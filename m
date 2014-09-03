Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbaICPha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:37:30 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:52945 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbaICPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:37:28 -0400
MIME-Version: 1.0
In-Reply-To: <54073409.6030004@canonical.com>
References: <5405E186.2080406@canonical.com>
	<20140902192941.GB3001@console-pimps.org>
	<CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>
	<5406D0DB.90401@canonical.com>
	<CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
	<54073409.6030004@canonical.com>
Date: Wed, 3 Sep 2014 17:37:26 +0200
Message-ID: <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Matt Fleming <matt@console-pimps.org>, Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 September 2014 17:30, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> Hey,
>
> Op 03-09-14 om 14:18 schreef Ard Biesheuvel:
>> Could you please try adding the visibility attribute lik this instead?
>>
>> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
>> index 044a2fd3c5fe..8725d85f1903 100644
>> --- a/arch/x86/include/asm/efi.h
>> +++ b/arch/x86/include/asm/efi.h
>> @@ -178,7 +178,7 @@ struct efi_config {
>>         bool is64;
>>  } __packed;
>>
>> -extern struct efi_config *efi_early;
>> +extern __attribute__((visibility("hidden"))) struct efi_config *efi_early;
>>
>>  #define efi_call_early(f, ...)                                         \
>>         efi_early->call(efi_early->f, __VA_ARGS__);
>>
>> Before this change, I get 18 R_X86_64_GOTPCREL relocations pointing to
>> efi_early, both in efi-stub-helper.c and eboot.c.
>> After the change, I get 0, using 'readelf -a
>> drivers/firmware/efi/libstub/efi-stub-helper.o
>> arch/x86/boot/compressed/eboot.o|grep GOTPCREL|wc -l'
>>
> Yeah that fixes things!
>
> Feel free to slap on a reported-reviewed-and-tested-by on your patch. :-)
>

Will do, thanks.

@Matt: so there is two ways to fix this, the patch above addressing
this single instance, and alternatively, adding a #pragma GCC
visiblilty push(hidden) to all .c files under libstub/, *before* the
#includes. The latter would catch future problems regarding newly
introduced global variables, but it may be a bit overkill in this
case, as libstub is not expected to be in flux in the foreseeable
future.

Any preferences?

-- 
Ard.
