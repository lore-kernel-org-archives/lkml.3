Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbaD1OSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:18:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:33908 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752663AbaD1OSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:18:09 -0400
Date: Mon, 28 Apr 2014 10:18:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.14-rt1
Message-ID: <20140428101805.75032f45@gandalf.local.home>
In-Reply-To: <1398676186.30930.49.camel@marge.simpson.net>
References: <20140411185739.GA6644@linutronix.de>
	<1397918766.5436.16.camel@marge.simpson.net>
	<1398411635.11930.45.camel@marge.simpson.net>
	<1398501491.12941.5.camel@marge.simpson.net>
	<1398520699.28726.22.camel@marge.simpson.net>
	<1398661784.30930.33.camel@marge.simpson.net>
	<1398676186.30930.49.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014 11:09:46 +0200
Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
 
> migrate_disable-pushd-down-in-atomic_dec_and_spin_lo.patch
> 
> bug: migrate_disable() after blocking is too late.
> 
> @@ -1028,12 +1028,12 @@ int atomic_dec_and_spin_lock(atomic_t *a
>         /* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
>         if (atomic_add_unless(atomic, -1, 1))
>                 return 0;
> -       migrate_disable();
>         rt_spin_lock(lock);
> -       if (atomic_dec_and_test(atomic))
> +       if (atomic_dec_and_test(atomic)){
> +               migrate_disable();

Makes sense, as the CPU can go offline right after the lock is grabbed
and before the migrate_disable() is called.

Seems that migrate_disable() must be called before taking the lock as
it is done in every other location.

-- Steve


>                 return 1;
> +       }
>         rt_spin_unlock(lock);
> -       migrate_enable();
>         return 0;
>  }
>  EXPORT_SYMBOL(atomic_dec_and_spin_lock);
> 
> read_lock-migrate_disable-pushdown-to-rt_read_lock.patch
> 
> bug: ditto.
> 
> @@ -244,8 +246,10 @@ void __lockfunc rt_read_lock(rwlock_t *r
>         /*
>          * recursive read locks succeed when current owns the lock
>          */
> -       if (rt_mutex_owner(lock) != current)
> +       if (rt_mutex_owner(lock) != current) {
>                 __rt_spin_lock(lock);
> +               migrate_disable();
> +       }
>         rwlock->read_depth++;
>  }
> 
> Moving that migrate_disable() up will likely fix my hotplug troubles.
> I'll find out when I get back from physical torture (therapy) session.
> 
> -Mike

