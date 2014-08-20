Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaHTUAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:00:38 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41425 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaHTUAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:00:37 -0400
From: Arjun Sreedharan <arjun024@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] params: fix potential memory leak in add_sysfs_param()
Date: Thu, 21 Aug 2014 01:30:16 +0530
Message-Id: <1408564816-1778-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not leak memory when attrs is non NULL and
krealloc() fails. Without temporary variable,
reference to it is lost.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 kernel/params.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 34f5270..b69d683 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -594,7 +594,7 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
 				     const char *name)
 {
 	struct module_param_attrs *new;
-	struct attribute **attrs;
+	struct attribute **attrs, **new_attrs;
 	int err, num;
 
 	/* We don't bother calling this with invisible parameters. */
@@ -613,15 +613,12 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
 		       sizeof(*mk->mp) + sizeof(mk->mp->attrs[0]) * (num+1),
 		       GFP_KERNEL);
 	if (!new) {
-		kfree(attrs);
 		err = -ENOMEM;
 		goto fail;
 	}
-	/* Despite looking like the typical realloc() bug, this is safe.
-	 * We *want* the old 'attrs' to be freed either way, and we'll store
-	 * the new one in the success case. */
-	attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
-	if (!attrs) {
+
+	new_attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
+	if (!new_attrs) {
 		err = -ENOMEM;
 		goto fail_free_new;
 	}
@@ -629,9 +626,9 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
 	/* Sysfs wants everything zeroed. */
 	memset(new, 0, sizeof(*new));
 	memset(&new->attrs[num], 0, sizeof(new->attrs[num]));
-	memset(&attrs[num], 0, sizeof(attrs[num]));
+	memset(&new_attrs[num], 0, sizeof(new_attrs[num]));
 	new->grp.name = "parameters";
-	new->grp.attrs = attrs;
+	new->grp.attrs = new_attrs;
 
 	/* Tack new one on the end. */
 	sysfs_attr_init(&new->attrs[num].mattr.attr);
@@ -653,6 +650,7 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
 fail_free_new:
 	kfree(new);
 fail:
+	kfree(attrs);
 	mk->mp = NULL;
 	return err;
 }
-- 
1.8.1.msysgit.1

