Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaAWAi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:38:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39981 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaAWAiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:38:24 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1390011895-28123-2-git-send-email-mukesh.rathor@oracle.com>
References: <1390011895-28123-1-git-send-email-mukesh.rathor@oracle.com> <1390011895-28123-2-git-send-email-mukesh.rathor@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [V0 PATCH] xen/pvh: set some cr flags upon vcpu start
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 17 Jan 2014 22:20:53 -0500
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: roger.pau@citrix.com, Xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Message-ID: <f0ca98c8-b89d-4849-b8bc-a78cd8d54db9@email.android.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mukesh Rathor <mukesh.rathor@oracle.com> wrote:
>pvh was designed to start with pv flags, but a commit in xen tree
>51e2cac257ec8b4080d89f0855c498cbbd76a5e5 removed some of the flags as

"Name of the patch in the Xen tree"

>they are not necessary. As a result, these CR flags must be set in the
>guest.

>
>Signed-off-by: Roger Pau Monne <roger.pau@citrix.com>

You missed modifying the patch to reflect the authorship to be Roger's.

Please use git commit --amend --author "somebody s name " 

Also Roger should be credited with Reported-by. I can add that.

>Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
>---
>arch/x86/xen/enlighten.c |   43
>+++++++++++++++++++++++++++++++++++++------
> arch/x86/xen/smp.c       |    2 +-
> arch/x86/xen/xen-ops.h   |    2 +-
> 3 files changed, 39 insertions(+), 8 deletions(-)
>
>diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
>index 628099a..4a2aaa6 100644
>--- a/arch/x86/xen/enlighten.c
>+++ b/arch/x86/xen/enlighten.c
>@@ -1410,12 +1410,8 @@ static void __init
>xen_boot_params_init_edd(void)
>  * Set up the GDT and segment registers for -fstack-protector.  Until
>  * we do this, we have to be careful not to call any stack-protected
>  * function, which is most of the kernel.
>- *
>- * Note, that it is refok - because the only caller of this after init
>- * is PVH which is not going to use xen_load_gdt_boot or other
>- * __init functions.
>  */
>-void __ref xen_setup_gdt(int cpu)
>+static void xen_setup_gdt(int cpu)
> 	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> #ifdef CONFIG_X86_64
>@@ -1463,13 +1459,48 @@ void __ref xen_setup_gdt(int cpu)
> 	pv_cpu_ops.load_gdt = xen_load_gdt;
> }
> 
>+/*
>+ * A pv guest starts with default flags that are not set for pvh, set
>them
>+ * here asap.
>+ */
>+static void xen_pvh_set_cr_flags(int cpu)

>+{

Pls add:

/* See 'secondary_startup_64' for how bare metal does it. */

>+	write_cr0(read_cr0() | X86_CR0_MP | X86_CR0_WP | X86_CR0_AM);
>+
>+	if (!cpu)
>+		return;
>+	/*
>+	 * Unlike PV, for pvh xen does not set: PSE PGE OSFXSR OSXMMEXCPT
>+	 * For BSP, PSE PGE will be set in probe_page_size_mask(), for AP
>+	 * set them here. For all, OSFXSR

Might want to mention that for AP on bare metal they are set in 'secondary_start_64'

... 
>+	 */

Is it OK to set this twice? 

Meaning remove the 'if (!cpu)..' check so that this code path is run for BSP and AP?

>+	if (cpu_has_pse)
>+		set_in_cr4(X86_CR4_PSE);
>+
>+	if (cpu_has_pge)
>+		set_in_cr4(X86_CR4_PGE);
>+}
>+
>+/*
>+ * Note, that it is refok - because the only caller of this after init
>+ * is PVH which is not going to use xen_load_gdt_boot or other
>+ * __init functions.

Hmm. You must be using and older tree. The new one has __ref comment.

>+ */
>+void __ref xen_pvh_secondary_vcpu_init(int cpu)
>+{
>+	xen_setup_gdt(cpu);
>+	xen_pvh_set_cr_flags(cpu);
>+}
>+
> static void __init xen_pvh_early_guest_init(void)
> {
> 	if (!xen_feature(XENFEAT_auto_translated_physmap))
> 		return;
> 
>-	if (xen_feature(XENFEAT_hvm_callback_vector))
>+	if (xen_feature(XENFEAT_hvm_callback_vector)) 

> 		xen_have_vector_callback = 1;
>+		xen_pvh_set_cr_flags(0);
>+	}
> 
> #ifdef CONFIG_X86_32
> 	BUG(); /* PVH: Implement proper support. */
>diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
>index 5e46190..a18eadd 100644
>--- a/arch/x86/xen/smp.c
>+++ b/arch/x86/xen/smp.c
>@@ -105,7 +105,7 @@ static void cpu_bringup_and_idle(int cpu)
> #ifdef CONFIG_X86_64
> 	if (xen_feature(XENFEAT_auto_translated_physmap) &&
> 	    xen_feature(XENFEAT_supervisor_mode_kernel))
>-		xen_setup_gdt(cpu);
>+		xen_pvh_secondary_vcpu_init(cpu);
> #endif
> 	cpu_bringup();
> 	cpu_startup_entry(CPUHP_ONLINE);
>diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
>index 9059c24..1cb6f4c 100644
>--- a/arch/x86/xen/xen-ops.h
>+++ b/arch/x86/xen/xen-ops.h
>@@ -123,5 +123,5 @@ __visible void xen_adjust_exception_frame(void);
> 
> extern int xen_panic_handler_init(void);
> 
>-void xen_setup_gdt(int cpu);
>+void xen_pvh_secondary_vcpu_init(int cpu);
> #endif /* XEN_OPS_H */

Thanks!
