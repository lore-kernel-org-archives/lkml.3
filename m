Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3FTHiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:38:52 -0400
Received: from intranet.asianux.com ([58.214.24.6]:21859 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab3FTHiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:38:51 -0400
X-Spam-Score: -100.8
Message-ID: <51C2B157.40806@asianux.com>
Date: Thu, 20 Jun 2013 15:37:59 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        laijs@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/kthread.c: need spin_lock_irq() for 'worker' before
 main looping, since it can "WARN_ON(worker->task)".
References: <51C12D9A.8030801@asianux.com> <20130619084124.GF30681@mtj.dyndns.org> <51C18540.5060200@asianux.com> <20130619155218.GA14881@htj.dyndns.org> <51C26087.9000109@asianux.com> <alpine.DEB.2.02.1306200900030.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306200900030.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 03:02 PM, Thomas Gleixner wrote:
> On Thu, 20 Jun 2013, Chen Gang wrote:
> 
>> > On 06/19/2013 11:52 PM, Tejun Heo wrote:
>>> > > On Wed, Jun 19, 2013 at 06:17:36PM +0800, Chen Gang wrote:
>>>>> > >> > Hmm... can 'worker->task' has chance to be not NULL before set 'current'
>>>>> > >> > to it ?
>>> > > Yes, if the caller screws up and try to attach more than one workers
>>> > > to the kthread_worker, which has some possibility of happening as
>>> > > kthread_worker allows both attaching and detaching a worker.
>>> > > 
>> > 
>> > If we detect the bugs, and still want to use WARN_ON() to report warning
>> > and continue running, we need be sure of keeping the related things no
>> > touch (at least not lead to worse).
>> > 
>> > If we can not be sure of keeping the related things no touch:
>> >   if it is a kernel bug, better use BUG_ON() instead of,
>> >   if it is a user mode bug, better to return failure with error code and
>> > print related information.
> Wrong. BUG_ON() is only for cases where the kernel CANNOT continue at
> all. WARN_ON() prints the very same information, but allows to
> continue.
> 

In fact, BUG_ON() and WARN_ON() has various implementations in different
architectures, and also can be configured by user.

Even some of 'crazy users' (e.g. randconfig), can make BUG_ON() and
WARN_ON() 'empty' (include/asm-generic/bug.h).

In my experience (mainly for servers), when find a kernel bug, it will
stop and report bug, that will let coredump analysing (or KDB trap) much
easier.


>> > BUG_ON() will stop current working flow and report kernel bug in details.
> There is no reason to crash the machine completely. The kernel can
> continue and the WARN_ON reports the bug with the same details.

If so (we still prefer to use WARN_ON), we'd better to let it in lock
protected.

At least when we still have to continue, try not to lead things worse.

It will provide much help for coredump analysing (or KDB trap).


In fact, for coredump analysers, for every real world coredump, they
have to assume the system has already continued blindly, and then die.


Thanks.
-- 
Chen Gang

Asianux Corporation
