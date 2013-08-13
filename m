Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab3HMVam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:30:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4147 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759319Ab3HMVak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:30:40 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=oBndWcvtRmYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=KOmSh42vtLoA:10 a=3FjqDcWCL-xfqGZUuVcA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813213038.928834078@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 17:02:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] [PATCH 1/3] module: Add flag to allow mod params to have no
 arguments
References: <20130813210228.989279359@goodmis.org>
Content-Disposition: inline; filename=0001-module-Add-flag-to-allow-mod-params-to-have-no-argum.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the params.c code allows only two "set" functions to have
no arguments. If a parameter does not have an argument, then it
looks at the set function and tests if it is either param_set_bool()
or param_set_bint(). If it is not one of these functions, then it
fails the loading of the module.

But there may be module parameters that have different set functions
and still allow no arguments. But unless each of these cases adds
their function to the if statement, it wont be allowed to have no
arguments. This method gets rather messing and does not scale.

Instead, introduce a flags field to the kernel_param_ops, where if
the flag KERNEL_PARAM_FL_NOARG is set, the parameter will not fail
if it does not contain an argument. It will be expected that the
corresponding set function can handle a NULL pointer as "val".

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/moduleparam.h |   13 ++++++++++++-
 kernel/params.c             |    6 ++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 27d9da3..c3eb102 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -36,7 +36,18 @@ static const char __UNIQUE_ID(name)[]					  \
 
 struct kernel_param;
 
+/*
+ * Flags available for kernel_param_ops
+ *
+ * NOARG - the parameter allows for no argument (foo instead of foo=1)
+ */
+enum {
+	KERNEL_PARAM_FL_NOARG = (1 << 0)
+};
+
 struct kernel_param_ops {
+	/* How the ops should behave */
+	unsigned int flags;
 	/* Returns 0, or -errno.  arg is in kp->arg. */
 	int (*set)(const char *val, const struct kernel_param *kp);
 	/* Returns length written or -errno.  Buffer is 4k (ie. be short!) */
@@ -187,7 +198,7 @@ struct kparam_array
 /* Obsolete - use module_param_cb() */
 #define module_param_call(name, set, get, arg, perm)			\
 	static struct kernel_param_ops __param_ops_##name =		\
-		 { (void *)set, (void *)get };				\
+		{ 0, (void *)set, (void *)get };			\
 	__module_param_call(MODULE_PARAM_PREFIX,			\
 			    name, &__param_ops_##name, arg,		\
 			    (perm) + sizeof(__check_old_set_param(set))*0, -1)
diff --git a/kernel/params.c b/kernel/params.c
index 440e65d..27a0af9 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -103,8 +103,8 @@ static int parse_one(char *param,
 			    || params[i].level > max_level)
 				return 0;
 			/* No one handled NULL, so do it here. */
-			if (!val && params[i].ops->set != param_set_bool
-			    && params[i].ops->set != param_set_bint)
+			if (!val &&
+			    !(params[i].ops->flags & KERNEL_PARAM_FL_NOARG))
 				return -EINVAL;
 			pr_debug("handling %s with %p\n", param,
 				params[i].ops->set);
@@ -320,6 +320,7 @@ int param_get_bool(char *buffer, const struct kernel_param *kp)
 EXPORT_SYMBOL(param_get_bool);
 
 struct kernel_param_ops param_ops_bool = {
+	.flags = KERNEL_PARAM_FL_NOARG,
 	.set = param_set_bool,
 	.get = param_get_bool,
 };
@@ -370,6 +371,7 @@ int param_set_bint(const char *val, const struct kernel_param *kp)
 EXPORT_SYMBOL(param_set_bint);
 
 struct kernel_param_ops param_ops_bint = {
+	.flags = KERNEL_PARAM_FL_NOARG,
 	.set = param_set_bint,
 	.get = param_get_int,
 };
-- 
1.7.10.4


