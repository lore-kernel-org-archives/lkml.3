Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3CLAAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:00:03 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:58236 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3CLAAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:00:01 -0400
MIME-Version: 1.0
In-Reply-To: <1362843501-31159-1-git-send-email-tom.leiming@gmail.com>
References: <1362843501-31159-1-git-send-email-tom.leiming@gmail.com>
Date: Tue, 12 Mar 2013 00:59:59 +0100
Message-ID: <CAFTL4hyO7HxGYOL=Fvq-g3LY37PY2f+xR6+stA7-wNkh3wkV=Q@mail.gmail.com>
Subject: Re: [PATCH] atomic: improve atomic_inc_unless_negative/atomic_dec_unless_positive
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/9 Ming Lei <tom.leiming@gmail.com>:
> Generally, both atomic_inc_unless_negative() and
> atomic_dec_unless_positive() need at least two atomic_cmpxchg()
> to complete the atomic operation. In fact, the 1st atomic_cmpxchg()
> is just used to read current value of the atomic variable at most times.
>
> Considered memory barrier, bus lock, cache walking, etc. things may be
> involved in atomic_cmpxchg(), it is much expensive than atomic_read(),
> which is just the simple below:
>
>         (*(volatile int *)&(v)->counter)
>
> so this patch can save one extra atomic_cmpxchg() for the two
> helpers under general situation, and should improve them a bit.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  include/linux/atomic.h |   28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/atomic.h b/include/linux/atomic.h
> index 5b08a85..aa951d8 100644
> --- a/include/linux/atomic.h
> +++ b/include/linux/atomic.h
> @@ -63,26 +63,34 @@ static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
>  #ifndef atomic_inc_unless_negative
>  static inline int atomic_inc_unless_negative(atomic_t *p)
>  {
> -       int v, v1;
> -       for (v = 0; v >= 0; v = v1) {
> -               v1 = atomic_cmpxchg(p, v, v + 1);
> -               if (likely(v1 == v))
> +       int v, t;
> +
> +       v = atomic_read(p);
> +       while (1) {
> +               if (unlikely(v < 0))
> +                       return 0;

But atomic_read() lacks the full memory barrier that is needed for
proper atomicity here.

For example if the initial value of p is -1 and another CPU just did
an atomic_inc() that resulted in the new value to be 0, the above
atomic_read() might return -1 because there is no guarantee it's
seeing the recent update on the remote CPU.

atomic_cmpxchg() OTOH provides that guarantee.
