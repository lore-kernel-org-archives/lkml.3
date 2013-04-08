Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935225Ab3DHR6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:58:22 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34560 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934931Ab3DHR6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:58:20 -0400
Message-ID: <1365443897.24306.12.camel@hornet>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Pawel Moll <pawel.moll@arm.com>
To: Richard Cochran <richardcochran@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Date: Mon, 08 Apr 2013 18:58:17 +0100
In-Reply-To: <20130406110507.GC7572@netboy>
References: <51586315.7080006@gmail.com> <5159D221.70304@linaro.org>
	 <1364889256.16858.1.camel@laptop> <515B0502.8070408@linaro.org>
	 <1365009558.26858.19.camel@hornet> <515C66FE.7030501@linaro.org>
	 <1365010502.26858.32.camel@hornet> <515C6C01.9070905@linaro.org>
	 <1365092963.26858.107.camel@hornet> <1365185813.25942.12.camel@hornet>
	 <20130406110507.GC7572@netboy>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 08 Apr 2013 17:58:18.0066 (UTC) FILETIME=[A64B2B20:01CE3482]
X-MC-Unique: 113040818581806501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-06 at 12:05 +0100, Richard Cochran wrote:
> On Fri, Apr 05, 2013 at 07:16:53PM +0100, Pawel Moll wrote:
> > Ok, so how about the code below? Disclaimer: this is just a proposal.
> > I'm not sure how welcomed would be an extra field in struct file, but
> > this makes the clocks ultimately flexible - one can "attach" the clock
> > to any arbitrary struct file. Alternatively we could mark a "clocked"
> > file with a special flag in f_mode and have some kind of lookup.
> 
> Only a tiny minority of file instances will want to be clocks.
> Therefore I think adding the extra field will be a hard sell.
> 
> The flag idea sounds harmless, but how do you perform the lookup?

Hash table. I'll get some code typed and post it tomorrow.
 
> > Also, I can't stop thinking that the posix-clock.c shouldn't actually do
> > anything about the character device... The PTP core (as the model of
> > using character device seems to me just one of possible choices) could
> > do this on its own and have simple open/release attaching/detaching the
> > clock. This would remove a lot of "generic dev" code in the
> > posix-clock.c and all the optional cdev methods in struct posix_clock.
> > It's just a thought, though...
> 
> Right, the chardev could be pushed into the PHC layer. The original
> idea of chardev clocks did have precedents, though, like hpet and rtc.

I'm not arguing about the use of cdev for PTP clocks, it's perfectly
fine with me. I'm just not convinced that the "more generic" clock layer
should enforce cdevs and nothing more. But I think we're more-or-less
talking the same language here, so I'll simply create a patch and send
it as RFC.

> > And a couple of questions to Richard... Isn't the kref_put() in
> > posix_clock_unregister() a bug? I'm not 100% but it looks like a simple
> > register->unregister sequence was making the ref count == -1, so the
> > delete_clock() won't be called.
> 
> Well,
> 
> 	posix_clock_register() -> kref_init() ->
> 		atomic_set(&kref->refcount, 1);
> 
> So refcount is now 1 ...
> 
> 	posix_clock_unregister() -> kref_put() -> kref_sub(count=1) ->
> 		atomic_sub_and_test((int) count, &kref->refcount)
> 
> and refcount is now 0. Can't see how you would get -1 here.

Eh. For some reason I was convinced that kref_init() sets the counter to
0 not 1. My bad.

> > And was there any particular reason that the ops in struct
> > posix_clock are *not* a pointer?
> 
> One less run time indirection maybe? I don't really remember why or
> how we arrived at this. The whole PHC review took a year, with
> something like fifteen revisions.

Ok. As most of the *_ops seem to be referenced via pointers (including
file ops, which are pretty heavily used ;-) and this makes it much
easier to define static clocks, I'll propose a change in a separate
patch.

Now, before I spend time doing all this, a question to John, Peter,
Stephane and the rest of the public - would a solution providing such
userspace interface:

	fd = sys_perf_open()
	timestamp = clock_gettime((FD_TO_CLOCKID(fd), &ts)

be acceptable to all?

Paweł


