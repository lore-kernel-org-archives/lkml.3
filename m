Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab3GVKeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:34:09 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:52196 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab3GVKeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:34:07 -0400
Date: Mon, 22 Jul 2013 12:34:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH RFC 1/2] qrwlock: A queue read/write lock implementation
Message-ID: <20130722103402.GA1991@gmail.com>
References: <1373679249-27123-1-git-send-email-Waiman.Long@hp.com>
 <1373679249-27123-2-git-send-email-Waiman.Long@hp.com>
 <alpine.DEB.2.02.1307151657540.11918@ionos.tec.linutronix.de>
 <51E49FA3.4030202@hp.com>
 <20130718074204.GA22623@gmail.com>
 <51E7F03A.4090305@hp.com>
 <20130719084023.GB25784@gmail.com>
 <51E95B85.8090003@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E95B85.8090003@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <waiman.long@hp.com> wrote:

> I had run some performance tests using the fserver and new_fserver 
> benchmarks (on ext4 filesystems) of the AIM7 test suite on a 80-core 
> DL980 with HT on. The following kernels were used:
> 
> 1. Modified 3.10.1 kernel with mb_cache_spinlock in fs/mbcache.c
>    replaced by a rwlock
> 2. Modified 3.10.1 kernel + modified __read_lock_failed code as suggested
>    by Ingo
> 3. Modified 3.10.1 kernel + queue read/write lock
> 4. Modified 3.10.1 kernel + queue read/write lock in classic read/write
>    lock behavior
> 
> The last one is with the read lock stealing flag set in the qrwlock
> structure to give priority to readers and behave more like the classic
> read/write lock with less fairness.
> 
> The following table shows the averaged results in the 200-1000
> user ranges:
> 
> +-----------------+--------+--------+--------+--------+
> |  Kernel         |    1   |    2   |    3   |   4    |
> +-----------------+--------+--------+--------+--------+
> | fserver JPM     | 245598 | 274457 | 403348 | 411941 |
> | % change from 1 |   0%   | +11.8% | +64.2% | +67.7% |
> +-----------------+--------+--------+--------+--------+
> | new-fserver JPM | 231549 | 269807 | 399093 | 399418 |
> | % change from 1 |   0%   | +16.5% | +72.4% | +72.5% |
> +-----------------+--------+--------+--------+--------+

So it's not just herding that is a problem.

I'm wondering, how sensitive is this particular benchmark to fairness? 
I.e. do the 200-1000 simulated users each perform the same number of ops, 
so that any smearing of execution time via unfairness gets amplified?

I.e. does steady-state throughput go up by 60%+ too with your changes?

Thanks,

	Ingo
