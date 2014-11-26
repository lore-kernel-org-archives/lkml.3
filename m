Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaKZGqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 01:46:16 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:60818 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaKZGqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 01:46:14 -0500
Message-ID: <54757734.4060301@linaro.org>
Date: Wed, 26 Nov 2014 01:46:12 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        William Cohen <wcohen@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] arm64: Kprobes with single stepping support
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org> <1416292375-29560-2-git-send-email-dave.long@linaro.org> <20141118145643.GO18842@arm.com> <CA+b37P337jcTCPTg4Ydxh6TKwqmyMngt-eEowzfsTNBDZ7-NEg@mail.gmail.com> <20141119112553.GC15985@arm.com> <546CAF5A.4060901@linaro.org>
In-Reply-To: <546CAF5A.4060901@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/14 09:55, David Long wrote:
> On 11/19/14 06:25, Will Deacon wrote:
>> On Wed, Nov 19, 2014 at 11:21:24AM +0000, Sandeepa Prabhu wrote:
>>> On 18 November 2014 20:26, Will Deacon <will.deacon@arm.com> wrote:
>>>
>>>> One thing I noticed looking through this patch is that we're
>>>> effectively
>>>> reinventing a bunch of the instruction decoding logic that we
>>>> already have
>>>> in the kernel (introduced since Sandeepa last sent his patch).
>>>>
>>>> Could you take a look at include/asm/insn.h and kernel/insn.c
>>>> please, and
>>>> see if you can at least consolidate some of this? Some of it should
>>>> be easy
>>>> (i.e. reusing masks, using existing #defines to construct BRK
>>>> encodings),
>>>> but I appreciate there may be places where kprobes needs to add
>>>> extra bits,
>>>> in which case I'd really like to keep this all together if at all
>>>> possible.
>>>>
>>>> We're currently in a position where the module loader, BPF jit,
>>>> ftrace and
>>>> the proposed alternative patching scheme are all using the same
>>>> instruction
>>>> manipulation functions, so we should try to continue that trend if
>>>> we can.
>>> Will,
>>>
>>> kernel/insn.c support generating instruction encodings(forming opcodes
>>> with given specifications), so for kprobes, only BRK encoding can use
>>> this mechanism.
>>> For instruction simulation, the instruction behavior should be
>>> simulated on saved pt_regs, which is not supported on insn.c routines,
>>> so still need probes-simulate-insn.c. Please point me if I am missing
>>> something here.
>>
>> I was thinking of the magic hex numbers in the kprobes decode tables,
>> which
>> seem to correspond directly to the instruction classes described in
>> insn.c
>>
>> Keeping the actual emulation code separate makes sense.
>>
>> Will
>
> Of course that follows the model of the much more complex arm32
> kprobes/uprobes decoding.  I can have a go at replacing it with insn.c
> calls.
>
> -dl
>

While the existing aarch64_get_insn_class() function in insn.c is 
somewhat useful here what is really needed is a function that identifies 
if an instruction uses the pc (branch, load literal, load address). 
Such instructions cannot be arbitrarily moved around in isolation, and 
do not fall neatly into the existing "class"es.  I've written a simple 
aarch64_insn_uses_pc() function to add to insn.c but I'd like to hear 
agreement that this is a good approach before sending out the patch. 
Thoughts?

-dl

