Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaJTOBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:01:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaJTOBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:01:36 -0400
Date: Mon, 20 Oct 2014 17:04:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Thomas Graf <tgraf@suug.ch>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 13/25] virtio_console: enable VQs early
Message-ID: <20141020140410.GA10994@redhat.com>
References: <1413114332-626-1-git-send-email-mst-v4@redhat.com>
 <1413114332-626-14-git-send-email-mst-v4@redhat.com>
 <20141020120750.GA18561@casper.infradead.org>
 <20141020144223.5655dcbc.cornelia.huck@de.ibm.com>
 <20141020133555.GA27111@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020133555.GA27111@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 04:35:55PM +0300, Michael S. Tsirkin wrote:
> On Mon, Oct 20, 2014 at 02:42:23PM +0200, Cornelia Huck wrote:
> > On Mon, 20 Oct 2014 13:07:50 +0100
> > Thomas Graf <tgraf@suug.ch> wrote:
> > 
> > > On 10/13/14 at 10:50am, Michael S. Tsirkin wrote:
> > > > virtio spec requires drivers to set DRIVER_OK before using VQs.
> > > > This is set automatically after probe returns, virtio console violated this
> > > > rule by adding inbufs, which causes the VQ to be used directly within
> > > > probe.
> > > > 
> > > > To fix, call virtio_device_ready before using VQs.
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > >  drivers/char/virtio_console.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> > > > index b585b47..6ebe8f6 100644
> > > > --- a/drivers/char/virtio_console.c
> > > > +++ b/drivers/char/virtio_console.c
> > > > @@ -1449,6 +1449,8 @@ static int add_port(struct ports_device *portdev, u32 id)
> > > >  	spin_lock_init(&port->outvq_lock);
> > > >  	init_waitqueue_head(&port->waitqueue);
> > > >  
> > > > +	virtio_device_ready(portdev->vdev);
> > > > +
> > > >  	/* Fill the in_vq with buffers so the host can send us data. */
> > > >  	nr_added_bufs = fill_queue(port->in_vq, &port->inbuf_lock);
> > > >  	if (!nr_added_bufs) {
> > > 
> > > Seems like probe and add_port() now both set VIRTIO_CONFIG_S_DRIVER_OK
> > 
> > I think we need to set this in the probe function instead, otherwise we
> > fail for multiqueue (which also wants to use the control queue early).
> > 
> > Completely untested patch below; I can send this with proper s-o-b if
> > it helps.
> > 
> > diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> > index bfa6400..cf7a561 100644
> > --- a/drivers/char/virtio_console.c
> > +++ b/drivers/char/virtio_console.c
> > @@ -1449,8 +1449,6 @@ static int add_port(struct ports_device *portdev, u32 id)
> >  	spin_lock_init(&port->outvq_lock);
> >  	init_waitqueue_head(&port->waitqueue);
> >  
> > -	virtio_device_ready(portdev->vdev);
> > -
> >  	/* Fill the in_vq with buffers so the host can send us data. */
> >  	nr_added_bufs = fill_queue(port->in_vq, &port->inbuf_lock);
> >  	if (!nr_added_bufs) {
> > @@ -2026,6 +2024,8 @@ static int virtcons_probe(struct virtio_device *vdev)
> >  	spin_lock_init(&portdev->ports_lock);
> >  	INIT_LIST_HEAD(&portdev->ports);
> >  
> > +	virtio_device_ready(portdev->vdev);
> > +
> >  	if (multiport) {
> >  		unsigned int nr_added_bufs;
> >  
> 
> I wanted to set DRIVER_OK as late as possible, to both reduce
> the chance it can fail after DRIVER_OK and to reduce  the risk of
> introducing a regression since old qemu might only start sending
> interrupts after DRIVER_OK is set.
> 
> So I wanted everything completely initialized before DRIVER_OK.
> 
> You patch makes sense to me since nothing can fail,
> and we won't get interrupts before we add inbufs.
> 
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Testig will report shortly, pls send with sob line.

Sure enough, this helps:

Tested-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>

Pls repost as a top-level patch.

> -- 
> MST
