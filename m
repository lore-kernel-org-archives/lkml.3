Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab3HMNrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:47:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38250 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756891Ab3HMNrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:47:49 -0400
Date: Tue, 13 Aug 2013 14:47:45 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "srinivas.pandruvada@linux.intel.com" 
	<srinivas.pandruvada@linux.intel.com>,
        "lars@metafoo.de" <lars@metafoo.de>
Subject: Re: [PATCH v2] iio: add Bosch BMA180 acceleration sensor driver
Message-ID: <20130813134745.GP27165@e106331-lin.cambridge.arm.com>
References: <1376384956-16720-1-git-send-email-o.v.kravchenko@globallogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376384956-16720-1-git-send-email-o.v.kravchenko@globallogic.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:09:16AM +0100, Oleksandr Kravchenko wrote:
> This patch adds IIO driver for Bosch BMA180 triaxial
> acceleration sensor.
> http://omapworld.com/BMA180_111_1002839.pdf
> 
> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> ---
>  .../devicetree/bindings/iio/accel/bma180.txt       |   35 ++
>  drivers/iio/accel/Kconfig                          |   12 +
>  drivers/iio/accel/Makefile                         |    2 +
>  drivers/iio/accel/bma180.c                         |  635 ++++++++++++++++++++
>  4 files changed, 684 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/accel/bma180.txt
>  create mode 100644 drivers/iio/accel/bma180.c
> 
> diff --git a/Documentation/devicetree/bindings/iio/accel/bma180.txt b/Documentation/devicetree/bindings/iio/accel/bma180.txt
> new file mode 100644
> index 0000000..e08780b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/accel/bma180.txt
> @@ -0,0 +1,35 @@
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
> +  - interrupts : interrupt mapping for GPIO IRQ, it should by configured with
> +               flags IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING
> +
> +  - bosch,resolution : ADC resolution. Must be 130, 190, 250, 380, 500,
> +               990 or 1980 mcg/LSB only
> +
> +  - bosch,bandwidth : select bandwidth frequency. Must be 10, 20, 40, 75,
> +               150 or 300 Hz only
> +
> +  - bosch,mode : 0 - select low noise mode, 1 - select low power mode

>From the looks of the code, those last three properties seem to get
programmed into the device, have default values, and look far more like
configuration rather than hardware description.

I don't think these need to be in the dt -- you can set sane defaults
and then have something under sysfs to change them dynamically later if
necessary.

> +
> +Example:
> +
> +bma180@40 {
> +       compatible = "bosch,bma180";
> +       reg = <0x40>;
> +       interrupt-parent = <&gpio6>;
> +       interrupts = <18 (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING)>;
> +       bosch,bandwidth = <300>;
> +       bosch,resolution = <250>;
> +       bosch,mode = <0>;
> +};

[...]

> +static int bma180_probe(struct i2c_client *client,
> +               const struct i2c_device_id *id)
> +{
> +       struct bma180_data *data;
> +       struct iio_dev *indio_dev;
> +       struct iio_trigger *trig;
> +       struct device_node *np = client->dev.of_node;
> +       int ret;
> +
> +       indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
> +       if (!indio_dev)
> +               return -ENOMEM;
> +
> +       data = iio_priv(indio_dev);
> +       i2c_set_clientdata(client, indio_dev);
> +       data->client = client;
> +
> +       if (of_property_read_u32(np, "bosch,bandwidth", &data->bw))
> +               data->bw = BMA180_DEF_BW;
> +       if (of_property_read_u32(np, "bosch,resolution", &data->scale))
> +               data->scale = BMA180_DEF_SCALE;
> +       of_property_read_u32(np, "bosch,mode", &data->mode);

What if bosch,mode isn't decribed? It looks like it'll have an
uninitialised value.

> +
> +       ret = bma180_chip_init(data);
> +       if (ret < 0)
> +               goto err_1;
> +
> +       mutex_init(&data->mutex);
> +
> +       indio_dev->dev.parent = &client->dev;
> +       indio_dev->channels = bma180_channels;
> +       indio_dev->num_channels = ARRAY_SIZE(bma180_channels);
> +       indio_dev->name = BMA180_DRV_NAME;
> +       indio_dev->modes = INDIO_DIRECT_MODE;
> +       indio_dev->info = &bma180_info;
> +
> +       trig = iio_trigger_alloc("%s-dev%d", indio_dev->name, indio_dev->id);
> +       if (!trig) {
> +               ret = -ENOMEM;
> +               goto err_1;
> +       }
> +
> +       ret = devm_request_irq(&client->dev, client->irq,
> +                       iio_trigger_generic_data_rdy_poll,
> +                       IRQF_TRIGGER_RISING, BMA180_IRQ_NAME, trig);
> +       if (ret) {
> +               dev_err(&client->dev, "unable to request IRQ\n");
> +               goto err_2;
> +       }
> +
> +       trig->dev.parent = &client->dev;
> +       trig->ops = &bma180_trigger_ops;
> +       iio_trigger_set_drvdata(trig, indio_dev);
> +       data->trig = trig;
> +       indio_dev->trig = trig;
> +
> +       ret = iio_trigger_register(trig);
> +       if (ret)
> +               goto err_2;
> +
> +       ret = iio_triggered_buffer_setup(indio_dev, NULL,
> +                       bma180_trigger_handler, NULL);
> +       if (ret < 0) {
> +               dev_err(&client->dev, "unable to setup iio triggered buffer\n");
> +               goto err_3;
> +       }
> +
> +       ret = iio_device_register(indio_dev);
> +       if (ret < 0) {
> +               dev_err(&client->dev, "unable to register iio device\n");
> +               goto err_4;
> +       }
> +
> +       return 0;
> +
> +err_4:
> +       iio_triggered_buffer_cleanup(indio_dev);
> +err_3:
> +       iio_trigger_unregister(trig);
> +err_2:
> +       iio_trigger_free(trig);
> +err_1:
> +       bma180_chip_disable(data);

It would be nice to have (slightly) clearer labels here, e.g.
err_chip, err_trigger.

Thanks,
Mark.
