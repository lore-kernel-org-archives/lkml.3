Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3IJPaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:30:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17396 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3IJPaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:30:09 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: xen-devel@lists.xen.org
Cc: konrad.wilk@oracle.com, david.vrabel@citrix.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v1 1/5] xen: xensyms support
Date: Tue, 10 Sep 2013 11:31:46 -0400
Message-Id: <1378827110-4192-2-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export Xen symbols to dom0 via /proc/xen/xensyms (similar to /proc/kallsyms).

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 drivers/xen/Kconfig              |   5 ++
 drivers/xen/xenfs/Makefile       |   1 +
 drivers/xen/xenfs/super.c        |   3 +
 drivers/xen/xenfs/xenfs.h        |   1 +
 drivers/xen/xenfs/xensyms.c      | 170 +++++++++++++++++++++++++++++++++++++++
 include/xen/interface/platform.h |  21 +++++
 6 files changed, 201 insertions(+)
 create mode 100644 drivers/xen/xenfs/xensyms.c

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 9e02d60..a21fce9 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -242,4 +242,9 @@ config XEN_MCE_LOG
 config XEN_HAVE_PVMMU
        bool
 
+config XEN_SYMS
+       bool "Xen symbols"
+       depends on XEN_DOM0 && XENFS && KALLSYMS
+       default y
+
 endmenu
diff --git a/drivers/xen/xenfs/Makefile b/drivers/xen/xenfs/Makefile
index b019865..1a83010 100644
--- a/drivers/xen/xenfs/Makefile
+++ b/drivers/xen/xenfs/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_XENFS) += xenfs.o
 
 xenfs-y			  = super.o
 xenfs-$(CONFIG_XEN_DOM0) += xenstored.o
+xenfs-$(CONFIG_XEN_SYMS) += xensyms.o
diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 06092e0..8559a71 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -57,6 +57,9 @@ static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
 		{ "privcmd", &xen_privcmd_fops, S_IRUSR|S_IWUSR },
 		{ "xsd_kva", &xsd_kva_file_ops, S_IRUSR|S_IWUSR},
 		{ "xsd_port", &xsd_port_file_ops, S_IRUSR|S_IWUSR},
+#ifdef CONFIG_XEN_SYMS
+		{ "xensyms", &xensyms_ops, S_IRUSR},
+#endif
 		{""},
 	};
 
diff --git a/drivers/xen/xenfs/xenfs.h b/drivers/xen/xenfs/xenfs.h
index 6b80c77..2c5934e 100644
--- a/drivers/xen/xenfs/xenfs.h
+++ b/drivers/xen/xenfs/xenfs.h
@@ -3,5 +3,6 @@
 
 extern const struct file_operations xsd_kva_file_ops;
 extern const struct file_operations xsd_port_file_ops;
+extern const struct file_operations xensyms_ops;
 
 #endif	/* _XENFS_XENBUS_H */
