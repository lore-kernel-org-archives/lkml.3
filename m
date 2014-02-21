Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaBUJhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 04:37:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbaBUJhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 04:37:05 -0500
Date: Fri, 21 Feb 2014 10:37:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] floppy: don't use PREPARE_[DELAYED_]WORK
In-Reply-To: <1392929071-16555-4-git-send-email-tj@kernel.org>
Message-ID: <alpine.LNX.2.00.1402211036410.1192@pobox.suse.cz>
References: <1392929071-16555-1-git-send-email-tj@kernel.org> <1392929071-16555-4-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Tejun Heo wrote:

> PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> and a nasty surprise in terms of reentrancy guarantee as workqueue
> considers work items to be different if they don't have the same work
> function.
> 
> floppy has been multiplexing floppy_work and fd_timer with multiple
> work functions.  Introduce floppy_work_workfn() and fd_timer_workfn()
> which invoke floppy_work_fn and fd_timer_fn respectively and always
> use the two functions as the work functions and update the users to
> set floppy_work_fn and fd_timer_fn instead of overriding work
> functions using PREPARE_[DELAYED_]WORK().
> 
> It would probably be best to route this with other related updates
> through the workqueue tree.
> 
> Lightly tested using qemu.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Jiri Kosina <jkosina@suse.cz>

Thanks.

> ---
>  drivers/block/floppy.c | 42 ++++++++++++++++++++++++++++--------------
>  1 file changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 2023043..8f5565b 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -961,17 +961,31 @@ static void empty(void)
>  {
>  }
>  
> -static DECLARE_WORK(floppy_work, NULL);
> +static void (*floppy_work_fn)(void);
> +
> +static void floppy_work_workfn(struct work_struct *work)
> +{
> +	floppy_work_fn();
> +}
> +
> +static DECLARE_WORK(floppy_work, floppy_work_workfn);
>  
>  static void schedule_bh(void (*handler)(void))
>  {
>  	WARN_ON(work_pending(&floppy_work));
>  
> -	PREPARE_WORK(&floppy_work, (work_func_t)handler);
> +	floppy_work_fn = handler;
>  	queue_work(floppy_wq, &floppy_work);
>  }
>  
> -static DECLARE_DELAYED_WORK(fd_timer, NULL);
> +static void (*fd_timer_fn)(void) = NULL;
> +
> +static void fd_timer_workfn(struct work_struct *work)
> +{
> +	fd_timer_fn();
> +}
> +
> +static DECLARE_DELAYED_WORK(fd_timer, fd_timer_workfn);
>  
>  static void cancel_activity(void)
>  {
> @@ -982,7 +996,7 @@ static void cancel_activity(void)
>  
>  /* this function makes sure that the disk stays in the drive during the
>   * transfer */
> -static void fd_watchdog(struct work_struct *arg)
> +static void fd_watchdog(void)
>  {
>  	debug_dcl(DP->flags, "calling disk change from watchdog\n");
>  
> @@ -993,7 +1007,7 @@ static void fd_watchdog(struct work_struct *arg)
>  		reset_fdc();
>  	} else {
>  		cancel_delayed_work(&fd_timer);
> -		PREPARE_DELAYED_WORK(&fd_timer, fd_watchdog);
> +		fd_timer_fn = fd_watchdog;
>  		queue_delayed_work(floppy_wq, &fd_timer, HZ / 10);
>  	}
>  }
> @@ -1005,7 +1019,8 @@ static void main_command_interrupt(void)
>  }
>  
>  /* waits for a delay (spinup or select) to pass */
> -static int fd_wait_for_completion(unsigned long expires, work_func_t function)
> +static int fd_wait_for_completion(unsigned long expires,
> +				  void (*function)(void))
>  {
>  	if (FDCS->reset) {
>  		reset_fdc();	/* do the reset during sleep to win time
> @@ -1016,7 +1031,7 @@ static int fd_wait_for_completion(unsigned long expires, work_func_t function)
>  
>  	if (time_before(jiffies, expires)) {
>  		cancel_delayed_work(&fd_timer);
> -		PREPARE_DELAYED_WORK(&fd_timer, function);
> +		fd_timer_fn = function;
>  		queue_delayed_work(floppy_wq, &fd_timer, expires - jiffies);
>  		return 1;
>  	}
> @@ -1334,8 +1349,7 @@ static int fdc_dtr(void)
>  	 * Pause 5 msec to avoid trouble. (Needs to be 2 jiffies)
>  	 */
>  	FDCS->dtr = raw_cmd->rate & 3;
> -	return fd_wait_for_completion(jiffies + 2UL * HZ / 100,
> -				      (work_func_t)floppy_ready);
> +	return fd_wait_for_completion(jiffies + 2UL * HZ / 100, floppy_ready);
>  }				/* fdc_dtr */
>  
>  static void tell_sector(void)
> @@ -1440,7 +1454,7 @@ static void setup_rw_floppy(void)
>  	int flags;
>  	int dflags;
>  	unsigned long ready_date;
> -	work_func_t function;
> +	void (*function)(void);
>  
>  	flags = raw_cmd->flags;
>  	if (flags & (FD_RAW_READ | FD_RAW_WRITE))
> @@ -1454,9 +1468,9 @@ static void setup_rw_floppy(void)
>  		 */
>  		if (time_after(ready_date, jiffies + DP->select_delay)) {
>  			ready_date -= DP->select_delay;
> -			function = (work_func_t)floppy_start;
> +			function = floppy_start;
>  		} else
> -			function = (work_func_t)setup_rw_floppy;
> +			function = setup_rw_floppy;
>  
>  		/* wait until the floppy is spinning fast enough */
>  		if (fd_wait_for_completion(ready_date, function))
> @@ -1486,7 +1500,7 @@ static void setup_rw_floppy(void)
>  		inr = result();
>  		cont->interrupt();
>  	} else if (flags & FD_RAW_NEED_DISK)
> -		fd_watchdog(NULL);
> +		fd_watchdog();
>  }
>  
>  static int blind_seek;
> @@ -1863,7 +1877,7 @@ static int start_motor(void (*function)(void))
>  
>  	/* wait_for_completion also schedules reset if needed. */
>  	return fd_wait_for_completion(DRS->select_date + DP->select_delay,
> -				      (work_func_t)function);
> +				      function);
>  }
>  
>  static void floppy_ready(void)
> -- 
> 1.8.5.3
> 

-- 
Jiri Kosina
SUSE Labs
