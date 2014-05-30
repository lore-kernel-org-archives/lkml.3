Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaE3FDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:03:17 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43078 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaE3FDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:03:15 -0400
Message-ID: <53881102.1080406@gmail.com>
Date: Fri, 30 May 2014 07:02:58 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>
CC: olof@lixom.net, javier.martinez@collabora.co.uk,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: exynos5420: Keep aclk66_peric enabled during boot
References: <1401398496-4624-1-git-send-email-dianders@chromium.org> <20140529222904.10062.22764@quantum>
In-Reply-To: <20140529222904.10062.22764@quantum>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 30.05.2014 00:29, Mike Turquette wrote:
> Quoting Doug Anderson (2014-05-29 14:21:36)
>> Right now if you've got earlyprintk enabled on exynos5420-peach-pit
>> then you'll get a hang on boot.  Here's why:
>>
>> 1. The i2c-s3c2410 driver will probe at subsys_initcall.  It will
>>    enable its clock and disable it.  This is the clock "i2c2".
>> 2. The act of disabling "i2c2" will disable its parents.  In this case
>>    the parent is "aclk66_peric".  There are no other children of
>>    "aclk66_peric" officially enabled, so "aclk66_peric" will be turned
>>    off (despite being CLK_IGNORE_UNUSED, but that's by design).
>> 3. The next time you try to earlyprintk you'll do so without the UART
>>    clock enabled.  That's because the UART clocks are also children of
>>    "aclk66_peric".  You'll hang.
>>
>> There's no good place to put a clock enable for earlyprintk, which is
>> handled by a bunch of assembly code.  The best we can do is to handle
>> this in the clock driver.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  drivers/clk/samsung/clk-exynos5420.c | 24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
>> index 9d7d7ee..1e586be 100644
>> --- a/drivers/clk/samsung/clk-exynos5420.c
>> +++ b/drivers/clk/samsung/clk-exynos5420.c
>> @@ -1172,11 +1172,17 @@ static struct of_device_id ext_clk_match[] __initdata = {
>>         { },
>>  };
>>  
>> +/* Keep these clocks on until late_initcall */
>> +static const char *boot_clocks[] __initconst = {
>> +       "aclk66_peric",
>> +};
>> +
>>  /* register exynos5420 clocks */
>>  static void __init exynos5x_clk_init(struct device_node *np,
>>                 enum exynos5x_soc soc)
>>  {
>>         struct samsung_clk_provider *ctx;
>> +       int i;
>>  
>>         if (np) {
>>                 reg_base = of_iomap(np, 0);
>> @@ -1226,6 +1232,12 @@ static void __init exynos5x_clk_init(struct device_node *np,
>>         }
>>  
>>         exynos5420_clk_sleep_init();
>> +
>> +       for (i = 0; i < ARRAY_SIZE(boot_clocks); i++) {
>> +               struct clk *to_enable = __clk_lookup(boot_clocks[i]);
> 
> How about replacing __clk_lookup with clk_get? You can keep the struct
> clk object hanging around for later...
> 

Mike, correct me if I'm wrong, but I thought you need clkdev look-up
entry for clk_get() to find a clock. Here, this clock apparently don't
have one and you don't even have a struct device * to pass to clk_get(),
so even if you had a look-up entry, it would need to be a wildcard entry
(with NULL device), which wouldn't be too elegant.

Doug, isn't a similar thing needed for PM debug as well? Maybe having
this clock always ungated whenever DEBUG_LL is enabled would be enough?

Best regards,
Tomasz
