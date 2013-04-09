Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937456Ab3DIKJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:09:52 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64237 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936275Ab3DIKJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:09:50 -0400
X-AuditID: cbfec7f4-b7f4c6d0000018de-fb-5163e8ecd932
Message-id: <5163E8EB.1050803@samsung.com>
Date: Tue, 09 Apr 2013 12:09:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, a.zummo@towertech.it,
        kgene.kim@samsung.com, dianders@chromium.org
Subject: Re: [PATCH RFC] rtc: rtc-s3c: use clk_prepare_enable and
 clk_disable_unprepare
References: <1365500744-14839-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1365500744-14839-1-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xy7pvXiQHGkx7LWmx5OJVdouzyw6y
	WbRdOchu0bvgKpvF5V1z2CxmnN/HZLG/s4PRgd1jdsNFFo89E0+yefRtWcXoMX3eTyaPz5vk
	AlijuGxSUnMyy1KL9O0SuDIOzz/PWPBQt+LJDrMGxhdqXYycHBICJhLLl99gh7DFJC7cW8/W
	xcjFISSwlFGi8fQBsISQwCdGiQcbrEFsXgEtib8dk8DiLAKqEl+37GcFsdkEDCV6j/Yxgtii
	AgESi5ecY4eoF5T4MfkeC4gtIqAtsX3uJLB6ZoHljBLHH8uC2MICkRKnd0xigtjlIXH63FWw
	Xk4BT4m5B68wQdTrSOxvncYGYctLbF7zlnkCo8AsJCtmISmbhaRsASPzKkbR1NLkguKk9FxD
	veLE3OLSvHS95PzcTYyQEP+yg3HxMatDjAIcjEo8vJWPkgKFWBPLiitzDzFKcDArifC23EkO
	FOJNSaysSi3Kjy8qzUktPsTIxMEp1cBo96Js79o9DqonVm3fcOpexb5fv0429n86ZctSJh7U
	4Ki6a81ye9uXPneLFigenrJ5zlIn+/28r1fs+hVUMU/39VY/raD4lZml1tt33k08+Tjmh4n4
	hbRtDZ6ZQdUmv9JOJH36rMj7/IgX8wOFpAjDNBFO873lJYpJ7VPtDz2z4Dqt1chlYLBKiaU4
	I9FQi7moOBEAo1iGWU8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 11:45 AM, Vivek Gautam wrote:
> Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
> calls as required by common clock framework, to get rid of
> WARN_ON on prepare_count.

Hmm, do you think warnings like below are any better that WARN_ON() on wrong
clock's prepare_count value ? :)

> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
> 
> This fixes the warnings in the boot log coming out of enabling
> the common clock framework in exynos platform.
> 
> However, on doing system suspend/resume using rtc wake mechanism
> we still get following warning dump for the first time we suspend
> using commands:
>     echo +10 > /sys/class/rtc/rtc0/wakealarm
>     echo mem > /sys/power/state
> 
> [   12.530000] ------------[ cut here ]------------
> [   12.530000] WARNING: at kernel/mutex.c:199 __mutex_lock_slowpath+0x2c0/0x340()
> [   12.530000] Modules linked in:
> [   12.530000] [<80014c60>] (unwind_backtrace+0x0/0xf8) from [<8001ebd0>] (warn_slowpath_common+0x54/0x68)
> [   12.530000] [<8001ebd0>] (warn_slowpath_common+0x54/0x68) from [<8001ec00>] (warn_slowpath_null+0x1c/0x24)
> [   12.530000] [<8001ec00>] (warn_slowpath_null+0x1c/0x24) from [<8033f548>] (__mutex_lock_slowpath+0x2c0/0x340)
> [   12.530000] [<8033f548>] (__mutex_lock_slowpath+0x2c0/0x340) from [<8033f5d4>] (mutex_lock+0xc/0x24)
> [   12.530000] [<8033f5d4>] (mutex_lock+0xc/0x24) from [<80299e18>] (clk_prepare+0x18/0x34)
> [   12.530000] [<80299e18>] (clk_prepare+0x18/0x34) from [<802862d8>] (s3c_rtc_alarmirq+0x1c/0x98)
> [   12.530000] [<802862d8>] (s3c_rtc_alarmirq+0x1c/0x98) from [<8006ad78>] (handle_irq_event_percpu+0x54/0x194)
> [   12.530000] [<8006ad78>] (handle_irq_event_percpu+0x54/0x194) from [<8006aef4>] (handle_irq_event+0x3c/0x5c)
> [   12.530000] [<8006aef4>] (handle_irq_event+0x3c/0x5c) from [<8006db00>] (handle_fasteoi_irq+0xa4/0x134)
> [   12.530000] [<8006db00>] (handle_fasteoi_irq+0xa4/0x134) from [<8006a594>] (generic_handle_irq+0x30/0x40)
> [   12.530000] [<8006a594>] (generic_handle_irq+0x30/0x40) from [<8000f4fc>] (handle_IRQ+0x40/0x90)
> [   12.530000] [<8000f4fc>] (handle_IRQ+0x40/0x90) from [<80008544>] (gic_handle_irq+0x38/0x68)
> [   12.530000] [<80008544>] (gic_handle_irq+0x38/0x68) from [<8000e200>] (__irq_svc+0x40/0x70)
> [   12.530000] Exception stack(0x8182be60 to 0x8182bea8)
> [   12.530000] be60: 00000000 00000000 0000000c ffffffff 60000013 8049fc50 00000000 80479a10
> [   12.530000] be80: 60000013 ee97de98 804799c0 00000001 0000000d 8182bea8 803412dc 803412e0
> [   12.530000] bea0: 60000013 ffffffff
> [   12.530000] [<8000e200>] (__irq_svc+0x40/0x70) from [<803412e0>] (_raw_spin_unlock_irqrestore+0x10/0x38)
> [   12.530000] [<803412e0>] (_raw_spin_unlock_irqrestore+0x10/0x38) from [<80070bc4>] (resume_irqs+0x9c/0xb8)
> [   12.530000] [<80070bc4>] (resume_irqs+0x9c/0xb8) from [<8021d528>] (dpm_resume_start+0xc/0x18)
> [   12.530000] [<8021d528>] (dpm_resume_start+0xc/0x18) from [<800544ac>] (suspend_devices_and_enter+0x118/0x2e4)
> [   12.530000] [<800544ac>] (suspend_devices_and_enter+0x118/0x2e4) from [<80054814>] (pm_suspend+0x19c/0x214)
> [   12.530000] [<80054814>] (pm_suspend+0x19c/0x214) from [<80053a58>] (state_store+0x120/0x12c)
> [   12.530000] [<80053a58>] (state_store+0x120/0x12c) from [<801ae9d8>] (kobj_attr_store+0x14/0x20)
> [   12.530000] [<801ae9d8>] (kobj_attr_store+0x14/0x20) from [<801092c8>] (sysfs_write_file+0xfc/0x17c)
> [   12.530000] [<801092c8>] (sysfs_write_file+0xfc/0x17c) from [<800b0d84>] (vfs_write+0xa8/0x138)
> [   12.530000] [<800b0d84>] (vfs_write+0xa8/0x138) from [<800b10e4>] (sys_write+0x40/0x68)
> [   12.530000] [<800b10e4>] (sys_write+0x40/0x68) from [<8000e600>] (ret_fast_syscall+0x0/0x30)
> [   12.530000] ---[ end trace 8643216fba2e8cb5 ]---
> 
>  drivers/rtc/rtc-s3c.c |   58 ++++++++++++++++++++++++------------------------
>  1 files changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
> index fb994e9..75637ad 100644
> --- a/drivers/rtc/rtc-s3c.c
> +++ b/drivers/rtc/rtc-s3c.c
> @@ -65,12 +65,12 @@ static void s3c_rtc_alarm_clk_enable(bool enable)
>  	spin_lock_irqsave(&s3c_rtc_alarm_clk_lock, irq_flags);
>  	if (enable) {
>  		if (!alarm_clk_enabled) {
> -			clk_enable(rtc_clk);
> +			clk_prepare_enable(rtc_clk);
>  			alarm_clk_enabled = true;
>  		}
>  	} else {
>  		if (alarm_clk_enabled) {
> -			clk_disable(rtc_clk);
> +			clk_disable_unprepare(rtc_clk);
>  			alarm_clk_enabled = false;
>  		}
>  	}
> @@ -83,13 +83,13 @@ static irqreturn_t s3c_rtc_alarmirq(int irq, void *id)
>  {
>  	struct rtc_device *rdev = id;
>  
> -	clk_enable(rtc_clk);
> +	clk_prepare_enable(rtc_clk);

The reason for the above failure is that clk_prepare is called from an interrupt
context. You are not supposed to use clk_prepare_enable()/clk_unprepare_disble()
like this. Instead, prepare the clock in s3c_rtc_probe() and unprepare in the
driver's remove() callback. And clk_enable()/clk_disable calls could stay untouched.

>  	rtc_update_irq(rdev, 1, RTC_AF | RTC_IRQF);
>  
>  	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
>  		writeb(S3C2410_INTP_ALM, s3c_rtc_base + S3C2410_INTP);
>  
> -	clk_disable(rtc_clk);
> +	clk_disable_unprepare(rtc_clk);
>  
>  	s3c_rtc_alarm_clk_enable(false);
>  
> @@ -100,13 +100,13 @@ static irqreturn_t s3c_rtc_tickirq(int irq, void *id)
>  {
>  	struct rtc_device *rdev = id;
>  
> -	clk_enable(rtc_clk);
> +	clk_prepare_enable(rtc_clk);
>  	rtc_update_irq(rdev, 1, RTC_PF | RTC_IRQF);
>  
>  	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
>  		writeb(S3C2410_INTP_TIC, s3c_rtc_base + S3C2410_INTP);
>  
> -	clk_disable(rtc_clk);
> +	clk_disable_unprepare(rtc_clk);
>  	return IRQ_HANDLED;
>  }

Regards,
Sylwester

