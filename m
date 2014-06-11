Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaFKFwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 01:52:11 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36467 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaFKFwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 01:52:10 -0400
MIME-Version: 1.0
Date: Wed, 11 Jun 2014 02:52:09 -0300
Message-ID: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
Subject: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
From: Rafael Tinoco <rafael.tinoco@canonical.com>
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, ebiederm@xmission.com,
        Dave Chiluk <dave.chiluk@canonical.com>,
        Christopher Arges <chris.j.arges@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney, Eric Biederman, David Miller (and/or anyone else interested):

It was brought to my attention that netns creation/execution might
have suffered scalability/performance regression after v3.8.

I would like you, or anyone interested, to review these charts/data
and check if there is something that could be discussed/said before I
move further.

The following script was used for all the tests and charts generation:

====
#!/bin/bash
IP=/sbin/ip

function add_fake_router_uuid() {
    j=`uuidgen`
    $IP netns add bar-${j}
    $IP netns exec bar-${j} $IP link set lo up
    $IP netns exec bar-${j} sysctl -w net.ipv4.ip_forward=1 > /dev/null
    k=`echo $j | cut -b -11`
    $IP link add qro-${k} type veth peer name qri-${k} netns bar-${j}
    $IP link add qgo-${k} type veth peer name qgi-${k} netns bar-${j}
}

for i in `seq 1 $1`; do
    if [ `expr $i % 250` -eq 0 ]; then
        echo "$i by `date +%s`"
    fi
    add_fake_router_uuid
done
====

This script gives how many "fake routers" are added per second (from 0
to 3000 router creation mark, ex). With this and a git bisect on
kernel tree I was led to one specific commit causing
scalability/performance regression: #911af50 "rcu: Provide
compile-time control for no-CBs CPUs". Even Though this change was
experimental at that point, it introduced a performance scalability
regression (explained below) that still lasts.

RCU related code looked like to be responsible for the problem. With
that, every commit from tag v3.8 to master that changed any of this
files: "kernel/rcutree.c kernel/rcutree.h kernel/rcutree_plugin.h
include/trace/events/rcu.h include/linux/rcupdate.h" had the kernel
checked out/compiled/tested. The idea was to check performance
regression during rcu development, if that was the case. In the worst
case, the regression not being related to rcu, I would still have
chronological data to interpret.

All text below this refer to 2 groups of charts, generated during the study:

====
1) Kernel git tags from 3.8 to 3.14.
*** http://people.canonical.com/~inaddy/lp1328088/charts/250-tag.html ***

2) Kernel git commits for rcu development (111 commits) -> Clearly
shows regressions:
*** http://people.canonical.com/~inaddy/lp1328088/charts/250.html ***

Obs:

1) There is a general chart with 111 commits. With this chart you can
see performance evolution/regression on each test mark. Test mark goes
from 0 to 2500 and refers to "fake routers already created". Example:
Throughput was 50 routers/sec on 250 already created mark and 30
routers/sec on 1250 mark.

2) Clicking on a specific commit will give you that commit evolution
from 0 routers already created to 2500 routers already created mark.
====

Since there were differences in results, depending on how many cpus or
how the no-cb cpus were configured, 3 kernel config options were used
on every measure, for 1 and 4 cpus.

====
- CONFIG_RCU_NOCB_CPU (disabled): nocbno
- CONFIG_RCU_NOCB_CPU_ALL (enabled): nocball
- CONFIG_RCU_NOCB_CPU_NONE (enabled): nocbnone

Obs: For 1 cpu cases: nocbno, nocbnone, nocball behaves the same (or
should) since w/ only 1 cpu there is no no-cb cpu.
====

After charts being generated it was clear that NOCB_CPU_ALL (4 cpus)
affected the "fake routers" creation process performance and this
regression continues up to upstream version. It was also clear that,
after commit #911af50, having more than 1 cpu does not improve
performance/scalability for netns, makes it worse.

#911af50
====
...
+#ifdef CONFIG_RCU_NOCB_CPU_ALL
+ pr_info("\tExperimental no-CBs for all CPUs\n");
+ cpumask_setall(rcu_nocb_mask);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
...
====

Comparing standing out points (see charts):

#81e5949 - good
#911af50 - bad

I was able to see that, from the script above, the following lines
causes major impact on netns scalability/performance:

1) ip netns add -> huge performance regression:

 1 cpu: no regression
 4 cpu: regression for NOCB_CPU_ALL

 obs: regression from 250 netns/sec to 50 netns/sec on 500 netns
already created mark

2) ip netns exec -> some performance regression

 1 cpu: no regression
 4 cpu: regression for NOCB_CPU_ALL

 obs: regression from 40 netns (+1 exec per netns creation) to 20
netns/sec on 500 netns created mark

========

FULL NOTE: http://people.canonical.com/~inaddy/lp1328088/

** Assumption: RCU callbacks being offloaded to multiple cpus
(cpumask_setall) caused regression in
copy_net_ns<-created_new_namespaces or unshare(clone_newnet).

** Next Steps: I'll probably begin to function_graph netns creation execution
