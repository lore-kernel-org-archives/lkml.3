Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874Ab3IDQai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:30:38 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:39775 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934905Ab3IDQag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:30:36 -0400
Date: Wed, 4 Sep 2013 17:30:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 04/11] iio: pressure-i2c: st: Simplify error checking in
 probe()
Message-ID: <20130904163031.GB8980@lee--X1>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-5-git-send-email-lee.jones@linaro.org>
 <19108ebc-3e17-4b85-a82c-c55132443a6f@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19108ebc-3e17-4b85-a82c-c55132443a6f@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Lee. This won't apply as this driver has already been cleaned up using devm_iio_device_alloc.
> 
> Guessing you are basing on an old tree? 
> Always use at least staging-next for IIO patches.

Sure, I'll rebase and resubmit the set once all the other creases have
been ironed out.

> I think this one will hit mainline in next few days.

Okay, great.

> Lee Jones <lee.jones@linaro.org> wrote:
> >Strip out all the unnecessary gotos and check for NULL returns in the
> >usual manner.
> >
> >Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >---
> > drivers/iio/pressure/st_pressure_i2c.c | 17 ++++++-----------
> > 1 file changed, 6 insertions(+), 11 deletions(-)
> >
> >diff --git a/drivers/iio/pressure/st_pressure_i2c.c
> >b/drivers/iio/pressure/st_pressure_i2c.c
> >index 7cebcc7..2ace770 100644
> >--- a/drivers/iio/pressure/st_pressure_i2c.c
> >+++ b/drivers/iio/pressure/st_pressure_i2c.c
> >@@ -26,10 +26,8 @@ static int st_press_i2c_probe(struct i2c_client
> >*client,
> > 	int err;
> > 
> > 	indio_dev = iio_device_alloc(sizeof(*pdata));
> >-	if (indio_dev == NULL) {
> >-		err = -ENOMEM;
> >-		goto iio_device_alloc_error;
> >-	}
> >+	if (!indio_dev)
> >+		return -ENOMEM;
> > 
> > 	pdata = iio_priv(indio_dev);
> > 	pdata->dev = &client->dev;
> >@@ -37,15 +35,12 @@ static int st_press_i2c_probe(struct i2c_client
> >*client,
> > 	st_sensors_i2c_configure(indio_dev, client, pdata);
> > 
> > 	err = st_press_common_probe(indio_dev);
> >-	if (err < 0)
> >-		goto st_press_common_probe_error;
> >+	if (err < 0) {
> >+		iio_device_free(indio_dev);
> >+		return err;
> >+	}
> > 
> > 	return 0;
> >-
> >-st_press_common_probe_error:
> >-	iio_device_free(indio_dev);
> >-iio_device_alloc_error:
> >-	return err;
> > }
> > 
> > static int st_press_i2c_remove(struct i2c_client *client)
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
