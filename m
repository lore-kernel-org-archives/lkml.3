Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbaFKPjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:39:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42529 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755747AbaFKPjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:39:11 -0400
Date: Wed, 11 Jun 2014 11:39:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kgene.kim@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v2 1/2] usb: ehci-exynos: Make provision for vdd regulators
In-Reply-To: <1402064411-18244-1-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1406111131200.890-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Vivek Gautam wrote:

> Facilitate getting required 3.3V and 1.0V VDD supply for
> EHCI controller on Exynos.
> 
> With patches for regulators' nodes merged in 3.15:
> c8c253f ARM: dts: Add regulator entries to smdk5420
> 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
> 
> certain perripherals will now need to ensure that,
> they request VDD regulators in their drivers, and enable
> them so as to make them working.

"Certain peripherals"?  Don't you mean "certain controllers"?

Does this mean some controllers don't need to use the VDD regulators?

> @@ -193,7 +196,31 @@ static int exynos_ehci_probe(struct platform_device *pdev)
>  
>  	err = exynos_ehci_get_phy(&pdev->dev, exynos_ehci);
>  	if (err)
> -		goto fail_clk;
> +		goto fail_regulator1;
> +
> +	exynos_ehci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
> +	if (!IS_ERR(exynos_ehci->vdd33)) {
> +		err = regulator_enable(exynos_ehci->vdd33);
> +		if (err) {
> +			dev_err(&pdev->dev,
> +				"Failed to enable 3.3V Vdd supply\n");
> +			goto fail_regulator1;
> +		}
> +	} else {
> +		dev_warn(&pdev->dev, "Regulator 3.3V Vdd supply not found\n");
> +	}

What if this is one of the controllers that don't need to use a VDD 
regulator?  Do you really want to print out a warning in that case?  
Should you call devm_regulator_get_optional() instead?

Alan Stern

