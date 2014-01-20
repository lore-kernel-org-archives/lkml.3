Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaATMUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:20:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55030 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaATMU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:20:29 -0500
Date: Mon, 20 Jan 2014 13:19:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH v7 5/6] MCS Lock: allow architectures to hook in to
 contended paths
Message-ID: <20140120121948.GD31570@twins.programming.kicks-ass.net>
References: <cover.1389890175.git.tim.c.chen@linux.intel.com>
 <1389917311.3138.15.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389917311.3138.15.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 04:08:31PM -0800, Tim Chen wrote:
> +#ifndef arch_mcs_spin_lock_contended
> +/*
> + * Using smp_load_acquire() provides a memory barrier that ensures
> + * subsequent operations happen after the lock is acquired.
> + */
> +#define arch_mcs_spin_lock_contended(l)					\
> +	while (!(smp_load_acquire(l))) {				\
> +		arch_mutex_cpu_relax();					\
> +	}
> +#endif

I think that wants to be:

#define arch_mcs_spin_lock_contended(l)				\
do {								\
	while (!smp_load_acquire(l))				\
		arch_mutex_cpu_relax();				\
} while (0)

So that we properly eat the ';' in: arch_mcs_spin_lock_contended(l);.

> +#ifndef arch_mcs_spin_unlock_contended
> +/*
> + * smp_store_release() provides a memory barrier to ensure all
> + * operations in the critical section has been completed before
> + * unlocking.
> + */
> +#define arch_mcs_spin_unlock_contended(l)				\
> +	smp_store_release((l), 1)
>  #endif
