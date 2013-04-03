Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600Ab3DCJHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:07:38 -0400
Received: from mail.abilis.ch ([195.70.19.74]:12773 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758716Ab3DCJHe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:07:34 -0400
X-Greylist: delayed 844 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Apr 2013 05:07:34 EDT
Date: Wed, 3 Apr 2013 10:53:14 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: tglx@linutronix.de, Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] timer: Fix possible issues with non serialized
 timer_pending( )
Message-ID: <20130403085313.GA9321@ab42.lan>
References: <1364553218-31255-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1364553218-31255-1-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have tested the patch in several configurations and boards using
tests which previously crashed the kernel in less than an hour. The
crashes in question could not be reproduced in long term tests (3 days)
and nightly tests with the patch. I can thus confirm that this fixes a
real issue.

On Fri, Mar 29, 2013 at 04:03:38PM +0530, Vineet Gupta wrote:
> When stress testing ARC Linux from 3.9-rc3, we've hit a serialization
> issue when mod_timer() races with itself. This is on a FPGA board and
> kernel .config among others has !SMP and !PREEMPT_COUNT.
> 
> The issue happens in mod_timer( ) because timer_pending( ) based early
> exit check is NOT done inside the timer base spinlock - as a networking
> optimization.
> 
> The value used in there, timer->entry.next is also used further in call
> chain (all inlines though) for actual list manipulation. However if the
> register containing this pointer remains live across the spinlock (in a
> UP setup with !PREEMPT_COUNT there's nothing forcing gcc to reload) then
> a stale value of next pointer causes incorrect list manipulation,
> observed with following sequence in our tests.
> 
> [...]
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Reported-by: Christian Ruppert <christian.ruppert@abilis.com>
Tested-by: Christian Ruppert <christian.ruppert@abilis.com>

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Christian Ruppert <christian.ruppert@abilis.com>
> Cc: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/linux/timer.h |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/timer.h b/include/linux/timer.h
> index 8c5a197..1537104 100644
> --- a/include/linux/timer.h
> +++ b/include/linux/timer.h
> @@ -168,7 +168,16 @@ static inline void init_timer_on_stack_key(struct timer_list *timer,
>   */
>  static inline int timer_pending(const struct timer_list * timer)
>  {
> -	return timer->entry.next != NULL;
> +	int pending = timer->entry.next != NULL;
> +
> +	/*
> +	 * The check above enables timer fast path - early exit.
> +	 * However most of the call sites are not protected by timer->base
> +	 * spinlock. If the caller (say mod_timer) races with itself, it
> +	 * can use the stale "next" pointer. See commit log for details.
> +	 */
> +	barrier();
> +	return pending;
>  }
>  
>  extern void add_timer_on(struct timer_list *timer, int cpu);
> -- 
> 1.7.10.4
> 

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
