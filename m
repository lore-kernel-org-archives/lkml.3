Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab3FXT55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:57:57 -0400
Received: from mail.ispras.ru ([83.149.199.45]:43165 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3FXT5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:57:55 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Huang Shijie <shijie8@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 1/2] [media] tlg2300: implement error handling in poseidon_probe()
Date: Mon, 24 Jun 2013 23:57:36 +0400
Message-Id: <1372103857-29451-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All poseidon init functions properly return error codes,
but they are ignored by poseidon_probe(). The patch implements
handling of error cases.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/tlg2300/pd-main.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-main.c b/drivers/media/usb/tlg2300/pd-main.c
index e07e4c6..ca5e1bc 100644
--- a/drivers/media/usb/tlg2300/pd-main.c
+++ b/drivers/media/usb/tlg2300/pd-main.c
@@ -436,12 +436,22 @@ static int poseidon_probe(struct usb_interface *interface,
 
 		/* register v4l2 device */
 		ret = v4l2_device_register(&interface->dev, &pd->v4l2_dev);
+		if (ret)
+			goto err_v4l2;
 
 		/* register devices in directory /dev */
 		ret = pd_video_init(pd);
-		poseidon_audio_init(pd);
-		poseidon_fm_init(pd);
-		pd_dvb_usb_device_init(pd);
+		if (ret)
+			goto err_video;
+		ret = poseidon_audio_init(pd);
+		if (ret)
+			goto err_audio;
+		ret = poseidon_fm_init(pd);
+		if (ret)
+			goto err_fm;
+		ret = pd_dvb_usb_device_init(pd);
+		if (ret)
+			goto err_dvb;
 
 		INIT_LIST_HEAD(&pd->device_list);
 		list_add_tail(&pd->device_list, &pd_device_list);
@@ -459,6 +469,17 @@ static int poseidon_probe(struct usb_interface *interface,
 	}
 #endif
 	return 0;
+err_dvb:
+	poseidon_fm_exit(pd);
+err_fm:
+	poseidon_audio_free(pd);
+err_audio:
+	pd_video_exit(pd);
+err_video:
+	v4l2_device_unregister(&pd->v4l2_dev);
+err_v4l2:
+	kfree(pd);
+	return ret;
 }
 
 static void poseidon_disconnect(struct usb_interface *interface)
-- 
1.8.1.2

