Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaHMUbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:31:49 -0400
Received: from ozlabs.org ([103.22.144.67]:45655 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbaHMUbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:31:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jani Nikula <jani.nikula@intel.com>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, jani.nikula@intel.com
Subject: Re: [PATCH 0/4] module: add support for unsafe, tainting parameters
In-Reply-To: <cover.1407764272.git.jani.nikula@intel.com>
References: <cover.1407764272.git.jani.nikula@intel.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 14 Aug 2014 05:55:05 +0930
Message-ID: <87wqac87dq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jani Nikula <jani.nikula@intel.com> writes:
> This is a generic version of Daniel's patch [1] letting us have unsafe
> module parameters (experimental, debugging, testing, etc.) that taint
> the kernel when set. Quoting Daniel,

OK, I think the idea is fine, but we'll probably only want this for
a few types (eg. int and bool).  So for the moment I prefer a more
naive approach.

Does this work for you?

Subject: module: add taint_int type

An int parameter which taints the kernel if set; i915 at least wants this.

Based-on-patches-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Based-on-patches-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 494f99e852da..99ba68206ba4 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -408,6 +408,10 @@ extern int param_set_bint(const char *val, const struct kernel_param *kp);
 #define param_get_bint param_get_int
 #define param_check_bint param_check_int
 
+/* An int, which taints the kernel if set. */
+extern struct kernel_param_ops param_ops_taint_int;
+#define param_check_taint_int param_check_int
+
 /**
  * module_param_array - a parameter which is an array of some type
  * @name: the name of the array variable
diff --git a/kernel/params.c b/kernel/params.c
index 34f527023794..3128218158cf 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -375,6 +375,20 @@ struct kernel_param_ops param_ops_bint = {
 };
 EXPORT_SYMBOL(param_ops_bint);
 
+static int param_set_taint_int(const char *val, const struct kernel_param *kp)
+{
+	pr_warn("Setting dangerous option %s - tainting kernel\n", kp->name);
+	add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+
+	return param_set_int(val, kp);
+}
+
+struct kernel_param_ops param_ops_taint_int = {
+	.set = param_set_taint_int,
+	.get = param_get_int,
+};
+EXPORT_SYMBOL(param_ops_taint_int);
+
 /* We break the rule and mangle the string. */
 static int param_array(const char *name,
 		       const char *val,
