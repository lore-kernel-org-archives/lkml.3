Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935793Ab3DKNaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:30:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935388Ab3DKNab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:30:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 21/26] mips: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-mips@linux-mips.org, viro@ZenIV.linux.org.uk,
        Ralf Baechle <ralf@linux-mips.org>
Date: Thu, 11 Apr 2013 14:30:24 +0100
Message-ID: <20130411133024.32763.36191.stgit@warthog.procyon.org.uk>
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
cc: Ralf Baechle <ralf@linux-mips.org>
cc: linux-mips@linux-mips.org
---

 arch/mips/kernel/smtc-proc.c          |   64 +++++++++-------------
 arch/mips/pci/ops-pmcmsp.c            |   95 ++++++++++++++-------------------
 arch/mips/sibyte/sb1250/bus_watcher.c |   81 +++++++++++++---------------
 3 files changed, 104 insertions(+), 136 deletions(-)

diff --git a/arch/mips/kernel/smtc-proc.c b/arch/mips/kernel/smtc-proc.c
index aee7c81..9fb7144 100644
--- a/arch/mips/kernel/smtc-proc.c
+++ b/arch/mips/kernel/smtc-proc.c
@@ -16,6 +16,7 @@
 #include <asm/mipsregs.h>
 #include <asm/cacheflush.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 #include <asm/smtc_proc.h>
 
@@ -30,51 +31,39 @@ unsigned long selfipis[NR_CPUS];
 
 struct smtc_cpu_proc smtc_cpu_stats[NR_CPUS];
 
-static struct proc_dir_entry *smtc_stats;
-
 atomic_t smtc_fpu_recoveries;
 
-static int proc_read_smtc(char *page, char **start, off_t off,
-			  int count, int *eof, void *data)
+static int smtc_proc_show(struct seq_file *m, void *v)
 {
-	int totalen = 0;
-	int len;
 	int i;
 	extern unsigned long ebase;
 
-	len = sprintf(page, "SMTC Status Word: 0x%08x\n", smtc_status);
-	totalen += len;
-	page += len;
-	len = sprintf(page, "Config7: 0x%08x\n", read_c0_config7());
-	totalen += len;
-	page += len;
-	len = sprintf(page, "EBASE: 0x%08lx\n", ebase);
-	totalen += len;
-	page += len;
-	len = sprintf(page, "Counter Interrupts taken per CPU (TC)\n");
-	totalen += len;
-	page += len;
-	for (i=0; i < NR_CPUS; i++) {
-		len = sprintf(page, "%d: %ld\n", i, smtc_cpu_stats[i].timerints);
-		totalen += len;
-		page += len;
-	}
-	len = sprintf(page, "Self-IPIs by CPU:\n");
-	totalen += len;
-	page += len;
-	for(i = 0; i < NR_CPUS; i++) {
-		len = sprintf(page, "%d: %ld\n", i, smtc_cpu_stats[i].selfipis);
-		totalen += len;
-		page += len;
-	}
-	len = sprintf(page, "%d Recoveries of \"stolen\" FPU\n",
-		      atomic_read(&smtc_fpu_recoveries));
-	totalen += len;
-	page += len;
+	seq_printf(m, "SMTC Status Word: 0x%08x\n", smtc_status);
+	seq_printf(m, "Config7: 0x%08x\n", read_c0_config7());
+	seq_printf(m, "EBASE: 0x%08lx\n", ebase);
+	seq_printf(m, "Counter Interrupts taken per CPU (TC)\n");
+	for (i=0; i < NR_CPUS; i++)
+		seq_printf(m, "%d: %ld\n", i, smtc_cpu_stats[i].timerints);
+	seq_printf(m, "Self-IPIs by CPU:\n");
+	for(i = 0; i < NR_CPUS; i++)
+		seq_printf(m, "%d: %ld\n", i, smtc_cpu_stats[i].selfipis);
+	seq_printf(m, "%d Recoveries of \"stolen\" FPU\n",
+		   atomic_read(&smtc_fpu_recoveries));
+	return 0;
+}
 
-	return totalen;
+static int smtc_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, smtc_proc_show, NULL);
 }
 
