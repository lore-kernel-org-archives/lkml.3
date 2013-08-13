Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab3HMHUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:20:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58065 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754684Ab3HMHUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:20:11 -0400
Date: Tue, 13 Aug 2013 09:19:59 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/9] PCI: mvebu: remove subsys_initcall
Message-ID: <20130813091959.784b44f0@skate>
In-Reply-To: <1376333215-12885-4-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1376333215-12885-4-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Mon, 12 Aug 2013 20:46:49 +0200, Sebastian Hesselbarth wrote:
> This removes the subsys_initcall from the driver and converts it to
> a normal platform_driver. Also, drvdata is set and a remove functions
> is added to disable the clock and free resources.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

I'm OK with this, just a comment below.

> +static int mvebu_pcie_remove(struct platform_device *pdev)
> +{
> +	struct mvebu_pcie *pcie = platform_get_drvdata(pdev);
> +	struct mvebu_pcie_port *port = &pcie->ports[0];
> +	int i;
> +
> +	for (i = 0; i < pcie->nports; i++, port++) {
> +		clk_disable_unprepare(port->clk);
> +		kfree(port->name);
> +	}
> +
> +	return 0;
> +}

I believe the ->remove() part is quite useless. The driver is a 'bool'
in Kconfig, so it cannot be compiled as a module, and I'm not sure
there a way to remove the platform device that corresponds to the PCIe
controller.

And even if there was, then it would still not work because as far as I
know, the ARM PCI core doesn't provide functions to 'unregister' PCI
controllers, so it would keep pointers to functions located in the
driver, which would cause nasty things when unloading the module.

So the reason why I didn't include a ->remove() hook is simply because
there was, as of today, no use for it.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
