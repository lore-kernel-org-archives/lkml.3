Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbaFKNj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:39:27 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45232 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaFKNjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:39:25 -0400
Date: Wed, 11 Jun 2014 06:39:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rafael Tinoco <rafael.tinoco@canonical.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, ebiederm@xmission.com,
        Dave Chiluk <dave.chiluk@canonical.com>,
        Christopher Arges <chris.j.arges@canonical.com>
Subject: Re: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
Message-ID: <20140611133919.GZ4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061113-3532-0000-0000-000002678CE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 02:52:09AM -0300, Rafael Tinoco wrote:
> Paul E. McKenney, Eric Biederman, David Miller (and/or anyone else interested):
> 
> It was brought to my attention that netns creation/execution might
> have suffered scalability/performance regression after v3.8.
> 
> I would like you, or anyone interested, to review these charts/data
> and check if there is something that could be discussed/said before I
> move further.
> 
> The following script was used for all the tests and charts generation:
> 
> ====
> #!/bin/bash
> IP=/sbin/ip
> 
> function add_fake_router_uuid() {
>     j=`uuidgen`
>     $IP netns add bar-${j}
>     $IP netns exec bar-${j} $IP link set lo up
>     $IP netns exec bar-${j} sysctl -w net.ipv4.ip_forward=1 > /dev/null
>     k=`echo $j | cut -b -11`
>     $IP link add qro-${k} type veth peer name qri-${k} netns bar-${j}
>     $IP link add qgo-${k} type veth peer name qgi-${k} netns bar-${j}
> }
> 
> for i in `seq 1 $1`; do
>     if [ `expr $i % 250` -eq 0 ]; then
>         echo "$i by `date +%s`"
>     fi
>     add_fake_router_uuid
> done
> ====
> 
> This script gives how many "fake routers" are added per second (from 0
> to 3000 router creation mark, ex). With this and a git bisect on
> kernel tree I was led to one specific commit causing
> scalability/performance regression: #911af50 "rcu: Provide
> compile-time control for no-CBs CPUs". Even Though this change was
> experimental at that point, it introduced a performance scalability
> regression (explained below) that still lasts.
> 
> RCU related code looked like to be responsible for the problem. With
> that, every commit from tag v3.8 to master that changed any of this
> files: "kernel/rcutree.c kernel/rcutree.h kernel/rcutree_plugin.h
> include/trace/events/rcu.h include/linux/rcupdate.h" had the kernel
> checked out/compiled/tested. The idea was to check performance
> regression during rcu development, if that was the case. In the worst
> case, the regression not being related to rcu, I would still have
> chronological data to interpret.
> 
> All text below this refer to 2 groups of charts, generated during the study:
> 
> ====
> 1) Kernel git tags from 3.8 to 3.14.
> *** http://people.canonical.com/~inaddy/lp1328088/charts/250-tag.html ***
> 
> 2) Kernel git commits for rcu development (111 commits) -> Clearly
> shows regressions:
> *** http://people.canonical.com/~inaddy/lp1328088/charts/250.html ***

I am having a really hard time distinguishing the colors on both charts
(yeah, red-green colorblind, go figure).  Any chance of brighter colors,
patterned lines, or (better yet) the data in tabular form (for example,
with the configuration choices as columns and the releases/commits
as rows)?  That said, I must admire your thicket of linked charts,
even if I cannot reliably distinguish the lines.

OK, I can apparently click on the color spots to eliminate some of
the traces.  More on this later.

In addition, two of the color spots at the top of the graphs do not have
labels.  What are they?

What is a "250 MARK"?  250 fake netns routers?  OK, maybe this is
the routers/sec below, though I have no idea what that might mean.
(Laptops/sec?  Smartphones/sec?  Supercomputers/sec?)

You have the throughput apparently dropping all the way to zero, for
example, for "Merge commit 8700c95adb03 into timers/nohz."  Really???

