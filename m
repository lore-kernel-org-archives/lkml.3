Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbaKSQCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:02:46 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:48320 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbaKSQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:02:42 -0500
MIME-Version: 1.0
In-Reply-To: <CALYGNiMt2A3DP02cOtxqu4RrnmhojrDxkRG7bkHMByUnzG+PeA@mail.gmail.com>
References: <20141118172146.3784.81151.stgit@buzz>
	<20141118173413.GB4042@n2100.arm.linux.org.uk>
	<546B8C64.3010904@samsung.com>
	<2041617.Kxhx5O4MMr@wuerfel>
	<CAKv+Gu-8qhHYOry+LsDzp+LDZqYxVZ5G7cj48E3G2Unp2+=_yg@mail.gmail.com>
	<CALYGNiMt2A3DP02cOtxqu4RrnmhojrDxkRG7bkHMByUnzG+PeA@mail.gmail.com>
Date: Wed, 19 Nov 2014 17:02:40 +0100
Message-ID: <CAKv+Gu-rYWutr-45MsZH6KOhhUyNCVLfkO9JQrqCm1L6ms_DUg@mail.gmail.com>
Subject: Re: [PATCH RFC] ARM: option for loading modules into vmalloc area
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrey Ryabinin <a.ryabinin@samsung.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2014 16:52, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> On Wed, Nov 19, 2014 at 5:54 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> On 19 November 2014 14:40, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Tuesday 18 November 2014 21:13:56 Konstantin Khlebnikov wrote:
>>>> On 2014-11-18 20:34, Russell King - ARM Linux wrote:
>>>> > On Tue, Nov 18, 2014 at 08:21:46PM +0400, Konstantin Khlebnikov wrote:
>>>> >> Usually modules are loaded into small area prior to the kernel
>>>> >> text because they are linked with the kernel using short calls.
>>>> >> Compile-time instrumentation like GCOV or KASAN bloats code a lot,
>>>> >> and as a result huge modules no longer fit into reserved area.
>>>> >>
>>>> >> This patch adds option CONFIG_MODULES_USE_VMALLOC which lifts
>>>> >> limitation on amount of loaded modules. It links modules using
>>>> >> long-calls (option -mlong-calls) and loads them into vmalloc area.
>>>> >>
>>>> >> In few places exported symbols are called from inline assembly.
>>>> >> This patch adds macro for such call sites: __asmbl and __asmbl_clobber.
>>>> >> Call turns into single 'bl' or sequence 'movw; movt; blx' depending on
>>>> >> context and state of config option.
>>>> >>
>>>> >> Unfortunately this option isn't compatible with CONFIG_FUNCTION_TRACER.
>>>> >> Compiler emits short calls to profiling function despite of -mlong-calls.
>>>> >> This is a bug in GCC, but ftrace anyway needs an update to handle this.
>>>> > It also isn't compatible with the older architectures which don't have
>>>> > "blx".
>>>>
>>>> Ok, I'll add "depends on CPU_V6 || CPU_V7" I don't think that it is
>>>> necessary for older cpus.
>>>
>>> Why not just use a different branch instruction for the older CPUs?
>>>
>>
>> ARMv6 doesn't support movw/movt so this will only work on v7.
>>
>> What about doing 'mov lr, pc; ldr pc,=symbol' instead? You clearly
>> don't care about performance in this case, so the performance hit (due
>> to the dcache access and interfering with the return stack predictors)
>> should be tolerable. The only thing to be careful about is thumb2
>> kernels: you would need to set the thumb bit in lr manually but only
>> if the call is made /from/ thumb. You would probably be better off
>> just depending on !THUMB2_KERNEL.
>
> Do you mean ldr pc, =symbol ?
>
> In this case I get this error:
>
> /tmp/ccAHtONU.s: Assembler messages:
> /tmp/ccAHtONU.s:220: Error: invalid literal constant: pool needs to be closer
>
> Probably constant pool doesn't work well in inline assembly.
>
>
> Something like this seems work:
>
> add     lr, pc, #4
> ldr       pc, [pc, #-4]
> .long symbol
>

You can add a '.ltorg' instruction which tells the assembler to dump
the literal pool, but you still need to jump over it, i.e.,

adr lr, 0f
ldr pc, =symbol
.ltorg
0:
-- 
Ard.
