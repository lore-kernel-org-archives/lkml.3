Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3C0Jz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:55:56 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:42998 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369Ab3C0Jzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:55:54 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Mike Turquette <mike.turquette@linaro.org>
Cc: Maxime Coquelin <maxime_coquelin@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 27 Mar 2013 10:55:47 +0100
Subject: Re: [PATCH] clk: ux500: Fix prcmu clocks registration
Thread-Topic: [PATCH] clk: ux500: Fix prcmu clocks registration
Thread-Index: Ac4q0UGGBghkOw5vTlCLkdPvR0EYRg==
Message-ID: <5152C223.2080302@st.com>
References: <1364308035-16909-1-git-send-email-maxime_coquelin@yahoo.fr>
 <20130326200533.4014.81236@quantum>
In-Reply-To: <20130326200533.4014.81236@quantum>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120713
 Thunderbird/14.0
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2R9tt7L012435

Le 03/26/2013 09:05 PM, Mike Turquette a Ã©crit :
> Quoting Maxime Coquelin (2013-03-26 07:27:15)
>> From: Maxime Coquelin <maxime.coquelin@st.com>
>>
>> In clk_reg_prcmu(), clk->hw.init field is assigned with a
>> reference local to clk_reg_prcmu() function.
>>
>> This patch replaces references to clk->hw.init with calls
>> to __clk_get_name when called after clock registration.
>>
>> This patch applies on top of v3.9-rc4.
>>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> Hi Maxime,
>
> This patch did not apply cleanly onto clk-next.  Below is what I merged.
> Please let me know if there are any issues.
Hi Mike,

I just fetched your clk-next branch.
It looks good to me.

Thanks for the merge,
Maxime
>
> Regards,
> Mike
>
>
>
>  From 5717b1a93c7d86cfea501a35bb8c83910c20159f Mon Sep 17 00:00:00 2001
> From: Maxime Coquelin <maxime.coquelin@st.com>
> Date: Tue, 26 Mar 2013 15:27:15 +0100
> Subject: [PATCH] clk: ux500: Fix prcmu clocks registration
>
> In clk_reg_prcmu(), clk->hw.init field is assigned with a
> reference local to clk_reg_prcmu() function.
>
> This patch replaces references to clk->hw.init with calls
> to __clk_get_name when called after clock registration.
>
> This patch applies on top of v3.9-rc4.
>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> [mturquette@linaro.org: resolved trivial merge issues]
> ---
>   drivers/clk/ux500/clk-prcmu.c |   10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
> index 9d83256..293a288 100644
> --- a/drivers/clk/ux500/clk-prcmu.c
> +++ b/drivers/clk/ux500/clk-prcmu.c
> @@ -44,7 +44,7 @@ static void clk_prcmu_unprepare(struct clk_hw *hw)
>   	struct clk_prcmu *clk = to_clk_prcmu(hw);
>   	if (prcmu_request_clock(clk->cg_sel, false))
>   		pr_err("clk_prcmu: %s failed to disable %s.\n", __func__,
> -			hw->init->name);
> +			__clk_get_name(hw->clk));
>   	else
>   		clk->is_prepared = 0;
>   }
> @@ -106,7 +106,7 @@ static int clk_prcmu_opp_prepare(struct clk_hw *hw)
>   						100);
>   		if (err) {
>   			pr_err("clk_prcmu: %s fail req APE OPP for %s.\n",
> -				__func__, hw->init->name);
> +				__func__, __clk_get_name(hw->clk));
>   			return err;
>   		}
>   		clk->opp_requested = 1;
> @@ -130,7 +130,7 @@ static void clk_prcmu_opp_unprepare(struct clk_hw *hw)
>   
>   	if (prcmu_request_clock(clk->cg_sel, false)) {
>   		pr_err("clk_prcmu: %s failed to disable %s.\n", __func__,
> -			hw->init->name);
> +			__clk_get_name(hw->clk));
>   		return;
>   	}
>   
> @@ -152,7 +152,7 @@ static int clk_prcmu_opp_volt_prepare(struct clk_hw *hw)
>   		err = prcmu_request_ape_opp_100_voltage(true);
>   		if (err) {
>   			pr_err("clk_prcmu: %s fail req APE OPP VOLT for %s.\n",
> -				__func__, hw->init->name);
> +				__func__, __clk_get_name(hw->clk));
>   			return err;
>   		}
>   		clk->opp_requested = 1;
> @@ -175,7 +175,7 @@ static void clk_prcmu_opp_volt_unprepare(struct clk_hw *hw)
>   
>   	if (prcmu_request_clock(clk->cg_sel, false)) {
>   		pr_err("clk_prcmu: %s failed to disable %s.\n", __func__,
> -			hw->init->name);
> +			__clk_get_name(hw->clk));
>   		return;
>   	}
>   
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
