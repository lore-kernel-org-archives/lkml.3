Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaAOU4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:56:54 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:12818 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750886AbaAOU4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:56:51 -0500
Date: Wed, 15 Jan 2014 15:56:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH 1/1] timers: internal_add_timer() should update
 ->next_timer if ->active_timers == 0
Message-ID: <20140115155650.51d11395@gandalf.local.home>
In-Reply-To: <20140115173137.GB14473@redhat.com>
References: <20140115051939.GA31164@linux.vnet.ibm.com>
	<1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1389763248-31297-4-git-send-email-paulmck@linux.vnet.ibm.com>
	<20140115172409.GD11499@redhat.com>
	<20140115173117.GA14473@redhat.com>
	<20140115173137.GB14473@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 18:31:37 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> internal_add_timer(timer) updates base->next_timer only if
> timer->expires < base->next_timer. This is correct, but it also
> makes sense to do the same if we add the first non-deferrable
> timer.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Makes sense.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  kernel/timer.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 6582b82..9492d57 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -388,9 +388,9 @@ static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
>  	 * Update base->active_timers and base->next_timer
>  	 */
>  	if (!tbase_get_deferrable(timer->base)) {
> -		if (time_before(timer->expires, base->next_timer))
> +		if (!base->active_timers++ ||
> +		    time_before(timer->expires, base->next_timer))
>  			base->next_timer = timer->expires;
> -		base->active_timers++;
>  	}
>  }
>  

