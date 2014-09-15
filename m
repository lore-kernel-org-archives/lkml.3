Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaIOOjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:39:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbaIOOjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:39:41 -0400
Date: Mon, 15 Sep 2014 17:39:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: virtualization@lists.linux-foundation.org,
        Anthony Liguori <aliguori@amazon.com>, Matt Wilson <msw@amazon.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_pci: properly clean up MSI-X state when
 initialization fails
Message-ID: <20140915143906.GB11644@redhat.com>
References: <1410751406-10039-1-git-send-email-anthony@codemonkey.ws>
 <20140915083220.GC6480@redhat.com>
 <CA+aC4kuHTjVF7vMbYwXPdoKcOfxQLKQywo+WMtjGfk99iJ9XUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+aC4kuHTjVF7vMbYwXPdoKcOfxQLKQywo+WMtjGfk99iJ9XUA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 07:10:45AM -0700, Anthony Liguori wrote:
> Hi Michael,
> 
> On Mon, Sep 15, 2014 at 1:32 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Sun, Sep 14, 2014 at 08:23:26PM -0700, Anthony Liguori wrote:
> >> From: Anthony Liguori <aliguori@amazon.com>
> >>
> >> If MSI-X initialization fails after setting msix_enabled = 1, then
> >> the device is left in an inconsistent state.  This would normally
> >> only happen if there was a bug in the device emulation but it still
> >> should be handled correctly.
> >
> > This might happen if host runs out of resources when trying
> > to map VQs to vectors, so doesn't have to be a bug.
> >
> > But I don't see what the problem is:
> > msix_used_vectors reflects the number of used vectors
> > and msix_enabled is set, thus vp_free_vectors
> > will free all IRQs and then disable MSIX.
> >
> > Where is the inconsistency you speak about?
> 
> I missed the fact that vp_free_vectors() conditionally sets
> msix_enabled=0.  It seems a bit cludgy especially since it is called
> both before and after setting msix_enabled=1.

It's the style of initialization that records the current initialization
stage, and then uses that to do all cleanup in a single place
(as compared to detailed separate goto labels for each initialization
stage).

I don't mind either keeping this style or changing to another style,
but if we change it we should change it everywhere I think.


> I ran into a number of weird problems due to read/write reordering
> that was causing this code path to fail.  The impact was
> non-deterministic.  I'll go back and try to better understand what
> code path is causing it.
> 
> >> Cc: Matt Wilson <msw@amazon.com>
> >> Cc: Rusty Russell <rusty@rustcorp.com.au>
> >> Cc: Michael Tsirkin <mst@redhat.com>
> >> Signed-off-by: Anthony Liguori <aliguori@amazon.com>
> >> ---
> >>  drivers/virtio/virtio_pci.c |    8 ++++++--
> >>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> >> index 9cbac33..3d2c2a5 100644
> >> --- a/drivers/virtio/virtio_pci.c
> >> +++ b/drivers/virtio/virtio_pci.c
> >> @@ -357,7 +357,7 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
> >>       v = ioread16(vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
> >>       if (v == VIRTIO_MSI_NO_VECTOR) {
> >>               err = -EBUSY;
> >> -             goto error;
> >> +             goto error_msix_used;
> >>       }
> >>
> >>       if (!per_vq_vectors) {
> >> @@ -369,11 +369,15 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
> >>                                 vp_vring_interrupt, 0, vp_dev->msix_names[v],
> >>                                 vp_dev);
> >>               if (err)
> >> -                     goto error;
> >> +                     goto error_msix_used;
> >>               ++vp_dev->msix_used_vectors;
> >>       }
> >>       return 0;
> >> +error_msix_used:
> >> +     v = --vp_dev->msix_used_vectors;
> >> +     free_irq(vp_dev->msix_entries[v].vector, vp_dev);
> >>  error:
> >> +     vp_dev->msix_enabled = 0;
> >
> > As far as I can see, if you do this, guest will not call
> > pci_disable_msix thus leaving the device with MSIX enabled.
> 
> I don't understand this comment.  How is the work done in this path
> any different from what's done in vp_free_vectors()?
> 
> Regards,
> 
> Anthony Liguori
> 
> > I'm not sure this won't break drivers if they then
> > try to use the device without MSIX, and it
> > definitely seems less elegant than reverting the
> > device to the original state.
> >
> >
> >>       vp_free_vectors(vdev);
> >>       return err;
> >>  }
> >> --
> >> 1.7.9.5
