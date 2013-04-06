Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab3DFLFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 07:05:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37159 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab3DFLFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 07:05:23 -0400
Date: Sat, 6 Apr 2013 13:05:07 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
Message-ID: <20130406110507.GC7572@netboy>
References: <51586315.7080006@gmail.com>
 <5159D221.70304@linaro.org>
 <1364889256.16858.1.camel@laptop>
 <515B0502.8070408@linaro.org>
 <1365009558.26858.19.camel@hornet>
 <515C66FE.7030501@linaro.org>
 <1365010502.26858.32.camel@hornet>
 <515C6C01.9070905@linaro.org>
 <1365092963.26858.107.camel@hornet>
 <1365185813.25942.12.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365185813.25942.12.camel@hornet>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 07:16:53PM +0100, Pawel Moll wrote:
 
> Ok, so how about the code below? Disclaimer: this is just a proposal.
> I'm not sure how welcomed would be an extra field in struct file, but
> this makes the clocks ultimately flexible - one can "attach" the clock
> to any arbitrary struct file. Alternatively we could mark a "clocked"
> file with a special flag in f_mode and have some kind of lookup.

Only a tiny minority of file instances will want to be clocks.
Therefore I think adding the extra field will be a hard sell.

The flag idea sounds harmless, but how do you perform the lookup?
 
> Also, I can't stop thinking that the posix-clock.c shouldn't actually do
> anything about the character device... The PTP core (as the model of
> using character device seems to me just one of possible choices) could
> do this on its own and have simple open/release attaching/detaching the
> clock. This would remove a lot of "generic dev" code in the
> posix-clock.c and all the optional cdev methods in struct posix_clock.
> It's just a thought, though...

Right, the chardev could be pushed into the PHC layer. The original
idea of chardev clocks did have precedents, though, like hpet and rtc.
 
> And a couple of questions to Richard... Isn't the kref_put() in
> posix_clock_unregister() a bug? I'm not 100% but it looks like a simple
> register->unregister sequence was making the ref count == -1, so the
> delete_clock() won't be called.

Well,

	posix_clock_register() -> kref_init() ->
		atomic_set(&kref->refcount, 1);

So refcount is now 1 ...

	posix_clock_unregister() -> kref_put() -> kref_sub(count=1) ->
		atomic_sub_and_test((int) count, &kref->refcount)

and refcount is now 0. Can't see how you would get -1 here.

> And was there any particular reason that the ops in struct
> posix_clock are *not* a pointer?

One less run time indirection maybe? I don't really remember why or
how we arrived at this. The whole PHC review took a year, with
something like fifteen revisions.

Thanks,
Richard

