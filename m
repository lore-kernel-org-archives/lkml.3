Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaBXDwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:52:07 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:55070 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaBXDwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:52:04 -0500
MIME-Version: 1.0
In-Reply-To: <1393178459-14637-4-git-send-email-vladimir.barinov@cogentembedded.com>
References: <1393178459-14637-1-git-send-email-vladimir.barinov@cogentembedded.com>
	<1393178459-14637-4-git-send-email-vladimir.barinov@cogentembedded.com>
Date: Mon, 24 Feb 2014 12:52:01 +0900
Message-ID: <CANqRtoSKckgZBSaHDYYjfbTECJfB1Nn57suYspT0FR97P8SZFg@mail.gmail.com>
Subject: Re: [PATCH V4 3/4] ARM: shmobile: koelsch: Add USBHS and internal PCI
 USB support
From: Magnus Damm <magnus.damm@gmail.com>
To: vladimir.barinov@cogentembedded.com
Cc: SH-Linux <linux-sh@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 3:00 AM,  <vladimir.barinov@cogentembedded.com> wrote:
> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>
> This adds the following to R-Car M2 Koelsch board:
> - USBHS PHY
> - USBHS device
> - internal PCI USB host devices
>
> Depending on state of ID pin from MAX3355E chip the usb0 is configured
> ether as host or gadget.
> In case of gadget the USBHS device is registered.
> In case of host the PCI USB is registered.
>
> The USB phy is bound to either USB host or USBHS device respectively, hence
> configured to ether channel 0 or 2.
>
> The USBHS can act as USB Host, and this can be easily configured.
> But the simplest test with storage stick connected to USBHS Host provides
> IP resets and system hangs. Even the PWEN pin is not handled and it is nessasary to
> provide VBUS using gpio. It is easy to see in RCAR H2/M2 documentation
> that the USBHS IP changed. F.e. the PWEN/EXTLP pins are no more presented in
> USBHS via DVSTCTR register. And others.
>
> Since the USBHS is not stable in Host mode lets connect fully tested PCI USB IP to usb0.
>
> Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>
> Changes in V4:
> * folded USBHS and internal PCI USB related patches together
> * added handling of ID pin from MAX3355E chip
> * removed ifdefs

Thanks for removing the ifdefs and adding some initial implementation
for the MAX chip.

Please see my comments below.

> --- build.orig/arch/arm/mach-shmobile/board-koelsch.c   2014-02-23 21:47:44.510571967 +0400
> +++ build/arch/arm/mach-shmobile/board-koelsch.c        2014-02-23 21:47:59.358571662 +0400
> @@ -367,6 +370,177 @@
>         DEFINE_RES_IRQ(gic_spi(168)),
>  };
>
> +/* USBHS */
> +static const struct resource usbhs_resources[] __initconst = {
> +       DEFINE_RES_MEM(0xe6590000, 0x100),
> +       DEFINE_RES_IRQ(gic_spi(107)),
> +};
> +
> +struct usbhs_private {
> +       struct renesas_usbhs_platform_info info;
> +       struct usb_phy *phy;
> +};
> +
> +#define usbhs_get_priv(pdev) \
> +       container_of(renesas_usbhs_get_info(pdev), struct usbhs_private, info)
> +
> +static int usbhs_power_ctrl(struct platform_device *pdev,
> +                               void __iomem *base, int enable)
> +{
> +       struct usbhs_private *priv = usbhs_get_priv(pdev);
> +
> +       if (!priv->phy)
> +               return -ENODEV;
> +
> +       if (enable) {
> +               int retval = usb_phy_init(priv->phy);
> +
> +               if (!retval)
> +                       retval = usb_phy_set_suspend(priv->phy, 0);
> +               return retval;
> +       }
> +
> +       usb_phy_set_suspend(priv->phy, 1);
> +       usb_phy_shutdown(priv->phy);
> +       return 0;
> +}
> +
> +static int usbhs_hardware_init(struct platform_device *pdev)
> +{
> +       struct usbhs_private *priv = usbhs_get_priv(pdev);
> +       struct usb_phy *phy;
> +
> +       phy = usb_get_phy_dev(&pdev->dev, 0);
> +       if (IS_ERR(phy))
> +               return PTR_ERR(phy);
> +
> +       priv->phy = phy;
> +       return 0;
> +}
> +
> +static int usbhs_hardware_exit(struct platform_device *pdev)
> +{
> +       struct usbhs_private *priv = usbhs_get_priv(pdev);
> +
> +       if (!priv->phy)
> +               return 0;
> +
> +       usb_put_phy(priv->phy);
> +       priv->phy = NULL;
> +       return 0;
> +}
> +
> +static int usbhs_get_id(struct platform_device *pdev)
> +{
> +       return USBHS_GADGET;
> +}

Uhm, I sort of expected this place to be where you read out the ID pin
state from the MAX device.

