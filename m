Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaBGSmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:42:00 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33001 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaBGSl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:41:58 -0500
Date: Fri, 7 Feb 2014 13:41:47 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 9.5/10] sysfs, kobject: add sysfs wrapper for
 kernfs_enable_ns()
Message-ID: <20140207184147.GC12815@htj.dyndns.org>
References: <1391454557-32376-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391454557-32376-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5de4dc5a029516985b6ee9add23b4bacbbea490d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 7 Feb 2014 13:32:07 -0500

Currently, kobject is invoking kernfs_enable_ns() directly.  This is
fine now as sysfs and kernfs are enabled and disabled together.  If
sysfs is disabled, kernfs_enable_ns() is switched to dummy
implementation too and everything is fine; however, kernfs will soon
have its own config option CONFIG_KERNFS and !SYSFS && KERNFS will be
possible, which can make kobject call into non-dummy
kernfs_enable_ns() with NULL kernfs_node pointers leading to an oops.

Introduce sysfs_enable_ns() which is a wrapper around
kernfs_enable_ns() so that it can be made a noop depending only on
CONFIG_SYSFS regardless of the planned CONFIG_KERNFS.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
 include/linux/sysfs.h | 9 +++++++++
 lib/kobject.c         | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 14df054..fdaa0c6 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -244,6 +244,11 @@ void sysfs_notify(struct kobject *kobj, const char *dir, const char *attr);
 
 int __must_check sysfs_init(void);
 
+static inline void sysfs_enable_ns(struct kernfs_node *kn)
+{
+	return kernfs_enable_ns(kn);
+}
+
 #else /* CONFIG_SYSFS */
 
 static inline int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
@@ -416,6 +421,10 @@ static inline int __must_check sysfs_init(void)
 	return 0;
 }
 
+static inline void sysfs_enable_ns(struct kernfs_node *kn)
+{
+}
+
 #endif /* CONFIG_SYSFS */
 
 static inline int __must_check sysfs_create_file(struct kobject *kobj,
diff --git a/lib/kobject.c b/lib/kobject.c
index cb14aea..58751bb 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -94,7 +94,7 @@ static int create_dir(struct kobject *kobj)
 		BUG_ON(ops->type >= KOBJ_NS_TYPES);
 		BUG_ON(!kobj_ns_type_registered(ops->type));
 
-		kernfs_enable_ns(kobj->sd);
+		sysfs_enable_ns(kobj->sd);
 	}
 
 	return 0;
-- 
1.8.5.3

