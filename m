Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944Ab3GLNsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:48:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46596 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861Ab3GLNsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:48:03 -0400
Date: Fri, 12 Jul 2013 14:48:11 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130712134811.GG20960@e103034-lin>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <51DC414F.5050900@linux.intel.com>
 <51DE9859.8090405@linux.vnet.ibm.com>
MIME-Version: 1.0
In-Reply-To: <51DE9859.8090405@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 Jul 2013 13:47:56.0995 (UTC) FILETIME=[6A47E130:01CE7F06]
X-MC-Unique: 113071214480000201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 12:34:49PM +0100, Preeti U Murthy wrote:
> Hi Morten,
> 
> I have a few quick comments.
> 
> On 07/09/2013 10:28 PM, Arjan van de Ven wrote:
> > On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
> >> Hi,
> >>
> >> This patch set is an initial prototype aiming at the overall power-aware
> >> scheduler design proposal that I previously described
> >> <http://permalink.gmane.org/gmane.linux.kernel/1508480>.
> >>
> >> The patch set introduces a cpu capacity managing 'power scheduler'
> >> which lives
> >> by the side of the existing (process) scheduler. Its role is to
> >> monitor the
> >> system load and decide which cpus that should be available to the process
> >> scheduler. Long term the power scheduler is intended to replace the
> >> currently
> >> distributed uncoordinated power management policies and will interface a
> >> unified platform specific power driver obtain power topology
> >> information and
> >> handle idle and P-states. The power driver interface should be made
> >> flexible
> >> enough to support multiple platforms including Intel and ARM.
> >>
> > I quickly browsed through it but have a hard time seeing what the
> > real interface is between the scheduler and the hardware driver.
> > What information does the scheduler give the hardware driver exactly?
> > e.g. what does it mean?
> > 
> > If the interface is "go faster please" or "we need you to be at fastest
> > now",
> > that doesn't sound too bad.
> > But if the interface is "you should be at THIS number" that is pretty
> > bad and
> > not going to work for us.
> > 
> > also, it almost looks like there is a fundamental assumption in the code
> > that you can get the current effective P state to make scheduler
> > decisions on;
> > on Intel at least that is basically impossible... and getting more so
> > with every generation
> > (likewise for AMD afaics)
> 
> I am concerned too about scheduler making its load balancing decisions
> based on the cpu frequency for the reason that it could create an
> imbalance in the load across cpus.
> 
> Scheduler could keep loading a cpu, because its cpu frequency goes on
> increasing, and it could keep un-loading a cpu because its cpu frequency
> goes on decreasing. This increase and decrease as an effect of the load
> itself. This is of course assuming that the driver would make its
> decisions proportional to the cpu load. There could be many more
> complications, if the driver makes its decisions on factors unknown to
> the scheduler.
> 
> Therefore my suggestion is that we should simply have the scheduler
> asking for increase/decrease in the frequency and letting it at that.

If I understand correctly your concern is about the effect of frequency
scaling on load-balancing when using tracked load (PJT's) for the task
loads as it is done in Alex Shi's patches.

That problem is present even with the existing cpufreq governors and has
not been addressed yet. Tasks on cpus at low frequencies appear bigger
since they run longer, which will cause the load-balancer to think the
cpu loaded and move tasks to other cpus. That will cause cpufreq to
lower the frequency of that cpu and make any remaining tasks look even
bigger. The story repeats itself.

One might be tempted to suggest to use arch_scale_freq_power to tell the
load-balancer about frequency scaling. But in its current form it will
actually make it worse, as cpu_power is currently used to indicate max
compute capacity and not the current one.

I don't understand how a simple up/down request from the scheduler would
solve that problem. It would just make frequency scaling slower if you
only go up or down one step at the time. Much like the existing
conservative cpufreq governor that nobody uses. Maybe I am missing
something?

I think we should look into scaling the tracked load by some metric that
represents the current performance of the cpu whenever the tracked load
is updated as it was suggested by Arjan in our previous discussion. I
included it in my power scheduler design proposal, but I haven't done
anything about it yet.

In short, I agree that there is a problem around load-balancing and
frequency scaling that needs to be fixed. Without Alex's patches the
problem is not present as task load doesn't depend on the cpu load of the
task.
 
> Secondly, I think we should spend more time on when to make a call to
> the frequency driver in your patchset regarding the change in the
> frequency of the CPU, the scheduler wishes to request. The reason being,
> the whole effort of integrating the knowledge of cpu frequency
> statistics into the scheduler is being done because the scheduler can
> call the frequency driver at times *complimenting* load balancing,
> unlike now.

I don't think I get your point here. The current policy in this patch
set is just a prototype that should be improved. The power scheduler
does complement the load-balancer already by asking for frequency
changes as the cpu load changes.

> 
> Also adding Rafael to the cc list.
> 

Thanks.

Morten

