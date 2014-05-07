Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbaEGIiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:38:19 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51050 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932069AbaEGIiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:38:17 -0400
Message-ID: <5369F0D6.3080503@st.com>
Date: Wed, 7 May 2014 10:37:42 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>, <mturquette@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        <linux-kernel@vger.kernel.org>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: clk-divider: Fix infinite loop for table divider
References: <1399408005-4209-1-git-send-email-festevam@gmail.com>
In-Reply-To: <1399408005-4209-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.129.6.55]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-07_02:2014-05-06,2014-05-07,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On 05/06/2014 10:26 PM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> Since commit e7489693b3 (clk: divider: Optimize clk_divider_bestdiv loop) we
> notice a system hang on mx6qboard.
>
> The cause for the hang is well explained by Sascha Hauer [1]:
>
> "This cannot work. _round_up_table is implemented like this:
>
> static int _round_up_table(const struct clk_div_table *table, int div)
> {
>          const struct clk_div_table *clkt;
>          int up = _get_table_maxdiv(table);
>
>          for (clkt = table; clkt->div; clkt++) {
>                  if (clkt->div == div)
>                          return clkt->div;
>                  ...
>          }
>          ...
> }
>
> Here when a table entry matches the input div this function will return
> exactly the input div. This means _next_div() will always return the
> same value and clk_divider_bestdiv() has an infinite loop:
>
>          for (i = 1; i <= maxdiv; i = _next_div(divider, i)) {
>                  ...
>          }
> "
> [1] http://marc.info/?l=linux-arm-kernel&m=139940658726253&w=2
>
> Remove the 'return _round_up_table' so that the system can work normally again.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>   drivers/clk/clk-divider.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index b3c8396..fc3e344 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -246,8 +246,6 @@ static int _next_div(struct clk_divider *divider, int div)
>
>   	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
>   		return __roundup_pow_of_two(div);
> -	if (divider->table)
> -		return _round_up_table(divider->table, div);

Couldn't we initialize "up" variable to INT_MAX in _round_up_table() as 
I just proposed in mail thread reporting the regression?

See http://marc.info/?l=linux-arm-kernel&m=139945172905130&w=2

Regards,
Maxime

>
>   	return div;
>   }
>
