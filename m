Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab3HMHLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:11:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58018 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753114Ab3HMHLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:11:18 -0400
Date: Tue, 13 Aug 2013 09:11:06 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/9] PCI: mvebu: move clock enable before register
 access
Message-ID: <20130813091106.326c562a@skate>
In-Reply-To: <1376333215-12885-2-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1376333215-12885-2-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Mon, 12 Aug 2013 20:46:47 +0200, Sebastian Hesselbarth wrote:

> +		port->clk = of_clk_get_by_name(child, NULL);
> +		if (IS_ERR(port->clk)) {
> +			dev_err(&pdev->dev, "PCIe%d.%d: cannot get clock\n",
> +			       port->port, port->lane);
> +			iounmap(port->base);

You shouldn't iounmap() here in case of error, since the register
mapping hasn't been done yet.

> +			port->haslink = 0;
> +			continue;
> +		}
> +		clk_prepare_enable(port->clk);

Nitpick, an empty new line between the closing } and the
clk_prepare_enable() line would be nice.

> +
>  		port->base = mvebu_pcie_map_registers(pdev, child, port);
>  		if (!port->base) {
>  			dev_err(&pdev->dev, "PCIe%d.%d: cannot map registers\n",
> @@ -916,22 +926,9 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
>  				 port->port, port->lane);

and maybe here you could unprepare+release the clock if we haven't
managed to remap registers?

>  		}
>  
> -		port->clk = of_clk_get_by_name(child, NULL);
> -		if (IS_ERR(port->clk)) {
> -			dev_err(&pdev->dev, "PCIe%d.%d: cannot get clock\n",
> -			       port->port, port->lane);
> -			iounmap(port->base);
> -			port->haslink = 0;
> -			continue;
> -		}
> -
>  		port->dn = child;
> -
> -		clk_prepare_enable(port->clk);
>  		spin_lock_init(&port->conf_lock);
> -
>  		mvebu_sw_pci_bridge_init(port);
> -
>  		i++;
>  	}
>  

Thanks!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
