Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaKAW5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:57:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60023 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbaKAWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Borkmann" <dborkman@redhat.com>,
        "Vlad Yasevich" <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.729226889@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 096/102] net: sctp: fix remote memory pressure from
 excessive queueing
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit 26b87c7881006311828bb0ab271a551a62dcceb4 upstream.

This scenario is not limited to ASCONF, just taken as one
example triggering the issue. When receiving ASCONF probes
in the form of ...

  -------------- INIT[ASCONF; ASCONF_ACK] ------------->
  <----------- INIT-ACK[ASCONF; ASCONF_ACK] ------------
  -------------------- COOKIE-ECHO -------------------->
  <-------------------- COOKIE-ACK ---------------------
  ---- ASCONF_a; [ASCONF_b; ...; ASCONF_n;] JUNK ------>
  [...]
  ---- ASCONF_m; [ASCONF_o; ...; ASCONF_z;] JUNK ------>

... where ASCONF_a, ASCONF_b, ..., ASCONF_z are good-formed
ASCONFs and have increasing serial numbers, we process such
ASCONF chunk(s) marked with !end_of_packet and !singleton,
since we have not yet reached the SCTP packet end. SCTP does
only do verification on a chunk by chunk basis, as an SCTP
packet is nothing more than just a container of a stream of
chunks which it eats up one by one.

We could run into the case that we receive a packet with a
malformed tail, above marked as trailing JUNK. All previous
chunks are here goodformed, so the stack will eat up all
previous chunks up to this point. In case JUNK does not fit
into a chunk header and there are no more other chunks in
the input queue, or in case JUNK contains a garbage chunk
header, but the encoded chunk length would exceed the skb
tail, or we came here from an entirely different scenario
and the chunk has pdiscard=1 mark (without having had a flush
point), it will happen, that we will excessively queue up
the association's output queue (a correct final chunk may
then turn it into a response flood when flushing the
queue ;)): I ran a simple script with incremental ASCONF
serial numbers and could see the server side consuming
excessive amount of RAM [before/after: up to 2GB and more].

The issue at heart is that the chunk train basically ends
with !end_of_packet and !singleton markers and since commit
2e3216cd54b1 ("sctp: Follow security requirement of responding
with 1 packet") therefore preventing an output queue flush
point in sctp_do_sm() -> sctp_cmd_interpreter() on the input
chunk (chunk = event_arg) even though local_cork is set,
but its precedence has changed since then. In the normal
case, the last chunk with end_of_packet=1 would trigger the
queue flush to accommodate possible outgoing bundling.

In the input queue, sctp_inq_pop() seems to do the right thing
in terms of discarding invalid chunks. So, above JUNK will
not enter the state machine and instead be released and exit
the sctp_assoc_bh_rcv() chunk processing loop. It's simply
the flush point being missing at loop exit. Adding a try-flush
approach on the output queue might not work as the underlying
infrastructure might be long gone at this point due to the
side-effect interpreter run.

One possibility, albeit a bit of a kludge, would be to defer
invalid chunk freeing into the state machine in order to
possibly trigger packet discards and thus indirectly a queue
flush on error. It would surely be better to discard chunks
as in the current, perhaps better controlled environment, but
going back and forth, it's simply architecturally not possible.
I tried various trailing JUNK attack cases and it seems to
look good now.

Joint work with Vlad Yasevich.

Fixes: 2e3216cd54b1 ("sctp: Follow security requirement of responding with 1 packet")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/inqueue.c      | 33 +++++++--------------------------
 net/sctp/sm_statefuns.c |  3 +++
 2 files changed, 10 insertions(+), 26 deletions(-)

--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -152,18 +152,9 @@ struct sctp_chunk *sctp_inq_pop(struct s
 		} else {
 			/* Nothing to do. Next chunk in the packet, please. */
 			ch = (sctp_chunkhdr_t *) chunk->chunk_end;
-
 			/* Force chunk->skb->data to chunk->chunk_end.  */
-			skb_pull(chunk->skb,
-				 chunk->chunk_end - chunk->skb->data);
-
-			/* Verify that we have at least chunk headers
-			 * worth of buffer left.
-			 */
-			if (skb_headlen(chunk->skb) < sizeof(sctp_chunkhdr_t)) {
-				sctp_chunk_free(chunk);
-				chunk = queue->in_progress = NULL;
-			}
+			skb_pull(chunk->skb, chunk->chunk_end - chunk->skb->data);
+			/* We are guaranteed to pull a SCTP header. */
 		}
 	}
 
@@ -199,24 +190,14 @@ struct sctp_chunk *sctp_inq_pop(struct s
 	skb_pull(chunk->skb, sizeof(sctp_chunkhdr_t));
 	chunk->subh.v = NULL; /* Subheader is no longer valid.  */
 
-	if (chunk->chunk_end < skb_tail_pointer(chunk->skb)) {
+	if (chunk->chunk_end + sizeof(sctp_chunkhdr_t) <
+	    skb_tail_pointer(chunk->skb)) {
 		/* This is not a singleton */
 		chunk->singleton = 0;
 	} else if (chunk->chunk_end > skb_tail_pointer(chunk->skb)) {
-		/* RFC 2960, Section 6.10  Bundling
-		 *
-		 * Partial chunks MUST NOT be placed in an SCTP packet.
-		 * If the receiver detects a partial chunk, it MUST drop
-		 * the chunk.
-		 *
-		 * Since the end of the chunk is past the end of our buffer
-		 * (which contains the whole packet, we can freely discard
-		 * the whole packet.
-		 */
-		sctp_chunk_free(chunk);
-		chunk = queue->in_progress = NULL;
-
-		return NULL;
+		/* Discard inside state machine. */
+		chunk->pdiscard = 1;
+		chunk->chunk_end = skb_tail_pointer(chunk->skb);
 	} else {
 		/* We are at the end of the packet, so mark the chunk
 		 * in case we need to send a SACK.
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -163,6 +163,9 @@ sctp_chunk_length_valid(struct sctp_chun
 {
 	__u16 chunk_length = ntohs(chunk->chunk_hdr->length);
 
+	/* Previously already marked? */
+	if (unlikely(chunk->pdiscard))
+		return 0;
 	if (unlikely(chunk_length < required_length))
 		return 0;
 

