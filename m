Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaHaQQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 12:16:35 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57761 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaHaQQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 12:16:34 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: goldfish_audio.c: sparse warning of incorrect type
Date: Sun, 31 Aug 2014 21:46:22 +0530
Message-Id: <1409501782-20775-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning of incorrect type in argument 1 and incorrect type in argument 2
it was directly dereferencing a __iomem pointer , which will work in x86 but will fail in other architectures.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

hi,
can you please reveiew the patch and check if the approach is correct. If it is correct then I can send another patch to correct the other similar warnings present in this file. 

 drivers/staging/goldfish/goldfish_audio.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index c89d0b8..f9a13e7 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -118,6 +118,7 @@ static ssize_t goldfish_audio_read(struct file *fp, char __user *buf,
 	struct goldfish_audio *data = fp->private_data;
 	int length;
 	int result = 0;
+	void *buffer;
 
 	if (!data->read_supported)
 		return -ENODEV;
@@ -133,9 +134,15 @@ static ssize_t goldfish_audio_read(struct file *fp, char __user *buf,
 						AUDIO_READ_BUFFER_AVAILABLE);
 
 		/* copy data to user space */
-		if (copy_to_user(buf, data->read_buffer, length))
+		buffer = kzalloc(length, GFP_KERNEL);
+		if (buffer == NULL)
+			return -ENOMEM;
+		memcpy_fromio(buffer, data->read_buffer, length);
+		if (copy_to_user((void __user *)buf, buffer, length)) {
+			kfree(buffer);
 			return -EFAULT;
-
+		}
+		kfree(buffer);
 		result += length;
 		buf += length;
 		count -= length;
-- 
1.8.1.2

