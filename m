Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaIYPnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:43:09 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44540 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaIYPnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:43:07 -0400
Date: Thu, 25 Sep 2014 09:43:02 -0600
From: Lina Iyer <lina.iyer@linaro.org>
To: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, rjw@rjwysocki.net
Subject: Re: [PATCH v3 3/4] irq: Allow multiple clients to register for irq
 affinity notification
Message-ID: <20140925154209.GF1004@ilina-mac.local>
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org>
 <1409170479-29955-4-git-send-email-lina.iyer@linaro.org>
 <alpine.DEB.2.10.1408272239190.3323@nanos>
 <20140902184305.GB91995@ilina-mac.local>
 <alpine.DEB.2.10.1409022109050.3333@nanos>
 <20140924221023.GD1004@ilina-mac.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20140924221023.GD1004@ilina-mac.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02 2014 at 14:56 -0600, Thomas Gleixner wrote:
>On Tue, 2 Sep 2014, Lina Iyer wrote:
>> On Wed, Aug 27 2014 at 14:56 -0600, Thomas Gleixner wrote:
>> > On Wed, 27 Aug 2014, Lina Iyer wrote:
>> >
>> > All you are describing is the fact, that there is only a single
>> > notifier possible right now, but you completely miss to describe WHY
>> > you need multiple ones.
>> >
>> > The existing notifier was introduced to tell the driver that the irq
>> > affinity has changed, so it can move its buffers to the proper NUMA
>> > node. So if that driver gets this information then it can tell the PM
>> > QoS code that its affinity changed so that stuff can react
>> > accordingly, right?
>> >
>> With the new PM QoS changes, multiple drivers would now be interested in
>> knowing the smp_affinity changes of the same IRQ. PM QoS abstracts the
>
>Again, you fail to tell me WHY multiple drivers are interested and
>which drivers are interested and what they do with that information.
>
>> notifier in the framework, so individual drivers dont have to register
>> for notification themselves and handle affinity notifications. But PM
>> QoS needs to coexist with NUMA and other arch drivers that need to
>> modify based on their arch specific needs upon affinity change
>> notifications.
>
>Lots of unspecified blurb. What has NUMA to do with other arch
>drivers? Are you actually understanding what this is all about?
>
>> Modifying the IRQ notifications to list, benefits having a simpler
>> mechanism to notify all arch drivers and frameworks like PM QoS.
>
>Painting my bikeshed blue benefits all neighbours and institutions
>like the Royal Navy, right?
Sorry about not being very clear in my responses.

>
>Lina, this is leading nowhere. You just make completely unspecified
>claims and try to push your solution to a not explained problem
>through. That's not how it works, at least not with me.
>
>So please sit down and write up a proper description of the problem
>you are trying to solve.
>
>All I can see from your postings so far is:
>
>    1) You want to use the notification for PM QoS
>
>    2) You run into conflicts with the existing notifiers
>
>    3) You want to solve that conflict
>
Here is the premise of my patchset - 

When a cpuidle governor selects the idle state of the cpu, it uses
the PM QoS CPU_DMA_LATENCY constraint value in determining the
acceptable tolerance in exit latency of the cpu, before choosing the low
power state for the cpu. Drivers specify the PM QoS request for this
constraint, indicating their tolerance. The aggregated QoS request is
used in determining the state of each cpu.
Now, when drivers make a request, they usually have a device IRQ in
mind, which generally needs to be addressed within the stipulated time
after the interrupt fires. By default, the IRQs' have affinity towards
many cpus. However, when used with a IRQ balancer, that sets the
affinity only to a subset of the available cpus, it seems inefficient
that all cpus obey the QoS requirement in terms of power.
Say, when an USB driver specifies a 2 millisecond QoS constraint, it
prevents all the cpus in the SoC from entering any power down state,
which need more than 2 ms to be effective.  Thats a lot of leakage
current that could be saved. The IRQ in many instances would just
wake up cpu0, while other cpus remain in high leakage idle states. This
information is critical to the governor to determine the best idle state
it could allow the cpu to be in.

So the change here is to specify QoS requests against a subset of cpus,
which when aggregated, the idle governor can distill out the QoS
requirement only for that cpu. When requests are made with a set of cpus
as the intended target for the QoS value, the PM QoS framework
calculates the QoS value for each cpu. The governor can then be modified
to request the QoS CPU_DMA_LATENCY constraint on an individual cpu and
can choose the deepest idle state that would respect the requirement.

