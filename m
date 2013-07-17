Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3GQR55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:57:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab3GQR5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:57:54 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=7xwofrrtwS4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zDptr_D0OFsA:10 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=KKAkSRfTAAAA:8 a=P_-x9VVyirrVWYDCu1UA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=Zh68SRI7RUMA:10 a=3Rfx1nUSh_UA:10 a=1JvJEtVdGvUA:10 a=_RhRFcbxBZMA:10 a=WwgC8nHKvroA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374083871.6458.166.camel@gandalf.local.home>
Subject: Re: [PATCH 05/18] vtime: Update a few comments
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Date: Wed, 17 Jul 2013 13:57:51 -0400
In-Reply-To: <1374079471-3129-6-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
	 <1374079471-3129-6-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 18:44 +0200, Frederic Weisbecker wrote:
> Update a stale comment from the old vtime era and document some
> locking that might be non obvious.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Kevin Hilman <khilman@linaro.org>
> ---
>  include/linux/context_tracking.h |    8 ++------
>  kernel/sched/cputime.c           |    7 +++++++
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
> index 5984f25..12045ce 100644
> --- a/include/linux/context_tracking.h
> +++ b/include/linux/context_tracking.h
> @@ -72,8 +72,8 @@ extern void guest_exit(void);
>  static inline void guest_enter(void)
>  {
>  	/*
> -	 * This is running in ioctl context so we can avoid
> -	 * the call to vtime_account() with its unnecessary idle check.
> +	 * This is running in ioctl context so its safe
> +	 * to assume the pending cputime to flush is stime.

The above is worded funny. What about:

"This is running in ioctl context so its safe to assume that its the
stime pending cputime to flush"

I don't know. But "is stime" is what made me have to read that three
times to figure out what you meant.


>  	 */
>  	vtime_account_system(current);
>  	current->flags |= PF_VCPU;
> @@ -81,10 +81,6 @@ static inline void guest_enter(void)
>  
>  static inline void guest_exit(void)
>  {
> -	/*
> -	 * This is running in ioctl context so we can avoid
> -	 * the call to vtime_account() with its unnecessary idle check.
> -	 */

Should we copy the comment here too?

-- Steve

>  	vtime_account_system(current);
>  	current->flags &= ~PF_VCPU;
>  }
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index a7959e0..223a35e 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -712,6 +712,13 @@ void vtime_user_enter(struct task_struct *tsk)
>  
>  void vtime_guest_enter(struct task_struct *tsk)
>  {
> +	/*
> +	 * The flags must be updated under the lock with
> +	 * the vtime_snap flush and update.
> +	 * That enforces a right ordering and update sequence
> +	 * synchronization against the reader (task_gtime())
> +	 * that can thus safely catch up with a tickless delta.
> +	 */
>  	write_seqlock(&tsk->vtime_seqlock);
>  	__vtime_account_system(tsk);
>  	current->flags |= PF_VCPU;


