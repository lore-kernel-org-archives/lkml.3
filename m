Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab3FLVI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:08:29 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51064 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3FLVI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:08:28 -0400
Date: Wed, 12 Jun 2013 14:08:24 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <theo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/2] percpu-refcount: implement percpu_tryget() along
 with percpu_ref_kill_and_confirm()
Message-ID: <20130612210824.GG6151@google.com>
References: <20130612204532.GB15092@htj.dyndns.org>
 <20130612204627.GC15092@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612204627.GC15092@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 01:46:27PM -0700, Tejun Heo wrote:
> From de3c0749e2c1960afcc433fc5da136b85c8bd896 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Wed, 12 Jun 2013 13:37:42 -0700
> 
> Implement percpu_tryget() which succeeds iff the refcount hasn't been
> killed yet.  Because the refcnt is per-cpu, different CPUs may have
> different perceptions on when the counter has been killed and tryget()
> may continue to succeed for a while after percpu_ref_kill() returns.

I don't feel very comfortable with saying percpu_ref_tryget() succeeds
"iff the refcount hasn't been killed yet".  That's something I would say
about e.g. atomic_inc_not_zero(), but percpu_ref_tryget() doesn't do
that sort of synchronization which is what iff implies to me.

If the user does need some kind of strict ordering between
percpu_ref_kill() and percpu_ref_tryget(), they'd have to insert some
memory barriers - tryget() certainly doesn't have any.

That said, I haven't seen near enough actual uses to know whether this
would be an issue in practice, or what a better description would be. I
mean, tryget() does always get you a valid ref...

Maybe emphasize that tryget() succeeds iff this cpu hasn't seen
percpu_ref_kill() done yet? I dunno.

> For use cases where it's necessary to know when all CPUs start to see
> the refcnt as dead, percpu_ref_kill_and_confirm() is added.  The new
> function takes an extra argument @confirm_kill which is invoked when
> the refcnt is guaranteed to be viewed as killed on all CPUs.
> 
> While this isn't the prettiest interface, it doesn't force synchronous
> wait and is much safer than requiring the caller to do its own
> call_rcu().

Yeah, this seems... icky to me. I'm going to withhold judgement until I
see how it's used, maybe there isn't any other way but I'd like to try
and find something prettier.

>  /**
> - * percpu_ref_kill - safely drop initial ref
> + * percpu_ref_kill_and_confirm - drop the initial ref and schedule confirmation
>   * @ref: percpu_ref to kill
> + * @confirm_kill: optional confirmation callback
>   *
> - * Must be used to drop the initial ref on a percpu refcount; must be called
> - * precisely once before shutdown.
> + * Equivalent to percpu_ref_kill() but also schedules kill confirmation if
> + * @confirm_kill is not NULL.  @confirm_kill, which may not block, will be
> + * called after @ref is seen as dead from all CPUs - all further
> + * invocations of percpu_ref_tryget() will fail.  See percpu_ref_tryget()
> + * for more details.
>   *
> - * Puts @ref in non percpu mode, then does a call_rcu() before gathering up the
> - * percpu counters and dropping the initial ref.
> + * It's guaranteed that there will be at least one full RCU grace period
> + * between the invocation of this function and @confirm_kill and the caller
> + * can piggy-back their RCU release on the callback.
>   */
> -void percpu_ref_kill(struct percpu_ref *ref)
> +void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
> +				 percpu_ref_func_t *confirm_kill)

Passing release to percpu_ref_init() and confirm_kill to
percpu_ref_kill() is inconsistent. Can we pass them both to
percpu_ref_init()?

Also, given that confirm_kill is an optional thing I don't see why
you're renaming percpu_ref_kill() -> percpu_ref_kill_and_confirm(). Most
users (certainly aio, I think the module code too) don't have any use
for confirm kill, I don't want to rename it for an ugly optional thing.
