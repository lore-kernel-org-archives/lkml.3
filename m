Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbaDXNio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:38:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56536 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbaDXNin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:38:43 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <535913E1.70509@roeck-us.net>
Date: Thu, 24 Apr 2014 06:38:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: monstr@monstr.eu
CC: linux-kernel@vger.kernel.org
Subject: Re: Microblaze image hanging in qemu with 3.15-rc
References: <20140422172356.GA15672@roeck-us.net> <53575074.6010602@monstr.eu> <5357C246.7050604@roeck-us.net> <5357CA6B.1070101@monstr.eu> <20140423154533.GA15644@roeck-us.net> <5358AC50.7020308@monstr.eu>
In-Reply-To: <5358AC50.7020308@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 11:16 PM, Michal Simek wrote:
> On 04/23/2014 05:45 PM, Guenter Roeck wrote:
>> On Wed, Apr 23, 2014 at 04:12:59PM +0200, Michal Simek wrote:
>>> On 04/23/2014 03:38 PM, Guenter Roeck wrote:
>>>> On 04/22/2014 10:32 PM, Michal Simek wrote:
>>>>> Hi Guenter,
>>>>>
>>>>>
>>>>> On 04/22/2014 07:23 PM, Guenter Roeck wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> when trying to run a microblaze image with 3.15-rc1 or 3.15-rc2 in qemu,
>>>>>> I get the following hangup. This used to work with earlier kernels
>>>>>> with the same configuration.
>>>>>>
>>>>>> Is this a known problem, or is something wrong with my configuration
>>>>>> or with my qemu command line ?
>>>>>
>>>>> Is this BE/LE version? Which qemu do you use?
>>>>
>>>> BE.
>>>>
>>>> file vmlinux:
>>>>
>>>> vmlinux: ELF 32-bit MSB  executable, version 1 (SYSV), statically linked, BuildID[sha1]=5e1872c08df2956eddaed6fc1f6528a8540375b7, not stripped
>>>>
>>>> qemu-system-microblaze --version:
>>>>
>>>> QEMU emulator version 1.7.0, Copyright (c) 2003-2008 Fabrice Bellard
>>>>
>>>> gcc --version:
>>>>
>>>> microblaze-linux-gcc (GCC) 4.8.0
>>>> Copyright (C) 2013 Free Software Foundation, Inc.
>>>> This is free software; see the source for copying conditions.  There is NO
>>>> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>>>>
>>>>> There is endian autodetection in timer and intc driver
>>>>> which can caused this problem.
>>>>>
>>>> Is this new code ? I didn't see the problem in 3.13 (same compile options,
>>>> same configuration, same compiler, same qemu version).
>>>
>>> yes it was added to 3.15-rc1.
>>>
>>> Try to rever this one
>>> a66a626 microblaze: Use asm-generic/io.h
>>>
>>> but the problem is probably here because you are not getting proper
>>> reaction from qemu model.
>>> a1715bb microblaze: Make timer driver endian aware
>>> 1aa1243 microblaze: Make intc driver endian aware
>>>
>>> I have tested it on the latest petalinux qemu and there shouldn't be
>>> any problem.
>>>
>> Hi Michal,
>>
>> qemu 2.0.0 still has the problem. Bisect points to
>>
>> commit a66a626538af65cbfc611e2b2fce500ed3f24518
>> Author: Michal Simek <michal.simek@xilinx.com>
>> Date:   Thu Feb 7 15:12:24 2013 +0100
>>
>>      microblaze: Use asm-generic/io.h
>>
>> as the culprit, so you were right on the money. Reverting this commit
>> fixes the problem.
>
> yep. But it is just side effect of previous two commits I have mentioned.
> Can you just please check if you are setting up correct IO functions?
>
> 	write_fn = timer_write32;
> 	read_fn = timer_read32;
>
> 	write_fn(TCSR_MDT, timer_baseaddr + TCSR0);
> 	if (!(read_fn(timer_baseaddr + TCSR0) & TCSR_MDT)) {
> 		write_fn = timer_write32_be;
> 		read_fn = timer_read32_be;
> 	}
> git
>

The read returns 0x1, so the access functions are not updated. If I change the code
to force the update to the _be versions, the calibration loop still hangs (obviously,
because then the result is 0x01000000, which is really wrong).

>> Assuming this is in fact a problem with qemu, can you point me to a set
>> of qemu patches necessary to fix it ? Also, do you know if there are plans
>> to send the patches upstream ? I don't find anything related in the qemu
>> repository (though of course I may have missed it).
>
> Yes, it should be qemu issue. I am not aware about particular qemu patches
> but you can try to use https://github.com/Xilinx/qemu
> but now sure if Peter updating this repository.
>
Last commit in that repository is from a year ago, so it looks like he doesn't
update it.

> Anyway if you look at code above and I expect that the problem is just
> that autodetection is broken in your qemu it should be pretty simple
> to fix it.
>
Not sure I understand what you'd expect qemu to return in this case,
and why it worked previously. Any idea ?

Thanks,
Guenter

