Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3CAUWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:22:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3CATpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 16/77] b43: Fix lockdep splat on module unload
Date: Fri,  1 Mar 2013 11:44:01 -0800
Message-Id: <20130301194353.717100295@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/b43/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4214,7 +4214,6 @@ redo:
 	mutex_unlock(&wl->mutex);
 	cancel_delayed_work_sync(&dev->periodic_work);
 	cancel_work_sync(&wl->tx_work);
-	cancel_work_sync(&wl->firmware_load);
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
 	if (!dev || b43_status(dev) < B43_STAT_STARTED) {
@@ -5434,6 +5433,7 @@ static void b43_bcma_remove(struct bcma_
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
 	cancel_work_sync(&wldev->restart_work);
+	cancel_work_sync(&wl->firmware_load);
 
 	B43_WARN_ON(!wl);
 	if (!wldev->fw.ucode.data)
@@ -5510,6 +5510,7 @@ static void b43_ssb_remove(struct ssb_de
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
 	cancel_work_sync(&wldev->restart_work);
+	cancel_work_sync(&wl->firmware_load);
 
 	B43_WARN_ON(!wl);
 	if (!wldev->fw.ucode.data)


