Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696Ab3DKU6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:58:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935845Ab3DKUtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:25 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=YPEA9Lx85B0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=4HaGtGEpPQoA:10 a=vGmHpr-PAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=FDBlm5GMVscA:10 a=MSl-tDqOz04A:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202559.785287607@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Parag Warudkar <parag.lkml@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 083/171 ] ath9k: avoid queueing hw check work when suspended
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0083-ath9k-avoid-queueing-hw-check-work-when-suspended.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

[ Upstream commit 7fc0357479eeff4ca808c4d8c09bc7631f576b8d ]

The following issue was reported.

WARNING: at net/mac80211/util.c:599 ieee80211_can_queue_work.isra.7+0x32/0x40 [mac80211]()
Hardware name: iMac12,1
queueing ieee80211 work while going to suspend
Pid: 0, comm: swapper/0 Tainted: PF          O 3.8.2-206.fc18.x86_64 #1
Call Trace: Mar 16 09:39:17 Parags-iMac kernel: [ 3993.642992]  <IRQ>
[<ffffffff8105e61f>] warn_slowpath_common+0x7f/0xc0
[<ffffffffa0581420>] ? ath_start_rx_poll+0x70/0x70 [ath9k]
<ffffffff8105e716>] warn_slowpath_fmt+0x46/0x50
[<ffffffffa045b542>] ieee80211_can_queue_work.isra.7+0x32/0x40

Fix this by avoiding to queue the work if our device has
already been marked as suspended or stopped.

Reported-by: Parag Warudkar <parag.lkml@gmail.com>
Tested-by: Parag Warudkar <parag.lkml@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/ath/ath9k/link.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 62b58ba..b99514f 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -173,7 +173,8 @@ void ath_rx_poll(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
 
-	ieee80211_queue_work(sc->hw, &sc->hw_check_work);
+	if (!test_bit(SC_OP_INVALID, &sc->sc_flags))
+		ieee80211_queue_work(sc->hw, &sc->hw_check_work);
 }
 
 /*
-- 
1.7.10.4


