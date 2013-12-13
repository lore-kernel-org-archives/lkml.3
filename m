Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3LMK42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:56:28 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:46566 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3LMK41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:56:27 -0500
X-IronPort-AV: E=Sophos;i="4.95,477,1384300800"; 
   d="scan'208";a="81937325"
Message-ID: <52AAE7D8.2030602@citrix.com>
Date: Fri, 13 Dec 2013 10:56:24 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <george.dunlap@eu.citrix.com>, <ian.jackson@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <tim@xen.org>, <jbeulich@suse.com>,
        <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH V10 02/14] xen/pvh: Extend vcpu_guest_context, p2m, event,
 and XenBus.
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com> <1386900621-27528-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386900621-27528-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> Make gdt_frames[]/gdt_ents into a union with {gdtaddr, gdtsz},
> as PVH only needs to send down gdtaddr and gdtsz in the
> vcpu_guest_context structure..
> 
> For interrupts, PVH uses native_irq_ops so we can skip most of the
> PV ones. In the future we can support the pirq_eoi_map..
> Also VCPU hotplug is currently not available for PVH.
> 
> For events (and IRQs) we follow what PVHVM does - so use callback
> vector.  Lastly, for XenBus we use the same logic that is used in
> the PVHVM case.
[...]
> --- a/arch/x86/include/asm/xen/interface.h
> +++ b/arch/x86/include/asm/xen/interface.h
> @@ -145,7 +145,16 @@ struct vcpu_guest_context {
>      struct cpu_user_regs user_regs;         /* User-level CPU registers     */
>      struct trap_info trap_ctxt[256];        /* Virtual IDT                  */
>      unsigned long ldt_base, ldt_ents;       /* LDT (linear address, # ents) */
> -    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine frames, # ents) */
> +    union {
> +	struct {
> +		/* PV: GDT (machine frames, # ents).*/
> +		unsigned long gdt_frames[16], gdt_ents;
> +	} pv;
> +	struct {
> +		/* PVH: GDTR addr and size */
> +		unsigned long gdtaddr, gdtsz;
> +	} pvh;
> +    } u;

Doesn't match the hypervisor.

> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -800,8 +800,10 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>  	unsigned topidx, mididx, idx;
>  
>  	/* don't track P2M changes in autotranslate guests */
> -	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap)))
> +	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
> +		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
>  		return true;
> +	}

Isn't this undoing a recent change that removed this BUG_ON()?

David
