Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934AbaCUNcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:32:20 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62328 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaCUNcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:32:16 -0400
Message-ID: <532C40B0.3000805@gmail.com>
Date: Fri, 21 Mar 2014 14:37:52 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Jean-Francois Moine <moinejf@free.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drm/i2c: tda998x: Change the compatible strings
References: <20140321115541.01cbbb06@armhf>
In-Reply-To: <20140321115541.01cbbb06@armhf>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 11:55 AM, Jean-Francois Moine wrote:
> The tda998x driver accepts only 3 chips from the TDA998x family.
> This patch changes the driver compatible strings to these chips.

Jean-Francois,

be careful with building a DT binding from a Linux driver. Although
we constantly struggle to define a binding independent of Linux, it
should not reflect what Linux is capable of but describe the HW in
general.

> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
> v2: change the subject to drm/i2c
> This patch applies after
> 	drm/i2c: tda998x: Fix lack of required reg in DT documentation
> ---
>   Documentation/devicetree/bindings/drm/i2c/tda998x.txt | 4 ++--
>   drivers/gpu/drm/i2c/tda998x_drv.c                     | 4 +++-
>   2 files changed, 5 insertions(+), 3 deletions(-)
> diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> index fc7effa..e3f3d65 100644
> --- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> +++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> @@ -1,7 +1,7 @@
>   Device-Tree bindings for the NXP TDA998x HDMI transmitter
>
>   Required properties;
> -  - compatible: must be "nxp,tda998x"
> +  - compatible: may be "nxp,tda9989", "nxp,tda19988" or "nxp,tda19989"

There is a "DT is ABI" policy and although there is no mainline Linux
user of current compatible, the correct way would be to deprecate
"nxp,tda998x" and introduce new compatibles.

Also, as long as we don't know about any major differences between
9989, 1998[89] it is fine to just have one of them defined. As soon
as we discover any difference that cannot be solved in another way,
we can add a new compatible.

What we _know_ is that 998[134] are different from 9989,1998[89]
with respect to additional CEC feature. But we also _know_ that the
exact version/revision of 9989,1998[89] can be probed from i2c
registers.

DT maintainers will know better, but as long as we have no prove that
998[134] can also be properly distinguished by i2c registers, just add
"nxp,tda9989" (which was probably the first revision released) and
assume 1998[89] are "compatible enough". Or add all three and make
"nxp,tda9989" the mandatory compatible.

You can leave out 998[134] for now.

>     - reg: I2C address
>

The line above and below reg property look like there is a tab. If
so, can you please get rid of the blank line above and fix the line
below?

> @@ -20,7 +20,7 @@ Optional properties:
>   Example:
>
>   	tda998x: hdmi-encoder {
> -		compatible = "nxp,tda998x";
> +		compatible = "nxp,tda19988";

Depending on above decision this becomes either

compatible = "nxp,tda9989";

or

compatible = "nxp,tda19988", "nxp,tda9989";

>   		reg = <0x70>;
>   		interrupt-parent = <&gpio0>;
>   		interrupts = <27 2>;		/* falling edge */
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index 48af5ca..fd6751c 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -1367,7 +1367,9 @@ fail:
>
>   #ifdef CONFIG_OF
>   static const struct of_device_id tda998x_dt_ids[] = {
> -	{ .compatible = "nxp,tda998x", },
> +	{ .compatible = "nxp,tda9989", },
> +	{ .compatible = "nxp,tda19988", },
> +	{ .compatible = "nxp,tda19989", },

Independent of the decision above, just "nxp,tda9989" is
sufficient.

Sebastian

>   	{ }
>   };
>   MODULE_DEVICE_TABLE(of, tda998x_dt_ids);
>

