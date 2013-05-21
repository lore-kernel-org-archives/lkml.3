Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3EUHG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:06:26 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:56698 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3EUHGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:06:24 -0400
Date: Tue, 21 May 2013 09:06:17 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.10-rc3
Message-ID: <20130521090617.31133499@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052107-0542-0000-0000-0000054FFE61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
An additional sysfs attribute for channel paths and a couple of bux fixes.

Alexander Shiyan (1):
      s390: remove non existent reference to GENERIC_KERNEL_THREAD

Christian Borntraeger (4):
      s390: disable pfmf for clear page instruction
      s390: fix gmap_ipte_notifier vs. software dirty pages
      s390/xpram: mark xpram as non-rotational
      s390/pgtable: fix ipte notify bit

Heiko Carstens (2):
      s390/disassembler: prevent endless loop in print_fn_code()
      s390/ftrace: fix mcount adjustment

Martin Schwidefsky (1):
      s390/smp: fix cpu re-scan vs. cpu state

Peter Oberparleiter (1):
      s390/cio: add channel ID sysfs attribute

 arch/s390/Kconfig               |    1 -
 arch/s390/include/asm/ftrace.h  |   12 +++++++-----
 arch/s390/include/asm/page.h    |   20 ++++++++------------
 arch/s390/include/asm/pgtable.h |    4 ++--
 arch/s390/kernel/dis.c          |    2 ++
 arch/s390/kernel/ftrace.c       |    9 ++-------
 arch/s390/kernel/mcount.S       |    2 ++
 arch/s390/kernel/mcount64.S     |    2 ++
 arch/s390/kernel/smp.c          |    2 +-
 arch/s390/mm/pgtable.c          |    3 +--
 drivers/s390/block/xpram.c      |    1 +
 drivers/s390/cio/chp.c          |   36 ++++++++++++++++++++++++++++++++++++
 drivers/s390/cio/chsc.h         |    4 +++-
 13 files changed, 67 insertions(+), 31 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2c9789d..da183c5 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -98,7 +98,6 @@ config S390
 	select CLONE_BACKWARDS2
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CPU_DEVICES if !SMP
-	select GENERIC_KERNEL_THREAD
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL_OLD
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index b7931fa..bf246da 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -9,11 +9,6 @@ struct dyn_arch_ftrace { };
 
 #define MCOUNT_ADDR ((long)_mcount)
 
-#ifdef CONFIG_64BIT
-#define MCOUNT_INSN_SIZE  12
-#else
-#define MCOUNT_INSN_SIZE  20
-#endif
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
@@ -21,4 +16,11 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 }
 
 #endif /* __ASSEMBLY__ */
+
+#ifdef CONFIG_64BIT
+#define MCOUNT_INSN_SIZE  12
+#else
+#define MCOUNT_INSN_SIZE  22
+#endif
+
 #endif /* _ASM_S390_FTRACE_H */
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 75ce9b0..5d64fb7 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -32,7 +32,7 @@
 
 void storage_key_init_range(unsigned long start, unsigned long end);
 
