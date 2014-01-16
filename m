Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaAPCKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:10:16 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50182 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaAPCKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:10:12 -0500
Date: Wed, 15 Jan 2014 18:10:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH 1/1] timers: internal_add_timer() should update
	->next_timer if ->active_timers == 0
Message-ID: <20140116021003.GM10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140115051939.GA31164@linux.vnet.ibm.com>
 <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1389763248-31297-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140115172409.GD11499@redhat.com>
 <20140115173117.GA14473@redhat.com>
 <20140115173137.GB14473@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115173137.GB14473@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011602-0928-0000-0000-0000057484D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 06:31:37PM +0100, Oleg Nesterov wrote:
> internal_add_timer(timer) updates base->next_timer only if
> timer->expires < base->next_timer. This is correct, but it also
> makes sense to do the same if we add the first non-deferrable
> timer.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I have pulled this on in, thank you Oleg!

							Thanx, Paul

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
> -- 
> 1.5.5.1
> 
> 

