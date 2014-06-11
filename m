Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaFKXN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:13:27 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:47080 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaFKXNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:13:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: paulmck@linux.vnet.ibm.com
Cc: chiluk@canonical.com, Rafael Tinoco <rafael.tinoco@canonical.com>,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
	<20140611133919.GZ4581@linux.vnet.ibm.com>
	<CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
	<539879B8.4010204@canonical.com>
	<20140611161857.GC4581@linux.vnet.ibm.com>
	<53989F7B.6000004@canonical.com>
	<874mzr41kf.fsf@x220.int.ebiederm.org>
	<20140611225228.GO4581@linux.vnet.ibm.com>
Date: Wed, 11 Jun 2014 16:12:15 -0700
In-Reply-To: <20140611225228.GO4581@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Wed, 11 Jun 2014 15:52:28 -0700")
Message-ID: <87ioo7vy5s.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+lqUXktTbSJ8wBDM44P2MDOIhyzrs3OZ4=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4946]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;paulmck@linux.vnet.ibm.com
X-Spam-Relay-Country: 
Subject: Re: Possible netns creation and execution performance/scalability regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> On Wed, Jun 11, 2014 at 01:46:08PM -0700, Eric W. Biederman wrote:
>> On the chance it is dropping the old nsproxy which calls syncrhonize_rcu
>> in switch_task_namespaces that is causing you problems I have attached
>> a patch that changes from rcu_read_lock to task_lock for code that
>> calls task_nsproxy from a different task.  The code should be safe
>> and it should be an unquestions performance improvement but I have only
>> compile tested it.
>> 
>> If you can try the patch it will tell is if the problem is the rcu
>> access in switch_task_namespaces (the only one I am aware of network
>> namespace creation) or if the problem rcu case is somewhere else.
>> 
>> If nothing else knowing which rcu accesses are causing the slow down
>> seem important at the end of the day.
>> 
>> Eric
>> 
>
> If this is the culprit, another approach would be to use workqueues from
> RCU callbacks.  The following (untested, probably does not even build)
> patch illustrates one such approach.

For reference the only reason we are using rcu_lock today for nsproxy is
an old lock ordering problem that does not exist anymore.

I can say that in some workloads setns is a bit heavy today because of
the synchronize_rcu and setns is more important that I had previously
thought because pthreads break the classic unix ability to do things in
your process after fork() (sigh).

Today daemonize is gone, and notify the parent process with a signal
relies on task_active_pid_ns which does not use nsproxy.  So the old
lock ordering problem/race is gone.

The description of what was happening when the code switched from
task_lock to rcu_read_lock to protect nsproxy.

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
    
    [clg@fr.ibm.com: fix unshare()]
    [ebiederm@xmission.com: Update get_net_ns_by_pid]
    Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    Cc: Oleg Nesterov <oleg@tv-sign.ru>
    Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Serge Hallyn <serue@us.ibm.com>
    Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Eric
