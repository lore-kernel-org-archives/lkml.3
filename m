Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab3D2WQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:16:45 -0400
Received: from mx3.valvesoftware.com ([208.64.203.145]:49584 "EHLO
	mx3.valvesoftware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760118Ab3D2WQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:16:41 -0400
X-Greylist: delayed 1260 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 18:16:41 EDT
Message-ID: <517EEBD1.503@valvesoftware.com>
Date: Mon, 29 Apr 2013 14:53:21 -0700
From: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Rik van Riel <riel@redhat.com>, <linux-kernel@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <sonnyrao@chromium.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <akpm@linux-foundation.org>
Subject: Re: IO regression after ab8fabd46f on x86 kernels with high memory
References: <517B1153.8000401@valvesoftware.com> <517B2FB4.30605@redhat.com> <20130427024248.GA1229@cmpxchg.org>
In-Reply-To: <20130427024248.GA1229@cmpxchg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: 86b76815-e903-4403-b95d-5abb05264373
X-Mlf-Version: 7.3.6.7163
X-Mlf-UniqueId: o201304292155360086151
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2013 07:42 PM, Johannes Weiner wrote:
> On Fri, Apr 26, 2013 at 09:53:56PM -0400, Rik van Riel wrote:
>> On 04/26/2013 07:44 PM, Pierre-Loup A. Griffais wrote:
>>> I initially observed this between kernels 3.2 and 3.5: on 3.2, copying a
>>> 180M shared object on the same ext4 filesystem takes 0.6s. On 3.5, it
>>> takes between two and three minutes. It looks like a similar throughput
>>> regression happens on any machine running an i386 PAE kernel with high
>>> amounts of memory; the threshold seems to be 16G; passing mem=15G to the
>>> kernel commandline fixes it.
>>
>> If you have that much memory in the system, you will
>> want to run a 64 bit kernel to avoid all kinds of
>> memory management corner cases.
>
> Agreed.  You can even keep your 32 bit userland, just swap the
> kernel...
>
>>> I bisected it to the following change:
>>>
>>> commit ab8fabd46f811d5153d8a0cd2fac9a0d41fb593d
>>> Author: Johannes Weiner <jweiner@redhat.com>
>>> Date:   Tue Jan 10 15:07:42 2012 -0800
>>>
>>>      mm: exclude reserved pages from dirtyable memory
>>>
>>> I realize running x86 kernels against high amounts of memory is not
>>> advised for various reasons, but I would assume that such a big
>>> regression in basic functionality to not be part of them. Is that
>>> accurate, or are these configurations expected to become unusable from
>>> 3.3 onwards?
>>
>> Reverting that patch would probably break i686 PAE systems with
>> lots of memory at a different threshold.
>
> It would also re-introduce the reclaim stalls when zones with very
> little page cache due to lowmem reserves end up with a large
> percentage of their LRU dirty.  And that affects modern machines too,
> because of the lowmem reserves in DMA32 due to relatively bigger
> Normal zones.
>
> On such large highmem machines, however, the imbalance between highmem
> and lowmem is so enormous that the lowmem reserves basically exclude
> all of lowmem from page cache usage.
>
> But because dirty highmem creates lowmem pressure, and the amount of
> sanely allowable dirty memory is actually a function of lowmem, not
> highmem, highmem is not included in the amount of dirtyable memory.
>
> So because your lowmem is not available for page cache and highmem is
> not considered dirtyable out of the box, the amount of dirtyable
> memory on your machine is 0.  You can workaround this by setting
> vm.highmem_is_dirtyable=1.

I understand the technical concerns; we had some existing issues on 3.2 
with 24/32GB machines where the kernel would start erroneously 
OOM-killing new processes after a while; booting with mem=16G solved 
that. But now this goes a level further, since the machine is unusable 
upfront, right at boot, even with mem=16G. As such this is clearly seems 
like a regression more than a tradeoff.

We're in a situation where popular distros ship 32-bit as the default 
"use this if you're not sure what to get" option, with PAE also enabled 
by default. most modern computers shipping with more than 16G of RAM, 
especially for gaming. Looking at the Steam HW survey data we have 
hundreds of users using this combination; this commit means that 
installing package updates that pull in a new kernel will immediately 
cause their system to become unusable.

Other than this particular concern, what's the high-level take-away? Is 
PAE support in the Linux kernel a false promise than distros should not 
be shipping by default, if at all? Should it be removed from the kernel 
entirely if these configurations are knowingly broken by commits like this?

Thanks,
  - Pierre-Loup


