Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaG1NdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:33:13 -0400
Received: from smtp.citrix.com ([66.165.176.89]:41018 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaG1NdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:33:09 -0400
X-IronPort-AV: E=Sophos;i="5.01,749,1400025600"; 
   d="scan'208";a="156367057"
Message-ID: <53D65112.7080801@citrix.com>
Date: Mon, 28 Jul 2014 14:33:06 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>, <xen-devel@lists.xenproject.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 1/4] xen PVonHVM: use E820_Reserved area for shared_info
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com> <1405431640-649-2-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1405431640-649-2-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/14 14:40, Vitaly Kuznetsov wrote:
> From: Olaf Hering <olaf@aepfle.de>
> 
> This is a respin of 00e37bdb0113a98408de42db85be002f21dbffd3
> ("xen PVonHVM: move shared_info to MMIO before kexec").
> 
> Currently kexec in a PVonHVM guest fails with a triple fault because the
> new kernel overwrites the shared info page. The exact failure depends on
> the size of the kernel image. This patch moves the pfn from RAM into an
> E820 reserved memory area.
> 
> The pfn containing the shared_info is located somewhere in RAM. This will
> cause trouble if the current kernel is doing a kexec boot into a new
> kernel. The new kernel (and its startup code) can not know where the pfn
> is, so it can not reserve the page. The hypervisor will continue to update
> the pfn, and as a result memory corruption occours in the new kernel.
> 
> The toolstack marks the memory area FC000000-FFFFFFFF as reserved in the
> E820 map. Within that range newer toolstacks (4.3+) will keep 1MB
> starting from FE700000 as reserved for guest use. Older Xen4 toolstacks
> will usually not allocate areas up to FE700000, so FE700000 is expected
> to work also with older toolstacks.
> 
> In Xen3 there is no reserved area at a fixed location. If the guest is
> started on such old hosts the shared_info page will be placed in RAM. As
> a result kexec can not be used.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> (cherry picked from commit 9d02b43dee0d7fb18dfb13a00915550b1a3daa9f)

Is this a useful commit to give?  Isn't it one of Konrad's random trees?


> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1726,23 +1726,29 @@ asmlinkage __visible void __init xen_start_kernel(void)
>  #endif
>  }
>  
> -void __ref xen_hvm_init_shared_info(void)
> +#ifdef CONFIG_XEN_PVHVM
> +#define HVM_SHARED_INFO_ADDR 0xFE700000UL

I would like clearer documentation for this magic address.  Perhaps
referring to some toolstack documentation?

> @@ -1828,10 +1853,23 @@ static void __init xen_hvm_guest_init(void)
>  
>  static uint32_t __init xen_hvm_platform(void)
>  {
> +	uint32_t eax, ebx, ecx, edx, base;
> +
>  	if (xen_pv_domain())
>  		return 0;
>  
> -	return xen_cpuid_base();
> +	base = xen_cpuid_base();
> +	if (!base)
> +		return 0;
> +
> +	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
> +
> +	xen_major = eax >> 16;
> +	xen_minor = eax & 0xffff;
> +
> +	printk(KERN_INFO "Xen version %d.%d.\n", xen_major, xen_minor);
> +
> +	return 1;

You appear to have changed to return value here?  Did you mean to return
base here?

David
