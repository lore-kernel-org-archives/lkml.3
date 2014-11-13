Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaKMHC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 02:02:59 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60200 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbaKMHC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 02:02:57 -0500
Message-ID: <54645799.5010409@linaro.org>
Date: Thu, 13 Nov 2014 16:02:49 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linaro-kernel@lists.linaro.org
CC: Will Deacon <will.deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org> <54633F53.8020507@linaro.org> <20141112111352.GC26437@arm.com> <6358312.yt5WU3kBm9@wuerfel>
In-Reply-To: <6358312.yt5WU3kBm9@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 08:19 PM, Arnd Bergmann wrote:
> On Wednesday 12 November 2014 11:13:52 Will Deacon wrote:
>> On Wed, Nov 12, 2014 at 11:06:59AM +0000, AKASHI Takahiro wrote:
>>> On 11/12/2014 08:00 PM, Will Deacon wrote:
>>>> On Wed, Nov 12, 2014 at 10:46:01AM +0000, AKASHI Takahiro wrote:
>>>>> On 11/07/2014 11:04 PM, Oleg Nesterov wrote:
>>>>>> To me the fact that PTRACE_SET_SYSCALL can be undefined and syscall_set_nr()
>>>>>> is very much arch-dependant (but most probably trivial) means that this  code
>>>>>> should live in arch_ptrace().
>>>>>
>>>>> Thinking of Oleg's comment above, it doesn't make sense neither to define generic
>>>>> NT_SYSTEM_CALL (user_regset) in uapi/linux/elf.h and implement it in ptrace_regset()
>>>>> in kernel/ptrace.c with arch-defined syscall_(g)set_nr().
>>>>>
>>>>> Since we should have the same interface on arm and arm64, we'd better implement
>>>>> ptrace(PTRACE_SET_SYSCALL) locally on arm64 for now (as I originally submitted).
>>>>
>>>> I think the regset approach is cleaner. We already do something similar for
>>>> TLS. That would be implemented under arch/arm64/ with it's own NT type.
>>>
>>> Okey, so arm64 goes its own way
>>> Or do you want to have a similar regset on arm, too?
>>> (In this case, NT_ARM_SYSTEM_CALL can be shared in uapi/linux/elf.h)
>>
>> Just do arm64. We already have the dedicated request for arch/arm/.
>
> I wonder if we should define NT_ARM64_SYSTEM_CALL to the same value
> as NT_S390_SYSTEM_CALL (0x307), or even define it as an architecture-
> independent NT_SYSTEM_CALL number with that value, so other architectures
> don't have to introduce new types when they also want to implement it.

I digged into gdb code (gdb/bfd/elf.c):
https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=blob;f=bfd/elf.c;h=8b207ad872a3992381e93bdfa0a75ef444651613;hb=HEAD
   elf_parse_notes()->elfcore_grok_note()->elfcore_grok_s390_system_call()

It seems to me that NT_S390_SYSTEM_CALL(=0x307) is recognized as a s390 specific
value (without checking for machine type). So thinking of potential conflict, it might not be
a good idea to use this value as a common number (of NT_SYSTEM_CALL).
It's very unlikely that a "note" section for NT_(S390_)SYSTEM_CALL appears in a coredump file, though.

What do you think?

-Takahiro AKASHI

>
> 	Arnd
>
