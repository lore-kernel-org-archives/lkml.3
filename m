Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3CKXp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:45:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3CKXpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:45:10 -0400
Date: Mon, 11 Mar 2013 16:45:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] atomic: improve
 atomic_inc_unless_negative/atomic_dec_unless_positive
Message-Id: <20130311164509.6ef8ac82597371f51fa5b997@linux-foundation.org>
In-Reply-To: <1362843501-31159-1-git-send-email-tom.leiming@gmail.com>
References: <1362843501-31159-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  9 Mar 2013 23:38:21 +0800 Ming Lei <tom.leiming@gmail.com> wrote:

> Generally, both atomic_inc_unless_negative() and
> atomic_dec_unless_positive() need at least two atomic_cmpxchg()
> to complete the atomic operation. In fact, the 1st atomic_cmpxchg()
> is just used to read current value of the atomic variable at most times.
> 
> Considered memory barrier, bus lock, cache walking, etc. things may be
> involved in atomic_cmpxchg(), it is much expensive than atomic_read(),
> which is just the simple below:
> 
> 	(*(volatile int *)&(v)->counter)
> 
> so this patch can save one extra atomic_cmpxchg() for the two
> helpers under general situation, and should improve them a bit.
> 
> ...
>
> --- a/include/linux/atomic.h
> +++ b/include/linux/atomic.h
> @@ -63,26 +63,34 @@ static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
>  #ifndef atomic_inc_unless_negative
>  static inline int atomic_inc_unless_negative(atomic_t *p)
>  {
> -	int v, v1;
> -	for (v = 0; v >= 0; v = v1) {
> -		v1 = atomic_cmpxchg(p, v, v + 1);
> -		if (likely(v1 == v))
> +	int v, t;
> +
> +	v = atomic_read(p);
> +	while (1) {
> +		if (unlikely(v < 0))
> +			return 0;
> +		t = atomic_cmpxchg(p, v, v + 1);
> +		if (likely(t == v))
>  			return 1;
> +		v = t;
>  	}
> -	return 0;

It looks right to me...
