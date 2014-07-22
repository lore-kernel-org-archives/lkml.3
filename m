Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbaGVUhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:37:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaGVUhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:37:18 -0400
Date: Tue, 22 Jul 2014 13:37:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Ingo Molnar <mingo@kernel.org>, David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] spin_lock_*(): Always evaluate second argument
Message-Id: <20140722133716.cff957eff4eff1cc9c1d9968@linux-foundation.org>
In-Reply-To: <53CE1019.10708@acm.org>
References: <53CE1019.10708@acm.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014 09:17:45 +0200 Bart Van Assche <bvanassche@acm.org> wrote:

> Evaluating a macro argument only if certain configuration options
> have been selected is confusing and error-prone. Hence always
> evaluate the second argument of spin_lock_nested() and
> spin_lock_nest_lock().
> 
> An intentional side effect of this patch is that it avoids that
> the following warning is reported for netif_addr_lock_nested()
> when building with CONFIG_DEBUG_LOCK_ALLOC=n and with W=1:
> 
> ...
>
> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -197,8 +197,10 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
>  		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
>  	 } while (0)
>  #else
> -# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
> -# define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
> +# define raw_spin_lock_nested(lock, subclass)		\
> +	((void)(subclass), _raw_spin_lock(lock))
> +# define raw_spin_lock_nest_lock(lock, nest_lock)	\
> +	((void)(nest_lock), _raw_spin_lock(lock))
>  #endif
>  

Did you try converting these to static inline functions?  That should
squish the warning and makes the code nicer instead of nastier...

