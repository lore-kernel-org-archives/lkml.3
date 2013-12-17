Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3LQLcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:32:00 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:49990 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752053Ab3LQLb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:31:58 -0500
Date: Tue, 17 Dec 2013 06:31:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.5-rt6
Message-ID: <20131217063156.6ac3bfed@gandalf.local.home>
In-Reply-To: <1387264591.5340.23.camel@marge.simpson.net>
References: <20131216091431.GA13796@linutronix.de>
	<1387264591.5340.23.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013 08:16:31 +0100
Mike Galbraith <bitbucket@online.de> wrote:

> Hi Sebastian,
> 
> Looks like there's a booboo here:
> 
> On Mon, 2013-12-16 at 10:14 +0100, Sebastian Andrzej Siewior wrote:
 
> "ptrace: fix ptrace vs tasklist_lock race" added.. 
> 
> @@ -1068,8 +1082,11 @@ unsigned long wait_task_inactive(struct
>  		 * is actually now running somewhere else!
>  		 */
>  		while (task_running(rq, p)) {
> -			if (match_state && unlikely(p->state != match_state))
> +			if (match_state) {
> +				if (!unlikely(check_task_state(p, match_state)))
> +					return 0;
>  				return 0;
> +			}

Ouch! 
>  			cpu_relax();
>  		}
>  
> ..which is how it stays with the whole series applied.
> 
> The patch contains hunk 2 from
> 
>    "sched/rt: Fix wait_task_interactive() to test rt_spin_lock state",
> 
> which went away in -rt6, so it seems the busted hunk should be as below
> if the two are to be merged.
> 
> @@ -1068,8 +1082,10 @@ unsigned long wait_task_inactive(struct
>  		 * is actually now running somewhere else!
>  		 */
>  		while (task_running(rq, p)) {
> -			if (match_state && unlikely(p->state != match_state))
> +			if (match_state && unlikely(p->state != match_state)
> +			    && unlikely(p->saved_state != match_state))
>  				return 0;
> +			}

Yeah, it should just be:

		if (match_state && check_task_state(p, match_state))
			return 0;

Also, looking at check_task_state():

+static bool check_task_state(struct task_struct *p, long match_state)
+{
+       bool match = false;
+
+       raw_spin_lock_irq(&p->pi_lock);
+       if (p->state == match_state)
+               match = true;
+       else if (p->saved_state == match_state)
+               match = true;

Why the if () else if()? and not just:

	if (p->state == match_state || p->save_state == match_state)
		match = true;
?

The else if makes me think there's something missing.

-- Steve

+       raw_spin_unlock_irq(&p->pi_lock);
+
+       return match;
+}



>  			cpu_relax();
>  		}
>  
> 

