Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab3LWSY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 13:24:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3LWSYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 13:24:54 -0500
Date: Mon, 23 Dec 2013 19:24:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jason Seba <jason.seba42@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Tomas Henzl <thenzl@redhat.com>,
        Jack Wang <xjtuwjp@gmail.com>,
        Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>,
        Viswas G <Viswas.G@pmcs.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        Vasanthalakshmi Tharmarajan 
	<Vasanthalakshmi.Tharmarajan@pmcs.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: spinlock_irqsave() && flags (Was: pm80xx: Spinlock fix)
Message-ID: <20131223182455.GA5656@redhat.com>
References: <52B8357D.60202@redhat.com> <52B83B89.9040700@gmail.com> <CE2C58F938F4C44EA74FFF880BAA7E5E1C68AA8A@BBYEXM01.pmc-sierra.internal> <CAD0Z9T+69VoSnDY-Sj7a1QfJ-KLJYVyL9=WQ123XMfRvQmGdsg@mail.gmail.com> <52B8518B.4060204@gmail.com> <52B8569D.4050101@redhat.com> <CAD0Z9TK-cn=X3ywSzPnEQN-FB+ue+0dHQ3EHuwonC+KfgrmPMA@mail.gmail.com> <20131223163410.GA28220@redhat.com> <20131223172744.GA2069@redhat.com> <CA+55aFy_y45feJNJgFa=Taks0GpxiXEMJexhjVVYH-vVFkPmkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy_y45feJNJgFa=Taks0GpxiXEMJexhjVVYH-vVFkPmkA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Linus Torvalds wrote:
>
> On Mon, Dec 23, 2013 at 9:27 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > In short, is this code
> >
> >         spinlock_t LOCK;
> >         unsigned long FLAGS;
> >
> >         void my_lock(void)
> >         {
> >                 spin_lock_irqsave(&LOCK, FLAGS);
> >         }
> >
> >         void my_unlock(void)
> >         {
> >                 spin_unlock_irqrestore(&LOCK, FLAGS);
> >         }
> >
> > correct or not?
>
> Hell no. "flags" needs to be a thread-private variable, or at least
> protected some way (ie the above could work if everything is inside a
> bigger lock, to serialize access to FLAGS).

This was my understanding (although, once again, it seems to me this can
suprisingly work with the current implementation).

However, the code above already has the users. Do you think it makes
sense to add something like

	void spinlock_irqsave_careful(spinlock_t *lock, unsigned long *flags)
	{
		unsigned long _flags;
		spinlock_irqsave(lock, _flags);
		*flags = flags;
	}

	void spinlock_irqrestore_careful(spinlock_t *lock, unsigned long *flags)
	{
		unsigned long _flags = *flags;
		spinlock_irqrestore(lock, _flags);
	}

into include/linux/spinlock.h ?

Oleg.

