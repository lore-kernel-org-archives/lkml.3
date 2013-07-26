Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263Ab3GZPkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:40:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36563 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab3GZPkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:40:19 -0400
Message-ID: <51F2985F.60202@wwwdotorg.org>
Date: Fri, 26 Jul 2013 09:40:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: akpm@linux-foundation.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, gg@slimlogic.co.uk, kishon@ti.com,
        Stephen Warren <swarren@nvidia.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH] drivers/rtc/rtc-palmas.c: support for backup battery
 charging
References: <1374755343-32573-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1374755343-32573-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC'ing the new DT binding maintainers and mailing list on this reply,
hence quoting the whole of the DT binding)

On 07/25/2013 06:29 AM, Laxman Dewangan wrote:
> Palmas series device like TPS65913, TPS80036 supports the backup battery
> for powering the RTC when no other energy source is available.
> 
> The backup battery is optional, connected to the VBACKUP pin, and can be
> nonrechargeable or rechargeable. The rechargeable battery can be charged
> from the system supply using the backup battery charger.
> 
> Add support for enabling charging of this backup battery.  Also add the DT
> binding document and the new properties to have this support.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  .../devicetree/bindings/rtc/rtc-palmas.txt         |   28 ++++++++++++++
>  drivers/rtc/rtc-palmas.c                           |   39 ++++++++++++++++++++
>  2 files changed, 67 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> 
> diff --git a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> new file mode 100644
> index 0000000..e4b6910
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> @@ -0,0 +1,28 @@
> +Palmas RTC controller bindings
> +
> +Required properties:
> +- compatible:
> +  - "ti,palams-rtc" for palma series of the RTC controller
> +- interrupt-parent: Parent interrupt device, must be handle of palams node.
> +- interrupts: Interrupt number of RTC submodule on device.
> +
> +Optional properties:
> +- ti,back-bat-chg-enable: The palmas series device like TPS65913 or TPS80036
> +	supports the battery backup for powering the RTC when main battery is
> +	removed or in very low power state. This flag will enable the backup
> +	battery charging.
> +- ti,back-bat-chg-current: Configure charging current. Device supports the
> +	charging current as < 100mA or >100mA.

Does the HW support just two options; less-than or greater-than 100mA?
If so, a Boolean property here might be better. The code below certainly
implies this.

Given there's only 1 battery, I think "back-" is redundant in the
property names. Since that shortens the names a bit, I'd suggest
spelling everything out in full, perhaps:

battery-charge-enable
battery-charge-low-current

Both Boolean.

> +Example:
> +	palmas: tps65913@58 {
> +		:::::::::::

"..." is probably more common than lots of colons, or you could just
delete this line.

> +		palmas_rtc: rtc {
> +			compatible = "ti,palmas-rtc";
> +			interrupt-parent = <&palmas>;
> +			interrupts = <8 0>;
> +			ti,back-bat-chg-enable;
> +			ti,back-bat-chg-current = <100>;
> +		};
> +		:::::::::::
> +	};

> diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c

> @@ -238,6 +238,19 @@ static int palmas_rtc_probe(struct platform_device *pdev)

> +		ret = of_property_read_u32(pdev->dev.of_node,
> +					"ti,back-bat-chg-current", &pval);
> +		if (!ret)
> +			bb_charging_current = pval;

Do you need to validate that pval is one of the legal values?

> @@ -254,6 +267,32 @@ static int palmas_rtc_probe(struct platform_device *pdev)
>  	palmas_rtc->dev = &pdev->dev;
>  	platform_set_drvdata(pdev, palmas_rtc);
>  
> +	if (enable_bb_charging) {
> +		unsigned reg = 0;
> +
> +		if (bb_charging_current < 100)
> +			reg |= PALMAS_BACKUP_BATTERY_CTRL_BBS_BBC_LOW_ICHRG;

This implies that a Boolean property would be a better representation of HW.
