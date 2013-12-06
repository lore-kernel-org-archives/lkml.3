Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162827Ab3LFXwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:52:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48378 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759121Ab3LFXMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:35 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 017/152] rt2800usb: slow down TX status polling
Date: Fri,  6 Dec 2013 15:09:01 -0800
Message-Id: <1386371476-2477-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 36165fd5b00bf8163f89c21bb16a3e9834555b10 upstream.

Polling TX statuses too frequently has two negative effects. First is
randomly peek CPU usage, causing overall system functioning delays.
Second bad effect is that device is not able to fill TX statuses in
H/W register on some workloads and we get lot of timeouts like below:

ieee80211 phy4: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 7 in queue 2
ieee80211 phy4: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 7 in queue 2
ieee80211 phy4: rt2800usb_txdone: Warning - Got TX status for an empty queue 2, dropping

This not only cause flood of messages in dmesg, but also bad throughput,
since rate scaling algorithm can not work optimally.

In the future, we should probably make polling interval be adjusted
automatically, but for now just increase values, this make mentioned
problems gone.

Resolve:
https://bugzilla.kernel.org/show_bug.cgi?id=62781

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 5c149b5..926f1b0 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -148,6 +148,8 @@ static bool rt2800usb_txstatus_timeout(struct rt2x00_dev *rt2x00dev)
 	return false;
 }
 
+#define TXSTATUS_READ_INTERVAL 1000000
+
 static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 						 int urb_status, u32 tx_status)
 {
@@ -175,8 +177,9 @@ static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
 
 	if (rt2800usb_txstatus_pending(rt2x00dev)) {
-		/* Read register after 250 us */
-		hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 250000),
+		/* Read register after 1 ms */
+		hrtimer_start(&rt2x00dev->txstatus_timer,
+			      ktime_set(0, TXSTATUS_READ_INTERVAL),
 			      HRTIMER_MODE_REL);
 		return false;
 	}
@@ -201,8 +204,9 @@ static void rt2800usb_async_read_tx_status(struct rt2x00_dev *rt2x00dev)
 	if (test_and_set_bit(TX_STATUS_READING, &rt2x00dev->flags))
 		return;
 
-	/* Read TX_STA_FIFO register after 500 us */
-	hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 500000),
+	/* Read TX_STA_FIFO register after 2 ms */
+	hrtimer_start(&rt2x00dev->txstatus_timer,
+		      ktime_set(0, 2*TXSTATUS_READ_INTERVAL),
 		      HRTIMER_MODE_REL);
 }
 
-- 
1.8.3.2

