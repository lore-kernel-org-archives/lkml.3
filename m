Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaJTNLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:11:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbaJTNLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:11:34 -0400
Date: Mon, 20 Oct 2014 16:14:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas Graf <tgraf@suug.ch>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 13/25] virtio_console: enable VQs early
Message-ID: <20141020131405.GA20582@redhat.com>
References: <1413114332-626-1-git-send-email-mst-v4@redhat.com>
 <1413114332-626-14-git-send-email-mst-v4@redhat.com>
 <20141020120750.GA18561@casper.infradead.org>
 <20141020131016.GA20489@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020131016.GA20489@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 04:10:16PM +0300, Michael S. Tsirkin wrote:
> On Mon, Oct 20, 2014 at 01:07:50PM +0100, Thomas Graf wrote:
> > On 10/13/14 at 10:50am, Michael S. Tsirkin wrote:
> > > virtio spec requires drivers to set DRIVER_OK before using VQs.
> > > This is set automatically after probe returns, virtio console violated this
> > > rule by adding inbufs, which causes the VQ to be used directly within
> > > probe.
> > > 
> > > To fix, call virtio_device_ready before using VQs.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >  drivers/char/virtio_console.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> > > index b585b47..6ebe8f6 100644
> > > --- a/drivers/char/virtio_console.c
> > > +++ b/drivers/char/virtio_console.c
> > > @@ -1449,6 +1449,8 @@ static int add_port(struct ports_device *portdev, u32 id)
> > >  	spin_lock_init(&port->outvq_lock);
> > >  	init_waitqueue_head(&port->waitqueue);
> > >  
> > > +	virtio_device_ready(portdev->vdev);
> > > +
> > >  	/* Fill the in_vq with buffers so the host can send us data. */
> > >  	nr_added_bufs = fill_queue(port->in_vq, &port->inbuf_lock);
> > >  	if (!nr_added_bufs) {
> 
> I see Cornelia sent a patch already.
> I'd like to reproduce this though - could you send me
> the command line please?

Nevermind, the trick is to add a port it seems:

-device virtio-serial -chardev socket,path=/tmp/c1,server,nowait,id=foo
-device virtserialport,chardev=foo,name=org.fedoraproject.port.0

works fine without -device virtserialport.

-- 
MST
