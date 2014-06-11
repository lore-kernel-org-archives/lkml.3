Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaFKTBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:01:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37641 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaFKTBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:01:16 -0400
Date: Wed, 11 Jun 2014 21:01:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, m.chehab@samsung.com, rostedt@goodmis.org,
        linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7 v2] RAS, debugfs: Add debugfs interface for RAS
 subsystem
Message-ID: <20140611190113.GD14923@pd.tnic>
References: <1402475691-30045-1-git-send-email-gong.chen@linux.intel.com>
 <1402475691-30045-5-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1402475691-30045-5-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:34:48AM -0400, Chen, Gong wrote:
> Implement a new debugfs interface for RAS susbsystem.
> A file named daemon_active is added there accordingly.
> This file is used to track if user space daemon enables
> perf/trace interface or not. One can track which daemon
> opens it via "lsof /path/to/debugfs/ras/daemon_active".
> 
> v2 -> v1: Change file access mode from 0444 to 0400.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  drivers/ras/Makefile  |  2 +-
>  drivers/ras/debugfs.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/ras/ras.c     | 14 +++++++++++++
>  include/linux/ras.h   | 15 ++++++++++++++
>  4 files changed, 87 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/ras/debugfs.c
>  create mode 100644 include/linux/ras.h
> 
> diff --git a/drivers/ras/Makefile b/drivers/ras/Makefile
> index 223e806..d7f7334 100644
> --- a/drivers/ras/Makefile
> +++ b/drivers/ras/Makefile
> @@ -1 +1 @@
> -obj-$(CONFIG_RAS) += ras.o
> +obj-$(CONFIG_RAS) += ras.o debugfs.o
> diff --git a/drivers/ras/debugfs.c b/drivers/ras/debugfs.c
> new file mode 100644
> index 0000000..d0bc389
> --- /dev/null
> +++ b/drivers/ras/debugfs.c
> @@ -0,0 +1,57 @@
> +#include <linux/debugfs.h>
> +
> +struct dentry *ras_debugfs_dir;
> +EXPORT_SYMBOL_GPL(ras_debugfs_dir);

No need to export this. Revised version below:

---
From: "Chen, Gong" <gong.chen@linux.intel.com>

Implement a new debugfs interface for RAS susbsystem.
A file named daemon_active is added there accordingly.
This file is used to track if user space daemon accesses
perf/trace interface or not. One can track which daemon
opens it via "lsof /path/to/debugfs/ras/daemon_active".

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Link: http://lkml.kernel.org/r/1402475691-30045-5-git-send-email-gong.chen@linux.intel.com
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/ras/Makefile  |  2 +-
 drivers/ras/debugfs.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ras/ras.c     | 14 +++++++++++++
 include/linux/ras.h   | 15 ++++++++++++++
 4 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ras/debugfs.c
 create mode 100644 include/linux/ras.h

Index: linux/drivers/ras/Makefile
===================================================================
--- linux.orig/drivers/ras/Makefile	2014-06-11 17:54:21.738397566 +0200
+++ linux/drivers/ras/Makefile	2014-06-11 17:54:21.726397566 +0200
@@ -1 +1 @@
-obj-$(CONFIG_RAS) += ras.o
+obj-$(CONFIG_RAS) += ras.o debugfs.o
Index: linux/drivers/ras/debugfs.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/ras/debugfs.c	2014-06-11 17:58:47.214393178 +0200
@@ -0,0 +1,56 @@
+#include <linux/debugfs.h>
+
+static struct dentry *ras_debugfs_dir;
+
+static atomic_t trace_count = ATOMIC_INIT(0);
+
+int ras_userspace_consumers(void)
+{
+	return atomic_read(&trace_count);
+}
+EXPORT_SYMBOL_GPL(ras_userspace_consumers);
+
+static int trace_show(struct seq_file *m, void *v)
+{
+	return atomic_read(&trace_count);
+}
+
+static int trace_open(struct inode *inode, struct file *file)
+{
+	atomic_inc(&trace_count);
+	return single_open(file, trace_show, NULL);
+}
+
+static int trace_release(struct inode *inode, struct file *file)
+{
+	atomic_dec(&trace_count);
+	return single_release(inode, file);
+}
+
+static const struct file_operations trace_fops = {
+	.open    = trace_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = trace_release,
+};
+
+int __init ras_add_daemon_trace(void)
+{
+	struct dentry *fentry;
+
+	if (!ras_debugfs_dir)
+		return -ENOENT;
+
+	fentry = debugfs_create_file("daemon_active", S_IRUSR, ras_debugfs_dir,
+				     NULL, &trace_fops);
+	if (!fentry)
+		return -ENODEV;
+
+	return 0;
+
+}
+
+void __init ras_debugfs_init(void)
+{
+	ras_debugfs_dir = debugfs_create_dir("ras", NULL);
+}
Index: linux/drivers/ras/ras.c
===================================================================
--- linux.orig/drivers/ras/ras.c	2014-06-11 17:54:21.738397566 +0200
+++ linux/drivers/ras/ras.c	2014-06-11 17:54:21.730397566 +0200
@@ -5,8 +5,22 @@
  *	Chen, Gong <gong.chen@linux.intel.com>
  */
 
+#include <linux/init.h>
+#include <linux/ras.h>
+
 #define CREATE_TRACE_POINTS
 #define TRACE_INCLUDE_PATH ../../include/ras
 #include <ras/ras_event.h>
 
+static int __init ras_init(void)
+{
+	int rc = 0;
+
+	ras_debugfs_init();
+	rc = ras_add_daemon_trace();
+
+	return rc;
+}
+subsys_initcall(ras_init);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
Index: linux/include/linux/ras.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/include/linux/ras.h	2014-06-11 17:58:43.350393242 +0200
@@ -0,0 +1,14 @@
+#ifndef __RAS_H__
+#define __RAS_H__
+
+#ifdef CONFIG_DEBUG_FS
+int ras_userspace_consumers(void);
+void ras_debugfs_init(void);
+int ras_add_daemon_trace(void);
+#else
+static inline int ras_userspace_consumers(void) { return 0; }
+static inline void ras_debugfs_init(void) { return; }
+static inline int ras_add_daemon_trace(void) { return 0; }
+#endif
+
+#endif

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
