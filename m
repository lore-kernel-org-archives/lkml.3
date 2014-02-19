Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaBSUYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:24:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41560 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaBSUYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:24:50 -0500
Date: Wed, 19 Feb 2014 21:24:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Drew Richardson <drew.richardson@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo <acme@redhat.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Wade Cherry <Wade.Cherry@arm.com>
Subject: Re: Perf Oops on 3.14-rc2
Message-ID: <20140219202443.GK6835@laptop.programming.kicks-ass.net>
References: <20140210221758.GB11542@dreric01-Precision-T1600>
 <20140218101831.GB4178@mudshark.cambridge.arm.com>
 <20140219162819.GP15586@twins.programming.kicks-ass.net>
 <CABPqkBQS355_XW-2KthkdZkzQnApRvOpANkB3SnfFyac-qsJaw@mail.gmail.com>
 <20140219183623.GL27965@twins.programming.kicks-ass.net>
 <CABPqkBS15h1p4gaaqJ0ExE35QcoFQ5dsVKeYcXi=jZ_9GB-BHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS15h1p4gaaqJ0ExE35QcoFQ5dsVKeYcXi=jZ_9GB-BHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 08:59:08PM +0100, Stephane Eranian wrote:
> On Wed, Feb 19, 2014 at 7:36 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, Feb 19, 2014 at 07:03:13PM +0100, Stephane Eranian wrote:
> >> I am trying to understand the context here.
> >> Are you saying, we may call an offline CPU?
> >
> > Yes, that is what's happening.
> >
> >> I saw that sometimes you retry, sometimes you don't.
> >
> > I tried to do exactly what we do for the task case which is far more
> > likely to fail. Could be I messed up.
> >
> I am not sure why you need to retry. If the CPU is offline, it is offline.
> Or are you saying, you get an error, but you don't know the exact
> reason, thus you keep trying? But how do you get out of this if
> the CPU stays offline?

Ah, so take perf_remove_from_context() as before the patch; if the
cpu_function_call() fails because the CPU is offline, it doesn't call
list_del_event().

Now the offline function is supposed to take them off the list, but it
doesn't actually in case they're grouped.

This leaves a free()d event on the offline cpu's context list.

After that things quickly go downwards.

But before I got there I was led down a few too many rabbit holes trying
to figure out wtf happened.


We could probably fix it differently though. But by the time I more or
less understood things I was too tired to make something pretty.

Anyway; if you get to do something if cpu_function_call() fails; you
have to also check if it got back up since you tried; at which point
you've got the same pattern as we have for task_function_call().
