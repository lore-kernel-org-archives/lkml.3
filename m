Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaBGMnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:43:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaBGLu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 118/233] b43legacy: Fix unload oops if firmware is not available
Date: Fri,  7 Feb 2014 11:45:37 +0000
Message-Id: <1391773652-25214-119-git-send-email-luis.henriques@canonical.com>
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

commit 452028665312672c6ba9e16a19248ee00ead9400 upstream.

The asyncronous firmware load uses a completion struct to hold firmware
processing until the user-space routines are up and running. There is.
however, a problem in that the waiter is nevered canceled during teardown.
As a result, unloading the driver when firmware is not available causes an oops.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/b43legacy/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 5726688..349c776 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3919,6 +3919,7 @@ static void b43legacy_remove(struct ssb_device *dev)
 	 * as the ieee80211 unreg will destroy the workqueue. */
 	cancel_work_sync(&wldev->restart_work);
 	cancel_work_sync(&wl->firmware_load);
+	complete(&wldev->fw_load_complete);
 
 	B43legacy_WARN_ON(!wl);
 	if (!wldev->fw.ucode)
-- 
1.8.3.2

