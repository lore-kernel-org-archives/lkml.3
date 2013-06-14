Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3FNTVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:21:01 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37790 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3FNTU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:20:59 -0400
Message-ID: <51BB6D18.3010806@linaro.org>
Date: Fri, 14 Jun 2013 12:20:56 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 8/9] RFC: rtc: hctosys: support rtc_read_timeval() for
 high precision clocks
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-9-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1371228732-5749-9-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 09:52 AM, Alexander Holler wrote:
> Some RTCs do provide a higher precision than seconds. Add support for them
> by trying rtc_read_timeval() before using rtc_read_time() to get the time
> in the hctosys mechanism.
>
>
[snip]
> +	rc = rtc_read_timeval(rtc, &tv);
> +	if (rc || (!tv.tv_sec && !tv.tv_usec)) {
> +		rc = rtc_read_time(rtc, &now);
> +		if (unlikely(rc)) {
> +			dev_err(rtc->dev.parent,
> +				"rtc core: error reading time from RTC: %d\n",
> +				rc);
> +			return;
> +		}
> +		rtc_tm_to_time(&now, &ts.tv_sec);
> +		ts.tv_nsec = NSEC_PER_SEC >> 1;
> +	} else {
> +		rtc_time_to_tm(tv.tv_sec, &now);
> +		ts.tv_sec = tv.tv_sec;
> +		ts.tv_nsec = tv.tv_usec*NSEC_PER_USEC;


Yea, this sort of fallback logic should be centralized in the RTC layer 
rather then in the individual users.

Might be easiest to modify the rtc_read_timeval() interface to try the 
ops->read_timeval() operation and do the fallback to rtc_read_time() 
internally.

thanks
-john