By default QoS requests do not have a preference for cpus and that is
the behavior with these patches too. Using the per-cpu PM QoS, the
drivers can now specify a set of cpus that need to obey the QoS
requests, if they know the cpus or they would specify an IRQ, if the
request is to avoid latency in handling the device IRQ. The driver is
not expected to handle the IRQ's smp_affinity changes and would be done
by the PM QoS framework on behalf of the driver. This is not enforced on
the driver that they need to specify an IRQ or a subset of cpus for
their request. If there is no IRQ or cpu preference, then PM QoS
defaults to applying the request for all cpus. I would expect many of
the existing drivers still want this behavior.

In the case a driver is aware that the QoS request to guarantee a
certain performance in handling the device IRQ, the request can be made
to track the IRQ. PM QoS registers for a smp_affinity change and does
the best judgement based on the affinity. The IRQ may still fire on any
of the cpus in the affinity mask which would make it comparable to the
existing QoS behavior and no power saving is achieved.

>What you are not telling is:
>
>    1) In which way is PM QoS going to use that notifier
>
>    2) How does that conflict with the existing users. And we only
>       have two of them:
>
>       - InfiniPath 7322 chip driver
>
>       - cpu_rmap driver, which is used by
>
>       	- solarflare NIC driver
>	- mellanox mlx4 driver
>	- cisco enic driver
>
>	So how is that conflicting with your ARM centric PM QoS work?
>
>	Please provide proper debug info about such a conflict, if it
>	exists at all.
>
>    3) Which arch drivers are involved?
>
>       So far none, at least not in mainline according to
>       "grep irq_set_affinity_notifier arch/".
>
>       If you have out of tree code which uses this, then we want to
>       see it first to understand what the arch driver is trying to
>       solve by using that notification mechanism.
>

I assumed that PM QoS is also used in conjunction with NUMA. I did
notice a few systems that used the smp_affinity notifications. My
assumption was such systems may have drivers that could prefer a per-cpu
QoS request. per-cpu PM QoS is not an ARM specific change, though this
benefits quite a bit in a power constrained environment. An octa core
system with a low power or a high performance distinction amongst the
cores, clearly benefits from this feature, when used with an IRQ
balancer. 

It didnt seem right me that PM QoS gets notified from InifiniPath and NIC
drivers, while others have PM QoS registering directly.

As far my usecases are concerned in an ARM chipset, I did not see any
conflict with the existing users of the smp affinity notifications. But,
I assume the systems may want to use per-cpu PM QoS for some of their
IRQs on a later date. Hence the change to a notification mechanism.

>The more I think about what you are not telling the more I get the
>feeling that this whole PM QoS thing you try to do is a complete
>design disaster.
>
>From your changelog:
>
> "PM QoS and other idle frameworks can do a better job of addressing
>  power and performance requirements for a cpu, knowing the IRQs that
>  are affine to that cpu."
>
>I agree with that. PM might make better decisions if it knows which
>activities are targeted at a particular cpu.
>
>So someone figured that out and you got tasked to implement it. So you
>looked for a way to get to this information and you found the existing
>notifier and decided to (ab)use it for your purpose. But you did not
>spend a split second to figure out why this is wrong and even useless.
>
>At the point where PM QoS or whatever decides to use that information,
>it does not know at all what the current affinity mask is. So in your
>patch 4/4, which I ignored so far you do:
>
>+     	   	 struct irq_desc *desc = irq_to_desc(req->irq);
>+ 		 struct cpumask *mask = desc->irq_data.affinity;
>
>WTF?
>
Sorry, bad access on my part. I will fix it.

