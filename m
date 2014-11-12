Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbaKLEjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:39:01 -0500
Received: from ozlabs.org ([103.22.144.67]:54217 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbaKLEi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:38:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amos Kong <akong@redhat.com>, virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch, mb@bu3sch.de,
        mpm@selenic.com, amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/6] hw_random: use reference counts on each struct hwrng.
In-Reply-To: <1415030186-18303-4-git-send-email-akong@redhat.com>
References: <1415030186-18303-1-git-send-email-akong@redhat.com> <1415030186-18303-4-git-send-email-akong@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 12 Nov 2014 14:11:23 +1030
Message-ID: <87zjbxm6fw.fsf@rustcorp.com.au>
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
> v4: decrease last reference for triggering the cleanup

This doesn't make any sense:

> +static void drop_current_rng(void)
> +{
> +	struct hwrng *rng = current_rng;
> +
> +	BUG_ON(!mutex_is_locked(&rng_mutex));
> +	if (!current_rng)
> +		return;
> +
> +	/* release current_rng reference */
> +	kref_put(&current_rng->ref, cleanup_rng);
> +	current_rng = NULL;
> +
> +	/* decrease last reference for triggering the cleanup */
> +	kref_put(&rng->ref, cleanup_rng);
> +}

Why would it drop the refcount twice?  This doesn't make sense.

Hmm, because you added kref_init, which initializes the reference count
to 1, you created this bug.

Leave out the kref_init, and let it naturally be 0 (until, and if, it
becomes current_rng).  Add a comment if you want.

Thanks,
Rusty.
