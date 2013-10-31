Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3JaJ5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 05:57:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3JaJ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 05:57:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.24
Date: Thu, 31 Oct 2013 09:57:00 +0000
Message-Id: <1383213420-8503-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1383213420-8503-1-git-send-email-luis.henriques@canonical.com>
References: <1383213420-8503-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 6da3d8e..f51c204 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .23
+EXTRAVERSION = .24
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
index fce38a6..36b69df 100644
--- a/arch/arm/include/asm/syscall.h
+++ b/arch/arm/include/asm/syscall.h
@@ -51,6 +51,9 @@ static inline void syscall_get_arguments(struct task_struct *task,
 					 unsigned int i, unsigned int n,
 					 unsigned long *args)
 {
+	if (n == 0)
+		return;
+
 	if (i + n > SYSCALL_MAX_ARGS) {
 		unsigned long *args_bad = args + SYSCALL_MAX_ARGS - i;
 		unsigned int n_bad = n + i - SYSCALL_MAX_ARGS;
@@ -75,6 +78,9 @@ static inline void syscall_set_arguments(struct task_struct *task,
 					 unsigned int i, unsigned int n,
 					 const unsigned long *args)
 {
+	if (n == 0)
+		return;
+
 	if (i + n > SYSCALL_MAX_ARGS) {
 		pr_warning("%s called with max args %d, handling only %d\n",
 			   __func__, i + n, SYSCALL_MAX_ARGS);
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index f54d592..01ad1f6 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -99,6 +99,9 @@ void show_mem(unsigned int filter)
 	printk("Mem-info:\n");
 	show_free_areas(filter);
 
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
+
 	for_each_bank (i, mi) {
 		struct membank *bank = &mi->bank[i];
 		unsigned int pfn1, pfn2;
diff --git a/arch/ia64/mm/contig.c b/arch/ia64/mm/contig.c
index 1516d1d..f2652fc 100644
--- a/arch/ia64/mm/contig.c
+++ b/arch/ia64/mm/contig.c
@@ -47,6 +47,8 @@ void show_mem(unsigned int filter)
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas(filter);
 	printk(KERN_INFO "Node memory in pages:\n");
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
 	for_each_online_pgdat(pgdat) {
 		unsigned long present;
 		unsigned long flags;
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index c641333..2230817 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -623,6 +623,8 @@ void show_mem(unsigned int filter)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas(filter);
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
 	printk(KERN_INFO "Node memory in pages:\n");
 	for_each_online_pgdat(pgdat) {
 		unsigned long present;
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 45ba99f..71d7d72 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -810,14 +810,14 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 	else {
 
 	    /*
-	     * The kernel should never fault on its own address space.
+	     * The kernel should never fault on its own address space,
+	     * unless pagefault_disable() was called before.
 	     */
 
-	    if (fault_space == 0) 
+	    if (fault_space == 0 && !in_atomic())
 	    {
 		pdc_chassis_send_status(PDC_CHASSIS_DIRECT_PANIC);
 		parisc_terminate("Kernel Fault", regs, code, fault_address);
-	
 	    }
 	}
 
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 3ac462d..cf2da13 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -697,6 +697,8 @@ void show_mem(unsigned int filter)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas(filter);
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
 #ifndef CONFIG_DISCONTIGMEM
 	i = max_mapnr;
 	while (i-- > 0) {
diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index 7ebbae0..f62fda1 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -307,6 +307,7 @@ static void parse_system_parameter_string(struct seq_file *m)
 				__pa(rtas_data_buf),
 				RTAS_DATA_BUF_SIZE);
 	memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
+	local_buffer[SPLPAR_MAXLENGTH - 1] = '\0';
 	spin_unlock(&rtas_data_buf_lock);
 
 	if (call_status != 0) {
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index a1044f4..86af817 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -963,7 +963,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_206)
 BEGIN_FTR_SECTION
 	mfspr	r8, SPRN_DSCR
 	ld	r7, HSTATE_DSCR(r13)
-	std	r8, VCPU_DSCR(r7)
+	std	r8, VCPU_DSCR(r9)
 	mtspr	SPRN_DSCR, r7
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_206)
 
diff --git a/arch/powerpc/lib/checksum_64.S b/arch/powerpc/lib/checksum_64.S
index afa2eba..3cdbc64 100644
--- a/arch/powerpc/lib/checksum_64.S
+++ b/arch/powerpc/lib/checksum_64.S
@@ -229,19 +229,35 @@ _GLOBAL(csum_partial)
 	blr
 
 
-	.macro source
+	.macro srcnr
 100:
 	.section __ex_table,"a"
 	.align 3
-	.llong 100b,.Lsrc_error
+	.llong 100b,.Lsrc_error_nr
 	.previous
 	.endm
 
-	.macro dest
+	.macro source
+150:
+	.section __ex_table,"a"
+	.align 3
+	.llong 150b,.Lsrc_error
+	.previous
+	.endm
+
+	.macro dstnr
 200:
 	.section __ex_table,"a"
 	.align 3
-	.llong 200b,.Ldest_error
+	.llong 200b,.Ldest_error_nr
+	.previous
+	.endm
+
+	.macro dest
+250:
+	.section __ex_table,"a"
+	.align 3
+	.llong 250b,.Ldest_error
 	.previous
 	.endm
 
@@ -277,11 +293,11 @@ _GLOBAL(csum_partial_copy_generic)
 	mtctr	r6
 
 1:
-source;	lhz	r6,0(r3)		/* align to doubleword */
+srcnr;	lhz	r6,0(r3)		/* align to doubleword */
 	subi	r5,r5,2
 	addi	r3,r3,2
 	adde	r0,r0,r6
-dest;	sth	r6,0(r4)
+dstnr;	sth	r6,0(r4)
 	addi	r4,r4,2
 	bdnz	1b
 
@@ -395,10 +411,10 @@ dest;	std	r16,56(r4)
 
 	mtctr	r6
 3:
-source;	ld	r6,0(r3)
+srcnr;	ld	r6,0(r3)
 	addi	r3,r3,8
 	adde	r0,r0,r6
-dest;	std	r6,0(r4)
+dstnr;	std	r6,0(r4)
 	addi	r4,r4,8
 	bdnz	3b
 
@@ -408,10 +424,10 @@ dest;	std	r6,0(r4)
 	srdi.	r6,r5,2
 	beq	.Lcopy_tail_halfword
 
-source;	lwz	r6,0(r3)
+srcnr;	lwz	r6,0(r3)
 	addi	r3,r3,4
 	adde	r0,r0,r6
-dest;	stw	r6,0(r4)
+dstnr;	stw	r6,0(r4)
 	addi	r4,r4,4
 	subi	r5,r5,4
 
@@ -419,10 +435,10 @@ dest;	stw	r6,0(r4)
 	srdi.	r6,r5,1
 	beq	.Lcopy_tail_byte
 
-source;	lhz	r6,0(r3)
+srcnr;	lhz	r6,0(r3)
 	addi	r3,r3,2
 	adde	r0,r0,r6
-dest;	sth	r6,0(r4)
+dstnr;	sth	r6,0(r4)
 	addi	r4,r4,2
 	subi	r5,r5,2
 
@@ -430,10 +446,10 @@ dest;	sth	r6,0(r4)
 	andi.	r6,r5,1
 	beq	.Lcopy_finish
 
-source;	lbz	r6,0(r3)
+srcnr;	lbz	r6,0(r3)
 	sldi	r9,r6,8			/* Pad the byte out to 16 bits */
 	adde	r0,r0,r9
-dest;	stb	r6,0(r4)
+dstnr;	stb	r6,0(r4)
 
 .Lcopy_finish:
 	addze	r0,r0			/* add in final carry */
@@ -443,6 +459,11 @@ dest;	stb	r6,0(r4)
 	blr
 
 .Lsrc_error:
+	ld	r14,STK_REG(r14)(r1)
+	ld	r15,STK_REG(r15)(r1)
+	ld	r16,STK_REG(r16)(r1)
+	addi	r1,r1,STACKFRAMESIZE
+.Lsrc_error_nr:
 	cmpdi	0,r7,0
 	beqlr
 	li	r6,-EFAULT
@@ -450,6 +471,11 @@ dest;	stb	r6,0(r4)
 	blr
 
 .Ldest_error:
+	ld	r14,STK_REG(r14)(r1)
+	ld	r15,STK_REG(r15)(r1)
+	ld	r16,STK_REG(r16)(r1)
+	addi	r1,r1,STACKFRAMESIZE
+.Ldest_error_nr:
 	cmpdi	0,r8,0
 	beqlr
 	li	r6,-EFAULT
diff --git a/arch/tile/include/asm/percpu.h b/arch/tile/include/asm/percpu.h
index 63294f5..4f7ae39 100644
--- a/arch/tile/include/asm/percpu.h
+++ b/arch/tile/include/asm/percpu.h
@@ -15,9 +15,37 @@
 #ifndef _ASM_TILE_PERCPU_H
 #define _ASM_TILE_PERCPU_H
 
-register unsigned long __my_cpu_offset __asm__("tp");
-#define __my_cpu_offset __my_cpu_offset
-#define set_my_cpu_offset(tp) (__my_cpu_offset = (tp))
+register unsigned long my_cpu_offset_reg asm("tp");
+
+#ifdef CONFIG_PREEMPT
+/*
+ * For full preemption, we can't just use the register variable
+ * directly, since we need barrier() to hazard against it, causing the
+ * compiler to reload anything computed from a previous "tp" value.
+ * But we also don't want to use volatile asm, since we'd like the
+ * compiler to be able to cache the value across multiple percpu reads.
+ * So we use a fake stack read as a hazard against barrier().
+ * The 'U' constraint is like 'm' but disallows postincrement.
+ */
+static inline unsigned long __my_cpu_offset(void)
+{
+	unsigned long tp;
+	register unsigned long *sp asm("sp");
+	asm("move %0, tp" : "=r" (tp) : "U" (*sp));
+	return tp;
+}
+#define __my_cpu_offset __my_cpu_offset()
+#else
+/*
+ * We don't need to hazard against barrier() since "tp" doesn't ever
+ * change with PREEMPT_NONE, and with PREEMPT_VOLUNTARY it only
+ * changes at function call points, at which we are already re-reading
+ * the value of "tp" due to "my_cpu_offset_reg" being a global variable.
+ */
+#define __my_cpu_offset my_cpu_offset_reg
+#endif
+
+#define set_my_cpu_offset(tp) (my_cpu_offset_reg = (tp))
 
 #include <asm-generic/percpu.h>
 
diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
index de186bd..6444828 100644
--- a/arch/unicore32/mm/init.c
+++ b/arch/unicore32/mm/init.c
@@ -66,6 +66,9 @@ void show_mem(unsigned int filter)
 	printk(KERN_DEFAULT "Mem-info:\n");
 	show_free_areas(filter);
 
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
+
 	for_each_bank(i, mi) {
 		struct membank *bank = &mi->bank[i];
 		unsigned int pfn1, pfn2;
diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index f40acef..a6977e1 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -39,6 +39,7 @@
 #include <linux/ipmi.h>
 #include <linux/device.h>
 #include <linux/pnp.h>
+#include <linux/spinlock.h>
 
 MODULE_AUTHOR("Zhao Yakui");
 MODULE_DESCRIPTION("ACPI IPMI Opregion driver");
@@ -57,7 +58,7 @@ struct acpi_ipmi_device {
 	struct list_head head;
 	/* the IPMI request message list */
 	struct list_head tx_msg_list;
-	struct mutex	tx_msg_lock;
+	spinlock_t	tx_msg_lock;
 	acpi_handle handle;
 	struct pnp_dev *pnp_dev;
 	ipmi_user_t	user_interface;
@@ -147,6 +148,7 @@ static void acpi_format_ipmi_msg(struct acpi_ipmi_msg *tx_msg,
 	struct kernel_ipmi_msg *msg;
 	struct acpi_ipmi_buffer *buffer;
 	struct acpi_ipmi_device *device;
+	unsigned long flags;
 
 	msg = &tx_msg->tx_message;
 	/*
@@ -177,10 +179,10 @@ static void acpi_format_ipmi_msg(struct acpi_ipmi_msg *tx_msg,
 
 	/* Get the msgid */
 	device = tx_msg->device;
-	mutex_lock(&device->tx_msg_lock);
+	spin_lock_irqsave(&device->tx_msg_lock, flags);
 	device->curr_msgid++;
 	tx_msg->tx_msgid = device->curr_msgid;
-	mutex_unlock(&device->tx_msg_lock);
+	spin_unlock_irqrestore(&device->tx_msg_lock, flags);
 }
 
 static void acpi_format_ipmi_response(struct acpi_ipmi_msg *msg,
@@ -242,6 +244,7 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 	int msg_found = 0;
 	struct acpi_ipmi_msg *tx_msg;
 	struct pnp_dev *pnp_dev = ipmi_device->pnp_dev;
+	unsigned long flags;
 
 	if (msg->user != ipmi_device->user_interface) {
 		dev_warn(&pnp_dev->dev, "Unexpected response is returned. "
@@ -250,7 +253,7 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 		ipmi_free_recv_msg(msg);
 		return;
 	}
-	mutex_lock(&ipmi_device->tx_msg_lock);
+	spin_lock_irqsave(&ipmi_device->tx_msg_lock, flags);
 	list_for_each_entry(tx_msg, &ipmi_device->tx_msg_list, head) {
 		if (msg->msgid == tx_msg->tx_msgid) {
 			msg_found = 1;
@@ -258,7 +261,7 @@ static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
 		}
 	}
 
-	mutex_unlock(&ipmi_device->tx_msg_lock);
+	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
 	if (!msg_found) {
 		dev_warn(&pnp_dev->dev, "Unexpected response (msg id %ld) is "
 			"returned.\n", msg->msgid);
@@ -378,6 +381,7 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 	struct acpi_ipmi_device *ipmi_device = handler_context;
 	int err, rem_time;
 	acpi_status status;
+	unsigned long flags;
 	/*
 	 * IPMI opregion message.
 	 * IPMI message is firstly written to the BMC and system software
@@ -395,9 +399,9 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 		return AE_NO_MEMORY;
 
 	acpi_format_ipmi_msg(tx_msg, address, value);
-	mutex_lock(&ipmi_device->tx_msg_lock);
+	spin_lock_irqsave(&ipmi_device->tx_msg_lock, flags);
 	list_add_tail(&tx_msg->head, &ipmi_device->tx_msg_list);
-	mutex_unlock(&ipmi_device->tx_msg_lock);
+	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
 	err = ipmi_request_settime(ipmi_device->user_interface,
 					&tx_msg->addr,
 					tx_msg->tx_msgid,
@@ -413,9 +417,9 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 	status = AE_OK;
 
 end_label:
-	mutex_lock(&ipmi_device->tx_msg_lock);
+	spin_lock_irqsave(&ipmi_device->tx_msg_lock, flags);
 	list_del(&tx_msg->head);
-	mutex_unlock(&ipmi_device->tx_msg_lock);
+	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
 	kfree(tx_msg);
 	return status;
 }
@@ -457,7 +461,7 @@ static void acpi_add_ipmi_device(struct acpi_ipmi_device *ipmi_device)
 
 	INIT_LIST_HEAD(&ipmi_device->head);
 
-	mutex_init(&ipmi_device->tx_msg_lock);
+	spin_lock_init(&ipmi_device->tx_msg_lock);
 	INIT_LIST_HEAD(&ipmi_device->tx_msg_list);
 	ipmi_install_space_handler(ipmi_device);
 
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 395d2e8..08b4e70 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -646,7 +646,7 @@ struct timer_rand_state {
  */
 void add_device_randomness(const void *buf, unsigned int size)
 {
-	unsigned long time = get_cycles() ^ jiffies;
+	unsigned long time = random_get_entropy() ^ jiffies;
 
 	mix_pool_bytes(&input_pool, buf, size, NULL);
 	mix_pool_bytes(&input_pool, &time, sizeof(time), NULL);
@@ -683,7 +683,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		goto out;
 
 	sample.jiffies = jiffies;
-	sample.cycles = get_cycles();
+	sample.cycles = random_get_entropy();
 	sample.num = num;
 	mix_pool_bytes(&input_pool, &sample, sizeof(sample), NULL);
 
@@ -750,7 +750,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
-	__u32			input[4], cycles = get_cycles();
+	__u32			input[4], cycles = random_get_entropy();
 
 	input[0] = cycles ^ jiffies;
 	input[1] = irq;
@@ -1447,12 +1447,11 @@ ctl_table random_table[] = {
 
 static u32 random_int_secret[MD5_MESSAGE_BYTES / 4] ____cacheline_aligned;
 
-static int __init random_int_secret_init(void)
+int random_int_secret_init(void)
 {
 	get_random_bytes(random_int_secret, sizeof(random_int_secret));
 	return 0;
 }
-late_initcall(random_int_secret_init);
 
 /*
  * Get a random word for internal kernel use only. Similar to urandom but
@@ -1471,7 +1470,7 @@ unsigned int get_random_int(void)
 
 	hash = get_cpu_var(get_random_int_hash);
 
-	hash[0] += current->pid + jiffies + get_cycles();
+	hash[0] += current->pid + jiffies + random_get_entropy();
 	md5_transform(hash, random_int_secret);
 	ret = hash[0];
 	put_cpu_var(get_random_int_hash);
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 9d90e8c..7ab4b1d 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -64,6 +64,7 @@ void proc_fork_connector(struct task_struct *task)
 
 	msg = (struct cn_msg*)buffer;
 	ev = (struct proc_event*)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -79,6 +80,7 @@ void proc_fork_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	/*  If cn_netlink_send() failed, the data is not sent */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
@@ -95,6 +97,7 @@ void proc_exec_connector(struct task_struct *task)
 
 	msg = (struct cn_msg*)buffer;
 	ev = (struct proc_event*)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -105,6 +108,7 @@ void proc_exec_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -121,6 +125,7 @@ void proc_id_connector(struct task_struct *task, int which_id)
 
 	msg = (struct cn_msg*)buffer;
 	ev = (struct proc_event*)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->what = which_id;
 	ev->event_data.id.process_pid = task->pid;
 	ev->event_data.id.process_tgid = task->tgid;
@@ -144,6 +149,7 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -159,6 +165,7 @@ void proc_sid_connector(struct task_struct *task)
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -169,6 +176,7 @@ void proc_sid_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -184,6 +192,7 @@ void proc_ptrace_connector(struct task_struct *task, int ptrace_id)
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -202,6 +211,7 @@ void proc_ptrace_connector(struct task_struct *task, int ptrace_id)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -217,6 +227,7 @@ void proc_comm_connector(struct task_struct *task)
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -228,6 +239,7 @@ void proc_comm_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -243,6 +255,7 @@ void proc_exit_connector(struct task_struct *task)
 
 	msg = (struct cn_msg*)buffer;
 	ev = (struct proc_event*)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -255,6 +268,7 @@ void proc_exit_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -278,6 +292,7 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 
 	msg = (struct cn_msg*)buffer;
 	ev = (struct proc_event*)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	msg->seq = rcvd_seq;
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -287,6 +302,7 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = rcvd_ack + 1;
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index dde6a0f..ea6efe8 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -157,17 +157,18 @@ static int cn_call_callback(struct sk_buff *skb)
 static void cn_rx_skb(struct sk_buff *__skb)
 {
 	struct nlmsghdr *nlh;
-	int err;
 	struct sk_buff *skb;
+	int len, err;
 
 	skb = skb_get(__skb);
 
 	if (skb->len >= NLMSG_SPACE(0)) {
 		nlh = nlmsg_hdr(skb);
+		len = nlmsg_len(nlh);
 
-		if (nlh->nlmsg_len < sizeof(struct cn_msg) ||
+		if (len < (int)sizeof(struct cn_msg) ||
 		    skb->len < nlh->nlmsg_len ||
-		    nlh->nlmsg_len > CONNECTOR_MAX_MSG_SIZE) {
+		    len > CONNECTOR_MAX_MSG_SIZE) {
 			kfree_skb(skb);
 			return;
 		}
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 650e2d7..9c2ae4e 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1766,7 +1766,7 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
 		rdev->config.evergreen.sx_max_export_size = 256;
 		rdev->config.evergreen.sx_max_export_pos_size = 64;
 		rdev->config.evergreen.sx_max_export_smx_size = 192;
-		rdev->config.evergreen.max_hw_contexts = 8;
+		rdev->config.evergreen.max_hw_contexts = 4;
 		rdev->config.evergreen.sq_num_cf_insts = 2;
 
 		rdev->config.evergreen.sc_prim_fifo_size = 0x40;
diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 0882b25..dbaf7f4 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -212,6 +212,7 @@ static int send_argument(const char *key)
 
 static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 {
+	u8 status, data = 0;
 	int i;
 
 	if (send_command(cmd) || send_argument(key)) {
@@ -219,6 +220,7 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 		return -EIO;
 	}
 
+	/* This has no effect on newer (2012) SMCs */
 	outb(len, APPLESMC_DATA_PORT);
 
 	for (i = 0; i < len; i++) {
@@ -229,6 +231,17 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 		buffer[i] = inb(APPLESMC_DATA_PORT);
 	}
 
+	/* Read the data port until bit0 is cleared */
+	for (i = 0; i < 16; i++) {
+		udelay(APPLESMC_MIN_WAIT);
+		status = inb(APPLESMC_CMD_PORT);
+		if (!(status & 0x01))
+			break;
+		data = inb(APPLESMC_DATA_PORT);
+	}
+	if (i)
+		pr_warn("flushed %d bytes, last value is: %d\n", i, data);
+
 	return 0;
 }
 
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 4caa8e6..2d2b1b7 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -269,6 +269,14 @@ static chunk_t area_location(struct pstore *ps, chunk_t area)
 	return NUM_SNAPSHOT_HDR_CHUNKS + ((ps->exceptions_per_area + 1) * area);
 }
 
+static void skip_metadata(struct pstore *ps)
+{
+	uint32_t stride = ps->exceptions_per_area + 1;
+	chunk_t next_free = ps->next_free;
+	if (sector_div(next_free, stride) == NUM_SNAPSHOT_HDR_CHUNKS)
+		ps->next_free++;
+}
+
 /*
  * Read or write a metadata area.  Remembering to skip the first
  * chunk which holds the header.
@@ -502,6 +510,8 @@ static int read_exceptions(struct pstore *ps,
 
 	ps->current_area--;
 
+	skip_metadata(ps);
+
 	return 0;
 }
 
@@ -616,8 +626,6 @@ static int persistent_prepare_exception(struct dm_exception_store *store,
 					struct dm_exception *e)
 {
 	struct pstore *ps = get_info(store);
-	uint32_t stride;
-	chunk_t next_free;
 	sector_t size = get_dev_size(dm_snap_cow(store->snap)->bdev);
 
 	/* Is there enough room ? */
@@ -630,10 +638,8 @@ static int persistent_prepare_exception(struct dm_exception_store *store,
 	 * Move onto the next free pending, making sure to take
 	 * into account the location of the metadata chunks.
 	 */
-	stride = (ps->exceptions_per_area + 1);
-	next_free = ++ps->next_free;
-	if (sector_div(next_free, stride) == 1)
-		ps->next_free++;
+	ps->next_free++;
+	skip_metadata(ps);
 
 	atomic_inc(&ps->pending_count);
 	return 0;
diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index 8fd1874..1ca38b0 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -776,7 +776,7 @@ static int sh_vou_try_fmt_vid_out(struct file *file, void *priv,
 	v4l_bound_align_image(&pix->width, 0, VOU_MAX_IMAGE_WIDTH, 1,
 			      &pix->height, 0, VOU_MAX_IMAGE_HEIGHT, 1, 0);
 
-	for (i = 0; ARRAY_SIZE(vou_fmt); i++)
+	for (i = 0; i < ARRAY_SIZE(vou_fmt); i++)
 		if (vou_fmt[i].pfmt == pix->pixelformat)
 			return 0;
 
diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 4972609..ffda218 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -665,14 +665,14 @@ static size_t can_get_size(const struct net_device *dev)
 	size_t size;
 
 	size = nla_total_size(sizeof(u32));   /* IFLA_CAN_STATE */
-	size += sizeof(struct can_ctrlmode);  /* IFLA_CAN_CTRLMODE */
+	size += nla_total_size(sizeof(struct can_ctrlmode));  /* IFLA_CAN_CTRLMODE */
 	size += nla_total_size(sizeof(u32));  /* IFLA_CAN_RESTART_MS */
-	size += sizeof(struct can_bittiming); /* IFLA_CAN_BITTIMING */
-	size += sizeof(struct can_clock);     /* IFLA_CAN_CLOCK */
+	size += nla_total_size(sizeof(struct can_bittiming)); /* IFLA_CAN_BITTIMING */
+	size += nla_total_size(sizeof(struct can_clock));     /* IFLA_CAN_CLOCK */
 	if (priv->do_get_berr_counter)        /* IFLA_CAN_BERR_COUNTER */
-		size += sizeof(struct can_berr_counter);
+		size += nla_total_size(sizeof(struct can_berr_counter));
 	if (priv->bittiming_const)	      /* IFLA_CAN_BITTIMING_CONST */
-		size += sizeof(struct can_bittiming_const);
+		size += nla_total_size(sizeof(struct can_bittiming_const));
 
 	return size;
 }
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 81d4741..2bf507b 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -61,7 +61,7 @@
 #define FLEXCAN_MCR_BCC			BIT(16)
 #define FLEXCAN_MCR_LPRIO_EN		BIT(13)
 #define FLEXCAN_MCR_AEN			BIT(12)
-#define FLEXCAN_MCR_MAXMB(x)		((x) & 0xf)
+#define FLEXCAN_MCR_MAXMB(x)		((x) & 0x1f)
 #define FLEXCAN_MCR_IDAM_A		(0 << 8)
 #define FLEXCAN_MCR_IDAM_B		(1 << 8)
 #define FLEXCAN_MCR_IDAM_C		(2 << 8)
@@ -668,7 +668,6 @@ static int flexcan_chip_start(struct net_device *dev)
 {
 	struct flexcan_priv *priv = netdev_priv(dev);
 	struct flexcan_regs __iomem *regs = priv->base;
-	unsigned int i;
 	int err;
 	u32 reg_mcr, reg_ctrl;
 
@@ -702,9 +701,11 @@ static int flexcan_chip_start(struct net_device *dev)
 	 *
 	 */
 	reg_mcr = flexcan_read(&regs->mcr);
+	reg_mcr &= ~FLEXCAN_MCR_MAXMB(0xff);
 	reg_mcr |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_FEN | FLEXCAN_MCR_HALT |
 		FLEXCAN_MCR_SUPV | FLEXCAN_MCR_WRN_EN |
-		FLEXCAN_MCR_IDAM_C | FLEXCAN_MCR_SRX_DIS;
+		FLEXCAN_MCR_IDAM_C | FLEXCAN_MCR_SRX_DIS |
+		FLEXCAN_MCR_MAXMB(FLEXCAN_TX_BUF_ID);
 	netdev_dbg(dev, "%s: writing mcr=0x%08x", __func__, reg_mcr);
 	flexcan_write(reg_mcr, &regs->mcr);
 
@@ -734,16 +735,9 @@ static int flexcan_chip_start(struct net_device *dev)
 	netdev_dbg(dev, "%s: writing ctrl=0x%08x", __func__, reg_ctrl);
 	flexcan_write(reg_ctrl, &regs->ctrl);
 
-	for (i = 0; i < ARRAY_SIZE(regs->cantxfg); i++) {
-		flexcan_write(0, &regs->cantxfg[i].can_ctrl);
-		flexcan_write(0, &regs->cantxfg[i].can_id);
-		flexcan_write(0, &regs->cantxfg[i].data[0]);
-		flexcan_write(0, &regs->cantxfg[i].data[1]);
-
-		/* put MB into rx queue */
-		flexcan_write(FLEXCAN_MB_CNT_CODE(0x4),
-			&regs->cantxfg[i].can_ctrl);
-	}
+	/* Abort any pending TX, mark Mailbox as INACTIVE */
+	flexcan_write(FLEXCAN_MB_CNT_CODE(0x4),
+		      &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
 
 	/* acceptance mask/acceptance code (accept everything) */
 	flexcan_write(0x0, &regs->rxgmask);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 2364f66..27c2843 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -566,6 +566,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 					 skb, cqe, cqe_idx)) {
 			if (tpa_info->parsing_flags & PARSING_FLAGS_VLAN)
 				__vlan_hwaccel_put_tag(skb, tpa_info->vlan_tag);
+			skb_record_rx_queue(skb, fp->rx_queue);
 			napi_gro_receive(&fp->napi, skb);
 		} else {
 			DP(NETIF_MSG_RX_STATUS,
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 7197e0f..02b03b5 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1273,15 +1273,13 @@ static void mib_counters_update(struct mv643xx_eth_private *mp)
 	p->rx_discard += rdlp(mp, RX_DISCARD_FRAME_CNT);
 	p->rx_overrun += rdlp(mp, RX_OVERRUN_FRAME_CNT);
 	spin_unlock_bh(&mp->mib_counters_lock);
-
-	mod_timer(&mp->mib_counters_timer, jiffies + 30 * HZ);
 }
 
 static void mib_counters_timer_wrapper(unsigned long _mp)
 {
 	struct mv643xx_eth_private *mp = (void *)_mp;
-
 	mib_counters_update(mp);
+	mod_timer(&mp->mib_counters_timer, jiffies + 30 * HZ);
 }
 
 
@@ -2368,6 +2366,7 @@ static int mv643xx_eth_open(struct net_device *dev)
 		mp->int_mask |= INT_TX_END_0 << i;
 	}
 
+	add_timer(&mp->mib_counters_timer);
 	port_start(mp);
 
 	wrlp(mp, INT_MASK_EXT, INT_EXT_LINK_PHY | INT_EXT_TX);
@@ -2915,7 +2914,6 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	mp->mib_counters_timer.data = (unsigned long)mp;
 	mp->mib_counters_timer.function = mib_counters_timer_wrapper;
 	mp->mib_counters_timer.expires = jiffies + 30 * HZ;
-	add_timer(&mp->mib_counters_timer);
 
 	spin_lock_init(&mp->mib_counters_lock);
 
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 762464e..e6911ee 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -876,8 +876,7 @@ static void emac_dev_mcast_set(struct net_device *ndev)
 		    netdev_mc_count(ndev) > EMAC_DEF_MAX_MULTICAST_ADDRESSES) {
 			mbp_enable = (mbp_enable | EMAC_MBP_RXMCAST);
 			emac_add_mcast(priv, EMAC_ALL_MULTI_SET, NULL);
-		}
-		if (!netdev_mc_empty(ndev)) {
+		} else if (!netdev_mc_empty(ndev)) {
 			struct netdev_hw_addr *ha;
 
 			mbp_enable = (mbp_enable | EMAC_MBP_RXMCAST);
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 1a62318..3710427 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -1972,6 +1972,7 @@ fst_get_iface(struct fst_card_info *card, struct fst_port_info *port,
 	}
 
 	i = port->index;
+	memset(&sync, 0, sizeof(sync));
 	sync.clock_rate = FST_RDL(card, portConfig[i].lineSpeed);
 	/* Lucky card and linux use same encoding here */
 	sync.clock_type = FST_RDB(card, portConfig[i].internalClock) ==
diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index feb7541..ccd496b 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -355,6 +355,7 @@ static int wanxl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			ifr->ifr_settings.size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
+		memset(&line, 0, sizeof(line));
 		line.clock_type = get_status(port)->clocking;
 		line.clock_rate = 0;
 		line.loopback = 0;
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1c60904..b81f2b6 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2181,6 +2181,13 @@ static int rt2800_get_gain_calibration_delta(struct rt2x00_dev *rt2x00dev)
 	int i;
 
 	/*
+	 * First check if temperature compensation is supported.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+	if (!rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_EXTERNAL_TX_ALC))
+		return 0;
+
+	/*
 	 * Read TSSI boundaries for temperature compensation from
 	 * the EEPROM.
 	 *
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index eea85da..be76eba 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -206,7 +206,8 @@ static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev,
 	return ret;
 }
 
-static int _pci_assign_resource(struct pci_dev *dev, int resno, int size, resource_size_t min_align)
+static int _pci_assign_resource(struct pci_dev *dev, int resno,
+				resource_size_t size, resource_size_t min_align)
 {
 	struct resource *res = dev->resource + resno;
 	struct pci_bus *bus;
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index d67ff42..987d3ef 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -122,6 +122,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Alcor Micro Corp. Hub */
 	{ USB_DEVICE(0x058f, 0x9254), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* MicroTouch Systems touchscreen */
+	{ USB_DEVICE(0x0596, 0x051e), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* appletouch */
 	{ USB_DEVICE(0x05ac, 0x021a), .driver_info = USB_QUIRK_RESET_RESUME },
 
@@ -155,6 +158,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Broadcom BCM92035DGROM BT dongle */
 	{ USB_DEVICE(0x0a5c, 0x2021), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* MAYA44USB sound device */
+	{ USB_DEVICE(0x0a92, 0x0091), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Action Semiconductor flash disk */
 	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =
 			USB_QUIRK_STRING_FETCH_255 },
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index b83a7b8..1b592dc 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1067,20 +1067,6 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
 		t1 = xhci_port_state_to_neutral(t1);
 		if (t1 != t2)
 			xhci_writel(xhci, t2, port_array[port_index]);
-
-		if (hcd->speed != HCD_USB3) {
-			/* enable remote wake up for USB 2.0 */
-			__le32 __iomem *addr;
-			u32 tmp;
-
-			/* Add one to the port status register address to get
-			 * the port power control register address.
-			 */
-			addr = port_array[port_index] + 1;
-			tmp = xhci_readl(xhci, addr);
-			tmp |= PORT_RWE;
-			xhci_writel(xhci, tmp, addr);
-		}
 	}
 	hcd->state = HC_STATE_SUSPENDED;
 	bus_state->next_statechange = jiffies + msecs_to_jiffies(10);
@@ -1159,20 +1145,6 @@ int xhci_bus_resume(struct usb_hcd *hcd)
 				xhci_ring_device(xhci, slot_id);
 		} else
 			xhci_writel(xhci, temp, port_array[port_index]);
-
-		if (hcd->speed != HCD_USB3) {
-			/* disable remote wake up for USB 2.0 */
-			__le32 __iomem *addr;
-			u32 tmp;
-
-			/* Add one to the port status register address to get
-			 * the port power control register address.
-			 */
-			addr = port_array[port_index] + 1;
-			tmp = xhci_readl(xhci, addr);
-			tmp &= ~PORT_RWE;
-			xhci_writel(xhci, tmp, addr);
-		}
 	}
 
 	(void) xhci_readl(xhci, &xhci->op_regs->command);
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 5e3ef3e..085d018 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -34,6 +34,9 @@
 #define PCI_VENDOR_ID_ETRON		0x1b6f
 #define PCI_DEVICE_ID_ASROCK_P67	0x7023
 
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI	0x8c31
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI	0x9c31
+
 static const char hcd_name[] = "xhci_hcd";
 
 /* called after powerup, by probe or system-pm "wakeup" */
@@ -67,6 +70,14 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 			xhci_dbg(xhci, "QUIRK: Fresco Logic xHC needs configure"
 					" endpoint cmd after reset endpoint\n");
 		}
+		if (pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
+				pdev->revision == 0x4) {
+			xhci->quirks |= XHCI_SLOW_SUSPEND;
+			xhci_dbg(xhci,
+				 "QUIRK: Fresco Logic xHC revision %u"
+				 "must be suspended extra slowly",
+				 pdev->revision);
+		}
 		/* Fresco Logic confirms: all revisions of this chip do not
 		 * support MSI, even though some of them claim to in their PCI
 		 * capabilities.
@@ -107,6 +118,15 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
 		xhci->quirks |= XHCI_AVOID_BEI;
 	}
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    (pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI)) {
+		/* Workaround for occasional spurious wakeups from S5 (or
+		 * any other sleep) on Haswell machines with LPT and LPT-LP
+		 * with the new Intel BIOS
+		 */
+		xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
+	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
@@ -213,6 +233,11 @@ static void xhci_pci_remove(struct pci_dev *dev)
 		usb_put_hcd(xhci->shared_hcd);
 	}
 	usb_hcd_pci_remove(dev);
+
+	/* Workaround for spurious wakeups at shutdown with HSW */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+		pci_set_power_state(dev, PCI_D3hot);
+
 	kfree(xhci);
 }
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index eb31daa..8ef76d2 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -776,12 +776,19 @@ void xhci_shutdown(struct usb_hcd *hcd)
 
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
+	/* Workaround for spurious wakeups at shutdown with HSW */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+		xhci_reset(xhci);
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
 
 	xhci_dbg(xhci, "xhci_shutdown completed - status = %x\n",
 		    xhci_readl(xhci, &xhci->op_regs->status));
+
+	/* Yet another workaround for spurious wakeups at shutdown with HSW */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+		pci_set_power_state(to_pci_dev(hcd->self.controller), PCI_D3hot);
 }
 
 #ifdef CONFIG_PM
@@ -883,6 +890,7 @@ static void xhci_clear_command_ring(struct xhci_hcd *xhci)
 int xhci_suspend(struct xhci_hcd *xhci)
 {
 	int			rc = 0;
+	unsigned int		delay = XHCI_MAX_HALT_USEC;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	u32			command;
 
@@ -901,8 +909,12 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	command = xhci_readl(xhci, &xhci->op_regs->command);
 	command &= ~CMD_RUN;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
+
+	/* Some chips from Fresco Logic need an extraordinary delay */
+	delay *= (xhci->quirks & XHCI_SLOW_SUSPEND) ? 10 : 1;
+
 	if (handshake(xhci, &xhci->op_regs->status,
-		      STS_HALT, STS_HALT, XHCI_MAX_HALT_USEC)) {
+		      STS_HALT, STS_HALT, delay)) {
 		xhci_warn(xhci, "WARN: xHC CMD_RUN timeout\n");
 		spin_unlock_irq(&xhci->lock);
 		return -ETIMEDOUT;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 9a97918..a3d5b54 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1517,6 +1517,8 @@ struct xhci_hcd {
 #define XHCI_COMP_MODE_QUIRK	(1 << 14)
 #define XHCI_AVOID_BEI		(1 << 15)
 #define XHCI_PLAT		(1 << 16)
+#define XHCI_SLOW_SUSPEND	(1 << 17)
+#define XHCI_SPURIOUS_WAKEUP	(1 << 18)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index d0c2d20..c4b313f 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -457,6 +457,10 @@ static void option_instat_callback(struct urb *urb);
 #define CHANGHONG_VENDOR_ID			0x2077
 #define CHANGHONG_PRODUCT_CH690			0x7001
 
+/* Inovia */
+#define INOVIA_VENDOR_ID			0x20a6
+#define INOVIA_SEW858				0x1105
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -703,6 +707,222 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x7A) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x7B) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x7C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x01) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x02) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x03) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x04) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x05) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x06) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x0A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x0B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x0D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x0E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x0F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x10) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x12) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x13) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x14) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x15) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x17) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x18) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x19) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x1A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x1B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x1C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x31) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x32) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x33) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x34) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x35) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x36) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x3A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x3B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x3D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x3E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x3F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x48) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x49) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x4A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x4B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x4C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x61) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x62) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x63) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x64) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x65) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x66) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x6A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x6B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x6D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x6E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x6F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x78) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x79) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x7A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x7B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x7C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x01) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x02) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x03) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x04) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x05) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x06) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x0A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x0B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x0D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x0E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x0F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x10) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x12) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x13) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x14) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x15) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x17) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x18) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x19) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x1A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x1B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x1C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x31) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x32) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x33) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x34) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x35) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x36) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x3A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x3B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x3D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x3E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x3F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x48) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x49) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x4A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x4B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x4C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x61) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x62) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x63) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x64) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x65) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x66) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x6A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x6B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x6D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x6E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x6F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x78) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x79) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x7A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x7B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x7C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x01) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x02) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x03) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x04) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x05) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x06) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x0A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x0B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x0D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x0E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x0F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x10) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x12) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x13) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x14) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x15) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x17) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x18) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x19) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x1A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x1B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x1C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x31) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x32) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x33) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x34) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x35) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x36) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x3A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x3B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x3D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x3E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x3F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x48) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x49) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x4A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x4B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x4C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x61) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x62) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x63) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x64) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x65) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x66) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x6A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x6B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x6D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x6E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x6F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x78) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x79) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x7A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x7B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x7C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x01) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x02) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x03) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x04) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x05) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x06) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x0A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x0B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x0D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x0E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x0F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x10) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x12) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x13) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x14) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x15) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x17) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x18) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x19) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x1A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x1B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x1C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x31) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x32) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x33) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x34) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x35) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x36) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x3A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x3B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x3D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x3E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x3F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x48) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x49) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x4A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x4B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x4C) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x61) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x62) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x63) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x64) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x65) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x66) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x6A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x6B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x6D) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x6E) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x6F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x78) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x79) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x7A) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x7B) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x7C) },
 
 
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) },
@@ -1279,7 +1499,9 @@ static const struct usb_device_id option_ids[] = {
 
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD145) },
-	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200),
+		.driver_info = (kernel_ulong_t)&net_intf6_blacklist
+	},
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
 	{ USB_DEVICE(YUGA_VENDOR_ID, YUGA_PRODUCT_CEM600) },
