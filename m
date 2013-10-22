Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3JVVmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:42:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51567 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3JVVmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:42:38 -0400
Date: Tue, 22 Oct 2013 14:42:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>,
        linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        davem@davemloft.net, cmetcalf@tilera.com
Subject: Re: [RFC PATCH linux-next v2] ns: do not allocate a new nsproxy at
 each call
Message-ID: <20131022214232.GD4118@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <8738o1ovdi.fsf@xmission.com>
 <1382107599-1028-1-git-send-email-guillaume.gaudonville@6wind.com>
 <87y55qqkck.fsf@xmission.com>
 <52669F51.8030003@6wind.com>
 <20131022165331.GA4118@linux.vnet.ibm.com>
 <8761spw3an.fsf@xmission.com>
 <87iowprsyz.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iowprsyz.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102221-1542-0000-0000-000002850B77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 12:44:20PM -0700, Eric W. Biederman wrote:
> 
> To be succint.
> 
> Mutation of nsproxy in place was a distraction.
> 
> What is crucial to the current operation of the code is
> 
> synchronize_rcu();
> put_pid_ns();
> put_net_ns();
> ...
> 
> To remove the syncrhonize_rcu we would have to either user call_rcu or
> make certain all of the namespaces have some kind of rcu liveness
> guarantee (which many of them do) and use something like maybe_get_net.

You beat me to the call_rcu() suggestion.  If the callback needs to
do something that might sleep, the usual trick is a workqueue scheduled
from the RCU callback.

> If you are going to pursue this the maybe_get_net direction is my
> preference as that is what we would need if we did not have nsproxy
> and so will be simpler overall.
> 
> Hmm.  On the side of simple it may be appropriate to revisit the patch
> that started using rcu protection for nsproxy.   I doesn't look like
> the original reasons for nsproxy being rcu protected exist any more,
> so reverting to task_lock protect may be enough..
> 
> And it would result in faster/simpler code that only slows down when we
> perform a remote access, which should be far from common.

That can be a good option, also.  ;-)

							Thanx, Paul

> commit cf7b708c8d1d7a27736771bcf4c457b332b0f818
> Author: Pavel Emelyanov <xemul@openvz.org>
> Date:   Thu Oct 18 23:39:54 2007 -0700
> 
>     Make access to task's nsproxy lighter
>     
>     When someone wants to deal with some other taks's namespaces it has to lock
>     the task and then to get the desired namespace if the one exists.  This is
>     slow on read-only paths and may be impossible in some cases.
>     
>     E.g.  Oleg recently noticed a race between unshare() and the (sent for
>     review in cgroups) pid namespaces - when the task notifies the parent it
>     has to know the parent's namespace, but taking the task_lock() is
>     impossible there - the code is under write locked tasklist lock.
>     
>     On the other hand switching the namespace on task (daemonize) and releasing
>     the namespace (after the last task exit) is rather rare operation and we
>     can sacrifice its speed to solve the issues above.
>     
>     The access to other task namespaces is proposed to be performed
>     like this:
>     
>          rcu_read_lock();
>          nsproxy = task_nsproxy(tsk);
>          if (nsproxy != NULL) {
>                  / *
>                    * work with the namespaces here
>                    * e.g. get the reference on one of them
>                    * /
>          } / *
>              * NULL task_nsproxy() means that this task is
>              * almost dead (zombie)
>              * /
>          rcu_read_unlock();
>     
>     This patch has passed the review by Eric and Oleg :) and,
>     of course, tested.
> 
> 
> Eric
> 

