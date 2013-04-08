Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934759Ab3DJAEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:04:09 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54536 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219Ab3DJAEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:04:07 -0400
Date: Mon, 8 Apr 2013 18:59:09 -0400
From: Andrew Shewmaker <agshew@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        simon.jeons@gmail.com, ric.masonn@gmail.com
Subject: [PATCH v9 3/3] mm: reinititalise user and admin reserves if memory
 is added or removed
Message-ID: <20130408225908.GD3396@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If memory is added and the reserves have been eliminated or increased above
the default max, then we'll trust the admin.

If memory is removed and there isn't enough free memory, then we
need to reset the reserves.

Otherwise keep the reserve set by the admin.

The reserve reset code is the same as the reserve initialization code.

I tested hot addition and removal by triggering it via sysfs. The reserves
shrunk when they were set high and memory was removed. They were reset
higher when memory was added again.

Signed-off-by: Andrew Shewmaker <agshew@gmail.com>

---

Please see first patch in series for full changelog.

Abbreviated Patch Changelog

v9:
 * Cleanup extern declarations - from Andrew Morton

 * Explanatory comments for magic numbers in memory notifier

 * Use new register_hotmemory_notifier() to avoid bloat - from Andrew Morton

 * Dropped accidental .gitignore change in v8

v8:
 * Rebased onto v3.9-rc4-mmotm-2013-03-26-15-09

 * Clarified reasoning between different calculations for
   overcommit 'guess' and 'never modes in FAQ entry
   "How do you calculate a minimum useful reserve?"
   in response to Simon Jeons.

 * Added third patch in series to handle hot-added or hot-swapped
   memory.
---
 mm/mmap.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 5d63c9e..9e3e028 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -33,6 +33,8 @@
 #include <linux/uprobes.h>
 #include <linux/rbtree_augmented.h>
 #include <linux/sched/sysctl.h>
+#include <linux/notifier.h>
+#include <linux/memory.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -3111,3 +3113,77 @@ int __meminit init_admin_reserve(void)
 	return 0;
 }
 module_init(init_admin_reserve)
+
+/*
+ * Reinititalise user and admin reserves if memory is added or removed.
+ *
+ * The default user reserve max is 128MB, and the default max for the
+ * admin reserve is 8MB. These are usually, but not always, enough to
+ * enable recovery from a memory hogging process using login/sshd, a shell,
+ * and tools like top. It may make sense to increase or even disable the
+ * reserve depending on the existence of swap or variations in the recovery
+ * tools. So, the admin may have changed them.
+ *
+ * If memory is added and the reserves have been eliminated or increased above
+ * the default max, then we'll trust the admin. 
+ *
+ * If memory is removed and there isn't enough free memory, then we 
+ * need to reset the reserves.
+ *
+ * Otherwise keep the reserve set by the admin.
+ */
+static int reserve_mem_notifier(struct notifier_block *nb,
+			     unsigned long action, void *data)
+{
+	unsigned long tmp, free_kbytes;
+
+	switch (action) {
+	case MEM_ONLINE:
+		/*
+		 * Default max is 128MB. Leave alone if modified by operator.
+ 		 */
+		tmp = sysctl_user_reserve_kbytes;
+		if (0 < tmp && tmp < (1UL << 17))
+			init_user_reserve();
+
+		/*
+		 * Default max is 8MB. Leave alone if modified by operator.
+ 		 */
+		tmp = sysctl_admin_reserve_kbytes;
+		if (0 < tmp && tmp < (1UL << 13))
+			init_admin_reserve();
+
+		break;
+	case MEM_OFFLINE:
+		free_kbytes = global_page_state(NR_FREE_PAGES) << (PAGE_SHIFT - 10);
+
+		if (sysctl_user_reserve_kbytes > free_kbytes) {
+			init_user_reserve();
+			pr_info("vm.user_reserve_kbytes reset to %lu\n",
+				sysctl_user_reserve_kbytes);
+		}
+
+		if (sysctl_admin_reserve_kbytes > free_kbytes) {
+			init_admin_reserve();
+			pr_info("vm.admin_reserve_kbytes reset to %lu\n",
+				sysctl_admin_reserve_kbytes);
+		}
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block reserve_mem_nb = {
+	.notifier_call = reserve_mem_notifier,
+};
+
+int __meminit init_reserve_notifier(void)
+{
+	if (register_hotmemory_notifier(&reserve_mem_nb))
+		printk("Failed registering memory add/remove notifier for admin reserve");
+
+	return 0;
+}
+module_init(init_reserve_notifier)
-- 
1.8.0.1

