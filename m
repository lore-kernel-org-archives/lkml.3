Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3CNUje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:39:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3CNUjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:39:33 -0400
Date: Thu, 14 Mar 2013 13:39:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] printk: Provide a wake_up_klogd() off-case
Message-Id: <20130314133931.3609b75deff58a2df02ca96b@linux-foundation.org>
In-Reply-To: <1363271189-6631-3-git-send-email-fweisbec@gmail.com>
References: <1363271189-6631-1-git-send-email-fweisbec@gmail.com>
	<1363271189-6631-3-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013 15:26:29 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> wake_up_klogd() is useless when CONFIG_PRINTK=n because
> neither printk() nor printk_sched() are in use and there
> are actually no waiter on log_wait waitqueue. It should
> be a stub in this case for users like bust_spinlocks().
> 
> Otherwise this results in this warning when CONFIG_PRINTK=n
> and CONFIG_IRQ_WORK=n:
> 
> 	kernel/built-in.o In function `wake_up_klogd':
> 	(.text.wake_up_klogd+0xb4): undefined reference to `irq_work_queue'
> 
> To fix this, provide an off-case for wake_up_klogd() when
> CONFIG_PRINTK=n.
> 
> There is much more from console_unlock() and other console
> related code in printk.c that should be moved under
> CONFIG_PRINTK. But for now, focus on a minimal fix as we passed
> the merged window already.
> 
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -390,7 +390,6 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
>  unsigned long int_sqrt(unsigned long);
>  
>  extern void bust_spinlocks(int yes);
> -extern void wake_up_klogd(void);
>  extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
>  extern int panic_timeout;
>  extern int panic_on_oops;
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index 1249a54..822171f 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -134,6 +134,8 @@ extern int printk_delay_msec;
>  extern int dmesg_restrict;
>  extern int kptr_restrict;
>  
> +extern void wake_up_klogd(void);
> +

Given this, it would be prudent to include printk.h in
bust_spinlocks.c.  printk.h currently gets included by kernel.h, but
that doesn't actually seem necessary - nothing in kernel.h calls
printk().

(I pity anyone who tries to remove that include from kernel.h ;))

--- a/lib/bust_spinlocks.c~printk-provide-a-wake_up_klogd-off-case-fix
+++ a/lib/bust_spinlocks.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/spinlock.h>
 #include <linux/tty.h>
 #include <linux/wait.h>
@@ -28,5 +29,3 @@ void __attribute__((weak)) bust_spinlock
 			wake_up_klogd();
 	}
 }
-
-
_

