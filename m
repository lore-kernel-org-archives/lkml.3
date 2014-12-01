Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaLARPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:15:23 -0500
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:35820 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752783AbaLARPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:15:22 -0500
MIME-Version: 1.0
In-Reply-To: <1417453389-1588-2-git-send-email-stefan@agner.ch>
References: <1417453389-1588-1-git-send-email-stefan@agner.ch>
	<1417453389-1588-2-git-send-email-stefan@agner.ch>
Date: Mon, 1 Dec 2014 09:15:21 -0800
Message-ID: <CAL85gmBq30pWxP0buKbM8so6QqsJq2YojiSK1EWtMPsH_7foeg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] power: reset: read priority from device tree
From: Feng Kan <fkan@apm.com>
To: Stefan Agner <stefan@agner.ch>
Cc: shawn.guo@linaro.org, kernel@pengutronix.de,
        Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        sre@kernel.org, grant.likely@linaro.org, robh+dt@kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 9:03 AM, Stefan Agner <stefan@agner.ch> wrote:
> This patch adds an optional property which allows to specify the
> reset source priority. This priority is used by the kernel restart
> handler call chain to sort out the proper reset/restart method.
> Depending on the power design of a board or other machine/board
> specific peculiarity, it is not possible to pick a generic priority.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  Documentation/devicetree/bindings/power/reset/syscon-reboot.txt | 3 +++
>  drivers/power/reset/syscon-reboot.c                             | 5 ++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> index 1190631..ee41d9c 100644
> --- a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> +++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> @@ -11,6 +11,9 @@ Required properties:
>  - offset: offset in the register map for the reboot register (in bytes)
>  - mask: the reset value written to the reboot register (32 bit access)
>
> +Optional properties:
> +- priority: define the priority of the reset (0-255, defaults to 128)
> +
>  Default will be little endian mode, 32 bit access only.
>
>  Examples:
> diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
> index 815b901..3060d6b 100644
> --- a/drivers/power/reset/syscon-reboot.c
> +++ b/drivers/power/reset/syscon-reboot.c
> @@ -67,8 +67,11 @@ static int syscon_reboot_probe(struct platform_device *pdev)
>         if (of_property_read_u32(pdev->dev.of_node, "mask", &ctx->mask))
>                 return -EINVAL;
>
> -       ctx->restart_handler.notifier_call = syscon_restart_handle;
>         ctx->restart_handler.priority = 128;
> +       of_property_read_u32(pdev->dev.of_node, "priority",
> +                            &ctx->restart_handler.priority);

What is this for?
> +
> +       ctx->restart_handler.notifier_call = syscon_restart_handle;
>         err = register_restart_handler(&ctx->restart_handler);
>         if (err)
>                 dev_err(dev, "can't register restart notifier (err=%d)\n", err);
> --
> 2.1.3
>
