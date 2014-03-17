Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaCQXCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:02:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaCQXC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:02:29 -0400
Date: Mon, 17 Mar 2014 16:04:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        mina86@mina86.com, m.szyprowski@samsung.com, andrzej.p@samsung.com
Subject: Re: [PATCH] usb: gadget: f_fs: add missing spinlock and mutex unlock
Message-ID: <20140317230430.GA25872@kroah.com>
References: <1394440417-6100-1-git-send-email-r.baldyga@samsung.com>
 <20140317230404.GA21462@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317230404.GA21462@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:04:04PM -0700, Greg KH wrote:
> On Mon, Mar 10, 2014 at 09:33:37AM +0100, Robert Baldyga wrote:
> > This patch adds missing spin_unlock and mutex_unlock calls in
> > error handling code.
> > 
> > Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> > Acked-by: Michal Nazarewicz <mina86@mina86.com>
> > Acked-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  drivers/usb/gadget/f_fs.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> > index b7d273a..d6bd0a3 100644
> > --- a/drivers/usb/gadget/f_fs.c
> > +++ b/drivers/usb/gadget/f_fs.c
> > @@ -802,7 +802,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
> >  		if (io_data->aio) {
> >  			req = usb_ep_alloc_request(ep->ep, GFP_KERNEL);
> >  			if (unlikely(!req))
> > -				goto error;
> > +				goto error_lock;
> >  
> >  			req->buf      = data;
> >  			req->length   = io_data->len;
> > @@ -817,7 +817,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
> >  			ret = usb_ep_queue(ep->ep, req, GFP_ATOMIC);
> >  			if (unlikely(ret)) {
> >  				usb_ep_free_request(ep->ep, req);
> > -				goto error;
> > +				goto error_lock;
> >  			}
> >  			ret = -EIOCBQUEUED;
> >  
> > @@ -863,6 +863,10 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
> >  
> >  	mutex_unlock(&epfile->mutex);
> >  	return ret;
> > +
> > +error_lock:
> > +	spin_unlock_irq(&epfile->ffs->eps_lock);
> > +	mutex_unlock(&epfile->mutex);
> >  error:
> >  	kfree(data);
> >  	return ret;
> > -- 
> > 1.7.9.5
> 
> This patch doesn't apply to my tree at all :(

Ick, wrong tree, nevermind...

greg "too many kernel trees" k-h
