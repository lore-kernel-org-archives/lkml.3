Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab3FXKhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:37:33 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:35479 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3FXKhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:37:31 -0400
Message-ID: <51C82169.1010203@free-electrons.com>
Date: Mon, 24 Jun 2013 12:37:29 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Shawn Guo <shawn.guo@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCHv2 1/3] iio: Add Nuvoton NAU7802 ADC driver
References: <1371754675-12242-1-git-send-email-alexandre.belloni@free-electrons.com> <1371754675-12242-2-git-send-email-alexandre.belloni@free-electrons.com> <51C7EA23.1040707@metafoo.de>
In-Reply-To: <51C7EA23.1040707@metafoo.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/2013 08:41, Lars-Peter Clausen wrote:
> On 06/20/2013 08:57 PM, Alexandre Belloni wrote:
>> The Nuvoton NAU7802 ADC is a 24-bit 2-channels I2C ADC, with adjustable
>> gain and sampling rates.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> ---
>>  .../bindings/iio/adc/nuvoton-nau7802.txt           |  17 +
>>  drivers/iio/adc/Kconfig                            |   9 +
>>  drivers/iio/adc/Makefile                           |   1 +
>>  drivers/iio/adc/nau7802.c                          | 603 +++++++++++++++++++++
>>  4 files changed, 630 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt
>>  create mode 100644 drivers/iio/adc/nau7802.c
>>
>> diff --git a/Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt b/Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt
>> new file mode 100644
>> index 0000000..9bc4218
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt
>> @@ -0,0 +1,17 @@
>> +* Nuvoton NAU7802 Analog to Digital Converter (ADC)use
>> +
>> +Required properties:
>> +  - compatible: Should be "nuvoton,nau7802"
>> +  - reg: Should contain the ADC I2C address
>> +
>> +Optional properties:
>> +  - nuvoton,vldo: Reference voltage in millivolts (integer)
>> +  - interrupts: IRQ line for the ADC. If not used the driver will use
>> +    polling.
>> +
>> +Example:
>> +adc2: nau7802@2a {
>> +	compatible = "nuvoton,nau7802";
>> +	reg = <0x2a>;
>> +	nuvoton,vldo = <3000>;
> We usually use the regulator framework for specifying the reference voltage.

I followed what Jonathan said in his review of my first patch. Do we
want to use the regulator framework to set the internal reference
voltage of the ADC ? I agree that if you supply an external voltage, it
will be necessary to use the regulator framework. Unfortunately, I can't
test that here.

>> +};
> [...]
>> diff --git a/drivers/iio/adc/nau7802.c b/drivers/iio/adc/nau7802.c
>> new file mode 100644
>> index 0000000..e1b6981
>> --- /dev/null
>> +++ b/drivers/iio/adc/nau7802.c
>> @@ -0,0 +1,603 @@
> [...]
>> +static int nau7802_set_gain(struct nau7802_state *st, int gain)
>> +{
>> +	u8 data;
>> +	int ret;
>> +
>> +	mutex_lock(&st->lock);
>> +	st->conversion_count = 0;
>> +
>> +	data = i2c_smbus_read_byte_data(st->client, NAU7802_REG_CTRL1);
>> +	if (data < 0)
>> +		goto nau7802_sysfs_set_gain_out;
> ret will be uninitialized if the goto above is taken

Right, bigger issue, data is u8 so it will never be negative. I'm fixing
that !


>> +	ret = i2c_smbus_write_byte_data(st->client, NAU7802_REG_CTRL1,
>> +					(data & (~NAU7802_CTRL1_GAINS_BITS)) |
>> +					gain);
>> +
>> +nau7802_sysfs_set_gain_out:
>> +	mutex_unlock(&st->lock);
>> +
>> +	return ret ? ret : 0;
>> +}
> [...]
>> +static int nau7802_read_irq(struct iio_dev *indio_dev,
>> +			struct iio_chan_spec const *chan,
>> +			int *val)
>> +{
>> +	struct nau7802_state *st = iio_priv(indio_dev);
>> +	int ret;
>> +
>> +	INIT_COMPLETION(st->value_ok);
>> +	enable_irq(st->client->irq);
> Is it really necessary to enable/disable the IRQ or could you keep it
> enabled all the time?

Fact is that the ADC doesn't really care if you are reading data or not
so you will probably endd up in a situation were you will get 320 IRQ
per second but not caring about the result. We have 3 ADCs on the board.
so that amounts to 960 IRQ per second when we are only reading like once
par second !


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

