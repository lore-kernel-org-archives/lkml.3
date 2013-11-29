Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3K2XXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 18:23:13 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:65222 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3K2XXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 18:23:09 -0500
MIME-Version: 1.0
In-Reply-To: <20131129174430.076978392@infradead.org>
References: <20131129173657.252094369@infradead.org> <20131129174430.076978392@infradead.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 29 Nov 2013 15:22:45 -0800
Message-ID: <CALCETrX=XvBP7-RjzCqMAV-3ZtMQY9XqBTOZOG3A85M9vhYwCw@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/7] x86: Use latch data structure for cyc2ns
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 9:37 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Use the 'latch' data structure for cyc2ns.
>
> This is a data structure first proposed by me and later named by
> Mathieu. If anybody's got a better name; do holler.

That structure must exist in the literature, but I have no idea what
it's called.  It's a multi-word lock-free atomic (I think -- maybe
it's just regular) register.  I even published a considerably fancier
version of much the same thing a few years ago.  :)

>
> Its a multi-version thing which allows always having a coherent
> object; we use this to avoid having to disable IRQs while reading
> sched_clock() and avoids a problem when getting an NMI while changing
> the cyc2ns data.
>
> The patch should have plenty comments actually explaining the thing.
>
> The hope is that the extra logic is offset by no longer requiring the
> sti;cli around reading the clock.

I've occasionally wondered whether it would be possible to make a
monotonicity-preserving version of this and use it for clock_gettime.
One approach: have the writer set the time for the update to be a bit
in the future and have the reader compare the current raw time to the
cutoff to see which set of frequency/offset to use.  (This requires
having some kind of bound on how long it takes to update the data
structures.)

The advantage: clock_gettime would never block.
The disadvantage: complicated, potentially nasty to implement, and it
would get complicated if anyone tried to allow multiple updates in
rapid succession.

Anyway, this is mostly irrelevant to your patches.

--Andy
