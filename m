Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3LAWMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 17:12:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab3LAWMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 17:12:02 -0500
Date: Mon, 2 Dec 2013 00:15:01 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/linux/kernel.h: Make might_fault to be a nop for
 !MMU
Message-ID: <20131201221501.GE5998@redhat.com>
References: <1385710934.11444.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385710934.11444.2.camel@phoenix>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 03:42:14PM +0800, Axel Lin wrote:
> No fault if !MUU, thus make might_fault to be a nop for !MMU.
> 
> This fixes below build error if
> !CONFIG_MMU && (CONFIG_PROVE_LOCKING=y || CONFIG_DEBUG_ATOMIC_SLEEP=y):
> 
> arch/arm/kernel/built-in.o: In function `arch_ptrace':
> arch/arm/kernel/ptrace.c:852: undefined reference to `might_fault'
> arch/arm/kernel/built-in.o: In function `restore_sigframe':
> arch/arm/kernel/signal.c:173: undefined reference to `might_fault'
> arch/arm/kernel/signal.c:174: undefined reference to `might_fault'
> arch/arm/kernel/signal.c:175: undefined reference to `might_fault'
> arch/arm/kernel/signal.c:176: undefined reference to `might_fault'
> arch/arm/kernel/built-in.o:arch/arm/kernel/signal.c:177: more undefined references to `might_fault' follow
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>

Makes sense. FWIW

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  include/linux/kernel.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 2ac0277..8b0ad48 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -193,7 +193,8 @@ extern int _cond_resched(void);
>  		(__x < 0) ? -__x : __x;		\
>  	})
>  
> -#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
> +#if defined(CONFIG_MMU) && \
> +	(defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP))
>  void might_fault(void);
>  #else
>  static inline void might_fault(void) { }
> -- 
> 1.8.1.2
> 
> 
