Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3FTJhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:37:39 -0400
Received: from intranet.asianux.com ([58.214.24.6]:4715 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab3FTJhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:37:37 -0400
X-Spam-Score: -100.8
Message-ID: <51C2CD2D.1090400@asianux.com>
Date: Thu, 20 Jun 2013 17:36:45 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        laijs@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/kthread.c: need spin_lock_irq() for 'worker' before
 main looping, since it can "WARN_ON(worker->task)".
References: <51C12D9A.8030801@asianux.com> <20130619084124.GF30681@mtj.dyndns.org> <51C18540.5060200@asianux.com> <20130619155218.GA14881@htj.dyndns.org> <51C26087.9000109@asianux.com> <alpine.DEB.2.02.1306200900030.4013@ionos.tec.linutronix.de> <51C2B157.40806@asianux.com> <alpine.DEB.2.02.1306200951090.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306200951090.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 04:28 PM, Thomas Gleixner wrote:
> On Thu, 20 Jun 2013, Chen Gang wrote:
> 
>> > On 06/20/2013 03:02 PM, Thomas Gleixner wrote:
>>> > > On Thu, 20 Jun 2013, Chen Gang wrote:
>>> > > 
>>>>> > >> > On 06/19/2013 11:52 PM, Tejun Heo wrote:
>>>>>>> > >>> > > On Wed, Jun 19, 2013 at 06:17:36PM +0800, Chen Gang wrote:
>>>>>>>>>>> > >>>>> > >> > Hmm... can 'worker->task' has chance to be not NULL before set 'current'
>>>>>>>>>>> > >>>>> > >> > to it ?
>>>>>>> > >>> > > Yes, if the caller screws up and try to attach more than one workers
>>>>>>> > >>> > > to the kthread_worker, which has some possibility of happening as
>>>>>>> > >>> > > kthread_worker allows both attaching and detaching a worker.
>>>>>>> > >>> > > 
>>>>> > >> > 
>>>>> > >> > If we detect the bugs, and still want to use WARN_ON() to report warning
>>>>> > >> > and continue running, we need be sure of keeping the related things no
>>>>> > >> > touch (at least not lead to worse).
>>>>> > >> > 
>>>>> > >> > If we can not be sure of keeping the related things no touch:
>>>>> > >> >   if it is a kernel bug, better use BUG_ON() instead of,
>>>>> > >> >   if it is a user mode bug, better to return failure with error code and
>>>>> > >> > print related information.
>>> > > Wrong. BUG_ON() is only for cases where the kernel CANNOT continue at
>>> > > all. WARN_ON() prints the very same information, but allows to
>>> > > continue.
>>> > > 
>> > 
>> > In fact, BUG_ON() and WARN_ON() has various implementations in different
>> > architectures, and also can be configured by user.
> And how is that relevant? 
>  

I only want to say 'Wrong. BUG_ON() is only for cases where ...." is not
quite precious.


>> > Even some of 'crazy users' (e.g. randconfig), can make BUG_ON() and
>> > WARN_ON() 'empty' (include/asm-generic/bug.h).
> That does not matter at all.
>  
>> > In my experience (mainly for servers), when find a kernel bug, it will
>> > stop and report bug, that will let coredump analysing (or KDB trap) much
>> > easier.
> And your core dump will help you in what way? The code which
> misbehaved is not longer executing. The problem is detected after the
> fact and therefor your coredump will just tell you that worker->task
> is not NULL.
>  

In this case, if generate a coredump, it will provide much help to
analyze the issues.

Normally, this coredump is not belongs to complex coredump.

I met a complex KDB trap (at least for me, it is complex, maybe easy for
others):
  When a driver is quiting, it releases the dma buffers firstly, then
immediately tell the hardware to stop dma usage.
  After the hardware writes 'a little waste data' to the released
buffer, the driver quite successfully.
  Then the driver restart again, and work normally.
  After 'a long period', the system finds random issues (sometimes for
ext3, sometimes for mm, block, or anywhere...).

I spend almost 1 month to find the root cause (from 2008-12 to 2009-01).


So if it generates a coredump (or KDB trap) when find bug, in most
cases, it is not a quite complex coredump.


>>>>> > >> > BUG_ON() will stop current working flow and report kernel bug in details.
>>> > > There is no reason to crash the machine completely. The kernel can
>>> > > continue and the WARN_ON reports the bug with the same details.
> Linus said about BUG_ON():
> 
>   Adding BUG_ON()'s just makes things much much much worse. There is
>   *never* a reason to add a BUG_ON().
>   
>   BUG_ON() makes it almost impossible to debug something, because you
>   just killed the machine. So using BUG_ON() for "please notice this"
>   is stupid as hell, because the most common end result is: "Oh, the
>   machine just hung with no messages".
> 
> And he is right about that. 
>  

Why we provide BUG_ON(), and many sub-systems also use it, at last ?

and Why we integrated KDB and KGDB at last ?


>> > If so (we still prefer to use WARN_ON), we'd better to let it in lock
>> > protected.
> No, because the lock is not protecting anything in that case. If some
> other code misbehaves and sets worker->task, then the lock does not
> prevent this and taking the lock is not making the WARN_ON any more
> reliable. So why the heck should we take it?
>  

For writing code, if 'worker->task' is not NULL, we can assume, it need
lock protected.

>> > At least when we still have to continue, try not to lead things worse.
> And what's going to be better if we take the lock? Nothing, because
> the lock CANNOT protect the check.
>  
>> > It will provide much help for coredump analysing (or KDB trap).
>> > 
>> > In fact, for coredump analysers, for every real world coredump, they
>> > have to assume the system has already continued blindly, and then die.
> Core dump analysers cannot analyse dynamic race conditions and neither
> can KDB. 
> 

Yes, they can.

At least for me, I have at least 20 successful experiences (2009 - 2010)
for coredump, dead lock, memory leak, and busy looping under user mode
system services (the related code about 400K).

For kernel, I also have some successful experience for coredump.


> So what do you gain from crashing the kernel? Exactly NOTHING.

So, the coredump (or KDB trap) is really useful for some guys (at least
for me).


Thanks.
-- 
Chen Gang

Asianux Corporation
