Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbbAVUcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:32:06 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:49658 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbbAVUb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:31:59 -0500
Message-ID: <54C15E20.8090201@linaro.org>
Date: Thu, 22 Jan 2015 20:31:28 +0000
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, david.vrabel@citrix.com,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [Xen-devel] [RFC v3 2/2] x86/xen: allow privcmd hypercalls to
 be preempted
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com> <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com> <54C0F6D9.70003@linaro.org> <20150122185627.GQ17887@wotan.suse.de>
In-Reply-To: <20150122185627.GQ17887@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/15 18:56, Luis R. Rodriguez wrote:
> On Thu, Jan 22, 2015 at 01:10:49PM +0000, Julien Grall wrote:
>> Hi Luis,
>>
>> On 22/01/15 02:17, Luis R. Rodriguez wrote:
>>> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
>>> index b4bca2d..23c526b 100644
>>> --- a/drivers/xen/events/events_base.c
>>> +++ b/drivers/xen/events/events_base.c
>>> @@ -32,6 +32,8 @@
>>>  #include <linux/slab.h>
>>>  #include <linux/irqnr.h>
>>>  #include <linux/pci.h>
>>> +#include <linux/sched.h>
>>> +#include <linux/kprobes.h>
>>>  
>>>  #ifdef CONFIG_X86
>>>  #include <asm/desc.h>
>>> @@ -1243,6 +1245,17 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>>>  	set_irq_regs(old_regs);
>>>  }
>>>  
>>> +notrace void xen_end_upcall(struct pt_regs *regs)
>>> +{
>>> +	if (!xen_is_preemptible_hypercall(regs) ||
>>
>> I don't see any definition of xen_is_preemptible_hypercall for ARM32/ARM64.
>>
>> As this function is called from the generic code, you have at least to
>> stub this function for those architectures.
> 
> Will add as:
> 
> diff --git a/arch/arm/include/asm/xen/hypercall.h b/arch/arm/include/asm/xen/hypercall.h
> index 712b50e..4fc8395 100644
> --- a/arch/arm/include/asm/xen/hypercall.h
> +++ b/arch/arm/include/asm/xen/hypercall.h
> @@ -74,4 +74,9 @@ MULTI_mmu_update(struct multicall_entry *mcl, struct mmu_update *req,
>  	BUG();
>  }
>  
> +static inline bool xen_is_preemptible_hypercall(struct pt_regs *regs)
> +{
> +	return false;
> +}
> +
>  #endif /* _ASM_ARM_XEN_HYPERCALL_H */
> 
> This will cover both arm and arm64 as arm64 includes the arm header.

I'm fine with this solution.

Regards,

-- 
Julien Grall
