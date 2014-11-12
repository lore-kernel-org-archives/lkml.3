Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbaKLEjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:39:03 -0500
Received: from ozlabs.org ([103.22.144.67]:57401 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbaKLEi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:38:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amos Kong <akong@redhat.com>, virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch, mb@bu3sch.de,
        mpm@selenic.com, amit.shah@redhat.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 4/6] hw_random: fix unregister race.
In-Reply-To: <1415030186-18303-5-git-send-email-akong@redhat.com>
References: <1415030186-18303-1-git-send-email-akong@redhat.com> <1415030186-18303-5-git-send-email-akong@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 12 Nov 2014 14:33:00 +1030
Message-ID: <87y4rhm5fv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amos Kong <akong@redhat.com> writes:
> From: Rusty Russell <rusty@rustcorp.com.au>
>
> The previous patch added one potential problem: we can still be
> reading from a hwrng when it's unregistered.  Add a wait for zero
> in the hwrng_unregister path.
>
> v4: add cleanup_done flag to insure that cleanup is done

That's a bit weird.  The usual pattern would be to hold a reference
until we're actually finished, but this reference is a bit weird.

We hold the mutex across cleanup, so we could grab that but we have to
take care sleeping inside wait_event, otherwise Peter will have to fix
my code again :)

AFAICT the wake_woken() stuff isn't merged yet, so your patch will
have to do for now.

> @@ -98,6 +99,8 @@ static inline void cleanup_rng(struct kref *kref)
>  
>  	if (rng->cleanup)
>  		rng->cleanup(rng);
> +	rng->cleanup_done = true;
> +	wake_up_all(&rng_done);
>  }
>  
>  static void set_current_rng(struct hwrng *rng)
> @@ -536,6 +539,11 @@ void hwrng_unregister(struct hwrng *rng)
>  			kthread_stop(hwrng_fill);
>  	} else
>  		mutex_unlock(&rng_mutex);
> +
> +	/* Just in case rng is reading right now, wait. */
> +	wait_event(rng_done, rng->cleanup_done &&
> +		   atomic_read(&rng->ref.refcount) == 0);
> +

The atomic_read() isn't necessary here.

However, you should probably init cleanup_done in hwrng_register().
(Probably noone does unregister then register, but let's be clear).

Thanks,
Rusty.

>  }
>  EXPORT_SYMBOL_GPL(hwrng_unregister);
>  
> diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
> index c212e71..7832e50 100644
> --- a/include/linux/hw_random.h
> +++ b/include/linux/hw_random.h
> @@ -46,6 +46,7 @@ struct hwrng {
>  	/* internal. */
>  	struct list_head list;
>  	struct kref ref;
> +	bool cleanup_done;
>  };
>  
>  /** Register a new Hardware Random Number Generator driver. */
> -- 
> 1.9.3
