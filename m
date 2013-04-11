Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935969Ab3DKSDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:03:48 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44348 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933627Ab3DKSDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:03:46 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+xfqYsjf/wo3C2irUlZwbN
Date: Thu, 11 Apr 2013 11:03:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>, viro@ZenIV.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 25/26] arm: Don't use create_proc_read_entry() [RFC]
Message-ID: <20130411180341.GA10155@atomide.com>
References: <20130411154806.GU10155@atomide.com>
 <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
 <20130411133058.32763.5466.stgit@warthog.procyon.org.uk>
 <13448.1365698725@warthog.procyon.org.uk>
 <20130411165702.GZ10155@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411165702.GZ10155@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [130411 10:01]:
> * David Howells <dhowells@redhat.com> [130411 09:50]:
> > Tony Lindgren <tony@atomide.com> wrote:
> > 
> > > Looks like the mach-omap1/pm.c part we can make into
> > > a debugfs entry as it only contains PM debug data. But
> > > that we can do after this patch.
> > 
> > If you have a patch to do that, I can substitute it for this one.
> 
> Sure will do.

Here's the updated patch to do it against current linux next.
Tested on osk5912. It should not conflict with anything else
currently queued, so please feel free to merge it along with
your other patches.

Note that the patch below does not contain the swp_emulate.c
changes.

Regards,

Tony


From: Tony Lindgren <tony@atomide.com>
Date: Thu, 11 Apr 2013 10:02:38 -0700
Subject: [PATCH] ARM: OMAP1: Replace PM debug create_proc_read_entry() with debugfs

There's no need to keep this entry in proc, it is PM
related debug only entry. Let's move it into debugfs.

Based on an earlier patch David Howells <dhowells@redhat.com>
to use seq_printf and to update to use create_proc_read_entry().

Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index db37f49..dd712f1 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -37,7 +37,8 @@
 
 #include <linux/suspend.h>
 #include <linux/sched.h>
-#include <linux/proc_fs.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 #include <linux/interrupt.h>
 #include <linux/sysfs.h>
 #include <linux/module.h>
@@ -423,23 +424,12 @@ void omap1_pm_suspend(void)
 		omap_rev());
 }
 
-#if defined(DEBUG) && defined(CONFIG_PROC_FS)
-static int g_read_completed;
-
+#ifdef CONFIG_DEBUG_FS
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
+static int omap_pm_debug_show(struct seq_file *m, void *v)
 {
-	int my_buffer_offset = 0;
-	char * const my_base = page_buffer;
-
 	ARM_SAVE(ARM_CKCTL);
 	ARM_SAVE(ARM_IDLECT1);
 	ARM_SAVE(ARM_IDLECT2);
@@ -480,10 +470,7 @@ static int omap_pm_read_proc(
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
@@ -513,8 +500,8 @@ static int omap_pm_read_proc(
 		   ULPD_SHOW(ULPD_STATUS_REQ),
 		   ULPD_SHOW(ULPD_POWER_CTRL));
 
-		if (cpu_is_omap7xx()) {
-			my_buffer_offset += sprintf(my_base + my_buffer_offset,
+	if (cpu_is_omap7xx()) {
+		seq_printf(m,
 			   "MPUI7XX_CTRL_REG	     0x%-8x \n"
 			   "MPUI7XX_DSP_STATUS_REG:      0x%-8x \n"
 			   "MPUI7XX_DSP_BOOT_CONFIG_REG: 0x%-8x \n"
@@ -527,8 +514,8 @@ static int omap_pm_read_proc(
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
@@ -541,8 +528,8 @@ static int omap_pm_read_proc(
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
@@ -555,28 +542,37 @@ static int omap_pm_read_proc(
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
+static int omap_pm_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, omap_pm_debug_show,
+				&inode->i_private);
 }
 
-static void omap_pm_init_proc(void)
+static const struct file_operations omap_pm_debug_fops = {
+	.open		= omap_pm_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static void omap_pm_init_debugfs(void)
 {
-	/* XXX Appears to leak memory */
-	create_proc_read_entry("driver/omap_pm",
-			       S_IWUSR | S_IRUGO, NULL,
-			       omap_pm_read_proc, NULL);
+	struct dentry *d;
+
+	d = debugfs_create_dir("pm_debug", NULL);
+	if (!d)
+		return;
+
+	(void) debugfs_create_file("omap_pm", S_IWUSR | S_IRUGO,
+					d, NULL, &omap_pm_debug_fops);
 }
 
-#endif /* DEBUG && CONFIG_PROC_FS */
+#endif /* CONFIG_DEBUG_FS */
 
 /*
  *	omap_pm_prepare - Do preliminary suspend work.
@@ -701,8 +697,8 @@ static int __init omap_pm_init(void)
 
 	suspend_set_ops(&omap_pm_ops);
 
-#if defined(DEBUG) && defined(CONFIG_PROC_FS)
-	omap_pm_init_proc();
+#ifdef CONFIG_DEBUG_FS
+	omap_pm_init_debugfs();
 #endif
 
 #ifdef CONFIG_OMAP_32K_TIMER
