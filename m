Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaDAMQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:16:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaDALQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bing Zhao <bzhao@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 024/144] mwifiex: do not advertise usb autosuspend support
Date: Tue,  1 Apr 2014 12:13:48 +0100
Message-Id: <1396350948-29910-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit adb07df1e039e9fe43e66aeea8b4771f83659dbb upstream.

As many Surface Pro I & II users have found out, the mwifiex_usb
doesn't support usb autosuspend, and it has caused some system
stability issues.

Bug 69661 - mwifiex_usb on MS Surface Pro 1 is unstable
Bug 60815 - Interface hangs in mwifiex_usb
Bug 64111 - mwifiex_usb USB8797 crash failed to get signal
 	    information

USB autosuspend get triggered when Surface Pro's AC power is
removed or powertop enables power saving on USB8797 device.
Driver's suspend handler is called here, but resume handler
won't be called until the AC power is put back on or powertop
disables power saving for USB8797.

We need to refactor the suspend/resume handlers to support
usb autosuspend properly. For now let's just remove it.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/usb.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index b7adf3d..923e348 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -511,13 +511,6 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 						   MWIFIEX_BSS_ROLE_ANY),
 				  MWIFIEX_ASYNC_CMD);
 
-#ifdef CONFIG_PM
-	/* Resume handler may be called due to remote wakeup,
-	 * force to exit suspend anyway
-	 */
-	usb_disable_autosuspend(card->udev);
-#endif /* CONFIG_PM */
-
 	return 0;
 }
 
@@ -576,7 +569,6 @@ static struct usb_driver mwifiex_usb_driver = {
 	.id_table = mwifiex_usb_table,
 	.suspend = mwifiex_usb_suspend,
 	.resume = mwifiex_usb_resume,
-	.supports_autosuspend = 1,
 };
 
 static int mwifiex_usb_tx_init(struct mwifiex_adapter *adapter)
-- 
1.9.1

