Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab3EBTqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:46:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:41581 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab3EBTqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:46:14 -0400
Date: Thu, 2 May 2013 21:46:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Colin Cross <ccross@android.com>
cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 08/10] nanosleep: use freezable blocking call
In-Reply-To: <1367458508-9133-9-git-send-email-ccross@android.com>
Message-ID: <alpine.LFD.2.02.1305022145590.2891@ionos>
References: <1367458508-9133-1-git-send-email-ccross@android.com> <1367458508-9133-9-git-send-email-ccross@android.com>
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

> Avoid waking up every thread sleeping in a nanosleep call during
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
>  kernel/hrtimer.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 14be27f..e036276 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -47,6 +47,7 @@
>  #include <linux/sched/sysctl.h>
>  #include <linux/sched/rt.h>
>  #include <linux/timer.h>
> +#include <linux/freezer.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -1525,7 +1526,7 @@ static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mod
>  			t->task = NULL;
>  
>  		if (likely(t->task))
> -			schedule();
> +			freezable_schedule();
>  
>  		hrtimer_cancel(&t->timer);
>  		mode = HRTIMER_MODE_ABS;
> -- 
> 1.8.2.1
> 
> 
