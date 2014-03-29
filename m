Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaC2MQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 08:16:51 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57023 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaC2MQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 08:16:49 -0400
From: Elias Vanderstuyft <elias.vds@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: Elias Vanderstuyft <elias.vds@gmail.com>,
        Anssi Hannula <anssi.hannula@iki.fi>,
        =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] Input: don't modify the id of ioctl-provided ff effect on upload failure
Date: Sat, 29 Mar 2014 13:16:36 +0100
Message-Id: <1396095396-23551-1-git-send-email-elias.vds@gmail.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a new (id == -1) ff effect was uploaded from userspace,
ff-core.c::input_ff_upload() will have assigned
a positive number to the new effect id.
Currently, evdev.c::evdev_do_ioctl() will save this new id to userspace,
regardless of whether the upload succeeded or not.

On upload failure, this can be confusing because the dev->ff->effects[] array
will not contain an element at the index of that new effect id.

This patch fixes this by leaving the id unchanged after upload fails.

Note: Unfortunately applications should still expect changed effect id for
quite some time.

This has been discussed on:
http://www.mail-archive.com/linux-input@vger.kernel.org/msg08513.html
("ff-core effect id handling in case of a failed effect upload")

Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Elias Vanderstuyft <elias.vds@gmail.com>
Cc: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Michal Malý <madcatxster@devoid-pointer.net>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 v2:
  Only added one line to the commit message to say
  what this patch actually does,
  instead of only stating the reason why it's submitted.

 drivers/input/evdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index a06e125..ce953d8 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -954,11 +954,13 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 
 		error = input_ff_upload(dev, &effect, file);
+		if (error)
+			return error;
 
 		if (put_user(effect.id, &(((struct ff_effect __user *)p)->id)))
 			return -EFAULT;
 
-		return error;
+		return 0;
 	}
 
 	/* Multi-number variable-length handlers */
-- 
1.8.3.1

