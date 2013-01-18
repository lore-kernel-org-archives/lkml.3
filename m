Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3ARO73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:59:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49606 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3ARO72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:59:28 -0500
Date: Fri, 18 Jan 2013 14:59:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roger Quadros <rogerq@ti.com>
Cc: sameo@linux.intel.com, balbi@ti.com, tony@atomide.com, kishon@ti.com,
        sshtylyov@mvista.com, bjorn@mork.no, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 05/22] mfd: omap-usb-tll: Clean up clock handling
Message-ID: <20130118145906.GE23505@n2100.arm.linux.org.uk>
References: <1358511445-26656-1-git-send-email-rogerq@ti.com> <1358511445-26656-6-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358511445-26656-6-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 02:17:08PM +0200, Roger Quadros wrote:
> +	tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk * [tll->nch]),
> +						GFP_KERNEL);
> +	if (!tll->ch_clk) {
> +		ret = -ENOMEM;
> +		dev_err(dev, "Couldn't allocate memory for channel clocks\n");
> +		goto err_clk_alloc;
> +	}
> +
> +	for (i = 0; i < tll->nch; i++) {
> +		char clkname[] = "usb_tll_hs_usb_chx_clk";
> +		struct clk *fck;
> +
> +		snprintf(clkname, sizeof(clkname),
> +					"usb_tll_hs_usb_ch%d_clk", i);
> +		fck = clk_get(dev, clkname);
> +
> +		if (IS_ERR(fck))
> +			dev_dbg(dev, "can't get clock : %s\n", clkname);
> +		else
> +			tll->ch_clk[i] = fck;

Hmm.  I'd actually suggest that this becomes:

		tll->ch_clk[i] = fck;
		if (IS_ERR(fck)
			dev_dbg(dev, "can't get clock: %s\n", clkname);

so that tll->ch_clk is always written to.

>  static int usbtll_omap_remove(struct platform_device *pdev)
>  {
>  	struct usbtll_omap *tll = platform_get_drvdata(pdev);
> +	int i;
> +
> +	for (i = 0; i < tll->nch; i++)
> +		clk_put(tll->ch_clk[i]);

And change this to:

	for (i = 0; i < tll->nch; i++)
		if (!IS_ERR(tll->ch_clk[i]))
			clk_put(tll->ch_clk[i]);

so that you're not passing a NULL pointer in.

> +	for (i = 0; i < tll->nch; i++) {
> +		if (is_ehci_tll_mode(pdata->port_mode[i])) {
> +			int r;
>  
> -	if (is_ehci_tll_mode(pdata->port_mode[1]))
> -		clk_enable(tll->usbtll_p2_fck);
> +			if (!tll->ch_clk[i])

			if (IS_ERR(tll->ch_clk[i]))

> +				continue;
> +
> +			r = clk_enable(tll->ch_clk[i]);
> +			if (r) {
> +				dev_err(dev,
> +				 "Error enabling ch %d clock: %d\n", i, r);
> +			}
> +		}
> +	}

> @@ -387,11 +409,12 @@ static int usbtll_runtime_suspend(struct device *dev)
>  
>  	spin_lock_irqsave(&tll->lock, flags);
>  
> -	if (is_ehci_tll_mode(pdata->port_mode[0]))
> -		clk_disable(tll->usbtll_p1_fck);
> -
> -	if (is_ehci_tll_mode(pdata->port_mode[1]))
> -		clk_disable(tll->usbtll_p2_fck);
> +	for (i = 0; i < tll->nch; i++) {
> +		if (is_ehci_tll_mode(pdata->port_mode[i])) {
> +			if (tll->ch_clk[i])

			if (!IS_ERR(tll->ch_clk[i]))

> +				clk_disable(tll->ch_clk[i]);
> +		}
> +	}
>  
>  	spin_unlock_irqrestore(&tll->lock, flags);
>  
> -- 
> 1.7.4.1
> 
