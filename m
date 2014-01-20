Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaATPJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:09:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31598 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaATPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:09:41 -0500
Date: Mon, 20 Jan 2014 10:09:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Cc: roger.pau@citrix.com, Xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [V0 PATCH] xen/pvh: set some cr flags upon vcpu start
Message-ID: <20140120150930.GA4598@phenom.dumpdata.com>
References: <1390011895-28123-1-git-send-email-mukesh.rathor@oracle.com>
 <1390011895-28123-2-git-send-email-mukesh.rathor@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390011895-28123-2-git-send-email-mukesh.rathor@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 06:24:55PM -0800, Mukesh Rathor wrote:
> pvh was designed to start with pv flags, but a commit in xen tree

Thank you for posting this!

> 51e2cac257ec8b4080d89f0855c498cbbd76a5e5 removed some of the flags as

You need to always include the title of said commit.

> they are not necessary. As a result, these CR flags must be set in the
> guest.

I sent out replies to this over the weekend but somehow they are not
showing up.


> 
> Signed-off-by: Roger Pau Monne <roger.pau@citrix.com>

Since his SoB is first that implies that he is the author. But the
'From' line is from you. You can modify that by doing:

git commit --amend --author "Roger Pau Monne <roger.pau@citrix.com>"

> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> ---
>  arch/x86/xen/enlighten.c |   43 +++++++++++++++++++++++++++++++++++++------
>  arch/x86/xen/smp.c       |    2 +-
>  arch/x86/xen/xen-ops.h   |    2 +-
>  3 files changed, 39 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 628099a..4a2aaa6 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1410,12 +1410,8 @@ static void __init xen_boot_params_init_edd(void)
>   * Set up the GDT and segment registers for -fstack-protector.  Until
>   * we do this, we have to be careful not to call any stack-protected
>   * function, which is most of the kernel.
> - *
> - * Note, that it is refok - because the only caller of this after init
> - * is PVH which is not going to use xen_load_gdt_boot or other
> - * __init functions.
>   */
> -void __ref xen_setup_gdt(int cpu)
> +static void xen_setup_gdt(int cpu)
>  {
>  	if (xen_feature(XENFEAT_auto_translated_physmap)) {
>  #ifdef CONFIG_X86_64
> @@ -1463,13 +1459,48 @@ void __ref xen_setup_gdt(int cpu)
>  	pv_cpu_ops.load_gdt = xen_load_gdt;
>  }
>  
> +/*
> + * A pv guest starts with default flags that are not set for pvh, set them
> + * here asap.
> + */
> +static void xen_pvh_set_cr_flags(int cpu)
> +{
> +	write_cr0(read_cr0() | X86_CR0_MP | X86_CR0_WP | X86_CR0_AM);

You seem to be missing the X86_CR0_NE ?

The hypervisor sets "X86_CR0_PG" for PVH and uncondtionally for HVM
X86_CR0_TS, X86_CR0_PE, X86_CR0_ET so from the list of them that
'secondary_startup_64' sets:

208         /* Setup cr0 */
209 #define CR0_STATE       (X86_CR0_PE | X86_CR0_MP | X86_CR0_ET | \
210                          X86_CR0_NE | X86_CR0_WP | X86_CR0_AM | \
211                          X86_CR0_PG)
212         movl    $CR0_STATE, %eax


The one that is missing is NE. I fixed it up.

> +
> +	if (!cpu)
> +		return;

And what happens if don't have this check? Will be bad if do multiple
cr4 writes?

Fyi, this (cr4) should have been a seperate patch. I fixed it up that way.
> +	/*
> +	 * Unlike PV, for pvh xen does not set: PSE PGE OSFXSR OSXMMEXCPT
> +	 * For BSP, PSE PGE will be set in probe_page_size_mask(), for AP
> +	 * set them here. For all, OSFXSR OSXMMEXCPT will be set in fpu_init
> +	 */
> +	if (cpu_has_pse)
> +		set_in_cr4(X86_CR4_PSE);
> +
> +	if (cpu_has_pge)
> +		set_in_cr4(X86_CR4_PGE);
> +}

Seperate patch and since the PGE part is more complicated that just
setting the CR4 - you also have to tweak this:

1512         /* Prevent unwanted bits from being set in PTEs. */                     
1513         __supported_pte_mask &= ~_PAGE_GLOBAL;                                  

I think it should be done once we have actually confirmed that you can
do 2MB pages within the guest. (might need some more tweaking?)

