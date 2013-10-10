Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3JJI52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:57:28 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:11348 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab3JJI50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:57:26 -0400
Message-ID: <52566BED.9010105@nsn.com>
Date: Thu, 10 Oct 2013 10:57:17 +0200
From: Ionut Nicu <ioan.nicu.ext@nsn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Peter Korsgaard <peter.korsgaard@barco.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-mux-gpio: test if the gpio can sleep
References: <525667C4.3080309@nsn.com> <52566971.5020700@metafoo.de>
In-Reply-To: <52566971.5020700@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1477
X-purgate-ID: 151667::1381395439-00004A43-714DC9AB/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.10.2013 10:46, ext Lars-Peter Clausen wrote:
> On 10/10/2013 10:39 AM, Ionut Nicu wrote:
>> Some gpio chips may have get/set operations that
>> can sleep. For this type of chips we must use the
>> _cansleep() version of gpio_set_value.
>>
>> Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
>> ---
>>  drivers/i2c/muxes/i2c-mux-gpio.c |   11 ++++++++---
>>  1 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
>> index a764da7..b5f17ef 100644
>> --- a/drivers/i2c/muxes/i2c-mux-gpio.c
>> +++ b/drivers/i2c/muxes/i2c-mux-gpio.c
>> @@ -27,11 +27,16 @@ struct gpiomux {
>>  
>>  static void i2c_mux_gpio_set(const struct gpiomux *mux, unsigned val)
>>  {
>> +	unsigned gpio;
>>  	int i;
>>  
>> -	for (i = 0; i < mux->data.n_gpios; i++)
>> -		gpio_set_value(mux->gpio_base + mux->data.gpios[i],
>> -			       val & (1 << i));
>> +	for (i = 0; i < mux->data.n_gpios; i++) {
>> +		gpio = mux->gpio_base + mux->data.gpios[i];
>> +		if (gpio_cansleep(gpio))
>> +			gpio_set_value_cansleep(gpio, val & (1 << i));
>> +		else
>> +			gpio_set_value(gpio, val & (1 << i));
> 
> The proper way to do this is just always use the _cansleep() version.
> gpio_set_value() only works for chips which do not sleep,
> gpio_set_value_cansleep() works for both those who do sleep and those who do
> not.
> 

Ok, then I will re-work the patch to do just that. Thanks!

