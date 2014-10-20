Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaJTMmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:42:45 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:58994 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaJTMmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:42:37 -0400
Date: Mon, 20 Oct 2014 14:42:23 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Thomas Graf <tgraf@suug.ch>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <20141020144223.5655dcbc.cornelia.huck@de.ibm.com>
In-Reply-To: <20141020120750.GA18561@casper.infradead.org>
References: <1413114332-626-1-git-send-email-mst-v4@redhat.com>
	<1413114332-626-14-git-send-email-mst-v4@redhat.com>
	<20141020120750.GA18561@casper.infradead.org>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102012-0017-0000-0000-000001814B6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014 13:07:50 +0100
Thomas Graf <tgraf@suug.ch> wrote:

> On 10/13/14 at 10:50am, Michael S. Tsirkin wrote:
> > virtio spec requires drivers to set DRIVER_OK before using VQs.
> > This is set automatically after probe returns, virtio console violated this
> > rule by adding inbufs, which causes the VQ to be used directly within
> > probe.
> > 
> > To fix, call virtio_device_ready before using VQs.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/char/virtio_console.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> > index b585b47..6ebe8f6 100644
> > --- a/drivers/char/virtio_console.c
> > +++ b/drivers/char/virtio_console.c
> > @@ -1449,6 +1449,8 @@ static int add_port(struct ports_device *portdev, u32 id)
> >  	spin_lock_init(&port->outvq_lock);
> >  	init_waitqueue_head(&port->waitqueue);
> >  
> > +	virtio_device_ready(portdev->vdev);
> > +
> >  	/* Fill the in_vq with buffers so the host can send us data. */
> >  	nr_added_bufs = fill_queue(port->in_vq, &port->inbuf_lock);
> >  	if (!nr_added_bufs) {
> 
> Seems like probe and add_port() now both set VIRTIO_CONFIG_S_DRIVER_OK

I think we need to set this in the probe function instead, otherwise we
fail for multiqueue (which also wants to use the control queue early).

Completely untested patch below; I can send this with proper s-o-b if
it helps.

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index bfa6400..cf7a561 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1449,8 +1449,6 @@ static int add_port(struct ports_device *portdev, u32 id)
 	spin_lock_init(&port->outvq_lock);
 	init_waitqueue_head(&port->waitqueue);
 
-	virtio_device_ready(portdev->vdev);
-
 	/* Fill the in_vq with buffers so the host can send us data. */
 	nr_added_bufs = fill_queue(port->in_vq, &port->inbuf_lock);
 	if (!nr_added_bufs) {
@@ -2026,6 +2024,8 @@ static int virtcons_probe(struct virtio_device *vdev)
 	spin_lock_init(&portdev->ports_lock);
 	INIT_LIST_HEAD(&portdev->ports);
 
+	virtio_device_ready(portdev->vdev);
+
 	if (multiport) {
 		unsigned int nr_added_bufs;
 

