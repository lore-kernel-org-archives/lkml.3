Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3CSMik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:38:40 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47616 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3CSMij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:38:39 -0400
X-Greylist: delayed 158707 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Mar 2013 08:38:39 EDT
Message-ID: <1363696716.21184.45.camel@edumazet-glaptop>
Subject: Re: [PATCH] ktime_add_ns() may overflow on 32bit architectures
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Engraf <david.engraf@sysgo.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 05:38:36 -0700
In-Reply-To: <51485A43.4020600@sysgo.com>
References: <51485A43.4020600@sysgo.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 13:29 +0100, David Engraf wrote:
> Hello,
> 
> I've triggered an overflow when using ktime_add_ns() on a 32bit 
> architecture not supporting CONFIG_KTIME_SCALAR.
> 
> When passing a very high value for u64 nsec, e.g. 7881299347898368000 
> the do_div() function converts this value to seconds (7881299347) which 
> is still to high to pass to the ktime_set() function as long. The result 
> in my case is a negative value.
> 
> The problem on my system occurs in the tick-sched.c, 
> tick_nohz_stop_sched_tick() when time_delta is set to 
> timekeeping_max_deferment(). The check for time_delta < KTIME_MAX is 
> valid, thus ktime_add_ns() is called with a too large value resulting in 
> a negative expire value. This leads to an endless loop in the ticker code:
> 
> time_delta: 7881299347898368000
> expires = ktime_add_ns(last_update, time_delta)
> expires: negative value
> 
> This error doesn't occurs on 64bit or architectures supporting 
> CONFIG_KTIME_SCALAR (e.g. ARM, x86-32).
> 
> Best regards
> - David
> 
> Signed-off-by: David Engraf <david.engraf@sysgo.com>
> 

But check already exists for 64bit arches in ktime_set()



