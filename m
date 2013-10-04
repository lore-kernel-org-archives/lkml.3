Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3JDKcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:32:10 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:37749 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3JDKcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:32:03 -0400
Subject: [PATCH 09/19] Create /proc/pid/core entry
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@in.ibm.com>
Cc: amwang@redhat.com, rdunlap@xenotime.net, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
        suzuki@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com,
        adobriyan@gmail.com, tarundsk@linux.vnet.ibm.com, vapier@gentoo.org,
        roland@hack.frob.com, tj@kernel.org, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Date: Fri, 04 Oct 2013 16:01:47 +0530
Message-ID: <20131004103146.1612.63775.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-5816-0000-0000-00000A357793
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Ananth N.Mavinakayanahalli <ananth@in.ibm.com>

Create the /proc/PID/core entry.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N.Mavinakayanahalli <ananth@in.ibm.com>
---
 fs/proc/Makefile   |    1 +
 fs/proc/base.c     |    2 ++
 fs/proc/gencore.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/internal.h |    1 +
 4 files changed, 52 insertions(+)
 create mode 100644 fs/proc/gencore.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index ab30716..a456c22 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -23,6 +23,7 @@ proc-y	+= version.o
 proc-y	+= softirqs.o
 proc-y	+= namespaces.o
 proc-y	+= self.o
+proc-$(CONFIG_ELF_CORE)        += gencore.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1485e38..da5a212 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2640,6 +2640,8 @@ static const struct pid_entry tgid_base_stuff[] = {
 #endif
 #ifdef CONFIG_ELF_CORE
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
+	REG("core", S_IRUSR, proc_gen_core_operations),
+
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUSR, proc_tgid_io_accounting),
diff --git a/fs/proc/gencore.c b/fs/proc/gencore.c
new file mode 100644
index 0000000..115f1e4
--- /dev/null
+++ b/fs/proc/gencore.c
@@ -0,0 +1,48 @@
+/*
+ * Application core dump
+ * 
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2010, 2013
+ *
+ * Authors:
+ *      Ananth N.Mavinakayanahalli <ananth@in.ibm.com>
+ *      Suzuki K. Poulose <suzuki@in.ibm.com>
+ */
+
+#include <linux/seq_file.h>
+#include "internal.h"
+
+static ssize_t read_gencore(struct file *file, char __user *buffer,
+				size_t buflen, loff_t *fpos)
+{
+	return 0;
+}
+
+static int release_gencore(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int open_gencore(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+const struct file_operations proc_gen_core_operations = {
+	.open           = open_gencore,
+	.read           = read_gencore,
+	.release        = release_gencore,
+};
+
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 651d09a..47538f2 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -228,6 +228,7 @@ extern const struct file_operations proc_ns_dir_operations;
  */
 extern const struct file_operations proc_net_operations;
 extern const struct inode_operations proc_net_inode_operations;
+extern const struct file_operations proc_gen_core_operations;
 
 #ifdef CONFIG_NET
 extern int proc_net_init(void);

