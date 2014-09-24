Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaIXKAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:00:16 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:7502 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751601AbaIXKAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:00:12 -0400
X-IronPort-AV: E=Sophos;i="5.04,588,1406563200"; 
   d="scan'208";a="36394367"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: [PATCHv3 1/2] procfs: show hierarchy of pid namespace
Date: Wed, 24 Sep 2014 18:00:26 +0800
Message-ID: <1411552827-31056-2-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1411552827-31056-1-git-send-email-chenhanxiao@cn.fujitsu.com>
References: <1411552827-31056-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will show the hierarchy of pid namespace
by /proc/pidns_hierarchy like:

[root@localhost ~]#cat /proc/pidns_hierarchy
/proc/18060/ns/pid /proc/18102/ns/pid /proc/1534/ns/pid
/proc/18060/ns/pid /proc/18102/ns/pid /proc/1600/ns/pid
/proc/1550/ns/pid

It shows the pid hierarchy below:

        init_pid_ns (not showed in /proc/pidns_hierarchy)
              │
┌──────────────┐
ns1                          ns2
│                            │
/proc/1550/ns/pid    /proc/18060/ns/pid
                              │
                              │
                             ns3
                              │
                     /proc/18102/ns/pid
                              │
                     ┌──────────┒
                     ns4                   ns5
                     │                    │
                     /proc/1534/ns/pid   /proc/1600/ns/pid

Every pid printed in pidns_hierarchy
is the init pid of that pid ns level.

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
v3: fix a race issue and memory leak issue
v2: use a procfs text file instead of dirs under /proc

 fs/proc/Kconfig           |   6 ++
 fs/proc/Makefile          |   1 +
 fs/proc/pidns_hierarchy.c | 227 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 234 insertions(+)
 create mode 100644 fs/proc/pidns_hierarchy.c

diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 2183fcf..e2e2292 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -71,3 +71,9 @@ config PROC_PAGE_MONITOR
 	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximately 4kb.
+
+config PROC_PID_HIERARCHY
+	bool "Enable /proc/pidns_hierarchy support" if EXPERT
+	depends on PROC_FS
+	help
+	  Show pid namespace hierarchy information
diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 7151ea4..33e384b 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -30,3 +30,4 @@ proc-$(CONFIG_PROC_KCORE)	+= kcore.o
 proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
 proc-$(CONFIG_PRINTK)	+= kmsg.o
 proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o
