Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbaHHNr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:47:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaHHNr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:47:58 -0400
Date: Fri, 8 Aug 2014 06:47:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Martin Berglund <martin@rogsta.net>
Cc: devel@driverdev.osuosl.org, Forest Bond <forest@alittletooquiet.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: wpactl.c: Fix sparse warnings
Message-ID: <20140808134725.GE4427@kroah.com>
References: <20140807220834.GA21645@licorice>
 <20140808021813.GB22340@kroah.com>
 <20140808070755.GA12023@astc-ogir.Teknik.UU.SE>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808070755.GA12023@astc-ogir.Teknik.UU.SE>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 09:07:55AM +0200, Martin Berglund wrote:
> On Thu, Aug 07, 2014 at 07:18:13PM -0700, Greg Kroah-Hartman wrote:
> > On Thu, Aug 07, 2014 at 11:08:34PM +0100, Martin Berglund wrote:
> > > Add missing __user macro casting in the function wpa_set_keys.
> > > This is okay since the function handles the possibility of
> > > param->u.wpa_key.key and param->u.wpa_key.seq pointing to
> > > kernelspace using a flag, fcpfkernel.
> > > 
> > > Signed-off-by: Martin Berglund <martin@rogsta.net>
> > > ---
> > > This was submitted as part of Eudyptula challenge task 16
> > > 
> > >  drivers/staging/vt6655/wpactl.c |    8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
> > > index 5f454ca..d75dd79 100644
> > > --- a/drivers/staging/vt6655/wpactl.c
> > > +++ b/drivers/staging/vt6655/wpactl.c
> > > @@ -224,7 +224,9 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
> > >  	} else {
> > >  		spin_unlock_irq(&pDevice->lock);
> > >  		if (param->u.wpa_key.key &&
> > > -		    copy_from_user(&abyKey[0], param->u.wpa_key.key, param->u.wpa_key.key_len)) {
> > > +		    copy_from_user(&abyKey[0],
> > > +				   (void __user *)param->u.wpa_key.key,
> > 
> > Would it be better to mark this pointer as __user in the structure
> > itself?  Or is it also used as a kernel structure in other places?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Yes, the structure is used as a kernel structure in some other places. 
> Even this function is sometimes called with the pointers in the
> structure pointing to kernel memory. However, that is correctly
> handled with a flag also sent to the function.

Ugh, that's a mess.  And should be cleaned up...

> As a side note: there are some uses of memcpy in this file that
> might be good to switch to copy_from/to_user but it's not as clear
> to me if these pointers never can point to kernel memory (because of
> the mixing of the two). For example all copying of ssid and bssid.

That also is not good, if memcpy is used for userspace memory pointers,
bad things can happen on some machines...

Look at how this was fixed up in the other staging vt* driver, odds are
you can do the same thing here, right?

thanks,

greg k-h
