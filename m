Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab3LWEt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 23:49:27 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:45812 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab3LWEt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 23:49:26 -0500
Message-ID: <52B7C0CF.4030209@landley.net>
Date: Sun, 22 Dec 2013 22:49:19 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>
CC: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, sebastian.capella@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use initmpfs even if there's root= cmdline
References: <20131212092542.GA14218@dhcp-16-126.nay.redhat.com> <20131213023814.GA5519@dhcp-16-126.nay.redhat.com> <52B1E0A2.2030202@landley.net> <20131219023524.GB2070@darkstar.nay.redhat.com>
In-Reply-To: <20131219023524.GB2070@darkstar.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/13 20:35, Dave Young wrote:
> On Wed, Dec 18, 2013 at 11:51:30AM -0600, Rob Landley wrote:
>>
>>
>> On 12/12/13 20:38, Dave Young wrote:
>>> On 12/12/13 at 05:25pm, Dave Young wrote:
>>>>
>>>> Current code use ramfs instead of tmpfs for stub when root= defined.
>>>>
>>>> But for real use case with initramfs, usually there's like cmdline like
>>>> root=UUID=$UUID the root dev is the real device. For that case we have
>>>> no way to use initmpfs, thus this patch removes the limitation so tmpfs
>>>> can benefit more people.
>>
>> The reason I did that was if you specify a root= then you don't want
>> to _stay_ on rootfs. You specify root= so either the kernel does
>> switch_root for you, or so rootfs does a swich_root at the end.
>>
>> The point of initmpfs is that when rootfs _is_ the "real" root
>> device, it can benefit from being tmpfs. When you're just goign to
>> switch to a different root device, tmpfs doesn't make much
>> difference.
>
> The reason make sense to most of users. Thanks for the info.
> For Fedora kdump initramfs there's different requirement though, we do the
> vmcore capturing in ramfs with root=, the root= is not necessay in most of
> the cases because we will reboot immediately after vmcore capturing finish.
> There's one potential exception is that we could switch to real root in
> case of capturing failure. Another thing is we use dracut to create initramfs
> and dracut has a limitation that root= is a must-have param.

Interesting use case.

I can't do anything about dracut. (Otherwise userspace could look at 
ROOT= which is not parsed by existing kernel code to have a special 
meaning...)

>>> Discussed with Vivek Goyal about the kdump use case, I missed one thing that
>>> tmpfs has default size limit though we can tune it.
>>>
>>> So I will think more about it, will address this later, please ignore this
>>> patch.
>>
>> I have a vague todo item of feeding rootflags= through to initmpfs,
>> but that's really intended to specify flags for root=. There isn't
>> really an existing command line option to specify initramfs flags
>> because ramfs doesn't care.
>>
>> It was one of those "only parse rootflags= for initmpfs when there's
>> no root=" vs "create a new rdrootflags= ala rdinit= even though
>> that's a subtly wrong name these days..." and it went on the todo
>> list because neither approach was obviously superior.
>>
>> Happy to take suggestions and whip up a patch if this is
>> inconveniencing somebody. :)
>
> It would be great that initmpfs can use the whole memory on demand by default at
> the same time we can avoid the deadlock mentioned about OOM handler.

Except that if initmpfs size=100% uses all the memory, we're back to 
"fill up the filesystem and the kernel deadlocks" same as initramfs.

Possibly I could tell it to go to 100% during extract and then remount 
to 50% afterwards? (The cpio archive filling up memory is pilot error. I 
wonder what happens if tmpfs is told to remount using less space than 
the filesystem currently has, does it fail or does it adjust the amount 
to what's currently used, or...?)

If necessary I could query the filesystem size after extract and remount 
to that amount or 50% (whichever is greater), but this is getting more 
complicated than seems strictly necessary? (If rootflags= got passed 
through we'd then want to only do this if they _didn't_ specify a size, 
or else have the "actual size or size= the user passed"...)

Implementing behavior is easy. Determing what the correct behavior 
should be is hard.

> For this purpose no need for extra flags? For other flags maybe "initmpfsflags="?

You can already say rootfstype=ramfs if you want to drop back to a 
filesystem that doesn't care about size checks. I could trivially make 
it so rootfstype=tmpfs overrides the root= check, but then there's that 
50% memory limitation on the filesystem size. (Beyond which the disk 
cache reaping logic gets VERY UNHAPPY, by the way. The automatic load 
balancing stuff is... touchy. Better now than it used to be, but I still 
trust it about as far as I could comfortably spit out a rat. Then again 
I'm generally not using systems with half a terabyte of ram, which is 
what they all seem to be optimizing for these days...)

Adding initrdflags= to specify a size= other than 50% makes sense, but 
you might have to modify your dracut thing to do a du on the filesystem 
before packaging it and feed in the correct number of kilobytes.

If you want a different behavior than that, please explain what it 
should do in a little more detail?

> Thanks
> Dave

Rob
