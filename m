Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbaEKGCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 02:02:22 -0400
Received: from [162.105.203.56] ([162.105.203.56]:45649 "EHLO
	mail.sei.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaEKGCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 02:02:20 -0400
X-Greylist: delayed 2356 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 May 2014 02:02:20 EDT
From: "Yuan Pengfei" <yuanpf12@sei.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] gcov: add support for GCC 4.9
Date: Sun, 11 May 2014 13:22:53 +0800
Message-ID: <001d01cf6cd9$0efba6b0$2cf2f410$@sei.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: Ac9s2NAcTC6E9oW9SimQpzcqX9R4MQ==
Content-Language: zh-cn
X-Spam_score: -102.9
X-Spam_score_int: -1028
X-Spam_bar: ---------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuan Pengfei <coolypf@qq.com>

This patch handles the gcov-related changes in GCC 4.9:
  A new counter (time profile) is added.
See http://gcc.gnu.org/gcc-4.9/changes.html
Signed-off-by: Yuan Pengfei <coolypf@qq.com>
---
 kernel/gcov/base.c    | 6 ++++++
 kernel/gcov/gcc_3_4.c | 2 +-
 kernel/gcov/gcc_4_7.c | 7 ++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/gcov/base.c b/kernel/gcov/base.c
index f45b75b..b358a80 100644
--- a/kernel/gcov/base.c
+++ b/kernel/gcov/base.c
@@ -85,6 +85,12 @@ void __gcov_merge_ior(gcov_type *counters, unsigned int
n_counters)
 }
 EXPORT_SYMBOL(__gcov_merge_ior);
 
+void __gcov_merge_time_profile(gcov_type *counters, unsigned int
n_counters)
+{
+ /* Unused. */
+}
+EXPORT_SYMBOL(__gcov_merge_time_profile);
+
 /**
  * gcov_enable_events - enable event reporting through gcov_event()
  *
diff --git a/kernel/gcov/gcc_3_4.c b/kernel/gcov/gcc_3_4.c
index 27bc88a..1c1f425 100644
--- a/kernel/gcov/gcc_3_4.c
+++ b/kernel/gcov/gcc_3_4.c
@@ -269,7 +269,7 @@ struct gcov_info *gcov_info_dup(struct gcov_info *info)
  dup->counts[i].num = ctr->num;
  dup->counts[i].merge = ctr->merge;
  dup->counts[i].values = vmalloc(size);
- if (!dup->counts[i].values)
+ if (size && !dup->counts[i].values)
  goto err_free;
  memcpy(dup->counts[i].values, ctr->values, size);
  }
diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
index 2c6e463..7f74b59 100644
--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,12 @@
 #include <linux/vmalloc.h>
 #include "gcov.h"
 
+#if __GNUC__ == 4 && __GNUC_MINOR__ >= 9
+#define GCOV_COUNTERS 9
+#else
 #define GCOV_COUNTERS 8
+#endif
+
 #define GCOV_TAG_FUNCTION_LENGTH 3
 
 static struct gcov_info *gcov_info_head;
@@ -290,7 +295,7 @@ struct gcov_info *gcov_info_dup(struct gcov_info *info)
 
  dci_ptr->values = vmalloc(cv_size);
 
- if (!dci_ptr->values)
+ if (cv_size && !dci_ptr->values)
  goto err_free;
 
  dci_ptr->num = sci_ptr->num;
-- 
2.0.0.rc2