-static unsigned long pfmf(unsigned long function, unsigned long address)
+static inline unsigned long pfmf(unsigned long function, unsigned long address)
 {
 	asm volatile(
 		"	.insn	rre,0xb9af0000,%[function],%[address]"
@@ -44,17 +44,13 @@ static unsigned long pfmf(unsigned long function, unsigned long address)
 
 static inline void clear_page(void *page)
 {
-	if (MACHINE_HAS_PFMF) {
-		pfmf(0x10000, (unsigned long)page);
-	} else {
-		register unsigned long reg1 asm ("1") = 0;
-		register void *reg2 asm ("2") = page;
-		register unsigned long reg3 asm ("3") = 4096;
-		asm volatile(
-			"	mvcl	2,0"
-			: "+d" (reg2), "+d" (reg3) : "d" (reg1)
-			: "memory", "cc");
-	}
+	register unsigned long reg1 asm ("1") = 0;
+	register void *reg2 asm ("2") = page;
+	register unsigned long reg3 asm ("3") = 4096;
+	asm volatile(
+		"	mvcl	2,0"
+		: "+d" (reg2), "+d" (reg3) : "d" (reg1)
+		: "memory", "cc");
 }
 
 static inline void copy_page(void *to, void *from)
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 4105b82..0f0de30 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -306,7 +306,7 @@ extern unsigned long MODULES_END;
 #define RCP_HC_BIT	0x00200000UL
 #define RCP_GR_BIT	0x00040000UL
 #define RCP_GC_BIT	0x00020000UL
-#define RCP_IN_BIT	0x00008000UL	/* IPTE notify bit */
+#define RCP_IN_BIT	0x00002000UL	/* IPTE notify bit */
 
 /* User dirty / referenced bit for KVM's migration feature */
 #define KVM_UR_BIT	0x00008000UL
@@ -374,7 +374,7 @@ extern unsigned long MODULES_END;
 #define RCP_HC_BIT	0x0020000000000000UL
 #define RCP_GR_BIT	0x0004000000000000UL
 #define RCP_GC_BIT	0x0002000000000000UL
-#define RCP_IN_BIT	0x0000800000000000UL	/* IPTE notify bit */
+#define RCP_IN_BIT	0x0000200000000000UL	/* IPTE notify bit */
 
 /* User dirty / referenced bit for KVM's migration feature */
 #define KVM_UR_BIT	0x0000800000000000UL
diff --git a/arch/s390/kernel/dis.c b/arch/s390/kernel/dis.c
index 7f4a4a8..be87d3e 100644
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -1862,6 +1862,8 @@ void print_fn_code(unsigned char *code, unsigned long len)
 	while (len) {
 		ptr = buffer;
 		opsize = insn_length(*code);
+		if (opsize > len)
+			break;
 		ptr += sprintf(ptr, "%p: ", code);
 		for (i = 0; i < opsize; i++)
 			ptr += sprintf(ptr, "%02x", code[i]);
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 78bdf0e..e3043ae 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -16,12 +16,6 @@
 #include <trace/syscall.h>
 #include <asm/asm-offsets.h>
 
-#ifdef CONFIG_64BIT
-#define MCOUNT_OFFSET_RET 12
-#else
-#define MCOUNT_OFFSET_RET 22
-#endif
-
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 void ftrace_disable_code(void);
@@ -155,9 +149,10 @@ unsigned long __kprobes prepare_ftrace_return(unsigned long parent,
 
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		goto out;
+	ip = (ip & PSW_ADDR_INSN) - MCOUNT_INSN_SIZE;
 	if (ftrace_push_return_trace(parent, ip, &trace.depth, 0) == -EBUSY)
 		goto out;
-	trace.func = (ip & PSW_ADDR_INSN) - MCOUNT_OFFSET_RET;
+	trace.func = ip;
 	/* Only trace if the calling function expects to. */
 	if (!ftrace_graph_entry(&trace)) {
 		current->curr_ret_stack--;
diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
index 4567ce2..08dcf21 100644
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -7,6 +7,7 @@
 
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
+#include <asm/ftrace.h>
 
 	.section .kprobes.text, "ax"
 
@@ -33,6 +34,7 @@ ENTRY(ftrace_caller)
 	la	%r2,0(%r14)
 	st	%r0,__SF_BACKCHAIN(%r15)
 	la	%r3,0(%r3)
+	ahi	%r2,-MCOUNT_INSN_SIZE
 	l	%r14,0b-0b(%r1)
 	l	%r14,0(%r14)
 	basr	%r14,%r14
diff --git a/arch/s390/kernel/mcount64.S b/arch/s390/kernel/mcount64.S
index 1133219..1c52eae 100644
--- a/arch/s390/kernel/mcount64.S
+++ b/arch/s390/kernel/mcount64.S
@@ -7,6 +7,7 @@
 
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
+#include <asm/ftrace.h>
 
 	.section .kprobes.text, "ax"
 
@@ -29,6 +30,7 @@ ENTRY(ftrace_caller)
 	stg	%r1,__SF_BACKCHAIN(%r15)
 	lgr	%r2,%r14
 	lg	%r3,168(%r15)
+	aghi	%r2,-MCOUNT_INSN_SIZE
 	larl	%r14,ftrace_trace_function
 	lg	%r14,0(%r14)
 	basr	%r14,%r14
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 8074cb4..05674b6 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -645,7 +645,7 @@ static int __cpuinit __smp_rescan_cpus(struct sclp_cpu_info *info,
 			continue;
 		pcpu = pcpu_devices + cpu;
 		pcpu->address = info->cpu[i].address;
-		pcpu->state = (cpu >= info->configured) ?
+		pcpu->state = (i >= info->configured) ?
 			CPU_STATE_STANDBY : CPU_STATE_CONFIGURED;
 		smp_cpu_set_polarization(cpu, POLARIZATION_UNKNOWN);
 		set_cpu_present(cpu, true);
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 7805ddc..18dc417 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -677,8 +677,7 @@ int gmap_ipte_notify(struct gmap *gmap, unsigned long start, unsigned long len)
 			break;
 		}
 		/* Get the page mapped */
-		if (get_user_pages(current, gmap->mm, addr, 1, 1, 0,
-				   NULL, NULL) != 1) {
+		if (fixup_user_fault(current, gmap->mm, addr, FAULT_FLAG_WRITE)) {
 			rc = -EFAULT;
 			break;
 		}
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index 690c333..464dd29 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -343,6 +343,7 @@ static int __init xpram_setup_blkdev(void)
 			put_disk(xpram_disks[i]);
 			goto out;
 		}
+		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, xpram_queues[i]);
 		blk_queue_make_request(xpram_queues[i], xpram_make_request);
 		blk_queue_logical_block_size(xpram_queues[i], 4096);
 	}
diff --git a/drivers/s390/cio/chp.c b/drivers/s390/cio/chp.c
index 21fabc6..6c440d4 100644
--- a/drivers/s390/cio/chp.c
+++ b/drivers/s390/cio/chp.c
@@ -352,12 +352,48 @@ static ssize_t chp_shared_show(struct device *dev,
 
 static DEVICE_ATTR(shared, 0444, chp_shared_show, NULL);
 
+static ssize_t chp_chid_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct channel_path *chp = to_channelpath(dev);
+	ssize_t rc;
+
+	mutex_lock(&chp->lock);
+	if (chp->desc_fmt1.flags & 0x10)
+		rc = sprintf(buf, "%04x\n", chp->desc_fmt1.chid);
+	else
+		rc = 0;
+	mutex_unlock(&chp->lock);
+
+	return rc;
+}
+static DEVICE_ATTR(chid, 0444, chp_chid_show, NULL);
+
+static ssize_t chp_chid_external_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct channel_path *chp = to_channelpath(dev);
+	ssize_t rc;
+
+	mutex_lock(&chp->lock);
+	if (chp->desc_fmt1.flags & 0x10)
+		rc = sprintf(buf, "%x\n", chp->desc_fmt1.flags & 0x8 ? 1 : 0);
+	else
+		rc = 0;
+	mutex_unlock(&chp->lock);
+
+	return rc;
+}
+static DEVICE_ATTR(chid_external, 0444, chp_chid_external_show, NULL);
+
 static struct attribute *chp_attrs[] = {
 	&dev_attr_status.attr,
 	&dev_attr_configure.attr,
 	&dev_attr_type.attr,
 	&dev_attr_cmg.attr,
 	&dev_attr_shared.attr,
+	&dev_attr_chid.attr,
+	&dev_attr_chid_external.attr,
 	NULL,
 };
 static struct attribute_group chp_attr_group = {
diff --git a/drivers/s390/cio/chsc.h b/drivers/s390/cio/chsc.h
index 349d5fc..e7ef2a6 100644
--- a/drivers/s390/cio/chsc.h
+++ b/drivers/s390/cio/chsc.h
@@ -43,7 +43,9 @@ struct channel_path_desc_fmt1 {
 	u8 chpid;
 	u32:24;
 	u8 chpp;
-	u32 unused[3];
+	u32 unused[2];
+	u16 chid;
+	u32:16;
 	u16 mdc;
 	u16:13;
 	u8 r:1;

