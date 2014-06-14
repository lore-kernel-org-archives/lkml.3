Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbaFNQXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 12:23:21 -0400
Received: from ns.horizon.com ([71.41.210.147]:32626 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755125AbaFNQXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 12:23:20 -0400
Date: 14 Jun 2014 12:23:19 -0400
Message-ID: <20140614162319.17191.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: [PATCH-v2 4/4] random: clean up interrupt entropy accounting for archs w/o cycle counters
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20140614160041.GI6447@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with your points, with one exception.  Which may be
me misunderstanding.

> Also note that the question is not whether the non-timer interrupt
> rate is less than 32 seconds, but rather out of the last 64
> interrupts, how many of the interrupts come from non-timer sources?
> That's not the same thing, especially if you are running in tickless
> mode, which most modern kernels for mobile handsets would want to do
> for the obvious power savings reason.  Indeed the main concern on most
> mobile handsets is that there aren't that many interrupts to begin
> with, because they've been optimized out as much as possible.

When you say "the question is", do you mean that's what you eant
the code to do?  Because that's not what it does right now.

The condition for not spilling is

	if ((fast_pool->count & 63) && !time_after(now, fast_pool->last + HZ))
		return;

In other words, spill if there have been 64 samples *or* 1 second since
the last spill.

> The real answer is that ARM manufacuters have to get off their !@#!@?
> duff and give us either a real clock cycle counter, or a real hardware
> randum number generator, or both...

I've thought of beating the RTC against the main oscillator.
But which I know a lot of SoCs have an battery-backed RTC, I don't
know how universal an RTC is.

The other nice source is an otherwise unused ADC.  Even if the input
is shorted out, there's lsbit noise.  but again, not everything has
an audio ADC.
