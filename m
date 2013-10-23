Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab3JWI1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:27:49 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:40883 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3JWI1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:27:44 -0400
Message-ID: <5267887B.3090307@6wind.com>
Date: Wed, 23 Oct 2013 10:27:39 +0200
From: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>, paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        davem@davemloft.net, cmetcalf@tilera.com
Subject: Re: [RFC PATCH linux-next v2] ns: do not allocate a new nsproxy at
 each call
References: <8738o1ovdi.fsf@xmission.com>	<1382107599-1028-1-git-send-email-guillaume.gaudonville@6wind.com>	<87y55qqkck.fsf@xmission.com> <52669F51.8030003@6wind.com>	<20131022165331.GA4118@linux.vnet.ibm.com>	<8761spw3an.fsf@xmission.com> <87iowprsyz.fsf@xmission.com>
In-Reply-To: <87iowprsyz.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 09:44 PM, Eric W. Biederman wrote:
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
>
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
Ok, let me think a bit of these new directions and I'll come back to you,
thanks for your help guys.
> commit cf7b708c8d1d7a27736771bcf4c457b332b0f818
> Author: Pavel Emelyanov <xemul@openvz.org>
> Date:   Thu Oct 18 23:39:54 2007 -0700
>
>      Make access to task's nsproxy lighter
>      
>      When someone wants to deal with some other taks's namespaces it has to lock
>      the task and then to get the desired namespace if the one exists.  This is
>      slow on read-only paths and may be impossible in some cases.
>      
>      E.g.  Oleg recently noticed a race between unshare() and the (sent for
>      review in cgroups) pid namespaces - when the task notifies the parent it
>      has to know the parent's namespace, but taking the task_lock() is
>      impossible there - the code is under write locked tasklist lock.
>      
>      On the other hand switching the namespace on task (daemonize) and releasing
>      the namespace (after the last task exit) is rather rare operation and we
>      can sacrifice its speed to solve the issues above.
>      
>      The access to other task namespaces is proposed to be performed
>      like this:
>      
>           rcu_read_lock();
>           nsproxy = task_nsproxy(tsk);
>           if (nsproxy != NULL) {
>                   / *
>                     * work with the namespaces here
>                     * e.g. get the reference on one of them
>                     * /
>           } / *
>               * NULL task_nsproxy() means that this task is
>               * almost dead (zombie)
>               * /
>           rcu_read_unlock();
>      
>      This patch has passed the review by Eric and Oleg :) and,
>      of course, tested.
>
>
> Eric

