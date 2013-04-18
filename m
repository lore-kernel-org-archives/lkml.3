Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964971Ab3DRCE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 22:04:59 -0400
Received: from relay1.sgi.com ([192.48.179.29]:36295 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935698Ab3DRCE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 22:04:58 -0400
Date: Wed, 17 Apr 2013 21:04:56 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -v5 5/5] Make reboot_cpuid a kernel parameter.
Message-ID: <20130418020456.GO3658@sgi.com>
References: <1366224198-49485-1-git-send-email-holt@sgi.com>
 <1366224198-49485-6-git-send-email-holt@sgi.com>
 <516EF9DE.6000707@zytor.com>
 <20130417194836.GK3658@sgi.com>
 <516EFF3D.4040506@zytor.com>
 <20130417201533.GL3658@sgi.com>
 <20130418001726.GM3658@sgi.com>
 <516F40C5.40409@zytor.com>
 <20130418012539.GN3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418012539.GN3658@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 08:25:39PM -0500, Robin Holt wrote:
> On Wed, Apr 17, 2013 at 05:39:33PM -0700, H. Peter Anvin wrote:
> > On 04/17/2013 05:17 PM, Robin Holt wrote:
> > > 
> > > There are 4 items being parsed out of reboot= for x86:
> > >  - reboot_mode		w[arm] | c[old]
> > >  - reboot_cpu		s[mp]####
> > >  - reboot_type		b[ios] | a[cpi] | k[bd] | t[riple] | e[fi] | p[ci]
> > >  - reboot_force		f[orce]
> > > 
> > > This seems like a lot to push into the generic kernel just to make it
> > > appear consistent when there will be no real cross arch consistency.
> > > 
> > > Contrast that with:
> > > 1) New kernel parameter (reboot_cpu) which is clear and concise, uses standard
> > >    parsing methods.
> > > 2) Backwards compatibility in that a user with an existing (broken) reboot=s32
> > >    on the command line will set reboot_cpu unless both were specified, in which
> > >    case reboot_cpu takes precedence.
> > > 
> > > What is so fundamentally wrong with that?  It accomplishes exactly what
> > > you had asked for in that existing users are not broken.  We are introducing
> > > a new functionality in the general kernel.  Why not introduce a new parameter
> > > associated with that functionality.
> > > 
> > 
> > You are confusing implementation with interface.  That is what is so
> > fundamentally wrong with that.  You really, really don't want to change
> > interface unless the world will end if you don't.
> > 
> > As far as why centralize -- the main concern I have is that someone
> > might try to introduce an arch-specific reboot= which is *syntactically*
> > different, which is yet again really awful from a user perspective.
> 
> Yes and no.  I am saying that the interface is garbage and already
> specified as arch specific.  You are asking me to take that garbage
> interface and promote it to a general interface which will force us to
> implement it in a completely crappy way.
> 
> Compare that with introducing a new interface which is concise and then
> providing backwards compatibility.  Add to that the fact, I don't need
> to pollute the kernel with some poorly done x86 interface and leave that
> cruft for others to clean up.

OK.  Here goes:

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..35af99e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2593,9 +2593,17 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Run specified binary instead of /init from the ramdisk,
 			used for early userspace startup. See initrd.
 
