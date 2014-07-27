Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaG0SpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 14:45:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaG0SpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 14:45:13 -0400
Date: Sun, 27 Jul 2014 11:45:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] staging: comedi: amplc_dio200_common: prevent extra
 free_irq()
Message-ID: <20140727184513.GB29496@kroah.com>
References: <1406308029-15712-1-git-send-email-abbotti@mev.co.uk>
 <1406308029-15712-2-git-send-email-abbotti@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D8825F1E378@P3PWEX4MB008.ex4.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825F1E378@P3PWEX4MB008.ex4.secureserver.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 06:23:10PM +0000, Hartley Sweeten wrote:
> On Friday, July 25, 2014 10:07 AM, Ian Abbott wrote:
> > `dio200_detach()` in "amplc_dio200.c" calls
> > `amplc_dio200_common_detach()` in "amplc_dio200_common.c", followed by
> > `comedi_legacy_detach()` in "../drivers.c".  Both of those functions
> > call `free_irq()` if `dev->irq` is non-zero.  The second call produces a
> > warning message because the handler has already been freed.  Prevent
> > that by setting `dev->irq = 0` in `amplc_dio200_common_detach()`.
> >
> > Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> > ---
> >  drivers/staging/comedi/drivers/amplc_dio200_common.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/comedi/drivers/amplc_dio200_common.c b/drivers/staging/comedi/drivers/amplc_dio200_common.c
> > index 78700e8..3592e58 100644
> > --- a/drivers/staging/comedi/drivers/amplc_dio200_common.c
> > +++ b/drivers/staging/comedi/drivers/amplc_dio200_common.c
> > @@ -1202,8 +1202,10 @@ void amplc_dio200_common_detach(struct comedi_device *dev)
> >  
> >  	if (!thisboard || !devpriv)
> >  		return;
> > -	if (dev->irq)
> > +	if (dev->irq) {
> >  		free_irq(dev->irq, dev);
> > +		dev->irq = 0;
> > +	}
> >  }
> >  EXPORT_SYMBOL_GPL(amplc_dio200_common_detach);
>  
> Ian,
> 
> I have already gave a Reviewed-by signoff for this series.
> 
> After looking over the code I think a cleaner solution would be to:
> 
> 1) Use comedi_legacy_detach() directly for the (*detach) in the
>    legacy ISA driver.
> 2) Move the code from amplc_dio200_common_detach() into the
>    (*detach) function for the PCI driver.
> 3) Remove the exported function amplc_dio200_common_detach().

So should I not apply these patches?

confused,

greg k-h
