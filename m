Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3IPIWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:22:24 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:64507 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab3IPIWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:22:22 -0400
Date: Mon, 16 Sep 2013 09:22:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 21/38] iio: sensors-core: st: Clean-up error handling in
 st_sensors_read_axis_data()
Message-ID: <20130916082217.GE3999@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-22-git-send-email-lee.jones@linaro.org>
 <523495D0.1050002@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <523495D0.1050002@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Sep 2013, Jonathan Cameron wrote:

> On 09/10/13 13:49, Lee Jones wrote:
> > Gets rid of those unnecessary gotos.
> 
> Unfortunately it introduced a bug whilst it is at it.  Sometimes
> those gotos are necessary and the 'right' way to do things.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/iio/common/st_sensors/st_sensors_core.c | 17 +++++++----------
> >  1 file changed, 7 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
> > index 8c4c54c..148f0e5 100644
> > --- a/drivers/iio/common/st_sensors/st_sensors_core.c
> > +++ b/drivers/iio/common/st_sensors/st_sensors_core.c
> > @@ -331,26 +331,23 @@ static int st_sensors_read_axis_data(struct iio_dev *indio_dev,
> >  	unsigned int byte_for_channel = ch->scan_type.storagebits >> 3;
> >  
> >  	outdata = kmalloc(byte_for_channel, GFP_KERNEL);
> > -	if (!outdata) {
> > -		err = -EINVAL;
> > -		goto st_sensors_read_axis_data_error;
> > -	}
> > +	if (!outdata)
> > +		return -ENOMEM;
> I agree this change makes complete sense.
> >  
> >  	err = sdata->tf->read_multiple_byte(&sdata->tb, sdata->dev,
> >  				ch->address, byte_for_channel,
> >  				outdata, sdata->multiread_bit);
> > -	if (err < 0)
> > -		goto st_sensors_free_memory;
> > +	if (err < 0) {
> > +		kfree(outdata);
> > +		return err;
> > +	}
> I don't like this change as....
> >  
> >  	if (byte_for_channel == 2)
> >  		*data = (s16)get_unaligned_le16(outdata);
> >  	else if (byte_for_channel == 3)
> >  		*data = (s32)st_sensors_get_unaligned_le24(outdata);
> >  
> > -st_sensors_free_memory:
> > -	kfree(outdata);
> you now don't free out data in the case of no error.  This is precisely the case
> where a goto is the correct way to handle things as the free need to occur whether
> or not the error occurs.

Ah, you're quite right. I'll fix up.

> > -st_sensors_read_axis_data_error:
> > -	return err;
> > +	return 0;
> >  }
> >  
> >  int st_sensors_read_info_raw(struct iio_dev *indio_dev,
> > 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
