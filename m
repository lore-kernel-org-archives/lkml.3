Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3HaJMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 05:12:30 -0400
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36367 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab3HaJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 05:12:28 -0400
MIME-Version: 1.0
Date: Sat, 31 Aug 2013 17:12:27 +0800
Message-ID: <CANHg-x7q4y6go_Bc8z5ZSYUJdQ72OQekg=SU+UVJopztknu6Ew@mail.gmail.com>
Subject: [RFC PATCH v1 1/1] powerpc/85xx: Wakeup kexec smp slave cpus in
 second kernel
From: Yu Chen <chenyu105@gmail.com>
To: galak@kernel.crashing.org, msm@freescale.com, chenhui.zhao@freescale.com,
        leoli@freescale.com, b24347@freescale.com, benh@kernel.crashing.org,
        paulus@samba.org
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
        Ryan Chan <chenyu105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1ccf579b871dfd5938ce958f729361a203485c74 Mon Sep 17 00:00:00 2001
From: Yu Chen <chenyu105@gmail.com>
Date: Sat, 31 Aug 2013 23:52:31 +0800
Subject: [PATCH]  powerpc/85xx: Wakeup kexec smp slave cpus in second kernel

In current 85xx smp kexec implementation,master cpu reset slave cpus
by mpic_reset_core,
before jump to second kernel.In order to wake slave cpus up in second
kernel,we debug
this patch on p2041rdb.

The main principle of this patch,is to get slave cpus polling for flag
to change,
thus waiting for master cpu to set it with non-zero cpu number(see misc_32.S).
This flag is placed in kexec control page,so it would not be
overlapped when copying kimage.
The master cpu put flag's physical address in r28 as a parameter
passed to second kernel,
so the latter knows how to wake slave cpus up in smp_85xx_kick_cpu.
The pseudo-code may be like:
void slave_cpu_spin(void)
{
        int cpu = smp_processor_id();
        while (*kexec_poll != cpu)
                ;
        /*slave wakeup and jump*/
        jump(*(kexec_poll+1));
}

void master_cpu_wakeup(unsigned long *kexec_poll, int cpu)
{
        *(kexec_poll+1) = __early_start;
        mb();
        *kexec_poll = cpu;
}

However,after applied this patch,we got some kernel exception during
booting second kernel,
I'm not sure if it's caused by improper treament of cache,or tlb,or
other.So I put this
patch here hoping someone can check and review it.

Signed-off-by: Yu Chen <chenyu105@gmail.com>
---
 arch/powerpc/kernel/head_fsl_booke.S |    7 ++
 arch/powerpc/kernel/misc_32.S        |   66 +++++++++++++-
 arch/powerpc/platforms/85xx/smp.c    |  166 ++++++++++++++++++++++++++++++----
 3 files changed, 222 insertions(+), 17 deletions(-)
 mode change 100644 => 100755 arch/powerpc/kernel/head_fsl_booke.S
 mode change 100644 => 100755 arch/powerpc/kernel/misc_32.S
 mode change 100644 => 100755 arch/powerpc/platforms/85xx/smp.c

diff --git a/arch/powerpc/kernel/head_fsl_booke.S
b/arch/powerpc/kernel/head_fsl_booke.S
old mode 100644
new mode 100755
index d10a7ca..63c8392
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -178,6 +178,13 @@ _ENTRY(__early_start)
      * This is where the main kernel code starts.
      */

+#if defined(CONFIG_KEXEC) && defined(CONFIG_SMP)
+    /* r28 contain position where slave cpus spin*/
+    lis    r1,kexec_poll_phy@h
+    ori    r1,r1,kexec_poll_phy@l
+    stw    r28,0(r1)
+#endif
+
     /* ptr to current */
     lis    r2,init_task@h
     ori    r2,r2,init_task@l
diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
old mode 100644
new mode 100755
index e469f30..d9eefc2
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -120,7 +120,7 @@ _GLOBAL(reloc_got2)
     addi    r4,r4,1b@l
     subf    r0,r4,r0
     add    r7,r0,r7
-2:    lwz    r0,0(r7)
+    2:    lwz    r0,0(r7)
     add    r0,r0,r3
     stw    r0,0(r7)
     addi    r7,r7,4
@@ -692,6 +692,7 @@ _GLOBAL(__main)
     blr

 #ifdef CONFIG_KEXEC
