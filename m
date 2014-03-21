Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965931AbaCUAI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:08:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965867AbaCUAIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bing Zhao <bzhao@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 25/85] mwifiex: do not advertise usb autosuspend support
Date: Thu, 20 Mar 2014 17:09:28 -0700
Message-Id: <20140321000602.190148207@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/usb.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -511,13 +511,6 @@ static int mwifiex_usb_resume(struct usb
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
 
@@ -576,7 +569,6 @@ static struct usb_driver mwifiex_usb_dri
 	.id_table = mwifiex_usb_table,
 	.suspend = mwifiex_usb_suspend,
 	.resume = mwifiex_usb_resume,
-	.supports_autosuspend = 1,
 };
 
 static int mwifiex_usb_tx_init(struct mwifiex_adapter *adapter)


