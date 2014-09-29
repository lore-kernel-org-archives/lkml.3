Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaI2OFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:05:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50188 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbaI2OFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:05:21 -0400
Date: Mon, 29 Sep 2014 16:05:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI changes for v3.18
Message-ID: <20140929140516.GL5430@worktop>
References: <20140928202702.GB18635@console-pimps.org>
 <20140929124321.GB18825@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929124321.GB18825@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 02:43:21PM +0200, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@console-pimps.org> wrote:
> 
> >  * Implement new EFI runtime lock which is required by the UEFI
> >    specification - Ard Biesheuvel
> 
> Firstly, under what circumstances can EFI call parallelism happen 
> currently? Most of the EFI code runs during early bootup, which 
> is serialized.
> 
> Secondly, this locking pattern looks pretty disgusting:
> 
> @@ -94,7 +187,17 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
>                                           unsigned long data_size,
>                                           void *data)
>  {
> -       return efi_call_virt(set_variable, name, vendor, attr, data_size, data);
> +       unsigned long flags;
> +       efi_status_t status;
> +       bool __in_nmi = efi_in_nmi();
> +
> +       if (!__in_nmi)
> +               spin_lock_irqsave(&efi_runtime_lock, flags);
> +       status = efi_call_virt(set_variable, name, vendor, attr, data_size,
> +                              data);
> +       if (!__in_nmi)
> +               spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +       return status;
>  }
> 
> and that's repeated in virt_efi_query_variable_info() as well.
> 
> and that's the explanation given:
> 
> +/*
> + * Some runtime services calls can be reentrant under NMI, even if the table
> + * above says they are not. (source: UEFI Specification v2.4A)
> + *
> + * Table 32. Functions that may be called after Machine Check, INIT and NMI
> + * 
> +----------------------------+------------------------------------------+
> + * | Function                  | Called after Machine Check, INIT and NMI |
> + * 
> +----------------------------+------------------------------------------+
> + * | GetTime()                 | Yes, even if previously busy.            |
> + * | GetVariable()             | Yes, even if previously busy             |
> + * | GetNextVariableName()     | Yes, even if previously busy             |
> + * | QueryVariableInfo()       | Yes, even if previously busy             |
> + * | SetVariable()             | Yes, even if previously busy             |
> + * | UpdateCapsule()           | Yes, even if previously busy             |
> + * | QueryCapsuleCapabilities()| Yes, even if previously busy             |
> + * | ResetSystem()             | Yes, even if previously busy             |
> + * 
> +----------------------------+------------------------------------------+
> + *
> + * In order to prevent deadlocks under NMI, the wrappers for these functions
> + * may only grab the efi_runtime_lock or rtc_lock spinlocks if !efi_in_nmi().
> + * However, not all of the services listed are reachable through NMI code paths,
> + * so the the special handling as suggested by the UEFI spec is only implemented
> + * for QueryVariableInfo() and SetVariable(), as these can be reached in NMI
> + * context through efi_pstore_write().

OMFG what a trainwreck... if they are reentrant like that, a lock isn't
going to help you in any way. The implementation of these calls must be
lockfree otherwise they cannot possibly be correct.

Conditional locking like above is just plain broken, disgusting doesn't
even begin to cover it. Full NAK on this. If this is required by the EFI
spec someone needs to pull their head from their arse and smell the real
world.


