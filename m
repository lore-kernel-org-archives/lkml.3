Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947287Ab3BHXBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:01:33 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64423 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947094Ab3BHXBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:01:31 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/4] serial/arc-uart: switch to devicetree based probing
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
In-Reply-To: <1357885223-19243-5-git-send-email-vgupta@synopsys.com>
References: <1357885223-19243-1-git-send-email-vgupta@synopsys.com> <1357885223-19243-5-git-send-email-vgupta@synopsys.com>
Date: Fri, 08 Feb 2013 23:01:27 +0000
Message-Id: <20130208230127.5F3063E2C27@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013 11:50:23 +0530, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> * DT binding for arc-uart
> * With alll the bits in place we can now use DT probing.
> 
> Note that there's a bit of kludge right now because earlyprintk portion
> of driver can't use the DT infrastrcuture to get resoures/plat_data.
> This requires some infrastructre changes to of_flat_ framework
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-serial@vger.kernel.org
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: linux-serial@vger.kernel.org
> ---
>  .../devicetree/bindings/tty/serial/arc-uart.txt    |   26 ++++++++++++
>  drivers/tty/serial/arc_uart.c                      |   43 ++++++++++++++++++-
>  2 files changed, 66 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/tty/serial/arc-uart.txt
> 
> diff --git a/Documentation/devicetree/bindings/tty/serial/arc-uart.txt b/Documentation/devicetree/bindings/tty/serial/arc-uart.txt
> new file mode 100644
> index 0000000..c3bd8f9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/tty/serial/arc-uart.txt
> @@ -0,0 +1,26 @@
> +* Synopsys ARC UART : Non standard UART used in some of the ARC FPGA boards
> +
> +Required properties:
> +- compatible		: "snps,arc-uart"
> +- reg			: offset and length of the register set for the device.
> +- interrupts		: device interrupt
> +- clock-frequency	: the input clock frequency for the UART
> +- baud			: baud rate for UART

change 'baud' to 'current-speed'. There is already precedence for this
with other serial devices.

g.

> @@ -673,8 +693,18 @@ static int __init arc_serial_probe_earlyprintk(struct platform_device *pdev)
>  static int arc_serial_probe(struct platform_device *pdev)
>  {
>  	int rc, dev_id;
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	/* no device tree device */
> +	if (!np)
> +		return -ENODEV;

This breaks non-DT users. Is this what you intend? It creates a flag day
where users have to switch from non-DT to DT cold-turkey.

> +	dev_id = of_alias_get_id(np, "serial");
> +	if (dev_id < 0) {
> +		dev_err(&pdev->dev, "failed to get alias id: %d\n", dev_id);
> +		return dev_id;
> +	}

Don't fail on this. If you can't get an id then choose one dynamically.

>  
> -	dev_id = pdev->id < 0 ? 0 : pdev->id;
>  	rc = arc_uart_init_one(pdev, dev_id);
>  	if (rc)
>  		return rc;
> @@ -689,12 +719,19 @@ static int arc_serial_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static const struct of_device_id arc_uart_dt_ids[] = {
> +	{ .compatible = "snps,arc-uart" },
> +	{ /* Sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, arc_uart_dt_ids);
> +
>  static struct platform_driver arc_platform_driver = {
>  	.probe = arc_serial_probe,
>  	.remove = arc_serial_remove,
>  	.driver = {
>  		.name = DRIVER_NAME,
>  		.owner = THIS_MODULE,
> +		.of_match_table  = arc_uart_dt_ids,
>  	 },
>  };
>  
> -- 
> 1.7.4.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
