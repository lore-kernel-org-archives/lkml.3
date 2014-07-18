Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbaGRLGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:06:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbaGRLGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:06:00 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/4] xen PVonHVM: use E820_Reserved area for shared_info
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
	<1405431640-649-2-git-send-email-vkuznets@redhat.com>
	<20140715150652.GN3403@laptop.dumpdata.com>
	<87vbqytyp6.fsf@vitty.brq.redhat.com>
	<20140715155045.GB7792@laptop.dumpdata.com>
Date: Fri, 18 Jul 2014 13:05:46 +0200
In-Reply-To: <20140715155045.GB7792@laptop.dumpdata.com> (Konrad Rzeszutek
	Wilk's message of "Tue, 15 Jul 2014 11:50:45 -0400")
Message-ID: <871ttjorjp.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:

> On Tue, Jul 15, 2014 at 05:43:17PM +0200, Vitaly Kuznetsov wrote:
>> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:
>> 
>> > On Tue, Jul 15, 2014 at 03:40:37PM +0200, Vitaly Kuznetsov wrote:
>> >> From: Olaf Hering <olaf@aepfle.de>
>> >> 
>> >> This is a respin of 00e37bdb0113a98408de42db85be002f21dbffd3
>> >> ("xen PVonHVM: move shared_info to MMIO before kexec").
>> >> 
>> >> Currently kexec in a PVonHVM guest fails with a triple fault because the
>> >> new kernel overwrites the shared info page. The exact failure depends on
>> >> the size of the kernel image. This patch moves the pfn from RAM into an
>> >> E820 reserved memory area.
>> >> 
>> >> The pfn containing the shared_info is located somewhere in RAM. This will
>> >> cause trouble if the current kernel is doing a kexec boot into a new
>> >> kernel. The new kernel (and its startup code) can not know where the pfn
>> >> is, so it can not reserve the page. The hypervisor will continue to update
>> >> the pfn, and as a result memory corruption occours in the new kernel.
>> >> 
>> >> The toolstack marks the memory area FC000000-FFFFFFFF as reserved in the
>> >> E820 map. Within that range newer toolstacks (4.3+) will keep 1MB
>> >> starting from FE700000 as reserved for guest use. Older Xen4 toolstacks
>> >> will usually not allocate areas up to FE700000, so FE700000 is expected
>> >> to work also with older toolstacks.
>> >> 
>> >> In Xen3 there is no reserved area at a fixed location. If the guest is
>> >> started on such old hosts the shared_info page will be placed in RAM. As
>> >> a result kexec can not be used.
>> >
>> > So this looks right, the one thing that we really need to check 
>> > is e9daff24a266307943457086533041bd971d0ef9
>> >
>> >    This reverts commit 9d02b43dee0d7fb18dfb13a00915550b1a3daa9f.
>> >
>> >     We are doing this b/c on 32-bit PVonHVM with older hypervisors
>> >     (Xen 4.1) it ends up bothing up the start_info. This is bad b/c
>> >     we use it for the time keeping, and the timekeeping code loops
>> >     forever - as the version field never changes. Olaf says to
>> >     revert it, so lets do that.
>> >
>> > Could you kindly test that the migration on 32-bit PVHVM guests
>> > on older hypervisors works?
>> >
>> 
>> Sure, will do! Was there anything special about the setup or any 32-bit
>> pvhvm guest migration (on 64-bit hypervisor I suppose) would fail? I can
>> try checking both current and old versions to make sure the issue was
>> acutually fixed.
>
> Nothing fancy (well, it was SMP, so 4 CPUs). I did the 'save'/'restore' and the
> guest would not restore properly.
>

The symptoms you saw were: after the resume guest appears to be frozen,
all vcpus except for the first one spin at 100%? I was able to reproduce
that on old patch version and everything works fine with your fix
(calling xen_hvm_set_shared_info() in addition to
xen_hvm_connect_shared_info() on resume). We're probably safe to apply
it now, thanks!

However I'd like to suggest we remove '__init' from
xen_hvm_set_shared_info() as now we call it on resume.

> Thank you!
>> 
>> >> 
>> >> Signed-off-by: Olaf Hering <olaf@aepfle.de>
>> >> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> >> (cherry picked from commit 9d02b43dee0d7fb18dfb13a00915550b1a3daa9f)
>> >> 
>> >> [On resume we need to reset the xen_vcpu_info, which the original
>> >> patch did not do]
>> >> 
>> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> >> ---
>> >>  arch/x86/xen/enlighten.c | 74 ++++++++++++++++++++++++++++++++++++------------
>> >>  arch/x86/xen/suspend.c   |  2 +-
>> >>  arch/x86/xen/xen-ops.h   |  2 +-
>> >>  3 files changed, 58 insertions(+), 20 deletions(-)
>> >> 
>> >> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
>> >> index ffb101e..a11af62 100644
>> >> --- a/arch/x86/xen/enlighten.c
>> >> +++ b/arch/x86/xen/enlighten.c
>> >> @@ -1726,23 +1726,29 @@ asmlinkage __visible void __init xen_start_kernel(void)
>> >>  #endif
>> >>  }
>> >>  
>> >> -void __ref xen_hvm_init_shared_info(void)
>> >> +#ifdef CONFIG_XEN_PVHVM
>> >> +#define HVM_SHARED_INFO_ADDR 0xFE700000UL
>> >> +static struct shared_info *xen_hvm_shared_info;
>> >> +static unsigned long xen_hvm_sip_phys;
>> >> +static int xen_major, xen_minor;
>> >> +
>> >> +static void xen_hvm_connect_shared_info(unsigned long pfn)
>> >>  {
>> >> -	int cpu;
>> >>  	struct xen_add_to_physmap xatp;
>> >> -	static struct shared_info *shared_info_page = 0;
>> >>  
>> >> -	if (!shared_info_page)
>> >> -		shared_info_page = (struct shared_info *)
>> >> -			extend_brk(PAGE_SIZE, PAGE_SIZE);
>> >>  	xatp.domid = DOMID_SELF;
>> >>  	xatp.idx = 0;
>> >>  	xatp.space = XENMAPSPACE_shared_info;
>> >> -	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
>> >> +	xatp.gpfn = pfn;
>> >>  	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
>> >>  		BUG();
>> >>  
>> >> -	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
>> >> +}
>> >> +static void __init xen_hvm_set_shared_info(struct shared_info *sip)
>> >> +{
>> >> +	int cpu;
>> >> +
>> >> +	HYPERVISOR_shared_info = sip;
>> >>  
>> >>  	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
>> >>  	 * page, we use it in the event channel upcall and in some pvclock
>> >> @@ -1760,20 +1766,39 @@ void __ref xen_hvm_init_shared_info(void)
>> >>  	}
>> >>  }
>> >>  
>> >> -#ifdef CONFIG_XEN_PVHVM
>> >> +/* Reconnect the shared_info pfn to a (new) mfn */
>> >> +void xen_hvm_resume_shared_info(void)
>> >> +{
>> >> +	xen_hvm_connect_shared_info(xen_hvm_sip_phys >> PAGE_SHIFT);
>> >> +	xen_hvm_set_shared_info(xen_hvm_shared_info);
>> >> +}
>> >> +
>> >> +/* Xen tools prior to Xen 4 do not provide a E820_Reserved area for guest usage.
>> >> + * On these old tools the shared info page will be placed in E820_Ram.
>> >> + * Xen 4 provides a E820_Reserved area at 0xFC000000, and this code expects
>> >> + * that nothing is mapped up to HVM_SHARED_INFO_ADDR.
>> >> + * Xen 4.3+ provides an explicit 1MB area at HVM_SHARED_INFO_ADDR which is used
>> >> + * here for the shared info page. */
>> >> +static void __init xen_hvm_init_shared_info(void)
>> >> +{
>> >> +	if (xen_major < 4) {
>> >> +		xen_hvm_shared_info = extend_brk(PAGE_SIZE, PAGE_SIZE);
>> >> +		xen_hvm_sip_phys = __pa(xen_hvm_shared_info);
>> >> +	} else {
>> >> +		xen_hvm_sip_phys = HVM_SHARED_INFO_ADDR;
>> >> +		set_fixmap(FIX_PARAVIRT_BOOTMAP, xen_hvm_sip_phys);
>> >> +		xen_hvm_shared_info =
>> >> +		(struct shared_info *)fix_to_virt(FIX_PARAVIRT_BOOTMAP);
>> >> +	}
>> >> +	xen_hvm_resume_shared_info();
>> >> +}
>> >> +
>> >>  static void __init init_hvm_pv_info(void)
>> >>  {
>> >> -	int major, minor;
>> >> -	uint32_t eax, ebx, ecx, edx, pages, msr, base;
>> >> +	uint32_t  ecx, edx, pages, msr, base;
>> >>  	u64 pfn;
>> >>  
>> >>  	base = xen_cpuid_base();
>> >> -	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
>> >> -
>> >> -	major = eax >> 16;
>> >> -	minor = eax & 0xffff;
>> >> -	printk(KERN_INFO "Xen version %d.%d.\n", major, minor);
>> >> -
>> >>  	cpuid(base + 2, &pages, &msr, &ecx, &edx);
>> >>  
>> >>  	pfn = __pa(hypercall_page);
>> >> @@ -1828,10 +1853,23 @@ static void __init xen_hvm_guest_init(void)
>> >>  
>> >>  static uint32_t __init xen_hvm_platform(void)
>> >>  {
>> >> +	uint32_t eax, ebx, ecx, edx, base;
>> >> +
>> >>  	if (xen_pv_domain())
>> >>  		return 0;
>> >>  
>> >> -	return xen_cpuid_base();
>> >> +	base = xen_cpuid_base();
>> >> +	if (!base)
>> >> +		return 0;
>> >> +
>> >> +	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
>> >> +
>> >> +	xen_major = eax >> 16;
>> >> +	xen_minor = eax & 0xffff;
>> >> +
>> >> +	printk(KERN_INFO "Xen version %d.%d.\n", xen_major, xen_minor);
>> >> +
>> >> +	return 1;
>> >>  }
>> >>  
>> >>  bool xen_hvm_need_lapic(void)
>> >> diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
>> >> index c4df9db..8d6793e 100644
>> >> --- a/arch/x86/xen/suspend.c
>> >> +++ b/arch/x86/xen/suspend.c
>> >> @@ -32,7 +32,7 @@ static void xen_hvm_post_suspend(int suspend_cancelled)
>> >>  {
>> >>  #ifdef CONFIG_XEN_PVHVM
>> >>  	int cpu;
>> >> -	xen_hvm_init_shared_info();
>> >> +	xen_hvm_resume_shared_info();
>> >>  	xen_callback_vector();
>> >>  	xen_unplug_emulated_devices();
>> >>  	if (xen_feature(XENFEAT_hvm_safe_pvclock)) {
>> >> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
>> >> index 97d8765..d083e82 100644
>> >> --- a/arch/x86/xen/xen-ops.h
>> >> +++ b/arch/x86/xen/xen-ops.h
>> >> @@ -43,7 +43,7 @@ void xen_enable_syscall(void);
>> >>  void xen_vcpu_restore(void);
>> >>  
>> >>  void xen_callback_vector(void);
>> >> -void xen_hvm_init_shared_info(void);
>> >> +void xen_hvm_resume_shared_info(void);
>> >>  void xen_unplug_emulated_devices(void);
>> >>  
>> >>  void __init xen_build_dynamic_phys_to_machine(void);
>> >> -- 
>> >> 1.9.3
>> >> 
>> 
>> -- 
>>   Vitaly

-- 
  Vitaly
