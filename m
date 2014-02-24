Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaBXO70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:59:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39799 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaBXO7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:59:25 -0500
Date: Mon, 24 Feb 2014 15:59:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/5] idle: Move idle conditions in cpuidle_idle main
 function
Message-ID: <20140224145912.GW27965@twins.programming.kicks-ass.net>
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
 <1393250151-6982-4-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393250151-6982-4-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 02:55:50PM +0100, Daniel Lezcano wrote:
> @@ -136,25 +155,8 @@ static void cpu_idle_loop(void)
>  			local_irq_disable();
>  			arch_cpu_idle_enter();
>  
> -			/*
> -			 * In poll mode we reenable interrupts and spin.
> -			 *
> -			 * Also if we detected in the wakeup from idle
> -			 * path that the tick broadcast device expired
> -			 * for us, we don't want to go deep idle as we
> -			 * know that the IPI is going to arrive right
> -			 * away
> -			 */
> -			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
> -				cpu_idle_poll();
> -			} else {
> -				if (!current_clr_polling_and_test()) {
> -					cpuidle_idle_call();
> -				} else {
> -					local_irq_enable();
> -				}
> -				__current_set_polling();
> -			}
> +			cpuidle_idle_call();
> +

Yeah, not liking that much; you can make it look like:

	if (cpu_idle_force_poll || tick_check_broadcast_expired())
		cpu_idle_poll();
	else
		cpu_idle_call();

Though. That keeps the polling case separate from the actual idle
function.


And when you do that; you can also push down the
current_clr_polling_and_test() muck so it doesn't cover the actual
cpuidle policy code.
