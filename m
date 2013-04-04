Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763031Ab3DDA4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:56:02 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36612 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762128Ab3DDA4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:56:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130403210019.GH5939@redhat.com>
References: <CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
	<20130402191130.GB31760@redhat.com>
	<CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
	<20130402201148.GJ29506@redhat.com>
	<CAE9FiQURMNjPYYze-tPn4Ssrc4TqMqTuvwRRhoVYEnGLF4Z0cQ@mail.gmail.com>
	<20130403131842.GA5939@redhat.com>
	<CAE9FiQUO-fLY-k_gmw6cg56YEN52VRvZuXr+f1EnywKr_cGc4Q@mail.gmail.com>
	<CAE9FiQXg2+DCd0BGRyKo4KWsMXdPZz74OjpQrUP=ciok2AZhuA@mail.gmail.com>
	<20130403174734.GG5939@redhat.com>
	<CAE9FiQU96BjThKbOGBhc6RHBey2+bvM6J6ZYaLb=xGuwahTuLQ@mail.gmail.com>
	<20130403210019.GH5939@redhat.com>
Date: Wed, 3 Apr 2013 17:56:00 -0700
X-Google-Sender-Auth: UoaqwuxzYDaN_vUdouF5plhYc_0
Message-ID: <CAE9FiQXnDu9R9YkTS9=726ztK049O=xfSgPhwTWxT+0xz3gnAA@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 2:00 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Apr 03, 2013 at 01:38:56PM -0700, Yinghai Lu wrote:
>> On Wed, Apr 3, 2013 at 10:47 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > So what I am saying that all our code is written assuming there is one
>> > single reserved range. Now if we need to reserve two ranges, then let
>> > us make it generic to suppoprt multiple ranges instead of hardcoding
>> > things and assume there can be 2 ranges. That will be a more generic
>> > solution.
>>
>> I don't think we have case that we need to support more than two ranges.
>>
>
> never say never.

One big rang under 4G is working well till second kernel need more than 512M
on bigger system with more memory.

Now we make the 64bit kernel/initrd etc could stay above 4G, we can have
enough range above 4G.

The only problem is during that second kernel running it need some ram
under 4G when iommu can not be used.

So have one big range above 4G, and a small range below 4g like 72M
is rational in a long run.

>
> One of the biggest problems is that we are trying to reserve all the
> memory at system bootup time using kernel command line.
>
> Why not reserve memory using some kernel interface after system has booted.
> That will make life much simpler.
>
> Reason being that currently we depend on one big single chunk being
> available in low memory area. And after boot there is no guarantee
> we will have that memory.
>
> But what if we just reserve enough memory for kernel and initramfs
> during boot and rest of the memory is reserved from user space. If
> system has more memory, there are high chances that after boot we will
> get memory immediately.

Allocate 72M continuous below 4G after system is booted up?

>
> What if we don't get a single range of memory, but multiple ranges,
> we should still be able to make use of all those ranges. And I think
> that is one possible area where multiple ranges could be useful.

swiotlb does not need continuous area?

>
> So yes, we don't have an immediate use case, but one can always pop
> up in future as we try to extend the functionality.

I don't think we need to extend it anymore with high/low two range support.

>
>
>> We only need to have one big range above 4G, and put second kernel and
>> initrd in it.
>> and another low one is only for switotlb or others that will be used by
>> second kernel.
>>
>> >
>> > So how about this.
>> >
>> > - In 3.9, just implement crashkernel=X;high. Don't auto reserve any low
>> >   memory. Support reservation of single range only. It could be either
>> >   high or low.
>> >
>> > - Those who are using iommu, they can use crashkernel=X;high. Old code
>> >   can continue to use crashkernel=X and get memory reserved in low
>> >   memory areas.
>>
>> That will not handle the case: big system that crashkernel=X;high
>> and kdump does not work with iommu.
>
> If we start supporting multiple ranges properly in 3.10, then it will.
> And we have never supported it so it is not a regression. Delaying a
> feature by a realease should be worth it in an attempt to do it
> properly.
>
>>
>> >
>> > - In 3.10 add a feature to support multiple crash reserved ranges.
>>
>> Again, we only need one high and one low range.
>> We don't need to support more than two ranges for crash kernel.
>
> For your current use case, you need one high and one low currently. But
> there can always be scenarios where multiple crash ranges are required,
> like reserving memory from user space.
>
> Anyway, if you are adamant on hardcoding this stuff, please don't
> use crashkernel= space. Continue to use crashkernel_high and/or
> crashkernel_low options. That way it allows us to extend crashkernel=
> in the form of crashkernel=X;<range-options>;<option2>;...
> and support multiple range feature properly down the line and not be
> bogged down with this new strange semantics.
>
> Also docuemnt very clearly that specifying crashkernel_high ignores
> any of the crashkernel= options.

will change back to crashkernel= override crashkernel_high.

>
> Also what happens to reserve memory release interface.  IIUC, there
> is no way to release crashkernel_low memory from user space and
> only memory reserved by crashkernel_high will be released?

can not decode.


>
> Seriously, why are you rushing with this high/low hardcoding. Why
> not wait for one more release and support multiple ranges properly
> both in kernel and kexec-tools.

As more then 2 range is not needed.
These four patches are complete solution.

Thanks

Yinghai
