Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab3APAMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:12:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:42843 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758455Ab3AOWce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hans de Goede <hdegoede@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 133/221] udldrmfb: udl_get_edid: usb_control_msg buffer must not be on the stack
Date: Tue, 15 Jan 2013 10:51:00 -0800
Message-Id: <20130115185007.640355261@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 242187b362555849e8c971dfbbfd55f8bd9fa717 upstream.

The buffer passed to usb_control_msg may end up in scatter-gather list, and
may thus not be on the stack. Having it on the stack usually works on x86, but
not on other archs.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/udl/udl_connector.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -22,13 +22,17 @@
 static u8 *udl_get_edid(struct udl_device *udl)
 {
 	u8 *block;
-	char rbuf[3];
+	char *rbuf;
 	int ret, i;
 
 	block = kmalloc(EDID_LENGTH, GFP_KERNEL);
 	if (block == NULL)
 		return NULL;
 
+	rbuf = kmalloc(2, GFP_KERNEL);
+	if (rbuf == NULL)
+		goto error;
+
 	for (i = 0; i < EDID_LENGTH; i++) {
 		ret = usb_control_msg(udl->ddev->usbdev,
 				      usb_rcvctrlpipe(udl->ddev->usbdev, 0), (0x02),
@@ -42,10 +46,12 @@ static u8 *udl_get_edid(struct udl_devic
 		block[i] = rbuf[1];
 	}
 
+	kfree(rbuf);
 	return block;
 
 error:
 	kfree(block);
+	kfree(rbuf);
 	return NULL;
 }
 