+#define KEXEC_MAGIC 0xdeadbeef
     /*
      * Must be relocatable PIC code callable as a C function.
      */
@@ -707,6 +708,16 @@ relocate_new_kernel:
     mr    r30, r4
     mr    r31, r5

+#ifdef CONFIG_SMP
+    bl    1f
+1:    mflr    r8
+    addi    r8,r8,kexec_flag-1b
+    lis     r7,PAGE_OFFSET@h
+    ori     r7,r7,PAGE_OFFSET@l
+    /*r28 contain slave cpu spin physical address */
+    subf    r28, r7, r8
+#endif
+
 #define ENTRY_MAPPING_KEXEC_SETUP
 #include "fsl_booke_entry_mapping.S"
 #undef ENTRY_MAPPING_KEXEC_SETUP
@@ -1172,4 +1183,57 @@ relocate_new_kernel_end:
     .globl relocate_new_kernel_size
 relocate_new_kernel_size:
     .long relocate_new_kernel_end - relocate_new_kernel
+#ifdef CONFIG_FSL_BOOKE
+    /**
+    * Slave cpus wait for kexec_flag to change
+    */
+    .globl relocate_smp_cpu_offset
+relocate_smp_cpu_offset:
+    .long relocate_smp_cpu_wait-relocate_new_kernel
+
+    .globl relocate_smp_cpu_wait
+relocate_smp_cpu_wait:
+
+    bl    1f
+1:    mflr    r5
+    addi    r5,r5,kexec_flag-1b
+    /*see if anyone calls me?*/
+    mfspr   r24,SPRN_PIR
+99:    lwz    r4,4(r5)
+    cmpw    r4,r24
+    msync
+    bne        99b
+
+    msync
+    /*r4 contains jump address*/
+    lwz    r4,8(r5)
+    msync
+    lis    r5,MSR_KERNEL@h
+    ori    r5,r5,MSR_KERNEL@l
+    msync
+    isync
+    mtspr    SPRN_SRR1, r5
+    mtspr    SPRN_SRR0, r4
+    msync
+    isync
+    rfi
+    isync
+1:    b    1b
+
+    /**
+    * kexec_flag indicates a kexec magic
+    * kexec_flag+4 bytes supposed to be set with cpu number
+    * kexec_flag+8 countain addr for slave cpu to jump into
+    */
+    .globl kexec_flag
+kexec_flag:
+    .long   KEXEC_MAGIC
+    .long    0
+    .long    0
+relocate_smp_cpu_wait_end:
+    .globl relocate_smp_cpu_size
+relocate_smp_cpu_size:
+    .long relocate_smp_cpu_wait_end-relocate_smp_cpu_wait
+#endif
+
 #endif
diff --git a/arch/powerpc/platforms/85xx/smp.c
b/arch/powerpc/platforms/85xx/smp.c
old mode 100644
new mode 100755
index 5ced4f5..c4f5c4c
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -140,6 +140,70 @@ static inline u32 read_spin_table_addr_l(void *spin_table)
         (ulong)spin_table + sizeof(struct epapr_spin_table));
     return in_be32(&((struct epapr_spin_table *)spin_table)->addr_l);
 }