> +static u32 koelsch_usbhs_pipe_type[] = {
> +       USB_ENDPOINT_XFER_CONTROL,
> +       USB_ENDPOINT_XFER_ISOC,
> +       USB_ENDPOINT_XFER_ISOC,
> +       USB_ENDPOINT_XFER_BULK,
> +       USB_ENDPOINT_XFER_BULK,
> +       USB_ENDPOINT_XFER_BULK,
> +       USB_ENDPOINT_XFER_INT,
> +       USB_ENDPOINT_XFER_INT,
> +       USB_ENDPOINT_XFER_INT,
> +       USB_ENDPOINT_XFER_BULK,
> +       USB_ENDPOINT_XFER_BULK,
> +       USB_ENDPOINT_XFER_BULK,
> +       USB_ENDPOINT_XFER_BULK,
> +       USB_ENDPOINT_XFER_BULK,
> +       USB_ENDPOINT_XFER_BULK,
> +       USB_ENDPOINT_XFER_BULK,
> +};
> +
> +static struct usbhs_private usbhs_priv __initdata = {
> +       .info = {
> +               .platform_callback = {
> +                       .power_ctrl     = usbhs_power_ctrl,
> +                       .hardware_init  = usbhs_hardware_init,
> +                       .hardware_exit  = usbhs_hardware_exit,
> +                       .get_id         = usbhs_get_id,
> +               },
> +               .driver_param = {
> +                       .buswait_bwait  = 4,
> +                       .pipe_type = koelsch_usbhs_pipe_type,
> +                       .pipe_size = ARRAY_SIZE(koelsch_usbhs_pipe_type),
> +               },
> +       }
> +};
> +
> +static void __init koelsch_add_usb0_gadget(void)
> +{
> +       usb_bind_phy("renesas_usbhs", 0, "usb_phy_rcar_gen2");
> +       platform_device_register_resndata(&platform_bus,
> +                                         "renesas_usbhs", -1,
> +                                         usbhs_resources,
> +                                         ARRAY_SIZE(usbhs_resources),
> +                                         &usbhs_priv.info,
> +                                         sizeof(usbhs_priv.info));
> +}
> +
> +/* Internal PCI0 */
> +static const struct resource pci0_resources[] __initconst = {
> +       DEFINE_RES_MEM(0xee090000, 0x10000),    /* CFG */
> +       DEFINE_RES_MEM(0xee080000, 0x10000),    /* MEM */
> +       DEFINE_RES_IRQ(gic_spi(108)),
> +};
> +
> +static void __init koelsch_add_usb0_host(void)
> +{
> +       usb_bind_phy("0000:00:01.0", 0, "usb_phy_rcar_gen2");
> +       usb_bind_phy("0000:00:02.0", 0, "usb_phy_rcar_gen2");
> +       platform_device_register_simple("pci-rcar-gen2",
> +                                       0, pci0_resources,
> +                                       ARRAY_SIZE(pci0_resources));
> +}
> +
> +/* Internal PCI1 */
> +static const struct resource pci1_resources[] __initconst = {
> +       DEFINE_RES_MEM(0xee0d0000, 0x10000),    /* CFG */
> +       DEFINE_RES_MEM(0xee0c0000, 0x10000),    /* MEM */
> +       DEFINE_RES_IRQ(gic_spi(113)),
> +};
> +
> +static void __init koelsch_add_usb1_host(void)
> +{
> +       platform_device_register_simple("pci-rcar-gen2",
> +                                       1, pci1_resources,
> +                                       ARRAY_SIZE(pci1_resources));
> +}
> +
> +/* USBHS PHY */
> +static struct rcar_gen2_phy_platform_data usbhs_phy_pdata = {
> +       .chan2_pci = 1, /* Channel 2 is PCI USB host */
> +};
> +
> +static const struct resource usbhs_phy_resources[] __initconst = {
> +       DEFINE_RES_MEM(0xe6590100, 0x100),
> +};
> +
> +/* Add all available USB devices */
> +static void __init koelsch_add_usb_devices(void)
> +{
> +       /* MAX3355E ID pin */
> +       gpio_request_one(RCAR_GP_PIN(5, 31), GPIOF_IN, NULL);
> +       if (!gpio_get_value(RCAR_GP_PIN(5, 31))) {
> +               usbhs_phy_pdata.chan0_pci = 1; /* Channel 0 is PCI USB host */
> +               koelsch_add_usb0_host();
> +       } else {
> +               usbhs_phy_pdata.chan0_pci = 0; /* Channel 0 is USBHS */
> +               koelsch_add_usb0_gadget();
> +       }

I don't think we should perform this kind of check at boot-up. This
goes without saying, but normal USB supports hot-plug so we should
check the cable type when the cable insertion event happens. Please
see my comment above for USBHS-specific location.

I do however understand that according to your investigation you
cannot use USBHS in host mode. I believe further investigation is
needed in that area to determine what is the best way forward.
Regarding VBUS control, I believe it should be possible to drive the
USB0_VBUS as GPIO and manually control the power.

Would it be possible for you to break out USB PCI support for USB1 and
resend that so we can begin by merging that?

Thanks,

/ magnus
