Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab3JYFsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 01:48:31 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59328 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3JYFsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 01:48:30 -0400
MIME-Version: 1.0
In-Reply-To: <20131024192752.GG2322@redhat.com>
References: <20131015144810.GI31215@redhat.com>
	<CAE9FiQXVCx__SuhAdO9_CNaRncW2HB2tv3UjZrQcbsTV35QWow@mail.gmail.com>
	<20131018123837.GB2277@redhat.com>
	<CAE9FiQWdMmSseDk6J=TOXT9ZahJUBf2BOU+VHJRXeeMofgH=EQ@mail.gmail.com>
	<20131021151643.GA20669@redhat.com>
	<CAE9FiQVfeUdugFRMt1DGjtqW2FAb2gfnGjXENHjoJ=JVAYbYgw@mail.gmail.com>
	<20131024140241.GA2322@redhat.com>
	<CAE9FiQUu0WwMgNpog4TKch+MT2i7_DsNvqZxbyQusS4AFxdhQQ@mail.gmail.com>
	<20131024191821.GE2322@redhat.com>
	<CAE9FiQU7+FRY=3ETdGZJJfcS0vjRht4ZT8MHTQ66kpjD2MmrcA@mail.gmail.com>
	<20131024192752.GG2322@redhat.com>
Date: Thu, 24 Oct 2013 22:48:29 -0700
X-Google-Sender-Auth: K7DhOsR87K-eFWj-Bu7aY2jEbe0
Message-ID: <CAE9FiQUw6REg2TXnSXtNZK8XY9vnorvi8oDbUn_5WdNZ6yiRtQ@mail.gmail.com>
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

On Thu, Oct 24, 2013 at 12:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Oct 24, 2013 at 12:24:57PM -0700, Yinghai Lu wrote:
>> On Thu, Oct 24, 2013 at 12:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Thu, Oct 24, 2013 at 12:15:25PM -0700, Yinghai Lu wrote:
>> >
>> > Also keeping things simple by not trying to *impose* a new crashkernel=
>> > syntax on existing crashkernel=xM users.
>>
>> Existing user that have crashkernel=xM working with their old kernel
>> and old kexec-tools, they still could keep their old command line and
>> old kexec-tools
>> with new updated kernel.
>> We should not change semantics to surprise them.
>
> Old users will get reservation still below 896MB.
>
> It will go above 896MB only if memory could not be allocated below 896MB.
>
> In the past reservation will fail and kexec-tools will fail.
> Now reservation will succeed but kexec-tools will fail.
>
> So end result a user sees is that kexec-tools fails. So I don't see how
> we are breaking existing installations or user setups.

case could be: if user add more memory and put more pcie cards, and
second kernel will need more ram and OOM there.
so user could just increase crashkernel=512M to crashkernel=1G.

without Cong's patch, kernel will fail to reserve, and user would dig
to change it
to crashkernel=1G,high, and update kexec-tools.

with Cong's patch, kernel will reserve other range like between 896
and 4G, old kexec-tools either
fail to load second kernel or hang in purgatory or early stage of
second kernel, or other unknown behavior.

I would think first path is much clear and predicted.

If my memory is right, HPA did not like idea that we try below 896M,
and then under 4G and then above 4G.
and want us to have ",high" solution. Not sure if he would change his mind.
Also you will need and #ifdef CONFIG_X86_64 for 896M/4G searching code
so it will not confuse the
32bit arch.

Thanks

Yinghai
