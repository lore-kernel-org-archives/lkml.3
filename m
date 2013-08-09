Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967782Ab3HICQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:16:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967528Ab3HIB6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 036/102] ath9k_htc: reboot firmware if it was loaded
Date: Thu,  8 Aug 2013 18:57:12 -0700
Message-Id: <20130809015018.345975043@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1289,7 +1289,9 @@ static void ath9k_hif_usb_disconnect(str
 
 	usb_set_intfdata(interface, NULL);
 
-	if (!unplugged && (hif_dev->flags & HIF_USB_START))
+	/* If firmware was loaded we should drop it
+	 * go back to first stage bootloader. */
+	if (!unplugged && (hif_dev->flags & HIF_USB_READY))
 		ath9k_hif_usb_reboot(udev);
 
 	kfree(hif_dev);


