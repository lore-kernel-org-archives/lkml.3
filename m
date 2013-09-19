Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3ISTMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 15:12:35 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:48685 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3ISTMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 15:12:34 -0400
Message-ID: <523B4C9B.6000002@gmail.com>
Date: Thu, 19 Sep 2013 21:12:27 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/26] clk: vt8500: parse pmc_base from clock driver
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com> <1379526839-14798-8-git-send-email-sebastian.hesselbarth@gmail.com> <523B4A51.4020704@prisktech.co.nz>
In-Reply-To: <523B4A51.4020704@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 09:02 PM, Tony Prisk wrote:
> On 19/09/13 05:53, Sebastian Hesselbarth wrote:
>> Currently, clock providers for vt8500 depend on machine_init providing
>> pmc_base address before calling of_clk_init. With upcoming arch-wide
>> .time_init calling of_clk_init, we should make clock providers
>> independent
>> of mach code. This adds a pmc_base parsing helper to current clock
>> provider
>> that gets called if there is no pmc_base set, yet.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Tony Prisk <linux@prisktech.co.nz>
>> Cc: Mike Turquette <mturquette@linaro.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   drivers/clk/clk-vt8500.c |   21 +++++++++++++++++++++
>>   1 file changed, 21 insertions(+)
>>
>> diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
>> index 82306f5..a5ee01c 100644
>> --- a/drivers/clk/clk-vt8500.c
>> +++ b/drivers/clk/clk-vt8500.c
>> @@ -15,11 +15,14 @@
>>   #include <linux/io.h>
>>   #include <linux/of.h>
>> +#include <linux/of_address.h>
>>   #include <linux/slab.h>
>>   #include <linux/bitops.h>
>>   #include <linux/clkdev.h>
>>   #include <linux/clk-provider.h>
>> +#define LEGACY_PMC_BASE        0xD8130000
>> +
>>   /* All clocks share the same lock as none can be changed
>> concurrently */
>>   static DEFINE_SPINLOCK(_lock);
>> @@ -626,6 +629,21 @@ const struct clk_ops vtwm_pll_ops = {
>>       .recalc_rate = vtwm_pll_recalc_rate,
>>   };
>> +static __init void vtwm_set_pmc_base(void)
>> +{
>> +    struct device_node *np =
>> +        of_find_compatible_node(NULL, NULL, "via,vt8500-pmc");
>> +
>> +    if (np)
>> +        pmc_base = of_iomap(np, 0);
>> +    else
>> +        pmc_base = ioremap(LEGACY_PMC_BASE, 0x1000);
>> +    of_node_put(np);
>> +
>> +    if (!pmc_base)
>> +        pr_err("%s:of_iomap(pmc) failed\n", __func__);
>> +}
>> +
>>   static __init void vtwm_pll_clk_init(struct device_node *node, int
>> pll_type)
>>   {
>>       u32 reg;
>> @@ -636,6 +654,9 @@ static __init void vtwm_pll_clk_init(struct
>> device_node *node, int pll_type)
>>       struct clk_init_data init;
>>       int rc;
>> +    if (!pmc_base)
>> +        vtwm_set_pmc_base();
>> +
>>       rc = of_property_read_u32(node, "reg", &reg);
>>       if (WARN_ON(rc))
>>           return;
> What happens if the first clock registered is a 'device clock' rather
> than a 'pll'?
>
> static __init void vtwm_device_clk_init(struct device_node *node)
> {
>      u32 en_reg, div_reg;
>      struct clk *clk;
>      struct clk_device *dev_clk;
>      const char *clk_name = node->name;
>      const char *parent_name;
>      struct clk_init_data init;
>      int rc;
>      int clk_init_flags = 0;
>
>      dev_clk = kzalloc(sizeof(*dev_clk), GFP_KERNEL);
>      if (WARN_ON(!dev_clk))
>          return;
>
>      dev_clk->lock = &_lock;
>
>      rc = of_property_read_u32(node, "enable-reg", &en_reg);
>      if (!rc) {
>          dev_clk->en_reg = pmc_base + en_reg;
> ...
> }
> CLK_OF_DECLARE(vt8500_device, "via,vt8500-device-clock",
> vtwm_device_clk_init);
>
> If a device clock is initialized first, pmc_base will be null and
> dev_clk->en_reg (+ other register offsets) will be incorrect.

Tony,

looks like I just missed to add the same check for !pmc_base to
vtwm_device_clk_init. If you are ok with the general approach,
I send v2 for this patch shortly.

Optionally, you can also choose to take care of clk-vt8500 yourself,
as mach-vt8500 has its own .init_time callback and will be unaffected
by the arch-wide default callback. If so, I will drop vt8500 to not
stall this series too much now.

Sebastian

