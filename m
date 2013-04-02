Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290Ab3DBUgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:36:04 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57015 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761463Ab3DBUgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:36:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130402201148.GJ29506@redhat.com>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
	<1364923183-316-4-git-send-email-yinghai@kernel.org>
	<20130402180606.GI29506@redhat.com>
	<CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
	<CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
	<20130402191130.GB31760@redhat.com>
	<CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
	<20130402201148.GJ29506@redhat.com>
Date: Tue, 2 Apr 2013 13:36:02 -0700
X-Google-Sender-Auth: _NLHuDaq00G3NBkUA7orTHjpS_I
Message-ID: <CAE9FiQURMNjPYYze-tPn4Ssrc4TqMqTuvwRRhoVYEnGLF4Z0cQ@mail.gmail.com>
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

On Tue, Apr 2, 2013 at 1:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Apr 02, 2013 at 01:00:46PM -0700, Yinghai Lu wrote:
>> On Tue, Apr 2, 2013 at 12:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Tue, Apr 02, 2013 at 11:49:13AM -0700, Yinghai Lu wrote:
>> >> On Tue, Apr 2, 2013 at 11:42 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> >> > aka:
>> >> > old kexec-tools stay with "crashkernel=X"
>> >> > new kexec-tools stay with
>> >> > 1. like old kexec tools
>> >> > 2. or "crashkernel=X,high" or "crashkernel=X,high crashkernel=Y,low",
>> >> > Y could be 100M or 0 etc.
>> >>
>> >> I keep the old logic like:
>> >> if there are several "crashkernel=X,high", only last one is honored.
>> >> if there are several "crashkernel=Y,low", only last one is honored.
>> >
>> > Yes but if different types of crashkernel= options are mixes then
>> > behavior is not defined.
>>
>> dmesg or /proc/iomem will show them what is finally reserved.
>>
>> >
>> > crashkernel=X,high crashkernel=X
>>
>> ==> crashkernel=X is tossed away.
>
> You are just describing what your code does. There is no theme or
> justification behind this behavior. There is no uniformity. A user can
> question that so far you used to honor last crashkernel= parameter and
> suddenly in 3.9 that's no more the case. Out of blue crashkernel=X,high is
> overriding crashkernel=X and it is not obivious why.

Let me repeat again:
we keep crashkernel=X old behavior with old kexec-tools.
crashkernel=X;high is for new kexec-tools that support loading high.

If the user want to use ,high but still with old kexec-tools, that is
not going to work.

Can we just keep it separated?

>
>>
>> > crashkernel=X,high crashkernel=Y;low
>>
>> normal case. if user want more or disable low range.
>
> Again, behavior is not clear to user. Please stop describing your code
> behavior. Discuss more in terms of presenting a consistent interface to
> user.
>
>>
>> > crashkernel=Y;low crashkernel=X
>>
>> crashkernel=X will be used.
>
> Why? When crashkernel=X is specified with crashkernel=Y;high, high takes
> over but when crashkernel=X is specified with crashkernel=Y;low,
> crashkernel=X takes over. These is highly unintutive.
>
>>
>> >
>> > And possibilities go on. So I think it makes life simpler if we always
>> > parse last crashkernel= option and act upon that. And use
>> > crashkernel_no_auto_low to opt out of auto reserved low memory area.
>>
>> No, that is not just disable. User could want more like 128M instead of 72M.
>
> If user wants 128M in low memory, they will just specify
> crashkernel=128M;low

in the kernel-parameter.txt, already says ;low is need to used with ;high.

>
> If they want to control multiple ranges of memory, then that's the feature
> we currently don't support. Currently we support only reserving one range
> of memory.
>
> If you want to support multiple ranges of memory,then do it properly.
> Parse all crashkernel= options, prepare a list of memory to be reserved
> and unreserved, resolve all the conflicts between various options and
> then reserve the memory. But that does not seem to be a requirement at
> this point of time.

No we does not support multiple ranges, as it will need more changes
in kexec-tools.

Can we stop here with those four patches?

Later, we can extend it if it is really needed.

Thanks

Yinghai
