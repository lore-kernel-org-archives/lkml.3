Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaJWQoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:44:04 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:55446 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaJWQoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:44:02 -0400
Date: Thu, 23 Oct 2014 12:43:58 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: rjw@rjwysocki.net, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org
Subject: Re: [PATCH V2 4/5] cpuidle: menu: Fix the get_typical_interval
In-Reply-To: <1414054881-17713-4-git-send-email-daniel.lezcano@linaro.org>
Message-ID: <alpine.LFD.2.11.1410231241160.6969@knanqh.ubzr>
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org> <1414054881-17713-4-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014, Daniel Lezcano wrote:

> The first time the 'get_typical_function' is called, it computes an average
> of zero as no data is filled yet. That leads the 'data->predicted_us' variable
> to be set to zero too.
> 
> The caller, 'menu_select' will then do:
> 
> 	interactivity_req = data->predicted_us /
> 			performance_multiplier(nr_iowaiters, cpu_load);
> 
> That sets the interactivity_req to zero (0/performance...).
> 
> and then
> 
> 	if (latency_req > interactivity_req)
> 		latency_req = interactivity_req;
> 
> ... setting 'latency_req' to zero too.
> 
> No idle state will fulfill this constraint and we will go the C1 state as
> default and leading to an update. So the next calls will compute an average
> different from zero.
> 
> Even if that works with the current code but with a broken semantic, it will
> just break with the next patches where we are stricter with the latencies
> check: the first check will fail (latency_req is zero), then no update will
> occur leading to always falling to choose an idle state.

s/falling/failing/

> 
> As there are no previous values and it is pointless to compute a standard
> deviation for these unexisting values. Just return without setting the
> 'data->predicted_us' to zero.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  drivers/cpuidle/governors/menu.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 3907301..6ae8390 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -226,6 +226,15 @@ again:
>  	else
>  		do_div(avg, divisor);
>  
> +	/*
> +	 * We are at the very beginning and no data have been filled
> +	 * yet. Let's skip the standard deviation computation
> +	 * otherwise the data->predicted_us will be zero and that will
> +	 * lead to a zero latency req in the select function
> +	 */
> +	if (!avg)
> +		return;
> +
>  	/* Then try to determine standard deviation */
>  	stddev = 0;
>  	for (i = 0; i < INTERVALS; i++) {
> -- 
> 1.9.1
> 
> 
