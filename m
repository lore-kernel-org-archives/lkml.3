Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaBMW5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:57:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:37340 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBMW5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:57:37 -0500
Date: Thu, 13 Feb 2014 23:57:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH RT] arm/unwind: fail on unwind in irq disabled regions
In-Reply-To: <1390580663-28869-1-git-send-email-bigeasy@linutronix.de>
Message-ID: <alpine.DEB.2.02.1402132355360.21991@ionos.tec.linutronix.de>
References: <1390580663-28869-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-282708098-1392332266=:21991"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-282708098-1392332266=:21991
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Fri, 24 Jan 2014, Sebastian Andrzej Siewior wrote:

> Mostly unwind is done with irqs enabled however SLUB may call it with
> irqs disabled while creating a new SLUB cache.
> 
> I had system freeze while loading a module which called
> kmem_cache_create() on init. That means SLUB's __slab_alloc() disabled
> interrupts and then
> 
> ->new_slab_objects()
>  ->new_slab()
>   ->setup_object()
>    ->setup_object_debug()
>     ->init_tracking()
>      ->set_track()
>       ->save_stack_trace()
>        ->save_stack_trace_tsk()
>         ->walk_stackframe()
>          ->unwind_frame()
>           ->unwind_find_idx()
>            =>spin_lock_irqsave(&unwind_lock);
> 
> I would prefer not to turn this into a raw lock so for now it will just
> fail if it is called with irqs disabled which might return a few "empty"
> traces…

If we really end up with unwinding then the few cycles to follow the
stack are not that important anymore. We really want that output.

Thanks,

	tglx


--8323329-282708098-1392332266=:21991--
