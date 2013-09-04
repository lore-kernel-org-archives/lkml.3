Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666Ab3IDN0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 09:26:46 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:46542 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762611Ab3IDN0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:26:44 -0400
Date: Wed, 4 Sep 2013 14:26:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Rutland <mark.rutland@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        broonie@kernel.org, "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 11/11] iio: pressure-core: st: Provide correct regulator
 support
Message-ID: <20130904132638.GG20150@lee--X1>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-12-git-send-email-lee.jones@linaro.org>
 <20130904131111.GJ18206@e106331-lin.cambridge.arm.com>
 <5227331A.5050507@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5227331A.5050507@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Sep 2013, Lars-Peter Clausen wrote:

> On 09/04/2013 03:11 PM, Mark Rutland wrote:
> > Hi Lee,
> > 
> > On Wed, Sep 04, 2013 at 10:31:43AM +0100, Lee Jones wrote:
> >> The power to some of the sensors are controlled by regulators. In most
> >> cases these are 'always on', but if not they will fail to work until
> >> the regulator is enabled using the relevant APIs.
> >>
> >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >> ---
> >>  drivers/iio/pressure/st_pressure_core.c | 13 +++++++++++++
> >>  include/linux/iio/common/st_sensors.h   |  3 +++
> >>  2 files changed, 16 insertions(+)
> >>
> >> diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
> >> index f452417..7beed89 100644
> >> --- a/drivers/iio/pressure/st_pressure_core.c
> >> +++ b/drivers/iio/pressure/st_pressure_core.c
> >> @@ -23,6 +23,7 @@
> >>  #include <linux/iio/sysfs.h>
> >>  #include <linux/iio/trigger.h>
> >>  #include <linux/iio/buffer.h>
> >> +#include <linux/regulator/consumer.h>
> >>  #include <asm/unaligned.h>
> >>  
> >>  #include <linux/iio/common/st_sensors.h>
> >> @@ -315,6 +316,15 @@ int st_press_common_probe(struct iio_dev *indio_dev)
> >>  	indio_dev->modes = INDIO_DIRECT_MODE;
> >>  	indio_dev->info = &press_info;
> >>  
> >> +	/* Regulator not mandatory, but if requested we should enable it. */
> >> +	pdata->regulator = regulator_get(&indio_dev->dev, "vdd");
> >> +	if (!IS_ERR_OR_NULL(pdata->regulator)) {
> > 
> > Can regulator_get return NULL? As far as I can see, it either returns a
> > valid reulator pointer or an ERR_PTR value.
> > 
> > When you say "if requested", do you mean "if described in the dt"? If
> > so, the above doesn't distunguish between a regulator not being listed
> > and one failing to be got (e.g. if we got EPROBE_DEFER from
> > regulator_get).
> > 
> > I think this would be better handled with something like Mark Brown's
> > suggested regulator_get_optional [1,2].

Thanks Mark, I didn't know that existed.

> It can return NULL, but NULL is actually a valid regulator in that case, so
> the check should only be IS_ERR. And yes regulator_get_optional is what
> should be used here.

Okay, I'll use that instead.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
