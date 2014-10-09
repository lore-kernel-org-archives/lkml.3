Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaJIW7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 18:59:43 -0400
Received: from mail-bn1on0071.outbound.protection.outlook.com ([157.56.110.71]:5824
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751015AbaJIW7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 18:59:41 -0400
Message-ID: <5437134E.5040601@caviumnetworks.com>
Date: Thu, 9 Oct 2014 15:59:26 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <Zubair.Kakakhel@imgtec.com>, <geert+renesas@glider.be>,
        <david.daney@cavium.com>, <peterz@infradead.org>,
        <paul.gortmaker@windriver.com>, <davidlohr@hp.com>,
        <macro@linux-mips.org>, <chenhc@lemote.com>, <richard@nod.at>,
        <zajec5@gmail.com>, <james.hogan@imgtec.com>, <keescook@chromium.org>,
        <alex@alex-smith.me.uk>, <tglx@linutronix.de>, <blogic@openwrt.org>,
        <jchandra@broadcom.com>, <paul.burton@imgtec.com>,
        <qais.yousef@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <markos.chandras@imgtec.com>,
        <dengcheng.zhu@imgtec.com>, <manuel.lauss@gmail.com>,
        <akpm@linux-foundation.org>, <lars.persson@axis.com>
Subject: Re: [PATCH v2 0/3] MIPS executable stack protection
References: <20141009195030.31230.58695.stgit@linux-yegoshin> <5437015B.3010205@gmail.com> <543709D0.6000501@imgtec.com>
In-Reply-To: <543709D0.6000501@imgtec.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-ClientProxiedBy: BN1PR07CA0036.namprd07.prod.outlook.com (10.255.193.11) To
 CO2PR07MB587.namprd07.prod.outlook.com (10.141.229.150)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR07MB587;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(377454003)(479174003)(51704005)(189002)(51444003)(199003)(24454002)(20776003)(80316001)(46102003)(50986999)(47776003)(64706001)(42186005)(83506001)(76176999)(23676002)(19580395003)(80022003)(4396001)(36756003)(92726001)(33656002)(95666004)(66066001)(87266999)(54356999)(69596002)(65806001)(92566001)(65956001)(110136001)(65816999)(97736003)(85306004)(122386002)(21056001)(53416004)(81156004)(31966008)(76482002)(106356001)(101416001)(107046002)(561944003)(102836001)(50466002)(105586002)(77096002)(87976001)(99396003)(40100002)(120916001)(85852003)(64126003)(59896002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB587;H:dl.caveonetworks.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR07MB972;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 03:18 PM, Leonid Yegoshin wrote:
> On 10/09/2014 02:42 PM, David Daney wrote:
>> On 10/09/2014 01:00 PM, Leonid Yegoshin wrote:
>>> The following series implements an executable stack protection in MIPS.
>>>
>>> It sets up a per-thread 'VDSO' page and appropriate TLB support.
>>> Page is set write-protected from user and is maintained via kernel VA.
>>> MIPS FPU emulation is shifted to new page and stack is relieved for
>>> execute protection as is as all data pages in default setup during ELF
>>> binary initialization. The real protection is controlled by GLIBC and
>>> it can do stack protected now as it is done in other architectures and
>>> I learned today that GLIBC team is ready for this.
>>
>> What does it mean to be 'ready'?  If they committed patches before
>> there was kernel support, that it putting the cart before the horse.
>> GlibC's state cannot be used as valid reason for committing major
>> kernel changes.  There would be no regression in any GLibC based
>> system as a result of not merging this patch.
> Rich Fuhler said me that they discussed it internally and have a
> solution to fix their problem (ignoring PT_GNU_STACK on first library
> load - they need to sort out the logic). But we need to split both issue
> - right now stack can't be protected because of emulation. If they set
> stack protected then emulation fails on CPU without FPU.

Yes, we understand why non-executable stack is not compatible with the 
FPU emulator.

>
>>
>>>
>>> Note: actual execute-protection depends from HW capability, of course.
>>>
>>> This patch is required for MIPS32/64 R2 emulation on MIPS R6
>>> architecture.
>>> Without it 'ssh-keygen' crashes pretty fast on attempt to execute
>>> instruction
>>> in stack.
>>
>> There is much more blocking MIPS32/64 R2 emulation on MIPS R6 than
>> just this patch isn't there?
>
> This one is critical - ssh-keygen crashes during running MIPS R2. I have
> a patch in my R6 repository but GLIBC still can't set stack executable
> and security suffers.

But is the R6 code already in the lmo or kernel.org repositories?

If not, then the lack of this patch is not a gating issue.  If this 
patch is really needed for R6 support, why not submit the R6 
prerequisite patches first?

If this patch has nothing to do with MIPS R6, then state that.

>
>>
>> Also, if you are supporting MIPS R6, this patch doesn't even work,
>> because it doesn't handle PC relative instructions at all.
>
> It seems like you missed my statement - adding support for PC-relative
> instruction is just 5 lines of code. I just refrain from this until
> toolchain starts generating that.

How can it be just 5 lines of code?  You have to emulate all those 
instructions:

   ADDIUPC
   AUIPC
   ALUIPC
   LDPC
   LWPC
   LWUPC

I think that is all of them.  You can emulate all of those in 5 lines of 
code?

We need to support everything the toolchain could product in the future. 
  I don't think it makes sense to add all this stuff when it is well 
known that it doesn't solve the problem for MIPS R6, especially when the 
justification for the patch is that it is needed for R6.

I understand what your goals are here, I have spend many months working 
towards a non-executable stack (see the patches that moved the signal 
trampolines off the stack).  But I am worried that there are many cases 
that it will not handle.

>
> Besides that, this version 2 of patch just passed 20-22 hours on P5600
> and Virtuoso (no FPU on both) under SOAK test and it gets around 1 per
> hour of signal right at emulated instruction in VDSO and unwind works
> (as I can see in debug prints).
>

I'm not saying that the patch doesn't work under your highly constrained 
test conditions, I believe that it does.

I am not familiar with the SOAK test.  Does it really put faulting 
instructions the delay slots of FP branch instructions, catch the 
resulting signal, and then throw an exception from the signal handler?


>>
>>
>> The recent discussions on this subject, including many comments from
>> Imgtec e-mail addresses, brought to light the need to use an
>> instruction set emulator for newer MIPSr6 ISA processors.
>
> In Imgtec I am only one who works on MIPS R6 SW and FPU branch emulation
> and I say you - it is not needed, this solution is enough.

It can't be true the PC relative support is not needed, why did you add 
the PC relative instructions, if you didn't want to use them in Linux 
userspace?

Really what I was talking about was a wider audience, the people that 
will write tools and code that target userspace.  They will want a 
solution without a bunch of restrictions forced upon them by the 
limitations of the FPU emulator.

>
>>
>> In light of this, why does it make sense to merge this patch, instead
>> of taking the approach of emulating the instructions in the delay slot?
>
> Well, because it does exist now. But full MIPS emulator... for all
> ASEs... for any MIPS vendor... I even doesn't want to estimate an amount
> of time and code size to develop it.
>
> Besides that, you missed my another statement - we don't force customer
> to disclose all details of their COP2 instructions.

Here is my proposal:

1) Add an emulator for all documented MIPS R6 instructions that can 
appear in a linux userspace delay slot.

2) Document as not supported placing COP2 instructions in FP branch 
delay slots.

3) Get rid of this execute-out-of-line code in the FPU emulator all 
together.

4) Enable non-execute stack.

In order to have full MIPS R6 support in the kernel, you will need an 
emulator for a subset of the instructions anyhow.  Going to a full ISA 
emulator will be a little more work, but it shouldn't be too hard.


David Daney
