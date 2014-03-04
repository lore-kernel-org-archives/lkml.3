Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaCDTaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:30:07 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:37818 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaCDT1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:27:47 -0500
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oliver Neukum <oneukum@suse.de>, Luigi Semenzato <semenzato@chromium.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH v2 2/2] usb: Make DELAY_INIT quirk wait 100ms between Get Configuration requests
Date: Tue,  4 Mar 2014 11:27:38 -0800
Message-Id: <1393961258-2885-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DELAY_INIT quirk only reduces the frequency of enumeration failures
with the Logitech HD Pro C920 and C930e webcams, but does not quite
eliminate them. We have found that adding a delay of 100ms between the
first and second Get Configuration request makes the device enumerate
perfectly reliable even after several weeks of extensive testing. The
reasons for that are anyone's guess, but since the DELAY_INIT quirk
already delays enumeration by a whole second, wating for another 10th of
that isn't really a big deal for the one other device that uses it, and
it will resolve the problems with these webcams.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/core/config.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 8d72f0c..062967c 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -717,6 +717,10 @@ int usb_get_configuration(struct usb_device *dev)
 			result = -ENOMEM;
 			goto err;
 		}
+
+		if (dev->quirks & USB_QUIRK_DELAY_INIT)
+			msleep(100);
+
 		result = usb_get_descriptor(dev, USB_DT_CONFIG, cfgno,
 		    bigbuffer, length);
 		if (result < 0) {
-- 
1.8.3.2

