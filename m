Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaF0MfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:35:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaF0MfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:35:07 -0400
Date: Fri, 27 Jun 2014 08:35:03 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] target: fix deadlock on unload
In-Reply-To: <1403842714.22367.8.camel@haakon3.risingtidesystems.com>
Message-ID: <alpine.LRH.2.02.1406270816160.24505@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1406231329430.8277@file01.intranet.prod.int.rdu2.redhat.com> <1403842714.22367.8.camel@haakon3.risingtidesystems.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jun 2014, Nicholas A. Bellinger wrote:

> Hi Mikulas,
> 
> On Mon, 2014-06-23 at 13:42 -0400, Mikulas Patocka wrote:
> > target: fix deadlock on unload
> > 
> > On uniprocessor preemptible kernel, target core deadlocks on unload. The
> > following events happen:
> > * iscsit_del_np is called
> > * it calls send_sig(SIGINT, np->np_thread, 1);
> > * the scheduler switches to the np_thread
> > * the np_thread is woken up, it sees that kthread_should_stop() returns
> >   false, so it doesn't terminate
> > * the np_thread clears signals with flush_signals(current); and goes back
> >   to sleep in iscsit_accept_np
> > * the scheduler switches back to iscsit_del_np
> > * iscsit_del_np calls kthread_stop(np->np_thread);
> > * the np_thread is waiting in iscsit_accept_np and it doesn't respond to
> >   kthread_stop
> > 
> > The deadlock could be resolved if the administrator sends SIGINT signal to
> > the np_thread with killall -INT iscsi_np
> > 
> > The reproducible deadlock was introduced in commit
> > db6077fd0b7dd41dc6ff18329cec979379071f87, but the thread-stopping code was
> > racy even before.
> > 
> > This patch fixes the problem. Using kthread_should_stop to stop the
> > np_thread is unreliable, so we test np_thread_state instead. If
> > np_thread_state equals ISCSI_NP_THREAD_SHUTDOWN, the thread exits.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> > 
> 
> Apologies for the delayed response..
> 
> Applied to target-pending/master and including in the next -rc3 PULL
> request.
> 
> Also FYI, I've added '3.12+' to the stable tag to match how far back
> commit db6077fd0 has been included in stable.
> 
> Thanks,
> 
> --nab

Hi

I think db6077fd0 should be backported to stable kernels beginning with 
3.10 (because they set np->np_thread = NULL in 
__iscsi_target_login_thread). The current 3.10-stable branch misses this 
patch.


This patch for unload deadlock should be backported to all stable kernels 
(because unload is racy there), but because of different code, we should 
make a different patch for old stable branches.

For example in 3.4.95, __iscsi_target_login_thread contains this code:
        spin_lock_bh(&np->np_thread_lock);
        if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
                np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
                complete(&np->np_restart_comp);
        } else {
                np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
        }
        spin_unlock_bh(&np->np_thread_lock);
If the state is ISCSI_NP_THREAD_SHUTDOWN, the above piece of code will 
change it to ISCSI_NP_THREAD_ACTIVE and open the same kthread_should_stop 
race.

Mikulas
