Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965165Ab3DHK0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:26:51 -0400
Received: from sauhun.de ([89.238.76.85]:39249 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965152Ab3DHK0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:26:48 -0400
Date: Mon, 8 Apr 2013 12:26:17 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        Prashanth G <prashanth.g@samsung.com>, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>, Jean Delvare <khali@linux-fr.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v4 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
Message-ID: <20130408102617.GC3496@the-dreams.de>
References: <1360957573-864-1-git-send-email-dianders@chromium.org>
 <1363192583-26363-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363192583-26363-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 09:36:21AM -0700, Doug Anderson wrote:
> The i2c-arbitrator-cros-ec driver implements the arbitration scheme
> that the Embedded Controller (EC) on the ARM Chromebook expects to use
> for bus multimastering.  This i2c-arbitrator-cros-ec driver could also
> be used in other places where standard I2C bus arbitration can't be
> used and two extra GPIOs are available for arbitration.
> 
> This driver is based on code that Simon Glass added to the i2c-s3c2410
> driver in the Chrome OS kernel 3.4 tree.  The current incarnation as a
> mux driver is as suggested by Grant Likely.  See
> <https://patchwork.kernel.org/patch/1877311/> for some history.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Simon Glass <sjg@chromium.org>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

I'd like to have the bindings more generic. They should allow for n
possible masters IMO. It doesn't need to be implemented right now, but
it should be possible to add that later.

> ---
> Changes in v4: None
> Changes in v3:
> - Handle of_find_i2c_adapter_by_node() failure more properly by
>   changing init order.
> - Don't warn on -EPROBE_DEFER from calls that could return it.
> - Move to module_platform_driver().  As we pull in parts of the system
>   that rely on devices under this i2c bus we'll need to make sure they
>   can handle the fact that they'll be initted later now.
> 
> Changes in v2:
> - Renamed to i2c-arbitrator-cros-ec.
> - Documented "microsecond" properties as optional; removed
>   "bus-arbitration" prefix since it was just extra wordy.
> - Split GPIOs into two properties to make it cleaner.
> - Capitalized I2C in freeform text.
> - Get 'active low' from device tree.
> 
>  .../bindings/i2c/i2c-arbitrator-cros-ec.txt        |  76 +++++++

I wonder about a more generic name. i2c-arb-gpio-challenge.* maybe?

>  drivers/i2c/muxes/Kconfig                          |  11 +
>  drivers/i2c/muxes/Makefile                         |   2 +
>  drivers/i2c/muxes/i2c-arbitrator-cros-ec.c         | 222 +++++++++++++++++++++
>  4 files changed, 311 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-arbitrator-cros-ec.txt
>  create mode 100644 drivers/i2c/muxes/i2c-arbitrator-cros-ec.c
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-arbitrator-cros-ec.txt b/Documentation/devicetree/bindings/i2c/i2c-arbitrator-cros-ec.txt
> new file mode 100644
> index 0000000..1f893e7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-arbitrator-cros-ec.txt
> @@ -0,0 +1,76 @@
> +GPIO-based Arbitration used by the ARM Chromebook (exynos5250-snow)
> +===================================================================
> +This uses GPIO lines between the AP (Application Processor) and an attached
> +EC (Embedded Controller) which both want to talk on the same I2C bus as master.
> +
> +The AP and EC each have a 'bus claim' line, which is an output that the
> +other can see. These are both active low, with pull-ups enabled.
> +
> +- AP_CLAIM: output from AP, signalling to the EC that the AP wants the bus
> +- EC_CLAIM: output from EC, signalling to the AP that the EC wants the bus

I'd like to drop the specific terms of AP and EC and just talk about
multiple masters.

> +This mechanism is used instead of standard I2C multimaster to avoid some of the
> +subtle driver and silicon bugs that are often present with I2C multimaster.
> +
> +
> +Algorithm:
> +
> +The basic algorithm is to assert your line when you want the bus, then make
> +sure that the other side doesn't want it also. A detailed explanation is best
> +done with an example.
> +
> +Let's say the AP wants to claim the bus. It:
> +1. Asserts AP_CLAIM.
> +2. Waits a little bit for the other side to notice (slew time, say 10
> +   microseconds).
> +3. Checks EC_CLAIM. If this is not asserted then the AP has the bus and we are
> +   done.
> +4. Otherwise, wait for a few milliseconds and see if EC_CLAIM is released.
> +5. If not, back off, release the claim and wait for a few more milliseconds.
> +6. Go back to 1 (until retry time has expired).
> +
> +
> +Required properties:
> +- compatible: i2c-arbitrator-cros-ec
> +- ap-claim-gpio: The GPIO that we (the AP) use to claim the bus.
> +- ec-claim-gpio: The GPIO that the other side (the EC) uses the claim the bus.

An array based approach like in the i2c-mux-gpio driver would be more
generic. Just mention that the driver only supports 2 entries at the
moment.

> +- Standard I2C mux properties. See mux.txt in this directory.
> +- Single I2C child bus node at reg 0. See mux.txt in this directory.
> +
> +Optional properties:
> +- slew-delay-us: microseconds to wait for a GPIO to go high. Default is 10 us.
> +- wait-retry-us: we'll attempt another claim after this many microseconds.
> +    Default is 3000 us.
> +- wait-free-us: we'll give up after this many microseconds. Default is 50000 us.

Grant, I assume it is okay to introduce these generic bindings?

> diff --git a/drivers/i2c/muxes/Kconfig b/drivers/i2c/muxes/Kconfig
> index 0be5b83..ca19378 100644
> --- a/drivers/i2c/muxes/Kconfig
> +++ b/drivers/i2c/muxes/Kconfig
> @@ -5,6 +5,17 @@
>  menu "Multiplexer I2C Chip support"
>  	depends on I2C_MUX
>  
> +config I2C_ARBITRATOR_CROS_EC
> +	tristate "GPIO-based I2C arbitrator used on exynos5250-snow"
> +	depends on GENERIC_GPIO && OF
> +	help
> +	  If you say yes to this option, support will be included for an
> +	  I2C multimaster arbitration scheme using GPIOs that is used in
> +	  the Samsung ARM Chromebook (exynos5250-snow).
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called i2c-arbitrator-cros-ec.
> +

This text could be more generic then, too.

> +static int i2c_arbitrator_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct device_node *parent_np;
> +	struct i2c_arbitrator_data *arb;
> +	enum of_gpio_flags gpio_flags;
> +	unsigned long out_init;
> +	int ret;
> +
> +	/* We only support probing from device tree; no platform_data */
> +	if (WARN_ON(!np))
> +		return -ENODEV;

Too much WARN_ON for my taste.

Thanks,

   Wolfram
