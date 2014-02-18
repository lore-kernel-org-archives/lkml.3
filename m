Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaBRT3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:29:16 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:37636 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaBRT3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:29:14 -0500
Message-ID: <5303C29A.6080200@cogentembedded.com>
Date: Tue, 18 Feb 2014 23:29:14 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>, grant.likely@linaro.org
CC: linux-kernel@lists.codethink.co.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] of_mdio: fix phy interrupt passing
References: <1392725818-558-1-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1392725818-558-1-git-send-email-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02/18/2014 03:16 PM, Ben Dooks wrote:

> The of_mdiobus_register_phy() is not setting phy->irq thus causing
> some drivers to incorrectly assume that the PHY does not have an
> IRQ associated with it. Not only do some drivers report no IRQ
> they do not install an interrupt handler for the PHY.

> Simplify the code setting irq and set the phy->irq at the same
> time so that we cover the following issues, which should cover
> all the cases the code will find:

> - Set phy->irq if node has irq property and mdio->irq is NULL
> - Set phy->irq if node has no irq and mdio->irq is not NULL
> - Leave phy->irq as PHY_POLL default if none of the above

> This fixes the issue:
>   net eth0: attached PHY 1 (IRQ -1) to driver Micrel KSZ8041RNLI

> to the correct:
>   net eth0: attached PHY 1 (IRQ 416) to driver Micrel KSZ8041RNLI

> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

[...]

> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index 875b7b6..46d95fc 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
[...]
> @@ -54,12 +54,14 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio, struct device_node *chi
>   	if (!phy || IS_ERR(phy))
>   		return 1;
>
> -	if (mdio->irq) {
> -		prev_irq = mdio->irq[addr];
> -		mdio->irq[addr] =
> -			irq_of_parse_and_map(child, 0);
> -		if (!mdio->irq[addr])
> -			mdio->irq[addr] = prev_irq;
> +	rc = irq_of_parse_and_map(child, 0);
> +	if (rc > 0) {
> +		phy->irq = rc;
> +		if (mdio->irq)
> +			mdio->irq[addr] = rc;
> +	} else {
> +		if (mdio->irq)
> +			phy->irq = mdio->irq[addr];

    I have now looked thru the of_mdio.c code and the code it calls.
    This case seems to be cared about by phy_device_create() called earlier 
via get_phy_device() call just above this hunk; in any case the value will be 
PHY_POLL. I don't think this branch is needed at all.

WBR, Sergei

