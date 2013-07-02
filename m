Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab3GBDBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 23:01:36 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:32907 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3GBDBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 23:01:30 -0400
MIME-Version: 1.0
In-Reply-To: <1372728935.22688.36.camel@gandalf.local.home>
References: <CANiYik6PbwRkH1vK4B4cFhY0MEJAoF=MBggkvgBYGfyCw2ny-w@mail.gmail.com>
 <CANiYik6h0_xnUYqCRHZU75az9YS=ySUHaqgMayW-Ffj5Jey6_g@mail.gmail.com> <1372728935.22688.36.camel@gandalf.local.home>
From: Alexander Lam <azl@google.com>
Date: Mon, 1 Jul 2013 20:01:08 -0700
Message-ID: <CANiYik6ut7zqAnUFk+HtTmrkig79pEx0wkWM+1uBAMorPb0zSw@mail.gmail.com>
Subject: Re: Fwd: [draft] Tracing multibuffer support concurrency issues
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Lam <lambchop468@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 6:35 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2013-07-01 at 15:33 -0700, Alexander Lam wrote:
>
>> To fix this we could go through the ftrace_trace_arrays list and use
>> addresses to check if a particular pointer to a trace_array is still
>> valid, but this is vulnerable to the ABA problem if a trace_array is
>> freed and another is reallocated at the same address. This method is
>> used by subsystem_open() in trace_events.c
>
> And what's so bad about that? If it is freed and a new one is allocated
> at the same address, let it return crap. I'm much more interested in not
> letting it crash then caring about inconsistent data from someone that's
> doing crazy things to the system.

I figured you might say something like that. I agree with you on this.

>>
>> An ugly way to get around the ABA issue is to use a monotonically
>> increasing ID # for each trace_array instance. Those IDs could be used
>> instead of pointers when creating debugfs files.
>
> Not worth it.
>
>>
>> Is there a better way to fix this problem?
>>
>> Also unaddressed are all of the other files which use a trace_array,
>> trace_cpu, or ftrace_event_file in their operation - these would need
>> the same fix.
>
> Hmm, really? Just the initiator. That is, when an event is enabled or
> anything gets opened, we block deletion from happening. That way we
> don't need to care about the rest. Only open and enabling events.

Yes, I did mean the initiator, but I meant the "search for this
pointer in a list" would have to be applied for each of those struct
types because they were being passed through inode->i_private. I see
how this isn't a problem anymore after looking at your patch. It
didn't occur to me that checking the tr field of those structs before
using other pointers in the struct would also work.

Thanks,
Alex

>
> -- Steve
>
>
>
