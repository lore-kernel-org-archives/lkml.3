Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbaGNO4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:56:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbaGNO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:56:04 -0400
Date: Mon, 14 Jul 2014 07:55:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCHv2 5/6] base: platform: name the device already during
 allocation
Message-ID: <20140714145543.GB11477@kroah.com>
References: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1401972778-5880-6-git-send-email-heikki.krogerus@linux.intel.com>
 <53C3767A.9000203@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C3767A.9000203@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 11:49:38AM +0530, Kishon Vijay Abraham I wrote:
> Greg,
> 
> On Thursday 05 June 2014 06:22 PM, Heikki Krogerus wrote:
> > This allows resources such as GPIOs and clocks, which can be
> > matched based on the device name when requested, to be
> > assigned even when PLATFORM_DEVID_AUTO is used.
> 
> Any comments on this patch?

I thought I rejected it in the past, don't have my email archives
around at the moment, sorry.


> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/base/platform.c | 77 ++++++++++++++++++++++++++++++-------------------
> >  1 file changed, 47 insertions(+), 30 deletions(-)
> > 
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 9e9227e..e856bc4 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -177,11 +177,45 @@ struct platform_object {
> >   */
> >  void platform_device_put(struct platform_device *pdev)
> >  {
> > -	if (pdev)
> > -		put_device(&pdev->dev);
> > +	if (!pdev)
> > +		return;
> > +
> > +	if (pdev->id_auto) {
> > +		ida_simple_remove(&platform_devid_ida, pdev->id);
> > +		pdev->id = PLATFORM_DEVID_AUTO;
> > +	}
> > +
> > +	put_device(&pdev->dev);
> >  }
> >  EXPORT_SYMBOL_GPL(platform_device_put);

Why would a single call to this function remove an id?  That seems
really wrong, you should be able to call get and put on a device
numerous times, only the "last" reference should cause the device to be
cleaned up.

Shouldn't this be in the release function instead?

thanks,

greg k-h
