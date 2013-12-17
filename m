Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3LQHQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 02:16:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57445 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3LQHQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 02:16:39 -0500
Message-ID: <1387264591.5340.23.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.12.5-rt6
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Tue, 17 Dec 2013 08:16:31 +0100
In-Reply-To: <20131216091431.GA13796@linutronix.de>
References: <20131216091431.GA13796@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:1eGmeYdke1a6YfM0cUF75gHPn4BSe7ibzRvjR5DaffI
 LK1nW5EbLwi+212nH/qJLzyhPBzmhDsDt0WzPIqSuY9UIrIu3Q
 7QNuapYFEbdNjnI85yobFCUFIS7zErsr8wP21tzrB229jOWWLD
 r39fe5Uc06jKM3SbvPRlOYXjNy4UNW08TZzU3XiCgSYdhahpIR
 lIisqCkgKDvQYLIKvM7IZ6ytDack0ZpmBhtUnBt5IQ3HbU14Qv
 R8vdgZFHi3jXZONa65Yelh8DPb4buDMwf26uQSDVgVBq6DUAnw
 +P8gpEbn+HQRYs+Wa6EzkCwcZb+Dt4j1YmqGVd5S1dnP2BccZi
 kW+erBWf3Q9Nf0pFEZ2KS/1ZbrQFqRFv5dAUP678x
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

Looks like there's a booboo here:

On Mon, 2013-12-16 at 10:14 +0100, Sebastian Andrzej Siewior wrote:

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 22fa2e2..9c87a17 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1115,9 +1129,11 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
>  		 * is actually now running somewhere else!
>  		 */
>  		while (task_running(rq, p)) {
> -			if (match_state && unlikely(p->state != match_state)
> -			    && unlikely(p->saved_state != match_state))
> +			if (match_state) {
> +				if (!unlikely(check_task_state(p, match_state)))
> +					return 0;
>  				return 0;
> +			}
>  			cpu_relax();
>  		}
>  

"ptrace: fix ptrace vs tasklist_lock race" added.. 

@@ -1068,8 +1082,11 @@ unsigned long wait_task_inactive(struct
 		 * is actually now running somewhere else!
 		 */
 		while (task_running(rq, p)) {
-			if (match_state && unlikely(p->state != match_state))
+			if (match_state) {
+				if (!unlikely(check_task_state(p, match_state)))
+					return 0;
 				return 0;
+			}
 			cpu_relax();
 		}
 
..which is how it stays with the whole series applied.

The patch contains hunk 2 from

   "sched/rt: Fix wait_task_interactive() to test rt_spin_lock state",

which went away in -rt6, so it seems the busted hunk should be as below
if the two are to be merged.

@@ -1068,8 +1082,10 @@ unsigned long wait_task_inactive(struct
 		 * is actually now running somewhere else!
 		 */
 		while (task_running(rq, p)) {
-			if (match_state && unlikely(p->state != match_state))
+			if (match_state && unlikely(p->state != match_state)
+			    && unlikely(p->saved_state != match_state))
 				return 0;
+			}
 			cpu_relax();
 		}
 


