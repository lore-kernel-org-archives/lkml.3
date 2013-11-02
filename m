Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3KBAcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 20:32:46 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37182 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3KBAcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 20:32:43 -0400
MIME-Version: 1.0
In-Reply-To: <20131101124958.GB6734@katana>
References: <1381960909-1735-1-git-send-email-tim.kryger@linaro.org>
	<1381960909-1735-2-git-send-email-tim.kryger@linaro.org>
	<20131101124958.GB6734@katana>
Date: Fri, 1 Nov 2013 17:32:42 -0700
Message-ID: <CAAYSxho8nd3TOsJ8LGfs94pHxoFYDxyZL0xjPA-CqVKVf7Nafw@mail.gmail.com>
Subject: Re: [RESEND PATCH 1/4] i2c: i2c-bcm-kona: Introduce Broadcom I2C Driver
From: Tim Kryger <tim.kryger@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 5:49 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Wed, Oct 16, 2013 at 03:01:46PM -0700, Tim Kryger wrote:
>> Introduce support for Broadcom Serial Controller (BSC) I2C bus found
>> in the Kona family of Mobile SoCs.  FIFO hardware is utilized but only
>> standard mode (100kHz), fast mode (400kHz), and fast mode plus (1MHz)
>> bus speeds are supported.
>>
>> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
>> Reviewed-by: Matt Porter <matt.porter@linaro.org>
>> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
>
> Looks mostly good, some remarks:
>
>> +struct bcm_kona_i2c_dev {
>> +     /* Pointer to linux device struct */
>> +     struct device *device;
>> +
>> +     /* Virtual address where registers are mapped */
>> +     void __iomem *base;
>> +
>> +     /* Interrupt */
>> +     int irq;
>> +
>> +     /* Standard Speed configuration */
>> +     const struct bus_speed_cfg *std_cfg;
>> +
>> +     /* Linux I2C adapter struct */
>> +     struct i2c_adapter adapter;
>> +
>> +     /* Lock for the I2C device */
>> +     struct mutex i2c_bcm_lock;
>> +
>> +     /* Completion to signal an operation finished */
>> +     struct completion done;
>> +
>> +     /* Handle for external clock */
>> +     struct clk *external_clk;
>> +};
>
> IMO most of the comments could go. Kind of stating the obvious :)

Sure thing.

>
>> +/* Read any amount of data using the RX FIFO from the i2c bus */
>> +static int bcm_kona_i2c_read_fifo(struct bcm_kona_i2c_dev *dev,
>> +                               struct i2c_msg *msg)
>> +{
>> +     unsigned int bytes_to_read = MAX_RX_FIFO_SIZE;
>> +     unsigned int last_byte_nak = 0;
>> +     unsigned int bytes_read = 0;
>> +     unsigned int rc;
>
> Should be signed.

Absolutely.  Thanks for catching this one.

>
>> +/* Write any amount of data using TX FIFO to the i2c bus */
>> +static int bcm_kona_i2c_write_fifo(struct bcm_kona_i2c_dev *dev,
>> +                                struct i2c_msg *msg)
>> +{
>> +     unsigned int bytes_to_write = MAX_TX_FIFO_SIZE;
>> +     unsigned int bytes_written = 0;
>> +     unsigned int rc;
>
> Ditto signed.

I shall fix it.

>
>> +/* Master transfer function */
>> +static int bcm_kona_i2c_xfer(struct i2c_adapter *adapter,
>> +                          struct i2c_msg msgs[], int num)
>> +{
>> +     struct bcm_kona_i2c_dev *dev = i2c_get_adapdata(adapter);
>> +     struct i2c_msg *pmsg;
>> +     int rc = 0;
>> +     int i;
>> +
>> +     mutex_lock(&dev->i2c_bcm_lock);
>
> Huh? Why do you need that? The core has locks per bus.

In that case, I will remove the local mutex.

>> +static int bcm_kona_i2c_assign_bus_speed(struct bcm_kona_i2c_dev *dev)
>> +{
>> +     unsigned int bus_speed;
>> +     int ret = of_property_read_u32(dev->device->of_node, "clock-frequency",
>> +                                    &bus_speed);
>> +     if (ret < 0) {
>> +             dev_err(dev->device, "missing clock-frequency property\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     switch (bus_speed) {
>> +     case 100000:
>> +             dev->std_cfg = &std_cfg_table[BCM_SPD_100K];
>> +             break;
>> +     case 400000:
>> +             dev->std_cfg = &std_cfg_table[BCM_SPD_400K];
>> +             break;
>> +     case 1000000:
>> +             dev->std_cfg = &std_cfg_table[BCM_SPD_1MHZ];
>> +             break;
>> +     default:
>> +             pr_err("%d hz bus speed not supported\n", bus_speed);
>> +             return -EINVAL;
>> +     };
>
> Unneeded semicolon.
>

Sure.  It will be removed.

>> +
>> +     return 0;
>> +}
>> +
>> +static int bcm_kona_i2c_probe(struct platform_device *pdev)
>> +{
>> +     int rc = 0;
>> +     struct bcm_kona_i2c_dev *dev;
>> +     struct i2c_adapter *adap;
>> +     struct resource *iomem;
>> +
>> +     /* Allocate memory for private data structure */
>> +     dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
>> +     if (!dev) {
>> +             rc = -ENOMEM;
>> +             goto probe_return;
>
> I'd prefer simply return -Esomething. The printout at probe_return is
> also available via driver core.

Agreed.

> ...
>
>> +     /* Add the i2c adapter */
>> +     adap = &dev->adapter;
>> +     i2c_set_adapdata(adap, dev);
>> +     adap->owner = THIS_MODULE;
>> +     adap->class = UINT_MAX; /* can be used by any I2C device */
>
> Why do you need class based instantiation. It will most likely cost
> boot-time and you have devicetree means for doing instantiation.
>
>

Agreed.

>> +     strlcpy(adap->name, "Broadcom I2C adapter", sizeof(adap->name));
>> +     adap->algo = &bcm_algo;
>> +     adap->dev.parent = &pdev->dev;
>> +     adap->nr = pdev->id;
>> +     adap->dev.of_node = pdev->dev.of_node;
>> +
>> +     rc = i2c_add_numbered_adapter(adap);
>
> Maybe you want simply i2c_add_adapter here since the core has no
> built-in support for of aliases?
>

Okay.  I will switch to i2c_add_adapter and remove the adap->nr assignment.

>> +
>> +MODULE_AUTHOR("Broadcom");
>
> Some email address please.
>
>> +MODULE_DESCRIPTION("Broadcom Kona I2C Driver");
>> +MODULE_LICENSE("GPL v2");
>
> Thanks,
>
>    Wolfram
>
