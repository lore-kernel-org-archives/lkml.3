Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaB0JJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:09:53 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:40435 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaB0JJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:09:46 -0500
MIME-Version: 1.0
In-Reply-To: <20140226214236.GO22728@two.firstfloor.org>
References: <530D53EF.9090706@amacapital.net>
	<CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
	<CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com>
	<20140226185513.GL22728@two.firstfloor.org>
	<CALCETrVQ8SBg+YLuPmDevL+f2dzBjLJucfMvVHaB04E8QJSGXw@mail.gmail.com>
	<530E3E47.8010205@gmail.com>
	<CALCETrUHiDqT+VRbdEnGsEkMFqQt+ZqX+RTenp1ets8XMhrQ2Q@mail.gmail.com>
	<530E4B42.5090401@gmail.com>
	<20140226205322.GM22728@two.firstfloor.org>
	<530E5DE7.7060904@gmail.com>
	<20140226214236.GO22728@two.firstfloor.org>
Date: Thu, 27 Feb 2014 10:09:44 +0100
Message-ID: <CABPqkBQcN=tA7o=9Zc8XeUYZB6PHXZoKJUcp7Z_sn9YW3+VpGA@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 10:42 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Feb 26, 2014 at 02:34:31PM -0700, David Ahern wrote:
>> On 2/26/14, 1:53 PM, Andi Kleen wrote:
>> >>Is there some reason not to enable frame pointers?
>> >
>> >It makes code slower.
>>

That is what I have been told by compiler people too.

This is especially true of small functions which C++ object-oriented
code is full of. And that's how large programs are written with these
days.

The other problem with FP is hat you need to have everything
compiled with it. It is not always obvious how to check this, without
going to assembly. There is no indication in the ELF headers, AFAIK.


>> Sure there is some overhead because of the push, mov, pop
>> instructions per function. But, take for example the simple program
>> below. Compile with and without frame pointers
>
> I'm not criticizing your choice, just saying that
> it's often not practical to get FP everywhere
> (and I bet you missed some cases too)
>
> <.. micro benchmark snipped...>
>
> The CPU you're using has special hardware to avoid the main
> problems with FP. It can still cause slow downs in other
> cases (e.g. one register less). But there are other
> CPUs where this special hardware is not available.
>
> You may not care about these cases, but other people do.
>
>> >wrong annotations, out of date or broken dwarf library etc.)
>>
>> dwarf is often just not usable:
>

The first problem with the dwarf approach is that it incurs some
overhead during sampling. You need to copy a chunk of the user stack
in each sample. Not clear how much you need.

The second problem is security. You are saving random chunks of stack
in the perf.data file. Who knows what it contains. In many environments this
is a showstopper.

The Haswell LBR call stack is a good compromise, though as Andi
pointed out it has its tradeoffs.  It does not work in all
cases. But it has the speed and the security. It is model specific.
But I can live with that. PMU always comes with incremental
improvements.

> I agree (altough I haven't seen that error before)
>
>
>> That is a huge difference. Not to mention the fact the dwarf file is
>> useless which means radically lowering sample rate and increasing
>> mmap size.
>
> Yep.
>
> It's just fundamentally inefficient for profiling.
>
> -Andi
