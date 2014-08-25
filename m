Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaHYQyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:54:36 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33534 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaHYQye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:54:34 -0400
Date: Mon, 25 Aug 2014 09:54:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jonathan Cameron <jic23@kernel.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Adam.Thomson.Opensource@diasemi.com,
        knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: core: Propagate error codes from OF layer to client
 drivers
Message-ID: <20140825165430.GB14614@roeck-us.net>
References: <1408971437-10751-1-git-send-email-iivanov@mm-sol.com>
 <53FB5FF7.8020504@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FB5FF7.8020504@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 05:10:31PM +0100, Jonathan Cameron wrote:
> On 25/08/14 13:57, Ivan T. Ivanov wrote:
> > Do not overwrite error codes returned from of_iio_channel_get().
> > Error codes are used to distinguish between "io-channel-names"
> > not present in DT bindings, property is optional, and IIO channel
> > provider driver still not being loaded, defer probe.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Cc'd Guenter who often takes an interest in this code (and wrote it ;)
> 
> Mostly seems logical to me, though I don't like the change of
> priority in the last bit.  I've also just taken a fix for this
> code so there may be some fuzz from that once it's propogated
> through to mainline and back to the togreg tree of iio.git
> 
> Thanks,
> 
> Jonathan
> > ---
> >  drivers/iio/inkern.c | 24 ++++++++++++------------
> >  1 file changed, 12 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> > index c749700..66a6cde 100644
> > --- a/drivers/iio/inkern.c
> > +++ b/drivers/iio/inkern.c
> > @@ -162,7 +162,7 @@ err_free_channel:
> >  static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
> >  						      const char *name)
> >  {
> > -	struct iio_channel *chan = NULL;
> > +	struct iio_channel *chan = ERR_PTR(-ENODEV);
> >  
> >  	/* Walk up the tree of devices looking for a matching iio channel */
> >  	while (np) {
> > @@ -183,7 +183,7 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
> >  		else if (name && index >= 0) {
> >  			pr_err("ERROR: could not get IIO channel %s:%s(%i)\n",
> >  				np->full_name, name ? name : "", index);
> > -			return NULL;
> > +			break;
> >  		}
> >  
> >  		/*
> > @@ -193,7 +193,7 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
> >  		 */
> >  		np = np->parent;
> >  		if (np && !of_get_property(np, "io-channel-ranges", NULL))
> > -			return NULL;
> > +			break;
> >  	}
> >  
> >  	return chan;
> > @@ -243,12 +243,12 @@ error_free_chans:
> >  static inline struct iio_channel *
> >  of_iio_channel_get_by_name(struct device_node *np, const char *name)
> >  {
> > -	return NULL;
> > +	return ERR_PTR(-ENODEV);
> >  }
> >  
> >  static inline struct iio_channel *of_iio_channel_get_all(struct device *dev)
> >  {
> > -	return NULL;
> > +	return ERR_PTR(-ENODEV);
> >  }
> >  
> >  #endif /* CONFIG_OF */
> > @@ -312,14 +312,14 @@ struct iio_channel *iio_channel_get(struct device *dev,
> >  	const char *name = dev ? dev_name(dev) : NULL;
> >  	struct iio_channel *channel;
> >  
> > -	if (dev) {
> > -		channel = of_iio_channel_get_by_name(dev->of_node,
> > -						     channel_name);
> > -		if (channel != NULL)
> > -			return channel;
> > -	}
> > +	channel = iio_channel_get_sys(name, channel_name);
> > +	if (!IS_ERR(channel))
> > +		return channel;
> > +
> > +	if (!dev)
> > +		return channel;
> >  
> > -	return iio_channel_get_sys(name, channel_name);
> > +	return of_iio_channel_get_by_name(dev->of_node, channel_name);
> >  }
> Why reorder the logic?   This makes this patch less obviously
> correct for limited obvious gain?
> 
> Previously the priority was clearly given to device tree bindings
> wherease now it is given to board file provided map elements.  It
> would be interesting to see boards with both provided, but it is
> possible.

I am not entirely sure I understand what problem this patch is supposed
to fix on top of the patch you just applied, and I am also a bit concerned
about reversing the logic. Also, iio_channel_get_sys can return -ENOMEM
and -EINVAL besides -ENODEV, all of which is now being ignored unless dev is
set, and then it is returned unconditionally. So instead of ignoring error
codes from of_iio_channel_get_by_name, the code now ignores error codes
from iio_channel_get_sys under some circumstances (which, coincidentially,
does not return -EPROBE_DEFER), and in other circumstances may return an error
even if devicetree data exists. Why and how is that better than before ?
Seems to me it just introduces a whole number of new failure conditions.

Guenter
