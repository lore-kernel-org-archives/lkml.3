Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaDNUvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:51:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53279 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaDNUvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:51:39 -0400
Message-ID: <534C4A59.8040507@codeaurora.org>
Date: Mon, 14 Apr 2014 13:51:37 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] PM / devfreq: Use freq_table for available_frequencies
References: <1397184881-12223-1-git-send-email-skannan@codeaurora.org>
In-Reply-To: <1397184881-12223-1-git-send-email-skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MyungJoo/Kyungmin,

Bump. Can we accept this patch please?

-Saravana


On 04/10/2014 07:54 PM, Saravana Kannan wrote:
> Some devices use freq_table instead of OPP. For those devices, the
> available_frequencies file shows up empty. Fix that by using freq_table to
> generate the available_frequencies data when OPP is not present.
>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>   drivers/devfreq/devfreq.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 2042ec3..a715d15 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -912,19 +912,26 @@ static ssize_t available_frequencies_show(struct device *d,
>   	struct devfreq *df = to_devfreq(d);
>   	struct device *dev = df->dev.parent;
>   	struct dev_pm_opp *opp;
> +	unsigned int i = 0, max_state = df->profile->max_state;
> +	bool use_opp;
>   	ssize_t count = 0;
>   	unsigned long freq = 0;
>
>   	rcu_read_lock();
> +	use_opp = dev_pm_opp_get_opp_count(dev) > 0;
>   	do {
> -		opp = dev_pm_opp_find_freq_ceil(dev, &freq);
> -		if (IS_ERR(opp))
> -			break;
> +		if (use_opp) {
> +			opp = dev_pm_opp_find_freq_ceil(dev, &freq);
> +			if (IS_ERR(opp))
> +				break;
> +		} else {
> +			freq = df->profile->freq_table[i++];
> +		}
>
>   		count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
>   				   "%lu ", freq);
>   		freq++;
> -	} while (1);
> +	} while (use_opp || (!use_opp && i < max_state));
>   	rcu_read_unlock();
>
>   	/* Truncate the trailing space */
>


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
