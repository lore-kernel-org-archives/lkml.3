Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaIVTBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:01:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:42027 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752760AbaIVTBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:01:00 -0400
Date: Mon, 22 Sep 2014 15:00:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] signal: document the RCU protection of ->sighand
Message-ID: <20140922150058.452cbe1e@gandalf.local.home>
In-Reply-To: <20140922164440.GA28942@redhat.com>
References: <20140922164404.GA28910@redhat.com>
	<20140922164440.GA28942@redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 18:44:40 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> __cleanup_sighand() frees sighand without RCU grace period. This is
> correct but this looks "obviously buggy" and constantly confuses the
> readers, add the comments to explain how this works.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/fork.c   |    5 ++++-
>  kernel/signal.c |   12 +++++++++++-
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 1380d8a..2dd9f1d 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1017,11 +1017,14 @@ void __cleanup_sighand(struct sighand_struct *sighand)
>  {
>  	if (atomic_dec_and_test(&sighand->count)) {
>  		signalfd_cleanup(sighand);
> +		/*
> +		 * sighand_cachep is SLAB_DESTROY_BY_RCU so we can free it
> +		 * without an RCU grace period, see __lock_task_sighand().
> +		 */
>  		kmem_cache_free(sighand_cachep, sighand);
>  	}
>  }
>  
> -
>  /*
>   * Initialize POSIX timer handling for a thread group.
>   */
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 61a1f55..9562a4f 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1272,7 +1272,17 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
>  		sighand = rcu_dereference(tsk->sighand);
>  		if (unlikely(sighand == NULL))
>  			break;
> -
> +		/*
> +		 * This sighand can be already freed and even reused, but
> +		 * we rely on SLAB_DESTROY_BY_RCU and sighand_ctor() which
> +		 * initializes ->siglock: this slab can't go away, it has
> +		 * the same object type, ->siglock can't be reinitialized.
> +		 *
> +		 * We need to ensure that tsk->sighand is still the same
> +		 * after we take the lock, we can race with de_thread() or
> +		 * __exit_signal(). In the latter case the next iteration
> +		 * must see ->sighand == NULL.
> +		 */
>  		spin_lock_irqsave(&sighand->siglock, *flags);
>  		if (likely(sighand == tsk->sighand))
>  			break;

