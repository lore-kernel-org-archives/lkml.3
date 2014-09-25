Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaIYJQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:16:20 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42040 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaIYJQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:16:13 -0400
Message-ID: <5423DD53.3030805@samsung.com>
Date: Thu, 25 Sep 2014 18:16:03 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linaro-kernel@lists.linaro.org, linux-tegra@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 2/5] ARM: add AFTR mode support to firmware do_idle
 method
References: <1411561488-1739-1-git-send-email-b.zolnierkie@samsung.com> <1411561488-1739-3-git-send-email-b.zolnierkie@samsung.com> <5423D104.4050809@samsung.com> <20140925090310.GA12046@ulmo>
In-Reply-To: <20140925090310.GA12046@ulmo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/14 18:03, Thierry Reding wrote:
> On Thu, Sep 25, 2014 at 05:23:32PM +0900, Kukjin Kim wrote:
>> On 09/24/14 21:24, Bartlomiej Zolnierkiewicz wrote:
>>> On some platforms (i.e. EXYNOS ones) more than one idle mode is
>>> available and we need to distinguish them in firmware do_idle method.
>>>
>>> Add mode parameter to do_idle firmware method and AFTR mode support
>>> to EXYNOS do_idle implementation.
>>>
>>> This change is a preparation for adding secure firmware support to
>>> EXYNOS cpuidle driver.
>>>
>>> This patch shouldn't cause any functionality changes.
>>>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz<b.zolnierkie@samsung.com>
>>> Acked-by: Kyungmin Park<kyungmin.park@samsung.com>
>>> ---
>>> v7:
>>> - fixed build on Tegra
>>> - updated summary line
>>>
>>>   arch/arm/include/asm/firmware.h        |  2 +-
>>>   arch/arm/mach-exynos/common.h          |  5 +++++
>>>   arch/arm/mach-exynos/firmware.c        | 10 ++++++++--
>>>   arch/arm/mach-tegra/cpuidle-tegra114.c |  2 +-
>>>   4 files changed, 15 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firmware.h
>>> index 5904f59..89aefe1 100644
>>> --- a/arch/arm/include/asm/firmware.h
>>> +++ b/arch/arm/include/asm/firmware.h
>>> @@ -28,7 +28,7 @@ struct firmware_ops {
>>>   	/*
>>>   	 * Enters CPU idle mode
>>>   	 */
>>> -	int (*do_idle)(void);
>>> +	int (*do_idle)(unsigned long mode);
>>>   	/*
>>>   	 * Sets boot address of specified physical CPU
>>>   	 */
>>> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
>>> index c218200..2d830df 100644
>>> --- a/arch/arm/mach-exynos/common.h
>>> +++ b/arch/arm/mach-exynos/common.h
>>> @@ -119,6 +119,11 @@ extern void __iomem *sysram_base_addr;
>>>   extern void __iomem *pmu_base_addr;
>>>   void exynos_sysram_init(void);
>>>
>>> +enum {
>>> +	FW_DO_IDLE_SLEEP,
>>> +	FW_DO_IDLE_AFTR,
>>> +};
>>> +
>>>   void exynos_firmware_init(void);
>>>
>>>   extern u32 exynos_get_eint_wake_mask(void);
>>> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
>>> index f5e626d..e57b7c3 100644
>>> --- a/arch/arm/mach-exynos/firmware.c
>>> +++ b/arch/arm/mach-exynos/firmware.c
>>> @@ -28,9 +28,15 @@
>>>   #define EXYNOS_BOOT_ADDR	0x8
>>>   #define EXYNOS_BOOT_FLAG	0xc
>>>
>>> -static int exynos_do_idle(void)
>>> +static int exynos_do_idle(unsigned long mode)
>>>   {
>>> -	exynos_smc(SMC_CMD_SLEEP, 0, 0, 0);
>>> +	switch (mode) {
>>> +	case FW_DO_IDLE_AFTR:
>>> +		exynos_smc(SMC_CMD_CPU0AFTR, 0, 0, 0);
>>> +		break;
>>> +	case FW_DO_IDLE_SLEEP:
>>> +		exynos_smc(SMC_CMD_SLEEP, 0, 0, 0);
>>> +	}
>>>   	return 0;
>>>   }
>>>
>>> diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegra/cpuidle-tegra114.c
>>> index e3ebdce..425b6c8 100644
>>> --- a/arch/arm/mach-tegra/cpuidle-tegra114.c
>>> +++ b/arch/arm/mach-tegra/cpuidle-tegra114.c
>>> @@ -49,7 +49,7 @@ static int tegra114_idle_power_down(struct cpuidle_device *dev,
>>>   	call_firmware_op(prepare_idle);
>>>
>>>   	/* Do suspend by ourselves if the firmware does not implement it */
>>> -	if (call_firmware_op(do_idle) == -ENOSYS)
>>> +	if (call_firmware_op(do_idle, 0) == -ENOSYS)
>>>   		cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
>>>
>>>   	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT,&dev->cpu);
>>
>> + Thierry(using nvidia.com e-mail address)
>>
>> Hi Thierry,
>>
>> For supporting AFTR mode in call_firmware_op(do_idle), need to modify tegra
>> stuff as you can see. The functionality will be same with before. Is it OK
>> to you? If you have no objection, I'd like to take this series into samsung
>> tree.
>
> I'm only aware of any devices using TrustedFirmware on Tegra, which is
> what the above code handles. The implementation for TrustedFirmware does
> not implement do_idle() (yet?) so I don't think this patch would cause
> any damage.
>
> Acked-by: Thierry Reding<treding@nvidia.com>
>
Thanks, I've applied this whole series.

- Kukjin
