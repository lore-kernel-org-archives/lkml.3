Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbaHKI4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:56:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbaHKIuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:50:35 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/20] perf tools: Add poller object to handle polling globaly
Date: Mon, 11 Aug 2014 10:49:56 +0200
Message-Id: <1407747014-18394-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding poller object to centralize polling processing and
to have independent polling object, that could gather and
process multiple file descriptors from different sources.
(like perf events, timers or standard input..)

The interface functions are documented in the poller.c and
usage is explained in the poller.h.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf |   2 +
 tools/perf/util/poller.c | 233 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/poller.h |  88 ++++++++++++++++++
 3 files changed, 323 insertions(+)
 create mode 100644 tools/perf/util/poller.c
 create mode 100644 tools/perf/util/poller.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 1ea31e275b4d..3ef50d35f8bf 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -303,6 +303,7 @@ LIB_H += ui/util.h
 LIB_H += ui/ui.h
 LIB_H += util/data.h
 LIB_H += util/kvm-stat.h
+LIB_H += util/poller.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -379,6 +380,7 @@ LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/tsc.o
 LIB_OBJS += $(OUTPUT)util/cloexec.o
+LIB_OBJS += $(OUTPUT)util/poller.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/poller.c b/tools/perf/util/poller.c
new file mode 100644
index 000000000000..d6db392633d2
--- /dev/null
+++ b/tools/perf/util/poller.c
@@ -0,0 +1,233 @@
+#include <linux/bitops.h>
+#include <linux/hash.h>
+#include <linux/string.h>
+#include <asm/bug.h>
+#include <string.h>
+#include <errno.h>
+#include "perf.h"
+#include "poller.h"
+
+/**
+ * poller__init - Initialize poller object
+ * @p: poller object pointer
+ */
+void poller__init(struct poller *p)
+{
+	int i;
+
+	memset(p, 0, sizeof(*p));
+	for (i = 0; i < POLLER__HLIST_SIZE ; ++i)
+		INIT_HLIST_HEAD(&p->items[i]);
+}
+
+/**
+ * poller__cleanup - Cleanup poller object
+ * @p: poller object pointer
+ */
+void poller__cleanup(struct poller *p)
+{
+	free(p->ptr);
+}
+
+static struct poller_item *item_find(struct poller *p, int fd)
+{
+	struct hlist_head *head;
+	struct poller_item *item;
+	int hash;
+
+	hash = hash_64(fd, POLLER__HLIST_BITS);
+	head = &p->items[hash];
+
+	hlist_for_each_entry(item, head, node) {
+		if (item->fd == fd)
+			return item;
+	}
+
+	return NULL;
+}
+
+static int process_item(struct poller *p, struct poller_item *item,
+			short revents)
+{
+	poller_cb cb = NULL;
+
+#define OP(__name) ({item->ops.__name ?: p->ops.__name; })
+	if (revents & POLLIN)
+		cb = OP(data);
+	if (revents & POLLERR)
+		cb = OP(error);
+	if (revents & POLLHUP)
+		cb = OP(hup);
+#undef OP
+	return cb ? cb(p, item) : 0;
+}
+
+static int process(struct poller *p, int nret)
+{
+	struct pollfd *pfd, *pfd_base;
+	int n = p->n;
+	int i, ret = 0;
+
+	/*
+	 * We allow to call poller__del from poll callbacks,
+	 * we we need to duplicate pollfd table to be sure
+	 * it's still there.
+	 */
+	pfd = pfd_base = memdup(p->ptr, p->n * sizeof(struct pollfd));
+	if (!pfd)
+		return -ENOMEM;
+
+	for (i = 0; (i < n) && nret; pfd++, i++) {
+		struct poller_item *item;
+
+		if (!pfd->revents)
+			continue;
+
+		ret = -EINVAL;
+
+		item = item_find(p, pfd->fd);
+		if (WARN(!item, "poller: unknown fd found"))
+			goto err;
+
+		ret = process_item(p, item, pfd->revents);
+		if (ret)
+			goto err;
+
+		nret--;
+	}
+
+err:
+	free(pfd_base);
+	return ret;
+}
+
+/**
+ * poller__poll - poll installed descriptors
+ * @p:       poller object pointer
+ * @timeout: poll timeout (same as for poll syscall)
+ *
+ * This will poll  on installed  descriptors  and  run installed
+ * callbacks in case there's an activity. If there's no activity
+ * it will sleep for @timeout milliseconds.
+ *
+ * On success returns number of descriptors processed.
+ * On error returns poll(3) error or failed callback
+ * error.
+ *
+ * Note first failed callback will stop processing
+ */
+int poller__poll(struct poller *p, int timeout)
+{
+	int ret, err;
+
+	ret = poll(p->ptr, p->n, timeout);
+	if (ret < 0 || !ret)
+		return ret;
+
+	err = process(p, ret);
+	return err ?: ret;
+}
+
+static struct pollfd *get_pfd(struct poller *p)
+{
+	struct pollfd *ptr = p->ptr;
+
+	if (p->n + 1 < p->n_alloc)
+		goto out;
+
+	ptr = realloc(ptr, (p->n + 1) * sizeof(*ptr));
+	if (!ptr)
+		return NULL;
+
+	p->n_alloc++;
+	p->ptr = ptr;
+out:
+	return ptr + p->n++;
+}
+
+static void put_pfd(struct poller *p, int fd)
+{
+	struct pollfd *pfd = p->ptr;
+	int i;
+
+	for (i = 0; i < p->n; pfd++, i++) {
+		if (pfd->fd == fd)
+			break;
+	}
+
+	if (WARN(i == p->n, "poller: fd not found"))
+		return;
+
+	p->n--;
+	*pfd = *(p->ptr + p->n);
+}
+
+/**
+ * poller__add - add file descriptor to poller object
+ * @p:    poller object pointer
+ * @item: file descriptor poller-item object pointer
+ *
+ * This will install file descriptor poller-item object
+ * pointer into  poller object. It will be processed in
+ * the poller__poll call.
+ *
+ * On success returns 0.
+ * On error returns value <0 indicating the error.
+ */
+int poller__add(struct poller *p, struct poller_item *item)
+{
+	struct pollfd *pfd;
+	int hash;
+
+	if (item_find(p, item->fd))
+		return -EINVAL;
+
+	pfd = get_pfd(p);
+	if (!pfd)
+		return -ENOMEM;
+
+	pfd->fd     = item->fd;
+	pfd->events = POLLIN|POLLERR|POLLHUP;
+
+	hash = hash_64(item->fd, POLLER__HLIST_BITS);
+	hlist_add_head(&item->node, &p->items[hash]);
+	return 0;
+}
+
+/**
+ * poller__del - remove file descriptor from poller object
+ * @p:    poller object pointer
+ * @item: file descriptor poller-item object pointer
+ *
+ * This will remove file descriptor poller-item object
+ * pointer from poller object.
+ */
+void poller__del(struct poller *p, struct poller_item *item)
+{
+	put_pfd(p, item->fd);
+	hlist_del_init(&item->node);
+}
+
+/**
+ * poller__set_ops - set poller object operations
+ * @p:   poller object pointer
+ * @ops: new operations
+ *
+ * This will remove file descriptor poller-item object
+ * pointer from poller object.
+ */
+void poller__set_ops(struct poller *p, struct poller_ops *ops)
+{
+	p->ops = *ops;
+}
+
+/**
+ * poller__empty - Check poller object emptiness
+ * @p:    poller object pointer
+ *
+ * Returns true if poller object is empty, false otherwise.
+ */
+bool poller__empty(struct poller *p)
+{
+	return p->n == 0;
+}
diff --git a/tools/perf/util/poller.h b/tools/perf/util/poller.h
new file mode 100644
index 000000000000..36b6f15d7538
--- /dev/null
+++ b/tools/perf/util/poller.h
@@ -0,0 +1,88 @@
+#ifndef __PERF_POLLER
+#define __PERF_POLLER
+
+/*
+ * The interface functions are documented in the poller.c.
+ *
+ * Basically user has 'struct poller poller' object and
+ * initialize it by calling:
+ *
+ *   poller__init(&poller);
+ *
+ * For each file descriptor define 'struct poller_item'
+ * object like:
+ *
+ *   struct poller_item p = {
+ *     .fd   = fd,              -> monitored fd
+ *     .data = ...              -> user data
+ *     .ops  = {                -> callbacks (optional)
+ *       data   = data_cb,      -> data  callback called for POLLIN event
+ *       error  = error_cb,     -> error callback called for POLLERR event
+ *       hup    = hup_cb,       -> hup   callback called for POLLHUP event
+ *     },
+ *   }
+ *
+ *  Any defined 'struct poller_item' object could be then added
+ *  (or removed) into poller object by:
+ *
+ *    poller__add(&poller, &p);
+ *    poller__del(&poller, &p);
+ *
+ *  Each added object gets processed by poller__poll:
+ *
+ *    poller__poll(&poller, -1);
+ *
+ *  which calls poll(3) on installed (added) descriptors
+ *  and calls callbacks for specific descriptors.
+ *
+ *  Note it's possible to call poller__add/del within
+ *  the callback function.
+ *
+ *  If 'struct poller_item::ops' stays undefined, the
+ *  'struct poller:ops' is checked and used instead.
+ *
+ *  To cleanup poller's object at the end call:
+ *
+ *     poller__cleanup(struct poller *p);
+ */
+
+#include <poll.h>
+#include <linux/list.h>
+
+#define POLLER__HLIST_BITS 8
+#define POLLER__HLIST_SIZE (1 << POLLER__HLIST_BITS)
+
+struct poller_item;
+struct poller;
+
+typedef int (*poller_cb)(struct poller *p, struct poller_item *item);
+
+struct poller_ops {
+	poller_cb data;
+	poller_cb error;
+	poller_cb hup;
+};
+
+struct poller_item {
+	int			 fd;
+	struct hlist_node	 node;
+	struct poller_ops	 ops;
+	void			 *data;
+};
+
+struct poller {
+	int			 n;
+	int			 n_alloc;
+	struct pollfd		*ptr;
+	struct poller_ops	 ops;
+	struct hlist_head	 items[POLLER__HLIST_SIZE];
+};
+
+void poller__init(struct poller *p);
+void poller__cleanup(struct poller *p);
+int poller__poll(struct poller *p, int timeout);
+int poller__add(struct poller *p, struct poller_item *item);
+void poller__del(struct poller *p, struct poller_item *item);
+void poller__set_ops(struct poller *p, struct poller_ops *ops);
+bool poller__empty(struct poller *p);
+#endif /* __PERF_POLLER */
-- 
1.8.3.1

