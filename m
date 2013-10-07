Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab3JGJoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 05:44:05 -0400
Received: from multi.imgtec.com ([194.200.65.239]:33696 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab3JGJoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:44:03 -0400
Message-ID: <5252825D.5000803@imgtec.com>
Date: Mon, 7 Oct 2013 10:43:57 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Rob Herring <rob.herring@calxeda.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-metag@vger.kernel.org>
Subject: Re: Commit f26150004 (metag: use common of_flat_dt_match_machine)
 causes metag build failures in linux-next
References: <5251AB52.3000506@roeck-us.net>
In-Reply-To: <5251AB52.3000506@roeck-us.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_10_07_10_43_59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/13 19:26, Guenter Roeck wrote:
> arch/metag/kernel/devtree.c: In function 'setup_machine_fdt':
> arch/metag/kernel/devtree.c:52: error: 'arch_get_next_mach' undeclared
> (first use in this function)
> arch/metag/kernel/devtree.c:52: error: (Each undeclared identifier is
> reported only once
> arch/metag/kernel/devtree.c:52: error: for each function it appears in.)
> arch/metag/kernel/devtree.c:52: warning: assignment discards qualifiers
> from pointer target type
> make[1]: *** [arch/metag/kernel/devtree.o] Error 1
> 
> Not surprising, since arch_get_next_mach() is not defined for metag.
> 
> Guenter

Thanks for reporting Guenter (and taking the time to set up auto-building
of different arches - we have a metag buildbot but it hasn't been
tracking the temporary linux-next URL).

Rob, sorry I didn't get around to testing your revised patchset until
now. Please apply something like the patch below (preferably as a fixup)
for f261500 (metag: use common of_flat_dt_match_machine).

This will cause a rebase conflict in "metag: move setup_machine_fdt
declaration from prom.h" since I added const to setup_machine_fdt()'s
return pointer, so that const needs adding to setup.h too.

Does that sound okay?

Thanks
James

>From 821871cba80e00e8d42a38deb8ea2505481e9f1d Mon Sep 17 00:00:00 2001
From: James Hogan <james.hogan@imgtec.com>
Date: Mon, 7 Oct 2013 10:11:23 +0100
Subject: [PATCH FIXUP] metag: fix build error converting to
 of_flat_dt_match_machine

Fix the following build error and warning due to commit f261500 (metag:
use common of_flat_dt_match_machine):

  arch/metag/kernel/devtree.c: In function 'setup_machine_fdt':
  arch/metag/kernel/devtree.c:52: error: 'arch_get_next_mach' undeclared (first use in this function)
  arch/metag/kernel/devtree.c:52: error: (Each undeclared identifier is reported only once
  arch/metag/kernel/devtree.c:52: error: for each function it appears in.)
  arch/metag/kernel/devtree.c:52: warning: assignment discards qualifiers from pointer target type
  make[1]: *** [arch/metag/kernel/devtree.o] Error 1

The arch_get_next_mach() function was missing, and there was a const
mismatch which I've pushed out to the global machine_desc pointer. Also
fix a little broken indentation (due presumably to the multiline
comment) and added back a pr_info of the name of the machine which the
kernel is using, as that's often useful to tell if it's using a more
generic machine than it should be.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/mach/arch.h |  2 +-
 arch/metag/include/asm/prom.h      |  2 +-
 arch/metag/kernel/devtree.c        | 20 +++++++++++++++++---
 arch/metag/kernel/setup.c          |  2 +-
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/metag/include/asm/mach/arch.h b/arch/metag/include/asm/mach/arch.h
index 12c5664..433f946 100644
--- a/arch/metag/include/asm/mach/arch.h
+++ b/arch/metag/include/asm/mach/arch.h
@@ -53,7 +53,7 @@ struct machine_desc {
 /*
  * Current machine - only accessible during boot.
  */
-extern struct machine_desc *machine_desc;
+extern const struct machine_desc *machine_desc;
 
 /*
  * Machine type table - also only accessible during boot
diff --git a/arch/metag/include/asm/prom.h b/arch/metag/include/asm/prom.h
index d2aa35d..9f67cbf 100644
--- a/arch/metag/include/asm/prom.h
+++ b/arch/metag/include/asm/prom.h
@@ -17,7 +17,7 @@
 #include <asm/setup.h>
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
-extern struct machine_desc *setup_machine_fdt(void *dt);
+extern const struct machine_desc *setup_machine_fdt(void *dt);
 extern void copy_fdt(void);
 
 #endif /* __ASM_METAG_PROM_H */
diff --git a/arch/metag/kernel/devtree.c b/arch/metag/kernel/devtree.c
index bf9df90..18dd7ae 100644
--- a/arch/metag/kernel/devtree.c
+++ b/arch/metag/kernel/devtree.c
@@ -34,6 +34,19 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 	return alloc_bootmem_align(size, align);
 }
 
+static const void * __init arch_get_next_mach(const char *const **match)
+{
+	static const struct machine_desc *mdesc = __arch_info_begin;
+	const struct machine_desc *m = mdesc;
+
+	if (m >= __arch_info_end)
+		return NULL;
+
+	mdesc++;
+	*match = m->dt_compat;
+	return m;
+}
+
 /**
  * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
  * @dt:		virtual address pointer to dt blob
@@ -41,9 +54,9 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
  * If a dtb was passed to the kernel, then use it to choose the correct
  * machine_desc and to setup the system.
  */
- struct machine_desc * __init setup_machine_fdt(void *dt)
- {
-	struct machine_desc *mdesc;
+const struct machine_desc * __init setup_machine_fdt(void *dt)
+{
+	const struct machine_desc *mdesc;
 
 	/* check device tree validity */
 	if (!early_init_dt_scan(dt))
@@ -52,6 +65,7 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 	mdesc = of_flat_dt_match_machine(NULL, arch_get_next_mach);
 	if (!mdesc)
 		dump_machine_table(); /* does not return */
+	pr_info("Machine name: %s\n", mdesc->name);
 
 	return mdesc;
 }
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index 2c697d3..92cc119 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -115,7 +115,7 @@ extern u32 __dtb_start[];
 extern struct console dash_console;
 #endif
 
-struct machine_desc *machine_desc __initdata;
+const struct machine_desc *machine_desc __initdata;
 
 /*
  * Map a Linux CPU number to a hardware thread ID
-- 
1.8.1.2

