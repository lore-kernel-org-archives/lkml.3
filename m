Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857AbaGWV4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:56:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933624AbaGWV4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:56:35 -0400
Date: Wed, 23 Jul 2014 14:56:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hyogi Gim <hyogi.gim@lge.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] driver/rtc/class.c: check the error after
 rtc_read_time()
Message-Id: <20140723145634.656752d0fe2fa124db48b4fc@linux-foundation.org>
In-Reply-To: <1405412723-10062-1-git-send-email-hyogi.gim@lge.com>
References: <1405412723-10062-1-git-send-email-hyogi.gim@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014 17:25:23 +0900 Hyogi Gim <hyogi.gim@lge.com> wrote:

> In rtc_suspend() and rtc_resume(), the error after rtc_read_time() is not
> checked. If rtc device fail to read time, we cannot guarantee the following
> process.
> 
> Add the verification code for returned rtc_read_time() error.
> 
> ...
>
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -53,6 +53,7 @@ static int rtc_suspend(struct device *dev)
>  	struct rtc_device	*rtc = to_rtc_device(dev);
>  	struct rtc_time		tm;
>  	struct timespec		delta, delta_delta;
> +	int err;
>  
>  	if (has_persistent_clock())
>  		return 0;
> @@ -61,7 +62,12 @@ static int rtc_suspend(struct device *dev)
>  		return 0;
>  
>  	/* snapshot the current RTC and system time at suspend*/
> -	rtc_read_time(rtc, &tm);
> +	err = rtc_read_time(rtc, &tm);
> +	if (err < 0) {
> +		pr_debug("%s:  fail to read rtc time\n", dev_name(&rtc->dev));
> +		return 0;
> +	}

OK, it makes no sense to go ahead and set the system time from a
garbage rtc_time.

But I'm wondering if we should propagate the error back to the
rtc_suspend() caller.  What does the PM core do if a particular
device's ->suspend or ->resume fails?

>  	getnstimeofday(&old_system);
>  	rtc_tm_to_time(&tm, &old_rtc.tv_sec);
>  
> @@ -94,6 +100,7 @@ static int rtc_resume(struct device *dev)
>  	struct rtc_time		tm;
>  	struct timespec		new_system, new_rtc;
>  	struct timespec		sleep_time;
> +	int err;
>  
>  	if (has_persistent_clock())
>  		return 0;
> @@ -104,7 +111,12 @@ static int rtc_resume(struct device *dev)
>  
>  	/* snapshot the current rtc and system time at resume */
>  	getnstimeofday(&new_system);
> -	rtc_read_time(rtc, &tm);
> +	err = rtc_read_time(rtc, &tm);
> +	if (err < 0) {
> +		pr_debug("%s:  fail to read rtc time\n", dev_name(&rtc->dev));
> +		return 0;
> +	}
> +
>  	if (rtc_valid_tm(&tm) != 0) {
>  		pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
>  		return 0;

