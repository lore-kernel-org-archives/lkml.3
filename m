Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaKHKmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 05:42:06 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:41288 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaKHKmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 05:42:03 -0500
Message-ID: <545DF373.4070100@linux.vnet.ibm.com>
Date: Sat, 08 Nov 2014 16:11:55 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, rjw@rjwysocki.net
CC: nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 4/6] cpuidle: idle: menu: Don't reflect when a state
 selection failed
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org> <1415370687-18688-5-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1415370687-18688-5-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110810-0021-0000-0000-000005FE170A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 08:01 PM, Daniel Lezcano wrote:
> In the current code, the check to reflect or not the outcoming state is done
> against the idle state which has been chosen and its value.
> 
> Instead of doing a check in each of the reflect functions, just don't call reflect
> if something went wrong in the idle path.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> ---
>  drivers/cpuidle/governors/ladder.c | 3 +--
>  drivers/cpuidle/governors/menu.c   | 3 +--
>  kernel/sched/idle.c                | 3 ++-
>  3 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
> index 51c9ccd..86e4d49 100644
> --- a/drivers/cpuidle/governors/ladder.c
> +++ b/drivers/cpuidle/governors/ladder.c
> @@ -165,8 +165,7 @@ static int ladder_enable_device(struct cpuidle_driver *drv,
>  static void ladder_reflect(struct cpuidle_device *dev, int index)
>  {
>  	struct ladder_device *ldev = this_cpu_ptr(&ladder_devices);
> -	if (index > 0)
> -		ldev->last_state_idx = index;
> +	ldev->last_state_idx = index;
>  }
> 
>  static struct cpuidle_governor ladder_governor = {
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 91b3000..2e4a315 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -366,8 +366,7 @@ static void menu_reflect(struct cpuidle_device *dev, int index)
>  {
>  	struct menu_device *data = this_cpu_ptr(&menu_devices);
>  	data->last_state_idx = index;
> -	if (index >= 0)
> -		data->needs_update = 1;
> +	data->needs_update = 1;
>  }
> 
>  /**
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index 0a7a1d1..0ae1cc8 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -173,7 +173,8 @@ use_default:
>  	/*
>  	 * Give the governor an opportunity to reflect on the outcome
>  	 */
> -	cpuidle_reflect(dev, entered_state);
> +	if (entered_state >= 0)
> +		cpuidle_reflect(dev, entered_state);
> 
>  exit_idle:
>  	__current_set_polling();
> 
Reviewed-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>

