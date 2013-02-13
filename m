Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3BMSp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:45:59 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:51171 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab3BMSp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:45:57 -0500
Date: Wed, 13 Feb 2013 10:45:59 -0800
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        Prashanth G <prashanth.g@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Stephen Warren <swarren@nvidia.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v1 1/4] i2c: mux: Add i2c-arbitrator 'mux' driver
Message-ID: <20130213184559.GA29145@quad.lixom.net>
References: <1360778532-7480-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360778532-7480-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The driver pieces have been reviewed a bit already, but I have a question on
the bindings below.

On Wed, Feb 13, 2013 at 10:02:09AM -0800, Doug Anderson wrote:
> The i2c-arbitrator driver implements the arbitration scheme that the
> Embedded Controller (EC) on the ARM Chromebook expects to use for bus
> multimastering.  This i2c-arbitrator driver could also be used in
> other places where standard i2c bus arbitration can't be used and two
> extra GPIOs are available for arbitration.
> 
> This driver is based on code that Simon Glass added to the i2c-s3c2410
> driver in the Chrome OS kernel 3.4 tree.  The current incarnation as a
> mux driver is as suggested by Grant Likely.  See
> <https://patchwork.kernel.org/patch/1877311/> for some history.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Simon Glass <sjg@chromium.org>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes in v1: None
> 
>  .../devicetree/bindings/i2c/i2c-arbitrator.txt     |  76 +++++++
>  drivers/i2c/muxes/Kconfig                          |  11 +
>  drivers/i2c/muxes/Makefile                         |   1 +
>  drivers/i2c/muxes/i2c-arbitrator.c                 | 242 +++++++++++++++++++++
>  4 files changed, 330 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-arbitrator.txt
>  create mode 100644 drivers/i2c/muxes/i2c-arbitrator.c
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-arbitrator.txt b/Documentation/devicetree/bindings/i2c/i2c-arbitrator.txt
> new file mode 100644
> index 0000000..bb9cca7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-arbitrator.txt
> @@ -0,0 +1,76 @@
> +GPIO-based Arbitration
> +======================
> +This uses GPIO lines between the AP (Application Processor) and an attached
> +EC (Embedded Controller) which both want to talk on the same I2C bus as master.
> +
> +The AP and EC each have a 'bus claim' line, which is an output that the
> +other can see. These are both active low, with pull-ups enabled.
> +
> +- AP_CLAIM: output from AP, signalling to the EC that the AP wants the bus
> +- EC_CLAIM: output from EC, signalling to the AP that the EC wants the bus
> +
> +
> +This mechanism is used instead of standard i2c multimaster to avoid some of the
> +subtle driver and silicon bugs that are often present with i2c multimaster.
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
> +- compatible: i2c-arbitrator
> +- bus-arbitration-gpios: Two GPIOs to use with the GPIO-based bus
> +    arbitration protocol.  The first should be an output, and is used to
> +    claim the I2C bus for us (AP_CLAIM).  The second should be an input and
> +    signals that the other side wants to claim the bus (EC_CLAIM).
> +- bus-arbitration-slew-delay-us: microseconds to wait for a GPIO to go high.
> +- bus-arbitration-wait-retry-us: we'll attempt another claim after this many
> +    microseconds.
> +- bus-arbitration-wait-free-us: we'll give up after this many microseconds.
> +- Standard I2C mux properties. See mux.txt in this directory.
> +- Single I2C child bus node at reg 0. See mux.txt in this directory.
> +
> +
> +Example:
> +	i2c@12CA0000 {
> +		compatible = "acme,some-i2c-device";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +	};
> +
> +	i2c-arbitrator {
> +		compatible = "i2c-arbitrator";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		i2c-parent = <&{/i2c@12CA0000}>;

Why use this custom i2c-parent property? The arbitrator should just be
under the i2c controller in the device tree, and thus parent would be
derived from the topology there.


-Olof
