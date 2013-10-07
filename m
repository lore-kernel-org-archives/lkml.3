Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3JGJt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 05:49:28 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:56686 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab3JGJt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:49:27 -0400
X-IronPort-AV: E=Sophos;i="4.90,1049,1371081600"; 
   d="scan'208";a="58282407"
Message-ID: <525283A5.4020904@citrix.com>
Date: Mon, 7 Oct 2013 10:49:25 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Frediano Ziglio <frediano.ziglio@citrix.com>
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xen: Fix possible user space selector corruption
References: <1380788677.30462.1.camel@hamster.uk.xensource.com>  <524D4132.3000809@citrix.com>  <1380804692.30462.3.camel@hamster.uk.xensource.com>  <20131004132033.GA26673@phenom.dumpdata.com> <524EC3C1.4010304@citrix.com>  <5252815E.70504@citrix.com> <1381139286.31436.2.camel@hamster.uk.xensource.com>
In-Reply-To: <1381139286.31436.2.camel@hamster.uk.xensource.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/13 10:48, Frediano Ziglio wrote:
> Due to the way kernel is initialized under Xen is possible that the
> ring1 selector used by the kernel for the boot cpu end up to be copied
> to userspace leading to segmentation fault in the userspace.
>
> Xen code in the kernel initialize no-boot cpus with correct selectors (ds
> and es set to __USER_DS) but the boot one keep the ring1 (passed by Xen).
> On task context switch (switch_to) we assume that ds, es and cs already
> point to __USER_DS and __KERNEL_CSso these selector are not changed.
>
> If processor is an Intel that support sysenter instruction sysenter/sysexit
> is used so ds and es are not restored switching back from kernel to
> userspace. In the case the selectors point to a ring1 instead of __USER_DS
> the userspace code will crash on first memory access attempt (to be
> precise Xen on the emulated iret used to do sysexit will detect and set ds
> and es to zero which lead to GPF anyway).
>
> Now if an userspace process call kernel using sysenter and get rescheduled
> (for me it happen on a specific init calling wait4) could happen that the
> ring1 selector is set to ds and es.
>
> This is quite hard to detect cause after a while these selectors are fixed
> (__USER_DS seems sticky).
>
> Bisecting the code commit 7076aada1040de4ed79a5977dbabdb5e5ea5e249 appears
> to be the first one that have this issue.
>
> Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>

Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>

> ---
>  arch/x86/xen/smp.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
>
> Just changed comment on source code as suggested by Andrew Cooper.
>
>
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index d99cae8..6d89fcc 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -245,6 +245,15 @@ static void __init xen_smp_prepare_boot_cpu(void)
>  	   old memory can be recycled */
>  	make_lowmem_page_readwrite(xen_initial_gdt);
>  
> +#ifdef CONFIG_X86_32
> +	/*
> +	 * Xen starts us with XEN_FLAT_RING1_DS, but linux code
> +	 * expects __USER_DS
> +	 */
> +	loadsegment(ds, __USER_DS);
> +	loadsegment(es, __USER_DS);
> +#endif
> +
>  	xen_filter_cpu_maps();
>  	xen_setup_vcpu_info_placement();
>  }

