Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbaFKPRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:17:45 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:52598 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaFKPRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:17:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140611133919.GZ4581@linux.vnet.ibm.com>
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
	<20140611133919.GZ4581@linux.vnet.ibm.com>
Date: Wed, 11 Jun 2014 12:17:43 -0300
Message-ID: <CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
Subject: Re: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
From: Rafael Tinoco <rafael.tinoco@canonical.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, ebiederm@xmission.com,
        Dave Chiluk <dave.chiluk@canonical.com>,
        Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am having a really hard time distinguishing the colors on both charts
> (yeah, red-green colorblind, go figure).  Any chance of brighter colors,
> patterned lines, or (better yet) the data in tabular form (for example,
> with the configuration choices as columns and the releases/commits
> as rows)?  That said, I must admire your thicket of linked charts,
> even if I cannot reliably distinguish the lines.

For now best option for me will be to generate charts on different colors
since this is not much time consuming and i can focus on other things.

> OK, I can apparently click on the color spots to eliminate some of
> the traces.  More on this later.
>
> In addition, two of the color spots at the top of the graphs do not have
> labels.  What are they?

Those 2 lines are only "fixing" a minimum and maximum (scale). They
should be always checked so you can keel same scale in any chart or
measure.
>
> What is a "250 MARK"?  250 fake netns routers?  OK, maybe this is
> the routers/sec below, though I have no idea what that might mean.
> (Laptops/sec?  Smartphones/sec?  Supercomputers/sec?)

This script simulates a failure on a cloud infrastructure, for ex. As soon as
one virtualization host fails all its network namespaces have to be migrated
to other node. Creating thousands of netns in the shortest time possible
is the objective here. This regression was observed trying to migrate from
v3.5 to v3.8+.

Script creates up to 3000/4000 thousands network namespaces and places
links on them. Every 250 mark (netns already created) we have a throughput
average (how many were created per second up from last mark to this one).

> You have the throughput apparently dropping all the way to zero, for
> example, for "Merge commit 8700c95adb03 into timers/nohz."  Really???

You can de-select all lines, but the affected one (even the 2 colors without
label). If you see "0,00" probably compilation did not generate a bootable
kernel for my testing tool. If you see something like "0,xx" it is probably a
serious regression.

Example:

http://people.canonical.com/~inaddy/lp1328088/charts/c0f4dfd4.html

If you select ONLY nocbno-4cpu and nocbnone-4cpu you will see that
nocbno has 0,09 (huge regression) and nocbnone has 0 (huge regression
or unbootable kernel).

> In addition, there should not be much in the way of change for the
> nocbno case, but I see the the nocbno-4cpu-250 line frequently dropping
> to zero.  Again, really???

Yes, it was observed and I thought it was weird also.

> Also, the four-CPU case is getting only about 2x the throughput of the
> one-CPU case.  Why such poor scaling?  Does this benchmark depend mostly
> on the grace-period latency or something?  (Given the routers/sec
> measure, I am thinking maybe so...)

I would say the four-CPU case is getting *half* of the throughput of the
one-CPU case (yes, i will generate charts with other colors, sorry). This
is my main intention here, to understand if this could be happening just
because of grace-period latency due to callbacks being offloaded (if it
makes sense). I'm starting to function_graph netns calls to check that.

> Do you have CONFIG_RCU_FAST_NO_HZ=y?  If so, please try setting it to n.

I have all 111 compiled kernels with CONFIG_RCU_FAST_NO_HZ=y. This is
probably because distributions try to configure a "fit-for-all-purposes" kernel
and this options makes sense for small devices and its energy consumption.

However I can get some commits that points out and recompile the kernel
again without this option to check if this would be beneficial. I'll
try to avoid
compiling everything again because it takes 5-7 days to compile and run
all the tests in all commits with all 3 config options on each (111 commits,
3 options = 333 kernels tested on 1 and 4 cpus).

Let me know if you have any specific commit you would like to see without
CONFIG_RCU_FAST_NO_HZ.

> Given that NOCB_CPU_ALL was designed primarily for real-time and HPC
> workloads, this is no surprise.  I am working on some changes to make
> it better behaved for other workloads based on a bug report from Rik.
> Something about certain distros having enabled it by default.  ;-)

:D Totally agree. Unfortunately having "nocbno" or "nocbnone" is also giving
us this performance regression (for netns, comparing to kernels <= 3.8). You
can check that on 250.html chart, on the last commit (recent).

Probably configuring rcu_nocbs would be the best scenario for a "general-
purpose" kernel.

Again, since the bisect showed regression for a specific rcu commit this was
the line of the "investigation". The regression could be tested manually also,
compiling before and after the bisect-bad commit.

>
> Well, before that commit, there was no such thing as CONFIG_RCU_NOCB_CPU_ALL,
> for one thing.  ;-)

Yes!! :D Im aware of that.. but i just did an automatized testing tool
for this and
make nconfig fixed my non-existent CONFIG_* options for kernels before that
specific commit.

> If you want to see the real CONFIG_RCU_NOCB_CPU_ALL effect before that
> commit, you need to use the rcu_nocbs= boot parameter.
>

Absolutely, I'll try with 2 or 3 commits before #911af50 just in case.

> Again, what you are seeing is the effect of callback offloading on
> a workload not particularly suited for it.  That said, I don't understand
> why you are seeing any particular effect when offloading is completely
> disabled unless your workload is sensitive to grace-period latency.
>

Wanted to make sure results were correctly. Starting to investigate netns
functions (copied some of netns developers here also). Totally agree
and this confirm my hypothesis.

>
> Some questions:
>
> o       Why does the throughput drop all the way to zero at various points?

Explained earlier. Check if it is 0.00 or 0.xx. 0.00 can mean unbootable kernel.

>
> o       What exactly is this benchmark doing?

Explained earlier. Simulating cloud infrastructure migrating netns on failure.

>
> o       Is this benchmark sensitive to grace-period latency?
>         (You can check this by changing the value of HZ, give or take.)

Will do that.

> o       How many runs were taken at each point?  If more than one, what
>         was the variability?

For all commits only one. For pointed out commits more then one.
Results tend to
be the same with minimum variation. Trying to balance efforts on digging into
the problem versus getting more results.

If you think, after my next answers (changing HZ, FAST_NOHZ) that
remeasuring everything is a must, let me know then I'll work on
deviation for you.

>
> o       Routers per second means what?

Explained earlier.

>
> o       How did you account for the effects of other non-RCU commits?
>         Did you rebase the RCU commits on top of an older release without
>         the other commits or something similar?

I used the Linus git tree, checking out specific commits and compiling the
kernel. I've only used commits that changed RCU because of the bisect
result. Besides these commits I have only generated kernel for main
release tags.

In my point of view, if this is related to RCU, several things have to be
discussed: Is using NOCB_CPU_ALL for a general purpose kernel a
good option ? Is netns code too dependent of grace-period low latency
to scale ? Is there a way of minimizing this ?

>                                                         Thanx, Paul

No Paul, I have to thank you. Really appreciate your time.

Rafael (tinoco@canonical/~inaddy)
