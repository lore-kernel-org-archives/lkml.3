Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab3JSFpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 01:45:45 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59893 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3JSFpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 01:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <20131018123837.GB2277@redhat.com>
References: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
	<CAE9FiQUNMDuVZtqud3LBbAmE0SL8ZWLFnc+CSYZm4UfTvNUaOA@mail.gmail.com>
	<20131015144810.GI31215@redhat.com>
	<CAE9FiQXVCx__SuhAdO9_CNaRncW2HB2tv3UjZrQcbsTV35QWow@mail.gmail.com>
	<20131018123837.GB2277@redhat.com>
Date: Fri, 18 Oct 2013 22:45:43 -0700
X-Google-Sender-Auth: BcMd8SQl63bRCMf6F6Jgkv8YKkE
Message-ID: <CAE9FiQWdMmSseDk6J=TOXT9ZahJUBf2BOU+VHJRXeeMofgH=EQ@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: crashkernel=X try to reserve below 896M
 first, then try below 4G, then MAXMEM
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 5:38 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Oct 17, 2013 at 08:50:07PM -0700, Yinghai Lu wrote:
>
> [..]
>> > Previously high reservation (reservation above 896M) will anyway fail. So
>> > instead of failing, if we try reservation in higher memory areas why that
>> > would break old kexec-tools?
>>
>> If thel old kexec-tools would fail, we should let them fail early as possible,
>> do not reserve at first point.
>
> A user does not care if they get the message "memory nor reserved" or if
> they get the message that "could not find a suitable memory hole at
> address X".

you are asking for trouble.

Now we have two paths:
1. old kernel with old kexec tools. crashkernel=XM, work,
the new kernel with old kexec tools still working with crashkernel=XM
2. old kernel with old kernel tools, crashkernel=XM, not working.
as X is too big.
then user update to new kernel AND new kexec-tools, and crashkernel=XM,high

with this patch, you will need to test new kernel all old kexec tools
to make sure
it will fail later instead of fail early to remind them to update kexec tools.
Also would make user to guess and try to make new kernel to work with old
kexec-tools

>
>>
>> >
>> > IOW, previously anyway kexec-tools will not work as no memory will be
>> > reserved in higher memory area. Now memory will be reserved but old
>> > kexec-tools should fail as it can't load in that area.
>> >
>> > If that works, then one would use crashkernel=X,high only if he is
>> > particualr that memory reservation comes from area above 4G (despite
>> > the fact that same memory could have been reserved below 4G too).
>>
>> My point:
>> Push user to use ",high" as more as possible, so we only to handle one
>> path eventually.
>> for old kernel, leave them to use old grammer. do not need to change it.
>
> I don't understand this. Why we should push users to use ",high" syntax.
> That is an option. Those who want to use it, should use it.
>
> We have been using crashkernel=XM for a long time now. And it makes sense
> to extend this option to be able to reserve memory at higher addresses
> if asked memory is not available at lower addresses.
>
> You are not thinking about ease of use here for existing users.

most existing user don't need to do anything. just with new kernel and
old kexec tools.

those system that did not work kexec before because XM is too big, they have to
update kexec tools, and use ",high"

Make it simple, less error.

>
>>
>> Also boot loader should always have different entry for old kernel and
>> new kernel.
>
> What does memory reservation location has to do with kernel entry point?
> If it is a 64bit bzImage, we will use 64bit entry point by default, isn't
> it? Does not matter whether memory is reserved above 4G or not.
>
> I think it makes sense that existing crashkernel=XM usres be able to
> reserve memory in higher memory area if sufficient memory is not available
> below 896M or below 4G. Those who always want memory reservation above 4G
> they should use ",high" syntax and enforce memory allocation above 4G.

We already support above 4G, what is point for trying below 4G?

You could get more bug report about new kernel with old kexec-tools, as
old kexec-tools could work with range between 896M and 4G in some case,
but not all.

Thanks

Yinghai
