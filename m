Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbaHHVw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:52:57 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:59789 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025AbaHHVww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:52:52 -0400
Date: Fri, 8 Aug 2014 14:52:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bart Van Assche <bvanassche@acm.org>
cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] spin_lock_nested(): Always evaluate second argument
In-Reply-To: <53E4A7F8.1040700@acm.org>
Message-ID: <alpine.DEB.2.02.1408081451470.15603@chino.kir.corp.google.com>
References: <53CE1019.10708@acm.org> <20140722133716.cff957eff4eff1cc9c1d9968@linux-foundation.org> <alpine.DEB.2.02.1407221612330.10592@chino.kir.corp.google.com> <53E260D9.6030803@acm.org> <53E2618F.6040208@acm.org> <alpine.DEB.2.02.1408061455290.13545@chino.kir.corp.google.com>
 <53E4A73D.5080801@acm.org> <53E4A7F8.1040700@acm.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014, Bart Van Assche wrote:

> diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
> index 3f2867f..262ba4e 100644
> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -197,7 +197,13 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
>  		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
>  	 } while (0)
>  #else
> -# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
> +/*
> + * Always evaluate the 'subclass' argument to avoid that the compiler
> + * warns about set-but-not-used variables when building with
> + * CONFIG_DEBUG_LOCK_ALLOC=n and with W=1.
> + */

I was hoping there was going to be a more important reason for this change 
than to avoid compiler warnings, such as an example where someone is doing 
spin_lock_nested(lock, subclass) and the expression for "subclass" 
requires evaluation in all configs.

> +# define raw_spin_lock_nested(lock, subclass)		\
> +	_raw_spin_lock(((void)(subclass), (lock)))
>  # define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
>  #endif
>  
