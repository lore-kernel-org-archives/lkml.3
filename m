Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964886Ab3IDQcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:32:54 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39573 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935280Ab3IDQcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:32:42 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1378287103-21765-10-git-send-email-lee.jones@linaro.org>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org> <1378287103-21765-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 09/11] iio: pressure-core: st: Clean-up error handling in probe function
From: Jonathan Cameron <jic23@kernel.org>
Date: Wed, 04 Sep 2013 17:32:27 +0100
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk
CC: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Message-ID: <7a1e763c-8f12-4ec8-9355-425ad4334573@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Lee Jones <lee.jones@linaro.org> wrote:
>This patch contains some pretty basic clean-ups in probe() pertaining
>to
>the simplification of error handling and a couple of readability
>adaptions.
>
>Signed-off-by: Lee Jones <lee.jones@linaro.org>

Hi Lee

Most of this series look fine but I am not that keen on some of this one.

The white space changes are definitely a matter of taste and honestly I don't care either way.

The returns are fine when there is no cleanup to do.

GOTOs and a clean unwind of the function is to my eye easier to review than unwinding directly after each error.

If reviewing original driver I would probably not bother commenting but for a cleanup patch the cleanup wants to be a clear improvement!  

Out of time now so will have to get to the rest of the series sometime soon.  

>---
>drivers/iio/pressure/st_pressure_core.c | 41
>+++++++++++++++------------------
> 1 file changed, 19 insertions(+), 22 deletions(-)
>
>diff --git a/drivers/iio/pressure/st_pressure_core.c
>b/drivers/iio/pressure/st_pressure_core.c
>index 3cf54ed..2893d08 100644
>--- a/drivers/iio/pressure/st_pressure_core.c
>+++ b/drivers/iio/pressure/st_pressure_core.c
>@@ -224,21 +224,23 @@ static const struct iio_trigger_ops
>st_press_trigger_ops = {
> 
> int st_press_common_probe(struct iio_dev *indio_dev)
> {
>-	int err;
> 	struct st_sensor_data *pdata = iio_priv(indio_dev);
>+	int irq = pdata->get_irq_data_ready(indio_dev);
>+	int err;
> 
> 	indio_dev->modes = INDIO_DIRECT_MODE;
> 	indio_dev->info = &press_info;
> 
> 	err = st_sensors_check_device_support(indio_dev,
>-				ARRAY_SIZE(st_press_sensors), st_press_sensors);
>+					      ARRAY_SIZE(st_press_sensors),
>+					      st_press_sensors);
> 	if (err < 0)
>-		goto st_press_common_probe_error;
>+		return err;
> 
> 	pdata->num_data_channels = ST_PRESS_NUMBER_DATA_CHANNELS;
>-	pdata->multiread_bit = pdata->sensor->multi_read_bit;
>-	indio_dev->channels = pdata->sensor->ch;
>-	indio_dev->num_channels = pdata->sensor->num_ch;
>+	pdata->multiread_bit     = pdata->sensor->multi_read_bit;
>+	indio_dev->channels      = pdata->sensor->ch;
>+	indio_dev->num_channels  = pdata->sensor->num_ch;
> 
> 	if (pdata->sensor->fs.addr != 0)
> 		pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
>@@ -248,32 +250,27 @@ int st_press_common_probe(struct iio_dev
>*indio_dev)
> 
> 	err = st_sensors_init_sensor(indio_dev);
> 	if (err < 0)
>-		goto st_press_common_probe_error;
>+		return err;
> 
>-	if (pdata->get_irq_data_ready(indio_dev) > 0) {
>+	if (irq > 0) {
> 		err = st_press_allocate_ring(indio_dev);
> 		if (err < 0)
>-			goto st_press_common_probe_error;
>+			return err;
> 
> 		err = st_sensors_allocate_trigger(indio_dev,
>-							ST_PRESS_TRIGGER_OPS);
>-		if (err < 0)
>-			goto st_press_probe_trigger_error;
>+						  ST_PRESS_TRIGGER_OPS);
>+		if (err < 0) {
>+			st_press_deallocate_ring(indio_dev);
>+			return err;
>+		}
> 	}
> 
> 	err = iio_device_register(indio_dev);
>-	if (err)
>-		goto st_press_device_register_error;
>-
>-	return err;
>-
>-st_press_device_register_error:
>-	if (pdata->get_irq_data_ready(indio_dev) > 0)
>+	if (err && irq > 0) {
> 		st_sensors_deallocate_trigger(indio_dev);
>-st_press_probe_trigger_error:
>-	if (pdata->get_irq_data_ready(indio_dev) > 0)
> 		st_press_deallocate_ring(indio_dev);
>-st_press_common_probe_error:
>+	}
>+
> 	return err;
> }
> EXPORT_SYMBOL(st_press_common_probe);

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
