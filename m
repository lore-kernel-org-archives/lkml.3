Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaJFQQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:16:35 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46168 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaJFQQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:16:33 -0400
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=" 
	<info@are.ma>
X-Google-Original-From: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
        mchehab@osg.samsung.com, hdegoede@redhat.com,
        laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
        sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
        peter.senna@gmail.com
Subject: [PATCH 1/1] dvbdev: add dvb_register_subdev() & dvb_unregister_subdev()
Date: Tue,  7 Oct 2014 01:16:28 +0900
Message-Id: <8871458fe6b20b802f045f0070d33e4a9be1e6cc.1412612011.git.knightrider@are.ma>
X-Mailer: git-send-email 1.8.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taken from https://github.com/knight-rider/ptx/tree/master/pt3_dvb,
these routines simplify I2C binding of subdevices.

Applicable at least to the followings:
drivers/media/pci/bt8xx/bttv-input.c
drivers/media/pci/cx23885/cx23885-dvb.c
drivers/media/pci/cx23885/cx23885-i2c.c
drivers/media/pci/cx23885/cx23885.h
drivers/media/pci/cx25821/cx25821-i2c.c
drivers/media/pci/cx25821/cx25821.h
drivers/media/pci/cx88/cx88-input.c
drivers/media/pci/cx88/cx88-video.c
drivers/media/pci/pt3/pt3.c
drivers/media/pci/saa7134/saa7134-i2c.c
drivers/media/pci/saa7134/saa7134-input.c
drivers/media/pci/saa7134/saa7134.h
drivers/media/pci/saa7164/saa7164-i2c.c
drivers/media/pci/saa7164/saa7164.h
drivers/media/usb/au0828/au0828-i2c.c
drivers/media/usb/au0828/au0828.h
drivers/media/usb/cx231xx/cx231xx-dvb.c
drivers/media/usb/cx231xx/cx231xx-i2c.c
drivers/media/usb/cx231xx/cx231xx-input.c
drivers/media/usb/cx231xx/cx231xx.h
drivers/media/usb/dvb-usb-v2/af9035.c
drivers/media/usb/dvb-usb-v2/anysee.c
drivers/media/usb/dvb-usb-v2/dvbsky.c
drivers/media/usb/dvb-usb-v2/rtl28xxu.c
drivers/media/usb/dvb-usb/cxusb.c
drivers/media/usb/em28xx/em28xx-cards.c
drivers/media/usb/em28xx/em28xx-dvb.c
drivers/media/usb/em28xx/em28xx-i2c.c
drivers/media/usb/em28xx/em28xx.h
drivers/media/usb/go7007/s2250-board.c
drivers/media/usb/hdpvr/hdpvr-i2c.c
drivers/media/usb/stk1160/stk1160-i2c.c
drivers/media/usb/stk1160/stk1160.h
drivers/media/usb/tm6000/tm6000-cards.c
drivers/media/usb/tm6000/tm6000-i2c.c
drivers/media/usb/tm6000/tm6000.h
drivers/media/usb/usbvision/usbvision-i2c.c
drivers/media/usb/usbvision/usbvision-video.c
drivers/media/usb/usbvision/usbvision.h

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/dvb-core/dvbdev.c | 24 ++++++++++++++++++++++++
 drivers/media/dvb-core/dvbdev.h |  3 +++
 2 files changed, 27 insertions(+)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 983db75..f449543 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -284,6 +284,30 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 }
 EXPORT_SYMBOL(dvb_unregister_device);
 
+struct i2c_client *dvb_register_subdev(struct i2c_adapter *adap, struct i2c_board_info const *info)
+{
+	struct i2c_client *clt;
+
+	request_module("%s", info->type);
+	clt = i2c_new_device(adap, info);
+	if (clt && clt->dev.driver)
+		if (!try_module_get(clt->dev.driver->owner)) {
+			i2c_unregister_device(clt);
+			clt = NULL;
+		}
+	return clt;
+}
+EXPORT_SYMBOL(dvb_register_subdev);
+
+void dvb_unregister_subdev(struct i2c_client *clt)
+{
+	if (clt) {
+		module_put(clt->dev.driver->owner);
+		i2c_unregister_device(clt);
+	}
+}
+EXPORT_SYMBOL(dvb_unregister_subdev);
+
 static int dvbdev_check_free_adapter_num(int num)
 {
 	struct list_head *entry;
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index f96b28e..cff2296 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -109,6 +109,9 @@ extern int dvb_register_device (struct dvb_adapter *adap,
 
 extern void dvb_unregister_device (struct dvb_device *dvbdev);
 
+extern struct i2c_client *dvb_register_subdev(struct i2c_adapter *adap, struct i2c_board_info const *info);
+extern void dvb_unregister_subdev(struct i2c_client *clt);
+
 extern int dvb_generic_open (struct inode *inode, struct file *file);
 extern int dvb_generic_release (struct inode *inode, struct file *file);
 extern long dvb_generic_ioctl (struct file *file,
-- 
1.8.4.5

