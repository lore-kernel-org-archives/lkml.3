Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018AbaKNBkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:40:25 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62698 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964984AbaKNBkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:40:23 -0500
Message-ID: <54655D7E.1000301@linaro.org>
Date: Fri, 14 Nov 2014 10:40:14 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
CC: Andreas Krebbel1 <Andreas.Krebbel@de.ibm.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        linaro-kernel@lists.linaro.org,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "roland@hack.frob.com" <roland@hack.frob.com>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org> <3899236.yrOvvrZHD6@wuerfel> <OF152076B7.38277C08-ONC1257D8F.0050C2DF-C1257D8F.00516BF2@de.ibm.com> <1472197.o98pKNTkBz@wuerfel>
In-Reply-To: <1472197.o98pKNTkBz@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich, Arnd, thank you for your discussions:

On 11/14/2014 07:25 AM, Arnd Bergmann wrote:
> On Thursday 13 November 2014 15:49:20 Ulrich Weigand wrote:
>> Arnd Bergmann <arnd@arndb.de> wrote on 13.11.2014 11:21:28:
>>
>>> I have to admit that I don't really understand gdb internals, but from
>>> a first look I get the impression that it will just do the right thing
>>> if you reuse NT_S390_SYSTEM_CALL on ARM64 with the same semantics.
>>
>> There's an interface between BFD and GDB proper involved here.  BFD will
>> detect the presence of register set notes in the core dump, and will
>> translate them into virtual sections; GDB will then simply look up such
>> sections under well-known names.
>>
>> In particular, the NT_S390_SYSTEM_CALL note will be translated by BFD
>> into a virtual section named ".reg-s390-system-call"; GDB platform-
>> specific code will look for sections of this particular name.
>>
>> So if you were to create notes using the same note type, by default it
>> would do nothing on ARM64.  You might add code to the ARM64 back-end
>> to also look for a section ".reg-s390-system-call", but that would be
>> somewhat confusing.  Using a new, platform-specific note type for ARM64
>> would appear to fit better with existing precedent.

I implemented a regset of NT_SYSTEM_CALL(=NT_S390_SYSTEM_CALL) experimentally,
and checked a generated core file:

 >$ aarch64-linux-gnu-readelf -Wn <...>/tmp/nulltest/core
 >
 >Displaying notes found at file offset 0x000003c0 with length 0x00000a68:
 >  Owner                 Data size    Description
 >  CORE                 0x00000188    NT_PRSTATUS (prstatus structure)
 >  CORE                 0x00000088    NT_PRPSINFO (prpsinfo structure)
 >  CORE                 0x00000080    NT_SIGINFO (siginfo_t data)
 >  CORE                 0x00000130    NT_AUXV (auxiliary vector)
 >  CORE                 0x000001b4    NT_FILE (mapped files)
 >    Page size: 4096
 >                 Start                 End         Page Offset
 >[snip]...
 >  CORE                 0x00000210    NT_FPREGSET (floating point registers)
 >  LINUX                0x00000008    NT_ARM_TLS (AArch TLS registers)
 >  LINUX                0x00000108    NT_ARM_HW_BREAK (AArch hardware breakpoint registers)
 >  LINUX                0x00000108    NT_ARM_HW_WATCH (AArch hardware watchpoint registers)
 >  LINUX                0x00000004    NT_S390_SYSTEM_CALL (s390 system call restart data)

Looks funny:)

> Ok, thanks a lot for your insight and for confirming what Takahiro AKASHI
> said. Let's use a new NT_ARM64_SYSTEM_CALL type with a different
> number then.

We will use NT_ARM_SYSTEM_CALL(=0x404) as other NT_ARM_*, except NT_ARM_VFP,
are also shared by arch/arm and arch/arm64.

Anyhow, gdb (and/or binutils?) should be updated as well once my coming patch is merged.
My next question is who should know this?

Thanks,
-Takahiro AKASHI

> 	Arnd
>
