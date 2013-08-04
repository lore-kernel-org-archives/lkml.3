Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3HDNsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 09:48:40 -0400
Received: from smtp-out-169.synserver.de ([212.40.185.169]:1318 "EHLO
	smtp-out-165.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751680Ab3HDNsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 09:48:39 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7001
Message-ID: <51FE5B0C.4070206@metafoo.de>
Date: Sun, 04 Aug 2013 15:45:48 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Oleksandr Kravchenko <x0199363@ti.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, jic23@cam.ac.uk,
        pmeerw@pmeerw.net, holler@ahsoftware.de, srinivas.pandruvada@intel.com,
        devicetree-discuss@lists.ozlabs.org,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: Re: [PATCH 2/2] iio: add Bosch BMA180 acceleration sensor driver
References: <1375109893-7917-1-git-send-email-x0199363@ti.com> <1375109893-7917-2-git-send-email-x0199363@ti.com>
In-Reply-To: <1375109893-7917-2-git-send-email-x0199363@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 04:58 PM, Oleksandr Kravchenko wrote:
> From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> 
> This patch adds IIO driver for Bosch BMA180 triaxial
> acceleration sensor.
> http://omapworld.com/BMA180_111_1002839.pdf
> 
> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> ---
>  .../devicetree/bindings/iio/accel/bma180.txt       |   53 +++
>  drivers/iio/accel/Kconfig                          |   10 +
>  drivers/iio/accel/Makefile                         |    2 +
>  drivers/iio/accel/bma180.c                         |  462 ++++++++++++++++++++
>  4 files changed, 527 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/accel/bma180.txt
>  create mode 100644 drivers/iio/accel/bma180.c
> 
> diff --git a/Documentation/devicetree/bindings/iio/accel/bma180.txt b/Documentation/devicetree/bindings/iio/accel/bma180.txt
> new file mode 100644
> index 0000000..7c13c84
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/accel/bma180.txt
> @@ -0,0 +1,53 @@
> +* Bosch BMA180 triaxial acceleration sensor
> +
> +http://omapworld.com/BMA180_111_1002839.pdf
> +
> +Required properties:
> +
> +  - compatible : should be "bosch,bma180"
> +  - reg : the I2C address of the sensor
> +
> +Optional properties:
> +
> +  - interrupt-parent : should be the phandle for the interrupt controller
> +
> +  - interrupts : interrupt mapping for GPIO IRQ, it shuld by configured with
> +		flags IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING
> +
> +  - range : select the full scale acceleration range
> +		0 : -1g..+1g
> +		1 : -1.5g..+1.5g
> +		2 : -2g..+2g
> +		3 : -3g..+3g
> +		4 : -4g..+4g
> +		5 : -8g..+8g
> +		6 : -16g..+16g
> +
> +  - bw : select bandwidth bandwidth
> +		0 : 10Hz
> +		1 : 20Hz
> +		2 : 40Hz
> +		3 : 75Hz
> +		4 : 150Hz
> +		5 : 300Hz
> +		Don't use bandwidth frequency more than 300Hz couse it
> +		influences the frequency of generating new data interrupts
> +		and i2c reading phase can be longer than pheriod of interrupt
> +		generation.
> +
> +  - mode_config : 0 - select low noise mode, 1 - select low power mode
> +
> +  - fuzz : specifies fuzz value that is used to filter noise from the event stream
> +

All the four properties above are vendor specific, so they need a vendor
prefix. Also no underscores in property names and no abbreviations. Also I
wonder if some of them should rather be runtime configurable, like range and
bandwidth,

> +Example:
> +
> +bma180@40 {
> +	compatible = "bosch,bma180";
> +	reg = <0x40>;
> +	interrupt-parent = <&gpio6>;
> +	interrupts = <18 (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING)>;
> +	range = <2>;
> +	bw = <0>;
> +	mode_config = <1>;
> +	fuzz = <555>;
> +};
[...]
> +static int bma180_read_raw(struct iio_dev *indio_dev,
> +		struct iio_chan_spec const *chan, int *val, int *val2,
> +		long mask)
> +{
> +	struct bma180_data *data = iio_priv(indio_dev);
> +	long tmp = ((s16)data->acc_reg[chan->channel] >> 2)
> +		* bma180_range_table[data->range].ratio;

> +
> +	if (data->acc_reg[chan->channel] < 0)
> +		return data->acc_reg[chan->channel];
> +
> +	*val = tmp / 1000000;
> +	*val2 = (tmp % 1000000);
> +

This doesn't look as if the device needs a special conversion formula. Just
expose the raw value and ratio as the scale.

> +	return IIO_VAL_INT_PLUS_MICRO;
> +}
[...]
