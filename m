Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaBKJj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:39:26 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:41565 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaBKJjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:39:24 -0500
MIME-Version: 1.0
In-Reply-To: <20140207165801.GC2107@lst.de>
References: <20140207165801.GC2107@lst.de>
Date: Tue, 11 Feb 2014 15:09:23 +0530
Message-ID: <CAC4Lta0=DojhnvPta5Rj3z61UzoEXO4H78iApa4nhNqmZcU+3g@mail.gmail.com>
Subject: Re: [PATCH v2] powerpc ticket locks
From: Raghavendra KT <raghavendra.kt.linux@gmail.com>
To: Torsten Duwe <duwe@lst.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Wood <scottwood@freescale.com>, Tom Musta <tommusta@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 10:28 PM, Torsten Duwe <duwe@lst.de> wrote:
> Ticket locks for ppc, version 2. Changes since v1:
> * The atomically exchanged entity is always 32 bits.
> * asm inline string variations thus removed.
> * Carry the additional holder hint only #if defined(CONFIG_PPC_SPLPAR)
>
> Signed-off-by: Torsten Duwe <duwe@suse.de>
> --
[...]
> +static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
>  {
> +       register struct __raw_tickets old, tmp,
> +               inc = { .tail = TICKET_LOCK_INC };
> +
>         CLEAR_IO_SYNC;
> -       while (1) {
> -               if (likely(__arch_spin_trylock(lock) == 0))
> -                       break;
> +       __asm__ __volatile__(
> +"1:    lwarx   %0,0,%4         # arch_spin_lock\n"
> +"      add     %1,%3,%0\n"
> +       PPC405_ERR77(0, "%4")
> +"      stwcx.  %1,0,%4\n"
> +"      bne-    1b"
> +       : "=&r" (old), "=&r" (tmp), "+m" (lock->tickets)
> +       : "r" (inc), "r" (&lock->tickets)
> +       : "cc");
> +
> +       if (likely(old.head == old.tail))
> +               goto out;
> +
> +       for (;;) {
> +               unsigned count = 100;

I am sure you wanted to tune the total loops to typical lock holding time ...
