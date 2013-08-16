Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab3HPWv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:51:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51903 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab3HPWlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleksij Rempel <linux@rempel-privat.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 048/133] ath9k_htc: reboot firmware if it was loaded
Date: Fri, 16 Aug 2013 15:33:10 -0700
Message-Id: <1376692475-28413-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <linux@rempel-privat.de>

commit 4928bd2ef8ece262f4f314630219999a91eaa440 upstream.

Currently ath9k_htc will reboot firmware only if interface was
ever started. Which lead to the problem in case where interface
was never started but module need to be reloaded.

This patch will partially fix bug "ath9k_htc: Target is unresponsive"
https://github.com/qca/open-ath9k-htc-firmware/issues/1

Reproduction case:
- plug adapter
- make sure nothing will touch it. Stop Networkmanager or blacklist mac address of this adapter.
- rmmod ath9k_htc; sleep 1; modprobe ath9k_htc

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f5dda84..75a6376 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1289,7 +1289,9 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 
 	usb_set_intfdata(interface, NULL);
 
-	if (!unplugged && (hif_dev->flags & HIF_USB_START))
+	/* If firmware was loaded we should drop it
+	 * go back to first stage bootloader. */
+	if (!unplugged && (hif_dev->flags & HIF_USB_READY))
 		ath9k_hif_usb_reboot(udev);
 
 	kfree(hif_dev);
-- 
1.8.1.2

