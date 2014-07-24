Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbaGXOKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:10:04 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62382 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758890AbaGXOKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:10:01 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, mingo@kernel.org, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, preeti@linux.vnet.ibm.com,
        Dietmar.Eggemann@arm.com, pjt@google.com
Subject: Re: [RFCv2 PATCH 01/23] sched: Documentation for scheduler energy cost model
Date: Thu, 24 Jul 2014 16:28:27 +0200
Message-ID: <14224056.9QdYi5f1q1@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140724072609.GI3935@laptop>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com> <3288345.jvzVvqTJvD@vostro.rjw.lan> <20140724072609.GI3935@laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2014 09:26:09 AM Peter Zijlstra wrote:
> On Thu, Jul 24, 2014 at 02:53:20AM +0200, Rafael J. Wysocki wrote:
> > I am used to slightly different terminology here.  Namely, there are voltage
> > domains (parts sharing a voltage rail or a voltage regulator, such that you
> > can only apply/remove/change voltage to all of them at the same time) and clock
> > domains (analogously, but for clocks).  A power domain (which in your description
> > above seems to correspond to a voltage domain) may be a voltage domain, a clock
> > domain or a combination thereof.
> > 
> > In addition to that, in a voltage domain it may be possible to apply many
> > different levels of voltage, which case doesn't seem to be covered at all by
> > the above (or I'm missing something).
> > 
> > Also a P-state is not just a frequency level, but a combination of frequency
> > and voltage that has to be applied for that frequency to be stable.  You may
> > regard them as Operation Performance Points of the CPU, but that very well may
> > go beyond frequencies and voltages.  Thus it actually is better not to talk
> > about P-states as "frequencies".
> > 
> > Now, P-states may or may not have to be coordinated between all CPUs in a
> > package (cluster), by hardware or software, such that all CPUs in a cluster
> > need to be kept in the same P-state.  That you can regard as a "P-state
> > domain", but it usually means a specific combination of voltage and frequency.
> 
> I think Morton is aware of this, but for the sake of sanity dropped the
> whole lot into something simpler (while hoping reality would not ruin
> his life).
> 
> > C-states in turn are states in which CPUs don't execute instructions.
> > That need not mean the removal of voltage or even frequency from them.
> > Of course, they do mean some sort of power draw reduction, but that may
> > be achieved in many different ways.  Some C-states require coordination
> > too (for example, a single C-state may apply to a whole package or cluster
> > at the same time) and you can think about "domains" here too, but there
> > need not be a direct mapping to physical parameters such as the frequency
> > or the voltage.
> 
> One thing that wasn't clear to me is if you allow for C-domain and
> P-domain to overlap or if they're always inclusive (where one is wholly
> contained in the other).

On the CPUs I worked with so far they were always inclusive.  Previously, the
whole package was a P-state domain.  Today some CPUs (Haswell server chips
for example) have per-core P-states.

> > Moreover, P-states and C-states may overlap.  That is, a CPU may be in Px
> > and Cy at the same time, which means that after leaving Cy it will execute
> > instructions in Px.  Things like leakage may depend on x in that case and
> > the total power draw may depend on the combination of x and y.
> 
> Right, and I suppose the domain thing makes it impossible to drop to the
> lowest P state on going idle. Tricky that.

That's the case for older chips.  I'm not sure about the newest lot entirely
to be honest, need to ask.

> > The concern is that if a scaling governor is running in parallel with the above
> > algorithm and it has its own utilization goal (it usually does), it may change
> > the P-state under you to match that utilization goal and you'll end up with
> > something different from what you expected.
> > 
> > That may be addressed either by trying to predict what the scaling governor will
> > do (and good luck with that) or by taking care of P-states by yourself.  The
> > latter would require changes to the algorithm I think, though.
> 
> The idea was that we'll do P states ourselves based on these utilization
> figures. If we find we cannot fit the 'new' task into the current set
> without either raising P or waking an idle cpu (if at all available), we
> compute the cost of either option and pick the cheapest.

Yeah.  One subtle thing is that ramping up P may affect the other guys
(if the whole chip is a P-domain, for example), but I guess that can be
taken into account.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
