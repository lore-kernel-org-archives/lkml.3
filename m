Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaBJUOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:14:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34649 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaBJTmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:42:51 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 055/124] b43: Fix lockdep splat
Date: Mon, 10 Feb 2014 11:39:55 -0800
Message-Id: <1392061264-28124-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 09164043f63c947a49797750a09ca1cd7c31108e upstream.

In https://bugzilla.kernel.org/show_bug.cgi?id=67561, a locking dependency is reported
when b43 is used with hostapd, and rfkill is used to kill the radio output.

The lockdep splat (in part) is as follows:

======================================================
[ INFO: possible circular locking dependency detected ]
3.12.0 #1 Not tainted
-------------------------------------------------------
rfkill/10040 is trying to acquire lock:
 (rtnl_mutex){+.+.+.}, at: [<ffffffff8146f282>] rtnl_lock+0x12/0x20

but task is already holding lock:
 (rfkill_global_mutex){+.+.+.}, at: [<ffffffffa04832ca>] rfkill_fop_write+0x6a/0x170 [rfkill]

--snip--

Chain exists of:
  rtnl_mutex --> misc_mtx --> rfkill_global_mutex

The fix is to move the initialization of the hardware random number generator
outside the code range covered by the rtnl_mutex.

Reported-by: yury <urykhy@gmail.com>
Tested-by: yury <urykhy@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/b43/main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 911c4c0..bb421be 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2415,6 +2415,7 @@ error:
 
 static int b43_one_core_attach(struct b43_bus_dev *dev, struct b43_wl *wl);
 static void b43_one_core_detach(struct b43_bus_dev *dev);
+static int b43_rng_init(struct b43_wl *wl);
 
 static void b43_request_firmware(struct work_struct *work)
 {
@@ -2466,6 +2467,10 @@ start_ieee80211:
 		goto err_one_core_detach;
 	wl->hw_registred = true;
 	b43_leds_register(wl->current_dev);
+
+	/* Register HW RNG driver */
+	b43_rng_init(wl);
+
 	goto out;
 
 err_one_core_detach:
@@ -4630,9 +4635,6 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 	if (!dev || b43_status(dev) != B43_STAT_INITIALIZED)
 		return;
 
-	/* Unregister HW RNG driver */
-	b43_rng_exit(dev->wl);
-
 	b43_set_status(dev, B43_STAT_UNINIT);
 
 	/* Stop the microcode PSM. */
@@ -4775,9 +4777,6 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
-	/* Register HW RNG driver */
-	b43_rng_init(dev->wl);
-
 out:
 	return err;
 
@@ -5438,6 +5437,9 @@ static void b43_bcma_remove(struct bcma_device *core)
 
 	b43_one_core_detach(wldev->dev);
 
+	/* Unregister HW RNG driver */
+	b43_rng_exit(wl);
+
 	b43_leds_unregister(wl);
 
 	ieee80211_free_hw(wl->hw);
@@ -5515,6 +5517,9 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 
 	b43_one_core_detach(dev);
 
+	/* Unregister HW RNG driver */
+	b43_rng_exit(wl);
+
 	if (list_empty(&wl->devlist)) {
 		b43_leds_unregister(wl);
 		/* Last core on the chip unregistered.
-- 
1.8.3.2

