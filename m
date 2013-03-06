Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab3CFTfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:35:40 -0500
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:36648 "EHLO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab3CFTfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:35:38 -0500
Message-ID: <51379A80.2090200@verisign.com>
Date: Wed, 06 Mar 2013 14:35:28 -0500
From: David C Niemi <dniemi@verisign.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stratos Karafotis <stratosk@semaphore.gr>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/3 linux-next] cpufreq: conservative: Fix the logic in
 frequency decrease  checking
References: <51366C70.3020406@semaphore.gr>
In-Reply-To: <51366C70.3020406@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2013 19:35:28.0626 (UTC) FILETIME=[C1F24520:01CE1AA1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "10" sounds like an attempt to add some hysteresis to the up/down decisionmaking.  If you take it out, you should make sure you don't get into situations where you're continually switching rapidly between two frequencies.  (In the ondemand governor some care was also taken to avoid the cost of doing a CPU idleness evaluation counting towards the CPU looking busy enough to upshift; I am not familiar enough with Conservative to know whether that is a problem for it too).

DCN

On 03/05/13 17:06, Stratos Karafotis wrote:
> When we evaluate the CPU load for frequency decrease we have to compare
> the load against down_threshold. There is no need to subtract 10 points
> from down_threshold.
>
> Instead, we have to use the default down_threshold or user's selection
> unmodified.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq_conservative.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
> index 1e3be56..08be431 100644
> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -92,12 +92,8 @@ static void cs_check_cpu(int cpu, unsigned int load)
>  		return;
>  	dbs_info->down_skip = 0;
>  
> -	/*
> -	 * The optimal frequency is the frequency that is the lowest that can
> -	 * support the current CPU usage without triggering the up policy. To be
> -	 * safe, we focus 10 points under the threshold.
> -	 */
> -	if (load < (cs_tuners.down_threshold - 10)) {
> +	/* Check for frequency decrease */
> +	if (load < cs_tuners.down_threshold) {
>  		freq_target = (cs_tuners.freq_step * policy->max) / 100;
>  
>  		dbs_info->requested_freq -= freq_target;

