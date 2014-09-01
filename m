Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaIARFC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:05:02 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:17703 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751195AbaIARFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:05:00 -0400
Date: Mon, 1 Sep 2014 18:04:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [RFC PATCH for Juno 1/2] net: smsc911x add support for probing
 from ACPI
Message-ID: <20140901170447.GF608@arm.com>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
 <1409583961-7466-2-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409583961-7466-2-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 04:06:00PM +0100, Hanjun Guo wrote:
> +#ifdef CONFIG_ACPI
> +/* Configure some sensible defaults for ACPI mode */
> +static int smsc911x_probe_config_acpi(struct smsc911x_platform_config *config,
> +				    acpi_handle *ahandle)
> +{
> +	if (!ahandle)
> +		return -ENOSYS;
> +
> +	config->phy_interface = PHY_INTERFACE_MODE_MII;
> +
> +	config->flags |= SMSC911X_USE_32BIT;
> +
> +	config->irq_polarity = SMSC911X_IRQ_POLARITY_ACTIVE_HIGH;
> +
> +	config->irq_type = SMSC911X_IRQ_TYPE_PUSH_PULL;
> +
> +	return 0;
> +}
> +#else

I don't like this and it shows issues we have with ACPI on certain ARM
platforms. You hard-code these values to match the Juno platform. What
if we get another SoC which has different configuration here? For DT, we
have the smsc911x_probe_config_dt() which reads the relevant information
from DT. I think this kind of configuration would be more suitable as
_DSD properties and sharing the similar names with DT (but we go back to
the question about who's in charge of the _DSD properties).

>  static int smsc911x_drv_probe(struct platform_device *pdev)
>  {
>  	struct device_node *np = pdev->dev.of_node;
> +	acpi_handle *ahandle = ACPI_HANDLE(&pdev->dev);
>  	struct net_device *dev;
>  	struct smsc911x_data *pdata;
>  	struct smsc911x_platform_config *config = dev_get_platdata(&pdev->dev);
> @@ -2436,6 +2464,9 @@ static int smsc911x_drv_probe(struct platform_device *pdev)
>  	}
>  
>  	retval = smsc911x_probe_config_dt(&pdata->config, np);
> +	if (retval)
> +		retval = smsc911x_probe_config_acpi(&pdata->config, ahandle);
> +

In most of the ACPI patches so far we check for ACPI first with DT as a
fall-back if ACPI is not enabled. This changes here. I would prefer
something which probes only ACPI if the ACPI is enabled (run-time, not
config) otherwise DT only. E.g.

-- 
Catalin
