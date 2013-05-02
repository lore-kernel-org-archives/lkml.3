Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634Ab3EBTqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:46:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:41566 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761355Ab3EBTqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:46:02 -0400
Date: Thu, 2 May 2013 21:45:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Colin Cross <ccross@android.com>
cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 07/10] futex: use freezable blocking call
In-Reply-To: <1367458508-9133-8-git-send-email-ccross@android.com>
Message-ID: <alpine.LFD.2.02.1305022145300.2891@ionos>
References: <1367458508-9133-1-git-send-email-ccross@android.com> <1367458508-9133-8-git-send-email-ccross@android.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Colin Cross wrote:

> Avoid waking up every thread sleeping in a futex_wait call during
> suspend and resume by calling a freezable blocking call.  Previous
> patches modified the freezer to avoid sending wakeups to threads
> that are blocked in freezable blocking calls.
> 
> This call was selected to be converted to a freezable call because
> it doesn't hold any locks or release any resources when interrupted
> that might be needed by another freezing task or a kernel driver
> during suspend, and is a common site where idle userspace tasks are
> blocked.
> 
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
>  kernel/futex.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index b26dcfc..d710fae 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -61,6 +61,7 @@
>  #include <linux/nsproxy.h>
>  #include <linux/ptrace.h>
>  #include <linux/sched/rt.h>
> +#include <linux/freezer.h>
>  
>  #include <asm/futex.h>
>  
> @@ -1807,7 +1808,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
>  		 * is no timeout, or if it has yet to expire.
>  		 */
>  		if (!timeout || timeout->task)
> -			schedule();
> +			freezable_schedule();
>  	}
>  	__set_current_state(TASK_RUNNING);
>  }
> -- 
> 1.8.2.1
> 
> 
