Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab3LWR1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:27:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757644Ab3LWR1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:27:41 -0500
Date: Mon, 23 Dec 2013 18:27:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jason Seba <jason.seba42@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tomas Henzl <thenzl@redhat.com>, Jack Wang <xjtuwjp@gmail.com>,
        Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>,
        Viswas G <Viswas.G@pmcs.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        Vasanthalakshmi Tharmarajan 
	<Vasanthalakshmi.Tharmarajan@pmcs.com>,
        linux-kernel@vger.kernel.org
Subject: spinlock_irqsave() && flags (Was: pm80xx: Spinlock fix)
Message-ID: <20131223172744.GA2069@redhat.com>
References: <1387366123-3950-1-git-send-email-Viswas.G@pmcs.com> <52B8357D.60202@redhat.com> <52B83B89.9040700@gmail.com> <CE2C58F938F4C44EA74FFF880BAA7E5E1C68AA8A@BBYEXM01.pmc-sierra.internal> <CAD0Z9T+69VoSnDY-Sj7a1QfJ-KLJYVyL9=WQ123XMfRvQmGdsg@mail.gmail.com> <52B8518B.4060204@gmail.com> <52B8569D.4050101@redhat.com> <CAD0Z9TK-cn=X3ywSzPnEQN-FB+ue+0dHQ3EHuwonC+KfgrmPMA@mail.gmail.com> <20131223163410.GA28220@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131223163410.GA28220@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Oleg Nesterov wrote:
>
> Perhaps we should ask the maintainers upstream? Even if this works, I am
> not sure this is _supposed_ to work. I mean, in theory spin_lock_irqave()
> can be changed as, say
>
> 	#define spin_lock_irqsave(lock, flags)		\
> 		do {    				\
> 			local_irq_save(flags);		\
> 			spin_lock(lock);		\
> 		} while (0)
>
> (and iirc it was defined this way a long ago). In this case "flags" is
> obviously not protected.

Yes, lets ask the maintainers.

In short, is this code

	spinlock_t LOCK;
	unsigned long FLAGS;

	void my_lock(void)
	{
		spin_lock_irqsave(&LOCK, FLAGS);
	}

	void my_unlock(void)
	{
		spin_unlock_irqrestore(&LOCK, FLAGS);
	}

correct or not?

Initially I thought that this is obviously wrong, irqsave/irqrestore
assume that "flags" is owned by the caller, not by the lock. And iirc
this was certainly wrong in the past.

But when I look at spinlock.c it seems that this code can actually work.
_irqsave() writes to FLAGS after it takes the lock, and _irqrestore()
has a copy of FLAGS before it drops this lock.

And it turns out, some users assume this should work, for example

	arch/arm/mach-omap2/powerdomain.c:
		pwrdm_lock() and pwrdm_unlock()

	drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c:
		brcmf_fws_lock() and brcmf_fws_unlock()

seem to do exactly this. Plus the pending patch for drivers/scsi/pm8001/.

So is it documented somewhere that this sequence is correct, or the code
above should be changed even if it happens to work?

Oleg.

