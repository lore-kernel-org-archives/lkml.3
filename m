Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3IROPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:15:40 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54627 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3IROPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:15:38 -0400
Date: Wed, 18 Sep 2013 07:15:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130918141533.GA16424@core.coreip.homeip.net>
References: <1379393047-11772-1-git-send-email-zubair.lutfullah@gmail.com>
 <1379393047-11772-3-git-send-email-zubair.lutfullah@gmail.com>
 <20130918042726.GB13196@core.coreip.homeip.net>
 <20130918065406.GA13451@gmail.com>
 <53771776-0d33-436d-9687-995ed0d6345d@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53771776-0d33-436d-9687-995ed0d6345d@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 10:39:42AM +0100, Jonathan Cameron wrote:
> 
> 
> "Zubair Lutfullah :" <zubair.lutfullah@gmail.com> wrote:
> >On Tue, Sep 17, 2013 at 09:27:27PM -0700, Dmitry Torokhov wrote:
> >> Hi Zubair,
> >> 
> >> On Tue, Sep 17, 2013 at 09:44:07AM +0500, Zubair Lutfullah wrote:
> >> > +
> >> > +	ret = devm_request_threaded_irq(indio_dev->dev.parent,
> >> > +				irq,
> >> > +				pollfunc_th, pollfunc_bh,
> >> > +				flags, indio_dev->name,
> >> > +				indio_dev);
> >> > +	if (ret)
> >> > +		goto error_kfifo_free;
> >> > +
> >> > +	indio_dev->setup_ops = setup_ops;
> >> > +	indio_dev->modes |= INDIO_BUFFER_HARDWARE;
> >> > +
> >> > +	ret = iio_buffer_register(indio_dev,
> >> > +				  indio_dev->channels,
> >> > +				  indio_dev->num_channels);
> >> > +	if (ret)
> >> > +		goto error_free_irq;
> >> > +
> >> > +	return 0;
> >> > +
> >> > +error_free_irq:
> >> > +	devm_free_irq(indio_dev->dev.parent, irq, indio_dev);
> >> 
> >> What is the point of using devm_* here if you are doing explicit
> >> management of the resource anyway (you explicitly release it in all
> >code
> >> paths)?
> >> 
> >> Thanks.
> >> 
> >> -- 
> >> Dmitry
> >
> >I admit I am unaware at the moment about how it works.
> >
> >I use devm and simply ignore the error path?
> >
> >The devm function header description said something about using
> >devm_free when freeing. And this is the way I am used to seeing 
> >error handling.
> 

> The devm interfaces ensure this is all cleaned when the device is
> removed thus avoiding the need to free the stuff explicitly.  Device
> will get freed on deliberate remove and on an error from probe. Hence
> you can drop all calls to devm free. The devm free functions are only
> needed if you wish to free in order to reallocate. This might happen
> if you want to change a buffer size for instance.

However in this case such conversion us dangerous. With all but IRQ
resource managed by the traditional methods they will be released first
with IRQ handler deregistered very last. Therefore if device is not
properly quiesced IRQ raised during driver unbinding is likely to result
in kernel oops.

IOW devm_request_irq() is very often evil (it is still useful if _all_
your resources are managed by devm_*).

In case of your driver I'd recommend switching to
request_irq()/free_irq() instead.

Thanks.

-- 
Dmitry