@@ -1367,6 +1589,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d03, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e01, 0xff, 0xff, 0xff) }, /* D-Link DWM-152/C1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e02, 0xff, 0xff, 0xff) }, /* D-Link DWM-156/C1 */
+	{ USB_DEVICE(INOVIA_VENDOR_ID, INOVIA_SEW858) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index ea41faa..bb1e0c5 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -209,6 +209,7 @@ static struct usb_device_id ti_id_table_combined[19+2*TI_EXTRA_VID_PID_COUNT+1]
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
 	{ }
 };
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 11418da..a6e4c4a 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -205,8 +205,11 @@ static int slave_configure(struct scsi_device *sdev)
 		/*
 		 * Many devices do not respond properly to READ_CAPACITY_16.
 		 * Tell the SCSI layer to try READ_CAPACITY_10 first.
+		 * However some USB 3.0 drive enclosures return capacity
+		 * modulo 2TB. Those must use READ_CAPACITY_16
 		 */
-		sdev->try_rc_10_first = 1;
+		if (!(us->fflags & US_FL_NEEDS_CAP16))
+			sdev->try_rc_10_first = 1;
 
 		/* assume SPC3 or latter devices support sense size > 18 */
 		if (sdev->scsi_level > SCSI_SPC_2)
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index ae14acd..7da68c4 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1905,6 +1905,13 @@ UNUSUAL_DEV(  0x1652, 0x6600, 0x0201, 0x0201,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
+/* Reported by Oliver Neukum <oneukum@suse.com> */
+UNUSUAL_DEV(  0x174c, 0x55aa, 0x0100, 0x0100,
+		"ASMedia",
+		"AS2105",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NEEDS_CAP16),
+
 /* Reported by Jesse Feddema <jdfeddema@gmail.com> */
 UNUSUAL_DEV(  0x177f, 0x0400, 0x0000, 0x0000,
 		"Yarvik",
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index 8df050d..1c53745 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -310,7 +310,8 @@ static long ts72xx_wdt_ioctl(struct file *file, unsigned int cmd,
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
+		error = put_user(0, p);
+		break;
 
 	case WDIOC_KEEPALIVE:
 		ts72xx_wdt_kick(wdt);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 646ee21..92841a7 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -684,6 +684,7 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 	int cowonly;
 	int ret;
 	int err = 0;
+	bool need_check = true;
 
 	path1 = btrfs_alloc_path();
 	path2 = btrfs_alloc_path();
@@ -906,6 +907,7 @@ again:
 			cur->bytenr);
 
 		lower = cur;
+		need_check = true;
 		for (; level < BTRFS_MAX_LEVEL; level++) {
 			if (!path2->nodes[level]) {
 				BUG_ON(btrfs_root_bytenr(&root->root_item) !=
@@ -949,14 +951,12 @@ again:
 
 				/*
 				 * add the block to pending list if we
-				 * need check its backrefs. only block
-				 * at 'cur->level + 1' is added to the
-				 * tail of pending list. this guarantees
-				 * we check backrefs from lower level
-				 * blocks to upper level blocks.
+				 * need check its backrefs, we only do this once
+				 * while walking up a tree as we will catch
+				 * anything else later on.
 				 */
-				if (!upper->checked &&
-				    level == cur->level + 1) {
+				if (!upper->checked && need_check) {
+					need_check = false;
 					list_add_tail(&edge->list[UPPER],
 						      &list);
 				} else
diff --git a/fs/buffer.c b/fs/buffer.c
index 2c78739..2675e5a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -957,9 +957,19 @@ grow_dev_page(struct block_device *bdev, sector_t block,
 	struct buffer_head *bh;
 	sector_t end_block;
 	int ret = 0;		/* Will call free_more_memory() */
+	gfp_t gfp_mask;
 
-	page = find_or_create_page(inode->i_mapping, index,
-		(mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS)|__GFP_MOVABLE);
+	gfp_mask = mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
+	gfp_mask |= __GFP_MOVABLE;
+	/*
+	 * XXX: __getblk_slow() can not really deal with failure and
+	 * will endlessly loop on improvised global reclaim.  Prefer
+	 * looping in the allocator rather than here, at least that
+	 * code knows what it's doing.
+	 */
+	gfp_mask |= __GFP_NOFAIL;
+
+	page = find_or_create_page(inode->i_mapping, index, gfp_mask);
 	if (!page)
 		return ret;
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1d261e6..e979d5d 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1328,6 +1328,8 @@ retry:
 				    s_min_extra_isize) {
 					tried_min_extra_isize++;
 					new_extra_isize = s_min_extra_isize;
+					kfree(is); is = NULL;
+					kfree(bs); bs = NULL;
 					goto retry;
 				}
 				error = -1;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b60cc5f..ac5b0b9 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1354,6 +1354,7 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_req *req;
 	struct fuse_setattr_in inarg;
 	struct fuse_attr_out outarg;
@@ -1384,8 +1385,10 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	if (is_truncate)
+	if (is_truncate) {
 		fuse_set_nowrite(inode);
+		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
+	}
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
@@ -1447,12 +1450,14 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 		invalidate_inode_pages2(inode->i_mapping);
 	}
 
+	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 	return 0;
 
 error:
 	if (is_truncate)
 		fuse_release_nowrite(inode);
 
+	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 	return err;
 }
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e7785e4..9cc2f91 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -515,7 +515,8 @@ static void fuse_read_update_size(struct inode *inode, loff_t size,
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	spin_lock(&fc->lock);
-	if (attr_ver == fi->attr_version && size < inode->i_size) {
+	if (attr_ver == fi->attr_version && size < inode->i_size &&
+	    !test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		fi->attr_version = ++fc->attr_version;
 		i_size_write(inode, size);
 	}
@@ -877,12 +878,16 @@ static ssize_t fuse_perform_write(struct file *file,
 {
 	struct inode *inode = mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	int err = 0;
 	ssize_t res = 0;
 
 	if (is_bad_inode(inode))
 		return -EIO;
 
+	if (inode->i_size < pos + iov_iter_count(ii))
+		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
+
 	do {
 		struct fuse_req *req;
 		ssize_t count;
@@ -917,6 +922,7 @@ static ssize_t fuse_perform_write(struct file *file,
 	if (res > 0)
 		fuse_write_update_size(inode, pos);
 
+	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 	fuse_invalidate_attr(inode);
 
 	return res > 0 ? res : err;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 771fb63..1f63d49 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -103,6 +103,15 @@ struct fuse_inode {
 
 	/** List of writepage requestst (pending or sent) */
 	struct list_head writepages;
+
+	/** Miscellaneous bits describing inode state */
+	unsigned long state;
+};
+
+/** FUSE inode state bits */
+enum {
+	/** An operation changing file size is in progress  */
+	FUSE_I_SIZE_UNSTABLE,
 };
 
 struct fuse_conn;
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1cd6165..bca4e62 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -92,6 +92,7 @@ static struct inode *fuse_alloc_inode(struct super_block *sb)
 	fi->attr_version = 0;
 	fi->writectr = 0;
 	fi->orig_ino = 0;
+	fi->state = 0;
 	INIT_LIST_HEAD(&fi->write_files);
 	INIT_LIST_HEAD(&fi->queued_writes);
 	INIT_LIST_HEAD(&fi->writepages);
@@ -199,7 +200,8 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 	loff_t oldsize;
 
 	spin_lock(&fc->lock);
-	if (attr_version != 0 && fi->attr_version > attr_version) {
+	if ((attr_version != 0 && fi->attr_version > attr_version) ||
+	    test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		spin_unlock(&fc->lock);
 		return;
 	}
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 3e7b2a0..f45b83f 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -94,6 +94,7 @@ void nilfs_forget_buffer(struct buffer_head *bh)
 	clear_buffer_nilfs_volatile(bh);
 	clear_buffer_nilfs_checked(bh);
 	clear_buffer_nilfs_redirected(bh);
+	clear_buffer_async_write(bh);
 	clear_buffer_dirty(bh);
 	if (nilfs_page_buffers_clean(page))
 		__nilfs_clear_page_dirty(page);
@@ -390,6 +391,7 @@ void nilfs_clear_dirty_pages(struct address_space *mapping)
 			bh = head = page_buffers(page);
 			do {
 				lock_buffer(bh);
+				clear_buffer_async_write(bh);
 				clear_buffer_dirty(bh);
 				clear_buffer_nilfs_volatile(bh);
 				clear_buffer_nilfs_checked(bh);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 88e11fb..8992b33 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -662,7 +662,7 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
 
 		bh = head = page_buffers(page);
 		do {
-			if (!buffer_dirty(bh))
+			if (!buffer_dirty(bh) || buffer_async_write(bh))
 				continue;
 			get_bh(bh);
 			list_add_tail(&bh->b_assoc_buffers, listp);
@@ -696,7 +696,8 @@ static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			bh = head = page_buffers(pvec.pages[i]);
 			do {
-				if (buffer_dirty(bh)) {
+				if (buffer_dirty(bh) &&
+						!buffer_async_write(bh)) {
 					get_bh(bh);
 					list_add_tail(&bh->b_assoc_buffers,
 						      listp);
@@ -1576,6 +1577,7 @@ static void nilfs_segctor_prepare_write(struct nilfs_sc_info *sci)
 
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
+			set_buffer_async_write(bh);
 			if (bh->b_page != bd_page) {
 				if (bd_page) {
 					lock_page(bd_page);
@@ -1589,6 +1591,7 @@ static void nilfs_segctor_prepare_write(struct nilfs_sc_info *sci)
 
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
+			set_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
 				if (bh->b_page != bd_page) {
 					lock_page(bd_page);
@@ -1674,6 +1677,7 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 	list_for_each_entry(segbuf, logs, sb_list) {
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
+			clear_buffer_async_write(bh);
 			if (bh->b_page != bd_page) {
 				if (bd_page)
 					end_page_writeback(bd_page);
@@ -1683,6 +1687,7 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
+			clear_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
 				if (bh->b_page != bd_page) {
 					end_page_writeback(bd_page);
@@ -1752,6 +1757,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 				    b_assoc_buffers) {
 			set_buffer_uptodate(bh);
 			clear_buffer_dirty(bh);
+			clear_buffer_async_write(bh);
 			if (bh->b_page != bd_page) {
 				if (bd_page)
 					end_page_writeback(bd_page);
@@ -1773,6 +1779,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 				    b_assoc_buffers) {
 			set_buffer_uptodate(bh);
 			clear_buffer_dirty(bh);
+			clear_buffer_async_write(bh);
 			clear_buffer_delay(bh);
 			clear_buffer_nilfs_volatile(bh);
 			clear_buffer_nilfs_redirected(bh);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 920beba..53eb728 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -868,7 +868,8 @@ extern void pagefault_out_of_memory(void);
  * Flags passed to show_mem() and show_free_areas() to suppress output in
  * various contexts.
  */
-#define SHOW_MEM_FILTER_NODES	(0x0001u)	/* filter disallowed nodes */
+#define SHOW_MEM_FILTER_NODES		(0x0001u)	/* disallowed nodes */
+#define SHOW_MEM_FILTER_PAGE_COUNT	(0x0002u)	/* page type count */
 
 extern void show_free_areas(unsigned int flags);
 extern bool skip_free_areas_node(unsigned int flags, int nid);
diff --git a/include/linux/random.h b/include/linux/random.h
index ac621ce..7e58ad2 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -56,6 +56,7 @@ extern void add_interrupt_randomness(int irq, int irq_flags);
 extern void get_random_bytes(void *buf, int nbytes);
 extern void get_random_bytes_arch(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
+extern int random_int_secret_init(void);
 
 #ifndef MODULE
 extern const struct file_operations random_fops, urandom_fops;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e1c1e64..160f3ea 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -774,6 +774,16 @@ static inline int skb_cloned(const struct sk_buff *skb)
 	       (atomic_read(&skb_shinfo(skb)->dataref) & SKB_DATAREF_MASK) != 1;
 }
 
+static inline int skb_unclone(struct sk_buff *skb, gfp_t pri)
+{
+	might_sleep_if(pri & __GFP_WAIT);
+
+	if (skb_cloned(skb))
+		return pskb_expand_head(skb, 0, 0, pri);
+
+	return 0;
+}
+
 /**
  *	skb_header_cloned - is the header a clone
  *	@skb: buffer to check
@@ -1216,6 +1226,11 @@ static inline int skb_pagelen(const struct sk_buff *skb)
 	return len + skb_headlen(skb);
 }
 
+static inline bool skb_has_frags(const struct sk_buff *skb)
+{
+	return skb_shinfo(skb)->nr_frags;
+}
+
 /**
  * __skb_fill_page_desc - initialise a paged fragment in an skb
  * @skb: buffer containing fragment to be initialised
diff --git a/include/linux/timex.h b/include/linux/timex.h
index 99bc88b..a647f36 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -173,6 +173,20 @@ struct timex {
 
 #include <asm/timex.h>
 
+#ifndef random_get_entropy
+/*
+ * The random_get_entropy() function is used by the /dev/random driver
+ * in order to extract entropy via the relative unpredictability of
+ * when an interrupt takes places versus a high speed, fine-grained
+ * timing source or cycle counter.  Since it will be occurred on every
+ * single interrupt, it must have a very low cost/overhead.
+ *
+ * By default we use get_cycles() for this purpose, but individual
+ * architectures may override this in their asm/timex.h header file.
+ */
+#define random_get_entropy()	get_cycles()
+#endif
+
 /*
  * SHIFT_PLL is used as a dampening factor to define how much we
  * adjust the frequency correction for a given offset in PLL mode.
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index 17df360..425bc8b 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -64,7 +64,9 @@
 	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
 		/* cannot handle READ_CAPACITY_16 */		\
 	US_FLAG(INITIAL_READ10,	0x00100000)			\
-		/* Initial READ(10) (and others) must be retried */
+		/* Initial READ(10) (and others) must be retried */	\
+	US_FLAG(NEEDS_CAP16,	0x00400000)
+		/* cannot handle READ_CAPACITY_10 */
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
diff --git a/include/net/cipso_ipv4.h b/include/net/cipso_ipv4.h
index a7a683e..a8c2ef6 100644
--- a/include/net/cipso_ipv4.h
+++ b/include/net/cipso_ipv4.h
@@ -290,6 +290,7 @@ static inline int cipso_v4_validate(const struct sk_buff *skb,
 	unsigned char err_offset = 0;
 	u8 opt_len = opt[1];
 	u8 opt_iter;
+	u8 tag_len;
 
 	if (opt_len < 8) {
 		err_offset = 1;
@@ -302,11 +303,12 @@ static inline int cipso_v4_validate(const struct sk_buff *skb,
 	}
 
 	for (opt_iter = 6; opt_iter < opt_len;) {
-		if (opt[opt_iter + 1] > (opt_len - opt_iter)) {
+		tag_len = opt[opt_iter + 1];
+		if ((tag_len == 0) || (opt[opt_iter + 1] > (opt_len - opt_iter))) {
 			err_offset = opt_iter + 1;
 			goto out;
 		}
-		opt_iter += opt[opt_iter + 1];
+		opt_iter += tag_len;
 	}
 
 out:
diff --git a/include/net/dst.h b/include/net/dst.h
index 8197ead..1efe71a 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -464,10 +464,22 @@ static inline struct dst_entry *xfrm_lookup(struct net *net,
 {
 	return dst_orig;
 } 
+
+static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
+{
+	return NULL;
+}
+
 #else
 extern struct dst_entry *xfrm_lookup(struct net *net, struct dst_entry *dst_orig,
 				     const struct flowi *fl, struct sock *sk,
 				     int flags);
+
+/* skb attached with this dst needs transformation if dst->xfrm is valid */
+static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
+{
+	return dst->xfrm;
+}
 #endif
 
 #endif /* _NET_DST_H */
diff --git a/init/main.c b/init/main.c
index 9a053de..0b62dae 100644
--- a/init/main.c
+++ b/init/main.c
@@ -68,6 +68,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/perf_event.h>
+#include <linux/random.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -779,6 +780,7 @@ static void __init do_basic_setup(void)
 	do_ctors();
 	usermodehelper_enable();
 	do_initcalls();
+	random_int_secret_init();
 }
 
 static void __init do_pre_smp_initcalls(void)
diff --git a/lib/show_mem.c b/lib/show_mem.c
index 4407f8c..b7c7231 100644
--- a/lib/show_mem.c
+++ b/lib/show_mem.c
@@ -18,6 +18,9 @@ void show_mem(unsigned int filter)
 	printk("Mem-Info:\n");
 	show_free_areas(filter);
 
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
+
 	for_each_online_pgdat(pgdat) {
 		unsigned long i, flags;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 226b63e..953bf3c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2405,6 +2405,8 @@ done:
 	return 0;
 nomem:
 	*ptr = NULL;
+	if (gfp_mask & __GFP_NOFAIL)
+		return 0;
 	return -ENOMEM;
 bypass:
 	*ptr = root_mem_cgroup;
diff --git a/mm/mmap.c b/mm/mmap.c
index f1a9a72..7e24763 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -6,6 +6,7 @@
  * Address space accounting code	<alan@lxorguk.ukuu.org.uk>
  */
 
+#include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/mm.h>
@@ -393,6 +394,34 @@ find_vma_prepare(struct mm_struct *mm, unsigned long addr,
 	return vma;
 }
 
+static unsigned long count_vma_pages_range(struct mm_struct *mm,
+		unsigned long addr, unsigned long end)
+{
+	unsigned long nr_pages = 0;
+	struct vm_area_struct *vma;
+
+	/* Find first overlaping mapping */
+	vma = find_vma_intersection(mm, addr, end);
+	if (!vma)
+		return 0;
+
+	nr_pages = (min(end, vma->vm_end) -
+		max(addr, vma->vm_start)) >> PAGE_SHIFT;
+
+	/* Iterate over the rest of the overlaps */
+	for (vma = vma->vm_next; vma; vma = vma->vm_next) {
+		unsigned long overlap_len;
+
+		if (vma->vm_start > end)
+			break;
+
+		overlap_len = min(end, vma->vm_end) - vma->vm_start;
+		nr_pages += overlap_len >> PAGE_SHIFT;
+	}
+
+	return nr_pages;
+}
+
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct rb_node **rb_link, struct rb_node *rb_parent)
 {
@@ -1228,6 +1257,23 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	unsigned long charged = 0;
 	struct inode *inode =  file ? file->f_path.dentry->d_inode : NULL;
 
+	/* Check against address space limit. */
+	if (!may_expand_vm(mm, len >> PAGE_SHIFT)) {
+		unsigned long nr_pages;
+
+		/*
+		 * MAP_FIXED may remove pages of mappings that intersects with
+		 * requested mapping. Account for the pages it would unmap.
+		 */
+		if (!(vm_flags & MAP_FIXED))
+			return -ENOMEM;
+
+		nr_pages = count_vma_pages_range(mm, addr, addr + len);
+
+		if (!may_expand_vm(mm, (len >> PAGE_SHIFT) - nr_pages))
+			return -ENOMEM;
+	}
+
 	/* Clear old maps */
 	error = -ENOMEM;
 munmap_back:
@@ -1238,10 +1284,6 @@ munmap_back:
 		goto munmap_back;
 	}
 
-	/* Check against address space limit. */
-	if (!may_expand_vm(mm, len >> PAGE_SHIFT))
-		return -ENOMEM;
-
 	/*
 	 * Set 'VM_NORESERVE' if we should not account for the
 	 * memory use of this mapping.
@@ -1823,9 +1865,28 @@ int expand_downwards(struct vm_area_struct *vma,
 	return error;
 }
 
+/*
+ * Note how expand_stack() refuses to expand the stack all the way to
+ * abut the next virtual mapping, *unless* that mapping itself is also
+ * a stack mapping. We want to leave room for a guard page, after all
+ * (the guard page itself is not added here, that is done by the
+ * actual page faulting logic)
+ *
+ * This matches the behavior of the guard page logic (see mm/memory.c:
+ * check_stack_guard_page()), which only allows the guard page to be
+ * removed under these circumstances.
+ */
 #ifdef CONFIG_STACK_GROWSUP
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
+	struct vm_area_struct *next;
+
+	address &= PAGE_MASK;
+	next = vma->vm_next;
+	if (next && next->vm_start == address + PAGE_SIZE) {
+		if (!(next->vm_flags & VM_GROWSUP))
+			return -ENOMEM;
+	}
 	return expand_upwards(vma, address);
 }
 
@@ -1848,6 +1909,14 @@ find_extend_vma(struct mm_struct *mm, unsigned long addr)
 #else
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
+	struct vm_area_struct *prev;
+
+	address &= PAGE_MASK;
+	prev = vma->vm_prev;
+	if (prev && prev->vm_end == address) {
+		if (!(prev->vm_flags & VM_GROWSDOWN))
+			return -ENOMEM;
+	}
 	return expand_downwards(vma, address);
 }
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e252db8..194cc02 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1072,11 +1072,11 @@ static unsigned long dirty_poll_interval(unsigned long dirty,
 	return 1;
 }
 
-static long bdi_max_pause(struct backing_dev_info *bdi,
-			  unsigned long bdi_dirty)
+static unsigned long bdi_max_pause(struct backing_dev_info *bdi,
+				   unsigned long bdi_dirty)
 {
-	long bw = bdi->avg_write_bandwidth;
-	long t;
+	unsigned long bw = bdi->avg_write_bandwidth;
+	unsigned long t;
 
 	/*
 	 * Limit pause time for small memory systems. If sleeping for too long
@@ -1088,7 +1088,7 @@ static long bdi_max_pause(struct backing_dev_info *bdi,
 	t = bdi_dirty / (1 + bw / roundup_pow_of_two(1 + HZ / 8));
 	t++;
 
-	return min_t(long, t, MAX_PAUSE);
+	return min_t(unsigned long, t, MAX_PAUSE);
 }
 
 static long bdi_min_pause(struct backing_dev_info *bdi,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 63e6fa4..715b395 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1929,6 +1929,13 @@ void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...)
 		return;
 
 	/*
+	 * Walking all memory to count page types is very expensive and should
+	 * be inhibited in non-blockable contexts.
+	 */
+	if (!(gfp_mask & __GFP_WAIT))
+		filter |= SHOW_MEM_FILTER_PAGE_COUNT;
+
+	/*
 	 * This documents exceptions given to allocations in certain
 	 * contexts that are allowed to allocate outside current's set
 	 * of allowed nodes.
diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index 708c80e..ebde030 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -152,7 +152,7 @@ static size_t vlan_get_size(const struct net_device *dev)
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
 
 	return nla_total_size(2) +	/* IFLA_VLAN_ID */
-	       sizeof(struct ifla_vlan_flags) + /* IFLA_VLAN_FLAGS */
+	       nla_total_size(sizeof(struct ifla_vlan_flags)) + /* IFLA_VLAN_FLAGS */
 	       vlan_qos_map_size(vlan->nr_ingress_mappings) +
 	       vlan_qos_map_size(vlan->nr_egress_mappings);
 }
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index 7ba2ed5..5bb38cd 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -134,7 +134,7 @@ static void br_stp_start(struct net_bridge *br)
 
 	if (br->bridge_forward_delay < BR_MIN_FORWARD_DELAY)
 		__br_set_forward_delay(br, BR_MIN_FORWARD_DELAY);
-	else if (br->bridge_forward_delay < BR_MAX_FORWARD_DELAY)
+	else if (br->bridge_forward_delay > BR_MAX_FORWARD_DELAY)
 		__br_set_forward_delay(br, BR_MAX_FORWARD_DELAY);
 
 	if (r == 0) {
diff --git a/net/compat.c b/net/compat.c
index 9c816e8..707f5ba 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -71,6 +71,8 @@ int get_compat_msghdr(struct msghdr *kmsg, struct compat_msghdr __user *umsg)
 	    __get_user(kmsg->msg_controllen, &umsg->msg_controllen) ||
 	    __get_user(kmsg->msg_flags, &umsg->msg_flags))
 		return -EFAULT;
+	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
+		return -EINVAL;
 	kmsg->msg_name = compat_ptr(tmp1);
 	kmsg->msg_iov = compat_ptr(tmp2);
 	kmsg->msg_control = compat_ptr(tmp3);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 7880af9..ffd0f56 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -268,7 +268,7 @@ begintw:
 			}
 			if (unlikely(!INET_TW_MATCH(sk, net, hash, acookie,
 				 saddr, daddr, ports, dif))) {
-				sock_put(sk);
+				inet_twsk_put(inet_twsk(sk));
 				goto begintw;
 			}
 			goto out;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 7ee32c6..ed8270f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -846,7 +846,7 @@ static int __ip_append_data(struct sock *sk,
 		csummode = CHECKSUM_PARTIAL;
 
 	cork->length += length;
-	if (((length > mtu) || (skb && skb_is_gso(skb))) &&
+	if (((length > mtu) || (skb && skb_has_frags(skb))) &&
 	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->dst.dev->features & NETIF_F_UFO) && !rt->dst.header_len) {
 		err = ip_ufo_append_data(sk, queue, getfrag, from, length,
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 98b30d0..8707417 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2707,7 +2707,7 @@ static struct rtable *ip_route_output_slow(struct net *net, struct flowi4 *fl4)
 							      RT_SCOPE_LINK);
 			goto make_route;
 		}
-		if (fl4->saddr) {
+		if (!fl4->saddr) {
 			if (ipv4_is_multicast(fl4->daddr))
 				fl4->saddr = inet_select_addr(dev_out, 0,
 							      fl4->flowi4_scope);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3d5ffe0..a6acd36 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1475,7 +1475,10 @@ static bool tcp_shifted_skb(struct sock *sk, struct sk_buff *skb,
 		tp->lost_cnt_hint -= tcp_skb_pcount(prev);
 	}
 
-	TCP_SKB_CB(skb)->tcp_flags |= TCP_SKB_CB(prev)->tcp_flags;
+	TCP_SKB_CB(prev)->tcp_flags |= TCP_SKB_CB(skb)->tcp_flags;
+	if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
+		TCP_SKB_CB(prev)->end_seq++;
+
 	if (skb == tcp_highest_sack(sk))
 		tcp_advance_highest_sack(sk, skb);
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 4a1e840..d06b130 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -934,6 +934,9 @@ static void tcp_queue_skb(struct sock *sk, struct sk_buff *skb)
 static void tcp_set_skb_tso_segs(const struct sock *sk, struct sk_buff *skb,
 				 unsigned int mss_now)
 {
+	/* Make sure we own this skb before messing gso_size/gso_segs */
+	WARN_ON_ONCE(skb_cloned(skb));
+
 	if (skb->len <= mss_now || !sk_can_gso(sk) ||
 	    skb->ip_summed == CHECKSUM_NONE) {
 		/* Avoid the costly divide in the normal
@@ -1015,9 +1018,7 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (skb_cloned(skb) &&
-	    skb_is_nonlinear(skb) &&
-	    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+	if (skb_unclone(skb, GFP_ATOMIC))
 		return -ENOMEM;
 
 	/* Get a new skb... force flag on. */
@@ -2150,6 +2151,8 @@ int tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb)
 		int oldpcount = tcp_skb_pcount(skb);
 
 		if (unlikely(oldpcount > 1)) {
+			if (skb_unclone(skb, GFP_ATOMIC))
+				return -ENOMEM;
 			tcp_init_tso_segs(sk, skb, cur_mss);
 			tcp_adjust_pcount(sk, skb, oldpcount - tcp_skb_pcount(skb));
 		}
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 73f1a00..e38290b 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -110,7 +110,7 @@ begintw:
 				goto out;
 			}
 			if (!INET6_TW_MATCH(sk, net, hash, saddr, daddr, ports, dif)) {
-				sock_put(sk);
+				inet_twsk_put(inet_twsk(sk));
 				goto begintw;
 			}
 			goto out;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index d00f1ad..01cf1cd 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1351,7 +1351,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 	skb = skb_peek_tail(&sk->sk_write_queue);
 	cork->length += length;
 	if (((length > mtu) ||
-	     (skb && skb_is_gso(skb))) &&
+	     (skb && skb_has_frags(skb))) &&
 	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->dst.dev->features & NETIF_F_UFO)) {
 		err = ip6_ufo_append_data(sk, getfrag, from, length,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 8253206..9659bd9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -818,7 +818,7 @@ static struct rt6_info *rt6_alloc_clone(struct rt6_info *ort,
 }
 
 static struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table, int oif,
-				      struct flowi6 *fl6, int flags)
+				      struct flowi6 *fl6, int flags, bool input)
 {
 	struct fib6_node *fn;
 	struct rt6_info *rt, *nrt;
@@ -826,8 +826,11 @@ static struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 	int attempts = 3;
 	int err;
 	int reachable = net->ipv6.devconf_all->forwarding ? 0 : RT6_LOOKUP_F_REACHABLE;
+	int local = RTF_NONEXTHOP;
 
 	strict |= flags & RT6_LOOKUP_F_IFACE;
+	if (input)
+		local |= RTF_LOCAL;
 
 relookup:
 	read_lock_bh(&table->tb6_lock);
@@ -847,7 +850,7 @@ restart:
 	read_unlock_bh(&table->tb6_lock);
 
 	if (!dst_get_neighbour_noref_raw(&rt->dst) &&
-	    !(rt->rt6i_flags & (RTF_NONEXTHOP | RTF_LOCAL)))
+	    !(rt->rt6i_flags & local))
 		nrt = rt6_alloc_cow(rt, &fl6->daddr, &fl6->saddr);
 	else if (!(rt->dst.flags & DST_HOST))
 		nrt = rt6_alloc_clone(rt, &fl6->daddr);
@@ -891,7 +894,7 @@ out2:
 static struct rt6_info *ip6_pol_route_input(struct net *net, struct fib6_table *table,
 					    struct flowi6 *fl6, int flags)
 {
-	return ip6_pol_route(net, table, fl6->flowi6_iif, fl6, flags);
+	return ip6_pol_route(net, table, fl6->flowi6_iif, fl6, flags, true);
 }
 
 static struct dst_entry *ip6_route_input_lookup(struct net *net,
@@ -924,7 +927,7 @@ void ip6_route_input(struct sk_buff *skb)
 static struct rt6_info *ip6_pol_route_output(struct net *net, struct fib6_table *table,
 					     struct flowi6 *fl6, int flags)
 {
-	return ip6_pol_route(net, table, fl6->flowi6_oif, fl6, flags);
+	return ip6_pol_route(net, table, fl6->flowi6_oif, fl6, flags, false);
 }
 
 struct dst_entry * ip6_route_output(struct net *net, const struct sock *sk,
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 286fec4..624cf33 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -352,7 +352,9 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 		goto error_put_sess_tun;
 	}
 
+	local_bh_disable();
 	l2tp_xmit_skb(session, skb, session->hdr_len);
+	local_bh_enable();
 
 	sock_put(ps->tunnel_sock);
 	sock_put(sk);
@@ -427,7 +429,9 @@ static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	skb->data[0] = ppph[0];
 	skb->data[1] = ppph[1];
 
+	local_bh_disable();
 	l2tp_xmit_skb(session, skb, session->hdr_len);
+	local_bh_enable();
 
 	sock_put(sk_tun);
 	sock_put(sk);
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 83dddb9..a1e2a9b 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -523,7 +523,8 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	 * by CRC32-C as described in <draft-ietf-tsvwg-sctpcsum-02.txt>.
 	 */
 	if (!sctp_checksum_disable) {
-		if (!(dst->dev->features & NETIF_F_SCTP_CSUM)) {
+		if (!(dst->dev->features & NETIF_F_SCTP_CSUM) ||
+		    (dst_xfrm(dst) != NULL) || packet->ipfragok) {
 			__u32 crc32 = sctp_start_cksum((__u8 *)sh, cksum_buf_len);
 
 			/* 3) Put the resultant value into the checksum field in the
diff --git a/net/socket.c b/net/socket.c
index cd51a03..c9b6b90 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1898,6 +1898,16 @@ struct used_address {
 	unsigned int name_len;
 };
 
+static int copy_msghdr_from_user(struct msghdr *kmsg,
+				 struct msghdr __user *umsg)
+{
+	if (copy_from_user(kmsg, umsg, sizeof(struct msghdr)))
+		return -EFAULT;
+	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
+		return -EINVAL;
+	return 0;
+}
+
 static int ___sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
 			 struct msghdr *msg_sys, unsigned int flags,
 			 struct used_address *used_address)
@@ -1916,8 +1926,11 @@ static int ___sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
 	if (MSG_CMSG_COMPAT & flags) {
 		if (get_compat_msghdr(msg_sys, msg_compat))
 			return -EFAULT;
-	} else if (copy_from_user(msg_sys, msg, sizeof(struct msghdr)))
-		return -EFAULT;
+	} else {
+		err = copy_msghdr_from_user(msg_sys, msg);
+		if (err)
+			return err;
+	}
 
 	if (msg_sys->msg_iovlen > UIO_FASTIOV) {
 		err = -EMSGSIZE;
@@ -2125,8 +2138,11 @@ static int ___sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
 	if (MSG_CMSG_COMPAT & flags) {
 		if (get_compat_msghdr(msg_sys, msg_compat))
 			return -EFAULT;
-	} else if (copy_from_user(msg_sys, msg, sizeof(struct msghdr)))
-		return -EFAULT;
+	} else {
+		err = copy_msghdr_from_user(msg_sys, msg);
+		if (err)
+			return err;
+	}
 
 	if (msg_sys->msg_iovlen > UIO_FASTIOV) {
 		err = -EMSGSIZE;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index ce7db4b..2e67391 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1248,6 +1248,15 @@ static int unix_socketpair(struct socket *socka, struct socket *sockb)
 	return 0;
 }
 
+static void unix_sock_inherit_flags(const struct socket *old,
+				    struct socket *new)
+{
+	if (test_bit(SOCK_PASSCRED, &old->flags))
+		set_bit(SOCK_PASSCRED, &new->flags);
+	if (test_bit(SOCK_PASSSEC, &old->flags))
+		set_bit(SOCK_PASSSEC, &new->flags);
+}
+
 static int unix_accept(struct socket *sock, struct socket *newsock, int flags)
 {
 	struct sock *sk = sock->sk;
@@ -1282,6 +1291,7 @@ static int unix_accept(struct socket *sock, struct socket *newsock, int flags)
 	/* attach accepted sock to socket */
 	unix_state_lock(tsk);
 	newsock->state = SS_CONNECTED;
+	unix_sock_inherit_flags(sock, newsock);
 	sock_graft(tsk, newsock);
 	unix_state_unlock(tsk);
 	return 0;
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 47d3002..1b4d8fc 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -134,6 +134,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	rep->udiag_family = AF_UNIX;
 	rep->udiag_type = sk->sk_type;
 	rep->udiag_state = sk->sk_state;
+	rep->pad = 0;
 	rep->udiag_ino = sk_ino;
 	sock_diag_save_cookie(sk, rep->udiag_cookie);
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1baf0dc..accddc0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6728,6 +6728,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x031c, "Gateway NV79", ALC662_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
+	SND_PCI_QUIRK(0x1043, 0x1477, "ASUS N56VZ", ALC662_FIXUP_ASUS_MODE4),
 	SND_PCI_QUIRK(0x1043, 0x8469, "ASUS mobo", ALC662_FIXUP_NO_JACK_DETECT),
 	SND_PCI_QUIRK(0x105b, 0x0cd6, "Foxconn", ALC662_FIXUP_ASUS_MODE2),
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index 43d337d..bdc4ddb 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -299,19 +299,6 @@ static void usX2Y_error_urb_status(struct usX2Ydev *usX2Y,
 	usX2Y_clients_stop(usX2Y);
 }
 
-static void usX2Y_error_sequence(struct usX2Ydev *usX2Y,
-				 struct snd_usX2Y_substream *subs, struct urb *urb)
-{
-	snd_printk(KERN_ERR
-"Sequence Error!(hcd_frame=%i ep=%i%s;wait=%i,frame=%i).\n"
-"Most probably some urb of usb-frame %i is still missing.\n"
-"Cause could be too long delays in usb-hcd interrupt handling.\n",
-		   usb_get_current_frame_number(usX2Y->dev),
-		   subs->endpoint, usb_pipein(urb->pipe) ? "in" : "out",
-		   usX2Y->wait_iso_frame, urb->start_frame, usX2Y->wait_iso_frame);
-	usX2Y_clients_stop(usX2Y);
-}
-
 static void i_usX2Y_urb_complete(struct urb *urb)
 {
 	struct snd_usX2Y_substream *subs = urb->context;
@@ -328,12 +315,9 @@ static void i_usX2Y_urb_complete(struct urb *urb)
 		usX2Y_error_urb_status(usX2Y, subs, urb);
 		return;
 	}
-	if (likely((urb->start_frame & 0xFFFF) == (usX2Y->wait_iso_frame & 0xFFFF)))
-		subs->completed_urb = urb;
-	else {
-		usX2Y_error_sequence(usX2Y, subs, urb);
-		return;
-	}
+
+	subs->completed_urb = urb;
+
 	{
 		struct snd_usX2Y_substream *capsubs = usX2Y->subs[SNDRV_PCM_STREAM_CAPTURE],
 			*playbacksubs = usX2Y->subs[SNDRV_PCM_STREAM_PLAYBACK];
diff --git a/sound/usb/usx2y/usx2yhwdeppcm.c b/sound/usb/usx2y/usx2yhwdeppcm.c
index 8e40b6e..1da1eca 100644
--- a/sound/usb/usx2y/usx2yhwdeppcm.c
+++ b/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -244,13 +244,8 @@ static void i_usX2Y_usbpcm_urb_complete(struct urb *urb)
 		usX2Y_error_urb_status(usX2Y, subs, urb);
 		return;
 	}
-	if (likely((urb->start_frame & 0xFFFF) == (usX2Y->wait_iso_frame & 0xFFFF)))
-		subs->completed_urb = urb;
-	else {
-		usX2Y_error_sequence(usX2Y, subs, urb);
-		return;
-	}
 
+	subs->completed_urb = urb;
 	capsubs = usX2Y->subs[SNDRV_PCM_STREAM_CAPTURE];
 	capsubs2 = usX2Y->subs[SNDRV_PCM_STREAM_CAPTURE + 2];
 	playbacksubs = usX2Y->subs[SNDRV_PCM_STREAM_PLAYBACK];
