Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3HEOfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:35:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40192 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3HEOfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:35:23 -0400
Date: Mon, 5 Aug 2013 10:34:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jason Wang <jasowang@redhat.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvm@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Doug Covelli <dcovelli@vmware.com>, Borislav Petkov <bp@suse.de>,
        Dan Hecht <dhecht@vmware.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@linuxdriverproject.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V2 4/4] x86: correctly detect hypervisor
Message-ID: <20130805143426.GH3321@phenom.dumpdata.com>
References: <1374742475-2485-1-git-send-email-jasowang@redhat.com>
 <1374742475-2485-4-git-send-email-jasowang@redhat.com>
 <51FF1E26.6010707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FF1E26.6010707@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 11:38:14AM +0800, Jason Wang wrote:
> On 07/25/2013 04:54 PM, Jason Wang wrote:
> > We try to handle the hypervisor compatibility mode by detecting hypervisor
> > through a specific order. This is not robust, since hypervisors may implement
> > each others features.
> >
> > This patch tries to handle this situation by always choosing the last one in the
> > CPUID leaves. This is done by letting .detect() returns a priority instead of
> > true/false and just re-using the CPUID leaf where the signature were found as
> > the priority (or 1 if it was found by DMI). Then we can just pick hypervisor who
> > has the highest priority. Other sophisticated detection method could also be
> > implemented on top.
> >
> > Suggested by H. Peter Anvin and Paolo Bonzini.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: x86@kernel.org
> > Cc: K. Y. Srinivasan <kys@microsoft.com>
> > Cc: Haiyang Zhang <haiyangz@microsoft.com>
> > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> > Cc: Doug Covelli <dcovelli@vmware.com>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Dan Hecht <dhecht@vmware.com>
> > Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > Cc: Gleb Natapov <gleb@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: devel@linuxdriverproject.org
> > Cc: kvm@vger.kernel.org
> > Cc: xen-devel@lists.xensource.com
> > Cc: virtualization@lists.linux-foundation.org
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> 
> Ping, any comments and acks for this series?

Could you provide me with a git branch so I can test it overnight please?

