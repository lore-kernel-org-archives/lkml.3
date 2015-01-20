Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbbATHTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:19:14 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:51649 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbbATHSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:18:41 -0500
MIME-Version: 1.0
In-Reply-To: <20150119160039.22722.67992@quantum>
References: <1420797291-15972-1-git-send-email-pi-cheng.chen@linaro.org>
	<1420797291-15972-3-git-send-email-pi-cheng.chen@linaro.org>
	<20150119160039.22722.67992@quantum>
Date: Tue, 20 Jan 2015 15:18:39 +0800
Message-ID: <CALx668Xn8Qz-B0RFYusyQPwnCsY8GwTRZw4r8kQyr3T6BRM8oA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: add cpufreq driver for Mediatek MT8173 SoC
From: Pi-Cheng Chen <pi-cheng.chen@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 January 2015 at 00:00, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting pi-cheng.chen (2015-01-09 01:54:51)
>> diff --git a/drivers/cpufreq/mt8173-cpufreq.c b/drivers/cpufreq/mt8173-cpufreq.c
>> new file mode 100644
>> index 0000000..b578c10
>> --- /dev/null
>> +++ b/drivers/cpufreq/mt8173-cpufreq.c
>> @@ -0,0 +1,459 @@

Hello Mike,

>
> Hello Pi-Cheng,
>
> <snip>
>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/cpufreq.h>
>> +#include <linux/cpufreq-dt.h>
>> +#include <linux/cpumask.h>
>> +#include <linux/slab.h>
>> +#include <linux/clk.h>
>> +#include <linux/clk-provider.h>
>
> I'll echo what Viresh said here. CPUfreq drivers should typically be
> clock consumers and only require clk.h, not clk-provider.h. More on that
> below.
>

I included it because of the __clk_lookup call. But yes, I will use the clk_get
to get the intermediate clock to get rid of this.

> <snip>
>
>> +static void cpuclk_mux_set(int cluster, u32 sel)
>> +{
>> +       u32 val;
>> +       u32 mask = 0x3;
>> +
>> +       if (cluster == BIG_CLUSTER) {
>> +               mask <<= 2;
>> +               sel <<= 2;
>> +       }
>> +
>> +       spin_lock(&lock);
>> +
>> +       val = readl(clk_mux_regs);
>> +       val = (val & ~mask) | sel;
>> +       writel(val, clk_mux_regs);
>> +
>> +       spin_unlock(&lock);
>> +}
>
> Is cpuclk a mux that is represented in the MT8173 clock driver? It looks
> like a clock that belong to the clock driver, but this cpufreq driver is
> writing to that register directly.
>

Yes, it's a mux but not presented in MT8173 clock driver yet. Therefore I
map the HW register and writing them directly to do reparent. I will get
rid of it once I got those muxes presented in MT8173 clock driver.

> <snip>
>
>> +static int mt8173_cpufreq_dvfs_info_init(void)
>> +{
>
> <snip>
>
>> +       mainpll = __clk_lookup("mainpll");
>> +       if (!mainpll) {
>> +               pr_err("failed to get mainpll clk\n");
>> +               ret = -ENOENT;
>> +               goto dvfs_info_release;
>> +       }
>> +       mainpll_freq = clk_get_rate(mainpll);
>
> This is definitely bad. Why not use clk_get() here? __clk_lookup should
> not be exposed to clock consumer drivers (and I hope to get rid of it
> completely some day).
>

Thanks for pointing me out the right API to do it. I will fix it in
next version.

Best Regards,
Pi-Cheng

> Regards,
> Mike
