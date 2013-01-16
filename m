Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab3APJ2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:28:07 -0500
Received: from multi.imgtec.com ([194.200.65.239]:10052 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758688Ab3APJ2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:28:02 -0500
Message-ID: <50F67299.4010102@imgtec.com>
Date: Wed, 16 Jan 2013 09:27:53 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Joe Perches <joe@perches.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <rnayak@ti.com>
Subject: Re: [PATCH 1/1] clk-divider: fix is_power_of_two()
References: <1358245685-4392-1-git-send-email-james.hogan@imgtec.com> <1358274665.2597.11.camel@joe-AO722> <20130116005639.8920.45989@quantum>
In-Reply-To: <20130116005639.8920.45989@quantum>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_16_09_27_54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/01/13 00:56, Mike Turquette wrote:
> Quoting Joe Perches (2013-01-15 10:31:05)
>> On Tue, 2013-01-15 at 10:28 +0000, James Hogan wrote:
>>> The macro is_power_of_two() in clk-divider.c was defined as !(i & ~i)
>>> which is always true. Correct it to !(i & (i - 1)).
>> []
>>> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
>> []
>>> @@ -29,8 +29,8 @@
>> []
>>> -#define div_mask(d)  ((1 << (d->width)) - 1)
>>> -#define is_power_of_two(i)   !(i & ~i)
>>> +#define div_mask(d)  ((1 << ((d)->width)) - 1)
>>> +#define is_power_of_two(i)   (!((i) & ((i) - 1)))
>>
>> Use is_power_of_2 in log2.h instead?
> 
> Both are fine suggestions.  How about I apply the below patch?

Looks good to me, thanks for taking care of the log.h change.

Cheers
James

> From 54c6c9e5f61693effbe6e4fb28ef9f2f9b3d7a23 Mon Sep 17 00:00:00 2001
> From: James Hogan <james.hogan@imgtec.com>
> Date: Tue, 15 Jan 2013 10:28:05 +0000
> Subject: [PATCH] clk-divider: fix macros
> 
> The macro is_power_of_two() in clk-divider.c was defined as !(i & ~i)
> which is always true.  Instead use is_power_of_2() from log2.h.
> 
> Also add brackets around the macro arguments in div_mask to avoid any
> future operator precedence problems.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Joe Perches <joe@perches.com>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> [mturquette@linaro.org: use log2.h per Joe Perches; update changelog]
> ---
>  drivers/clk/clk-divider.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index a9204c6..68b4021 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -16,6 +16,7 @@
>  #include <linux/io.h>
>  #include <linux/err.h>
>  #include <linux/string.h>
> +#include <linux/log2.h>
>  
>  /*
>   * DOC: basic adjustable divider clock that cannot gate
> @@ -29,8 +30,7 @@
>  
>  #define to_clk_divider(_hw) container_of(_hw, struct clk_divider, hw)
>  
> -#define div_mask(d)	((1 << (d->width)) - 1)
> -#define is_power_of_two(i)	!(i & ~i)
> +#define div_mask(d)	((1 << ((d)->width)) - 1)
>  
>  static unsigned int _get_table_maxdiv(const struct clk_div_table *table)
>  {
> @@ -137,7 +137,7 @@ static bool _is_valid_table_div(const struct clk_div_table *table,
>  static bool _is_valid_div(struct clk_divider *divider, unsigned int div)
>  {
>  	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
> -		return is_power_of_two(div);
> +		return is_power_of_2(div);
>  	if (divider->table)
>  		return _is_valid_table_div(divider->table, div);
>  	return true;
> 

