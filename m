Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3FXT6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:58:50 -0400
Received: from mail.ispras.ru ([83.149.199.45]:43176 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3FXT6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:58:48 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Huang Shijie <shijie8@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 2/2] [media] tlg2300: fix checking firmware in poseidon_probe()
Date: Mon, 24 Jun 2013 23:57:37 +0400
Message-Id: <1372103857-29451-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372103857-29451-1-git-send-email-khoroshilov@ispras.ru>
References: <1372103857-29451-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_firmware() makes sure firmware is in a device.
It returns zero on success and error code otherwise.
Also it sets down_firmware flag to 1 if downloading occurs.

The only caller poseidon_probe() checks down_firmware flag and
returns 0 without any initialization if it is set.

That looks very strange, so the patch removes down_firmware argument
of check_firmware() and returns error code if check_firmware() fails
in poseidon_probe().

Not tested on real hardware.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/tlg2300/pd-main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-main.c b/drivers/media/usb/tlg2300/pd-main.c
index ca5e1bc..95f94e5 100644
--- a/drivers/media/usb/tlg2300/pd-main.c
+++ b/drivers/media/usb/tlg2300/pd-main.c
@@ -375,7 +375,7 @@ static inline void set_map_flags(struct poseidon *pd, struct usb_device *udev)
 }
 #endif
 
-static int check_firmware(struct usb_device *udev, int *down_firmware)
+static int check_firmware(struct usb_device *udev)
 {
 	void *buf;
 	int ret;
@@ -395,10 +395,8 @@ static int check_firmware(struct usb_device *udev, int *down_firmware)
 			 USB_CTRL_GET_TIMEOUT);
 	kfree(buf);
 
-	if (ret < 0) {
-		*down_firmware = 1;
+	if (ret < 0)
 		return firmware_download(udev);
-	}
 	return 0;
 }
 
@@ -411,9 +409,9 @@ static int poseidon_probe(struct usb_interface *interface,
 	int new_one = 0;
 
 	/* download firmware */
-	check_firmware(udev, &ret);
+	ret = check_firmware(udev);
 	if (ret)
-		return 0;
+		return ret;
 
 	/* Do I recovery from the hibernate ? */
 	pd = find_old_poseidon(udev);
-- 
1.8.1.2

