Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaJFWBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 18:01:24 -0400
Received: from mail-bn1on0084.outbound.protection.outlook.com ([157.56.110.84]:56224
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751011AbaJFWBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 18:01:23 -0400
Message-ID: <54330D79.80102@caviumnetworks.com>
Date: Mon, 6 Oct 2014 14:45:29 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rich Felker <dalias@libc.org>
CC: David Daney <ddaney.cavm@gmail.com>, <libc-alpha@sourceware.org>,
        <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com> <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com> <20141006213101.GA23797@brightrain.aerifal.cx>
In-Reply-To: <20141006213101.GA23797@brightrain.aerifal.cx>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-ClientProxiedBy: BY2PR07CA019.namprd07.prod.outlook.com (10.255.247.44) To
 BLUPR07MB579.namprd07.prod.outlook.com (10.141.206.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR07MB579;
X-Forefront-PRVS: 03569407CC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(199003)(51704005)(377454003)(189002)(479174003)(21056001)(36756003)(50986999)(31966008)(92566001)(80022003)(76482002)(99396003)(76176999)(101416001)(120916001)(40100002)(85852003)(92726001)(10300001)(19580395003)(69596002)(105586002)(87976001)(50466002)(85306004)(20776003)(64706001)(93886004)(47776003)(122386002)(95666004)(106356001)(81156004)(102836001)(23756003)(65816999)(66066001)(4396001)(65956001)(54356999)(97736003)(53416004)(46102003)(107046002)(83506001)(110136001)(42186005)(33656002)(77096002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR07MB579;H:dl.caveonetworks.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 02:31 PM, Rich Felker wrote:
> On Mon, Oct 06, 2014 at 02:18:19PM -0700, David Daney wrote:
>>> Userspace should play no part in this; requiring userspace to help
>>> make special accomodations for fpu emulation largely defeats the
>>> purpose of fpu emulation.
>>
>> That is certainly one way of looking at it.  Really it is opinion,
>> rather than fact though.
>
> It's an opinion, yes, but it has substantial reason behind it.
>
>> GLibc is full of code (see ld.so) that in earlier incantations of
>> Unix/Linux was in kernel space, and was moved to userspace.  Given
>> that there is a partitioning of code between kernel space and
>> userspace, I think it not totally unreasonable to consider doing
>> some of this in userspace.
>>
>> Even on systems with hardware FPU, the architecture specification
>> allows for/requires emulation of certain cases (denormals, etc.)  So
>> it is already a requirement that userspace cooperate by always
>> having free space below $SP for use by the kernel.  So the current
>> situation is that userspace is providing services for the kernel FPU
>> emulator.
>>
>> My suggestion is to change the nature of the way these services are
>> provided by the userspace program.
>
> But this isn't setup by the userspace program. It's setup by the
> kernel on program entry. Despite that, though, I think it's an
> unnecessary (and undocumented!) constraint; the fact that it requires
> the stack to be executable makes it even more harmful and
> inappropriate.
>

The management of the stack is absolutely done by userspace code.  Any 
time you do pthread_create(), userspace code does mmap() to allocate the 
stack area, it then sets permissions on the area, and then it passes the 
address of the area to clone().  Furthermore the userspace code has to 
be very careful in its use of the $sp register, so that it doesn't store 
data in places that will be used/clobbered by the kernel.

All of this is under the control of the userspace program and done with 
userspace code.

I appreciate the fact that libc authors might prefer *not* to write more 
code, but they could, especially if they wanted to add the feature of 
non-executable stacks to their library implementation.

David Daney

