Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbaJIWTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 18:19:06 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:5074 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaJIWTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 18:19:04 -0400
Message-ID: <543709D0.6000501@imgtec.com>
Date: Thu, 9 Oct 2014 15:18:56 -0700
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: <linux-mips@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <geert+renesas@glider.be>, <david.daney@cavium.com>,
        <peterz@infradead.org>, <paul.gortmaker@windriver.com>,
        <davidlohr@hp.com>, <macro@linux-mips.org>, <chenhc@lemote.com>,
        <richard@nod.at>, <zajec5@gmail.com>, <james.hogan@imgtec.com>,
        <keescook@chromium.org>, <alex@alex-smith.me.uk>, <tglx@linutronix.de>,
        <blogic@openwrt.org>, <jchandra@broadcom.com>,
        <paul.burton@imgtec.com>, <qais.yousef@imgtec.com>,
        <linux-kernel@vger.kernel.org>, <ralf@linux-mips.org>,
        <markos.chandras@imgtec.com>, <dengcheng.zhu@imgtec.com>,
        <manuel.lauss@gmail.com>, <akpm@linux-foundation.org>,
        <lars.persson@axis.com>
Subject: Re: [PATCH v2 0/3] MIPS executable stack protection
References: <20141009195030.31230.58695.stgit@linux-yegoshin> <5437015B.3010205@gmail.com>
In-Reply-To: <5437015B.3010205@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 02:42 PM, David Daney wrote:
> On 10/09/2014 01:00 PM, Leonid Yegoshin wrote:
>> The following series implements an executable stack protection in MIPS.
>>
>> It sets up a per-thread 'VDSO' page and appropriate TLB support.
>> Page is set write-protected from user and is maintained via kernel VA.
>> MIPS FPU emulation is shifted to new page and stack is relieved for
>> execute protection as is as all data pages in default setup during ELF
>> binary initialization. The real protection is controlled by GLIBC and
>> it can do stack protected now as it is done in other architectures and
>> I learned today that GLIBC team is ready for this.
>
> What does it mean to be 'ready'?  If they committed patches before 
> there was kernel support, that it putting the cart before the horse.  
> GlibC's state cannot be used as valid reason for committing major 
> kernel changes.  There would be no regression in any GLibC based 
> system as a result of not merging this patch.
Rich Fuhler said me that they discussed it internally and have a 
solution to fix their problem (ignoring PT_GNU_STACK on first library 
load - they need to sort out the logic). But we need to split both issue 
- right now stack can't be protected because of emulation. If they set 
stack protected then emulation fails on CPU without FPU.

>
>>
>> Note: actual execute-protection depends from HW capability, of course.
>>
>> This patch is required for MIPS32/64 R2 emulation on MIPS R6 
>> architecture.
>> Without it 'ssh-keygen' crashes pretty fast on attempt to execute 
>> instruction
>> in stack.
>
> There is much more blocking MIPS32/64 R2 emulation on MIPS R6 than 
> just this patch isn't there?

This one is critical - ssh-keygen crashes during running MIPS R2. I have 
a patch in my R6 repository but GLIBC still can't set stack executable 
and security suffers.

>
> Also, if you are supporting MIPS R6, this patch doesn't even work, 
> because it doesn't handle PC relative instructions at all.

It seems like you missed my statement - adding support for PC-relative 
instruction is just 5 lines of code. I just refrain from this until 
toolchain starts generating that.

Besides that, this version 2 of patch just passed 20-22 hours on P5600 
and Virtuoso (no FPU on both) under SOAK test and it gets around 1 per 
hour of signal right at emulated instruction in VDSO and unwind works 
(as I can see in debug prints).

>
>
> The recent discussions on this subject, including many comments from 
> Imgtec e-mail addresses, brought to light the need to use an 
> instruction set emulator for newer MIPSr6 ISA processors.

In Imgtec I am only one who works on MIPS R6 SW and FPU branch emulation 
and I say you - it is not needed, this solution is enough.

>
> In light of this, why does it make sense to merge this patch, instead 
> of taking the approach of emulating the instructions in the delay slot?

Well, because it does exist now. But full MIPS emulator... for all 
ASEs... for any MIPS vendor... I even doesn't want to estimate an amount 
of time and code size to develop it.

Besides that, you missed my another statement - we don't force customer 
to disclose all details of their COP2 instructions.

- Leonid
