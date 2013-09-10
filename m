Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab3IJIz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:55:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41095 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3IJIzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:55:55 -0400
Date: Tue, 10 Sep 2013 10:55:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [RFC] seqcount: Add lockdep functionality to
 seqcount/seqlock structures
Message-ID: <20130910085545.GM26785@twins.programming.kicks-ass.net>
References: <1378788166-18474-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378788166-18474-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 09:42:46PM -0700, John Stultz wrote:
> @@ -38,10 +39,58 @@
>   */
>  typedef struct seqcount {
>  	unsigned sequence;
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +	struct lockdep_map dep_map;
> +#endif
>  } seqcount_t;
>  
> -#define SEQCNT_ZERO { 0 }
> -#define seqcount_init(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
> +
> +
> +
> +static inline void __seqcount_init(seqcount_t *s, const char *name,
> +					  struct lock_class_key *key)
> +{
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +	/*
> +	 * Make sure we are not reinitializing a held lock:
> +	 */
> +	lockdep_init_map(&s->dep_map, name, key, 0);
> +#endif
> +	s->sequence = 0;
> +}
> +
> +
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +# define SEQCOUNT_DEP_MAP_INIT(lockname) \
> +		.dep_map = { .name = #lockname } \
> +
> +# define seqcount_init(s)				\
> +	do {						\
> +		static struct lock_class_key __key;	\
> +		__seqcount_init((s), #s, &__key);	\
> +	} while (0)
> +
> +static inline void seqcount_reader_access(const seqcount_t *s)
> +{
> +	seqcount_t *l = (seqcount_t *)s;
> +	unsigned long flags;
> +
> +	preempt_disable();
> +	local_irq_save(flags);
> +	seqcount_acquire_read(&l->dep_map, 0, 0, _RET_IP_);
> +	seqcount_release(&l->dep_map, 1, _RET_IP_);
> +	local_irq_restore(flags);
> +	preempt_enable();
> +}

Why the preempt and local_irq thing? Also preempt_disable is quite
superfluous if you do local_irq_disable().

> +
> +#else
> +# define SEQCOUNT_DEP_MAP_INIT(lockname)
> +# define seqcount_init(s) __seqcount_init(s, NULL, NULL)
> +# define seqcount_reader_access(x)
> +#endif
> +
> +#define SEQCNT_ZERO(lockname) { .sequence = 0, SEQCOUNT_DEP_MAP_INIT(lockname)}
> +
