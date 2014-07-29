Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaG2JhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:37:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54274 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908AbaG2JhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:37:22 -0400
Date: Tue, 29 Jul 2014 10:37:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Dan Murphy <dmurphy@ti.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: Re: [v2] input: drv260x: Add TI drv260x haptics driver
Message-ID: <20140729093701.GJ2576@leverpostej>
References: <1406566403-1436-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406566403-1436-1-git-send-email-dmurphy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 05:53:23PM +0100, Dan Murphy wrote:
> Add the TI drv260x haptics/vibrator driver.
> This device uses the input force feedback
> to produce a wave form to driver an
> ERM or LRA actuator device.
> 
> The initial driver supports the devices
> real time playback mode.  But the device
> has additional wave patterns in ROM.
> 
> This functionality will be added in
> future patchsets.
> 
> Product data sheet is located here:
> http://www.ti.com/product/drv2605
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
> 
> v2 - Fixed binding doc and patch headline - https://patchwork.kernel.org/patch/4619641/
> 
>  .../devicetree/bindings/input/ti,drv260x.txt       |   44 ++
>  drivers/input/misc/Kconfig                         |    9 +
>  drivers/input/misc/Makefile                        |    1 +
>  drivers/input/misc/drv260x.c                       |  537 ++++++++++++++++++++
>  include/dt-bindings/input/ti-drv260x.h             |   30 ++
>  include/linux/input/drv260x.h                      |  181 +++++++
>  6 files changed, 802 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/ti,drv260x.txt
>  create mode 100644 drivers/input/misc/drv260x.c
>  create mode 100644 include/dt-bindings/input/ti-drv260x.h
>  create mode 100644 include/linux/input/drv260x.h
> 
> diff --git a/Documentation/devicetree/bindings/input/ti,drv260x.txt b/Documentation/devicetree/bindings/input/ti,drv260x.txt
> new file mode 100644
> index 0000000..930429b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/ti,drv260x.txt
> @@ -0,0 +1,44 @@
> +Texas Instruments - drv260x Haptics driver family
> +
> +The drv260x family serial control bus communicates through I2C protocols
> +
> +Required properties:
> +       - compatible - One of:
> +               "ti,drv2604" - DRV2604
> +               "ti,drv2605" - DRV2605
> +               "ti,drv2605l" - DRV2605L
> +       - reg -  I2C slave address
> +       - mode - Power up mode of the chip (defined in include/dt-bindings/input/ti-drv260x.h)
> +               DRV260X_RTP_MODE - Real time playback mode
> +               DRV260X_LRA_MODE - Linear Resonance Actuator mode (Piezoelectric)
> +               DRV260X_ERM_MODE - Eccentric Rotating Mass mode (Rotary vibrator)

What exactly are these, and why does the kernel not decide?

> +       - library_sel - Library to use at power up (defined in include/dt-bindings/input/ti-drv260x.h)

Please s/_/-/ in all property names.

> +               DRV260X_LIB_A - Pre-programmed Library
> +               DRV260X_LIB_B - Pre-programmed Library
> +               DRV260X_LIB_C - Pre-programmed Library
> +               DRV260X_LIB_D - Pre-programmed Library
> +               DRV260X_LIB_E - Pre-programmed Library
> +               DRV260X_LIB_F - Pre-programmed Library

What exactly are these, and why does the kernel not decide?

> +
> +Optional properties:
> +       - enable-gpio - gpio pin to enable/disable the device.
> +       - vib_rated_voltage - The rated voltage of the actuator.  If this is not
> +                                                 set then the value will be defaulted to 0x90 in the
> +                                                 driver.

What units is this in?

Don't mention the driver, just say "if not 0x90" (but with a better
description of what 0x90 actually means).

> +       - vib_overdrive_voltage - The overdrive voltage of the actuator.
> +                                                       If this is not set then the value
> +                                                       will be defaulted to 0x90 in the driver.

Similarly on both points.

[...]

> +static int drv260x_probe(struct i2c_client *client,
> +                          const struct i2c_device_id *id)
> +{
> +       struct drv260x_data *haptics;
> +       struct device_node *np = client->dev.of_node;
> +       struct drv260x_platform_data *pdata = client->dev.platform_data;
> +       struct ff_device *ff;
> +       int ret;
> +       int voltage;
> +
> +       haptics = devm_kzalloc(&client->dev, sizeof(*haptics), GFP_KERNEL);
> +       if (!haptics)
> +               return -ENOMEM;
> +
> +       haptics->rated_voltage = DRV260X_DEF_OD_CLAMP_VOLT;
> +       haptics->rated_voltage = DRV260X_DEF_RATED_VOLT;
> +
> +       if (np) {
> +               ret = of_property_read_u32(np, "mode", &haptics->mode);
> +               if (ret < 0) {
> +                       dev_err(&client->dev,
> +                               "%s: No entry for mode\n", __func__);
> +
> +                       return ret;
> +               }

No sanity checking on the actual value?

As far as I can see, haptics->mode is an int, not a u32.

> +               ret = of_property_read_u32(np, "library_sel",
> +                                       &haptics->library);
> +               if (ret < 0) {
> +                       dev_err(&client->dev,
> +                               "%s: No entry for library selection\n", __func__);
> +
> +                       return ret;
> +               }

Sanity checking?

haptics->library is not a u32.

> +               ret = of_property_read_u32(np, "vib_rated_voltage",
> +                                       &voltage);
> +               if (!ret)
> +                       haptics->rated_voltage = drv260x_calculate_voltage(voltage);
> +
> +
> +               ret = of_property_read_u32(np, "vib_overdrive_voltage",
> +                                       &voltage);
> +               if (!ret)
> +                       haptics->overdrive_voltage = drv260x_calculate_voltage(voltage);
> +

And again, on both points.

> +       } else if (pdata) {
> +               haptics->mode = pdata->mode;
> +               haptics->library = pdata->library_selection;
> +               if (pdata->vib_overdrive_voltage)
> +                       haptics->overdrive_voltage = drv260x_calculate_voltage(pdata->vib_overdrive_voltage);
> +               if (pdata->vib_rated_voltage)
> +                       haptics->rated_voltage = drv260x_calculate_voltage(pdata->vib_rated_voltage);
> +       } else {
> +               dev_err(&client->dev, "Platform data not set\n");
> +               return -ENODEV;
> +       }
> +
> +       haptics->regulator = regulator_get(&client->dev, "vbat");

This wasn't in the binding.

Thanks,
Mark.
