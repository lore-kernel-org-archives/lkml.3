Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaFVHaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 03:30:18 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:40483 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaFVHaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 03:30:17 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, alan@linux.intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH] staging: goldfish: fix direct copy_to_user() from __iomem
Date: Sun, 22 Jun 2014 03:29:38 -0400
Message-Id: <1403422178-20833-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allocates a few pages and performs an ioread8_rep() from the bus
address, which are then copied to userspace.  This fixes the sparse warning:

drivers/staging/goldfish/goldfish_audio.c:136:43: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/goldfish/goldfish_audio.c:136:43:    expected void const *from
drivers/staging/goldfish/goldfish_audio.c:136:43:    got char [noderef] <asn:2>*read_buffer

which was a result of performing a copy_to_user() directly from the bus address
to the userspace, which can be unsafe across some architectures.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/goldfish/goldfish_audio.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index a166424..535ed20 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -118,10 +118,17 @@ static ssize_t goldfish_audio_read(struct file *fp, char __user *buf,
 	struct goldfish_audio *data = fp->private_data;
 	int length;
 	int result = 0;
+	unsigned int order;
+	void *read_buffer;
 
 	if (!data->read_supported)
 		return -ENODEV;
 
+	order = get_order(READ_BUFFER_SIZE);
+	read_buffer = (void *)__get_free_pages(GFP_KERNEL, order);
+	if (!read_buffer)
+		return -ENOMEM;
+
 	while (count > 0) {
 		length = (count > READ_BUFFER_SIZE ? READ_BUFFER_SIZE : count);
 		AUDIO_WRITE(data, AUDIO_START_READ, length);
@@ -129,17 +136,21 @@ static ssize_t goldfish_audio_read(struct file *fp, char __user *buf,
 		wait_event_interruptible(data->wait,
 			(data->buffer_status & AUDIO_INT_READ_BUFFER_FULL));
 
-		length = AUDIO_READ(data,
-						AUDIO_READ_BUFFER_AVAILABLE);
+		length = AUDIO_READ(data, AUDIO_READ_BUFFER_AVAILABLE);
 
 		/* copy data to user space */
-		if (copy_to_user(buf, data->read_buffer, length))
-			return -EFAULT;
+		ioread8_rep(data->read_buffer, read_buffer, length);
+		if (copy_to_user(buf, read_buffer, length)) {
+			result = -EFAULT;
+			goto error;
+		}
 
 		result += length;
 		buf += length;
 		count -= length;
 	}
+error:
+	__free_pages(read_buffer, order);
 	return result;
 }
 
-- 
1.7.9.5

