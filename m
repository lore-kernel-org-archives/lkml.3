Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3FKGg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:36:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3FKGg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:36:28 -0400
Date: Mon, 10 Jun 2013 23:37:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        ldv-project@linuxtesting.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: ft1000: fix memory leak on error path in
 ft1000_probe()
Message-ID: <20130611063703.GB2380@kroah.com>
References: <1370892556-14503-1-git-send-email-khoroshilov@ispras.ru>
 <CAAfyv348JfJs-FbL3zvQgQ1i=MONVJWdhgfmqzdYOvGxcPAK0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv348JfJs-FbL3zvQgQ1i=MONVJWdhgfmqzdYOvGxcPAK0Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 10:40:19PM +0200, Belisko Marek wrote:
> Hi Alexey,
> 
> On Mon, Jun 10, 2013 at 9:29 PM, Alexey Khoroshilov
> <khoroshilov@ispras.ru> wrote:
> > ft1000dev->tx_urb and ft1000dev->rx_urb are not deallocated
> > if something goes wrong in ft1000_probe(). Also there is no
> > check for success of urb allocation. The patch fixes the both issues.
> >
> > By the way, there is no sense in GFP_ATOMIC for urb allocation here,
> > so it is changed to GFP_KERNEL.
> >
> > Found by Linux Driver Verification project (linuxtesting.org).
> >
> > Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> > ---
> >  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> > index 614db55..29a7cd2 100644
> > --- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> > +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> > @@ -79,8 +79,12 @@ static int ft1000_probe(struct usb_interface *interface,
> >         ft1000dev->dev = dev;
> >         ft1000dev->status = 0;
> >         ft1000dev->net = NULL;
> > -       ft1000dev->tx_urb = usb_alloc_urb(0, GFP_ATOMIC);
> > -       ft1000dev->rx_urb = usb_alloc_urb(0, GFP_ATOMIC);
> > +       ft1000dev->tx_urb = usb_alloc_urb(0, GFP_KERNEL);
> Can we check return value for tx here? If allocation fails it makes no sense to
> try allocate also rx. Otherwise looks good. Thanks.
> > +       ft1000dev->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
> Same for rx here.
> > +       if (!ft1000dev->tx_urb || !ft1000dev->rx_urb) {

Both of these allocations are checked here, so it's fine, no need to
change anything.

greg k-h
