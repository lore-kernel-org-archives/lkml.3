Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaJFWRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 18:17:11 -0400
Received: from mail-by2on0062.outbound.protection.outlook.com ([207.46.100.62]:53033
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751712AbaJFWRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 18:17:08 -0400
X-Greylist: delayed 3522 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2014 18:17:08 EDT
Message-ID: <543314DF.20808@caviumnetworks.com>
Date: Mon, 6 Oct 2014 15:17:03 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rich Felker <dalias@libc.org>
CC: David Daney <ddaney.cavm@gmail.com>, <libc-alpha@sourceware.org>,
        <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com> <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com> <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com> <20141006215813.GB23797@brightrain.aerifal.cx>
In-Reply-To: <20141006215813.GB23797@brightrain.aerifal.cx>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-ClientProxiedBy: BY2PR07CA021.namprd07.prod.outlook.com (10.255.247.46) To
 BY2PR07MB584.namprd07.prod.outlook.com (10.141.221.156)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR07MB584;
X-Forefront-PRVS: 03569407CC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(189002)(479174003)(377454003)(199003)(24454002)(77096002)(53416004)(110136001)(20776003)(47776003)(21056001)(64706001)(97736003)(42186005)(23756003)(31966008)(65816999)(76176999)(54356999)(50986999)(80022003)(87976001)(85852003)(46102003)(65956001)(92566001)(101416001)(122386002)(19580395003)(69596002)(120916001)(83506001)(36756003)(81156004)(561944003)(33656002)(102836001)(4396001)(105586002)(106356001)(10300001)(66066001)(92726001)(99396003)(107046002)(76482002)(85306004)(95666004)(93886004)(50466002)(40100002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR07MB584;H:dl.caveonetworks.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 02:58 PM, Rich Felker wrote:
> On Mon, Oct 06, 2014 at 02:45:29PM -0700, David Daney wrote:
>> On 10/06/2014 02:31 PM, Rich Felker wrote:
>>> On Mon, Oct 06, 2014 at 02:18:19PM -0700, David Daney wrote:
>>>>> Userspace should play no part in this; requiring userspace to help
>>>>> make special accomodations for fpu emulation largely defeats the
>>>>> purpose of fpu emulation.
>>>>
>>>> That is certainly one way of looking at it.  Really it is opinion,
>>>> rather than fact though.
>>>
>>> It's an opinion, yes, but it has substantial reason behind it.
>>>
>>>> GLibc is full of code (see ld.so) that in earlier incantations of
>>>> Unix/Linux was in kernel space, and was moved to userspace.  Given
>>>> that there is a partitioning of code between kernel space and
>>>> userspace, I think it not totally unreasonable to consider doing
>>>> some of this in userspace.
>>>>
>>>> Even on systems with hardware FPU, the architecture specification
>>>> allows for/requires emulation of certain cases (denormals, etc.)  So
>>>> it is already a requirement that userspace cooperate by always
>>>> having free space below $SP for use by the kernel.  So the current
>>>> situation is that userspace is providing services for the kernel FPU
>>>> emulator.
>>>>
>>>> My suggestion is to change the nature of the way these services are
>>>> provided by the userspace program.
>>>
>>> But this isn't setup by the userspace program. It's setup by the
>>> kernel on program entry. Despite that, though, I think it's an
>>> unnecessary (and undocumented!) constraint; the fact that it requires
>>> the stack to be executable makes it even more harmful and
>>> inappropriate.
>>>
>>
>> The management of the stack is absolutely done by userspace code.
>> Any time you do pthread_create(), userspace code does mmap() to
>> allocate the stack area, it then sets permissions on the area, and
>> then it passes the address of the area to clone().
>
> This is hardly management.
>
>> Furthermore the
>> userspace code has to be very careful in its use of the $sp
>> register, so that it doesn't store data in places that will be
>> used/clobbered by the kernel.
>
> This is not "being careful". The stack pointer can never become
> invalid unless you do wacky things in asm or invoke UB.
>
>> All of this is under the control of the userspace program and done
>> with userspace code.
>
> For the most part it just happens by default. There is no particular
> intentionality needed, and certainly no hideous MIPS-specific hacks
> needed.
>

Yes, it happens by default.  But it wasn't magic.  It took careful work 
by the ABI and toolchain designers to make it work.


>> I appreciate the fact that libc authors might prefer *not* to write
>> more code, but they could, especially if they wanted to add the
>> feature of non-executable stacks to their library implementation.
>
> So your position is that:

It is not really a position that I have.  Rather a proposal for one 
possible way to make non-executable stacks work on MIPS.

>
> 1. A non-exec-stack system can only run new code produced to do extra
>     stuff in userspace.

Any non-executable stack solution for MIPS will require changes to the 
toolchain/libc.  So it is merely a question of what form the change 
should take.


>
> 2. The startup code needs to do special work in userspace on MIPS to
>     setup an executable area for fpu emulation.

Yes. Similar to how startup code has to do special work to set up the 
TLS areas, and load shared libraries.

>
> 3. Every call to clone/CLONE_VM needs to be accompanied by a call to
>     mmap and this new syscall to set the address, and every call to
>     SYS_exit needs to be accompanies by a call to munmap for the
>     corresponding mapping.
>

No, We don't have to mmap() on each thread creation.  Many threads 
(perhaps 512) could be handled by a single page, so the normal case 
would be a single mmap() for the life of the program.


> This is a huge ill-designed mess.
>

Have you seen the alternatives?

Have you ever wondered why MIPS doesn't have non-executable stack support?

> Rich
>

