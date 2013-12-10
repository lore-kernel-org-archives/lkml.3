Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab3LJHjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:39:55 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:58316 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3LJHju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:39:50 -0500
Date: Tue, 10 Dec 2013 08:39:46 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: favr-32: clk_round_rate() can return a zero upon
 error
Message-ID: <20131210073945.GD4196@samfundet.no>
References: <alpine.DEB.2.02.1312091827300.4127@tamien>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1312091827300.4127@tamien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 09 Dec 2013 18:35:24 -0800 or thereabout, Paul Walmsley wrote:
> 
> Treat both negative and zero return values from clk_round_rate() as
> errors.  This is needed since subsequent patches will convert
> clk_round_rate()'s return value to be an unsigned type, rather than a
> signed type, since some clock sources can generate rates higher than
> (2^31)-1 Hz.
> 
> Eventually, when calling clk_round_rate(), only a return value of zero
> will be considered a error.  All other values will be considered valid
> rates.  The comparison against values less than 0 is kept to preserve
> the correct behavior in the meantime.
> 
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Håvard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Thanks for fixing, applied to for-linus branch in
git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32.git

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
> Applies on v3.13-rc3.  See also:
> 
> http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2
> 
>  arch/avr32/boards/favr-32/setup.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/avr32/boards/favr-32/setup.c b/arch/avr32/boards/favr-32/setup.c
> index 7b1f2cd85400..1f121497b517 100644
> --- a/arch/avr32/boards/favr-32/setup.c
> +++ b/arch/avr32/boards/favr-32/setup.c
> @@ -298,8 +298,10 @@ static int __init set_abdac_rate(struct platform_device *pdev)
>  	 */
>  	retval = clk_round_rate(pll1,
>  			CONFIG_BOARD_FAVR32_ABDAC_RATE * 256 * 16);
> -	if (retval < 0)
> +	if (retval <= 0) {
> +		retval = -EINVAL;
>  		goto out_abdac;
> +	}
> 
>  	retval = clk_set_rate(pll1, retval);
>  	if (retval != 0)


-- 
mvh
Hans-Christian Egtvedt
