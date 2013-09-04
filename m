Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762996Ab3IDQV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:21:29 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39417 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab3IDQV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:21:27 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1378287103-21765-5-git-send-email-lee.jones@linaro.org>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org> <1378287103-21765-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 04/11] iio: pressure-i2c: st: Simplify error checking in probe()
From: Jonathan Cameron <jic23@kernel.org>
Date: Wed, 04 Sep 2013 17:21:07 +0100
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk
CC: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Message-ID: <19108ebc-3e17-4b85-a82c-c55132443a6f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee. This won't apply as this driver has already been cleaned up using devm_iio_device_alloc.

Guessing you are basing on an old tree? 
Always use at least staging-next for IIO patches.

I think this one will hit mainline in next few days.

Jonathan

Lee Jones <lee.jones@linaro.org> wrote:
>Strip out all the unnecessary gotos and check for NULL returns in the
>usual manner.
>
>Signed-off-by: Lee Jones <lee.jones@linaro.org>
>---
> drivers/iio/pressure/st_pressure_i2c.c | 17 ++++++-----------
> 1 file changed, 6 insertions(+), 11 deletions(-)
>
>diff --git a/drivers/iio/pressure/st_pressure_i2c.c
>b/drivers/iio/pressure/st_pressure_i2c.c
>index 7cebcc7..2ace770 100644
>--- a/drivers/iio/pressure/st_pressure_i2c.c
>+++ b/drivers/iio/pressure/st_pressure_i2c.c
>@@ -26,10 +26,8 @@ static int st_press_i2c_probe(struct i2c_client
>*client,
> 	int err;
> 
> 	indio_dev = iio_device_alloc(sizeof(*pdata));
>-	if (indio_dev == NULL) {
>-		err = -ENOMEM;
>-		goto iio_device_alloc_error;
>-	}
>+	if (!indio_dev)
>+		return -ENOMEM;
> 
> 	pdata = iio_priv(indio_dev);
> 	pdata->dev = &client->dev;
>@@ -37,15 +35,12 @@ static int st_press_i2c_probe(struct i2c_client
>*client,
> 	st_sensors_i2c_configure(indio_dev, client, pdata);
> 
> 	err = st_press_common_probe(indio_dev);
>-	if (err < 0)
>-		goto st_press_common_probe_error;
>+	if (err < 0) {
>+		iio_device_free(indio_dev);
>+		return err;
>+	}
> 
> 	return 0;
>-
>-st_press_common_probe_error:
>-	iio_device_free(indio_dev);
>-iio_device_alloc_error:
>-	return err;
> }
> 
> static int st_press_i2c_remove(struct i2c_client *client)

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
