Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab3FJMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 08:25:56 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41710 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab3FJMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 08:25:55 -0400
Date: Mon, 10 Jun 2013 05:25:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/softirq.c: delete 'while' looping to improve a
 little performance and beautify code
Message-ID: <20130610122543.GG5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <51B4755B.4020205@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B4755B.4020205@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061012-5518-0000-0000-00000F7ED469
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 08:30:19PM +0800, Chen Gang wrote:
> 
> After finish the internal 'while', need not test TASKLET_STATE_SCHED
> again, so looping back to outside 'while' is only for set_bit().
> 
> When use 'if' and set_bit() instead of 'while', it will save at least
> one running conditional instruction, and also will be clearer for readers
> (although the binary size will be a little bigger).
> 
> The related patch is "1da177e Linux-2.6.12-rc2"
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/softirq.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index a5f8836..52da25f 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -540,10 +540,11 @@ void tasklet_kill(struct tasklet_struct *t)
>  	if (in_interrupt())
>  		printk("Attempt to kill tasklet from interrupt\n");
> 
> -	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
> +	if (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
>  		do {
>  			yield();
>  		} while (test_bit(TASKLET_STATE_SCHED, &t->state));
> +		set_bit(TASKLET_STATE_SCHED, &t->state);

This replaces an atomic test-and-set with two operations, a test and
a set.  Is this safe?

							Thanx, Paul

>  	}
>  	tasklet_unlock_wait(t);
>  	clear_bit(TASKLET_STATE_SCHED, &t->state);
> -- 
> 1.7.7.6
> 

