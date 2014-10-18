Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaJRRN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 13:13:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:5868 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaJRRNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 13:13:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,745,1406617200"; 
   d="scan'208";a="607504833"
Message-ID: <1413652382.2899.0.camel@spandruv-hsb-test>
Subject: Re: [PATCH] iio: inkern: Add of_xlate function to struct iio_dev
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        John Stultz <john.stultz@linaro.org>, linux-iio@vger.kernel.org,
        svarbanov@mm-sol.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Sat, 18 Oct 2014 10:13:02 -0700
In-Reply-To: <5442522D.40203@kernel.org>
References: <1412253128-32165-1-git-send-email-iivanov@mm-sol.com>
	 <5442522D.40203@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-18 at 12:42 +0100, Jonathan Cameron wrote:
> On 02/10/14 13:32, Ivan T. Ivanov wrote:
> > When #iio-cells is greater than '0', the driver could provide
> > a custom of_xlate function that reads the *args* and returns
> > the appropriate index in registered IIO channels array.
> > 
> > Add simple translation function, suitable for the most 1:1
> > mapped channels in IIO chips, and use it when driver did not
> > provide custom implementation.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Any more comments on this?  Been sat a while and the discussions seems
> to have died out.
> 
> As Ivan has pointed out, very similar approaches are used
> elsewhere (gpio for example).
Looks useful to me.
Thanks,
Srinivas
> 
> > ---
> >  drivers/iio/inkern.c    | 32 +++++++++++++++++++++++++++-----
> >  include/linux/iio/iio.h |  8 ++++++++
> >  2 files changed, 35 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> > index f084610..6c3e478 100644
> > --- a/drivers/iio/inkern.c
> > +++ b/drivers/iio/inkern.c
> > @@ -100,6 +100,28 @@ static int iio_dev_node_match(struct device *dev, void *data)
> >  	return dev->of_node == data && dev->type == &iio_device_type;
> >  }
> >  
> > +/**
> > + * __of_iio_simple_xlate - translate iiospec to the IIO channel index
> > + * @indio_dev:	pointer to the iio_dev structure
> > + * @iiospec:	IIO specifier as found in the device tree
> > + *
> > + * This is simple translation function, suitable for the most 1:1 mapped
> > + * channels in IIO chips. This function performs only one sanity check:
> > + * whether IIO index is less than num_channels (that is specified in the
> > + * iio_dev).
> > + */
> > +static int __of_iio_simple_xlate(struct iio_dev *indio_dev,
> > +				const struct of_phandle_args *iiospec)
> > +{
> > +	if (!iiospec->args_count)
> > +		return 0;
> > +
> > +	if (iiospec->args[0] >= indio_dev->num_channels)
> > +		return -EINVAL;
> > +
> > +	return iiospec->args[0];
> > +}
> > +
> >  static int __of_iio_channel_get(struct iio_channel *channel,
> >  				struct device_node *np, int index)
> >  {
> > @@ -122,18 +144,18 @@ static int __of_iio_channel_get(struct iio_channel *channel,
> >  
> >  	indio_dev = dev_to_iio_dev(idev);
> >  	channel->indio_dev = indio_dev;
> > -	index = iiospec.args_count ? iiospec.args[0] : 0;
> > -	if (index >= indio_dev->num_channels) {
> > -		err = -EINVAL;
> > +	if (!indio_dev->of_xlate)
> > +		indio_dev->of_xlate = __of_iio_simple_xlate;
> > +	index = indio_dev->of_xlate(indio_dev, &iiospec);
> > +	if (index < 0)
> >  		goto err_put;
> > -	}
> >  	channel->channel = &indio_dev->channels[index];
> >  
> >  	return 0;
> >  
> >  err_put:
> >  	iio_device_put(indio_dev);
> > -	return err;
> > +	return index;
> >  }
> >  
> >  static struct iio_channel *of_iio_channel_get(struct device_node *np, int index)
> > diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
> > index 15dc6bc..d5bb219 100644
> > --- a/include/linux/iio/iio.h
> > +++ b/include/linux/iio/iio.h
> > @@ -13,6 +13,7 @@
> >  #include <linux/device.h>
> >  #include <linux/cdev.h>
> >  #include <linux/iio/types.h>
> > +#include <linux/of.h>
> >  /* IIO TODO LIST */
> >  /*
> >   * Provide means of adjusting timer accuracy.
> > @@ -413,6 +414,11 @@ struct iio_buffer_setup_ops {
> >   * @currentmode:	[DRIVER] current operating mode
> >   * @dev:		[DRIVER] device structure, should be assigned a parent
> >   *			and owner
> > + * @of_xlate:		[DRIVER] function pointer to obtain channel specifier
> > + *			index. When #iio-cells is greater than '0', the driver
> > + *			could provide a custom of_xlate function that reads
> > + *			the *args* and returns the appropriate index in
> > + *			registered IIO channels array.
> >   * @event_interface:	[INTERN] event chrdevs associated with interrupt lines
> >   * @buffer:		[DRIVER] any buffer present
> >   * @buffer_list:	[INTERN] list of all buffers currently attached
> > @@ -451,6 +457,8 @@ struct iio_dev {
> >  	int				currentmode;
> >  	struct device			dev;
> >  
> > +	int (*of_xlate)(struct iio_dev *indio_dev,
> > +			const struct of_phandle_args *iiospec);
> >  	struct iio_event_interface	*event_interface;
> >  
> >  	struct iio_buffer		*buffer;
> > 


