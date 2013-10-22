Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab3JVToh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:44:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42963 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab3JVToe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:44:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
Cc: linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        davem@davemloft.net, cmetcalf@tilera.com, paulmck@linux.vnet.ibm.com
References: <8738o1ovdi.fsf@xmission.com>
	<1382107599-1028-1-git-send-email-guillaume.gaudonville@6wind.com>
	<87y55qqkck.fsf@xmission.com> <52669F51.8030003@6wind.com>
	<20131022165331.GA4118@linux.vnet.ibm.com>
	<8761spw3an.fsf@xmission.com>
Date: Tue, 22 Oct 2013 12:44:20 -0700
In-Reply-To: <8761spw3an.fsf@xmission.com> (Eric W. Biederman's message of
	"Tue, 22 Oct 2013 11:47:44 -0700")
Message-ID: <87iowprsyz.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19RxL+Hzz7T6ylhKCvohunQ+/ddbVMZGmU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0989]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH linux-next v2] ns: do not allocate a new nsproxy at each call
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To be succint.

Mutation of nsproxy in place was a distraction.

What is crucial to the current operation of the code is

synchronize_rcu();
put_pid_ns();
put_net_ns();
...

To remove the syncrhonize_rcu we would have to either user call_rcu or
make certain all of the namespaces have some kind of rcu liveness
guarantee (which many of them do) and use something like maybe_get_net.

If you are going to pursue this the maybe_get_net direction is my
preference as that is what we would need if we did not have nsproxy
and so will be simpler overall.

Hmm.  On the side of simple it may be appropriate to revisit the patch
that started using rcu protection for nsproxy.   I doesn't look like
the original reasons for nsproxy being rcu protected exist any more,
so reverting to task_lock protect may be enough..

And it would result in faster/simpler code that only slows down when we
perform a remote access, which should be far from common.

commit cf7b708c8d1d7a27736771bcf4c457b332b0f818
Author: Pavel Emelyanov <xemul@openvz.org>
Date:   Thu Oct 18 23:39:54 2007 -0700

    Make access to task's nsproxy lighter
    
    When someone wants to deal with some other taks's namespaces it has to lock
    the task and then to get the desired namespace if the one exists.  This is
    slow on read-only paths and may be impossible in some cases.
    
    E.g.  Oleg recently noticed a race between unshare() and the (sent for
    review in cgroups) pid namespaces - when the task notifies the parent it
    has to know the parent's namespace, but taking the task_lock() is
    impossible there - the code is under write locked tasklist lock.
    
    On the other hand switching the namespace on task (daemonize) and releasing
    the namespace (after the last task exit) is rather rare operation and we
    can sacrifice its speed to solve the issues above.
    
    The access to other task namespaces is proposed to be performed
    like this:
    
         rcu_read_lock();
         nsproxy = task_nsproxy(tsk);
         if (nsproxy != NULL) {
                 / *
                   * work with the namespaces here
                   * e.g. get the reference on one of them
                   * /
         } / *
             * NULL task_nsproxy() means that this task is
             * almost dead (zombie)
             * /
         rcu_read_unlock();
    
    This patch has passed the review by Eric and Oleg :) and,
    of course, tested.


Eric
