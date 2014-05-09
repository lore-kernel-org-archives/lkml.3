Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbaEIUJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:09:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:38436 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaEIUJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:09:19 -0400
Date: Fri, 9 May 2014 22:09:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, arvind.chauhan@arm.com, preeti@linux.vnet.ibm.com,
        khilman@linaro.org
Subject: Re: [PATCH 2/2] tick: SHUTDOWN event-dev if no events are required
 for KTIME_MAX
In-Reply-To: <0fe81b08a8aa32912ce7b4a015fdc09b6e3830e3.1399623699.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1405091728450.6261@ionos.tec.linutronix.de>
References: <cover.1399623699.git.viresh.kumar@linaro.org> <0fe81b08a8aa32912ce7b4a015fdc09b6e3830e3.1399623699.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014, Viresh Kumar wrote:
> When expires is set to KTIME_MAX in tick_program_event(), we are sure that there
> are no events enqueued for a very long time and so there is no point keeping
> event device running. We will get interrupted without any work to do many a
> times, for example when timer's counter overflows.
> 
> So, its better to SHUTDOWN the event device then and restart it ones we get a
> request for next event. For implementing this a new field 'last_mode' is added
> to 'struct clock_event_device' to keep track of last mode used.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  include/linux/clockchips.h |  1 +
>  kernel/time/tick-oneshot.c | 14 +++++++++++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> index 2e4cb67..36a4ca6 100644
> --- a/include/linux/clockchips.h
> +++ b/include/linux/clockchips.h
> @@ -105,6 +105,7 @@ struct clock_event_device {
>  	u32			mult;
>  	u32			shift;
>  	enum clock_event_mode	mode;
> +	enum clock_event_mode	last_mode;
>  	unsigned int		features;
>  	unsigned long		retries;
>  
> diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
> index 8241090..9543815 100644
> --- a/kernel/time/tick-oneshot.c
> +++ b/kernel/time/tick-oneshot.c
> @@ -27,8 +27,20 @@
>  int tick_program_event(ktime_t expires, int force)
>  {
>  	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
> +	int ret = 0;
>  
> -	return clockevents_program_event(dev, expires, force);
> +	/* Shut down event device if it is not required for long */
> +	if (unlikely(expires.tv64 == KTIME_MAX)) {
> +		dev->last_mode = dev->mode;
> +		clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);

No, we are not doing a state change behind the scene and a magic
restore. And I know at least one way to make this fall flat on its
nose, because you are blindly doing dev->last_mode = dev->mode on
every invocation. So if that gets called twice without a restore in
between, the device is going to be in shutdown mode forever.

It's moronic anyway as the clock event device has the state
CLOCK_EVT_MODE_ONESHOT if its active, otherwise we would not be in
that code path.

But what's even worse: you just define that it's the best way for all
implementations of clockevents to handle this.

It's definitley NOT. Some startup/shutdown implementations are rather
complex, so that would burden them with rather big latencies and some
of them will even outright break.

There is a world outside of YOUR favourite subarch.

We do not hijack stuff just because we can and it works on some
machines. We think about it proper.

I prevented that the GPIO folks hijacked irq_startup in a disgusting
way for solving the GPIO issues for the very same reason. So in the
end we added a new OPT-In interface which solved the problem without
breaking any existing code. And it made the code simpler and cleaner
in the very end.

If we hijack some existing facility then we audit ALL implementation
sites and document that we did so and why we are sure that it won't
break stuff. It still might break some oddball case, but that's not a
big issue.

In the clockevents case we do not even need a new interface, but this
must be made OPT-in and not a flagday change for all users.

And no we are not going to abuse a feature flag for this. It's not a
feature.

I'd rather have a new state for this, simply because it is NOT
shutdown. It is in ONESHOT_STOPPED state. Whether a specific
implementation will use the SHUTDOWN code for it or not does not
matter.

That requires a full tree update of all implementations because most
of them have a switch case for the mode. And adding a state will cause
all of them which do not have a default clause to omit warnings
because the mode is an enum for this very reason.

And even if all of them would have a default clause, you'd need a way
to OPT-In, because some of the defaults have a BUG() in there. Again,
no feature flag exclusion. See above.

So the right thing to do this is:

1A) Change the prototype of the set_mode callback to return int and
    fixup all users. Either add the missing default clause or remove
    the existing BUG()/ pr_err()/whatever handling in the existing
    default clause and return a UNIQUE error code.

    I know I should have done that from the very beginning, but in
    hindsight one could have done everything better.

    coccinelle is your friend (if you need help ask me or Julia
    Lawall). But it's going to be quite some manual work on top.

1B) Audit the changes and look at the implementations. If the patch is
    just adding the default clause or replacing some BUG/printk error
    handling goto #1C

    If it looks like it needs some preparatory care or if you find
    bugs in a particular implementation, roll back the changes and do
    the bug fixes and preparatory changes first as separate patches.

    Go back to #1A until the coccinelle patches are just squeaky
    clean.

1C) Add proper error handling for the various modes to the set_mode
    callback call sites, only two AFAIK.

2A) Add a new mode ONESHOT_STOPPED. That's safe now as all error
    handling will be done in the core code.

2B) Implement the ONESHOT_STOPPED logic and make sure all of the core
    code is aware of it.

And don't tell me it can't be done. I've done it I don't know how many
times with interrupts, timers, locking and some more. It's hard work,
but it's valuable and way better than the brainless "make it work for
me" hackery.

You asked me yesterday about your other hrtimer patches. You know why
I do not come around to review them? Because I have found way too much
half baken stuff in your patches I reviewed so far. That forces me to
go through all of them with a fine comb and I simply do not scale.

Alone reviewing this patch took me several couple of hours, because I
had to think through the implications and stare into the code. And you
know why? Because, first of all I do not trust your patches and
secondly your changelogs (especially the one of the 1/2 patch) told me
clearly, that this is "works for me" hackery.

So YOU forced me to spend time on looking at the consequences all over
the place instead of YOU had looked in the first place and figured it
out yourself.

Did you look at ALL implementations of clock events when you made that
change?  Definitely NOT.

I did. And found quite some of them which are going to be hurt. I also
found some of them which are buggy.

Just get it. This is CORE code and it affects ALL of its users. You
can play that "hack it into submission game" with a random driver, i.e
at the end of the callchain, but core code is very very differrent.

There is always the risk to break something when you work on core code
and nobody will rip your head off, if you break something because you
did not notice the random oddity of some use site.

But breaking stuff wholesale by just not thinking about it carefully
won't earn you any brownie points.

Vs. your other pending patches, I have no idea whether I have the time
and the stomach to go through them before I vanish to Japan next
weekend.

If there are urgent bugfixes, which are obvious or proper thought
through and explained, please resend them.

Thanks,

	tglx
