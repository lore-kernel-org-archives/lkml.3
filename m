Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaIBU4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:56:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:39503 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaIBU4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:56:20 -0400
Date: Tue, 2 Sep 2014 22:56:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lina Iyer <lina.iyer@linaro.org>
cc: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
Subject: Re: [PATCH v3 3/4] irq: Allow multiple clients to register for irq
 affinity notification
In-Reply-To: <20140902184305.GB91995@ilina-mac.local>
Message-ID: <alpine.DEB.2.10.1409022109050.3333@nanos>
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org> <1409170479-29955-4-git-send-email-lina.iyer@linaro.org> <alpine.DEB.2.10.1408272239190.3323@nanos> <20140902184305.GB91995@ilina-mac.local>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, Lina Iyer wrote:
> On Wed, Aug 27 2014 at 14:56 -0600, Thomas Gleixner wrote:
> > On Wed, 27 Aug 2014, Lina Iyer wrote:
> > 
> > All you are describing is the fact, that there is only a single
> > notifier possible right now, but you completely miss to describe WHY
> > you need multiple ones.
> > 
> > The existing notifier was introduced to tell the driver that the irq
> > affinity has changed, so it can move its buffers to the proper NUMA
> > node. So if that driver gets this information then it can tell the PM
> > QoS code that its affinity changed so that stuff can react
> > accordingly, right?
> > 
> With the new PM QoS changes, multiple drivers would now be interested in
> knowing the smp_affinity changes of the same IRQ. PM QoS abstracts the

Again, you fail to tell me WHY multiple drivers are interested and
which drivers are interested and what they do with that information.

> notifier in the framework, so individual drivers dont have to register
> for notification themselves and handle affinity notifications. But PM
> QoS needs to coexist with NUMA and other arch drivers that need to
> modify based on their arch specific needs upon affinity change
> notifications.

Lots of unspecified blurb. What has NUMA to do with other arch
drivers? Are you actually understanding what this is all about?

> Modifying the IRQ notifications to list, benefits having a simpler
> mechanism to notify all arch drivers and frameworks like PM QoS.

Painting my bikeshed blue benefits all neighbours and institutions
like the Royal Navy, right?

Lina, this is leading nowhere. You just make completely unspecified
claims and try to push your solution to a not explained problem
through. That's not how it works, at least not with me.

So please sit down and write up a proper description of the problem
you are trying to solve.

All I can see from your postings so far is:

    1) You want to use the notification for PM QoS

    2) You run into conflicts with the existing notifiers

    3) You want to solve that conflict

What you are not telling is:

    1) In which way is PM QoS going to use that notifier

    2) How does that conflict with the existing users. And we only
       have two of them:

       - InfiniPath 7322 chip driver

       - cpu_rmap driver, which is used by

       	- solarflare NIC driver
	- mellanox mlx4 driver
	- cisco enic driver

	So how is that conflicting with your ARM centric PM QoS work?

	Please provide proper debug info about such a conflict, if it
	exists at all.

    3) Which arch drivers are involved?

       So far none, at least not in mainline according to
       "grep irq_set_affinity_notifier arch/".

       If you have out of tree code which uses this, then we want to
       see it first to understand what the arch driver is trying to
       solve by using that notification mechanism.

The more I think about what you are not telling the more I get the
feeling that this whole PM QoS thing you try to do is a complete
design disaster.

>From your changelog:

 "PM QoS and other idle frameworks can do a better job of addressing
  power and performance requirements for a cpu, knowing the IRQs that
  are affine to that cpu."

I agree with that. PM might make better decisions if it knows which
activities are targeted at a particular cpu.

So someone figured that out and you got tasked to implement it. So you
looked for a way to get to this information and you found the existing
notifier and decided to (ab)use it for your purpose. But you did not
spend a split second to figure out why this is wrong and even useless.

At the point where PM QoS or whatever decides to use that information,
it does not know at all what the current affinity mask is. So in your
patch 4/4, which I ignored so far you do:

+     	   	 struct irq_desc *desc = irq_to_desc(req->irq);
+ 		 struct cpumask *mask = desc->irq_data.affinity;

WTF?

You did not even have the courtesy to use the proper functions for
this. And of course you access all of this unlocked. So how is that
supposed to work with a concurrent affinity update? Not at
all.

Fiddling with irq_desc is a NONO: Consult your preferred search
machine or just the kernel changelogs about the consequences.

Looking at the other patches you really seem to have missed out on
some other NONOs:

 struct pm_qos_request {
+	enum pm_qos_req_type type;
+	struct cpumask cpus_affine;
+	/* Internal structure members */
 	struct plist_node node;
 	int pm_qos_class;
 	struct delayed_work work; /* for pm_qos_update_request_timeout */
@@ -80,6 +90,7 @@ enum pm_qos_type {
 struct pm_qos_constraints {
 	struct plist_head list;
 	s32 target_value; /* Do not change to 64 bit */
+	s32 target_per_cpu[NR_CPUS];
 	s32 default_value;
 	s32 no_constraint_value;
 	enum pm_qos_type type;

Go figure how well "struct cpumask" and a s32 array sizeof NR_CPUS
bodes on kernels compiled for NR_CPUS=8192 or larger.

Just get it: You are hacking core code, not some random ARM SoC
driver.

That aside, your design or the lack thereof sucks. While your hackery
might work somehow for the PM QoS problem at hand - ignoring the hard
to debug race window of the concurrent affinity update - it's
completely useless for other PM related decisions despite your claims
that its a benefit for all of that.

How would a general "keep track of the targets of all interrupts in
the system" mechanism make use of this? Not at all. Simply because it
has no idea which interrupts are requested at any given time. Sure
your answer will be "add another notifier" to solve that problem. But
that's the completely wrong answer because notifiers are a PITA and
should go away. Here is Linus' POV of notifiers and I really agree
with it:

 "Notifiers are a disgrace, and almost all of them are a major design
  mistake. They all have locking problems, the introduce internal
  arbitrary API's that are hard to fix later (because you have random
  people who decided to hook into them, which is the whole *point* of
  those notifier chains)."

And so I really fight that notifier chain tooth and nails until someone
provides me a proper argument WHY it cant be solved with proper
explicit and understandable mechanisms.

Back to your PM QoS trainwreck:

I'm really impressed that you did not notice at all how inaccurate and
therefor useless the affinity information which you are consulting is.

Did it ever hit even the outer hemisphere of your brain, that
irqdata.affinity is the affinity which was requested by the caller of
an affinity setter function and not the effective affinity?

I bet it did not, simply because you did not pay any attention and
bother to analyze that proper. Otherwise you would have tried to hack
around this as well in some disgusting way.

Really great savings, if the affinity is left at default to all cpus,
but the effective affinity is a single cpu due to irq routing
restrictions in the hardware.

Surely you tested against single CPU affinities and achieved great
results, but that's not a generic and useful solution.

Thanks,

	tglx







