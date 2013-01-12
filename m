Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3ALRcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:32:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab3ALRcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:32:11 -0500
Date: Sat, 12 Jan 2013 18:31:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: rwlock_t unfairness and tasklist_lock
Message-ID: <20130112173144.GA22338@redhat.com>
References: <CANN689HRmVTLCjNL9c=JqhWy5F5vwr=A7coo3TVKLZGSVUpQjw@mail.gmail.com> <20130109174922.GA31211@redhat.com> <CANN689FEr+vFdNekW9hm7xwji1aX4FCUQ1BS=P3FhyKiC70qjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689FEr+vFdNekW9hm7xwji1aX4FCUQ1BS=P3FhyKiC70qjg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Michel Lespinasse wrote:
>
> On Wed, Jan 9, 2013 at 9:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 01/08, Michel Lespinasse wrote:
> >> Like others before me, I have discovered how easy it is to DOS a
> >> system by abusing the rwlock_t unfairness and causing the
> >> tasklist_lock read side to be continuously held
> >
> > Yes. Plus it has perfomance problems.
> >
> > It should die. We still need the global lock to protect, say,
> > init_task.tasks list, but otherwise we need the per-process locking.
>
> To be clear: I'm not trying to defend tasklist_lock here.

I understand,

> However,
> given how long this has been a known issue, I think we should consider
> attacking the problem from the lock fairness perspective first and
> stop waiting for an eventual tasklist_lock death.

And probably you are right,

> >> - Would there be any fundamental objection to implementing a fair
> >> rwlock_t and dealing with the reentrancy issues in tasklist_lock ? My
> >> proposal there would be along the lines of:
> >
> > I don't really understand your proposal in details, but until we kill
> > tasklist_lock, perhaps it makes sense to implement something simple, say,
> > write-biased rwlock and add "int task_struct->tasklist_read_lock_counter"
> > to avoid the read-write-read deadlock.
>
> Right. But one complexity that has to be dealt with, is how to handle
> reentrant uses of the tasklist_lock read side,
> ...
>
> there is still the
> possibility of an irq coming up in before the counter is incremented.

Sure, I didn't try to say that it is trivial to implement
read_lock_tasklist(), we should prevent this race.

> So to deal with that, I think we have to explicitly detect the
> tasklist_lock uses that are in irq/softirq context and deal with these
> differently from those in process context

I disagree. In the long term, I think that tasklist (or whatever we use
instead) should be never used in irq/atomic context. And probably the
per-process lock should be rw_semaphore (although it is not recursive).

But until then, if we try to improve the things somehow, we should not
complicate the code, we need something simple.

But actually I am not sure, you can be right.

Oleg.

