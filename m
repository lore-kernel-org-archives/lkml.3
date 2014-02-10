Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaBJDLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 22:11:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:42242 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbaBJDLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 22:11:24 -0500
Message-ID: <1392001823.3996.21.camel@pasglop>
Subject: Re: [PATCH v2] powerpc ticket locks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Torsten Duwe <duwe@lst.de>
Cc: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Wood <scottwood@freescale.com>, Tom Musta <tommusta@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 10 Feb 2014 14:10:23 +1100
In-Reply-To: <20140207165801.GC2107@lst.de>
References: <20140207165801.GC2107@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 17:58 +0100, Torsten Duwe wrote:
>  typedef struct {
> -       volatile unsigned int slock;
> -} arch_spinlock_t;
> +       union {
> +               __ticketpair_t head_tail;
> +               struct __raw_tickets {
> +#ifdef __BIG_ENDIAN__          /* The "tail" part should be in the MSBs */
> +                       __ticket_t tail, head;
> +#else
> +                       __ticket_t head, tail;
> +#endif
> +               } tickets;
> +       };
> +#if defined(CONFIG_PPC_SPLPAR)
> +       u32 holder;
> +#endif
> +} arch_spinlock_t __aligned(4);

That's still broken with lockref (which we just merged).

We must have the arch_spinlock_t and the ref in the same 64-bit word
otherwise it will break.

We can make it work in theory since the holder doesn't have to be
accessed atomically, but the practicals are a complete mess ...
lockref would essentially have to re-implement the holder handling
of the spinlocks and use lower level ticket stuff.

Unless you can find a sneaky trick ... :-(

Ben.