+#ifdef CONFIG_KEXEC
+
+#define KEXEC_MAGIC 0xdeadbeef
+#define KEXEC_RESERVE_LIMIT 0x10
+unsigned long kexec_poll_phy;
+extern void reserve_kexec_bootmem(unsigned long poll_phy, int size);
+
+/*
+ * Reserved bootmem for slave cpus kexec spin area.
+ */
+void mpc85xx_smp_reserve_kexec(void)
+{
+    unsigned long kexec_poll_virt;
+    unsigned long *kexec_magic_virt;
+
+    if (!kexec_poll_phy ||
+            kexec_poll_phy >= __max_low_memory)
+        return;
+
+    kexec_poll_virt = (unsigned long)phys_to_virt(kexec_poll_phy);
+    kexec_magic_virt = (unsigned long *)kexec_poll_virt;
+
+    if (*kexec_magic_virt == KEXEC_MAGIC)
+        reserve_kexec_bootmem(kexec_poll_phy, KEXEC_RESERVE_LIMIT);
+}
+
+/*
+ * Kick slave cpus from kexec spin area.
+ */
+int mpc85xx_smp_kick_kexec_cpus(int nr)
+{
+    unsigned long  kexec_poll_virt;
+    unsigned long *kexec_flag_virt;
+    unsigned long *kexec_magic_virt;
+    unsigned long *kexec_jump_virt;
+
+    /*verify accessible*/
+    if (!kexec_poll_phy ||
+            kexec_poll_phy >= __max_low_memory)
+        return -EBUSY;
+
+    kexec_poll_virt = (unsigned long)phys_to_virt(kexec_poll_phy);
+
+    kexec_magic_virt = (unsigned long *)kexec_poll_virt;
+    kexec_flag_virt = (unsigned long *)kexec_poll_virt + 1;
+    kexec_jump_virt = (unsigned long *)kexec_poll_virt + 2;
+
+    /*verify a valid kexec kick*/
+    if (*kexec_magic_virt == KEXEC_MAGIC) {
+        flush_dcache_range((ulong)kexec_poll_virt,
+        (ulong)kexec_poll_virt + L1_CACHE_BYTES-1);
+        *kexec_jump_virt = (unsigned long)__early_start;
+        mb();
+        /*kick cpu[nr] up*/
+        *kexec_flag_virt = nr;
+        mb();
+        flush_dcache_range((ulong)kexec_poll_virt,
+        (ulong)kexec_poll_virt + L1_CACHE_BYTES-1);
+
+        return 0;
+    }
+    return -EBUSY;
+}
+#endif

 static int smp_85xx_kick_cpu(int nr)
 {
@@ -181,6 +245,10 @@ static int smp_85xx_kick_cpu(int nr)

     local_irq_save(flags);
 #ifdef CONFIG_PPC32
+#ifdef CONFIG_KEXEC
+    if (!mpc85xx_smp_kick_kexec_cpus(nr))
+        goto kexec_kick_done;
+#endif
 #ifdef CONFIG_HOTPLUG_CPU
     /* Corresponding to generic_set_cpu_dead() */
     generic_set_cpu_up(nr);
@@ -225,7 +293,9 @@ static int smp_85xx_kick_cpu(int nr)
     out_be32(&spin_table->pir, hw_cpu);
     out_be32(&spin_table->addr_l, __pa(__early_start));
     flush_spin_table(spin_table);
-
+#ifdef CONFIG_KEXEC
+kexec_kick_done:
+#endif
     /* Wait a bit for the CPU to ack. */
     if (!spin_event_timeout(__secondary_hold_acknowledge == hw_cpu,
                     10000, 100)) {
@@ -266,7 +336,13 @@ struct smp_ops_t smp_85xx_ops = {
 };

 #ifdef CONFIG_KEXEC
+
 atomic_t kexec_down_cpus = ATOMIC_INIT(0);
+atomic_t kexec_ready_to_reboot = ATOMIC_INIT(0);
+atomic_t kexec_slave_finish = ATOMIC_INIT(0);
+unsigned long wait_code_buffer;
+static struct kimage *save_image;
+extern const unsigned int relocate_smp_cpu_size;

 void mpc85xx_smp_kexec_cpu_down(int crash_shutdown, int secondary)
 {
@@ -274,8 +350,29 @@ void mpc85xx_smp_kexec_cpu_down(int
crash_shutdown, int secondary)

     if (secondary) {
         atomic_inc(&kexec_down_cpus);
-        /* loop forever */
-        while (1);
+        mb();
+
+        if (crash_shutdown) {
+            /* loop forever */
+            while (1)
+                ;
+        } else {
+            while (!atomic_read(&kexec_ready_to_reboot))
+                cpu_relax();
+            /*flush destination*/
+            if (save_image)
+                mpc85xx_smp_flush_dcache_kexec(save_image, 1);
+
+            flush_icache_range(wait_code_buffer,
+                wait_code_buffer + relocate_smp_cpu_size);
+            flush_dcache_range(wait_code_buffer,
+                wait_code_buffer + relocate_smp_cpu_size);
+
+            atomic_inc(&kexec_slave_finish);
+
+            ((void (*)(void)) wait_code_buffer)();
+            /* NOTREACHED */
+        }
     }
 }

@@ -285,13 +382,23 @@ static void mpc85xx_smp_kexec_down(void *arg)
         ppc_md.kexec_cpu_down(0,1);
 }

-static void map_and_flush(unsigned long paddr)
+static void map_and_flush(unsigned long paddr, int atomic)
 {
     struct page *page = pfn_to_page(paddr >> PAGE_SHIFT);
-    unsigned long kaddr  = (unsigned long)kmap(page);
+    unsigned long kaddr;
+
+    if (atomic)
+        kaddr  = (unsigned long)kmap_atomic(page);
+    else
+        kaddr  = (unsigned long)kmap(page);

     flush_dcache_range(kaddr, kaddr + PAGE_SIZE);
-    kunmap(page);
+    flush_icache_range(kaddr, kaddr + PAGE_SIZE);
+
+    if (atomic)
+        kunmap_atomic((void *)kaddr);
+    else
+        kunmap(page);
 }

 /**
@@ -300,7 +407,7 @@ static void map_and_flush(unsigned long paddr)
  * are performed out of an overabundance of caution as interrupts are not
  * disabled yet and we can switch cores
  */
-static void mpc85xx_smp_flush_dcache_kexec(struct kimage *image)
+static void mpc85xx_smp_flush_dcache_kexec(struct kimage *image, int atomic)
 {
     kimage_entry_t *ptr, entry;
     unsigned long paddr;
@@ -312,18 +419,18 @@ static void
mpc85xx_smp_flush_dcache_kexec(struct kimage *image)
              ptr = (entry & IND_INDIRECTION) ?
                 phys_to_virt(entry & PAGE_MASK) : ptr + 1) {
             if (!(entry & IND_DESTINATION)) {
-                map_and_flush(entry);
+                map_and_flush(entry, atomic);
             }
         }
         /* flush out last IND_DONE page */
-        map_and_flush(entry);
+        map_and_flush(entry, atomic);
     } else {
         /* crash type kexec images are copied to the crash region */
         for (i = 0; i < image->nr_segments; i++) {
             struct kexec_segment *seg = &image->segment[i];
             for (paddr = seg->mem; paddr < seg->mem + seg->memsz;
                  paddr += PAGE_SIZE) {
-                map_and_flush(paddr);
+                map_and_flush(paddr, atomic);
             }
         }
     }
