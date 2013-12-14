Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3LNT1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:27:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab3LNT1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:27:04 -0500
Date: Sat, 14 Dec 2013 11:26:11 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20131214192611.GA23651@kroah.com>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
 <20131213020413.GD13333@kroah.com>
 <20131214121620.GA17467@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131214121620.GA17467@mithrandir>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 01:16:21PM +0100, Thierry Reding wrote:
> On Thu, Dec 12, 2013 at 06:04:13PM -0800, Greg Kroah-Hartman wrote:
> > On Thu, Dec 12, 2013 at 03:36:29PM +0100, Thierry Reding wrote:
> > > This is a simple test module that can be used to allocate, export and
> > > delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
> > > systems that lack a real second driver.
> > > 
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > >  drivers/base/Kconfig        |   4 +
> > >  drivers/base/Makefile       |   1 +
> > >  drivers/base/dma-buf-test.c | 308 ++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 313 insertions(+)
> > >  create mode 100644 drivers/base/dma-buf-test.c
> > > 
> > > diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> > > index e373671652b0..bed2abb9491b 100644
> > > --- a/drivers/base/Kconfig
> > > +++ b/drivers/base/Kconfig
> > > @@ -200,6 +200,10 @@ config DMA_SHARED_BUFFER
> > >  	  APIs extension; the file's descriptor can then be passed on to other
> > >  	  driver.
> > >  
> > > +config DMA_BUF_TEST
> > > +	tristate "DMA-BUF test module"
> > > +	depends on DMA_SHARED_BUFFER
> > 
> > We need some good documentation here.
> 
> I agree. The description should go into more details about what exactly
> this is meant to address.
> 
> > > > +static struct miscdevice dmabuf_device = {
> > > +	.minor = 128,
> > 
> > Why did you pick this minor?  Why not just make it dynamic?
> 
> It seemed like minors are statically allocated for miscdevice and 128
> seemed to be as good as any. The tentative plan was to go through the
> official way of having one allocated as explained in the comment in
> include/linux/miscdevice.h.
> 
> Reading that comment again, there's MISC_DYNAMIC_MINOR, which I guess
> would be appropriate here. Chances are that if you want to test DMA-BUF
> you'll have a reasonably modern userspace that will create the device
> dynamically.
> 
> Alternatively I guess I could instead turn this into a more full-fledged
> cdev and do the whole alloc_chrdev_region() dance. Although that will
> only allocate the major dynamically.

No, just use a dynamic misc device and all will be fine.  Bonus is that
you can create multiple misc devices if you ever really need to in the
future, with no need to change much code at all (i.e. no chrdev crud.)

> I'm not aware of any function that just allocates a single major/minor
> pair completely dynamically. Is there one that you could point me to?

Nope, that's what misc devices are for :)

greg k-h
