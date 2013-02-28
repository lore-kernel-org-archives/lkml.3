Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab3B1Ouq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:50:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42489 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950Ab3B1Oum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 117/139] b43: Fix lockdep splat on module unload
Date: Thu, 28 Feb 2013 14:44:27 +0000
Message-Id: <1362062689-2567-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 63a02ce1c5c59baa40b99756492e3ec8d6b51483 upstream.

On unload, b43 produces a lockdep warning that can be summarized in the
following way:

 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.8.0-wl+ #117 Not tainted
 -------------------------------------------------------
 modprobe/5557 is trying to acquire lock:
  ((&wl->firmware_load)){+.+.+.}, at: [<ffffffff81062160>] flush_work+0x0/0x2a0

 but task is already holding lock:
  (rtnl_mutex){+.+.+.}, at: [<ffffffff813bd7d2>] rtnl_lock+0x12/0x20

 which lock already depends on the new lock.
 [ INFO: possible circular locking dependency detected ]
 ======================================================

The full output is available at http://lkml.indiana.edu/hypermail/linux/kernel/1302.3/00060.html.
To summarize, commit 6b6fa58 added a 'cancel_work_sync(&wl->firmware_load)'
call in the wrong place.

The fix is to move the cancel_work_sync() call to b43_bcma_remove() and
b43_ssb_remove(). Thanks to Johannes Berg and Michael Buesch for help in
diagnosing the log output.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/b43/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 823943b..12603b8 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4208,7 +4208,6 @@ redo:
 	mutex_unlock(&wl->mutex);
 	cancel_delayed_work_sync(&dev->periodic_work);
 	cancel_work_sync(&wl->tx_work);
-	cancel_work_sync(&wl->firmware_load);
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
 	if (!dev || b43_status(dev) < B43_STAT_STARTED) {
@@ -5399,6 +5398,7 @@ static void b43_bcma_remove(struct bcma_device *core)
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
 	cancel_work_sync(&wldev->restart_work);
+	cancel_work_sync(&wl->firmware_load);
 
 	B43_WARN_ON(!wl);
 	if (!wldev->fw.ucode.data)
@@ -5475,6 +5475,7 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
 	cancel_work_sync(&wldev->restart_work);
+	cancel_work_sync(&wl->firmware_load);
 
 	B43_WARN_ON(!wl);
 	if (!wldev->fw.ucode.data)
-- 
1.8.1.2

