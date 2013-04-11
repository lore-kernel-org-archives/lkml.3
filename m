Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161610Ab3DKNbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:31:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980Ab3DKNbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:31:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 25/26] arm: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>, viro@ZenIV.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 11 Apr 2013 14:30:58 +0100
Message-ID: <20130411133058.32763.5466.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use create_proc_read_entry() as that is deprecated, but rather use
proc_create_data() and seq_file instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Russell King <linux@arm.linux.org.uk>
cc: Kevin Hilman <khilman@deeprootsystems.com>
cc: Tony Lindgren <tony@atomide.com>
cc: linux-arm-kernel@lists.infradead.org
cc: linux-omap@vger.kernel.org
---

 arch/arm/kernel/swp_emulate.c |   42 +++++++++++++-----------------
 arch/arm/mach-omap1/pm.c      |   58 +++++++++++++++++------------------------
 2 files changed, 43 insertions(+), 57 deletions(-)

diff --git a/arch/arm/kernel/swp_emulate.c b/arch/arm/kernel/swp_emulate.c
index 0bba47a..087fc32 100644
--- a/arch/arm/kernel/swp_emulate.c
+++ b/arch/arm/kernel/swp_emulate.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/perf_event.h>
@@ -79,27 +80,27 @@ static unsigned long abtcounter;
 static pid_t         previous_pid;
 
 #ifdef CONFIG_PROC_FS
-static int proc_read_status(char *page, char **start, off_t off, int count,
-			    int *eof, void *data)
+static int proc_status_show(struct seq_file *m, void *v)
 {
-	char *p = page;
-	int len;
-
-	p += sprintf(p, "Emulated SWP:\t\t%lu\n", swpcounter);
-	p += sprintf(p, "Emulated SWPB:\t\t%lu\n", swpbcounter);
-	p += sprintf(p, "Aborted SWP{B}:\t\t%lu\n", abtcounter);
+	seq_printf(m, "Emulated SWP:\t\t%lu\n", swpcounter);
+	seq_printf(m, "Emulated SWPB:\t\t%lu\n", swpbcounter);
+	seq_printf(m, "Aborted SWP{B}:\t\t%lu\n", abtcounter);
 	if (previous_pid != 0)
-		p += sprintf(p, "Last process:\t\t%d\n", previous_pid);
-
-	len = (p - page) - off;
-	if (len < 0)
-		len = 0;
-
-	*eof = (len <= count) ? 1 : 0;
-	*start = page + off;
+		seq_printf(m, "Last process:\t\t%d\n", previous_pid);
+	return 0;
+}
 
-	return len;
+static int proc_status_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_status_show, PDE_DATA(inode));
 }
+
+static const struct file_operations proc_status_fops = {
+	.open		= proc_status_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 #endif
 
 /*
@@ -266,12 +267,7 @@ static struct undef_hook swp_hook = {
 static int __init swp_emulation_init(void)
 {
 #ifdef CONFIG_PROC_FS
-	struct proc_dir_entry *res;
-
-	res = create_proc_read_entry("cpu/swp_emulation", S_IRUGO, NULL,
-					proc_read_status, NULL);
-
-	if (!res)
+	if (!proc_create("cpu/swp_emulation", S_IRUGO, NULL, &proc_status_fops))
 		return -ENOMEM;
 #endif /* CONFIG_PROC_FS */
 
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 7a7690a..2645e37 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -38,6 +38,7 @@
 #include <linux/suspend.h>
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/interrupt.h>
 #include <linux/sysfs.h>
 #include <linux/module.h>
@@ -423,22 +424,11 @@ void omap1_pm_suspend(void)
 }
 
 #if defined(DEBUG) && defined(CONFIG_PROC_FS)
-static int g_read_completed;
-
 /*
  * Read system PM registers for debugging
  */
