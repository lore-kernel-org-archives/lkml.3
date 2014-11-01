Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaKAW5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:57:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60015 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171AbaKAWj1 (ORCPT
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
Message-ID: <lsq.1414880883.233833980@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 095/102] net: sctp: fix panic on duplicate ASCONF chunks
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

commit b69040d8e39f20d5215a03502a8e8b4c6ab78395 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/sctp/sctp.h | 5 +++++
 net/sctp/associola.c    | 2 ++
 2 files changed, 7 insertions(+)

--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -523,6 +523,11 @@ static inline void sctp_assoc_pending_pm
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
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1638,6 +1638,8 @@ struct sctp_chunk *sctp_assoc_lookup_asc
 	 * ack chunk whose serial number matches that of the request.
 	 */
 	list_for_each_entry(ack, &asoc->asconf_ack_list, transmitted_list) {
+		if (sctp_chunk_pending(ack))
+			continue;
 		if (ack->subh.addip_hdr->serial == serial) {
 			sctp_chunk_hold(ack);
 			return ack;

