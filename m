Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3H3Hsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:48:39 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36053 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab3H3Hsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:48:37 -0400
Message-ID: <52204E4D.3030602@synopsys.com>
Date: Fri, 30 Aug 2013 13:18:29 +0530
From: Vineet Gupta <vineetg76@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michel Lespinasse <walken@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Arnd Bergmann <arnd@arndb.de>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] Kconfig.debug: Add FRAME_POINTER anti-dependency for
 ARC
References: <1377592285-21148-1-git-send-email-vgupta@synopsys.com> <521F662F.4050003@intel.com>
In-Reply-To: <521F662F.4050003@intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+linux-arch and other arch maintainers]

On 08/29/2013 08:48 PM, Dave Hansen wrote:
> On 08/27/2013 01:31 AM, Vineet Gupta wrote:
>> Frame pointer on ARC doesn't serve the conventional purpose of stack
>> unwinding due to the typical way ABI designates it's usage.
>> Thus it's explicit usage on ARC is discouraged (gcc is free to use it,
>> for some tricky stack frames even if -fomit-frame-pointer)
> ...
>> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
>> index 1501aa5..c971f3a 100644
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -908,7 +908,7 @@ config LOCKDEP
>>  	bool
>>  	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
>>  	select STACKTRACE
>> -	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE
>> +	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE && !ARC
>>  	select KALLSYMS
>>  	select KALLSYMS_ALL
> 
> I assume you're sending this my way since getmaintainer.pl has me tagged
> I moved a bunch of code in there. :)
> 
> The Kconfig.debug stuff has no real maintainer.  It would probably be OK
> if you just stick this in your architecture's next git pull request.
> 
> Although, it would be nice if someone, at some point, actually
> abstracted that out so that the individual architectures could take care
> of this without editing the main files:
> 
> # Kconfig.debug:
> 
> config ARCH_FRAME_POINTER_UNAVAILABLE
> 	def_bool y
> ...
> select FRAME_POINTER if !ARCH_FRAME_POINTER_UNAVAILABLE
> 
> # arch/.../Kconfig
> 
> select ARCH_FRAME_POINTER_UNAVAILABLE
> 
> 

I thought about this a bit. So adding ARCH_FRAME_POINTER_UNAVAILABLE does help
cleanup the anti-dependency list for say LATENCY_TOP for (MIPS, PPC, S390,
MICROBLAZE, ARM_UNWIND, ARC), but we are still stuck with keeping both
ARCH_WANT_FRAME_POINTERS and ARCH_FRAME_POINTER_UNAVAILABLE.

If we had ARCH_FRAME_POINTER_UNAVAILABLE (def_bool n), we could potentially remove
ARCH_FRAME_POINTER too:

1. arches which explicitly select ARCH_FRAME_POINTER (xtensa, parisc, arm64, x86,
unicore32, tile) could just drop that select.

2. Others which add themselves to config FRAME_POINTER depends on (CRIS, M68K,
FRV, UML, AVR32, SUPERH, BLACKFIN, MN10300, METAG) can simply be removed form that
list.

3. Other who want to inhibit FP obviously select it (MIPS, PPC, S390, MICROBLAZE,
ARM_UNWIND, ARC)

The issue is some (sparc, c6x...) which are neither in #1 or #2, and not present
in anti-dependency list either. e.g. With sparc64_defconfig FP is not present, but
if I enable LATENCY_TOP, FP is enabled. For such cases, what do we make default ?

This seemed so trivial to do to begin with :-)

-Vineet