-static int omap_pm_read_proc(
-	char *page_buffer,
-	char **my_first_byte,
-	off_t virtual_start,
-	int length,
-	int *eof,
-	void *data)
+static int omap_pm_proc_show(struct seq_file *m, void *v)
 {
-	int my_buffer_offset = 0;
-	char * const my_base = page_buffer;
-
 	ARM_SAVE(ARM_CKCTL);
 	ARM_SAVE(ARM_IDLECT1);
 	ARM_SAVE(ARM_IDLECT2);
@@ -479,10 +469,7 @@ static int omap_pm_read_proc(
 		MPUI1610_SAVE(EMIFS_CONFIG);
 	}
 
-	if (virtual_start == 0) {
-		g_read_completed = 0;
-
-		my_buffer_offset += sprintf(my_base + my_buffer_offset,
+	seq_printf(m,
 		   "ARM_CKCTL_REG:            0x%-8x     \n"
 		   "ARM_IDLECT1_REG:          0x%-8x     \n"
 		   "ARM_IDLECT2_REG:          0x%-8x     \n"
@@ -512,8 +499,8 @@ static int omap_pm_read_proc(
 		   ULPD_SHOW(ULPD_STATUS_REQ),
 		   ULPD_SHOW(ULPD_POWER_CTRL));
 
-		if (cpu_is_omap7xx()) {
-			my_buffer_offset += sprintf(my_base + my_buffer_offset,
+	if (cpu_is_omap7xx()) {
+		seq_printf(m,
 			   "MPUI7XX_CTRL_REG	     0x%-8x \n"
 			   "MPUI7XX_DSP_STATUS_REG:      0x%-8x \n"
 			   "MPUI7XX_DSP_BOOT_CONFIG_REG: 0x%-8x \n"
@@ -526,8 +513,8 @@ static int omap_pm_read_proc(
 			   MPUI7XX_SHOW(MPUI_DSP_API_CONFIG),
 			   MPUI7XX_SHOW(EMIFF_SDRAM_CONFIG),
 			   MPUI7XX_SHOW(EMIFS_CONFIG));
-		} else if (cpu_is_omap15xx()) {
-			my_buffer_offset += sprintf(my_base + my_buffer_offset,
+	} else if (cpu_is_omap15xx()) {
+		seq_printf(m,
 			   "MPUI1510_CTRL_REG             0x%-8x \n"
 			   "MPUI1510_DSP_STATUS_REG:      0x%-8x \n"
 			   "MPUI1510_DSP_BOOT_CONFIG_REG: 0x%-8x \n"
@@ -540,8 +527,8 @@ static int omap_pm_read_proc(
 			   MPUI1510_SHOW(MPUI_DSP_API_CONFIG),
 			   MPUI1510_SHOW(EMIFF_SDRAM_CONFIG),
 			   MPUI1510_SHOW(EMIFS_CONFIG));
-		} else if (cpu_is_omap16xx()) {
-			my_buffer_offset += sprintf(my_base + my_buffer_offset,
+	} else if (cpu_is_omap16xx()) {
+		seq_printf(m,
 			   "MPUI1610_CTRL_REG             0x%-8x \n"
 			   "MPUI1610_DSP_STATUS_REG:      0x%-8x \n"
 			   "MPUI1610_DSP_BOOT_CONFIG_REG: 0x%-8x \n"
@@ -554,25 +541,28 @@ static int omap_pm_read_proc(
 			   MPUI1610_SHOW(MPUI_DSP_API_CONFIG),
 			   MPUI1610_SHOW(EMIFF_SDRAM_CONFIG),
 			   MPUI1610_SHOW(EMIFS_CONFIG));
-		}
-
-		g_read_completed++;
-	} else if (g_read_completed >= 1) {
-		 *eof = 1;
-		 return 0;
 	}
-	g_read_completed++;
 
-	*my_first_byte = page_buffer;
-	return  my_buffer_offset;
+	return 0;
+}
+
+static int omap_pm_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, omap_pm_proc_show, PDE_DATA(inode));
 }
 
+static const struct file_operations omap_pm_proc_fops = {
+	.open		= omap_pm_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static void omap_pm_init_proc(void)
 {
 	/* XXX Appears to leak memory */
-	create_proc_read_entry("driver/omap_pm",
-			       S_IWUSR | S_IRUGO, NULL,
-			       omap_pm_read_proc, NULL);
+	create_proc("driver/omap_pm", S_IWUSR | S_IRUGO, NULL,
+		    &omap_pm_proc_fops);
 }
 
 #endif /* DEBUG && CONFIG_PROC_FS */

