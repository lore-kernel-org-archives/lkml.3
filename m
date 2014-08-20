Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaHTTrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:47:06 -0400
Received: from ozlabs.org ([103.22.144.67]:58063 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbaHTTrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:47:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>
Subject: Re: [PATCH 0/4] module: add support for unsafe, tainting parameters
In-Reply-To: <CAKMK7uGrT6jvsetM2av26CBEgQBv4b9asAP9kGN_-WdtT1bdkQ@mail.gmail.com>
References: <cover.1407764272.git.jani.nikula@intel.com> <87wqac87dq.fsf@rustcorp.com.au> <CAKMK7uGrT6jvsetM2av26CBEgQBv4b9asAP9kGN_-WdtT1bdkQ@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 21 Aug 2014 01:42:26 +0930
Message-ID: <87ppfvi1hx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Vetter <daniel.vetter@ffwll.ch> writes:
> On Wed, Aug 13, 2014 at 10:25 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Jani Nikula <jani.nikula@intel.com> writes:
>>> This is a generic version of Daniel's patch [1] letting us have unsafe
>>> module parameters (experimental, debugging, testing, etc.) that taint
>>> the kernel when set. Quoting Daniel,
>>
>> OK, I think the idea is fine, but we'll probably only want this for
>> a few types (eg. int and bool).  So for the moment I prefer a more
>> naive approach.
>>
>> Does this work for you?
>
> Can you please discuss this with yourself from a few months back?
> We've done the general version since you suggested that just doing it
> for int is a bit lame ;-) And I actually agreed so asked Jani to look
> into that.

Don't listen to me, I'm an idiot!

Applied.

I've applied this cleanup on top, however.

Cheers,
Rusty.

Subject: param: check for tainting before calling set op.

This means every set op doesn't need to call it, and it can move into
params.c.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 9531f9f9729e..593501996574 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -374,22 +374,6 @@ static inline void destroy_params(const struct kernel_param *params,
 #define __param_check(name, p, type) \
 	static inline type __always_unused *__check_##name(void) { return(p); }
 
-/**
- * param_check_unsafe - Warn and taint the kernel if setting dangerous options.
- *
- * This gets called from all the standard param setters, but can be used from
- * custom setters as well.
- */
-static inline void
-param_check_unsafe(const struct kernel_param *kp)
-{
-	if (kp->flags & KERNEL_PARAM_FL_UNSAFE) {
-		pr_warn("Setting dangerous option %s - tainting kernel\n",
-			kp->name);
-		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
-	}
-}
-
 extern struct kernel_param_ops param_ops_byte;
 extern int param_set_byte(const char *val, const struct kernel_param *kp);
 extern int param_get_byte(char *buffer, const struct kernel_param *kp);
diff --git a/kernel/params.c b/kernel/params.c
index ad8d04563c3a..f3cc977d6a66 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -83,6 +83,15 @@ bool parameq(const char *a, const char *b)
 	return parameqn(a, b, strlen(a)+1);
 }
 
+static void param_check_unsafe(const struct kernel_param *kp)
+{
+	if (kp->flags & KERNEL_PARAM_FL_UNSAFE) {
+		pr_warn("Setting dangerous option %s - tainting kernel\n",
+			kp->name);
+		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+	}
+}
+
 static int parse_one(char *param,
 		     char *val,
 		     const char *doing,
@@ -109,6 +119,7 @@ static int parse_one(char *param,
 			pr_debug("handling %s with %p\n", param,
 				params[i].ops->set);
 			mutex_lock(&param_lock);
+			param_check_unsafe(&params[i]);
 			err = params[i].ops->set(val, &params[i]);
 			mutex_unlock(&param_lock);
 			return err;
@@ -233,7 +244,6 @@ char *parse_args(const char *doing,
 #define STANDARD_PARAM_DEF(name, type, format, strtolfn)      		\
 	int param_set_##name(const char *val, const struct kernel_param *kp) \
 	{								\
-		param_check_unsafe(kp);					\
 		return strtolfn(val, 0, (type *)kp->arg);		\
 	}								\
 	int param_get_##name(char *buffer, const struct kernel_param *kp) \
@@ -266,8 +276,6 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
 		return -ENOSPC;
 	}
 
-	param_check_unsafe(kp);
-
 	maybe_kfree_parameter(*(char **)kp->arg);
 
 	/* This is a hack.  We can't kmalloc in early boot, and we
@@ -305,8 +313,6 @@ EXPORT_SYMBOL(param_ops_charp);
 /* Actually could be a bool or an int, for historical reasons. */
 int param_set_bool(const char *val, const struct kernel_param *kp)
 {
-	param_check_unsafe(kp);
-
 	/* No equals means "set"... */
 	if (!val) val = "1";
 
@@ -336,8 +342,6 @@ int param_set_invbool(const char *val, const struct kernel_param *kp)
 	bool boolval;
 	struct kernel_param dummy;
 
-	param_check_unsafe(kp);
-
 	dummy.arg = &boolval;
 	ret = param_set_bool(val, &dummy);
 	if (ret == 0)
@@ -364,8 +368,6 @@ int param_set_bint(const char *val, const struct kernel_param *kp)
 	bool v;
 	int ret;
 
-	param_check_unsafe(kp);
-
 	/* Match bool exactly, by re-using it. */
 	boolkp = *kp;
 	boolkp.arg = &v;
@@ -485,8 +487,6 @@ int param_set_copystring(const char *val, const struct kernel_param *kp)
 {
 	const struct kparam_string *kps = kp->str;
 
-	param_check_unsafe(kp);
-
 	if (strlen(val)+1 > kps->maxlen) {
 		pr_err("%s: string doesn't fit in %u chars.\n",
 		       kp->name, kps->maxlen-1);
@@ -563,6 +563,7 @@ static ssize_t param_attr_store(struct module_attribute *mattr,
 		return -EPERM;
 
 	mutex_lock(&param_lock);
+	param_check_unsafe(attribute->param);
 	err = attribute->param->ops->set(buf, attribute->param);
 	mutex_unlock(&param_lock);
 	if (!err)
