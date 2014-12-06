Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaLFR5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:57:25 -0500
Received: from 1wt.eu ([62.212.114.60]:40758 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbaLFRzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:55:15 -0500
Message-Id: <20141206174149.293297306@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:42:08 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>, Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>,
        Andy Whitcroft <andy.whitcroft@canonical.com>,
        Brad Figg <brad.figg@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 20/25] net: sctp: fix panic on duplicate ASCONF chunks
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit 12b18fdbbda747ad22a7684413a6559b681e503c upstream

When receiving a e.g. semi-good formed connection scan in the
form of ...

  -------------- INIT[ASCONF; ASCONF_ACK] ------------->
  <----------- INIT-ACK[ASCONF; ASCONF_ACK] ------------
  -------------------- COOKIE-ECHO -------------------->
  <-------------------- COOKIE-ACK ---------------------
  ---------------- ASCONF_a; ASCONF_b ----------------->

... where ASCONF_a equals ASCONF_b chunk (at least both serials
need to be equal), we panic an SCTP server!

The problem is that good-formed ASCONF chunks that we reply with
ASCONF_ACK chunks are cached per serial. Thus, when we receive a
same ASCONF chunk twice (e.g. through a lost ASCONF_ACK), we do
not need to process them again on the server side (that was the
idea, also proposed in the RFC). Instead, we know it was cached
and we just resend the cached chunk instead. So far, so good.

Where things get nasty is in SCTP's side effect interpreter, that
is, sctp_cmd_interpreter():

While incoming ASCONF_a (chunk = event_arg) is being marked
!end_of_packet and !singleton, and we have an association context,
we do not flush the outqueue the first time after processing the
ASCONF_ACK singleton chunk via SCTP_CMD_REPLY. Instead, we keep it
queued up, although we set local_cork to 1. Commit 2e3216cd54b1
changed the precedence, so that as long as we get bundled, incoming
chunks we try possible bundling on outgoing queue as well. Before
this commit, we would just flush the output queue.

Now, while ASCONF_a's ASCONF_ACK sits in the corked outq, we
continue to process the same ASCONF_b chunk from the packet. As
we have cached the previous ASCONF_ACK, we find it, grab it and
do another SCTP_CMD_REPLY command on it. So, effectively, we rip
the chunk->list pointers and requeue the same ASCONF_ACK chunk
another time. Since we process ASCONF_b, it's correctly marked
with end_of_packet and we enforce an uncork, and thus flush, thus
crashing the kernel.

Fix it by testing if the ASCONF_ACK is currently pending and if
that is the case, do not requeue it. When flushing the output
queue we may relink the chunk for preparing an outgoing packet,
but eventually unlink it when it's copied into the skb right
before transmission.

Joint work with Vlad Yasevich.

Fixes: 2e3216cd54b1 ("sctp: Follow security requirement of responding with 1 packet")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit b69040d8e39f20d5215a03502a8e8b4c6ab78395)
CVE-2014-3687
BugLink: http://bugs.launchpad.net/bugs/1386392
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Acked-by: Andy Whitcroft <andy.whitcroft@canonical.com>
Signed-off-by: Brad Figg <brad.figg@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/net/sctp/sctp.h | 5 +++++
 net/sctp/associola.c    | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 8a6d529..ad5989a 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -509,6 +509,11 @@ static inline void sctp_assoc_pending_pmtu(struct sctp_association *asoc)
 	asoc->pmtu_pending = 0;
 }
 
+static inline bool sctp_chunk_pending(const struct sctp_chunk *chunk)
+{
+	return !list_empty(&chunk->list);
+}
+
 /* Walk through a list of TLV parameters.  Don't trust the
  * individual parameter lengths and instead depend on
  * the chunk length to indicate when to stop.  Make sure
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 12137d3..8802516 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1605,6 +1605,8 @@ struct sctp_chunk *sctp_assoc_lookup_asconf_ack(
 	 * ack chunk whose serial number matches that of the request.
 	 */
 	list_for_each_entry(ack, &asoc->asconf_ack_list, transmitted_list) {
+		if (sctp_chunk_pending(ack))
+			continue;
 		if (ack->subh.addip_hdr->serial == serial) {
 			sctp_chunk_hold(ack);
 			return ack;
-- 
1.7.12.2.21.g234cd45.dirty



