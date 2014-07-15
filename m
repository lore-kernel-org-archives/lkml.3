Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbaGORjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:39:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26811 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbaGORjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:39:15 -0400
Message-ID: <53C567C6.2050007@oracle.com>
Date: Tue, 15 Jul 2014 13:41:26 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>, xen-devel@lists.xenproject.org
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/4] xen/pvhvm: Introduce xen_pvhvm_kexec_shutdown()
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com> <1405431640-649-3-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1405431640-649-3-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 09:40 AM, Vitaly Kuznetsov wrote:
> PVHVM guest requires special actions before kexec. Register specific
> xen_pvhvm_kexec_shutdown() handler for machine_ops.shutdown().
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/xen/enlighten.c | 9 +++++++++
>   arch/x86/xen/smp.c       | 9 +++++++++
>   arch/x86/xen/smp.h       | 1 +
>   3 files changed, 19 insertions(+)
>
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index a11af62..8074e4a 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1833,6 +1833,12 @@ static struct notifier_block xen_hvm_cpu_notifier = {
>   	.notifier_call	= xen_hvm_cpu_notify,
>   };
>   
> +static void xen_pvhvm_kexec_shutdown(void)
> +{
> +	xen_kexec_shutdown();
> +	native_machine_shutdown();
> +}
> +

This should probably be under ifdef CONFIG_KEXEC ?

>   static void __init xen_hvm_guest_init(void)
>   {
>   	init_hvm_pv_info();
> @@ -1849,6 +1855,9 @@ static void __init xen_hvm_guest_init(void)
>   	x86_init.irqs.intr_init = xen_init_IRQ;
>   	xen_hvm_init_time_ops();
>   	xen_hvm_init_mmu_ops();
> +#ifdef CONFIG_KEXEC
> +	machine_ops.shutdown = xen_pvhvm_kexec_shutdown;
> +#endif
>   }
>   
>   static uint32_t __init xen_hvm_platform(void)
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 7005974..35dcf39 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -18,6 +18,7 @@
>   #include <linux/smp.h>
>   #include <linux/irq_work.h>
>   #include <linux/tick.h>
> +#include <linux/kexec.h>
>   
>   #include <asm/paravirt.h>
>   #include <asm/desc.h>
> @@ -762,6 +763,14 @@ static void xen_hvm_cpu_die(unsigned int cpu)
>   	native_cpu_die(cpu);
>   }
>   
> +void xen_kexec_shutdown(void)
> +{
> +#ifdef CONFIG_KEXEC
> +	if (!kexec_in_progress)
> +		return;
> +#endif
> +}
> +

and this one too (whole routine)? And "#include" above as well.

>   void __init xen_hvm_smp_init(void)
>   {
>   	if (!xen_have_vector_callback)
> diff --git a/arch/x86/xen/smp.h b/arch/x86/xen/smp.h
> index c7c2d89..1af0493 100644
> --- a/arch/x86/xen/smp.h
> +++ b/arch/x86/xen/smp.h
> @@ -8,4 +8,5 @@ extern void xen_send_IPI_allbutself(int vector);
>   extern void xen_send_IPI_all(int vector);
>   extern void xen_send_IPI_self(int vector);
>   
> +extern void xen_kexec_shutdown(void);
>   #endif