@@ -335,13 +442,18 @@ static void
mpc85xx_smp_flush_dcache_kexec(struct kimage *image)

 static void mpc85xx_smp_machine_kexec(struct kimage *image)
 {
+    extern const unsigned char  relocate_smp_cpu_wait[];
+    extern const unsigned int relocate_smp_cpu_offset;
     int timeout = INT_MAX;
     int i, num_cpus = num_present_cpus();

     mpc85xx_smp_flush_dcache_kexec(image);

-    if (image->type == KEXEC_TYPE_DEFAULT)
+    if (image->type == KEXEC_TYPE_DEFAULT) {
+        save_image = image;
+        mb();
         smp_call_function(mpc85xx_smp_kexec_down, NULL, 0);
+    }

     while ( (atomic_read(&kexec_down_cpus) != (num_cpus - 1)) &&
         ( timeout > 0 ) )
@@ -352,12 +464,34 @@ static void mpc85xx_smp_machine_kexec(struct
kimage *image)
     if ( !timeout )
         printk(KERN_ERR "Unable to bring down secondary cpu(s)");

-    for_each_online_cpu(i)
-    {
-        if ( i == smp_processor_id() ) continue;
-        mpic_reset_core(i);
-    }
+    if (image->type == KEXEC_TYPE_DEFAULT) {

+        wait_code_buffer =
+        (unsigned long)page_address(image->control_code_page)+
+                relocate_smp_cpu_offset;
+
+        /* copy slave cpu spin code to the control code page */
+        memcpy((void *)wait_code_buffer, relocate_smp_cpu_wait,
+                        relocate_smp_cpu_size);
+        atomic_set(&kexec_ready_to_reboot, 1);
+        mb();
+        timeout = INT_MAX;
+
+        while ((atomic_read(&kexec_slave_finish) != (num_cpus-1)) &&
+            (timeout > 0))
+            timeout--;
+
+        if (!timeout)
+            printk(KERN_ERR "Unable to wait for secondary cpu(s) to
flush caches\n");
+
+        } else {
+        for_each_online_cpu(i)
+        {
+            if (i == smp_processor_id())
+                continue;
+            mpic_reset_core(i);
+        }
+    }
     default_machine_kexec(image);
 }
 #endif /* CONFIG_KEXEC */
-- 
1.7.1
