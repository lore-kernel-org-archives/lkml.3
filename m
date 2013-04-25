Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3DYGzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:55:35 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:42377 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3DYGzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:55:33 -0400
Date: Thu, 25 Apr 2013 08:55:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] x86, efi: Fix a build warning
Message-ID: <20130425065529.GD7806@gmail.com>
References: <1366798154-1380-1-git-send-email-bp@alien8.de>
 <20130424105610.GA15815@gmail.com>
 <5177BF67.2040308@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5177BF67.2040308@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt.fleming@intel.com> wrote:

> On 24/04/13 11:56, Ingo Molnar wrote:
> > 
> > * Borislav Petkov <bp@alien8.de> wrote:
> > 
> >> From: Borislav Petkov <bp@suse.de>
> >>
> >> Fix this:
> >>
> >> arch/x86/boot/compressed/eboot.c: In function ???setup_efi_vars???:
> >> arch/x86/boot/compressed/eboot.c:269:2: warning: passing argument 1 of ???efi_call_phys??? makes pointer from integer without a cast [enabled by default]
> >> In file included from arch/x86/boot/compressed/eboot.c:12:0:
> >> /w/kernel/linux/arch/x86/include/asm/efi.h:8:33: note: expected ???void *??? but argument is of type ???long unsigned int???
> >>
> >> after cc5a080c5d40 ("efi: Pass boot services variable info to runtime
> >> code").
> >>
> >> Cc: Matthew Garrett <matthew.garrett@nebula.com>
> >> Cc: Matt Fleming <matt.fleming@intel.com>
> >> Signed-off-by: Borislav Petkov <bp@suse.de>
> >> ---
> >>  arch/x86/boot/compressed/eboot.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> >> index 8615f7581820..41de115a55b7 100644
> >> --- a/arch/x86/boot/compressed/eboot.c
> >> +++ b/arch/x86/boot/compressed/eboot.c
> >> @@ -266,7 +266,7 @@ static efi_status_t setup_efi_vars(struct boot_params *params)
> >>  	while (data && data->next)
> >>  		data = (struct setup_data *)(unsigned long)data->next;
> >>  
> >> -	status = efi_call_phys4(sys_table->runtime->query_variable_info,
> >> +	status = efi_call_phys4((void *)sys_table->runtime->query_variable_info,
> >>  				EFI_VARIABLE_NON_VOLATILE |
> >>  				EFI_VARIABLE_BOOTSERVICE_ACCESS |
> >>  				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
> > 
> > Why isn't the query_variale_info field changed to void * instead? That way 
> > no cast would be needed.
> 
> We could either change all fields in efi_system_table or the
> efi_call_phys* prototypes. x86-64 already casts to (void *) when calling
> efi_call0(), etc, though I'm not entirely sure why void * is needed.

It's a basic cleanliness and robustness issue: we generally avoid type 
casts in the kernel, because type casts override compile-time type checks 
and are easy to get wrong. They are also ugly.

So in generaly we try to use the right type for the data structure, which 
matches its usage (and standardize functions/methods around that type) - 
then no cast is needed.

Thanks,

	Ingo
