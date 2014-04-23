Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbaDWRfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:35:14 -0400
Received: from smtpout4.laposte.net ([193.253.67.229]:24489 "EHLO
	smtpout.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaDWRfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:35:10 -0400
Date: Wed, 23 Apr 2014 19:35:02 +0200
From: Bastien Armand <armand.bastien@laposte.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Willy Tarreau <willy@meta-x.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] staging: panel: fix sparse warnings in lcd_write
Message-ID: <20140423173435.GB10879@plop.dartybox.com>
References: <20140418161057.GC1258@plop.dartybox.com>
 <20140422100144.GE26890@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422100144.GE26890@mwanda>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:01:45PM +0300, Dan Carpenter wrote:
> Out of curiosity, have you tested this patch?
> 
> On Fri, Apr 18, 2014 at 06:10:57PM +0200, Bastien Armand wrote:
> > This patch fixes two sparse warnings related to lcd_write :
> > warning: incorrect type in argument 1 (different address spaces)
> > warning: incorrect type in initializer (incompatible argument 2 
> > (different address spaces))
> > 
> > lcd_write can be used from kernel space (in panel_lcd_print) or from user
> > space. So we introduce the lcd_write_char function that will write a char to
> > the device. We modify lcd_write and panel_lcd_print to use it. Finally we add
> > __user annotation missing in lcd_write.
> > 
> > 
> > Signed-off-by: Bastien Armand <armand.bastien@laposte.net>
> > ---
> >  drivers/staging/panel/panel.c |  205 ++++++++++++++++++++++-------------------
> >  1 file changed, 109 insertions(+), 96 deletions(-)
> > 
> > diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> > index 1569e26..dc34254 100644
> > --- a/drivers/staging/panel/panel.c
> > +++ b/drivers/staging/panel/panel.c
> > @@ -1217,111 +1217,113 @@ static inline int handle_lcd_special_code(void)
> >  	return processed;
> >  }
> >  ...
> 
> This is buggy.  You are getting the first character over and over.  You
> should be doing:
> 
> 		if (get_user(c, tmp))
> 			return -EFAULT;
> 
Hi,

You're totally right. I am sorry to have missed that... As the patch has
been accepted in linux-next. I will send a correction right away.

> Btw, this whole function is terrible.  It should be reading larger
> chunks at once instead of get_user() for each character.
> 
> 

The aim of my patch was basically to add __user annotation. I tried to
keep the change minimal to lessen the risk of regression (it seems I have
failed here...). Perhaps, I can write an other patch to change that.

> > ...
> >  static void panel_lcd_print(const char *s)
> >  {
> > -	if (lcd_enabled && lcd_initialized)
> > -		lcd_write(NULL, s, strlen(s), NULL);
> > +	const char *tmp = s;
> > +	int count = strlen(s);
> > +
> > +	if (lcd_enabled && lcd_initialized) {
> > +		for (; count-- > 0; tmp++) {
> > +			if (!in_interrupt() && (((count + 1) & 0x1f) == 0))
> > +				/* let's be a little nice with other processes
> > +				   that need some CPU */
> > +				schedule();
> 
> This schedule() isn't needed.  It just prints a line or two at start up
> and some other debug output or something.  Small small.
> 

I hesitated to remove it. I leave it here as it was allready in lcd_write.
Perhaps, I could send another patch to remove it.

> regards,
> dan carpenter
> 

Thanks for your review. It was really appreciated.

Regards,
bastien armand

> > +
> > +			lcd_write_char(*tmp);
> > +		}
> > +	}
> >  }
> > 
> >  /* initialize the LCD driver */
> > --
> > 1.7.10.4
> > 
> > _______________________________________________
> > devel mailing list
> > devel@linuxdriverproject.org
> > http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
