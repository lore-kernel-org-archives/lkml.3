Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3EXVzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 17:55:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58506 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3EXVzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 17:55:42 -0400
Date: Fri, 24 May 2013 23:55:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
cc: Will Deacon <will.deacon@arm.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, djbw@fb.com
Subject: Re: [PATCH] dmatest: do not allow to interrupt ongoing tests
In-Reply-To: <1369308593-3723-1-git-send-email-andriy.shevchenko@linux.intel.com>
Message-ID: <Pine.LNX.4.64.1305242353210.7187@axis700.grange>
References: <1369308593-3723-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:yr47XwUrNVvV0UOL8SUogkM5XoTF+xIRgkKOYI1xqPc
 RI1pe9uktKgBj1wNF0TEWKl2AYZ456H11XvcJ8/ix3dKoAuWTL
 9y6tfxsVa5pnOW4iVbdq1+wAQpeVlqp+iVuuUNEUhswJpzdnru
 41kZQABQGkPhNghSfB5gmEQPWdPHOLk0UPnjZK6vqgFGcLaWHM
 3SUcwl8DyQPve9yHwAozUMwaVZyOxMlsiJTbBhzQOSXpCiAwZ/
 JLX3Q3+sJkjmpm3MkOxqHOS/Bf79WZLqilz1nSzq+iUh96XX/c
 NFANHehW07L0LPcKu6qyU8AImD3ojRLAZzmJIN4XW/hr8mi8u/
 XT4aV3yqkvcfeMfHcTw9AQRbDx1RX5lQ6zYbtvRBm9NvEImrE4
 9FOpozpJp21+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy

On Thu, 23 May 2013, Andy Shevchenko wrote:

> When user interrupts ongoing transfers the dmatest may end up with console
> lockup, oops, or data mismatch. This patch prevents user to abort any ongoing
> test.

Personally I would be against such a change. What about interrupting the 
test with rmmod? Is it still possible after this your patch or not? If not 
- this doesn't seem like a good idea to me. Why don't we just fix those 
bugs, that you're describing?

Thanks
Guennadi

> 
> Documentation is updated accordingly.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reported-by: Will Deacon <will.deacon@arm.com>
> Tested-by: Will Deacon <will.deacon@arm.com>
> ---
>  Documentation/dmatest.txt |  6 +++---
>  drivers/dma/dmatest.c     | 45 +++++++++++++++++++++++----------------------
>  2 files changed, 26 insertions(+), 25 deletions(-)
> 
> diff --git a/Documentation/dmatest.txt b/Documentation/dmatest.txt
> index 279ac0a..132a094 100644
> --- a/Documentation/dmatest.txt
> +++ b/Documentation/dmatest.txt
> @@ -34,7 +34,7 @@ command:
>  After a while you will start to get messages about current status or error like
>  in the original code.
>  
> -Note that running a new test will stop any in progress test.
> +Note that running a new test will not stop any in progress test.
>  
>  The following command should return actual state of the test.
>  	% cat /sys/kernel/debug/dmatest/run
> @@ -52,8 +52,8 @@ To wait for test done the user may perform a busy loop that checks the state.
>  
>  The module parameters that is supplied to the kernel command line will be used
>  for the first performed test. After user gets a control, the test could be
> -interrupted or re-run with same or different parameters. For the details see
> -the above section "Part 2 - When dmatest is built as a module..."
> +re-run with the same or different parameters. For the details see the above
> +section "Part 2 - When dmatest is built as a module..."
>  
>  In both cases the module parameters are used as initial values for the test case.
>  You always could check them at run-time by running
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index d8ce4ec..e88ded2 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -716,8 +716,7 @@ static int dmatest_func(void *data)
>  		}
>  		dma_async_issue_pending(chan);
>  
> -		wait_event_freezable_timeout(done_wait,
> -					     done.done || kthread_should_stop(),
> +		wait_event_freezable_timeout(done_wait, done.done,
>  					     msecs_to_jiffies(params->timeout));
>  
>  		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
> @@ -997,7 +996,6 @@ static void stop_threaded_test(struct dmatest_info *info)
>  static int __restart_threaded_test(struct dmatest_info *info, bool run)
>  {
>  	struct dmatest_params *params = &info->params;
> -	int ret;
>  
>  	/* Stop any running test first */
>  	__stop_threaded_test(info);
> @@ -1012,13 +1010,23 @@ static int __restart_threaded_test(struct dmatest_info *info, bool run)
>  	memcpy(params, &info->dbgfs_params, sizeof(*params));
>  
>  	/* Run test with new parameters */
> -	ret = __run_threaded_test(info);
> -	if (ret) {
> -		__stop_threaded_test(info);
> -		pr_err("dmatest: Can't run test\n");
> +	return __run_threaded_test(info);
> +}
> +
> +static bool __is_threaded_test_run(struct dmatest_info *info)
> +{
> +	struct dmatest_chan *dtc;
> +
> +	list_for_each_entry(dtc, &info->channels, node) {
> +		struct dmatest_thread *thread;
> +
> +		list_for_each_entry(thread, &dtc->threads, node) {
> +			if (!thread->done)
> +				return true;
> +		}
>  	}
>  
> -	return ret;
> +	return false;
>  }
>  
>  static ssize_t dtf_write_string(void *to, size_t available, loff_t *ppos,
> @@ -1091,22 +1099,10 @@ static ssize_t dtf_read_run(struct file *file, char __user *user_buf,
>  {
>  	struct dmatest_info *info = file->private_data;
>  	char buf[3];
> -	struct dmatest_chan *dtc;
> -	bool alive = false;
>  
>  	mutex_lock(&info->lock);
> -	list_for_each_entry(dtc, &info->channels, node) {
> -		struct dmatest_thread *thread;
> -
> -		list_for_each_entry(thread, &dtc->threads, node) {
> -			if (!thread->done) {
> -				alive = true;
> -				break;
> -			}
> -		}
> -	}
>  
> -	if (alive) {
> +	if (__is_threaded_test_run(info)) {
>  		buf[0] = 'Y';
>  	} else {
>  		__stop_threaded_test(info);
> @@ -1132,7 +1128,12 @@ static ssize_t dtf_write_run(struct file *file, const char __user *user_buf,
>  
>  	if (strtobool(buf, &bv) == 0) {
>  		mutex_lock(&info->lock);
> -		ret = __restart_threaded_test(info, bv);
> +
> +		if (__is_threaded_test_run(info))
> +			ret = -EBUSY;
> +		else
> +			ret = __restart_threaded_test(info, bv);
> +
>  		mutex_unlock(&info->lock);
>  	}
>  
> -- 
> 1.8.2.rc0.22.gb3600c3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
