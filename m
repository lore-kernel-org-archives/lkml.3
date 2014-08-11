Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaHKN5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:57:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:21615 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbaHKN5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:57:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,841,1400050800"; 
   d="scan'208";a="574988080"
From: Jani Nikula <jani.nikula@intel.com>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, jani.nikula@intel.com
Subject: [PATCH 3/4] module: add module_param_unsafe and module_param_named_unsafe
Date: Mon, 11 Aug 2014 16:52:21 +0300
Message-Id: <acb5af81e9ab220d5567c853f8cee5f1333af641.1407764272.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1407764272.git.jani.nikula@intel.com>
References: <cover.1407764272.git.jani.nikula@intel.com>
In-Reply-To: <cover.1407764272.git.jani.nikula@intel.com>
References: <cover.1407764272.git.jani.nikula@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the helpers to be used by modules wishing to expose unsafe debugging
or testing module parameters that taint the kernel when set.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Jon Mason <jon.mason@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 include/linux/moduleparam.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 1e3ffb839daa..9531f9f9729e 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -123,6 +123,12 @@ struct kparam_array
 	module_param_named(name, name, type, perm)
 
 /**
+ * module_param_unsafe - same as module_param but taints kernel
+ */
+#define module_param_unsafe(name, type, perm)			\
+	module_param_named_unsafe(name, name, type, perm)
+
+/**
  * module_param_named - typesafe helper for a renamed module/cmdline parameter
  * @name: a valid C identifier which is the parameter name.
  * @value: the actual lvalue to alter.
@@ -139,6 +145,14 @@ struct kparam_array
 	__MODULE_PARM_TYPE(name, #type)
 
 /**
+ * module_param_named_unsafe - same as module_param_named but taints kernel
+ */
+#define module_param_named_unsafe(name, value, type, perm)		\
+	param_check_##type(name, &(value));				\
+	module_param_cb_unsafe(name, &param_ops_##type, &value, perm);	\
+	__MODULE_PARM_TYPE(name, #type)
+
+/**
  * module_param_cb - general callback for a module/cmdline parameter
  * @name: a valid C identifier which is the parameter name.
  * @ops: the set & get operations for this parameter.
@@ -149,6 +163,10 @@ struct kparam_array
 #define module_param_cb(name, ops, arg, perm)				      \
 	__module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, -1, 0)
 
+#define module_param_cb_unsafe(name, ops, arg, perm)			      \
+	__module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, -1,    \
+			    KERNEL_PARAM_FL_UNSAFE)
+
 /**
  * <level>_param_cb - general callback for a module/cmdline parameter
  *                    to be evaluated before certain initcall level
-- 
1.9.1

