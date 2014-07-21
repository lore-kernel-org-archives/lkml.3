Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaGUIhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:37:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbaGUIhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:37:42 -0400
Subject: Re: [patch V2 40/64] hwmon: ibmaem: Use ktime_get_ns()
From: Jean Delvare <jdelvare@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20140716205055.584960520@linutronix.de>
References: <20140716205018.175419210@linutronix.de>
	 <20140716205055.584960520@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 21 Jul 2014 10:37:38 +0200
Message-ID: <1405931858.4939.30.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Le Wednesday 16 July 2014 à 21:04 +0000, Thomas Gleixner a écrit :
> Using the wall clock time for delta time calculations is wrong to
> begin with because wall clock time can be set from userspace and NTP.
> Such data wants to be based on clock monotonic.
> 
> The calcuations also are done on a nanosecond basis. Use the

Typo: calculations

> nanoseconds based interface right away.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jean Delvare <jdelvare@suse.de>
> ---
>  drivers/hwmon/ibmaem.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> Index: tip/drivers/hwmon/ibmaem.c
> ===================================================================
> --- tip.orig/drivers/hwmon/ibmaem.c
> +++ tip/drivers/hwmon/ibmaem.c
> @@ -842,11 +842,10 @@ static ssize_t aem_show_power(struct dev
>  	struct aem_data *data = dev_get_drvdata(dev);
>  	u64 before, after, delta, time;
>  	signed long leftover;
> -	struct timespec b, a;
>  
>  	mutex_lock(&data->lock);
>  	update_aem_energy_one(data, attr->index);
> -	getnstimeofday(&b);
> +	time = ktime_get_ns();
>  	before = data->energy[attr->index];
>  
>  	leftover = schedule_timeout_interruptible(
> @@ -858,11 +857,10 @@ static ssize_t aem_show_power(struct dev
>  	}
>  
>  	update_aem_energy_one(data, attr->index);
> -	getnstimeofday(&a);
> +	time = ktime_get_ns() - time;
>  	after = data->energy[attr->index];
>  	mutex_unlock(&data->lock);
>  
> -	time = timespec_to_ns(&a) - timespec_to_ns(&b);
>  	delta = (after - before) * UJ_PER_MJ;
>  
>  	return sprintf(buf, "%llu\n",

I'm not familiar with the driver and I can't test it, and I'm not
familiar with kernel timekeeping either. All I can say is that the
changes look reasonable and good.

Acked-by: Jean Delvare <jdelvare@suse.de>

Darrick, maybe you want to comment or test?

-- 
Jean Delvare
SUSE L3 Support

