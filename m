Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbbAXOEF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:04:05 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:55529 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbbAXODx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:03:53 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 03/32] cpumask, nodemask: implement cpumask/nodemask_pr_args()
Date: Sat, 24 Jan 2015 09:03:09 -0500
Message-Id: <1422108218-25398-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printf family of functions can now format bitmaps using '%*pb[l]' and
all cpumask and nodemask formatting will be converted to use it.  To
ease printing these masks with '%*pb[l]' which require two params -
the number of bits and the actual bitmap, this patch implement
cpumask_pr_args() and nodemask_pr_args() which can be used to provide
arguments for '%*pb[l]'

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
Hello,

Linus, this is the third of the three pre-requisite patches to convert
the users of the dedicated bitmap formatting functions over to
'%*pb[l]' formatting and actually implements the formatting.

If this approach is agreed upon, I think it'd be best to route these
three patches through mainline soon so that subsystem conversion
patches can pull these in and apply per-subsystem conversion patches.

Thanks.

 include/linux/cpumask.h  | 8 ++++++++
 include/linux/nodemask.h | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 98939d1..4d8e3b2 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -22,6 +22,14 @@ typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
  */
 #define cpumask_bits(maskp) ((maskp)->bits)
 
+/**
+ * cpumask_pr_args - printf args to output a cpumask
+ * @maskp: cpumask to be printed
+ *
+ * Can be used to provide arguments for '%*pb[l]' when printing a cpumask.
+ */
+#define cpumask_pr_args(maskp)		nr_cpu_ids, cpumask_bits(maskp)
+
 #if NR_CPUS == 1
 #define nr_cpu_ids		1
 #else
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 83a6aed..63295d2 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -98,6 +98,14 @@
 typedef struct { DECLARE_BITMAP(bits, MAX_NUMNODES); } nodemask_t;
 extern nodemask_t _unused_nodemask_arg_;
 
+/**
+ * nodemask_pr_args - printf args to output a nodemask
+ * @maskp: nodemask to be printed
+ *
+ * Can be used to provide arguments for '%*pb[l]' when printing a nodemask.
+ */
+#define nodemask_pr_args(maskp)		MAX_NUMNODES, (maskp)->bits
+
 /*
  * The inline keyword gives the compiler room to decide to inline, or
  * not inline a function as it sees best.  However, as these functions
-- 
2.1.0

