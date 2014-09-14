Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaINKTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:19:45 -0400
Received: from forward7l.mail.yandex.net ([84.201.143.140]:52170 "EHLO
	forward7l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaINKTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:19:43 -0400
X-Yandex-Uniq: b5160751-72ad-4768-921b-ca37338e3e3a
Authentication-Results: smtp1h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 3/3] core: create /proc/built-in file to show the list of
 built-in drivers
From: Kirill Tkhai <tkhai@yandex.ru>
To: mmarek@suse.cz, arnd@arndb.de, linux-kbuild@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, grant.likely@secretlab.ca, ebiederm@xmission.com,
        akpm@linux-foundation.org, ktkhai@parallels.com, sam@ravnborg.org
Date: Sun, 14 Sep 2014 14:19:37 +0400
Message-ID: <20140914101933.3745.29648.stgit@localhost>
In-Reply-To: <20140914100545.3745.23394.stgit@localhost>
References: <20140914100545.3745.23394.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: kirill tkhai <ktkhai@parallels.com>
---
 fs/proc/Makefile  |    1 +
 fs/proc/builtin.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)
 create mode 100644 fs/proc/builtin.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 7151ea4..1e13361 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -10,6 +10,7 @@ proc-$(CONFIG_MMU)	:= task_mmu.o
 proc-y       += inode.o root.o base.o generic.o array.o \
 		fd.o
 proc-$(CONFIG_TTY)      += proc_tty.o
+proc-y	+= builtin.o
 proc-y	+= cmdline.o
 proc-y	+= consoles.o
 proc-y	+= cpuinfo.o
diff --git a/fs/proc/builtin.c b/fs/proc/builtin.c
new file mode 100644
index 0000000..2d49980
--- /dev/null
+++ b/fs/proc/builtin.c
@@ -0,0 +1,70 @@
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+extern char __start_builtin_drivers_list[], __stop_builtin_drivers_list[];
+
+static void *b_start(struct seq_file *m, loff_t *pos)
+{
+	unsigned long size = (unsigned long)__stop_builtin_drivers_list -
+			     (unsigned long)__start_builtin_drivers_list;
+	if (*pos) {
+		/* Skip all !'\0' symbols */
+		while (*pos <= size &&  *(__start_builtin_drivers_list + *pos))
+			++*pos;
+		/* Skip all  '\0' symbols */
+		while (*pos <= size && !*(__start_builtin_drivers_list + *pos))
+			++*pos;
+	}
+
+	if (*pos >= size)
+		return NULL;
+
+	return __start_builtin_drivers_list + *pos;
+}
+
+static void *b_next(struct seq_file *m, void *cur, loff_t *pos)
+{
+	++*pos;
+
+	return b_start(m, pos);
+}
+
+static void b_stop(struct seq_file *m, void *p)
+{
+}
+
+static int b_show(struct seq_file *m, void *p)
+{
+	seq_printf(m, "%s\n", (const char *)p);
+
+	return 0;
+}
+
+static const struct seq_operations builtin_op = {
+	.start = b_start,
+	.next = b_next,
+	.stop = b_stop,
+	.show = b_show
+};
+
+static int builtin_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &builtin_op);
+}
+
+static const struct file_operations builtin_operations = {
+	.open = builtin_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release_private,
+};
+
+static int __init proc_builtin_init(void)
+{
+	proc_create("built-in", S_IRUGO, NULL, &builtin_operations);
+	return 0;
+}
+
+fs_initcall(proc_builtin_init);

