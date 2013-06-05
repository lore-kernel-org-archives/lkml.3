Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3FEHi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:38:29 -0400
Received: from ozlabs.org ([203.10.76.45]:52297 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab3FEHi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:38:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul McKenney" <paul.mckenney@us.ibm.com>
Subject: Re: [PATCH] Generic percpu refcounting
In-Reply-To: <1370039205-14071-1-git-send-email-koverstreet@google.com>
References: <1370039205-14071-1-git-send-email-koverstreet@google.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 05 Jun 2013 17:05:09 +0930
Message-ID: <87d2s1rowi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> This implements a refcount with similar semantics to
> atomic_get()/atomic_dec_and_test() - but percpu.
>
> It also implements two stage shutdown, as we need it to tear down the
> percpu counts.  Before dropping the initial refcount, you must call
> percpu_ref_kill(); this puts the refcount in "shutting down mode" and
> switches back to a single atomic refcount with the appropriate barriers
> (synchronize_rcu()).
>
> It's also legal to call percpu_ref_kill() multiple times - it only returns
> true once, so callers don't have to reimplement shutdown synchronization.

> +static inline void percpu_ref_get(struct percpu_ref *ref)
> +{
> +	unsigned __percpu *pcpu_count;
> +
> +	preempt_disable();
> +
> +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> +
> +	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
> +		__this_cpu_inc(*pcpu_count);
> +	else
> +		atomic_inc(&ref->count);
> +
> +	preempt_enable();
> +}

I think this should be rcu_read_lock(), which is currently equivalent
but theoretically different.

Does your percpu_ref_kill() *really* need to be nonblocking?  (I'd have
to read your other patches which use this to be sure).  Otherwise, just
use synchronize_rcu(), and get rid of the release function...

Cheers,
Rusty.
