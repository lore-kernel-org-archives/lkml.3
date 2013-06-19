Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934289Ab3FSIl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:41:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:53089 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934194Ab3FSIlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:41:22 -0400
Date: Wed, 19 Jun 2013 10:41:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of
 spin_lock + local_irq_save, especially when CONFIG_LOCKDEP not defined
In-Reply-To: <51C11E83.8030902@asianux.com>
Message-ID: <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de>
References: <51C11E83.8030902@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013, Chen Gang wrote:

> 
> When CONFIG_LOCKDEP is not defined, spin_lock_irqsave() is not equal to
> spin_lock() + local_irq_save().
> 
> In __mod_timer(), After call spin_lock_irqsave() with 'base->lock' in
> lock_timer_base(), it may use spin_lock() with the 'new_base->lock'.
> 
> It may let original call do_raw_spin_lock_flags() with 'base->lock',
> but new  call LOCK_CONTENDED() with 'new_base->lock'.
> 
> In fact, we need both of them call do_raw_spin_lock_flags(), so use
> spin_lock_irqsave() instead of spin_lock() + local_irq_save().

Why do we need to do that? There is no reason to do so and it's
totally irrelevant whether CONFIG_LOCKDEP is enabled or not.

The code is written intentionally this way.

What's the difference between:

       spin_lock_irqsave(&l1, flags);
       spin_unlock(&l1);
       spin_lock(l2);
       spin_unlock_irqrestore(&l2, flags);

and

       spin_lock_irqsave(&l1, flags);
       spin_unlock_irqrestore(&l1);
       spin_lock_irqsave(l2, flags);
       spin_unlock_irqrestore(&l2, flags);

The difference is that we avoid to touch the interrupt disable in the
cpu, which might be an expensive operation depending on the cpu model.

There is no point in reenabling interrupts just to disable them
again a few instruction cycles later.

And lockdep is perfectly fine with that code. All lockdep cares about
is whether the lock context (interrupts disabled) is correct or
not.

Thanks,

	tglx