+proc-$(CONFIG_PROC_PID_HIERARCHY)	+= pidns_hierarchy.o
diff --git a/fs/proc/pidns_hierarchy.c b/fs/proc/pidns_hierarchy.c
new file mode 100644
index 0000000..8a73095
--- /dev/null
+++ b/fs/proc/pidns_hierarchy.c
@@ -0,0 +1,227 @@
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/proc_fs.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/pid_namespace.h>
+#include <linux/seq_file.h>
+#include <linux/mutex.h>
+
+/*
+ *  /proc/pidns_hierarchy
+ *
+ *  show the hierarchy of pid namespace
+ */
+
+#define NS_HIERARCHY	"pidns_hierarchy"
+
+static LIST_HEAD(pidns_list);
+static LIST_HEAD(pidns_tree);
+static DEFINE_MUTEX(pidns_list_lock);
+
+/* list for host pid collection */
+struct pidns_list {
+	struct list_head list;
+	struct pid *pid;
+};
+
+static void free_pidns_list(struct list_head *head)
+{
+	struct pidns_list *tmp, *pos;
+
+	list_for_each_entry_safe(pos, tmp, head, list) {
+		list_del(&pos->list);
+		kfree(pos);
+	}
+}
+
+/*
+ * Only add init pid of different namespaces
+ */
+static int
+pidns_list_really_add(struct pid *pid, struct list_head *list_head)
+{
+	struct pidns_list *pos;
+
+	if (!is_child_reaper(pid))
+		return 0;
+
+	list_for_each_entry(pos, list_head, list)
+		if (ns_of_pid(pid) == ns_of_pid(pos->pid))
+			return 0;
+
+	return 1;
+}
+
+static int
+pidns_list_add(struct pid *pid, struct list_head *list_head)
+{
+	struct pidns_list *ent;
+
+	if (pidns_list_really_add(pid, list_head)) {
+		ent = kmalloc(sizeof(*ent), GFP_ATOMIC);
+		if (!ent)
+			return -ENOMEM;
+
+		ent->pid = pid;
+		list_add_tail(&ent->list, list_head);
+	}
+
+	return 0;
+}
+
+static int
+pidns_list_filter(void)
+{
+	struct pidns_list *pos, *pos_t;
+	struct pid_namespace *ns0, *ns1;
+	struct pid *pid0, *pid1;
+	int flag = 0;
+	int rc;
+
+	/* screen pid with relationship
+	 * in pidns_list, we may add pids like
+	 * ns0   ns1   ns2
+	 * pid1->pid2->pid3
+	 * we should screen pid1, pid2 and keep pid3
+	 */
+	list_for_each_entry(pos, &pidns_list, list) {
+		list_for_each_entry(pos_t, &pidns_list, list) {
+			flag = 0;
+			pid0 = pos->pid;
+			pid1 = pos_t->pid;
+			ns0 = pid0->numbers[pid0->level].ns;
+			ns1 = pid1->numbers[pid1->level].ns;
+			if (pos->pid->level < pos_t->pid->level)
+				for (; ns1 != NULL; ns1 = ns1->parent)
+					if (ns0 == ns1) {
+						flag = 1;
+						break;
+					}
+			if (flag == 1)
+				break;
+		}
+
+		if (flag == 0) {
+			rc = pidns_list_add(pos->pid, &pidns_tree);
+			if (rc)
+				goto out;
+		}
+	}
+
+	/* Now all usefull stuff are in pidns_tree, free pidns_list*/
+	free_pidns_list(&pidns_list);
+
+	return 0;
+
+out:
+	free_pidns_list(&pidns_tree);
+	return rc;
+}
+
+/* collect pids in pidns_list,
+ * then remove duplicated ones,
+ * add the rest to pidns_tree
+ */
+static int proc_pidns_list_refresh(void)
+{
+	struct pid *pid;
+	struct task_struct *p;
+	int rc;
+
+	/* collect pid in differet ns */
+	rcu_read_lock();
+	for_each_process(p) {
+		pid = task_pid(p);
+		if (pid && (pid->level > 0)) {
+			rc = pidns_list_add(pid, &pidns_list);
+			if (rc)
+				goto out;
+		}
+	}
+
+	/* screen duplicate pids from list pidns_list
+	* and form a new list pidns_tree
+	*/
+	rc = pidns_list_filter();
+	if (rc)
+		goto out;
+	rcu_read_unlock();
+
+	return 0;
+
+out:
+	free_pidns_list(&pidns_list);
+	rcu_read_unlock();
+	return rc;
+}
+
+static int nslist_proc_show(struct seq_file *m, void *v)
+{
+	struct pidns_list *pos;
+	struct pid_namespace *ns, *curr_ns;
+	struct pid *pid;
+	char pid_buf[32];
+	int i, curr_level;
+	int rc;
+
+	curr_ns = task_active_pid_ns(current);
+
+	mutex_lock(&pidns_list_lock);
+	rc = proc_pidns_list_refresh();
+	if (rc) {
+		mutex_unlock(&pidns_list_lock);
+		return rc;
+	}
+
+	/* print pid namespace hierarchy */
+	list_for_each_entry(pos, &pidns_tree, list) {
+		pid = pos->pid;
+		curr_level = -1;
+		ns = pid->numbers[pid->level].ns;
+		/* Check whether a pid has relationship with current ns */
+		for (; ns != NULL; ns = ns->parent)
+			if (ns == curr_ns)
+				curr_level = curr_ns->level;
+
+		if (curr_level == -1)
+			continue;
+
+		for (i = curr_level + 1; i <= pid->level; i++) {
+			ns = pid->numbers[i].ns;
+			/* show PID '1' in specific pid ns */
+			snprintf(pid_buf, 32, "/proc/%u/ns/pid",
+				pid_vnr(find_pid_ns(1, ns)));
+			seq_printf(m, "%s ", pid_buf);
+		}
+
+		seq_putc(m, '\n');
+	}
+
+	free_pidns_list(&pidns_tree);
+	mutex_unlock(&pidns_list_lock);
+
+	return 0;
+}
+
+static int nslist_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nslist_proc_show, NULL);
+}
+
+static const struct file_operations proc_nspid_nslist_fops = {
+	.open		= nslist_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init pidns_hierarchy_init(void)
+{
+	proc_create(NS_HIERARCHY, S_IWUGO,
+		NULL, &proc_nspid_nslist_fops);
+
+	return 0;
+}
+fs_initcall(pidns_hierarchy_init);
-- 
1.9.0

