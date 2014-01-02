Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaACAJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:09:55 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:33587 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaACAID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:08:03 -0500
Date: Thu, 2 Jan 2014 15:26:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: jiel@marvell.com
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cpufreq: Fix timer/workqueue corruption by protecting
 reading governor_enabled
Message-ID: <20140102232638.GA21548@core.coreip.homeip.net>
References: <1388632482-16921-1-git-send-email-jiel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388632482-16921-1-git-send-email-jiel@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jane:

On Thu, Jan 02, 2014 at 11:14:42AM +0800, jiel@marvell.com wrote:
> @@ -119,8 +121,11 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>  {
>  	int i;
>  
> -	if (!policy->governor_enabled)
> +	mutex_lock(&cpufreq_governor_lock);
> +	if (!policy->governor_enabled) {
> +		mutex_unlock(&cpufreq_governor_lock);
>  		return;
> +	}
>  
>  	if (!all_cpus) {
>  		/*
> @@ -135,6 +140,7 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>  		for_each_cpu(i, policy->cpus)
>  			__gov_queue_work(i, dbs_data, delay);
>  	}
> +	mutex_unlock(&cpufreq_governor_lock);

Unlocking in different branches is not the best practice IMO, I'd
recommend doing:

	mutex_lock(&cpufreq_governor_lock);

	if (!policy->governor_enabled)
		goto out_unlock;

	...

out_unlock:
	mutex_unlock(&cpufreq_governor_lock);

Thanks!

-- 
Dmitry
