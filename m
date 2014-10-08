Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbaJHPRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:17:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47776 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbaJHPRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:17:38 -0400
Date: Wed, 8 Oct 2014 17:17:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mathias Krause <minipli@googlemail.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
Message-ID: <20141008151730.GB16892@pd.tnic>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
 <1411313216-2641-2-git-send-email-minipli@googlemail.com>
 <20141003134707.GJ14343@console-pimps.org>
 <20141007150132.GA7307@nazgul.tnic>
 <20141007170748.GA25767@jig.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141007170748.GA25767@jig.fritz.box>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 07:07:48PM +0200, Mathias Krause wrote:
> What you can see here are actually the EFI runtime service mappings, not
> the ESP fix area. Check the addresses and compare them. You should find
> similarities ;) And, in fact, the EFI mappings are incomplete in the
> second dump, i.e. the vanilla kernel one, because of the enforced limit
> for the ESP fix area.
> 
> So, in your examples are actually *no* ESP fix area mappings as those
> would be r/o. In fact, I think, the above dumps are the result of a
> CONFIG_EFI_PGT_DUMP enabled kernel that dumps the page table after
> setting up the EFI mappings. There are no ESP fix mappings in this dump
> because those are only set up after the EFI runtime service mappings.

Ok, I think I know what the deal is:

So, the ptdump we do to dmesg very early at boot is the EFI pagetable which
shouldn't have espfix mappings...

> See the following code in init/main:
> 
>   #ifdef CONFIG_X86
>       if (efi_enabled(EFI_RUNTIME_SERVICES))
>           efi_enter_virtual_mode();
>   #endif
>   #ifdef CONFIG_X86_ESPFIX64
>       /* Should be run before the first non-init thread is created */
>       init_espfix_bsp();
>   #endif

... exactly because of this: we're setting up the EFI mappings in
the EFI page table before we do the espfix mappings in the *kernel*
pagetable which is a separate one.

So, if we have to be really correct about it, the first dump to dmesg
which comes down the efi_enter_virtual_mode() path shouldn't contain the
espfix area at all.

Later dumps from debugfs cannot select the EFI pagetable so they should
not be dumping the EFI runtime services.

I don't have a good idea about how to do that right now though, maybe
the address markers should have flags or so...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
