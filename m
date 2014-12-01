Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaLAMyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:54:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbaLAMy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:54:29 -0500
Date: Mon, 1 Dec 2014 14:54:08 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 42/46] virtio_scsi: v1.0 support
Message-ID: <20141201125408.GA18135@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
 <1417359787-10138-43-git-send-email-mst@redhat.com>
 <20141201135001.142bd29a.cornelia.huck@de.ibm.com>
 <20141201125305.GC18106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201125305.GC18106@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 02:53:05PM +0200, Michael S. Tsirkin wrote:
> On Mon, Dec 01, 2014 at 01:50:01PM +0100, Cornelia Huck wrote:
> > On Sun, 30 Nov 2014 17:12:47 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > Note: for consistency, and to avoid sparse errors,
> > >   convert all fields, even those no longer in use
> > >   for virtio v1.0.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > >  include/linux/virtio_scsi.h | 32 +++++++++++++++-------------
> > >  drivers/scsi/virtio_scsi.c  | 51 ++++++++++++++++++++++++++++-----------------
> > >  2 files changed, 49 insertions(+), 34 deletions(-)
> > > 
> > 
> > > @@ -196,10 +196,13 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
> > >  		break;
> > >  	}
> > > 
> > > -	WARN_ON(resp->sense_len > VIRTIO_SCSI_SENSE_SIZE);
> > > +	WARN_ON(virtio32_to_cpu(vscsi->vdev, resp->sense_len) >
> > > +		VIRTIO_SCSI_SENSE_SIZE);
> > 
> > Introduce a local variable for this? Might make this statement and the
> > min_t statement below easier to read.
> 
> I prefer 1:1 code conversions. We can do refactorings on top.
> Since you mention this line as hard to read, I'll just make it > 80
> chars for now, and trivial line splits can come later.
> OK?

Or maybe I'll keep it as is, since Paolo who wrote this code
is happy with it ..

> > >  	if (sc->sense_buffer) {
> > >  		memcpy(sc->sense_buffer, resp->sense,
> > > -		       min_t(u32, resp->sense_len, VIRTIO_SCSI_SENSE_SIZE));
> > > +		       min_t(u32,
> > > +			     virtio32_to_cpu(vscsi->vdev, resp->sense_len),
> > > +			     VIRTIO_SCSI_SENSE_SIZE));
> > >  		if (resp->sense_len)
> > >  			set_driver_byte(sc, DRIVER_SENSE);
> > >  	}
> > 
> > Otherwise looks good to me.
