Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaKYVUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:20:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaKYVUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:20:51 -0500
Date: Tue, 25 Nov 2014 23:20:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Pawel Moll <pawel.moll@arm.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 04/42] virtio: disable virtio 1.0 in transports
Message-ID: <20141125212011.GA22343@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
 <1416933600-21398-5-git-send-email-mst@redhat.com>
 <20141125182942.3890fe7b.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125182942.3890fe7b.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 06:29:42PM +0100, Cornelia Huck wrote:
> On Tue, 25 Nov 2014 18:41:35 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > disable virtio 1.0 in transports that don't
> > support it yet.
> 
> I'd prefer if you disabled it for _every_ transport in this patch,
> until the needed infrastructure is in place. Else this is a bit
> confusing.

Well the only transports left are pci and rpoc, and these only
read the low 32 bit of the features from the device -
so there's nothing to clear.

E.g. the following would be even more confusing, would it not:

	u32 features;
	....
	features &= ~BIT_ULL(VIRTIO_F_VERSION_1);

Agree?

> > We will gradually re-enable as support is added.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/lguest/lguest_device.c     | 3 ++-
> >  drivers/misc/mic/card/mic_virtio.c | 2 ++
> >  drivers/s390/kvm/virtio_ccw.c      | 3 ++-
> >  drivers/virtio/virtio_mmio.c       | 2 ++
> >  4 files changed, 8 insertions(+), 2 deletions(-)
> 
> Why do you disable ccw but not pci? (Doesn't pci need any changes
> transport-side?)

No because the register is 32 bit wide there.

> And you missed the old s390 virtio transport in
> drivers/s390/kvm/kvm_virtio.c :)

Good catch. I can fix that for v5, but see below.

> > diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
> > index abba04d..08536f0 100644
> > --- a/drivers/s390/kvm/virtio_ccw.c
> > +++ b/drivers/s390/kvm/virtio_ccw.c
> > @@ -704,7 +704,8 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
> >  out_free:
> >  	kfree(features);
> >  	kfree(ccw);
> > -	return rc;
> > +	/* TODO: enable virtio 1.0 */
> > +	return rc & ~BIT_ULL(VIRTIO_F_VERSION_1);;
> 
> double ';'
> 
> FWIW, as negotiating a revision >= 1 is a pre-req for virtio 1.0
> support on ccw, virtio 1.0 is already implicitly disabled.

Ah, you mean device guarantees that VIRTIO_F_VERSION_1 isn't set
if guest sets revision to 0?
In that case it's probably best to drop this from both ccw
devices.

It is here temporarily anyway, only in order to avoid
using transitional devices incorrectly when bisecting.


> >  }
> > 
> >  static void virtio_ccw_finalize_features(struct virtio_device *vdev)
