Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaAZMlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 07:41:50 -0500
Received: from hostedrelay.fireflyinternet.com ([109.228.30.76]:60037 "EHLO
	relay.fireflyinternet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaAZMls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 07:41:48 -0500
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jan 2014 07:41:48 EST
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] lib: Export interval_tree
Date: Sun, 26 Jan 2014 12:24:33 +0000
Message-Id: <1390739073-4519-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390316872-15887-1-git-send-email-chris@chris-wilson.co.uk>
References: <1390316872-15887-1-git-send-email-chris@chris-wilson.co.uk>
X-Authenticated-User: chris.alporthouse@surfanytime.net 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/interval_tree.c provides a simple interface for an interval-tree
(an augmented red-black tree) but is only built when testing the generic
macros for building interval-trees. For drivers with modest needs,
export the simple interval-tree library as is.

v2: Lots of help from Michel Lespinasse to only compile the code
    as required:
    - make INTERVAL_TREE a config option
    - make INTERVAL_TREE_TEST select the library functions
      and sanitize the filenames & Makefile
    - prepare interval_tree for being built as a module if required

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Note for maintainers, this is being proposed for use by i915.ko, so it
may make the most sense to merge it via the drm/i915 tree in the next
cycle.
---
 lib/Kconfig                   |  14 ++++++
 lib/Kconfig.debug             |   1 +
 lib/Makefile                  |   3 +-
 lib/interval_tree.c           |   6 +++
 lib/interval_tree_test.c      | 106 ++++++++++++++++++++++++++++++++++++++++++
 lib/interval_tree_test_main.c | 106 ------------------------------------------
 6 files changed, 128 insertions(+), 108 deletions(-)
 create mode 100644 lib/interval_tree_test.c
 delete mode 100644 lib/interval_tree_test_main.c

diff --git a/lib/Kconfig b/lib/Kconfig
index 991c98bc4a3f..04270aae4b60 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -322,6 +322,20 @@ config TEXTSEARCH_FSM
 config BTREE
 	boolean
 
+config INTERVAL_TREE
+	boolean
+	help
+	  Simple, embeddable, interval-tree. Can find the start of an
+	  overlapping range in log(n) time and then iterate over all
+	  overlapping nodes. The algorithm is implemented as an
+	  augmented rbtree.
+
+	  See:
+
+		Documentation/rbtree.txt
+
+	  for more information.
+
 config ASSOCIATIVE_ARRAY
 	bool
 	help
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index db25707aa41b..a29e9b84f102 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1478,6 +1478,7 @@ config RBTREE_TEST
 config INTERVAL_TREE_TEST
 	tristate "Interval tree test"
 	depends on m && DEBUG_KERNEL
+	select INTERVAL_TREE
 	help
 	  A benchmark measuring the performance of the interval tree library
 
diff --git a/lib/Makefile b/lib/Makefile
index a459c31e8c6b..fc04948548ad 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -47,6 +47,7 @@ CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 
 obj-$(CONFIG_BTREE) += btree.o
+obj-$(CONFIG_INTERVAL_TREE) += interval_tree.o
 obj-$(CONFIG_ASSOCIATIVE_ARRAY) += assoc_array.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
@@ -152,8 +153,6 @@ lib-$(CONFIG_LIBFDT) += $(libfdt_files)
 obj-$(CONFIG_RBTREE_TEST) += rbtree_test.o
 obj-$(CONFIG_INTERVAL_TREE_TEST) += interval_tree_test.o
 
-interval_tree_test-objs := interval_tree_test_main.o interval_tree.o
-
 obj-$(CONFIG_PERCPU_TEST) += percpu_test.o
 
 obj-$(CONFIG_ASN1) += asn1_decoder.o
diff --git a/lib/interval_tree.c b/lib/interval_tree.c
index e6eb406f2d65..e4109f624e51 100644
--- a/lib/interval_tree.c
+++ b/lib/interval_tree.c
@@ -1,6 +1,7 @@
 #include <linux/init.h>
 #include <linux/interval_tree.h>
 #include <linux/interval_tree_generic.h>
+#include <linux/module.h>
 
 #define START(node) ((node)->start)
 #define LAST(node)  ((node)->last)
@@ -8,3 +9,8 @@
 INTERVAL_TREE_DEFINE(struct interval_tree_node, rb,
 		     unsigned long, __subtree_last,
 		     START, LAST,, interval_tree)
