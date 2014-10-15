Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaJOTAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:00:33 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:19660 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbaJOTAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:00:32 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcNAIzDPlRbtBXi/2dsb2JhbABbgw6BK7guBQFzmimBGBcBfYQwLyOBGjeIQgG1QoQdjxsshiKKLB2ENQWdVJYagUcBgjE7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] HCI: remove comparisons on shdlc boolean members.
Date: Wed, 15 Oct 2014 21:00:24 +0200
Message-Id: <1413399624-8128-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes coccinelles warnings:
net/nfc/hci/llc_shdlc.c:539:7-17: WARNING: Comparison to bool
net/nfc/hci/llc_shdlc.c:544:9-19: WARNING: Comparison to bool
net/nfc/hci/llc_shdlc.c:574:6-22: WARNING: Comparison to bool
net/nfc/hci/llc_shdlc.c:250:5-21: WARNING: Comparison to bool
net/nfc/hci/llc_shdlc.c:333:6-16: WARNING: Comparison to bool
net/nfc/hci/llc_shdlc.c:431:31-43: WARNING: Comparison to bool

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/nfc/hci/llc_shdlc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
index 401c7e2..76e6fa2 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -247,7 +247,7 @@ static void llc_shdlc_rcv_i_frame(struct llc_shdlc *shdlc,
 		goto exit;
 	}
 
-	if (shdlc->t1_active == false) {
+	if (!shdlc->t1_active) {
 		shdlc->t1_active = true;
 		mod_timer(&shdlc->t1_timer, jiffies +
 			  msecs_to_jiffies(SHDLC_T1_VALUE_MS(shdlc->w)));
@@ -330,7 +330,7 @@ static void llc_shdlc_rcv_s_frame(struct llc_shdlc *shdlc,
 	switch (s_frame_type) {
 	case S_FRAME_RR:
 		llc_shdlc_rcv_ack(shdlc, nr);
-		if (shdlc->rnr == true) {	/* see SHDLC 10.7.7 */
+		if (shdlc->rnr) {	/* see SHDLC 10.7.7 */
 			shdlc->rnr = false;
 			if (shdlc->send_q.qlen == 0) {
 				skb = llc_shdlc_alloc_skb(shdlc, 0);
@@ -428,7 +428,7 @@ static void llc_shdlc_rcv_u_frame(struct llc_shdlc *shdlc,
 					       false;
 
 			if ((w <= SHDLC_MAX_WINDOW) &&
-			    (SHDLC_SREJ_SUPPORT || (srej_support == false))) {
+			    (SHDLC_SREJ_SUPPORT || (!srej_support))) {
 				shdlc->w = w;
 				shdlc->srej_support = srej_support;
 				r = llc_shdlc_connect_send_ua(shdlc);
@@ -536,12 +536,12 @@ static void llc_shdlc_handle_send_queue(struct llc_shdlc *shdlc)
 		pr_debug
 		    ("sendQlen=%d ns=%d dnr=%d rnr=%s w_room=%d unackQlen=%d\n",
 		     shdlc->send_q.qlen, shdlc->ns, shdlc->dnr,
-		     shdlc->rnr == false ? "false" : "true",
+		     !shdlc->rnr ? "false" : "true",
 		     shdlc->w - llc_shdlc_w_used(shdlc->ns, shdlc->dnr),
 		     shdlc->ack_pending_q.qlen);
 
 	while (shdlc->send_q.qlen && shdlc->ack_pending_q.qlen < shdlc->w &&
-	       (shdlc->rnr == false)) {
+	       (!shdlc->rnr)) {
 
 		if (shdlc->t1_active) {
 			del_timer_sync(&shdlc->t1_timer);
@@ -571,7 +571,7 @@ static void llc_shdlc_handle_send_queue(struct llc_shdlc *shdlc)
 
 		skb_queue_tail(&shdlc->ack_pending_q, skb);
 
-		if (shdlc->t2_active == false) {
+		if (!shdlc->t2_active) {
 			shdlc->t2_active = true;
 			mod_timer(&shdlc->t2_timer, time_sent +
 				  msecs_to_jiffies(SHDLC_T2_VALUE_MS));
-- 
1.9.3

