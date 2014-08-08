Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbaHHHKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:10:47 -0400
Received: from mailrelay.sea-ab.se ([91.223.232.53]:42195 "EHLO
	mailrelay.sea-ab.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaHHHKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:10:46 -0400
Date: Fri, 8 Aug 2014 09:07:55 +0200
From: Martin Berglund <martin@rogsta.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Forest Bond <forest@alittletooquiet.net>,
        Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: wpactl.c: Fix sparse warnings
Message-ID: <20140808070755.GA12023@astc-ogir.Teknik.UU.SE>
References: <20140807220834.GA21645@licorice>
 <20140808021813.GB22340@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808021813.GB22340@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 07:18:13PM -0700, Greg Kroah-Hartman wrote:
> On Thu, Aug 07, 2014 at 11:08:34PM +0100, Martin Berglund wrote:
> > Add missing __user macro casting in the function wpa_set_keys.
> > This is okay since the function handles the possibility of
> > param->u.wpa_key.key and param->u.wpa_key.seq pointing to
> > kernelspace using a flag, fcpfkernel.
> > 
> > Signed-off-by: Martin Berglund <martin@rogsta.net>
> > ---
> > This was submitted as part of Eudyptula challenge task 16
> > 
> >  drivers/staging/vt6655/wpactl.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
> > index 5f454ca..d75dd79 100644
> > --- a/drivers/staging/vt6655/wpactl.c
> > +++ b/drivers/staging/vt6655/wpactl.c
> > @@ -224,7 +224,9 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
> >  	} else {
> >  		spin_unlock_irq(&pDevice->lock);
> >  		if (param->u.wpa_key.key &&
> > -		    copy_from_user(&abyKey[0], param->u.wpa_key.key, param->u.wpa_key.key_len)) {
> > +		    copy_from_user(&abyKey[0],
> > +				   (void __user *)param->u.wpa_key.key,
> 
> Would it be better to mark this pointer as __user in the structure
> itself?  Or is it also used as a kernel structure in other places?
> 
> thanks,
> 
> greg k-h

Yes, the structure is used as a kernel structure in some other places. 
Even this function is sometimes called with the pointers in the
structure pointing to kernel memory. However, that is correctly
handled with a flag also sent to the function.

As a side note: there are some uses of memcpy in this file that
might be good to switch to copy_from/to_user but it's not as clear
to me if these pointers never can point to kernel memory (because of
the mixing of the two). For example all copying of ssid and bssid.

Cheers,
                Martin
