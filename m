Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaKDHaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:30:22 -0500
Received: from numascale.com ([213.162.240.84]:44821 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaKDHaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:30:18 -0500
Message-ID: <5458807E.80701@numascale.com>
Date: Tue, 04 Nov 2014 15:30:06 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH v3 5/5] Use 2GB memory block size on large x86-64 systems
References: <1414915813-2462-1-git-send-email-daniel@numascale.com> <1414915813-2462-5-git-send-email-daniel@numascale.com> <alpine.DEB.2.11.1411032021331.5308@nanos> <54580C9E.7070706@numascale.com> <alpine.DEB.2.11.1411040033530.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1411040033530.5308@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 07:36 AM, Thomas Gleixner wrote:
> On Tue, 4 Nov 2014, Daniel J Blueman wrote:
>
>> On 11/04/2014 03:38 AM, Thomas Gleixner wrote:
>>> On Sun, 2 Nov 2014, Daniel J Blueman wrote:
>>>
>>>> On larger x64-64 systems, use a 2GB memory block size to reduce sysfs
>>>> entry creation time by 16x. Large is defined as 64GB or more memory.
>>>
>>> This changelog sucks.
>>>
>>> It neither tells which sysfs entries are meant nor does it explain
>>> what the actual effect of this change is aside of speeding up some
>>> random sysfs thingy.
>>
>> How about this?
>>
>> On large-memory systems of 64GB or more with memory hot-plug enabled, use a
>> 2GB memory block size. Eg with 64GB memory, this reduces the number of
>> directories in /sys/devices/system/memory from 512 to 32, making it more
>> manageable, and reducing the creation time accordingly.
>
> It still does not tell what the downside is of this and why you think
> it does not matter.

Yes, let's make it explicit:

On large-memory systems of 64GB or more with memory hot-plug enabled, 
use a 2GB memory block size. Eg with 64GB memory, this reduces the 
number of directories in /sys/devices/system/memory from 512 to 32, 
making it more manageable, and reducing the creation time accordingly.

This caveat is that the memory can't be offlined (for hotplug or 
otherwise) with finer 128MB granularity, but this is unimportant due to 
the high memory densities generally used with such large-memory systems, 
where eg a single DIMM is the order of 16GB.

>>>> @@ -1247,9 +1246,9 @@ static unsigned long probe_memory_block_size(void)
>>>>    	/* start from 2g */
>>>>    	unsigned long bz = 1UL<<31;
>>>>
>>>> -#ifdef CONFIG_X86_UV
>>>> -	if (is_uv_system()) {
>>>> -		printk(KERN_INFO "UV: memory block size 2GB\n");
>>>> +#ifdef CONFIG_X86_64
>>>
>>> And this brainless 's/CONFIG_X86_UV/CONFIG_X86_64/' sucks even
>>> more. I'm sure you can figure out the WHY yourself.
>>
>> The benefit of this is applicable to other architectures. I'm unable to test
>> the change, but if you agree it's conservative enough, I'll drop the ifdef?
>
> Which other architectures? Care to turn on your brain before replying?

Clearly 64-bit architectures, including X86, MIPS, PARISC, SPARC, 
AArch64, ia64, however, I must be missing something, as a 
sizeof(long)/CONFIG_64BIT check would be redundant if we agree to drop 
the ifdef, as we're already checking the number of physical pages, which 
is bounded by the same limits.

Thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
