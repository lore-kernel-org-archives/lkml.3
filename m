Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036Ab3FTI3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:29:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:59513 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab3FTI27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:28:59 -0400
Date: Thu, 20 Jun 2013 10:28:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        laijs@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/kthread.c: need spin_lock_irq() for 'worker'
 before main looping, since it can "WARN_ON(worker->task)".
In-Reply-To: <51C2B157.40806@asianux.com>
Message-ID: <alpine.DEB.2.02.1306200951090.4013@ionos.tec.linutronix.de>
References: <51C12D9A.8030801@asianux.com> <20130619084124.GF30681@mtj.dyndns.org> <51C18540.5060200@asianux.com> <20130619155218.GA14881@htj.dyndns.org> <51C26087.9000109@asianux.com> <alpine.DEB.2.02.1306200900030.4013@ionos.tec.linutronix.de>
 <51C2B157.40806@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Chen Gang wrote:

> On 06/20/2013 03:02 PM, Thomas Gleixner wrote:
> > On Thu, 20 Jun 2013, Chen Gang wrote:
> > 
> >> > On 06/19/2013 11:52 PM, Tejun Heo wrote:
> >>> > > On Wed, Jun 19, 2013 at 06:17:36PM +0800, Chen Gang wrote:
> >>>>> > >> > Hmm... can 'worker->task' has chance to be not NULL before set 'current'
> >>>>> > >> > to it ?
> >>> > > Yes, if the caller screws up and try to attach more than one workers
> >>> > > to the kthread_worker, which has some possibility of happening as
> >>> > > kthread_worker allows both attaching and detaching a worker.
> >>> > > 
> >> > 
> >> > If we detect the bugs, and still want to use WARN_ON() to report warning
> >> > and continue running, we need be sure of keeping the related things no
> >> > touch (at least not lead to worse).
> >> > 
> >> > If we can not be sure of keeping the related things no touch:
> >> >   if it is a kernel bug, better use BUG_ON() instead of,
> >> >   if it is a user mode bug, better to return failure with error code and
> >> > print related information.
> > Wrong. BUG_ON() is only for cases where the kernel CANNOT continue at
> > all. WARN_ON() prints the very same information, but allows to
> > continue.
> > 
> 
> In fact, BUG_ON() and WARN_ON() has various implementations in different
> architectures, and also can be configured by user.

And how is that relevant? 
 
> Even some of 'crazy users' (e.g. randconfig), can make BUG_ON() and
> WARN_ON() 'empty' (include/asm-generic/bug.h).

That does not matter at all.
 
> In my experience (mainly for servers), when find a kernel bug, it will
> stop and report bug, that will let coredump analysing (or KDB trap) much
> easier.

And your core dump will help you in what way? The code which
misbehaved is not longer executing. The problem is detected after the
fact and therefor your coredump will just tell you that worker->task
is not NULL.
 
> >> > BUG_ON() will stop current working flow and report kernel bug in details.
> > There is no reason to crash the machine completely. The kernel can
> > continue and the WARN_ON reports the bug with the same details.

Linus said about BUG_ON():

  Adding BUG_ON()'s just makes things much much much worse. There is
  *never* a reason to add a BUG_ON().
  
  BUG_ON() makes it almost impossible to debug something, because you
  just killed the machine. So using BUG_ON() for "please notice this"
  is stupid as hell, because the most common end result is: "Oh, the
  machine just hung with no messages".

And he is right about that. 
 
> If so (we still prefer to use WARN_ON), we'd better to let it in lock
> protected.

No, because the lock is not protecting anything in that case. If some
other code misbehaves and sets worker->task, then the lock does not
prevent this and taking the lock is not making the WARN_ON any more
reliable. So why the heck should we take it?
 
> At least when we still have to continue, try not to lead things worse.

And what's going to be better if we take the lock? Nothing, because
the lock CANNOT protect the check.
 
> It will provide much help for coredump analysing (or KDB trap).
> 
> In fact, for coredump analysers, for every real world coredump, they
> have to assume the system has already continued blindly, and then die.

Core dump analysers cannot analyse dynamic race conditions and neither
can KDB. 

So what do you gain from crashing the kernel? Exactly NOTHING.

Thanks,

	tglx
