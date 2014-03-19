Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbaCSOEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:04:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51441 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933380AbaCSOEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:04:07 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
Date: Wed, 19 Mar 2014 15:19:36 +0100
Message-ID: <19131121.D211TBerqb@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53296AD0.5090908@linux.vnet.ibm.com>
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com> <CAKohpomLW17B=Sk42tczzDF+VGwn7hT521osWPi5TcgqpCPZ_w@mail.gmail.com> <53296AD0.5090908@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 19, 2014 03:30:48 PM Srivatsa S. Bhat wrote:
> On 03/19/2014 10:33 AM, Viresh Kumar wrote:
> > On 18 March 2014 17:46, Srivatsa S. Bhat
> > <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> >> Agreed. As far as I understand, for ->target drivers, today we use GOV_STOP
> >> to stop managing the CPU going offline. And for ->setpolicy drivers, we will
> >> use this new callback to achieve the same goal.
> > 
> > So a better question would be: What's the purpose of ->stop() call for a policy?
> 
> Ideally, it should remove the outgoing CPU from the policy and "stop managing
> that CPU", whatever that means to the driver (for intel_pstate, it means
> setting it to min P state and destroying the timer).
> 
> > Stop managing CPUs of that policy?
> 
> Stop managing only the particular CPU going offline. IOW, we should somehow
> communicate to the ->stop() callback that we are taking CPU 'x' offline.
> 
> If adding a ->stop() callback in the cpufreq_driver is not the best way to
> achieve it, then lets think of an alternative. The way I look at it, this
> new mechanism what we want, should allow ->setpolicy drivers to do what the
> GOV_STOP will do for regular drivers. That is, allow it to "shutdown the
> CPU from a cpufreq perspective", whatever that means to the driver.
> We can think of a completely different way of achieving it, if ->stop()
> is not suitable for that purpose.

I agree.

That said, for the intel_pstate case ->stop() as proposed by Dirk is demonstrably
sufficient and there are no other ->setpolicy drivers in sight wanting or needing
anything else.

So to me, (1) the new ->stop() should *only* be called for ->setpolicy drivers,
because the purpose of it should be to "allow ->setpolicy drivers to do what the
GOV_STOP will do for regular drivers" as you put it above, and (2) some code in
the original intel_pstate's ->exit() may/should stay in there (instead of being
moved to the new ->stop()), which is the only possibly remaining issue here.

The whole discussion about possibly re-using ->stop() for ->target drivers goes
in a totally wrong direction, because *if* ->target drivers need a new callback
to be executed around where ->stop() is called for ->setpolicy drivers, *then*
that has to be a *different* callback.

And by the way, ->get() in fact has a different meaning for ->setpolicy drivers,
so it would be good to consider logical separation of ->setpolicy and ->target
drivers so that each kind has its own separate set of callbacks with no overlaps.
That would make it easier to avoid breakage resulting from changes made with
->setpolicy drivers that also affect ->target drivers in unpredictable ways and
the other way around.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