+
+EXPORT_SYMBOL(interval_tree_insert);
+EXPORT_SYMBOL(interval_tree_remove);
+EXPORT_SYMBOL(interval_tree_iter_first);
+EXPORT_SYMBOL(interval_tree_iter_next);
diff --git a/lib/interval_tree_test.c b/lib/interval_tree_test.c
new file mode 100644
index 000000000000..245900b98c8e
--- /dev/null
+++ b/lib/interval_tree_test.c
@@ -0,0 +1,106 @@
+#include <linux/module.h>
+#include <linux/interval_tree.h>
+#include <linux/random.h>
+#include <asm/timex.h>
+
+#define NODES        100
+#define PERF_LOOPS   100000
+#define SEARCHES     100
+#define SEARCH_LOOPS 10000
+
+static struct rb_root root = RB_ROOT;
+static struct interval_tree_node nodes[NODES];
+static u32 queries[SEARCHES];
+
+static struct rnd_state rnd;
+
+static inline unsigned long
+search(unsigned long query, struct rb_root *root)
+{
+	struct interval_tree_node *node;
+	unsigned long results = 0;
+
+	for (node = interval_tree_iter_first(root, query, query); node;
+	     node = interval_tree_iter_next(node, query, query))
+		results++;
+	return results;
+}
+
+static void init(void)
+{
+	int i;
+	for (i = 0; i < NODES; i++) {
+		u32 a = prandom_u32_state(&rnd);
+		u32 b = prandom_u32_state(&rnd);
+		if (a <= b) {
+			nodes[i].start = a;
+			nodes[i].last = b;
+		} else {
+			nodes[i].start = b;
+			nodes[i].last = a;
+		}
+	}
+	for (i = 0; i < SEARCHES; i++)
+		queries[i] = prandom_u32_state(&rnd);
+}
+
+static int interval_tree_test_init(void)
+{
+	int i, j;
+	unsigned long results;
+	cycles_t time1, time2, time;
+
+	printk(KERN_ALERT "interval tree insert/remove");
+
+	prandom_seed_state(&rnd, 3141592653589793238ULL);
+	init();
+
+	time1 = get_cycles();
+
+	for (i = 0; i < PERF_LOOPS; i++) {
+		for (j = 0; j < NODES; j++)
+			interval_tree_insert(nodes + j, &root);
+		for (j = 0; j < NODES; j++)
+			interval_tree_remove(nodes + j, &root);
+	}
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	time = div_u64(time, PERF_LOOPS);
+	printk(" -> %llu cycles\n", (unsigned long long)time);
+
+	printk(KERN_ALERT "interval tree search");
+
+	for (j = 0; j < NODES; j++)
+		interval_tree_insert(nodes + j, &root);
+
+	time1 = get_cycles();
+
+	results = 0;
+	for (i = 0; i < SEARCH_LOOPS; i++)
+		for (j = 0; j < SEARCHES; j++)
+			results += search(queries[j], &root);
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	time = div_u64(time, SEARCH_LOOPS);
+	results = div_u64(results, SEARCH_LOOPS);
+	printk(" -> %llu cycles (%lu results)\n",
+	       (unsigned long long)time, results);
+
+	return -EAGAIN; /* Fail will directly unload the module */
+}
+
+static void interval_tree_test_exit(void)
+{
+	printk(KERN_ALERT "test exit\n");
+}
+
+module_init(interval_tree_test_init)
+module_exit(interval_tree_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michel Lespinasse");
+MODULE_DESCRIPTION("Interval Tree test");
diff --git a/lib/interval_tree_test_main.c b/lib/interval_tree_test_main.c
deleted file mode 100644
index 245900b98c8e..000000000000
--- a/lib/interval_tree_test_main.c
+++ /dev/null
@@ -1,106 +0,0 @@
-#include <linux/module.h>
-#include <linux/interval_tree.h>
-#include <linux/random.h>
-#include <asm/timex.h>
-
-#define NODES        100
-#define PERF_LOOPS   100000
-#define SEARCHES     100
-#define SEARCH_LOOPS 10000
-
-static struct rb_root root = RB_ROOT;
-static struct interval_tree_node nodes[NODES];
-static u32 queries[SEARCHES];
-
-static struct rnd_state rnd;
-
-static inline unsigned long
-search(unsigned long query, struct rb_root *root)
-{
-	struct interval_tree_node *node;
-	unsigned long results = 0;
-
-	for (node = interval_tree_iter_first(root, query, query); node;
-	     node = interval_tree_iter_next(node, query, query))
-		results++;
-	return results;
-}
-
-static void init(void)
-{
-	int i;
-	for (i = 0; i < NODES; i++) {
-		u32 a = prandom_u32_state(&rnd);
-		u32 b = prandom_u32_state(&rnd);
-		if (a <= b) {
-			nodes[i].start = a;
-			nodes[i].last = b;
-		} else {
-			nodes[i].start = b;
-			nodes[i].last = a;
-		}
-	}
-	for (i = 0; i < SEARCHES; i++)
-		queries[i] = prandom_u32_state(&rnd);
-}
-
-static int interval_tree_test_init(void)
-{
-	int i, j;
-	unsigned long results;
-	cycles_t time1, time2, time;
-
-	printk(KERN_ALERT "interval tree insert/remove");
-
-	prandom_seed_state(&rnd, 3141592653589793238ULL);
-	init();
-
-	time1 = get_cycles();
-
-	for (i = 0; i < PERF_LOOPS; i++) {
-		for (j = 0; j < NODES; j++)
-			interval_tree_insert(nodes + j, &root);
-		for (j = 0; j < NODES; j++)
-			interval_tree_remove(nodes + j, &root);
-	}
-
-	time2 = get_cycles();
-	time = time2 - time1;
-
-	time = div_u64(time, PERF_LOOPS);
-	printk(" -> %llu cycles\n", (unsigned long long)time);
-
-	printk(KERN_ALERT "interval tree search");
-
-	for (j = 0; j < NODES; j++)
-		interval_tree_insert(nodes + j, &root);
-
-	time1 = get_cycles();
-
-	results = 0;
-	for (i = 0; i < SEARCH_LOOPS; i++)
-		for (j = 0; j < SEARCHES; j++)
-			results += search(queries[j], &root);
-
-	time2 = get_cycles();
-	time = time2 - time1;
-
-	time = div_u64(time, SEARCH_LOOPS);
-	results = div_u64(results, SEARCH_LOOPS);
-	printk(" -> %llu cycles (%lu results)\n",
-	       (unsigned long long)time, results);
-
-	return -EAGAIN; /* Fail will directly unload the module */
-}
-
-static void interval_tree_test_exit(void)
-{
-	printk(KERN_ALERT "test exit\n");
-}
-
-module_init(interval_tree_test_init)
-module_exit(interval_tree_test_exit)
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Michel Lespinasse");
-MODULE_DESCRIPTION("Interval Tree test");
-- 
1.8.5.3