> Obs:
> 
> 1) There is a general chart with 111 commits. With this chart you can
> see performance evolution/regression on each test mark. Test mark goes
> from 0 to 2500 and refers to "fake routers already created". Example:
> Throughput was 50 routers/sec on 250 already created mark and 30
> routers/sec on 1250 mark.
> 
> 2) Clicking on a specific commit will give you that commit evolution
> from 0 routers already created to 2500 routers already created mark.
> ====
> 
> Since there were differences in results, depending on how many cpus or
> how the no-cb cpus were configured, 3 kernel config options were used
> on every measure, for 1 and 4 cpus.
> 
> ====
> - CONFIG_RCU_NOCB_CPU (disabled): nocbno
> - CONFIG_RCU_NOCB_CPU_ALL (enabled): nocball
> - CONFIG_RCU_NOCB_CPU_NONE (enabled): nocbnone
> 
> Obs: For 1 cpu cases: nocbno, nocbnone, nocball behaves the same (or
> should) since w/ only 1 cpu there is no no-cb cpu.

In addition, there should not be much in the way of change for the
nocbno case, but I see the the nocbno-4cpu-250 line frequently dropping
to zero.  Again, really???

Also, the four-CPU case is getting only about 2x the throughput of the
one-CPU case.  Why such poor scaling?  Does this benchmark depend mostly
on the grace-period latency or something?  (Given the routers/sec
measure, I am thinking maybe so...)

Do you have CONFIG_RCU_FAST_NO_HZ=y?  If so, please try setting it to n.

> ====
> 
> After charts being generated it was clear that NOCB_CPU_ALL (4 cpus)
> affected the "fake routers" creation process performance and this
> regression continues up to upstream version.

Given that NOCB_CPU_ALL was designed primarily for real-time and HPC
workloads, this is no surprise.  I am working on some changes to make
it better behaved for other workloads based on a bug report from Rik.
Something about certain distros having enabled it by default.  ;-)

>                                              It was also clear that,
> after commit #911af50, having more than 1 cpu does not improve
> performance/scalability for netns, makes it worse.

Well, before that commit, there was no such thing as CONFIG_RCU_NOCB_CPU_ALL,
for one thing.  ;-)

If you want to see the real CONFIG_RCU_NOCB_CPU_ALL effect before that
commit, you need to use the rcu_nocbs= boot parameter.

> #911af50
> ====
> ...
> +#ifdef CONFIG_RCU_NOCB_CPU_ALL
> + pr_info("\tExperimental no-CBs for all CPUs\n");
> + cpumask_setall(rcu_nocb_mask);
> +#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
> ...
> ====
> 
> Comparing standing out points (see charts):
> 
> #81e5949 - good
> #911af50 - bad
> 
> I was able to see that, from the script above, the following lines
> causes major impact on netns scalability/performance:
> 
> 1) ip netns add -> huge performance regression:
> 
>  1 cpu: no regression
>  4 cpu: regression for NOCB_CPU_ALL
> 
>  obs: regression from 250 netns/sec to 50 netns/sec on 500 netns
> already created mark
> 
> 2) ip netns exec -> some performance regression
> 
>  1 cpu: no regression
>  4 cpu: regression for NOCB_CPU_ALL
> 
>  obs: regression from 40 netns (+1 exec per netns creation) to 20
> netns/sec on 500 netns created mark

Again, what you are seeing is the effect of callback offloading on
a workload not particularly suited for it.  That said, I don't understand
why you are seeing any particular effect when offloading is completely
disabled unless your workload is sensitive to grace-period latency.

> ========
> 
> FULL NOTE: http://people.canonical.com/~inaddy/lp1328088/
> 
> ** Assumption: RCU callbacks being offloaded to multiple cpus
> (cpumask_setall) caused regression in
> copy_net_ns<-created_new_namespaces or unshare(clone_newnet).
> 
> ** Next Steps: I'll probably begin to function_graph netns creation execution

Some questions:

o	Why does the throughput drop all the way to zero at various points?

o	What exactly is this benchmark doing?

o	Is this benchmark sensitive to grace-period latency?
	(You can check this by changing the value of HZ, give or take.)

o	How many runs were taken at each point?  If more than one, what
	was the variability?

o	Routers per second means what?

o	How did you account for the effects of other non-RCU commits?
	Did you rebase the RCU commits on top of an older release without
	the other commits or something similar?

							Thanx, Paul

