Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3AXDcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:32:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44426 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab3AXDbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:31 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 62/74] udldrmfb: udl_get_edid: usb_control_msg buffer must not be on the stack
Date: Thu, 24 Jan 2013 01:27:14 -0200
Message-Id: <1358998046-613-63-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 242187b362555849e8c971dfbbfd55f8bd9fa717 upstream.

The buffer passed to usb_control_msg may end up in scatter-gather list, and
may thus not be on the stack. Having it on the stack usually works on x86, but
not on other archs.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/udl/udl_connector.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/udl/udl_connector.c b/drivers/gpu/drm/udl/udl_connector.c
index 1230bc0..b7780dd 100644
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
@@ -42,10 +46,12 @@ static u8 *udl_get_edid(struct udl_device *udl)
 		block[i] = rbuf[1];
 	}
 
+	kfree(rbuf);
 	return block;
 
 error:
 	kfree(block);
+	kfree(rbuf);
 	return NULL;
 }
 
-- 
1.7.9.5

