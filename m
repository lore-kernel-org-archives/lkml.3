Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762600Ab3IDNQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 09:16:47 -0400
Received: from smtp-out-004.synserver.de ([212.40.185.4]:1189 "EHLO
	smtp-out-003.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754283Ab3IDNQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:16:45 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 21105
Message-ID: <5227331A.5050507@metafoo.de>
Date: Wed, 04 Sep 2013 15:18:18 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "arnd@arndb.de" <arnd@arndb.de>, broonie@kernel.org
Subject: Re: [PATCH 11/11] iio: pressure-core: st: Provide correct regulator
 support
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org> <1378287103-21765-12-git-send-email-lee.jones@linaro.org> <20130904131111.GJ18206@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130904131111.GJ18206@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 03:11 PM, Mark Rutland wrote:
> Hi Lee,
> 
> On Wed, Sep 04, 2013 at 10:31:43AM +0100, Lee Jones wrote:
>> The power to some of the sensors are controlled by regulators. In most
>> cases these are 'always on', but if not they will fail to work until
>> the regulator is enabled using the relevant APIs.
>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> ---
>>  drivers/iio/pressure/st_pressure_core.c | 13 +++++++++++++
>>  include/linux/iio/common/st_sensors.h   |  3 +++
>>  2 files changed, 16 insertions(+)
>>
>> diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
>> index f452417..7beed89 100644
>> --- a/drivers/iio/pressure/st_pressure_core.c
>> +++ b/drivers/iio/pressure/st_pressure_core.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/iio/sysfs.h>
>>  #include <linux/iio/trigger.h>
>>  #include <linux/iio/buffer.h>
>> +#include <linux/regulator/consumer.h>
>>  #include <asm/unaligned.h>
>>  
>>  #include <linux/iio/common/st_sensors.h>
>> @@ -315,6 +316,15 @@ int st_press_common_probe(struct iio_dev *indio_dev)
>>  	indio_dev->modes = INDIO_DIRECT_MODE;
>>  	indio_dev->info = &press_info;
>>  
>> +	/* Regulator not mandatory, but if requested we should enable it. */
>> +	pdata->regulator = regulator_get(&indio_dev->dev, "vdd");
>> +	if (!IS_ERR_OR_NULL(pdata->regulator)) {
> 
> Can regulator_get return NULL? As far as I can see, it either returns a
> valid reulator pointer or an ERR_PTR value.
> 
> When you say "if requested", do you mean "if described in the dt"? If
> so, the above doesn't distunguish between a regulator not being listed
> and one failing to be got (e.g. if we got EPROBE_DEFER from
> regulator_get).
> 
> I think this would be better handled with something like Mark Brown's
> suggested regulator_get_optional [1,2].

It can return NULL, but NULL is actually a valid regulator in that case, so
the check should only be IS_ERR. And yes regulator_get_optional is what
should be used here.

- Lars
