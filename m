Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3IKE7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3IKE5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:21 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=4lliHvy_dd8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qjHHzMx7v7oA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=gvl4HP8tAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=OTgC_HKJBnUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042915.750358015@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [141/251] Bluetooth: ath3k: dont use stack memory for DMA
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0141-Bluetooth-ath3k-don-t-use-stack-memory-for-DMA.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

[ Upstream commit 517828a87994f41af6ae5a0f96f0f069f05baa81 ]

Memory allocated by vmalloc (including stack) can not be used for DMA,
i.e. data pointer on usb_control_msg() should not point to stack memory.

Resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=977558

Reported-and-tested-by: Andy Lawrence <dr.diesel@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/bluetooth/ath3k.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index b0395b0..e224a48 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -176,24 +176,44 @@ error:
 
 static int ath3k_get_state(struct usb_device *udev, unsigned char *state)
 {
-	int pipe = 0;
+	int ret, pipe = 0;
+	char *buf;
+
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	pipe = usb_rcvctrlpipe(udev, 0);
-	return usb_control_msg(udev, pipe, ATH3K_GETSTATE,
-			USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
-			state, 0x01, USB_CTRL_SET_TIMEOUT);
+	ret = usb_control_msg(udev, pipe, ATH3K_GETSTATE,
+			      USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
+			      buf, sizeof(*buf), USB_CTRL_SET_TIMEOUT);
+
+	*state = *buf;
+	kfree(buf);
+
+	return ret;
 }
 
 static int ath3k_get_version(struct usb_device *udev,
 			struct ath3k_version *version)
 {
-	int pipe = 0;
+	int ret, pipe = 0;
+	struct ath3k_version *buf;
+	const int size = sizeof(*buf);
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	pipe = usb_rcvctrlpipe(udev, 0);
-	return usb_control_msg(udev, pipe, ATH3K_GETVERSION,
-			USB_TYPE_VENDOR | USB_DIR_IN, 0, 0, version,
-			sizeof(struct ath3k_version),
-			USB_CTRL_SET_TIMEOUT);
+	ret = usb_control_msg(udev, pipe, ATH3K_GETVERSION,
+			      USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
+			      buf, size, USB_CTRL_SET_TIMEOUT);
+
+	memcpy(version, buf, size);
+	kfree(buf);
+
+	return ret;
 }
 
 static int ath3k_load_fwfile(struct usb_device *udev,
-- 
1.7.10.4


