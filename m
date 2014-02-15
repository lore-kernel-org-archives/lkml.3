Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaBOSoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 13:44:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40250 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbaBOSoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 13:44:19 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1392474801.1585.8.camel@wall-e.seibold.net>
References: <1392367964-32118-1-git-send-email-stefani@seibold.net> <52FE9993.8060109@zytor.com> <1392474801.1585.8.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v16 0/10] Add 32 bit VDSO time function support
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 15 Feb 2014 10:42:45 -0800
To: Stefani Seibold <stefani@seibold.net>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Message-ID: <325723f1-697e-4032-ac39-d7ecdddfb3f9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generated/ prefix is wrong because when using O= to build we add $(srcdir)/arch/x86/include and $(objdir)/arch/x86/include/generated to the include path, not $(objdir)/arch/x86/include.

On February 15, 2014 6:33:21 AM PST, Stefani Seibold <stefani@seibold.net> wrote:
>
>Am Freitag, den 14.02.2014, 14:32 -0800 schrieb H. Peter Anvin:
>> I still get build errors.
>> 
>
>Oops, i did it again...
>
>> i386 allyesconfig, i386 allmodconfig as well as a more basic i386
>> configuration:
>> 
>> arch/x86/vdso/vdso32-int80.so.dbg: undefined symbols found
>> make[4]: *** [arch/x86/vdso/vdso32-int80.so.dbg] Error 1
>> 
>
>The problem is the call of vget_cycles() in function vread_tsc().
>
>vget_cycles() will access  cpu_has_tsc which is a macro which access
>boot_cpu_data, which is not available in a VDSO.
>
>But i think it is save to replace the call by __native_read_tsc() and
>skip the test of cpu_has_tsc, because vread_tsc() will be only invoked
>when gtod->vclock_mode == VCLOCK_TSC. Since the kernel will set this
>when the TSC is the current clock, the CPU must have a TSC.
>
>There was also a issue with arch/x86/tools/relocs.c, the __vvar_page
>must be outside the #if ELF_BITS == 64
>
>So i tested it now with
>
>make distclean
>make ARCH=i386 allyesconfig
>
>And it compiles a kernel without an error.
>
>> x86-64 allyesconfig and x86-64 allmodconfig:
>> 
>>
>/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:128:4:
>warning:
>> symbol 'hpet_page' was not declared
>> . Should it be static?
>>
>/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:134:33:
>> warning: incorrect type in argument 1 (diff
>> erent address spaces)
>>
>/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:134:33:
>>    expected void const volatile [noderef] <
>> asn:2>*addr
>>
>/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:134:33:
>>    got unsigned char [toplevel] *
>>
>/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:294:13:
>> warning: symbol '__vdso_clock_gettime' was
>> not declared. Should it be static?
>>
>/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:322:13:
>> warning: symbol '__vdso_gettimeofday' was n
>> ot declared. Should it be static?
>>
>/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:343:16:
>> warning: symbol '__vdso_time' was not decla
>> red. Should it be static?
>>   CC      arch/x86/vdso/vdso32/vclock_gettime.o
>> /home/hpa/kernel/distwork/arch/x86/vdso/vdso32/vclock_gettime.c:1:0:
>> sorry, unimplemented: -mfentry isn’t supported fo
>> r 32-bit in combination with -fpic
>>  #define BUILD_VDSO32
>>  ^
>> make[4]: *** [arch/x86/vdso/vdso32/vclock_gettime.o] Error 1
>> make[3]: *** [arch/x86/vdso] Error 2
>> make[3]: *** Waiting for unfinished jobs....
>> 
>> This is after I removed the incorrect "generated/" filename prefix in
>> patch 9.
>> 
>
>make distclean
>make allyesconfig
>
>Compiles without an error.
>
>Why is the
>
>#include <generated/asm/unistd_32_ia32.h>
>
>incorrect?
>
>The bit kernel syscall function numbers are needed in case build a 32
>bit VDSO for a 64 bit kernel.
>
>A quick "find . -name \*.c | xargs grep 'generated/'" in the kernel
>sources showed up 38 includes of a generated header.
>
>If it is incorrect to include a generated header why therefore are
>generated? Only to waste disc space?
>
>- Stefani

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
