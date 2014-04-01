Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaDAQQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:16:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44675 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaDAQQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:16:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bing Zhao <bzhao@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 34/86] mwifiex: do not advertise usb autosuspend support
Date: Tue,  1 Apr 2014 09:07:47 -0700
Message-Id: <1396368519-12728-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/mwifiex/usb.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index b96472c..6478366 100644
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
1.8.3.2

