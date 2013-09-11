Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3IKHTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 03:19:55 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49824 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab3IKHTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 03:19:54 -0400
Date: Wed, 11 Sep 2013 08:19:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 26/38] iio: pressure-core: st: Clean-up probe() function
Message-ID: <20130911071950.GE11227@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-27-git-send-email-lee.jones@linaro.org>
 <02cccf68-fdc6-4ac3-a5d7-adfa10fa1c46@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <02cccf68-fdc6-4ac3-a5d7-adfa10fa1c46@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	err = st_sensors_init_sensor(indio_dev, plat_data);
> > 	if (err < 0)
> >-		goto st_press_common_probe_error;
> >+		return err;
> > 
> >-	if (pdata->get_irq_data_ready(indio_dev) > 0) {
> >+	if (irq > 0) {
> > 		err = st_press_allocate_ring(indio_dev);
> > 		if (err < 0)
> >-			goto st_press_common_probe_error;
> >+			return err;
> > 
> > 		err = st_sensors_allocate_trigger(indio_dev,
> >-							ST_PRESS_TRIGGER_OPS);
> >+						  ST_PRESS_TRIGGER_OPS);
> > 		if (err < 0)
> > 			goto st_press_probe_trigger_error;
> > 	}
> > 
> > 	err = iio_device_register(indio_dev);
> >-	if (err)
> 
> This bit of handling is confusing. I would much rather see the if IRQ at the goto. Here the first thought is why is it not an error if there is no IRQ! 

I certainly see your point. But surely anyone would see after a second
or two that we're returning err and not 0 in this case, so the error
would still be returned, we're not ignoring it. Adding this extra
comparison saves several lines of code.

If you think it's 'too' confusing, I'll revert the change.

Or perhaps a comment:

/* Only deallocate_[trigger|ring] if they were allocated. */
or
/* Only deallocate_[trigger|ring] if we have an IRQ line. */
or
/* If no IRQ was specified, just return the error. */

> >+	if (err && irq > 0)
> > 		goto st_press_device_register_error;
> > 
> > 	return err;
> > 
> > st_press_device_register_error:
> >-	if (pdata->get_irq_data_ready(indio_dev) > 0)
> >-		st_sensors_deallocate_trigger(indio_dev);
> >+	st_sensors_deallocate_trigger(indio_dev);
> > st_press_probe_trigger_error:
> >-	if (pdata->get_irq_data_ready(indio_dev) > 0)
> >-		st_press_deallocate_ring(indio_dev);
> >-st_press_common_probe_error:
> >+	st_press_deallocate_ring(indio_dev);
> >+
> > 	return err;
> > }
> > EXPORT_SYMBOL(st_press_common_probe);
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
