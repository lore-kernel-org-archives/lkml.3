Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab3DWQme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:42:34 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39559 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab3DWQma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:42:30 -0400
Message-ID: <5176B9F1.3030300@samsung.com>
Date: Wed, 24 Apr 2013 01:42:25 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Tushar Behera <tushar.behera@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, olofj@chromium.org, patches@linaro.org
Subject: Re: [PATCH] clk: exynos5250: Fix parent clock for sclk_mmc{0,1,2,3}
References: <CAD=FV=UUg9Apb0o+zLdidDUmkLZt1phgo80bxug=o6JmANCPfw@mail.gmail.com> <1366698711-15470-1-git-send-email-tushar.behera@linaro.org> <20130423162349.17530.35976@quantum>
In-Reply-To: <20130423162349.17530.35976@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/13 01:23, Mike Turquette wrote:
> Quoting Tushar Behera (2013-04-22 23:31:51)
>> commit 688f7d8c9fef ("clk: exynos5250: Fix divider values for
>> sclk_mmc{0,1,2,3}") incorrectly sets the divider for sclk_mmc{0,1,2,3}
>> to fix the wrong clock value. Though this fixed issue with Arndale,
>> it created regressions for other boards like Snow.
>>
>> On Exynos5250, sclk_mmc<n>  is generated like below (as per the clock
>> names in drivers/clk/samsung/clk-exynos5250.c)
>>
>> mout_group1_p ==>  mout_mmc<n>  ==>
>>                  div_mmc<n>  ==>  div_mmc_pre<n>  =>  sclk_mmc<n>
>>
>> Earlier div_mmc<n>  was set as the parent for sclk_mmc<n>, hence
>> div_mmc_pre<n>  was not getting referred in kernel code and depending
>> on its value set during preboot, sclk_mmc<n>  value was different for
>> various boards.
>>
>> Setting the correct clock generation path should fix the issues
>> reported in above referenced commit. The changes committed during the
>> earlier patch has also been reverted here.
>>
>> Signed-off-by: Tushar Behera<tushar.behera@linaro.org>
>> CC: Doug Anderson<dianders@chromium.org>
>
> Change looks good to me.
>

+1

Olof, I think, you can pick this up in the arm-soc directly.

If you want:
Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

>> ---
>> Doug,
>>
>> Would you please test whether this patch works for Snow?
>>
>>
>>   drivers/clk/samsung/clk-exynos5250.c |   16 ++++++++--------
>>   1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
>> index 7290faa..bb54606 100644
>> --- a/drivers/clk/samsung/clk-exynos5250.c
>> +++ b/drivers/clk/samsung/clk-exynos5250.c
>> @@ -276,10 +276,10 @@ struct samsung_div_clock exynos5250_div_clks[] __initdata = {
>>          DIV(none, "div_pcm0", "sclk_audio0", DIV_MAU, 4, 8),
>>          DIV(none, "div_sata", "mout_sata", DIV_FSYS0, 20, 4),
>>          DIV(none, "div_usb3", "mout_usb3", DIV_FSYS0, 24, 4),
>> -       DIV(none, "div_mmc0", "mout_mmc0", DIV_FSYS1, 8, 8),
>> -       DIV(none, "div_mmc1", "mout_mmc1", DIV_FSYS1, 24, 8),
>> -       DIV(none, "div_mmc2", "mout_mmc2", DIV_FSYS2, 8, 8),
>> -       DIV(none, "div_mmc3", "mout_mmc3", DIV_FSYS2, 24, 8),
>> +       DIV(none, "div_mmc0", "mout_mmc0", DIV_FSYS1, 0, 4),
>> +       DIV(none, "div_mmc1", "mout_mmc1", DIV_FSYS1, 16, 4),
>> +       DIV(none, "div_mmc2", "mout_mmc2", DIV_FSYS2, 0, 4),
>> +       DIV(none, "div_mmc3", "mout_mmc3", DIV_FSYS2, 16, 4),
>>          DIV(none, "div_uart0", "mout_uart0", DIV_PERIC0, 0, 4),
>>          DIV(none, "div_uart1", "mout_uart1", DIV_PERIC0, 4, 4),
>>          DIV(none, "div_uart2", "mout_uart2", DIV_PERIC0, 8, 4),
>> @@ -421,13 +421,13 @@ struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
>>                          SRC_MASK_DISP1_0, 20, 0, 0),
>>          GATE(sclk_audio0, "sclk_audio0", "div_audio0",
>>                          SRC_MASK_MAU, 0, CLK_SET_RATE_PARENT, 0),
>> -       GATE(sclk_mmc0, "sclk_mmc0", "div_mmc0",
>> +       GATE(sclk_mmc0, "sclk_mmc0", "div_mmc_pre0",
>>                          SRC_MASK_FSYS, 0, CLK_SET_RATE_PARENT, 0),
>> -       GATE(sclk_mmc1, "sclk_mmc1", "div_mmc1",
>> +       GATE(sclk_mmc1, "sclk_mmc1", "div_mmc_pre1",
>>                          SRC_MASK_FSYS, 4, CLK_SET_RATE_PARENT, 0),
>> -       GATE(sclk_mmc2, "sclk_mmc2", "div_mmc2",
>> +       GATE(sclk_mmc2, "sclk_mmc2", "div_mmc_pre2",
>>                          SRC_MASK_FSYS, 8, CLK_SET_RATE_PARENT, 0),
>> -       GATE(sclk_mmc3, "sclk_mmc3", "div_mmc3",
>> +       GATE(sclk_mmc3, "sclk_mmc3", "div_mmc_pre3",
>>                          SRC_MASK_FSYS, 12, CLK_SET_RATE_PARENT, 0),
>>          GATE(sclk_sata, "sclk_sata", "div_sata",
>>                          SRC_MASK_FSYS, 24, CLK_SET_RATE_PARENT, 0),
>> --
>> 1.7.9.5
