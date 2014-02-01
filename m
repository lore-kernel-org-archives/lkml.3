Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272AbaBAPkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 10:40:31 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55102 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaBAPk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 10:40:29 -0500
Date: Sat, 1 Feb 2014 15:40:21 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: "Brown, Len" <len.brown@intel.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Preeti Murthy <preeti.lkml@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct rq
Message-ID: <20140201154021.GA7827@e102568-lin.cambridge.arm.com>
References: <20140130163501.GG5002@laptop.programming.kicks-ass.net>
 <52EA8B07.6020206@linaro.org>
 <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com>
 <20140131090230.GM5002@laptop.programming.kicks-ass.net>
 <52EB6F65.8050008@linux.vnet.ibm.com>
 <52EBBC23.8020603@linux.intel.com>
 <52EBC33A.6080101@linaro.org>
 <52EBC645.2040607@linux.intel.com>
 <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr>
 <1A7043D5F58CCB44A599DFD55ED4C948452D34DC@FMSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <1A7043D5F58CCB44A599DFD55ED4C948452D34DC@FMSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 01 Feb 2014 15:40:26.0025 (UTC) FILETIME=[ED492190:01CF1F63]
X-MC-Unique: 114020115402601401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 01, 2014 at 06:00:40AM +0000, Brown, Len wrote:
> > Right now (on ARM at least but I imagine this is pretty universal), the
> > biggest impact on information accuracy for a CPU depends on what the
> > other CPUs are doing.  The most obvious example is cluster power down.
> > For a cluster to be powered down, all the CPUs sharing this cluster must
> > also be powered down.  And all those CPUs must have agreed to a possible
> > cluster power down in advance as well.  But it is not because an idle
> > CPU has agreed to the extra latency imposed by a cluster power down that
> > the cluster has actually powered down since another CPU in that cluster
> > might still be running, in which case the recorded latency information
> > for that idle CPU would be higher than it would be in practice at that
> > moment.
> 
> That will not work.
> 
> When a CPU goes idle, it uses the CURRENT criteria for entering that state.
> If the criteria change after it has entered the state, are you going
> to wake it up so it can re-evaluate?  No.
> 
> That is why the state must describe the worst case latency
> that CPU may see when waking from the state on THAT entry.
> 
> That is why we use the package C-state numbers to describe
> core C-states on IA.

That's what we do on ARM too for cluster states. But the state decision
might turn out suboptimal in this case too for the same reasons you have
just mentioned.

There are some use cases when it matters (and where monitoring the
timers on all CPUs in a cluster shows that aborting cluster shutdown is
required because some CPUs have a pending timer and the governor decision is
stale), there are some use cases where it does not matter at all.

We talked about this at LPC and I guess x86 FW/HW plays a role in
package states demotion too, we can do it in FW on ARM.

Overall we all know that whatever we do, it is impossible to know the
precise C-state a CPU is in, even if we resort to HW probing, it is just
a matter of deciding what level of abstraction is necessary for the
scheduler to work properly.

Thanks for bringing this topic up.

Lorenzo

