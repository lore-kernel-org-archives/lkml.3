Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaFKHIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:08:38 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:36432 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbaFKHIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:08:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rafael Tinoco <rafael.tinoco@canonical.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Dave Chiluk <dave.chiluk@canonical.com>,
        Christopher Arges <chris.j.arges@canonical.com>
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
Date: Wed, 11 Jun 2014 00:07:29 -0700
In-Reply-To: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
	(Rafael Tinoco's message of "Wed, 11 Jun 2014 02:52:09 -0300")
Message-ID: <87mwdj6i1a.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX195DiNpTG/3qI0kzEVF8EeWft3KdIzkzbQ=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4702]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rafael Tinoco <rafael.tinoco@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: Possible netns creation and execution performance/scalability regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael Tinoco <rafael.tinoco@canonical.com> writes:

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

[snip long explanation]

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

copy_netns except possibly in the per_net callbacks does not use
rcu so I am mystified.  So a little more digging to figure out which
rcu usage is causing the problem would be very interesting.

> 2) ip netns exec -> some performance regression
>
>  1 cpu: no regression
>  4 cpu: regression for NOCB_CPU_ALL
>
>  obs: regression from 40 netns (+1 exec per netns creation) to 20
> netns/sec on 500 netns created mark

The performance regression is probably in setns().
switch_task_namespaces is occassionaly a choke point.

At one point I was playing with ideas on how to use the task lock
instead of rcu to protect nsproxy.  As the original reason we could
not use task_lock appeared to have disappeared.

That could be worth playing with.


> ========
>
> FULL NOTE: http://people.canonical.com/~inaddy/lp1328088/
>
> ** Assumption: RCU callbacks being offloaded to multiple cpus
> (cpumask_setall) caused regression in
> copy_net_ns<-created_new_namespaces or unshare(clone_newnet).
>
> ** Next Steps: I'll probably begin to function_graph netns creation execution

Eric


