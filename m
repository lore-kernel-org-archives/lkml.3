Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaBBMdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 07:33:32 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:37573 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaBBMda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 07:33:30 -0500
X-Auth-Info: OIaB90Fy5GNON/wCs717yAT0lTc/p/zLT4dmf6EM27I=
Date: Sun, 2 Feb 2014 13:33:27 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] spi: switch to devm_spi_alloc_master
Message-ID: <20140202123327.GR20094@book.gsilab.sittig.org>
References: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com>
 <1391163792-21819-4-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391163792-21819-4-git-send-email-maxime.ripard@free-electrons.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 11:23 +0100, Maxime Ripard wrote:
> 
> Make the existing users of devm_spi_register_master use the
> devm_spi_alloc_master function to avoid leaking memory.
> 
> [ ... ]
>  drivers/spi/spi-mpc512x-psc.c    | 19 ++++++++-----------

Note that the context for the MPC512x SPI driver will change in
3.14-rc1, so you will have to rebase after the merge window.

> diff --git a/drivers/spi/spi-mpc512x-psc.c b/drivers/spi/spi-mpc512x-psc.c
> index 46d2313..f376595 100644
> --- a/drivers/spi/spi-mpc512x-psc.c
> +++ b/drivers/spi/spi-mpc512x-psc.c
> @@ -479,7 +479,7 @@ static int mpc512x_psc_spi_do_probe(struct device *dev, u32 regaddr,
>  	char clk_name[16];
>  	struct clk *clk;
>  
> -	master = spi_alloc_master(dev, sizeof *mps);
> +	master = devm_spi_alloc_master(dev, sizeof *mps);
>  	if (master == NULL)
>  		return -ENOMEM;
>  
> @@ -507,8 +507,7 @@ static int mpc512x_psc_spi_do_probe(struct device *dev, u32 regaddr,
>  	tempp = devm_ioremap(dev, regaddr, size);
>  	if (!tempp) {
>  		dev_err(dev, "could not ioremap I/O port range\n");
> -		ret = -EFAULT;
> -		goto free_master;
> +		return -EFAULT;
>  	}
>  	mps->psc = tempp;
>  	mps->fifo =
> @@ -516,19 +515,19 @@ static int mpc512x_psc_spi_do_probe(struct device *dev, u32 regaddr,
>  	ret = devm_request_irq(dev, mps->irq, mpc512x_psc_spi_isr, IRQF_SHARED,
>  				"mpc512x-psc-spi", mps);
>  	if (ret)
> -		goto free_master;
> +		return ret;
>  	init_completion(&mps->txisrdone);
>  
>  	psc_num = master->bus_num;
>  	snprintf(clk_name, sizeof(clk_name), "psc%d_mclk", psc_num);
>  	clk = devm_clk_get(dev, clk_name);
> -	if (IS_ERR(clk)) {
> -		ret = PTR_ERR(clk);
> -		goto free_master;
> -	}
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
>  	ret = clk_prepare_enable(clk);
>  	if (ret)
> -		goto free_master;
> +		return ret;
> +
>  	mps->clk_mclk = clk;
>  	mps->mclk_rate = clk_get_rate(clk);
>  
> @@ -544,8 +543,6 @@ static int mpc512x_psc_spi_do_probe(struct device *dev, u32 regaddr,
>  
>  free_clock:
>  	clk_disable_unprepare(mps->clk_mclk);
> -free_master:
> -	spi_master_put(master);
>  
>  	return ret;
>  }

Reading the diff in the SPI master driver, the change appears to
be balanced, and replacing 'goto free_master' with immediate
return looks appropriate.

Can't comment on the correctness of removing the spi_master_put()
call when switching from spi_alloc_master() to
devm_spi_alloc_master().  This gets discussed in the other
subthread, dealing with the generic subsystem approach.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
