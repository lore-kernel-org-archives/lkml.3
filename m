Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaA3VCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:02:20 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:39104 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaA3VCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:02:18 -0500
Date: Thu, 30 Jan 2014 16:02:15 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
In-Reply-To: <20140130175024.GD8389@e102568-lin.cambridge.arm.com>
Message-ID: <alpine.LFD.2.11.1401301533390.1652@knanqh.ubzr>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org> <20140130153150.GD5002@laptop.programming.kicks-ass.net> <52EA7D8A.6080604@linaro.org> <20140130163501.GG5002@laptop.programming.kicks-ass.net>
 <52EA8B07.6020206@linaro.org> <20140130175024.GD8389@e102568-lin.cambridge.arm.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Lorenzo Pieralisi wrote:

> On Thu, Jan 30, 2014 at 05:25:27PM +0000, Daniel Lezcano wrote:
> > On 01/30/2014 05:35 PM, Peter Zijlstra wrote:
> > > On Thu, Jan 30, 2014 at 05:27:54PM +0100, Daniel Lezcano wrote:
> > >> IIRC, Alex Shi sent a patchset to improve the choosing of the idlest cpu and
> > >> the exit_latency was needed.
> > >
> > > Right. However if we have a 'natural' order in the state array the index
> > > itself might often be sufficient to find the least idle state, in this
> > > specific case the absolute exit latency doesn't matter, all we want is
> > > the lowest one.
> > 
> > Indeed. It could be simple as that. I feel we may need more informations 
> > in the future but comparing the indexes could be a nice simple and 
> > efficient solution.
> 
> As long as we take into account that some states might require multiple
> CPUs to be idle in order to be entered, fine by me. But we should
> certainly avoid waking up a CPU in a cluster that is in eg C2 (all CPUs in
> C2, so cluster in C2) when there are CPUs in C3 in other clusters with
> some CPUs running in those clusters, because there C3 means "CPU in C3, not
> cluster in C3". Overall what I am saying is that what you are doing
> makes perfect sense but we have to take the above into account.
> 
> Some states have CPU and cluster (or we can call it package) components,
> and that's true on ARM and other architectures too, to the best of my
> knowledge.

The notion of cluster or package maps pretty naturally onto scheduling 
domains.  And the search for an idle CPU to wake up should avoid a 
scheduling domain with a load of zero (which is obviously a prerequisite 
for a power save mode to be applied to the cluster level) if there exist 
idle CPUs in another domain already which load is not zero (all other 
considerations being equal).  Hence your concern would be addressed 
without any particular issue even if the individual CPU idle state index 
is not exactly in sync with reality because of other hardware related 
constraints.

The other solution consists in making the index dynamic.  That means 
letting backend idle drivers change it i.e. when the last man in a 
cluster goes idle it could update the index for all the other CPUs in 
the cluster.  There is no locking needed as the scheduler is only 
consuming this info, and the scheduler getting it wrong on rare 
occasions is not a big deal either.  But that looks pretty ugly as at 
least 2 levels of abstractions would be breached in this case.


Nicolas
