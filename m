Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992456AbaEPVpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:45:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:61145 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbaEPVnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:43:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1069,1389772800"; 
   d="scan'208";a="533259471"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/8] list: Out of line INIT_LIST_HEAD and list_del
Date: Fri, 16 May 2014 14:43:10 -0700
Message-Id: <1400276595-6965-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Out of lining these two inlines saves ~21k on my vmlinux

14152713	2003976	1507328	17664017	10d8811	vmlinux-before-list
14131431	2008136	1507328	17646895	10d452f	vmlinux-list

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/list.h | 15 ++++-----------
 lib/Makefile         |  2 +-
 lib/list.c           | 22 ++++++++++++++++++++++
 3 files changed, 27 insertions(+), 12 deletions(-)
 create mode 100644 lib/list.c

diff --git a/include/linux/list.h b/include/linux/list.h
index ef95941..8297885 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -21,11 +21,8 @@
 #define LIST_HEAD(name) \
 	struct list_head name = LIST_HEAD_INIT(name)
 
-static inline void INIT_LIST_HEAD(struct list_head *list)
-{
-	list->next = list;
-	list->prev = list;
-}
+/* Out of line to save space */
+void INIT_LIST_HEAD(struct list_head *list);
 
 /*
  * Insert a new entry between two known consecutive entries.
@@ -101,12 +98,8 @@ static inline void __list_del_entry(struct list_head *entry)
 	__list_del(entry->prev, entry->next);
 }
 
-static inline void list_del(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	entry->next = LIST_POISON1;
-	entry->prev = LIST_POISON2;
-}
+/* Out of line to save space */
+void list_del(struct list_head *entry);
 #else
 extern void __list_del_entry(struct list_head *entry);
 extern void list_del(struct list_head *entry);
diff --git a/lib/Makefile b/lib/Makefile
index 0cd7b68..8b744f7 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o
+	 earlycpio.o list.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
diff --git a/lib/list.c b/lib/list.c
new file mode 100644
index 0000000..298768f
--- /dev/null
+++ b/lib/list.c
@@ -0,0 +1,22 @@
+#include <linux/list.h>
+#include <linux/module.h>
+
+/*
+ * Out of line versions of common list.h functions that bloat the
+ * kernel too much.
+ */
+
+void INIT_LIST_HEAD(struct list_head *list)
+{
+	list->next = list;
+	list->prev = list;
+}
+EXPORT_SYMBOL(INIT_LIST_HEAD);
+
+void list_del(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->next = LIST_POISON1;
+	entry->prev = LIST_POISON2;
+}
+EXPORT_SYMBOL(list_del);
-- 
1.9.0

