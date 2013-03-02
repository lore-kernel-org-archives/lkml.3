Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3CBQJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 11:09:21 -0500
Received: from mail.active-venture.com ([67.228.131.205]:59421 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3CBQJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 11:09:20 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sat, 02 Mar 2013 10:09:20 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] i2o/i2o_config: Validate message size
Date: Sat,  2 Mar 2013 08:09:21 -0800
Message-Id: <1362240561-26167-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message size was already validated against inbound_frame_size, but that does
not guarantee that it is small enough for the buffer used to store a copy of it
on the stack.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
I am also not sure if the previous validation can be trusted, since the size
is read again from user space after the initial validation.

 drivers/message/i2o/i2o_config.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index 5451bef..aabaafc 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -922,6 +922,10 @@ static int i2o_cfg_passthru(unsigned long arg)
 		}
 		size = size >> 16;
 		size *= 4;
+		if (size > sizeof(rmsg)) {
+			rcode = -EFAULT;
+			goto sg_list_cleanup;
+		}
 		/* Copy in the user's I2O command */
 		if (copy_from_user(rmsg, user_msg, size)) {
 			rcode = -EFAULT;
-- 
1.7.9.7

