Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbbAWMaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:30:00 -0500
Received: from mx02.posteo.de ([89.146.194.165]:55067 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbbAWM35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:29:57 -0500
From: Martin Kepplinger <martink@posteo.de>
To: dmitry.torokhov@gmail.com
Cc: khoroshilov@ispras.ru, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] input: (gtco) use sign_extend32() for sign extension
Date: Fri, 23 Jan 2015 13:29:36 +0100
Message-Id: <1422016176-6299-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
Despite it's name, sign_extend32() is safe to use for 8 and 16 bit types too.


 drivers/input/tablet/gtco.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index 8580456..272a838 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -59,7 +59,7 @@ Scott Hill shill@gtcocalcomp.com
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 #include <asm/byteorder.h>
-
+#include <linux/bitops.h>
 
 #include <linux/usb/input.h>
 
@@ -666,13 +666,8 @@ static void gtco_urb_callback(struct urb *urbinfo)
 		case 4:
 			/* Tilt */
 
-			/* Sign extend these 7 bit numbers.  */
-			if (device->buffer[6] & 0x40)
-				device->buffer[6] |= 0x80;
-
-			if (device->buffer[7] & 0x40)
-				device->buffer[7] |= 0x80;
-
+			device->buffer[6] = sign_extend32(device->buffer[6], 6);
+			device->buffer[7] = sign_extend32(device->buffer[7], 6);
 
 			valsigned = (device->buffer[6]);
 			input_report_abs(inputdev, ABS_TILT_X, (s32)valsigned);
-- 
2.1.4

