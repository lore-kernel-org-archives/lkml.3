Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaIXNSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:18:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38363 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802AbaIXNR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:17:58 -0400
Date: Wed, 24 Sep 2014 14:16:55 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] sbs-battery: add forced instantiation from
 device tree
Message-ID: <20140924131655.GG5729@leverpostej>
References: <1411564278-17207-1-git-send-email-frans.klaver@xsens.com>
 <1411564278-17207-2-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411564278-17207-2-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 02:11:17PM +0100, Frans Klaver wrote:
> In some cases you want to instantiate a battery even before it is
> attached; it is perfectly reasonable for a device to start up on
> wall-power and be connected to a battery later. The current advice is to
> instantiate a device explicitly in the kernel, or probe for the device
> from userspace. The downside of these approaches is that the user needs
> to keep the information related to the i2c battery in different places,
> which is inconvenient.

This really sounds like a Linux policy issue rather than something that
should be described in dt.

Presumably there's a reason we sanity cehck this in the first place.
What happens while the battery isn't plugged in? What can fail, and how?

Mark.

> Add the "sbs,always-present" option to the device tree. If set, the
> battery is instantiated without sanity checking the connection.

>From the description above, this name is incorrect. You're adding this
property to work around the battery _not_ being present at probe-time.
>From a binding point of view, "instantiated" is somewhat meaningless --
that's an OS level detail rather than a contract detail.

Mark.

> 
> Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> ---
>  drivers/power/sbs-battery.c       | 11 +++++++++--
>  include/linux/power/sbs-battery.h |  3 +++
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
> index b5f2a76..5d327b5 100644
> --- a/drivers/power/sbs-battery.c
> +++ b/drivers/power/sbs-battery.c
> @@ -651,6 +651,9 @@ static struct sbs_platform_data *sbs_of_populate_pdata(
>  	if (!rc)
>  		pdata->poll_retry_count = prop;
>  
> +	pdata->always_present = of_property_read_bool(of_node,
> +						      "sbs,always-present");
> +
>  	if (!of_get_property(of_node, "sbs,battery-detect-gpios", NULL)) {
>  		pdata->battery_detect = -1;
>  		goto of_out;
> @@ -761,10 +764,14 @@ static int sbs_probe(struct i2c_client *client,
>  
>  skip_gpio:
>  	/*
> -	 * Before we register, we need to make sure we can actually talk
> +	 * Before we register, we might need to make sure we can actually talk
>  	 * to the battery.
>  	 */
> -	rc = sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
> +	if (!pdata->always_present)
> +		rc = sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
> +	else
> +		rc = 0;
> +
>  	if (rc < 0) {
>  		dev_err(&client->dev, "%s: Failed to get device status\n",
>  			__func__);
> diff --git a/include/linux/power/sbs-battery.h b/include/linux/power/sbs-battery.h
> index 2b0a9d9..724bd9b 100644
> --- a/include/linux/power/sbs-battery.h
> +++ b/include/linux/power/sbs-battery.h
> @@ -31,12 +31,15 @@
>   * @i2c_retry_count:		# of times to retry on i2c IO failure
>   * @poll_retry_count:		# of times to retry looking for new status after
>   *				external change notification
> + * @always_present:		the device is instantiated even if the battery
> + *				is not physically present
>   */
>  struct sbs_platform_data {
>  	int battery_detect;
>  	int battery_detect_present;
>  	int i2c_retry_count;
>  	int poll_retry_count;
> +	bool always_present;
>  };
>  
>  #endif
> -- 
> 2.1.0
> 
> 
