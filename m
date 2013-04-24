Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab3DXLSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:18:06 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:56504 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3DXLSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:18:04 -0400
Message-ID: <5177BF67.2040308@intel.com>
Date: Wed, 24 Apr 2013 12:17:59 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] x86, efi: Fix a build warning
References: <1366798154-1380-1-git-send-email-bp@alien8.de> <20130424105610.GA15815@gmail.com>
In-Reply-To: <20130424105610.GA15815@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/13 11:56, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@alien8.de> wrote:
> 
>> From: Borislav Petkov <bp@suse.de>
>>
>> Fix this:
>>
>> arch/x86/boot/compressed/eboot.c: In function ???setup_efi_vars???:
>> arch/x86/boot/compressed/eboot.c:269:2: warning: passing argument 1 of ???efi_call_phys??? makes pointer from integer without a cast [enabled by default]
>> In file included from arch/x86/boot/compressed/eboot.c:12:0:
>> /w/kernel/linux/arch/x86/include/asm/efi.h:8:33: note: expected ???void *??? but argument is of type ???long unsigned int???
>>
>> after cc5a080c5d40 ("efi: Pass boot services variable info to runtime
>> code").
>>
>> Cc: Matthew Garrett <matthew.garrett@nebula.com>
>> Cc: Matt Fleming <matt.fleming@intel.com>
>> Signed-off-by: Borislav Petkov <bp@suse.de>
>> ---
>>  arch/x86/boot/compressed/eboot.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
>> index 8615f7581820..41de115a55b7 100644
>> --- a/arch/x86/boot/compressed/eboot.c
>> +++ b/arch/x86/boot/compressed/eboot.c
>> @@ -266,7 +266,7 @@ static efi_status_t setup_efi_vars(struct boot_params *params)
>>  	while (data && data->next)
>>  		data = (struct setup_data *)(unsigned long)data->next;
>>  
>> -	status = efi_call_phys4(sys_table->runtime->query_variable_info,
>> +	status = efi_call_phys4((void *)sys_table->runtime->query_variable_info,
>>  				EFI_VARIABLE_NON_VOLATILE |
>>  				EFI_VARIABLE_BOOTSERVICE_ACCESS |
>>  				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
> 
> Why isn't the query_variale_info field changed to void * instead? That way 
> no cast would be needed.

We could either change all fields in efi_system_table or the
efi_call_phys* prototypes. x86-64 already casts to (void *) when calling
efi_call0(), etc, though I'm not entirely sure why void * is needed.

