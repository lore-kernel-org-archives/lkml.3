Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762494Ab3IDNMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 09:12:14 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50085 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751993Ab3IDNMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:12:12 -0400
Date: Wed, 4 Sep 2013 14:11:11 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "arnd@arndb.de" <arnd@arndb.de>, broonie@kernel.org
Subject: Re: [PATCH 11/11] iio: pressure-core: st: Provide correct
 regulator support
Message-ID: <20130904131111.GJ18206@e106331-lin.cambridge.arm.com>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-12-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378287103-21765-12-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Wed, Sep 04, 2013 at 10:31:43AM +0100, Lee Jones wrote:
> The power to some of the sensors are controlled by regulators. In most
> cases these are 'always on', but if not they will fail to work until
> the regulator is enabled using the relevant APIs.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/iio/pressure/st_pressure_core.c | 13 +++++++++++++
>  include/linux/iio/common/st_sensors.h   |  3 +++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
> index f452417..7beed89 100644
> --- a/drivers/iio/pressure/st_pressure_core.c
> +++ b/drivers/iio/pressure/st_pressure_core.c
> @@ -23,6 +23,7 @@
>  #include <linux/iio/sysfs.h>
>  #include <linux/iio/trigger.h>
>  #include <linux/iio/buffer.h>
> +#include <linux/regulator/consumer.h>
>  #include <asm/unaligned.h>
>  
>  #include <linux/iio/common/st_sensors.h>
> @@ -315,6 +316,15 @@ int st_press_common_probe(struct iio_dev *indio_dev)
>  	indio_dev->modes = INDIO_DIRECT_MODE;
>  	indio_dev->info = &press_info;
>  
> +	/* Regulator not mandatory, but if requested we should enable it. */
> +	pdata->regulator = regulator_get(&indio_dev->dev, "vdd");
> +	if (!IS_ERR_OR_NULL(pdata->regulator)) {

Can regulator_get return NULL? As far as I can see, it either returns a
valid reulator pointer or an ERR_PTR value.

When you say "if requested", do you mean "if described in the dt"? If
so, the above doesn't distunguish between a regulator not being listed
and one failing to be got (e.g. if we got EPROBE_DEFER from
regulator_get).

I think this would be better handled with something like Mark Brown's
suggested regulator_get_optional [1,2].

Thanks,
Mark.

[1] https://lkml.org/lkml/2013/7/30/328 (cover)
[2] https://lkml.org/lkml/2013/7/30/334 (patches)

> +		err = regulator_enable(pdata->regulator);
> +		if (err != 0)
> +			dev_warn(&indio_dev->dev,
> +				 "Failed to enable specified vdd regulator\n");
> +	}
> +
>  	err = st_sensors_check_device_support(indio_dev,
>  					      ARRAY_SIZE(st_press_sensors),
>  					      st_press_sensors);
> @@ -363,6 +373,9 @@ void st_press_common_remove(struct iio_dev *indio_dev)
>  {
>  	struct st_sensor_data *pdata = iio_priv(indio_dev);
>  
> +	if (!IS_ERR_OR_NULL(pdata->regulator))
> +		regulator_disable(pdata->regulator);
> +
>  	iio_device_unregister(indio_dev);
>  	if (pdata->get_irq_data_ready(indio_dev) > 0) {
>  		st_sensors_deallocate_trigger(indio_dev);
> diff --git a/include/linux/iio/common/st_sensors.h b/include/linux/iio/common/st_sensors.h
> index 4aef925..eb6ef3f 100644
> --- a/include/linux/iio/common/st_sensors.h
> +++ b/include/linux/iio/common/st_sensors.h
> @@ -16,6 +16,7 @@
>  #include <linux/irqreturn.h>
>  #include <linux/iio/trigger.h>
>  #include <linux/bitops.h>
> +#include <linux/regulator/consumer.h>
>  
>  #define ST_SENSORS_TX_MAX_LENGTH		2
>  #define ST_SENSORS_RX_MAX_LENGTH		6
> @@ -197,6 +198,7 @@ struct st_sensors {
>   * @trig: The trigger in use by the core driver.
>   * @sensor: Pointer to the current sensor struct in use.
>   * @current_fullscale: Maximum range of measure by the sensor.
> + * @regulator: Pointer to sensor's power supply
>   * @enabled: Status of the sensor (false->off, true->on).
>   * @multiread_bit: Use or not particular bit for [I2C/SPI] multiread.
>   * @buffer_data: Data used by buffer part.
> @@ -211,6 +213,7 @@ struct st_sensor_data {
>  	struct iio_trigger *trig;
>  	struct st_sensors *sensor;
>  	struct st_sensor_fullscale_avl *current_fullscale;
> +	struct regulator *regulator;
>  
>  	bool enabled;
>  	bool multiread_bit;
> -- 
> 1.8.1.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
