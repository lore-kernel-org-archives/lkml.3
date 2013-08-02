Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3HBVps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:45:48 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:41650 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3HBVpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:45:47 -0400
From: Andreas Platschek <andi.platschek@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Andreas Platschek <andi.platschek@gmail.com>
Subject: [PATCH] driver-core: only call kfree() if memory was allocated
Date: Fri,  2 Aug 2013 23:43:50 +0200
Message-Id: <1375479830-8698-1-git-send-email-andi.platschek@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several cases where we could bail out of show_uevent()
before kzalloc() is even called. In those cases we don't want to
call kfree().

In addition the error handling of kzalloc() is now using the
single point of exit as well.

Signed-off-by: Andreas Platschek <andi.platschek@gmail.com>
---
 drivers/base/core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8856d74..bf4effb 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -372,8 +372,10 @@ static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
 			goto out;
 
 	env = kzalloc(sizeof(struct kobj_uevent_env), GFP_KERNEL);
-	if (!env)
-		return -ENOMEM;
+	if (!env) {
+		count = -ENOMEM;
+		goto out;
+	}
 
 	/* let the kset specific function add its keys */
 	retval = kset->uevent_ops->uevent(kset, &dev->kobj, env);
@@ -383,8 +385,9 @@ static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
 	/* copy keys to file */
 	for (i = 0; i < env->envp_idx; i++)
 		count += sprintf(&buf[count], "%s\n", env->envp[i]);
-out:
+out_free:
 	kfree(env);
+out:
 	return count;
 }
 
-- 
1.7.10.4

