Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab3JRH1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 03:27:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab3JRH1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 03:27:01 -0400
Date: Fri, 18 Oct 2013 09:24:25 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 1/7] static_key: flush rate limit timer on rmmod
Message-ID: <20131018072420.GA13111@hpx.cz>
References: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
 <1382004631-25895-2-git-send-email-rkrcmar@redhat.com>
 <525FBD71.7000608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <525FBD71.7000608@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-10-17 12:35+0200, Paolo Bonzini:
> Il 17/10/2013 12:10, Radim Krčmář ha scritto:
> > Fix a bug when we free module memory while timer is pending by marking
> > deferred static keys and flushing the timer on module unload.
> > 
> > Also make static_key_rate_limit() useable more than once.
> > 
> > Reproducer: (host crasher)
> >   modprobe kvm_intel
> >   (sleep 1; echo quit) \
> >     | qemu-kvm -kernel /dev/null -monitor stdio &
> >   sleep 0.5
> >   until modprobe -rv kvm_intel 2>/dev/null; do true; done
> >   modprobe -v kvm_intel
> > 
> > Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> > ---
> > Very hacky; I've already queued generalizing ratelimit and applying it
> > here, but there is still a lot to do on static keys ...
> > 
> >  include/linux/jump_label.h |  1 +
> >  kernel/jump_label.c        | 17 ++++++++++++++++-
> >  2 files changed, 17 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> > index a507907..848bd15 100644
> > --- a/include/linux/jump_label.h
> > +++ b/include/linux/jump_label.h
> > @@ -58,6 +58,7 @@ struct static_key {
> >  #ifdef CONFIG_MODULES
> >  	struct static_key_mod *next;
> >  #endif
> > +	atomic_t deferred;
> >  };
> >  
> >  # include <asm/jump_label.h>
> > diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> > index 297a924..7018042 100644
> > --- a/kernel/jump_label.c
> > +++ b/kernel/jump_label.c
> > @@ -116,8 +116,9 @@ EXPORT_SYMBOL_GPL(static_key_slow_dec_deferred);
> >  void jump_label_rate_limit(struct static_key_deferred *key,
> >  		unsigned long rl)
> >  {
> > +	if (!atomic_xchg(&key->key.deferred, 1))
> > +		INIT_DELAYED_WORK(&key->work, jump_label_update_timeout);
> 
> Can it actually happen that jump_label_rate_limit is called multiple
> times?  If so, this hunk alone would be a separate bugfix.  I don't
> think all the concurrency that you're protecting against can actually
> happen, but in any case I'd just take the jump_label_lock() instead of
> using atomics.

It can't happen in current code and it is highly unlikely to happen in
future too.

There was no reason to take the lock, so I didn't, but we could use bool
in struct then ... I'll do it, even though it has more lines of code, it
is probably easier to understand.

> It's also not necessary to use a new field, since you can just check
> key->timeout.

The flush is done automatically and we don't know if the jump_entry
belongs to deferred key, so we shouldn't just blindly try.
(another bit to jump_entry flags would supply enough information, but we
 haven't decided if we want to optimize them into pointers and there
 isn't much space in them + they were introduced in patch [5/7])

> All this gives something like this for static_key_rate_limit_flush:
> 
>         if (key->timeout) {
> 		jump_label_lock();
> 		if (key->enabled) {
> 			jump_label_unlock();
> 			flush_delayed_work(&dkey->work);
> 		} else
> 			jump_label_unlock();
> 	}

Ugh, I see a problem in original patch now: I changed it from
cancel_delayed_work() in the module that owns this key shortly before
posting, because it could still bug then and forgot it isn't good to
take jump_label_lock() a second time, which would be done in the flush.

This needs be solved by checking if we are the last module that uses
this key and issuing a cancel() then and I'm not sure it would not still
bug yet -- the work could already be running, just waiting for
jump_label_lock() we would then somehow manage to free the memory first.

(leaving it to programmer starts to look sane ...)

> Paolo