>You did not even have the courtesy to use the proper functions for
>this. And of course you access all of this unlocked. So how is that
>supposed to work with a concurrent affinity update? Not at
>all.
>
>Fiddling with irq_desc is a NONO: Consult your preferred search
>machine or just the kernel changelogs about the consequences.
>
>Looking at the other patches you really seem to have missed out on
>some other NONOs:
>
> struct pm_qos_request {
>+	enum pm_qos_req_type type;
>+	struct cpumask cpus_affine;
>+	/* Internal structure members */
> 	struct plist_node node;
> 	int pm_qos_class;
> 	struct delayed_work work; /* for pm_qos_update_request_timeout */
>@@ -80,6 +90,7 @@ enum pm_qos_type {
> struct pm_qos_constraints {
> 	struct plist_head list;
> 	s32 target_value; /* Do not change to 64 bit */
>+	s32 target_per_cpu[NR_CPUS];
> 	s32 default_value;
> 	s32 no_constraint_value;
> 	enum pm_qos_type type;
>
>Go figure how well "struct cpumask" and a s32 array sizeof NR_CPUS
>bodes on kernels compiled for NR_CPUS=8192 or larger.
>
Sorry, I did not imagine the possiblity of these failures.
I figured that I would not use up a per-cpu variable, since the access
to the values may be from one cpu where the code is being processed, but
seems like there are quite a few merits, that I overlooked.

>Just get it: You are hacking core code, not some random ARM SoC
>driver.
>
>That aside, your design or the lack thereof sucks. While your hackery
>might work somehow for the PM QoS problem at hand - ignoring the hard
>to debug race window of the concurrent affinity update - it's
>completely useless for other PM related decisions despite your claims
>that its a benefit for all of that.
Yes, there is a race condition in PM QoS, where the notification between
the time, the request is added and the notification is registered.
AFAIK, the behavior in the irq/manage.c seems to be held the same. If
there is a concurrent change in notification, the schedule_work would
not reschedule and possibly not send a notification, which happens today
as well. I will revisit the change and look, if I can make it better.

>
>How would a general "keep track of the targets of all interrupts in
>the system" mechanism make use of this? 
Sorry, I do not understand your question.
PM QoS is only interested in the IRQs specified in the QoS request. If
there are no requests that need to be associated with an IRQ, then PM
QoS will not register for an affinity change notification.

>Not at all. Simply because it
>has no idea which interrupts are requested at any given time. Sure
>your answer will be "add another notifier" to solve that problem. But
>that's the completely wrong answer because notifiers are a PITA and
>should go away. Here is Linus' POV of notifiers and I really agree
>with it:
>
> "Notifiers are a disgrace, and almost all of them are a major design
>  mistake. They all have locking problems, the introduce internal
>  arbitrary API's that are hard to fix later (because you have random
>  people who decided to hook into them, which is the whole *point* of
>  those notifier chains)."
>
>And so I really fight that notifier chain tooth and nails until someone
>provides me a proper argument WHY it cant be solved with proper
>explicit and understandable mechanisms.
>
FWIW, I do not like notifications either. I feel it adds unpredictablity
to the system. If I didnt think, that NUMA and other systems might
benefit from per-cpu PM QoS feature, I would not have added this
notification mechanism and instead registered directly. I admit to
having not much of a knowledge about NUMA, but atleast PM QoS seems to
be architecture agnostic and all systems could use this generic kernel
feature.

Also, the notification added is restricted to PM QoS framework. The
smp-affinity notifications are not relayed to the driver making the PM
QoS request.

The way it is with per-cpu PM QoS is that the framework registers for
notification, *only* if there is a QoS request tagged with an IRQ. When
a request does not specify an IRQ, the QoS framework does not register
for any IRQ affinity notifications. Also, its possible that multiple
drivers may have a QoS request and could tag the same IRQ, in which
case, the notfication list helps. But surely, I can use other methods in
PM QoS to do the same thing, without the need for a notification list in
the IRQ framework. But that still doesnt solve for other systems that
may have NUMA or NIC drivers using per-cpu PM QoS.

When notified PM QoS updates its request list and amends the request
affinity and recalculates the target value. In this patch, I currently
update requests when the irq notifications are sent out.

>Back to your PM QoS trainwreck:
>
>I'm really impressed that you did not notice at all how inaccurate and
>therefor useless the affinity information which you are consulting is.
>
>Did it ever hit even the outer hemisphere of your brain, that
>irqdata.affinity is the affinity which was requested by the caller of
>an affinity setter function and not the effective affinity?
>
Yes and the effective affinity may not match up to irqdata.affinity,
but the only reliable information we have is irqdata.affinity. We are
trying to do the best with the information available. It still is better
than having no information about affinity.

>I bet it did not, simply because you did not pay any attention and
>bother to analyze that proper. Otherwise you would have tried to hack
>around this as well in some disgusting way.
>
>Really great savings, if the affinity is left at default to all cpus,
>but the effective affinity is a single cpu due to irq routing
>restrictions in the hardware.
>
>Surely you tested against single CPU affinities and achieved great
>results, but that's not a generic and useful solution.

Here is what needs to happen, before the power savings can be
beneficial.
	- Drivers specifying PM QoS request update their drivers to
	  track the request against an IRQ
	- SoCs that have a way of constraining the IRQ affinity to a
	  subset of cpus. Or may use an IRQ balancer or may be design
	  limited to have IRQs affine to a set of cpus.
	- Menu and other cpuidle governors consider per-cpu PM QoS in
	  determining the idle state of the cpu.

We may not see any benefit without all these in play on a given system.
Like you say, with single CPU affinity and with these changes, we do see
quite a bit of power savings from the performance cores.

Obviously, I seem to be doing it wrong with this change. I am ready to
amend and start over, if there are better ways to get affinity
information.

Thanks,
Lina

