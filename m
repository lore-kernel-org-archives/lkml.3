Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996Ab3K3Rfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 12:35:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33535 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab3K3Rfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 12:35:41 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrXUZe9xmUyDHgZRRe2TBP7CXSVpXkvH61qiLLxcANicUg@mail.gmail.com>
References: <CALCETrXUZe9xmUyDHgZRRe2TBP7CXSVpXkvH61qiLLxcANicUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Clock control algorithms (Re: [RFC][PATCH 5/7] x86: Use latch data structure for cyc2ns)
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 30 Nov 2013 09:34:20 -0800
To: Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>
CC: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@gmail.com>
Message-ID: <e24ec9c9-b250-4505-a534-4199202c9580@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a huge difference between something that breaks after 2^32 and 2^64 events.  Very few computers will ever be able to have 2^64 events of any kind in their lifetime, never mind a single boot.  

Andy Lutomirski <luto@amacapital.net> wrote:
>[Subject changed because this isn't relevant to the patches in
>question any more.]
>
>On Sat, Nov 30, 2013 at 1:18 AM, Peter Zijlstra <peterz@infradead.org>
>wrote:
>> On Fri, Nov 29, 2013 at 03:22:45PM -0800, Andy Lutomirski wrote:
>>> On Fri, Nov 29, 2013 at 9:37 AM, Peter Zijlstra
><peterz@infradead.org> wrote:
>>> > Use the 'latch' data structure for cyc2ns.
>>> >
>>> > This is a data structure first proposed by me and later named by
>>> > Mathieu. If anybody's got a better name; do holler.
>>>
>>> That structure must exist in the literature, but I have no idea what
>>> it's called.  It's a multi-word lock-free atomic (I think -- maybe
>>> it's just regular) register.  I even published a considerably
>fancier
>>> version of much the same thing a few years ago.  :)
>>
>> Yeah, its a fairly straight fwd thing it has to be named someplace
>;-)
>
>The trouble is that this data structure (like seqlocks, refcounts, and
>lots of real-world synchronization things) fails if the reader falls
>asleep for a multiple of 2^32 (or 2^64) writes.  The literature
>generally doesn't like such things.  (As a thoroughly irrelevant
>aside, TSX, and maybe even LL/SC, can be used to work around that
>issue in case anyone cares.)
>
>>
>>> I've occasionally wondered whether it would be possible to make a
>>> monotonicity-preserving version of this and use it for
>clock_gettime.
>>> One approach: have the writer set the time for the update to be a
>bit
>>> in the future and have the reader compare the current raw time to
>the
>>> cutoff to see which set of frequency/offset to use.  (This requires
>>> having some kind of bound on how long it takes to update the data
>>> structures.)
>>>
>>> The advantage: clock_gettime would never block.
>>> The disadvantage: complicated, potentially nasty to implement, and
>it
>>> would get complicated if anyone tried to allow multiple updates in
>>> rapid succession.
>>
>> Yes, that way you can chain a number of linear segments in various
>> slots, but you're indeed right in that it will limit the update
>> frequency. More slots will give you more room, but eventually you're
>> limited.
>>
>> I suppose NTP is the primary updater in that case, does that have a
>> limit on the updates? All the other updates we can artificially
>limit,
>> that shouldn't really matter.
>>
>> But yeah in my case we pretty much assume the TSC is complete crap
>and a
>> little more crap simply doesn't matter.
>>
>> For the 'stable' tsc on modern machines we never set the frequency
>and
>> it doesn't matter anyway.
>
>I assume that NTP works by filddling with the frequency and offset on
>a regular basis to preserve monotonicity while still controlling the
>clock.
>
>TBH, I've never understood why the NTP code is so integrated into the
>kernel's timing infrastucture or, for that matter, lives in the kernel
>at all.  Shouldn't the core interface be something more like "starting
>at time t_1, change the frequency to f_1, then at time t_2, change the
>frequency to f_2"?  That would give the ability to manage a control
>loop in userspace (or some kernel thread) and to reliably slew the
>clock by a small, fixed amount.  I suppose this could be elaborated to
>allow more than two adjustments to be scheduled in advance, but I
>really don't see the need for anything much fancier.
>
>Benefits:
> - Comprehensible without reading the entire NTP spec and all the
>various addenda.
> - No need for any timing code at all in the tick handler -- the whole
>thing could presumably be done with hrtimers and a bit fancier data
>structure that lets clock_gettime figure out when to update*.
> - Things like PTP don't need to pretend to be NTP.
>
>Disadvantages: No clue, since I don't know why NTP works the way it
>does right now.
>
>* vclock_gettime on x86_64 already has a branch that depends on the
>time.  I think that good implementation could do all of this fancy
>stuff with exactly one branch, resulting in the fast path being just
>as fast.
>
>--Andy

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
