Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaFDRg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:36:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:47852 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaFDRg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:36:57 -0400
Date: Wed, 4 Jun 2014 19:36:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: umgwanakikbuti@gmail.com, mingo@kernel.org, tglx@linutronix.de,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] sched,idle: Clear polling before descheduling the
 idle thread
Message-ID: <20140604173655.GK13930@laptop.programming.kicks-ass.net>
References: <cover.1401902905.git.luto@amacapital.net>
 <b2059fcb4c613d520cb503b6fad6e47033c7c203.1401902905.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2059fcb4c613d520cb503b6fad6e47033c7c203.1401902905.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:31:16AM -0700, Andy Lutomirski wrote:
> @@ -218,6 +234,15 @@ static void cpu_idle_loop(void)
>  		 */
>  		preempt_set_need_resched();
>  		tick_nohz_idle_exit();
> +		__current_clr_polling();
> +
> +		/*
> +		 * We promise to reschedule if need_resched is set while
> +		 * polling is set.  That means that clearing polling
> +		 * needs to be visible before rescheduling.
> +		 */
> +		smp_mb__after_clear_bit();
> +
>  		schedule_preempt_disabled();
>  	}
>  }

I recently renamed those barriers, its now called:

  smp_mb__after_atomic();

It'll still compile with the old names, and even work, but you'll get
__deprecated warns and horrid code generation.

I'll fix up when applying these patches, no need to resend.

Thanks!