-	reboot=		[BUGS=X86-32,BUGS=ARM,BUGS=IA-64] Rebooting mode
-			Format: <reboot_mode>[,<reboot_mode2>[,...]]
-			See arch/*/kernel/reboot.c or arch/*/kernel/process.c
+	reboot=		[KNL]
+			Format:
+				[w[arm] | c[old]] \
+				[,b[ios] | a[cpi] | k[bd] | t[riple] | e[fi] | p[ci]] \
+				[,f[orce] \
+				[,] s[mp]####
+			Where reboot_mode is one of warm or cold,
+			      reboot_type is one of bios, acpi, kbd, triple, efi, or pci,
+			      reboot_force is either force or not specified,
+			      and reboot_cpu is s[mp]#### with #### being the
+			      processor to be used for rebooting.
 
 	relax_domain_level=
 			[KNL, SMP] Set scheduler's default relax_domain_level.
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 76fa1e9..f9e8bf4 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -36,22 +36,11 @@ void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
-static int reboot_mode;
-enum reboot_type reboot_type = BOOT_ACPI;
-int reboot_force;
+extern int reboot_mode;
+extern enum reboot_type reboot_type;
+extern int reboot_force;
 
-/*
- * This variable is used privately to keep track of whether or not
- * reboot_type is still set to its default value (i.e., reboot= hasn't
- * been set on the command line).  This is needed so that we can
- * suppress DMI scanning for reboot quirks.  Without it, it's
- * impossible to override a faulty reboot quirk without recompiling.
- */
-static int reboot_default = 1;
-
-#ifdef CONFIG_SMP
-static int reboot_cpu = -1;
-#endif
+extern int reboot_default;
 
 /*
  * This is set if we need to go through the 'emergency' path.
@@ -63,78 +52,6 @@ static int reboot_emergency;
 /* This is set by the PCI code if either type 1 or type 2 PCI is detected */
 bool port_cf9_safe = false;
 
-/*
- * reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
- * warm   Don't set the cold reboot flag
- * cold   Set the cold reboot flag
- * bios   Reboot by jumping through the BIOS
- * smp    Reboot by executing reset on BSP or other CPU
- * triple Force a triple fault (init)
- * kbd    Use the keyboard controller. cold reset (default)
- * acpi   Use the RESET_REG in the FADT
- * efi    Use efi reset_system runtime service
- * pci    Use the so-called "PCI reset register", CF9
- * force  Avoid anything that could hang.
- */
-static int __init reboot_setup(char *str)
-{
-	for (;;) {
-		/*
-		 * Having anything passed on the command line via
-		 * reboot= will cause us to disable DMI checking
-		 * below.
-		 */
-		reboot_default = 0;
-
-		switch (*str) {
-		case 'w':
-			reboot_mode = 0x1234;
-			break;
-
-		case 'c':
-			reboot_mode = 0;
-			break;
-
-#ifdef CONFIG_SMP
-		case 's':
-			if (isdigit(*(str+1))) {
-				reboot_cpu = (int) (*(str+1) - '0');
-				if (isdigit(*(str+2)))
-					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
-			}
-			/*
-			 * We will leave sorting out the final value
-			 * when we are ready to reboot, since we might not
-			 * have detected BSP APIC ID or smp_num_cpu
-			 */
-			break;
-#endif /* CONFIG_SMP */
-
-		case 'b':
-		case 'a':
-		case 'k':
-		case 't':
-		case 'e':
-		case 'p':
-			reboot_type = *str;
-			break;
-
-		case 'f':
-			reboot_force = 1;
-			break;
-		}
-
-		str = strchr(str, ',');
-		if (str)
-			str++;
-		else
-			break;
-	}
-	return 1;
-}
-
-__setup("reboot=", reboot_setup);
-
 
 /*
  * Reboot options and system auto-detection code provided by
@@ -614,26 +531,10 @@ void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
-
-	/* The boot cpu is always logical cpu 0 */
-	int reboot_cpu_id = 0;
-
-	/* See if there has been given a command line override */
-	if ((reboot_cpu != -1) && (reboot_cpu < nr_cpu_ids) &&
-		cpu_online(reboot_cpu))
-		reboot_cpu_id = reboot_cpu;
-
-	/* Make certain the cpu I'm about to reboot on is online */
-	if (!cpu_online(reboot_cpu_id))
-		reboot_cpu_id = smp_processor_id();
-
-	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
-
 	/*
-	 * O.K Now that I'm on the appropriate processor, stop all of the
-	 * others. Also disable the local irq to not receive the per-cpu
-	 * timer interrupt which may trigger scheduler's load balance.
+	 * Stop all of the others. Also disable the local irq to
+	 * not receive the per-cpu timer interrupt which may trigger
+	 * scheduler's load balance.
 	 */
 	local_irq_disable();
 	stop_other_cpus();
diff --git a/kernel/reboot.c b/kernel/reboot.c
index 7f4658f..3448a1d 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -6,6 +6,7 @@
 
 #define pr_fmt(fmt)	"reboot: " fmt
 
+#include <linux/ctype.h>
 #include <linux/export.h>
 #include <linux/kexec.h>
 #include <linux/kmod.h>
@@ -69,22 +70,107 @@ int unregister_reboot_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+/*
+ * This variable is used privately to keep track of whether or not
+ * reboot_type is still set to its default value (i.e., reboot= hasn't
+ * been set on the command line).  This is needed so that we can
+ * suppress DMI scanning for reboot quirks.  Without it, it's
+ * impossible to override a faulty reboot quirk without recompiling.
+ */
+int reboot_default = 1;
+int reboot_mode;
+enum reboot_type reboot_type = BOOT_ACPI;
+int reboot_force;
+static int reboot_cpu;
+
+/*
+ * reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
+ * warm   Don't set the cold reboot flag
+ * cold   Set the cold reboot flag
+ * bios   Reboot by jumping through the BIOS
+ * smp    Reboot by executing reset on BSP or other CPU
+ * triple Force a triple fault (init)
+ * kbd    Use the keyboard controller. cold reset (default)
+ * acpi   Use the RESET_REG in the FADT
+ * efi    Use efi reset_system runtime service
+ * pci    Use the so-called "PCI reset register", CF9
+ * force  Avoid anything that could hang.
+ */
+static int __init reboot_setup(char *str)
+{
+	int i;
+
+	for (;;) {
+		/*
+		 * Having anything passed on the command line via
+		 * reboot= will cause us to disable DMI checking
+		 * below.
+		 */
+		reboot_default = 0;
+
+		switch (*str) {
+		case 'w':
+			reboot_mode = 0x1234;
+			break;
+
+		case 'c':
+			reboot_mode = 0;
+			break;
+
+#ifdef CONFIG_SMP
+		case 's':
+			if (*(str + 1) == 'm' && *(str + 2) == 'p')
+				str += 2;
+
+			reboot_cpu = 0;
+			for (i = 1; isdigit(*(str + i)); i++) {
+				reboot_cpu *= 10;
+				reboot_cpu += (int)(*(str + i) - '0');
+			}
+
+			break;
+#endif /* CONFIG_SMP */
+
+		case 'b':
+		case 'a':
+		case 'k':
+		case 't':
+		case 'e':
+		case 'p':
+			reboot_type = *str;
+			break;
+
+		case 'f':
+			reboot_force = 1;
+			break;
+		}
+
+		str = strchr(str, ',');
+		if (str)
+			str++;
+		else
+			break;
+	}
+	return 1;
+}
+__setup("reboot=", reboot_setup);
+
+
 static void migrate_to_reboot_cpu(void)
 {
-	/* The boot cpu is always logical cpu 0 */
-	int reboot_cpu_id = 0;
+	int cpu = reboot_cpu;
 
 	cpu_hotplug_disable();
 
 	/* Make certain the cpu I'm about to reboot on is online */
-	if (!cpu_online(reboot_cpu_id))
-		reboot_cpu_id = cpumask_first(cpu_online_mask);
+	if (!cpu_online(cpu))
+		cpu = cpumask_first(cpu_online_mask);
 
 	/* Prevent races with other tasks migrating this task */
 	current->flags |= PF_THREAD_BOUND;
 
 	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 }
 
 /**
