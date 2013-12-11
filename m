Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3LKDW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:22:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50050 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3LKDWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:22:24 -0500
Message-ID: <1386732093.5964.6.camel@marge.simpson.net>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <lenb@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
Date: Wed, 11 Dec 2013 04:21:33 +0100
In-Reply-To: <alpine.DEB.2.02.1312110030330.28330@ionos.tec.linutronix.de>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
	 <1386478624.4748.19.camel@marge.simpson.net>
	 <CAJvTdKn_2mihtMLiQVNCOp_zokx8CsSr2c5NhbkbfJ-qvma-8Q@mail.gmail.com>
	 <1386559014.4875.16.camel@marge.simpson.net>
	 <1386652637.5374.72.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de>
	 <alpine.DEB.2.02.1312110030330.28330@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:ICN8YsihSioLvmjCxV+UBBOmQZOXzPc8+PiF2rqFNv0
 XinUpCAd51zSSPPcSnX5WUdY9Kdrrocm55xdb/fkfqTeJ6yU8V
 z1ei43RbLDCaztWM2ZxhQYtEVQZzsaTGFJKc2u2dsAptFsw/kt
 fq0DU9G2TaNZLyPFjLF/XcaqiHOe7tR338RC76uxmUVuFUFpLt
 uZwBqL8kQQXH+IYzVFvgdWZLlEHAD004iccRW2YZHHtHInq0M4
 cVo/xR3aNDT/pG5vuiO7Q/It5lvelk3TAoRhrQ8QbrZmyvr5w0
 t/MHDFfXJ/8VROwur6bBTIdMdXMM7GESdwM+EsS/ndBIOvHeYg
 cOgKqXdGZKS/52t9K05caqA7M4qzLxSSwv1u9bxjR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alakazam..

pk cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6 CTMP   %pc3   %pc6
             0.17 2.01 2.26   0   0.02  99.82   0.00   49  99.55   0.00
 0   0   0   0.95 1.45 2.26   2   0.43  98.62   0.00   48  98.48   0.00
 1   0   8   0.24 1.99 2.26   2   0.02  99.75   0.00   38  99.68   0.00
 2   0  16   0.17 1.97 2.26   2   0.02  99.81   0.00   40  99.65   0.00
 3   0  24   0.18 1.92 2.26   2   0.02  99.80   0.00   41  99.68   0.00
 4   0  32   0.18 1.95 2.26   2   0.02  99.80   0.00   36  99.66   0.00
 5   0  40   0.15 1.85 2.26   0   0.03  99.83   0.00   35  99.70   0.00
 6   0  48   0.10 1.83 2.26   0   0.01  99.89   0.00   36  99.79   0.00
 7   0  56   0.10 1.97 2.26   0   0.01  99.89   0.00   43  99.75   0.00

Yup, magical gremlin repellent works on 8 socket DL980 too.

> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index a55e68f..b6399af 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -118,7 +118,7 @@ int cpuidle_idle_call(void)
>  	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
>  	struct cpuidle_driver *drv;
>  	int next_state, entered_state;
> -	bool broadcast;
> +	bool broadcast, coupled = false;
>  
>  	if (off || !initialized)
>  		return -ENODEV;
> @@ -147,15 +147,18 @@ int cpuidle_idle_call(void)
>  	if (broadcast)
>  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
>  
> -	if (cpuidle_state_is_coupled(dev, drv, next_state))
> +	if (cpuidle_state_is_coupled(dev, drv, next_state)) {
>  		entered_state = cpuidle_enter_state_coupled(dev, drv,
>  							    next_state);
> -	else
> +		coupled = true;
> +	} else
>  		entered_state = cpuidle_enter_state(dev, drv, next_state);
>  
>  	if (broadcast)
>  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
>  
> +	trace_printk("coupled %d: entered state %d\n", coupled, entered_state);
> +
>  	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
>  
>  	/* give the governor an opportunity to reflect on the outcome */
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index cf7f2f0..9de7ee2 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -309,7 +309,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  	data->expected_us =
>  		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
>  
> -
>  	data->bucket = which_bucket(data->expected_us);
>  
>  	multiplier = performance_multiplier();
> @@ -330,6 +329,9 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  					 data->correction_factor[data->bucket],
>  					 RESOLUTION * DECAY);
>  
> +	trace_printk("expected_us: %d predicted_us: %d\n", data->expected_us,
> +		     data->predicted_us);
> +
>  	get_typical_interval(data);
>  
>  	/*
> @@ -349,10 +351,15 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  		struct cpuidle_state *s = &drv->states[i];
>  		struct cpuidle_state_usage *su = &dev->states_usage[i];
>  
> +		trace_printk("Trying idle state %d s->dis %d su->dis %d\n", i,
> +			     s->disabled, su->disable);
>  		if (s->disabled || su->disable)
>  			continue;
> +		trace_printk("residency %d\n", s->target_residency);
>  		if (s->target_residency > data->predicted_us)
>  			continue;
> +		trace_printk("exit_latency %d vs. %d multiplier %d\n",
> +			     s->exit_latency, latency_req, multiplier);
>  		if (s->exit_latency > latency_req)
>  			continue;
>  		if (s->exit_latency * multiplier > data->predicted_us)
> 


