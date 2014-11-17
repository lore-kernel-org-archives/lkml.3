Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaKQXRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:17:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:36141 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaKQXRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:17:24 -0500
Date: Tue, 18 Nov 2014 00:17:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jens Axboe <axboe@kernel.dk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <546A7F18.8090309@kernel.dk>
Message-ID: <alpine.DEB.2.11.1411180008090.3909@nanos>
References: <20141114213124.GB3344@redhat.com> <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com> <alpine.DEB.2.11.1411142326510.3909@nanos> <CA+55aFxExBiRpPemPECKP9wMnR4F4J=ne8UoHKcXjntGB_OEgA@mail.gmail.com>
 <CA+55aFyBnd_Hbe46UpeRktS+ePkAdL5k7vEChUMEx3-e8O1Usg@mail.gmail.com> <546A7F18.8090309@kernel.dk>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Jens Axboe wrote:
> On 11/17/2014 02:22 PM, Linus Torvalds wrote:
> > On Fri, Nov 14, 2014 at 5:59 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >> Judging by the code disassembly, it's the "csd_lock_wait(csd)" at the
> >> end.
> > 
> > Btw, looking at this, I grew really suspicious of this code in csd_unlock():
> > 
> >         WARN_ON((csd->flags & CSD_FLAG_WAIT) && !(csd->flags & CSD_FLAG_LOCK));
> > 
> > because that makes no sense at all. It basically removes a sanity
> > check, yet that sanity check makes a hell of a lot of sense. Unlocking
> > a CSD that is not locked is *wrong*.
> > 
> > The crazy code code comes from commit c84a83e2aaab ("smp: don't warn
> > about csd->flags having CSD_FLAG_LOCK cleared for !wait") by Jens, but
> > the explanation and the code is pure crap.
> > 
> > There is no way in hell that it is ever correct to unlock an entry
> > that isn't locked, so that whole CSD_FLAG_WAIT thing is buggy as hell.
> > 
> > The explanation in commit c84a83e2aaab says that  "blk-mq reuses the
> > request potentially immediately" and claims that that is somehow ok,
> > but that's utter BS. Even if you don't ever wait for it, the CSD lock
> > bit fundamentally also protects the "csd->llist" pointer. So what that
> > commit actually does is to just remove a safety check, and do so in a
> > very unsafe manner. And apparently block-mq re-uses something THAT IS
> > STILL ACTIVELY IN USE. That's just horrible.
> 
> I agree that this description is probably utter crap. And now I do
> actually remember the issue at hand. The resource here is the tag, that
> decides what request we'll use, and subsequently what call_single_data
> storage is used. When this was originally done, blk-mq cleared the
> request from the function callback, instead of doing it at allocation
> time. The assumption here was cache hotness. That in turn also cleared
> ->csd, which meant that the flags got zeroed and csd_unlock() was
> naturally unhappy.

So that's exactly what I described in my other reply.

     csd_lock(csd);
     queue_csd();
     ipi();
				csd->func(csd->info);
     wait_for_completion(csd);
				  complete(csd);
     reuse_csd(csd);		
				csd_unlock(csd);

When you call complete() nothing can rely on csd anymore, except for
the smp core code ....

> THAT was the reuse case, not that the request would get reused
> before we had finished the IPI fn callback since that would
> obviously create other badness. Now I'm not sure what made me create
> that patch, which in retrospect is a bad hammer for this problem.

Performance blindness?
 
> blk-mq doesn't do the init-at-finish time anymore, so it should not be
> hit by the issue. But if we do bring that back, then it would still work
> fine with Thomas' patch, since we unlock prior to running the callback.

So if blk-mq is not relying on that, then we really should back out
that stuff for 3.18 and tag it for stable.

Treating sync and async function calls differently makes sense,
because any async caller which cannot deal with the unlock before call
scheme is broken by definition already today. But that's material for
next.

Thanks,

	tglx
