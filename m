Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbaA3Rub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:50:31 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39427 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaA3Ru3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:50:29 -0500
Date: Thu, 30 Jan 2014 17:50:24 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct rq
Message-ID: <20140130175024.GD8389@e102568-lin.cambridge.arm.com>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org>
 <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org>
 <20140130153150.GD5002@laptop.programming.kicks-ass.net>
 <52EA7D8A.6080604@linaro.org>
 <20140130163501.GG5002@laptop.programming.kicks-ass.net>
 <52EA8B07.6020206@linaro.org>
MIME-Version: 1.0
In-Reply-To: <52EA8B07.6020206@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 30 Jan 2014 17:50:25.0149 (UTC) FILETIME=[C11982D0:01CF1DE3]
X-MC-Unique: 114013017502701701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 05:25:27PM +0000, Daniel Lezcano wrote:
> On 01/30/2014 05:35 PM, Peter Zijlstra wrote:
> > On Thu, Jan 30, 2014 at 05:27:54PM +0100, Daniel Lezcano wrote:
> >> struct cpuidle_state *state = &drv->states[rq->index];
> >>
> >> And from the state, we have the following informations:
> >>
> >> struct cpuidle_state {
> >>
> >> 	[ ... ]
> >>
> >>          unsigned int    exit_latency; /* in US */
> >>          int             power_usage; /* in mW */
> >>          unsigned int    target_residency; /* in US */
> >>          bool            disabled; /* disabled on all CPUs */
> >>
> >> 	[ ... ]
> >> };
> >
> > Right, but can we say that a higher index will save more power and have
> > a higher exit latency? Or is a driver free to have a random mapping from
> > idle_index to state?
> 
> If the driver does its own random mapping that will break the governor 
> logic. So yes, the states are ordered, the higher the index is, the more 
> you save power and the higher the exit latency is.
> 
> > Also, we should probably create a pretty function to get that state,
> > just like you did in patch 1.
> 
> Yes, right.
> 
> >> IIRC, Alex Shi sent a patchset to improve the choosing of the idlest cpu and
> >> the exit_latency was needed.
> >
> > Right. However if we have a 'natural' order in the state array the index
> > itself might often be sufficient to find the least idle state, in this
> > specific case the absolute exit latency doesn't matter, all we want is
> > the lowest one.
> 
> Indeed. It could be simple as that. I feel we may need more informations 
> in the future but comparing the indexes could be a nice simple and 
> efficient solution.

As long as we take into account that some states might require multiple
CPUs to be idle in order to be entered, fine by me. But we should
certainly avoid waking up a CPU in a cluster that is in eg C2 (all CPUs in
C2, so cluster in C2) when there are CPUs in C3 in other clusters with
some CPUs running in those clusters, because there C3 means "CPU in C3, not
cluster in C3". Overall what I am saying is that what you are doing
makes perfect sense but we have to take the above into account.

Some states have CPU and cluster (or we can call it package) components,
and that's true on ARM and other architectures too, to the best of my
knowledge.

Lorenzo

