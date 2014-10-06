Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaJFVxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:53:14 -0400
Received: from mail-bn1on0081.outbound.protection.outlook.com ([157.56.110.81]:54004
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752419AbaJFVxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:53:11 -0400
X-Greylist: delayed 1126 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2014 17:53:10 EDT
Message-ID: <5433071B.4050606@caviumnetworks.com>
Date: Mon, 6 Oct 2014 14:18:19 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rich Felker <dalias@libc.org>
CC: David Daney <ddaney.cavm@gmail.com>, <libc-alpha@sourceware.org>,
        <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com> <20141006205459.GZ23797@brightrain.aerifal.cx>
In-Reply-To: <20141006205459.GZ23797@brightrain.aerifal.cx>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-ClientProxiedBy: BY2PR07CA053.namprd07.prod.outlook.com (10.141.251.28) To
 BY2PR07MB583.namprd07.prod.outlook.com (10.141.221.155)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR07MB583;
X-Forefront-PRVS: 03569407CC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(51704005)(377454003)(479174003)(189002)(24454002)(87266999)(76176999)(87976001)(21056001)(54356999)(81156004)(95666004)(65816999)(50986999)(120916001)(10300001)(33656002)(102836001)(110136001)(65956001)(99396003)(64706001)(66066001)(47776003)(85852003)(122386002)(76482002)(20776003)(105586002)(106356001)(40100001)(99136001)(36756003)(19580405001)(69596002)(19580395003)(80316001)(92726001)(92566001)(107046002)(83506001)(101416001)(23756003)(77096002)(31966008)(53416004)(4396001)(42186005)(97736003)(85306004)(50466002)(59896002)(46102003)(80022003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR07MB583;H:dl.caveonetworks.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 01:54 PM, Rich Felker wrote:
> On Mon, Oct 06, 2014 at 01:23:30PM -0700, David Daney wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> In order for MIPS to be able to support a non-executable stack, we
>> need to supply a method to specify a userspace area that can be used
>> for executing emulated branch delay slot instructions.
>>
>> We add a new system call, sys_set_fpuemul_xol_area so that userspace
>> threads that are using the FPU can specify the location of the FPU
>> emulation out of line execution area.
>>
>> Background:
>>
>> MIPS floating point support requires that any instruction that cannot
>> be directly executed by the FPU, be emulated by the kernel.  Part of
>> this emulation involves executing non-FPU instructions that fall in
>> the delay slots of FP branch instructions.  Since the beginning of
>> MIPS/Linux time, this has been done by placing the instructions on the
>> userspace thread stack, and executing them there, as the instructions
>> must be executed in the MM context of the thread receiving the
>> emulation.
>>
>> Because of this, the de facto MIPS Linux userspace ABI requires that
>> the userspace thread have an executable stack.  It is de facto,
>> because it is not written anywhere that this must be the case, but it
>> is never the less a requirement.
>>
>> Problem:
>>
>> How do we get MIPS Linux to use a non-executable stack in the face of
>> the FPU emulation problem?
>>
>> Since userspace desires to change the ABI, put some of the onus on the
>> userspace code.  Any userspace thread desiring a non-executable stack,
>> must allocate a 4-byte aligned area at least 8 bytes long with that
>> has read/write/execute permissions and pass the address of that area
>> to the kernel with the new sys_set_fpuemul_xol_area system call.
>>
>> This is similar to how we require userspace to notify the kernel of
>> the value of the thread local pointer.
>
> Userspace should play no part in this; requiring userspace to help
> make special accomodations for fpu emulation largely defeats the
> purpose of fpu emulation.

That is certainly one way of looking at it.  Really it is opinion, 
rather than fact though.

GLibc is full of code (see ld.so) that in earlier incantations of 
Unix/Linux was in kernel space, and was moved to userspace.  Given that 
there is a partitioning of code between kernel space and userspace, I 
think it not totally unreasonable to consider doing some of this in 
userspace.

Even on systems with hardware FPU, the architecture specification allows 
for/requires emulation of certain cases (denormals, etc.)  So it is 
already a requirement that userspace cooperate by always having free 
space below $SP for use by the kernel.  So the current situation is that 
userspace is providing services for the kernel FPU emulator.

My suggestion is to change the nature of the way these services are 
provided by the userspace program.

> The kernel is perfectly capable of mapping
> an appropriate page. The mapping should happen at exec time,  and at
> clone time with CLONE_VM

Why?  This adds overhead for threads that don't use the FPU.  So this 
suggestion adds at least one page of memory overhead for each thread in 
the system (unless I misunderstand what you are saying).

> unless the kernel is going to handle mutual
> exclusion so that only one thread can be using the page at a time.
> (Using one page for the whole process, and excluding simultaneous
> execution of fpu emulation in multiple threads, may be the more
> practical approach.)
>
> As an alternative, if the space of possible instruction with a delay
> slot is sufficiently small, all such instructions could be mapped as
> immutable code in a shared mapping, each at a fixed offset in the
> mapping. I suspect this would be borderline-impractical (multiple
> megabytes?), but it is the cleanest solution otherwise.
>

Yes, there are 2^32 possible instructions.  Each one is 4 bytes, plus 
you need a way to exit after the instruction has executed, which would 
require another instruction.  So you would need 32GB of memory to hold 
all those instructions, larger than the 32-bit virtual address space.

> Rich
>

