Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902Ab3DBXVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:21:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab3DBWL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:11:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Parag Warudkar <parag.lkml@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 014/124] ath9k: avoid queueing hw check work when suspended
Date: Tue,  2 Apr 2013 15:09:56 -0700
Message-Id: <20130402221105.861465537@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

commit 7fc0357479eeff4ca808c4d8c09bc7631f576b8d upstream.

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
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/link.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -170,7 +170,8 @@ void ath_rx_poll(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
 
-	ieee80211_queue_work(sc->hw, &sc->hw_check_work);
+	if (!test_bit(SC_OP_INVALID, &sc->sc_flags))
+		ieee80211_queue_work(sc->hw, &sc->hw_check_work);
 }
 
 /*


