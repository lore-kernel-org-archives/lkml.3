Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbbAMO0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:26:45 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:49024 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbbAMO0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:26:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?= <niso@kth.se>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com
Subject: Re: [PATCH 2/4] sh-pfc: Add emev2 pinmux support
Date: Tue, 13 Jan 2015 16:27:06 +0200
Message-ID: <4306343.ZxG2x6FY5Y@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1418414497-23741-3-git-send-email-niso@kth.se>
References: <1418414497-23741-1-git-send-email-niso@kth.se> <1418414497-23741-3-git-send-email-niso@kth.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Friday 12 December 2014 21:01:35 Niklas Söderlund wrote:
> Add PFC support for the EMMA Mobile EV2 SoC including pin groups for
> on-chip devices.
> 
> Signed-off-by: Niklas Söderlund <niso@kth.se>
> ---
>  .../bindings/pinctrl/renesas,pfc-pinctrl.txt       |    1 +
>  drivers/pinctrl/sh-pfc/Kconfig                     |    5 +
>  drivers/pinctrl/sh-pfc/Makefile                    |    1 +
>  drivers/pinctrl/sh-pfc/core.c                      |    9 +
>  drivers/pinctrl/sh-pfc/core.h                      |    1 +
>  drivers/pinctrl/sh-pfc/pfc-emev2.c                 | 1915 +++++++++++++++++
>  6 files changed, 1932 insertions(+)
>  create mode 100644 drivers/pinctrl/sh-pfc/pfc-emev2.c

[snip]

> diff --git a/drivers/pinctrl/sh-pfc/pfc-emev2.c
> b/drivers/pinctrl/sh-pfc/pfc-emev2.c new file mode 100644
> index 0000000..22c9e15
> --- /dev/null
> +++ b/drivers/pinctrl/sh-pfc/pfc-emev2.c

[snip]

> +#define CPU_ALL_PORT(fn, sfx)						\
> +	PORT_GP_32(0, fn, sfx),						\
> +	PORT_GP_32(1, fn, sfx),						\
> +	PORT_GP_32(2, fn, sfx),						\
> +	PORT_GP_32(3, fn, sfx),						\
> +	PORT_GP_32(4, fn, sfx)

GPIOs are numbered linearly in the datasheet, not using a bank number. 
Shouldn't that be reflected here ? Additionally the chip has 159 GPIOs, and 
you define 160 of them.

[snip]

I'm afraid I can't review all the data tables, I'll trust you on that :-)

> +/* Pin numbers for pins without a corresponding GPIO port number are
> computed
> + * from the row and column numbers with a 1000 offset to avoid collisions
> with
> + * GPIO port numbers. */
> +#define PIN_NUMBER(row, col)            (1000+((row)-1)*25+(col)-1)

The chip is an 23x23 BGA, shouldn't you multiply by 23 instead of 25 ?

[snip]

> +#define EMEV_MUX_PIN(name, pin, mark) \
> +	static const unsigned int name##_pins[] = { pin }; \
> +	static const unsigned int name##_mux[] = { mark##_MARK }

[snip]

> +/* = [ IIC ] ============== */
> +EMEV_MUX_PIN(iic0_scl, 44, IIC0_SCL);
> +EMEV_MUX_PIN(iic0_sda, 45, IIC0_SDA);

[snip]

> +static const struct sh_pfc_pin_group pinmux_groups[] = {

[snip]

> +	SH_PFC_PIN_GROUP(iic0_scl),
> +	SH_PFC_PIN_GROUP(iic0_sda),

[snip]

> +};

[snip]

> +static const char * const iic0_groups[] = {
> +	"iic0_scl",
> +	"iic0_sda",
> +};

(Taking IIC0 as an example)

You're defining one pin group per pin. While this isn't an invalid decision, 
the sh-pfc driver tried so far to group related pins in the same group. For 
instance, with IIC0, SCL and SDA can't be used independently, so you always 
need to request both. They could thus be grouped together. Is there a reason 
not to follow the same design for EMEV2 ?

[snip]

> +static const struct sh_pfc_function pinmux_functions[] = {
> +	SH_PFC_FUNCTION(jtag),
> +	SH_PFC_FUNCTION(lcd),
> +	SH_PFC_FUNCTION(yuv),
> +	SH_PFC_FUNCTION(tp33),
> +	SH_PFC_FUNCTION(iic0),
> +	SH_PFC_FUNCTION(iic1),
> +	SH_PFC_FUNCTION(uart1),
> +	SH_PFC_FUNCTION(uart2),
> +	SH_PFC_FUNCTION(uart3),
> +	SH_PFC_FUNCTION(sd),
> +	SH_PFC_FUNCTION(sdi0),
> +	SH_PFC_FUNCTION(sdi1),
> +	SH_PFC_FUNCTION(sdi2),
> +	SH_PFC_FUNCTION(ab),
> +	SH_PFC_FUNCTION(dtv),
> +	SH_PFC_FUNCTION(cf),
> +	SH_PFC_FUNCTION(usi0),
> +	SH_PFC_FUNCTION(usi1),
> +	SH_PFC_FUNCTION(usi2),
> +	SH_PFC_FUNCTION(usi3),
> +	SH_PFC_FUNCTION(usi4),
> +	SH_PFC_FUNCTION(usi5),
> +	SH_PFC_FUNCTION(ntsc),
> +	SH_PFC_FUNCTION(cam),
> +	SH_PFC_FUNCTION(hsi),
> +};

Could you please order the functions alphabetically, here and above ?

[snip]

-- 
Regards,

Laurent Pinchart

