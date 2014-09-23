Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbaIWVPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:15:51 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:41433 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875AbaIWVPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:15:47 -0400
Date: Tue, 23 Sep 2014 14:17:27 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH 9/9] percpu_ref: make INIT_ATOMIC and switch_to_atomic()
 sticky
Message-ID: <20140923211727.GJ15142@kmo-pixel>
References: <1411451718-17807-1-git-send-email-tj@kernel.org>
 <1411451718-17807-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411451718-17807-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 01:55:18AM -0400, Tejun Heo wrote:
> Currently, a percpu_ref which is initialized with
> PERPCU_REF_INIT_ATOMIC or switched to atomic mode via
> switch_to_atomic() automatically reverts to percpu mode on the first
> percpu_ref_reinit().  This makes the atomic mode difficult to use for
> cases where a percpu_ref is used as a persistent on/off switch which
> may be cycled multiple times.
> 
> This patch makes such atomic state sticky so that it survives through
> kill/reinit cycles.  After this patch, atomic state is cleared only by
> an explicit percpu_ref_switch_to_percpu() call.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Kent Overstreet <kmo@daterainc.com>

> ---
>  include/linux/percpu-refcount.h |  5 ++++-
>  lib/percpu-refcount.c           | 20 +++++++++++++++-----
>  2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> index 5f84bf0..8459d3a 100644
> --- a/include/linux/percpu-refcount.h
> +++ b/include/linux/percpu-refcount.h
> @@ -65,7 +65,9 @@ enum {
>  enum {
>  	/*
>  	 * Start w/ ref == 1 in atomic mode.  Can be switched to percpu
> -	 * operation using percpu_ref_switch_to_percpu().
> +	 * operation using percpu_ref_switch_to_percpu().  If initialized
> +	 * with this flag, the ref will stay in atomic mode until
> +	 * percpu_ref_switch_to_percpu() is invoked on it.
>  	 */
>  	PERCPU_REF_INIT_ATOMIC	= 1 << 0,
>  
> @@ -85,6 +87,7 @@ struct percpu_ref {
>  	unsigned long		percpu_count_ptr;
>  	percpu_ref_func_t	*release;
>  	percpu_ref_func_t	*confirm_switch;
> +	bool			force_atomic:1;
>  	struct rcu_head		rcu;
>  };
>  
> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index 74ec33e..c47e496 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -68,6 +68,8 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
>  	if (!ref->percpu_count_ptr)
>  		return -ENOMEM;
>  
> +	ref->force_atomic = flags & PERCPU_REF_INIT_ATOMIC;
> +
>  	if (flags & (PERCPU_REF_INIT_ATOMIC | PERCPU_REF_INIT_DEAD))
>  		ref->percpu_count_ptr |= __PERCPU_REF_ATOMIC;
>  	else
> @@ -203,7 +205,8 @@ static void __percpu_ref_switch_to_atomic(struct percpu_ref *ref,
>   * are guaraneed to be in atomic mode, @confirm_switch, which may not
>   * block, is invoked.  This function may be invoked concurrently with all
>   * the get/put operations and can safely be mixed with kill and reinit
> - * operations.
> + * operations.  Note that @ref will stay in atomic mode across kill/reinit
> + * cycles until percpu_ref_switch_to_percpu() is called.
>   *
>   * This function normally doesn't block and can be called from any context
>   * but it may block if @confirm_kill is specified and @ref is already in
> @@ -217,6 +220,7 @@ static void __percpu_ref_switch_to_atomic(struct percpu_ref *ref,
>  void percpu_ref_switch_to_atomic(struct percpu_ref *ref,
>  				 percpu_ref_func_t *confirm_switch)
>  {
> +	ref->force_atomic = true;
>  	__percpu_ref_switch_to_atomic(ref, confirm_switch);
>  }
>  
> @@ -256,7 +260,10 @@ void __percpu_ref_switch_to_percpu(struct percpu_ref *ref)
>   *
>   * Switch @ref to percpu mode.  This function may be invoked concurrently
>   * with all the get/put operations and can safely be mixed with kill and
> - * reinit operations.
> + * reinit operations.  This function reverses the sticky atomic state set
> + * by PERCPU_REF_INIT_ATOMIC or percpu_ref_switch_to_atomic().  If @ref is
> + * dying or dead, the actual switching takes place on the following
> + * percpu_ref_reinit().
>   *
>   * This function normally doesn't block and can be called from any context
>   * but it may block if @ref is in the process of switching to atomic mode
> @@ -264,6 +271,8 @@ void __percpu_ref_switch_to_percpu(struct percpu_ref *ref)
>   */
>  void percpu_ref_switch_to_percpu(struct percpu_ref *ref)
>  {
> +	ref->force_atomic = false;
> +
>  	/* a dying or dead ref can't be switched to percpu mode w/o reinit */
>  	if (!(ref->percpu_count_ptr & __PERCPU_REF_DEAD))
>  		__percpu_ref_switch_to_percpu(ref);
> @@ -305,8 +314,8 @@ EXPORT_SYMBOL_GPL(percpu_ref_kill_and_confirm);
>   * @ref: perpcu_ref to re-initialize
>   *
>   * Re-initialize @ref so that it's in the same state as when it finished
> - * percpu_ref_init().  @ref must have been initialized successfully and
> - * reached 0 but not exited.
> + * percpu_ref_init() ignoring %PERCPU_REF_INIT_DEAD.  @ref must have been
> + * initialized successfully and reached 0 but not exited.
>   *
>   * Note that percpu_ref_tryget[_live]() are safe to perform on @ref while
>   * this function is in progress.
> @@ -317,6 +326,7 @@ void percpu_ref_reinit(struct percpu_ref *ref)
>  
>  	ref->percpu_count_ptr &= ~__PERCPU_REF_DEAD;
>  	percpu_ref_get(ref);
> -	__percpu_ref_switch_to_percpu(ref);
> +	if (!ref->force_atomic)
> +		__percpu_ref_switch_to_percpu(ref);
>  }
>  EXPORT_SYMBOL_GPL(percpu_ref_reinit);
> -- 
> 1.9.3
> 
