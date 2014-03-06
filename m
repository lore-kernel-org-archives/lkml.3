Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaCFPgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:36:41 -0500
Received: from mail.windriver.com ([147.11.1.11]:44246 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaCFPgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:36:40 -0500
Message-ID: <531895C6.9000305@windriver.com>
Date: Thu, 6 Mar 2014 10:35:34 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Liu hua <sdu.liu@huawei.com>, Ingo Molnar <mingo@kernel.org>
CC: <oleg@redhat.com>, Li Zefan <lizefan@huawei.com>,
        Wang Nan <wangnan0@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hung_task : check the value of "sysctl_hung_task_timeout_sec"
References: <1394089669-18285-1-git-send-email-sdu.liu@huawei.com> <53182182.3080101@huawei.com>
In-Reply-To: <53182182.3080101@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-03-06 02:19 AM, Liu hua wrote:
> As sysctl_hung_task_timeout_sec is unsigned long, when this value is
> larger then LONG_MAX, the function schedule_timeout_interruptible in
> watchdog will return immediately without sleep :
> 
> for example (in x86_64 platform):
> 
> linux# echo 0xFFFFFFFFFFFFFFFF > /proc/sys/kernel/hung_task_timeout_secs
> 
> [   66.798350] schedule_timeout: wrong timeout value ffffffffffffff06
> [   66.800064] schedule_timeout: wrong timeout value ffffffffffffff06
> [   66.801774] schedule_timeout: wrong timeout value ffffffffffffff06
> [   66.803488] schedule_timeout: wrong timeout value ffffffffffffff06
> [   66.805225] schedule_timeout: wrong timeout value ffffffffffffff06
> 
> The screen was filled with "schedule_timeout: wrong timeout value
> ffffffffffffff06" and the system stalled.
> 
> So I do some check and correction in timeout_jiffies, to let the function
> schedule_timeout_interruptible allways get the valid parameter.
> 
> Signed-off-by: Liu Hua <sdu.liu@huawei.com>
> ---
>  kernel/hung_task.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> index 06bb141..ef96650 100644
> --- a/kernel/hung_task.c
> +++ b/kernel/hung_task.c
> @@ -186,7 +186,16 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
>  static unsigned long timeout_jiffies(unsigned long timeout)
>  {
>  	/* timeout of 0 will disable the watchdog */
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You are breaking the above functionality/feature by declaring
zero invalid.

Paul.
--

> -	return timeout ? timeout * HZ : MAX_SCHEDULE_TIMEOUT;
> +	if ((timeout == 0) || (timeout > MAX_SCHEDULE_TIMEOUT)) {
> +		pr_err("%s : wrong timeout value %lx\n",
> +					__func__, timeout);
> +		pr_err("Timeout value is set to MAX_SCHEDULE_TIMEOUT(%lx) now.\n",
> +					MAX_SCHEDULE_TIMEOUT);
> +		return MAX_SCHEDULE_TIMEOUT;
> +	}
> +
> +	return (timeout * HZ) < MAX_SCHEDULE_TIMEOUT ?
> +			timeout * HZ : MAX_SCHEDULE_TIMEOUT;
>  }
> 
>  /*
> 