> +
> +/*
> + * Note, that it is refok - because the only caller of this after init

Ah, you based this on a old commit. #linux-next is the one that has
the patches.

> + * is PVH which is not going to use xen_load_gdt_boot or other
> + * __init functions.
> + */
> +void __ref xen_pvh_secondary_vcpu_init(int cpu)
> +{
> +	xen_setup_gdt(cpu);
> +	xen_pvh_set_cr_flags(cpu);
> +}
> +
>  static void __init xen_pvh_early_guest_init(void)
>  {
>  	if (!xen_feature(XENFEAT_auto_translated_physmap))
>  		return;
>  
> -	if (xen_feature(XENFEAT_hvm_callback_vector))
> +	if (xen_feature(XENFEAT_hvm_callback_vector)) {
>  		xen_have_vector_callback = 1;
> +		xen_pvh_set_cr_flags(0);

Why? Why not make it unconditional? Or just change the
code to error out if !hvm_callback_vector?

Anyhow, I changed it in the patch.

> +	}
>  
>  #ifdef CONFIG_X86_32
>  	BUG(); /* PVH: Implement proper support. */
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 5e46190..a18eadd 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -105,7 +105,7 @@ static void cpu_bringup_and_idle(int cpu)
>  #ifdef CONFIG_X86_64
>  	if (xen_feature(XENFEAT_auto_translated_physmap) &&
>  	    xen_feature(XENFEAT_supervisor_mode_kernel))
> -		xen_setup_gdt(cpu);
> +		xen_pvh_secondary_vcpu_init(cpu);
>  #endif
>  	cpu_bringup();
>  	cpu_startup_entry(CPUHP_ONLINE);
> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> index 9059c24..1cb6f4c 100644
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -123,5 +123,5 @@ __visible void xen_adjust_exception_frame(void);
>  
>  extern int xen_panic_handler_init(void);
>  
> -void xen_setup_gdt(int cpu);
> +void xen_pvh_secondary_vcpu_init(int cpu);
>  #endif /* XEN_OPS_H */
> -- 
> 1.7.2.3
> 


Here is what I am thinking we should have in the tree:

>From 0a1574661b47544d2e880d579d1954dcbb6aa2c1 Mon Sep 17 00:00:00 2001
From: Roger Pau Monne <roger.pau@citrix.com>
Date: Mon, 20 Jan 2014 09:20:07 -0500
Subject: [PATCH] xen/pvh: Set X86_CR0_WP and others in CR0

otherwise we will get for some user-space applications
that use 'clone' with CLONE_CHILD_SETTID | CLONE_CHILD_CLEARTID
end up hitting an assert in glibc manifested by:

general protection ip:7f80720d364c sp:7fff98fd8a80 error:0 in
libc-2.13.so[7f807209e000+180000]

This is due to the nature of said operations which sets and clears
the PID.  "In the successful one I can see that the page table of
the parent process has been updated successfully to use a
different physical page, so the write of the tid on
that page only affects the child...

On the other hand, in the failed case, the write seems to happen before
the copy of the original page is done, so both the parent _and_ the child
end up with the same value (because the parent copies the page after
the write of the child tid has already happened)."
(Roger's analysis). The nature of this is due to the Xen's commit
of 51e2cac257ec8b4080d89f0855c498cbbd76a5e5
"x86/pvh: set only minimal cr0 and cr4 flags in order to use paging"
the CR0_WP was removed so COW features of the Linux kernel were not
operating properly.

While doing that also update the rest of the CR0 flags to be inline
with what a baremetal Linux kernel would set them to.

In 'secondary_startup_64' (baremetal Linux) sets:

X86_CR0_PE | X86_CR0_MP | X86_CR0_ET | X86_CR0_NE | X86_CR0_WP |
X86_CR0_AM | X86_CR0_PG

The hypervisor for HVM type guests (which PVH is a subset of) sets:
X86_CR0_PE | X86_CR0_ET | X86_CR0_TS
For PVH it specifically sets:
X86_CR0_PG

Which means we need to set the rest: X86_CR0_MP | X86_CR0_NE  |
X86_CR0_WP | X86_CR0_AM to have full parity.

Reported-and-Tested-by: Roger Pau Monne <roger.pau@citrix.com>
Signed-off-by: Roger Pau Monne <roger.pau@citrix.com>
Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[v1: Took out the cr4 writes to be a seperate patch]
---
 arch/x86/xen/enlighten.c |   31 +++++++++++++++++++++++++++++--
 arch/x86/xen/smp.c       |    2 +-
 arch/x86/xen/xen-ops.h   |    2 +-
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index b6d61c3..b320f2b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1462,13 +1462,40 @@ void __ref xen_setup_gdt(int cpu)
 	pv_cpu_ops.load_gdt = xen_load_gdt;
 }
 
+/*
+ * A PV guest starts with default flags that are not set for PVH, set them
+ * here asap.
+ */
+static void xen_pvh_set_cr_flags(int cpu)
+{
+
+	/* Some of these are setup in 'secondary_startup_64'. The others:
+	 * X86_CR0_TS, X86_CR0_PE, X86_CR0_ET are set by Xen for HVM guests
+	 * (which PVH shared codepaths), while X86_CR0_PG is for PVH. */
+	write_cr0(read_cr0() | X86_CR0_MP | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM);
+}
+
+/*
+ * Note, that it is ref - because the only caller of this after init
+ * is PVH which is not going to use xen_load_gdt_boot or other
+ * __init functions.
+ */
+void __ref xen_pvh_secondary_vcpu_init(int cpu)
+{
+	xen_setup_gdt(cpu);
+	xen_pvh_set_cr_flags(cpu);
+}
+
 static void __init xen_pvh_early_guest_init(void)
 {
 	if (!xen_feature(XENFEAT_auto_translated_physmap))
 		return;
 
-	if (xen_feature(XENFEAT_hvm_callback_vector))
-		xen_have_vector_callback = 1;
+	if (!xen_feature(XENFEAT_hvm_callback_vector))
+		return;
+
+	xen_have_vector_callback = 1;
+	xen_pvh_set_cr_flags(0);
 
 #ifdef CONFIG_X86_32
 	BUG(); /* PVH: Implement proper support. */
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 5e46190..a18eadd 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -105,7 +105,7 @@ static void cpu_bringup_and_idle(int cpu)
 #ifdef CONFIG_X86_64
 	if (xen_feature(XENFEAT_auto_translated_physmap) &&
 	    xen_feature(XENFEAT_supervisor_mode_kernel))
-		xen_setup_gdt(cpu);
+		xen_pvh_secondary_vcpu_init(cpu);
 #endif
 	cpu_bringup();
 	cpu_startup_entry(CPUHP_ONLINE);
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 9059c24..1cb6f4c 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -123,5 +123,5 @@ __visible void xen_adjust_exception_frame(void);
 
 extern int xen_panic_handler_init(void);
 
-void xen_setup_gdt(int cpu);
+void xen_pvh_secondary_vcpu_init(int cpu);
 #endif /* XEN_OPS_H */
-- 
1.7.7.6

