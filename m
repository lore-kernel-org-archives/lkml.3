Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaATDj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 22:39:57 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:33255 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaATDjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 22:39:55 -0500
Date: Sun, 19 Jan 2014 19:39:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v9 4/5] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140120033947.GA668@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com>
 <1389761047-47566-5-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389761047-47566-5-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012003-6688-0000-0000-000005B21D5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 11:44:06PM -0500, Waiman Long wrote:
> This patch modifies the queue_write_unlock() function to use the new
> smp_store_release() function (currently in tip). It also removes the
> temporary implementation of smp_load_acquire() and smp_store_release()
> function in qrwlock.c.
> 
> This patch will use atomic subtraction instead if the writer field is
> not atomic.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/asm-generic/qrwlock.h |   10 ++++++----
>  kernel/locking/qrwlock.c      |   34 ----------------------------------
>  2 files changed, 6 insertions(+), 38 deletions(-)
> 
> diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
> index 5abb6ca..68f488b 100644
> --- a/include/asm-generic/qrwlock.h
> +++ b/include/asm-generic/qrwlock.h
> @@ -181,11 +181,13 @@ static inline void queue_read_unlock(struct qrwlock *lock)
>  static inline void queue_write_unlock(struct qrwlock *lock)
>  {
>  	/*
> -	 * Make sure that none of the critical section will be leaked out.
> +	 * If the writer field is atomic, it can be cleared directly.
> +	 * Otherwise, an atomic subtraction will be used to clear it.
>  	 */
> -	smp_mb__before_clear_bit();
> -	ACCESS_ONCE(lock->cnts.writer) = 0;
> -	smp_mb__after_clear_bit();
> +	if (__native_word(lock->cnts.writer))
> +		smp_store_release(&lock->cnts.writer, 0);
> +	else
> +		atomic_sub(_QW_LOCKED, &lock->cnts.rwa);
>  }
> 
>  /*
> diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
> index 053be4d..2727188 100644
> --- a/kernel/locking/qrwlock.c
> +++ b/kernel/locking/qrwlock.c
> @@ -47,40 +47,6 @@
>  # define arch_mutex_cpu_relax() cpu_relax()
>  #endif
> 
> -#ifndef smp_load_acquire
> -# ifdef CONFIG_X86
> -#   define smp_load_acquire(p)				\
> -	({						\
> -		typeof(*p) ___p1 = ACCESS_ONCE(*p);	\
> -		barrier();				\
> -		___p1;					\
> -	})
> -# else
> -#   define smp_load_acquire(p)				\
> -	({						\
> -		typeof(*p) ___p1 = ACCESS_ONCE(*p);	\
> -		smp_mb();				\
> -		___p1;					\
> -	})
> -# endif
> -#endif
> -
> -#ifndef smp_store_release
> -# ifdef CONFIG_X86
> -#   define smp_store_release(p, v)			\
> -	do {						\
> -		barrier();				\
> -		ACCESS_ONCE(*p) = v;			\
> -	} while (0)
> -# else
> -#   define smp_store_release(p, v)			\
> -	do {						\
> -		smp_mb();				\
> -		ACCESS_ONCE(*p) = v;			\
> -	} while (0)
> -# endif
> -#endif
> -
>  /*
>   * If an xadd (exchange-add) macro isn't available, simulate one with
>   * the atomic_add_return() function.
> -- 
> 1.7.1
> 

