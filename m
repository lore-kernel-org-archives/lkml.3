Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbaLIMob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:44:31 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:32819 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbaLIMoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:44:30 -0500
Date: Tue, 9 Dec 2014 13:44:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups tree changes for v3.19
Message-ID: <20141209124424.GA29968@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   # HEAD: 29cc3730370f5fef9762a90fb515a8b1cd5fd7a6 Merge tag 'x86_queue_for_3.19' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp into x86/cleanups

Misc cleanups.

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      x86, espfix: Remove stale ptemask
      x86, CPU, AMD: Move K8 TLB flush filter workaround to K8 code

Fabian Frederick (6):
      x86, cpuid: Use PTR_ERR_OR_ZERO
      x86/sysfb: Use PTR_ERR_OR_ZERO
      x86/simplefb: Use PTR_ERR_OR_ZERO
      x86, msr: Use PTR_ERR_OR_ZERO
      x86, msr: Convert printk to pr_foo()
      x86, msr: Use seek definitions instead of hard-coded values


 arch/x86/kernel/cpu/amd.c        | 23 +++++++++++------------
 arch/x86/kernel/cpuid.c          |  2 +-
 arch/x86/kernel/espfix_64.c      |  3 ---
 arch/x86/kernel/msr.c            | 11 ++++++-----
 arch/x86/kernel/sysfb.c          |  2 +-
 arch/x86/kernel/sysfb_simplefb.c |  5 +----
 6 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 813d29d00a17..15c5df92f74e 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -566,6 +566,17 @@ static void init_amd_k8(struct cpuinfo_x86 *c)
 
 	if (!c->x86_model_id[0])
 		strcpy(c->x86_model_id, "Hammer");
+
+#ifdef CONFIG_SMP
+	/*
+	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
+	 * bit 6 of msr C001_0015
+	 *
+	 * Errata 63 for SH-B3 steppings
+	 * Errata 122 for all steppings (F+ have it disabled by default)
+	 */
+	msr_set_bit(MSR_K7_HWCR, 6);
+#endif
 }
 
 static void init_amd_gh(struct cpuinfo_x86 *c)
@@ -636,18 +647,6 @@ static void init_amd(struct cpuinfo_x86 *c)
 {
 	u32 dummy;
 
-#ifdef CONFIG_SMP
-	/*
-	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
-	 * bit 6 of msr C001_0015
-	 *
-	 * Errata 63 for SH-B3 steppings
-	 * Errata 122 for all steppings (F+ have it disabled by default)
-	 */
-	if (c->x86 == 0xf)
-		msr_set_bit(MSR_K7_HWCR, 6);
-#endif
-
 	early_init_amd(c);
 
 	/*
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 3225ae6c5180..83741a71558f 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -143,7 +143,7 @@ static int cpuid_device_create(int cpu)
 
 	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu), NULL,
 			    "cpu%d", cpu);
-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+	return PTR_ERR_OR_ZERO(dev);
 }
 
 static void cpuid_device_destroy(int cpu)
diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
index 94d857fb1033..f5d0730e7b08 100644
--- a/arch/x86/kernel/espfix_64.c
+++ b/arch/x86/kernel/espfix_64.c
@@ -122,9 +122,6 @@ static void init_espfix_random(void)
 void __init init_espfix_bsp(void)
 {
 	pgd_t *pgd_p;
-	pteval_t ptemask;
-
-	ptemask = __supported_pte_mask;
 
 	/* Install the espfix pud into the kernel page directory */
 	pgd_p = &init_level4_pgt[pgd_index(ESPFIX_BASE_ADDR)];
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index c9603ac80de5..113e70784854 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -22,6 +22,8 @@
  * an SMP box will direct the access to CPU %d.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 
 #include <linux/types.h>
@@ -50,11 +52,11 @@ static loff_t msr_seek(struct file *file, loff_t offset, int orig)
 
 	mutex_lock(&inode->i_mutex);
 	switch (orig) {
-	case 0:
+	case SEEK_SET:
 		file->f_pos = offset;
 		ret = file->f_pos;
 		break;
-	case 1:
+	case SEEK_CUR:
 		file->f_pos += offset;
 		ret = file->f_pos;
 		break;
@@ -206,7 +208,7 @@ static int msr_device_create(int cpu)
 
 	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, cpu), NULL,
 			    "msr%d", cpu);
-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+	return PTR_ERR_OR_ZERO(dev);
 }
 
 static void msr_device_destroy(int cpu)
@@ -248,8 +250,7 @@ static int __init msr_init(void)
 	i = 0;
 
 	if (__register_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr", &msr_fops)) {
-		printk(KERN_ERR "msr: unable to get major %d for msr\n",
-		       MSR_MAJOR);
+		pr_err("unable to get major %d for msr\n", MSR_MAJOR);
 		err = -EBUSY;
 		goto out;
 	}
diff --git a/arch/x86/kernel/sysfb.c b/arch/x86/kernel/sysfb.c
index 193ec2ce46c7..160386e9fc17 100644
--- a/arch/x86/kernel/sysfb.c
+++ b/arch/x86/kernel/sysfb.c
@@ -67,7 +67,7 @@ static __init int sysfb_init(void)
 
 	pd = platform_device_register_resndata(NULL, name, 0,
 					       NULL, 0, si, sizeof(*si));
-	return IS_ERR(pd) ? PTR_ERR(pd) : 0;
+	return PTR_ERR_OR_ZERO(pd);
 }
 
 /* must execute after PCI subsystem for EFI quirks */
diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 86179d409893..764a29f84de7 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -88,8 +88,5 @@ __init int create_simplefb(const struct screen_info *si,
 
 	pd = platform_device_register_resndata(NULL, "simple-framebuffer", 0,
 					       &res, 1, mode, sizeof(*mode));
-	if (IS_ERR(pd))
-		return PTR_ERR(pd);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(pd);
 }
