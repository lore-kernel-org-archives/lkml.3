Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbbA1UjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:39:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56980 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbbA1UjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:39:08 -0500
Date: Wed, 28 Jan 2015 08:42:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: Linux PM List <linux-pm@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PM: Use 64-bit timekeeping
Message-ID: <20150128074254.GA31048@amd>
References: <20150128043836.GA4112@tinar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128043836.GA4112@tinar>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2015-01-28 10:08:37, Tina Ruchandani wrote:
> The freezer try_to_freeze_tasks uses 'struct timeval' for start
> and end times, tracking time taken to freeze tasks. 'struct timeval'
> on 32-bit systems will have its tv_sec overflow in year 2038 and
> beyond. This patches uses 'ktime_t' (which has 64 bit values
> for seconds) for start and end time.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>

Nicer code, and without the overflow. Thanks!

Acked-by: Pavel Machek <pavel@ucw.cz>


> ---
> Changes in v2:
> 	- Use ktime_t to be able to use ktime_ms_delta
> 	  which is more efficient than timespec64 based methods.
> ---
>  kernel/power/process.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 5a6ec86..52414dd 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -17,6 +17,7 @@
>  #include <linux/delay.h>
>  #include <linux/workqueue.h>
>  #include <linux/kmod.h>
> +#include <linux/ktime.h>
>  #include <trace/events/power.h>
x>  
>  /* 
> @@ -30,13 +31,12 @@ static int try_to_freeze_tasks(bool user_only)
>  	unsigned long end_time;
>  	unsigned int todo;
>  	bool wq_busy = false;
> -	struct timeval start, end;
> -	u64 elapsed_msecs64;
> +	ktime_t start, end;
>  	unsigned int elapsed_msecs;
>  	bool wakeup = false;
>  	int sleep_usecs = USEC_PER_MSEC;
>  
> -	do_gettimeofday(&start);
> +	start = ktime_get();
>  
>  	end_time = jiffies + msecs_to_jiffies(freeze_timeout_msecs);
>  
> @@ -78,10 +78,8 @@ static int try_to_freeze_tasks(bool user_only)
>  			sleep_usecs *= 2;
>  	}
>  
> -	do_gettimeofday(&end);
> -	elapsed_msecs64 = timeval_to_ns(&end) - timeval_to_ns(&start);
> -	do_div(elapsed_msecs64, NSEC_PER_MSEC);
> -	elapsed_msecs = elapsed_msecs64;
> +	end = ktime_get();
> +	elapsed_msecs = (unsigned int) ktime_ms_delta(end, start);
>  
>  	if (todo) {
>  		printk("\n");

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
