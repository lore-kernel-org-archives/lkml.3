Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3KSQdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:33:38 -0500
Received: from smtp171.dfw.emailsrvr.com ([67.192.241.171]:58579 "EHLO
	smtp171.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3KSQdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:33:37 -0500
Message-ID: <528B9245.70409@calxeda.com>
Date: Tue, 19 Nov 2013 10:31:01 -0600
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: Re: [PATCH] cpufreq, highbank: enable ECME thermal notifications
References: <1382226889-11062-1-git-send-email-mark.langsdorf@calxeda.com>
In-Reply-To: <1382226889-11062-1-git-send-email-mark.langsdorf@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would it be possible to get some kind of ACK or NAK for this patch?
Thank you.

--Mark Langsdorf
Calxeda, Inc.


On 10/19/2013 06:54 PM, Mark Langsdorf wrote:
> The ECME sends thermal messages with a maximum and minimum allowed
> frequency when the SoC status reaches certain trip points known to the
> ECME. Use a notifier function to capture those messages and pass them
> to a work-queued function that can trigger a policy re-evaluation by
> cpufreq, capping the allowable frequencies.
> 
> The core of the policy adjusting code was taken from
> drivers/thermal/cpu_cooling.c.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> ---
>  drivers/cpufreq/highbank-cpufreq.c | 117 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 117 insertions(+)
> 
> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
> index b61b5a3..f0521d3 100644
> --- a/drivers/cpufreq/highbank-cpufreq.c
> +++ b/drivers/cpufreq/highbank-cpufreq.c
> @@ -17,15 +17,32 @@
>  #include <linux/module.h>
>  #include <linux/clk.h>
>  #include <linux/cpu.h>
> +#include <linux/cpufreq.h>
>  #include <linux/err.h>
>  #include <linux/of.h>
>  #include <linux/mailbox.h>
>  #include <linux/platform_device.h>
> +#include <linux/cpumask.h>
> +#include <linux/workqueue.h>
>  
>  #define HB_CPUFREQ_CHANGE_NOTE	0x80000001
> +#define HB_CPUFREQ_HEALTH_NOTE  0x00001001
> +#define HB_CPUFREQ_TPS_REPORT	1
>  #define HB_CPUFREQ_IPC_LEN	7
>  #define HB_CPUFREQ_VOLT_RETRIES	15
>  
> +#define NOTIFY_INVALID NULL
> +
> +struct hb_notify_device {
> +	unsigned long max_freq;
> +	unsigned long min_freq;
> +	unsigned long thermal_state;
> +	struct cpumask *allowed_cpus;
> +};
> +
> +static struct hb_notify_device hb_records, *notify_device = NOTIFY_INVALID;
> +static struct work_struct hb_thermal_wq;
> +
>  static int hb_voltage_change(unsigned int freq)
>  {
>  	u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE, freq / 1000000};
> @@ -33,6 +50,89 @@ static int hb_voltage_change(unsigned int freq)
>  	return pl320_ipc_transmit(msg);
>  }
>  
> +static int hb_thermal_cpufreq_notify(struct notifier_block *nb,
> +				    unsigned long event, void *data)
> +{
> +	struct cpufreq_policy *policy = data;
> +	unsigned long max_freq = 0, min_freq = 0;
> +
> +	if (event != CPUFREQ_ADJUST || notify_device == NOTIFY_INVALID)
> +		return 0;
> +
> +	if (cpumask_test_cpu(policy->cpu, notify_device->allowed_cpus)) {
> +		max_freq = notify_device->max_freq;
> +		min_freq = notify_device->min_freq;
> +	}
> +
> +	/* Never exceed user_policy.max */
> +	if (max_freq > policy->user_policy.max)
> +		max_freq = policy->user_policy.max;
> +	if (min_freq < policy->user_policy.min)
> +		min_freq = policy->user_policy.min;
> +
> +	if ((policy->max != max_freq) || (policy->min != min_freq))
> +		cpufreq_verify_within_limits(policy, min_freq, max_freq);
> +
> +	return 0;
> +}
> +
> +static struct notifier_block hb_thermal_cpufreq_nb = {
> +	.notifier_call = hb_thermal_cpufreq_notify,
> +};
> +
> +/*
> + * We can't call cpufreq_adjust_policy from inside a notifier, so
> + * do it from inside a workqueue
> + */
> +static void hb_thermal_wq_task(struct work_struct *work)
> +{
> +	unsigned int cpuid;
> +	struct cpumask *mask = hb_records.allowed_cpus;
> +
> +	notify_device = &hb_records;
> +
> +	for_each_cpu(cpuid, mask) {
> +		struct cpufreq_policy policy;
> +		if (cpufreq_get_policy(&policy, cpuid) == 0) {
> +			cpufreq_update_policy(cpuid);
> +			break;
> +		}
> +	}
> +	notify_device = NOTIFY_INVALID;
> +}
> +
> +static int hb_thermal_tps_notify(struct notifier_block *nb,
> +				unsigned long action, void *mailbox)
> +{
> +	unsigned long *data = (unsigned long *) mailbox;
> +
> +	if ((action != HB_CPUFREQ_HEALTH_NOTE) &&
> +			(data[0] != HB_CPUFREQ_TPS_REPORT))
> +		return 0;
> +
> +	/*
> +	 * If we're already at this thermal state, or if ECME isn't
> +	 * sending frequency data, there's nothing to do
> +	 */
> +	if ((hb_records.thermal_state == data[1]) || !data[2] || !data[3])
> +		return NOTIFY_DONE;
> +
> +	hb_records.thermal_state = data[1];
> +	hb_records.min_freq = data[2];
> +	hb_records.max_freq = data[3];
> +	notify_device = &hb_records;
> +
> +	schedule_work(&hb_thermal_wq);
> +
> +	pr_warn("ECME TPS event: frequencies limited to %lu-%lu MHz\n",
> +	       hb_records.min_freq, hb_records.max_freq);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block hb_thermal_tps_nb = {
> +	.notifier_call = hb_thermal_tps_notify,
> +};
> +
>  static int hb_cpufreq_clk_notify(struct notifier_block *nb,
>  				unsigned long action, void *hclk)
>  {
> @@ -100,6 +200,23 @@ static int hb_cpufreq_driver_init(void)
>  		goto out_put_node;
>  	}
>  
> +	/*
> +	 * Set up thermal state notifications from ECME, but continue
> +	 * running even if they don't work.
> +	 */
> +	ret = pl320_ipc_register_notifier(&hb_thermal_tps_nb);
> +	if (!ret) {
> +		ret = cpufreq_register_notifier(&hb_thermal_cpufreq_nb,
> +				CPUFREQ_POLICY_NOTIFIER);
> +		if (ret)
> +			pl320_ipc_unregister_notifier(&hb_thermal_tps_nb);
> +		else {
> +			hb_records.allowed_cpus = (struct cpumask *)
> +						cpu_possible_mask;
> +			INIT_WORK(&hb_thermal_wq, hb_thermal_wq_task);
> +		}
> +	}
> +
>  	/* Instantiate cpufreq-cpu0 */
>  	platform_device_register_full(&devinfo);
>  
> 

