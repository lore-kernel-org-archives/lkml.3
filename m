Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaLJD1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 22:27:31 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38962 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331AbaLJD13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 22:27:29 -0500
Message-ID: <5487BD8B.5060903@linux.vnet.ibm.com>
Date: Wed, 10 Dec 2014 08:57:07 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] clockevents: introduce ->set_dev_mode() which can
 return error
References: <1418162614-19182-1-git-send-email-khilman@kernel.org> <1418162614-19182-2-git-send-email-khilman@kernel.org>
In-Reply-To: <1418162614-19182-2-git-send-email-khilman@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121003-0029-0000-0000-00000160D11D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 03:33 AM, Kevin Hilman wrote:
> From: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Currently, the ->set_mode() method of a clockevent device is not
> allowed to fail, so it has no return value.  In order to add new
> clockevent modes, and allow the setting of those modes to fail, we
> need the clockevent core to be able to detect when setting a mode
> fails.
> 
> To allow detection of mode setting failures, introduce a new method
> ->set_dev_mode() which can return an error if the given mode is not
> supported or fails.
> 
> Since all current modes are still not allowed to fail, the core code
> simply WARNs if any modes fail.  Future patches that add new mode
> support will add proper error recovery based on failure conditions.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Kevin Hilman <khilman@linaro.org>
> [khilman: rework changelogs, minor formatting/checkpatch cleanups]
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
>  include/linux/clockchips.h |  5 ++++-
>  kernel/time/clockevents.c  | 21 ++++++++++++++++++---
>  kernel/time/timer_list.c   |  5 ++++-
>  3 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> index 2e4cb67f6e56..d969659cf688 100644
> --- a/include/linux/clockchips.h
> +++ b/include/linux/clockchips.h
> @@ -81,7 +81,8 @@ enum clock_event_mode {
>   * @mode:		operating mode assigned by the management code
>   * @features:		features
>   * @retries:		number of forced programming retries
> - * @set_mode:		set mode function
> + * @set_dev_mode:	set dev mode function
> + * @set_mode:		set mode function (deprecated, use set_dev_mode instead)
>   * @broadcast:		function to broadcast events
>   * @min_delta_ticks:	minimum delta value in ticks stored for reconfiguration
>   * @max_delta_ticks:	maximum delta value in ticks stored for reconfiguration
> @@ -109,6 +110,8 @@ struct clock_event_device {
>  	unsigned long		retries;
> 
>  	void			(*broadcast)(const struct cpumask *mask);
> +	int			(*set_dev_mode)(enum clock_event_mode mode,
> +						struct clock_event_device *);
>  	void			(*set_mode)(enum clock_event_mode mode,
>  					    struct clock_event_device *);
>  	void			(*suspend)(struct clock_event_device *);
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index 55449909f114..f7614041240e 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -105,7 +105,16 @@ void clockevents_set_mode(struct clock_event_device *dev,
>  				 enum clock_event_mode mode)
>  {
>  	if (dev->mode != mode) {
> -		dev->set_mode(mode, dev);
> +		if (dev->set_dev_mode) {
> +			int ret = dev->set_dev_mode(mode, dev);
> +
> +			/* Currently available modes shouldn't fail */
> +			WARN_ONCE(ret, "Requested mode: %d, error: %d\n",
> +				  mode, ret);
> +		} else {
> +			dev->set_mode(mode, dev);
> +		}
> +
>  		dev->mode = mode;
> 
>  		/*
> @@ -448,8 +457,14 @@ int __clockevents_update_freq(struct clock_event_device *dev, u32 freq)
>  	if (dev->mode == CLOCK_EVT_MODE_ONESHOT)
>  		return clockevents_program_event(dev, dev->next_event, false);
> 
> -	if (dev->mode == CLOCK_EVT_MODE_PERIODIC)
> -		dev->set_mode(CLOCK_EVT_MODE_PERIODIC, dev);
> +	if (dev->mode == CLOCK_EVT_MODE_PERIODIC) {
> +		/* Shouldn't fail while switching to PERIODIC MODE */
> +		if (dev->set_dev_mode)
> +			WARN_ON_ONCE(dev->set_dev_mode(CLOCK_EVT_MODE_PERIODIC,
> +						       dev));
> +		else
> +			dev->set_mode(CLOCK_EVT_MODE_PERIODIC, dev);
> +	}
> 
>  	return 0;
>  }
> diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
> index 61ed862cdd37..957a04951ef0 100644
> --- a/kernel/time/timer_list.c
> +++ b/kernel/time/timer_list.c
> @@ -229,7 +229,10 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
>  	SEQ_printf(m, "\n");
> 
>  	SEQ_printf(m, " set_mode:       ");
> -	print_name_offset(m, dev->set_mode);
> +	if (dev->set_dev_mode)
> +		print_name_offset(m, dev->set_dev_mode);
> +	else
> +		print_name_offset(m, dev->set_mode);
>  	SEQ_printf(m, "\n");
> 
>  	SEQ_printf(m, " event_handler:  ");
> 
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

