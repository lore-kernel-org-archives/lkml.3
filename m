Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaAaWaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:30:09 -0500
Received: from mail.ispras.ru ([83.149.199.45]:59813 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbaAaWaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:30:07 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] messages: i2o: fix deadlock in compat_ioctl(I2OGETIOPS)
Date: Sat,  1 Feb 2014 02:29:48 +0400
Message-Id: <1391207388-7691-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2o_cfg_compat_ioctl(I2OGETIOPS) locks i2o_cfg_mutex and then calls
i2o_cfg_ioctl(I2OGETIOPS) that locks i2o_cfg_mutex as well.
A deadlock is guaranteed.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/message/i2o/i2o_config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index a60c188c2bd9..04bd3b6de401 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -754,19 +754,19 @@ static long i2o_cfg_compat_ioctl(struct file *file, unsigned cmd,
 				 unsigned long arg)
 {
 	int ret;
-	mutex_lock(&i2o_cfg_mutex);
 	switch (cmd) {
 	case I2OGETIOPS:
 		ret = i2o_cfg_ioctl(file, cmd, arg);
 		break;
 	case I2OPASSTHRU32:
+		mutex_lock(&i2o_cfg_mutex);
 		ret = i2o_cfg_passthru32(file, cmd, arg);
+		mutex_unlock(&i2o_cfg_mutex);
 		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
 	}
-	mutex_unlock(&i2o_cfg_mutex);
 	return ret;
 }
 
-- 
1.8.3.2