+static const struct file_operations smtc_proc_fops = {
+	.open		= smtc_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 void init_smtc_stats(void)
 {
 	int i;
@@ -86,6 +75,5 @@ void init_smtc_stats(void)
 
 	atomic_set(&smtc_fpu_recoveries, 0);
 
-	smtc_stats = create_proc_read_entry("smtc", 0444, NULL,
-					    proc_read_smtc, NULL);
+	proc_create("smtc", 0444, NULL, &smtc_proc_fops);
 }
diff --git a/arch/mips/pci/ops-pmcmsp.c b/arch/mips/pci/ops-pmcmsp.c
index d0b6f83..4eaab63 100644
--- a/arch/mips/pci/ops-pmcmsp.c
+++ b/arch/mips/pci/ops-pmcmsp.c
@@ -53,56 +53,51 @@ static void pci_proc_init(void);
 
 /*****************************************************************************
  *
- *  FUNCTION: read_msp_pci_counts
+ *  FUNCTION: show_msp_pci_counts
  *  _________________________________________________________________________
  *
  *  DESCRIPTION: Prints the count of how many times each PCI
  *		 interrupt has asserted. Can be invoked by the
  *		 /proc filesystem.
  *
- *  INPUTS:	 page	 - part of STDOUT calculation
- *		 off	 - part of STDOUT calculation
- *		 count	 - part of STDOUT calculation
- *		 data	 - unused
+ *  INPUTS:	 m	 - synthetic file construction data
+ *		 v	 - iterator
  *
- *  OUTPUTS:	 start	 - new start location
- *		 eof	 - end of file pointer
- *
- *  RETURNS:	 len	 - STDOUT length
+ *  RETURNS:	 0 or error
  *
  ****************************************************************************/
-static int read_msp_pci_counts(char *page, char **start, off_t off,
-				int count, int *eof, void *data)
+static int show_msp_pci_counts(struct seq_file *m, void *v)
 {
 	int i;
-	int len = 0;
 	unsigned int intcount, total = 0;
 
 	for (i = 0; i < 32; ++i) {
 		intcount = pci_int_count[i];
 		if (intcount != 0) {
-			len += sprintf(page + len, "[%d] = %u\n", i, intcount);
+			seq_printf(m, "[%d] = %u\n", i, intcount);
 			total += intcount;
 		}
 	}
 
-	len += sprintf(page + len, "total = %u\n", total);
-	if (len <= off+count)
-		*eof = 1;
-
-	*start = page + off;
-	len -= off;
-	if (len > count)
-		len = count;
-	if (len < 0)
-		len = 0;
+	seq_printf(m, "total = %u\n", total);
+	return 0;
+}
 
-	return len;
+static int msp_pci_rd_cnt_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_msp_pci_counts, NULL);
 }
 
