Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaBGMo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:44:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41945 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392AbaBGLu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 116/233] b43: Fix lockdep splat
Date: Fri,  7 Feb 2014 11:45:35 +0000
Message-Id: <1391773652-25214-117-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/b43/main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 0e933bb..bccc6ca 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2424,6 +2424,7 @@ error:
 
 static int b43_one_core_attach(struct b43_bus_dev *dev, struct b43_wl *wl);
 static void b43_one_core_detach(struct b43_bus_dev *dev);
+static int b43_rng_init(struct b43_wl *wl);
 
 static void b43_request_firmware(struct work_struct *work)
 {
@@ -2475,6 +2476,10 @@ start_ieee80211:
 		goto err_one_core_detach;
 	wl->hw_registred = true;
 	b43_leds_register(wl->current_dev);
+
+	/* Register HW RNG driver */
+	b43_rng_init(wl);
+
 	goto out;
 
 err_one_core_detach:
@@ -4636,9 +4641,6 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 	if (!dev || b43_status(dev) != B43_STAT_INITIALIZED)
 		return;
 
-	/* Unregister HW RNG driver */
-	b43_rng_exit(dev->wl);
-
 	b43_set_status(dev, B43_STAT_UNINIT);
 
 	/* Stop the microcode PSM. */
@@ -4781,9 +4783,6 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
-	/* Register HW RNG driver */
-	b43_rng_init(dev->wl);
-
 out:
 	return err;
 
@@ -5450,6 +5449,9 @@ static void b43_bcma_remove(struct bcma_device *core)
 
 	b43_one_core_detach(wldev->dev);
 
+	/* Unregister HW RNG driver */
+	b43_rng_exit(wl);
+
 	b43_leds_unregister(wl);
 
 	ieee80211_free_hw(wl->hw);
@@ -5527,6 +5529,9 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 
 	b43_one_core_detach(dev);
 
+	/* Unregister HW RNG driver */
+	b43_rng_exit(wl);
+
 	if (list_empty(&wl->devlist)) {
 		b43_leds_unregister(wl);
 		/* Last core on the chip unregistered.
-- 
1.8.3.2