> 
> Thanks
> >  arch/x86/include/asm/hypervisor.h |    2 +-
> >  arch/x86/kernel/cpu/hypervisor.c  |   15 +++++++--------
> >  arch/x86/kernel/cpu/mshyperv.c    |   13 ++++++++-----
> >  arch/x86/kernel/cpu/vmware.c      |    8 ++++----
> >  arch/x86/kernel/kvm.c             |    6 ++----
> >  arch/x86/xen/enlighten.c          |    9 +++------
> >  6 files changed, 25 insertions(+), 28 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
> > index 2d4b5e6..e42f758 100644
> > --- a/arch/x86/include/asm/hypervisor.h
> > +++ b/arch/x86/include/asm/hypervisor.h
> > @@ -33,7 +33,7 @@ struct hypervisor_x86 {
> >  	const char	*name;
> >  
> >  	/* Detection routine */
> > -	bool		(*detect)(void);
> > +	uint32_t	(*detect)(void);
> >  
> >  	/* Adjust CPU feature bits (run once per CPU) */
> >  	void		(*set_cpu_features)(struct cpuinfo_x86 *);
> > diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
> > index 8727921..36ce402 100644
> > --- a/arch/x86/kernel/cpu/hypervisor.c
> > +++ b/arch/x86/kernel/cpu/hypervisor.c
> > @@ -25,11 +25,6 @@
> >  #include <asm/processor.h>
> >  #include <asm/hypervisor.h>
> >  
> > -/*
> > - * Hypervisor detect order.  This is specified explicitly here because
> > - * some hypervisors might implement compatibility modes for other
> > - * hypervisors and therefore need to be detected in specific sequence.
> > - */
> >  static const __initconst struct hypervisor_x86 * const hypervisors[] =
> >  {
> >  #ifdef CONFIG_XEN_PVHVM
> > @@ -49,15 +44,19 @@ static inline void __init
> >  detect_hypervisor_vendor(void)
> >  {
> >  	const struct hypervisor_x86 *h, * const *p;
> > +	uint32_t pri, max_pri = 0;
> >  
> >  	for (p = hypervisors; p < hypervisors + ARRAY_SIZE(hypervisors); p++) {
> >  		h = *p;
> > -		if (h->detect()) {
> > +		pri = h->detect();
> > +		if (pri != 0 && pri > max_pri) {
> > +			max_pri = pri;
> >  			x86_hyper = h;
> > -			printk(KERN_INFO "Hypervisor detected: %s\n", h->name);
> > -			break;
> >  		}
> >  	}
> > +
> > +	if (max_pri)
> > +		printk(KERN_INFO "Hypervisor detected: %s\n", x86_hyper->name);
> >  }
> >  
> >  void init_hypervisor(struct cpuinfo_x86 *c)
> > diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> > index 8f4be53..71a39f3 100644
> > --- a/arch/x86/kernel/cpu/mshyperv.c
> > +++ b/arch/x86/kernel/cpu/mshyperv.c
> > @@ -27,20 +27,23 @@
> >  struct ms_hyperv_info ms_hyperv;
> >  EXPORT_SYMBOL_GPL(ms_hyperv);
> >  
> > -static bool __init ms_hyperv_platform(void)
> > +static uint32_t  __init ms_hyperv_platform(void)
> >  {
> >  	u32 eax;
> >  	u32 hyp_signature[3];
> >  
> >  	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
> > -		return false;
> > +		return 0;
> >  
> >  	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
> >  	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
> >  
> > -	return eax >= HYPERV_CPUID_MIN &&
> > -		eax <= HYPERV_CPUID_MAX &&
> > -		!memcmp("Microsoft Hv", hyp_signature, 12);
> > +	if (eax >= HYPERV_CPUID_MIN &&
> > +	    eax <= HYPERV_CPUID_MAX &&
> > +	    !memcmp("Microsoft Hv", hyp_signature, 12))
> > +		return HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS;
> > +
> > +	return 0;
> >  }
> >  
> >  static cycle_t read_hv_clock(struct clocksource *arg)
> > diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
> > index 7076878..628a059 100644
> > --- a/arch/x86/kernel/cpu/vmware.c
> > +++ b/arch/x86/kernel/cpu/vmware.c
> > @@ -93,7 +93,7 @@ static void __init vmware_platform_setup(void)
> >   * serial key should be enough, as this will always have a VMware
> >   * specific string when running under VMware hypervisor.
> >   */
> > -static bool __init vmware_platform(void)
> > +static uint32_t __init vmware_platform(void)
> >  {
> >  	if (cpu_has_hypervisor) {
> >  		unsigned int eax;
> > @@ -102,12 +102,12 @@ static bool __init vmware_platform(void)
> >  		cpuid(CPUID_VMWARE_INFO_LEAF, &eax, &hyper_vendor_id[0],
> >  		      &hyper_vendor_id[1], &hyper_vendor_id[2]);
> >  		if (!memcmp(hyper_vendor_id, "VMwareVMware", 12))
> > -			return true;
> > +			return CPUID_VMWARE_INFO_LEAF;
> >  	} else if (dmi_available && dmi_name_in_serial("VMware") &&
> >  		   __vmware_platform())
> > -		return true;
> > +		return 1;
> >  
> > -	return false;
> > +	return 0;
> >  }
> >  
> >  /*
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index a96d32c..7817afd 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -498,11 +498,9 @@ void __init kvm_guest_init(void)
> >  #endif
> >  }
> >  
> > -static bool __init kvm_detect(void)
> > +static uint32_t __init kvm_detect(void)
> >  {
> > -	if (!kvm_para_available())
> > -		return false;
> > -	return true;
> > +	return kvm_cpuid_base();
> >  }
> >  
> >  const struct hypervisor_x86 x86_hyper_kvm __refconst = {
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 193097e..2fcaedc 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -1720,15 +1720,12 @@ static void __init xen_hvm_guest_init(void)
> >  	xen_hvm_init_mmu_ops();
> >  }
> >  
> > -static bool __init xen_hvm_platform(void)
> > +static uint32_t __init xen_hvm_platform(void)
> >  {
> >  	if (xen_pv_domain())
> > -		return false;
> > -
> > -	if (!xen_cpuid_base())
> > -		return false;
> > +		return 0;
> >  
> > -	return true;
> > +	return xen_cpuid_base();
> >  }
> >  
> >  bool xen_hvm_need_lapic(void)
> 