+static const struct file_operations msp_pci_rd_cnt_fops = {
+	.open		= msp_pci_rd_cnt_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 /*****************************************************************************
  *
- *  FUNCTION: gen_pci_cfg_wr
+ *  FUNCTION: gen_pci_cfg_wr_show
  *  _________________________________________________________________________
  *
  *  DESCRIPTION: Generates a configuration write cycle for debug purposes.
@@ -112,37 +107,30 @@ static int read_msp_pci_counts(char *page, char **start, off_t off,
  *		 PCI bus.  Intent is that this function by invocable from
  *		 the /proc filesystem.
  *
- *  INPUTS:	 page	 - part of STDOUT calculation
- *		 off	 - part of STDOUT calculation
- *		 count	 - part of STDOUT calculation
- *		 data	 - unused
+ *  INPUTS:	 m	 - synthetic file construction data
+ *		 v	 - iterator
  *
- *  OUTPUTS:	 start	 - new start location
- *		 eof	 - end of file pointer
- *
- *  RETURNS:	 len	 - STDOUT length
+ *  RETURNS:	 0 or error
  *
  ****************************************************************************/
-static int gen_pci_cfg_wr(char *page, char **start, off_t off,
-				int count, int *eof, void *data)
+static int gen_pci_cfg_wr_show(struct seq_file *m, void *v)
 {
 	unsigned char where = 0; /* Write to static Device/Vendor ID */
 	unsigned char bus_num = 0; /* Bus 0 */
 	unsigned char dev_fn = 0xF; /* Arbitrary device number */
 	u32 wr_data = 0xFF00AA00; /* Arbitrary data */
 	struct msp_pci_regs *preg = (void *)PCI_BASE_REG;
-	int len = 0;
 	unsigned long value;
 	int intr;
 
-	len += sprintf(page + len, "PMC MSP PCI: Beginning\n");
+	seq_puts(m, "PMC MSP PCI: Beginning\n");
 
 	if (proc_init == 0) {
 		pci_proc_init();
 		proc_init = ~0;
 	}
 
-	len += sprintf(page + len, "PMC MSP PCI: Before Cfg Wr\n");
+	seq_puts(m, "PMC MSP PCI: Before Cfg Wr\n");
 
 	/*
 	 * Generate PCI Configuration Write Cycle
@@ -168,21 +156,22 @@ static int gen_pci_cfg_wr(char *page, char **start, off_t off,
 	 */
 	intr = preg->if_status;
 
-	len += sprintf(page + len, "PMC MSP PCI: After Cfg Wr\n");
-
-	/* Handle STDOUT calculations */
-	if (len <= off+count)
-		*eof = 1;
-	*start = page + off;
-	len -= off;
-	if (len > count)
-		len = count;
-	if (len < 0)
-		len = 0;
+	seq_puts(m, "PMC MSP PCI: After Cfg Wr\n");
+	return 0;
+}
 
-	return len;
+static int gen_pci_cfg_wr_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, gen_pci_cfg_wr_show, NULL);
 }
 
+static const struct file_operations gen_pci_cfg_wr_fops = {
+	.open		= gen_pci_cfg_wr_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 /*****************************************************************************
  *
  *  FUNCTION: pci_proc_init
@@ -199,10 +188,8 @@ static int gen_pci_cfg_wr(char *page, char **start, off_t off,
  ****************************************************************************/
 static void pci_proc_init(void)
 {
-	create_proc_read_entry("pmc_msp_pci_rd_cnt", 0, NULL,
-				read_msp_pci_counts, NULL);
-	create_proc_read_entry("pmc_msp_pci_cfg_wr", 0, NULL,
-				gen_pci_cfg_wr, NULL);
+	proc_create("pmc_msp_pci_rd_cnt", 0, NULL, &msp_pci_rd_cnt_fops);
+	proc_create("pmc_msp_pci_cfg_wr", 0, NULL, &gen_pci_cfg_wr_fops);
 }
 #endif /* CONFIG_PROC_FS && PCI_COUNTERS */
 
diff --git a/arch/mips/sibyte/sb1250/bus_watcher.c b/arch/mips/sibyte/sb1250/bus_watcher.c
index e651105..cb1e3cb 100644
--- a/arch/mips/sibyte/sb1250/bus_watcher.c
+++ b/arch/mips/sibyte/sb1250/bus_watcher.c
@@ -30,6 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <asm/io.h>
 
 #include <asm/sibyte/sb1250.h>
@@ -99,63 +100,60 @@ void check_bus_watcher(void)
 		printk("Bus watcher indicates no error\n");
 }
 