diff --git a/drivers/xen/xenfs/xensyms.c b/drivers/xen/xenfs/xensyms.c
new file mode 100644
index 0000000..e3301f0
--- /dev/null
+++ b/drivers/xen/xenfs/xensyms.c
@@ -0,0 +1,170 @@
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/proc_fs.h>
+#include <linux/slab.h>
+#include <xen/interface/platform.h>
+#include <asm/xen/hypercall.h>
+#include <xen/xen-ops.h>
+#include "xenfs.h"
+
+
+struct xensyms_state {
+	struct xenpf_symdata symdata;
+	ssize_t off;
+};
+
+/* Grab next output page from the hypervisor */
+static int xensyms_next_page(struct xensyms_state *state)
+{
+	int ret;
+	struct xen_platform_op op;
+
+	op.cmd = XENPF_get_symbols;
+	op.u.symdata = state->symdata;
+
+	ret = HYPERVISOR_dom0_op(&op);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		/* End of symbols */
+		return 1;
+
+	state->symdata = op.u.symdata;
+	state->off = 0;
+
+	return 0;
+}
+
+static void *xensyms_start(struct seq_file *m, loff_t *pos)
+{
+	struct xensyms_state *state = (struct xensyms_state *)m->private;
+
+	if (state->off == UINT_MAX) {
+		if (xensyms_next_page(state))
+			return NULL;
+	}
+
+	return m->private;
+}
+
+static void *xensyms_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct xensyms_state *state = (struct xensyms_state *)m->private;
+	unsigned int str_len, next_off;
+
+	str_len = strlen(&state->symdata.buf[state->off]) + 1;
+	next_off = state->off + str_len;
+
+	/* If there is no more data on this page then ask Xen for more */
+	if (next_off >= XENSYMS_SZ || state->symdata.buf[next_off] == 0) {
+		if (xensyms_next_page(state))
+			return NULL;
+	} else
+		state->off = next_off;
+
+	return p;
+}
+
+static int xensyms_show(struct seq_file *m, void *p)
+{
+	struct xensyms_state *state = (struct xensyms_state *)m->private;
+
+	seq_printf(m, "%s", &state->symdata.buf[state->off]);
+
+	return 0;
+}
+
+static void xensyms_stop(struct seq_file *m, void *p)
+{
+}
+
+static const struct seq_operations xensyms_seq_ops = {
+	.start = xensyms_start,
+	.next = xensyms_next,
+	.show = xensyms_show,
+	.stop = xensyms_stop,
+};
+
+static int xensyms_open(struct inode *inode, struct file *file)
+{
+	int ret;
+	struct xensyms_state *state;
+	struct seq_file *m;
+
+	ret = seq_open_private(file, &xensyms_seq_ops,
+		sizeof(struct xensyms_state));
+	if (ret)
+		return ret;
+
+	m = file->private_data;
+	state = (struct xensyms_state *)m->private;
+	state->symdata.buf = kmalloc(XENSYMS_SZ, GFP_KERNEL);
+	if (!state->symdata.buf) {
+		(void)seq_release_private(inode, file);
+		return -ENOMEM;
+	}
+
+	/* Force first page fetch in xensyms_start() */
+	state->off = UINT_MAX;
+
+	state->symdata.xen_offset = 0;
+	state->symdata.xen_symnum = 0;
+
+	return 0;
+}
+
+static int xensyms_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = file->private_data;
+	struct xensyms_state *state = (struct xensyms_state *)m->private;
+
+	kfree(state->symdata.buf);
+	return seq_release_private(inode, file);
+}
+
+static loff_t xensyms_lseek(struct file *file, loff_t offset, int whence)
+{
+	loff_t ret;
+	struct seq_file *m = file->private_data;
+	struct xensyms_state *state = (struct xensyms_state *)m->private;
+
+	/*
+	 * lseek is rather limited in what it can do here since the file
+	 * is stored in compressed form. Typically it is only used to
+	 * seek to the beginning of the file by 'more' and the like
+	 * Getting it to work correctly maybe a TODO (broken for Linux
+	 * kallsyms too)
+	 */
+	if (whence != SEEK_SET)
+		return -EINVAL;
+
+	state->symdata.xen_offset = 0;
+	state->symdata.xen_symnum = 0;
+	state->off = UINT_MAX;
+
+	ret = seq_lseek(file, offset, whence);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Advance pointers to next string (seq_read() will flush
+	 * remainder of current string to user on next read).
+	 * Note that we are guaranteed not to cross page boundary here
+	 * since only whole strings are placed onto the page by Xen.
+	 */
+	if (state->off != UINT_MAX && state->symdata.buf[state->off] != 0)
+		state->off += strlen(&state->symdata.buf[state->off]) + 1;
+
+	return ret;
+}
+
+
+const struct file_operations xensyms_ops = {
+	.open = xensyms_open,
+	.read = seq_read,
+	.llseek = xensyms_lseek,
+	.release = xensyms_release
+};
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
index c57d5f6..ecaaa08a04 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -351,6 +351,26 @@ struct xenpf_core_parking {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_core_parking);
 
+#define XENPF_get_symbols  61
+
+#define XENSYMS_SZ         4096
+struct xenpf_symdata {
+	/*
+	 * offset into Xen's symbol data and symbol number from
+	 * last call. Used only by Xen.
+	 */
+	uint64_t xen_offset;
+	uint64_t xen_symnum;
+
+	/*
+	 * Symbols data, formatted similar to /proc/kallsyms:
+	 *   <address> <type> <name>
+	 */
+	GUEST_HANDLE(char) buf;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xenpf_symdata);
+
+
 struct xen_platform_op {
 	uint32_t cmd;
 	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
@@ -371,6 +391,7 @@ struct xen_platform_op {
 		struct xenpf_cpu_hotadd        cpu_add;
 		struct xenpf_mem_hotadd        mem_add;
 		struct xenpf_core_parking      core_parking;
+		struct xenpf_symdata           symdata;
 		uint8_t                        pad[128];
 	} u;
 };
-- 
1.8.1.4

