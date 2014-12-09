Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaLIRhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:37:38 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:51595 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaLIRhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:37:34 -0500
MIME-Version: 1.0
In-Reply-To: <54860571.4060803@de.ibm.com>
References: <5480F756.90106@upv.es>
	<54860571.4060803@de.ibm.com>
Date: Tue, 9 Dec 2014 09:37:33 -0800
X-Google-Sender-Auth: NnJljr2DYSbGSdutHo27kdxUvzs
Message-ID: <CAGXu5j+4nmdxTKoRLR49gAd0tsGxk0xhAv+=FnLtaSptx=Zn1w@mail.gmail.com>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
From: Kees Cook <keescook@chromium.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Hector Marco <hecmargi@upv.es>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 12:09 PM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> Am 05.12.2014 um 01:07 schrieb Hector Marco:
>> [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
>>
>>   The issue appears on PIE linked executables when all memory areas of
>>   a process are randomized (randomize_va_space=2). In this case, the
>>   attack "offset2lib" de-randomizes all library areas on 64 bit Linux
>>   systems in less than one second.
>>
>>   Further details of the PoC attack at:
>>   http://cybersecurity.upv.es/attacks/offset2lib/offset2lib.html
>>
>>   PIE linked applications are loaded side by side with the dynamic
>>   libraries, which is exploited by the offset2lib attack. Moving away
>>   the executable from the mmap_base area (libraries area) prevents the
>>   attack.
>>
>>   This patch loads the PIE linked executable in a different area than
>>   the libraries when randomize_va_space=3.
>>
>>   Patch implementation details:
>>
>>    - The ELF_ET_DYN_BASE address is used as the base to load randomly
>>      the PIE executable.
>>
>>    - The executable image has the same entropy than
>>      randomize_va_space=2.
> [...]
>> --- a/arch/arm/mm/mmap.c
>> +++ b/arch/arm/mm/mmap.c
> [...]
>> --- a/arch/arm64/mm/mmap.c
>> +++ b/arch/arm64/mm/mmap.c
> [...]
>
>> --- a/arch/x86/mm/mmap.c
>> +++ b/arch/x86/mm/mmap.c
> [...]
>
> FWIW, please note that s390 and power (maybe others?) also have PIE support done differently, e.g.
> commit d2c9dfccbc3 ("[S390] Randomize PIEs") and commit 501cb16d3cfdc ("powerpc: Randomise PIEs")
>
> What I can tell from a quick look both architectures should be fine regarding offsetlib, as they place the executable already in a different section and randomize those differently even with randomize_va_space=2.
>
> Would it make sense to unify the implementations again?

Seems like that would be best. If this is already being done on
non-x86 and non-arm, we should just fix x86 and arm to DTRT. :)

-Kees

-- 
Kees Cook
Chrome OS Security