-static int bw_print_buffer(char *page, struct bw_stats_struct *stats)
+#ifdef CONFIG_PROC_FS
+
+/* For simplicity, I want to assume a single read is required each
+   time */
+static int bw_proc_show(struct seq_file *m, void *v)
 {
-	int len;
-
-	len = sprintf(page, "SiByte Bus Watcher statistics\n");
-	len += sprintf(page+len, "-----------------------------\n");
-	len += sprintf(page+len, "L2-d-cor %8ld\nL2-d-bad %8ld\n",
-		       stats->l2_cor_d, stats->l2_bad_d);
-	len += sprintf(page+len, "L2-t-cor %8ld\nL2-t-bad %8ld\n",
-		       stats->l2_cor_t, stats->l2_bad_t);
-	len += sprintf(page+len, "MC-d-cor %8ld\nMC-d-bad %8ld\n",
-		       stats->mem_cor_d, stats->mem_bad_d);
-	len += sprintf(page+len, "IO-err   %8ld\n", stats->bus_error);
-	len += sprintf(page+len, "\nLast recorded signature:\n");
-	len += sprintf(page+len, "Request %02x from %d, answered by %d with Dcode %d\n",
-		       (unsigned int)(G_SCD_BERR_TID(stats->status) & 0x3f),
-		       (int)(G_SCD_BERR_TID(stats->status) >> 6),
-		       (int)G_SCD_BERR_RID(stats->status),
-		       (int)G_SCD_BERR_DCODE(stats->status));
+	struct bw_stats_struct *stats = m->private;
+
+	seq_puts(m, "SiByte Bus Watcher statistics\n");
+	seq_puts(m, "-----------------------------\n");
+	seq_printf(m, "L2-d-cor %8ld\nL2-d-bad %8ld\n",
+		   stats->l2_cor_d, stats->l2_bad_d);
+	seq_printf(m, "L2-t-cor %8ld\nL2-t-bad %8ld\n",
+		   stats->l2_cor_t, stats->l2_bad_t);
+	seq_printf(m, "MC-d-cor %8ld\nMC-d-bad %8ld\n",
+		   stats->mem_cor_d, stats->mem_bad_d);
+	seq_printf(m, "IO-err   %8ld\n", stats->bus_error);
+	seq_puts(m, "\nLast recorded signature:\n");
+	seq_printf(m, "Request %02x from %d, answered by %d with Dcode %d\n",
+		   (unsigned int)(G_SCD_BERR_TID(stats->status) & 0x3f),
+		   (int)(G_SCD_BERR_TID(stats->status) >> 6),
+		   (int)G_SCD_BERR_RID(stats->status),
+		   (int)G_SCD_BERR_DCODE(stats->status));
 	/* XXXKW indicate multiple errors between printings, or stats
 	   collection (or both)? */
 	if (stats->status & M_SCD_BERR_MULTERRS)
-		len += sprintf(page+len, "Multiple errors observed since last check.\n");
+		seq_puts(m, "Multiple errors observed since last check.\n");
 	if (stats->status_printed) {
-		len += sprintf(page+len, "(no change since last printing)\n");
+		seq_puts(m, "(no change since last printing)\n");
 	} else {
 		stats->status_printed = 1;
 	}
 
-	return len;
+	return 0;
 }
 
-#ifdef CONFIG_PROC_FS
-
-/* For simplicity, I want to assume a single read is required each
-   time */
-static int bw_read_proc(char *page, char **start, off_t off,
-			int count, int *eof, void *data)
+static int bw_proc_open(struct inode *inode, struct file *file)
 {
-	int len;
-
-	if (off == 0) {
-		len = bw_print_buffer(page, data);
-		*start = page;
-	} else {
-		len = 0;
-		*eof = 1;
-	}
-	return len;
+	return single_open(file, bw_proc_show, PDE_DATA(inode));
 }
 
+static const struct file_operations bw_proc_fops = {
+	.open		= bw_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static void create_proc_decoder(struct bw_stats_struct *stats)
 {
 	struct proc_dir_entry *ent;
 
-	ent = create_proc_read_entry("bus_watcher", S_IWUSR | S_IRUGO, NULL,
-				     bw_read_proc, stats);
+	ent = proc_create_data("bus_watcher", S_IWUSR | S_IRUGO, NULL,
+			       &bw_proc_fops, stats);
 	if (!ent) {
 		printk(KERN_INFO "Unable to initialize bus_watcher /proc entry\n");
 		return;
@@ -210,11 +208,6 @@ static irqreturn_t sibyte_bw_int(int irq, void *data)
 	stats->bus_error += G_SCD_MEM_BUSERR(cntr);
 	csr_out32(0, IOADDR(A_BUS_MEM_IO_ERRORS));
 
-#ifndef CONFIG_PROC_FS
-	bw_print_buffer(bw_buf, stats);
-	printk(bw_buf);
-#endif
-
 	return IRQ_HANDLED;
 }
 

