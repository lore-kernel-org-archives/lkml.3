Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab3C2Sci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:32:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52707 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3C2Scg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:32:36 -0400
X-IronPort-AV: E=Sophos;i="4.87,374,1363158000"; 
   d="scan'208";a="33863269"
Message-ID: <5155DE43.4000601@codeaurora.org>
Date: Fri, 29 Mar 2013 11:32:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: ning.n.jiang@gmail.com
CC: linux@arm.linux.org.uk, kgene.kim@samsung.com, davidb@codeaurora.org,
        dwalker@fifo99.com, bryanh@codeaurora.org, john.stultz@linaro.org,
        tglx@linutronix.de, linus.walleij@linaro.org, shawn.guo@linaro.org,
        rob.herring@calxeda.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: timer: Shutdown clock event device when stopping
 local timer
References: <1364549049-29278-1-git-send-email-ning.n.jiang@gmail.com>
In-Reply-To: <1364549049-29278-1-git-send-email-ning.n.jiang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/13 02:24, ning.n.jiang@gmail.com wrote:
> From: Ning Jiang <ning.n.jiang@gmail.com>
>
> Currently there are two problems when we try to stop local timer.
> First, it calls set_mode function directly so mode state is not
> updated for the clock event device. Second, it makes the device
> unused instead of shutdown.

What device is this a problem on? I believe this only matters to drivers
which enable their timer in their set_next_event() callback? But even
then, does anything actually happen because the interrupt should have
been disabled in the local timer stop callback.

>
> A subtle error will happen because of it. When a cpu is plugged out
> it will stop the local timer. It will call tick_nohz_idle_enter()
> in idle thread afterwards. It will cancel the sched timer and try
> to reprogram the next event. This is wrong since the local timer
> is supposed to be stopped.
>
> The right way to stop the local timer is to shutdown it by calling
> clockevents_set_mode(). Thus when we try to reprogram the clock
> event device, it will return directly without doing anything since
> the clock mode is CLOCK_EVT_MODE_SHUTDOWN.

While this prevents the set_next_event() callback from being called on a
dying CPU, wouldn't it be better to fix this problem in the core code
once instead of fixing it many times in each local timer driver? It
doesn't seem to make much sense to program an event on a CPU that is
about to die, so why do we do that?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

