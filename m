Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaJTAfZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 20:35:25 -0400
Received: from ozlabs.org ([103.22.144.67]:53978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaJTAen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 20:34:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amos Kong <akong@redhat.com>, virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch,
        mpm@selenic.com, amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] hw_random: use reference counts on each struct hwrng.
In-Reply-To: <1411043867-21109-4-git-send-email-akong@redhat.com>
References: <1411043867-21109-1-git-send-email-akong@redhat.com> <1411043867-21109-4-git-send-email-akong@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 20 Oct 2014 10:38:08 +1030
Message-ID: <874muza9hz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amos Kong <akong@redhat.com> writes:
> From: Rusty Russell <rusty@rustcorp.com.au>
>
> current_rng holds one reference, and we bump it every time we want
> to do a read from it.
>
> This means we only hold the rng_mutex to grab or drop a reference,
> so accessing /sys/devices/virtual/misc/hw_random/rng_current doesn't
> block on read of /dev/hwrng.
>
> Using a kref is overkill (we're always under the rng_mutex), but
> a standard pattern.
>
> This also solves the problem that the hwrng_fillfn thread was
> accessing current_rng without a lock, which could change (eg. to NULL)
> underneath it.
>
> V2: reduce reference count in signal_pending path

OK, I changed it to do the put_rng before the check, so instead of:

> @@ -208,17 +256,19 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  
>  		if (signal_pending(current)) {
>  			err = -ERESTARTSYS;
> +			put_rng(rng);
>  			goto out;
>  		}
> +
> +		put_rng(rng);
>  	}
>  out:
>  	return ret ? : err;
> -out_unlock:
> -	mutex_unlock(&rng_mutex);
> -	goto out;
> +
>  out_unlock_reading:
>  	mutex_unlock(&reading_mutex);
> -	goto out_unlock;
> +	put_rng(rng);
> +	goto out;
>  }

We have:


		mutex_unlock(&reading_mutex);
		put_rng(rng);

		if (need_resched())
			schedule_timeout_interruptible(1);

		if (signal_pending(current)) {
			err = -ERESTARTSYS;
			goto out;
		}
	}
out:
	return ret ? : err;

out_unlock_reading:
	mutex_unlock(&reading_mutex);
	put_rng(rng);
	goto out;
}


Cheers,
Rusty.
