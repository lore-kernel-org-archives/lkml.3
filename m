Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbaLIMVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:21:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257AbaLIMVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:21:32 -0500
Date: Tue, 9 Dec 2014 14:21:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, dahi@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, Christian Borntraeger <borntraeger@de.ibm.com>,
        linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 4/6] virtio_ccw: rev 1 devices set VIRTIO_F_VERSION_1
Message-ID: <20141209122118.GF3993@redhat.com>
References: <1418042769-25539-1-git-send-email-mst@redhat.com>
 <1418042769-25539-5-git-send-email-mst@redhat.com>
 <20141209120123.117ccfac.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209120123.117ccfac.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 12:01:23PM +0100, Cornelia Huck wrote:
> On Mon, 8 Dec 2014 15:06:03 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > What does it mean if rev 1 device does not set
> > VIRTIO_F_VERSION_1? E.g. is it native endian?
> 
> My understanding is that revision only determines the set of channel
> commands supported by the device, and their payload. IOW, it just
> governs the transport-specific way to communicate; things like
> endianness are independent of that and only governed by the VERSION_1
> bit which has rev 1 as a pre-req.

Well, that's a valid interpretation but it says so nowhere.

virtio 1.0 spec explicitly says VERSION_1 must be set.
virtio legacy explicitly said revision is 0.

And that is all.

We can go ahead and extend spec to support these configurations
in virtio 1.1.

Meanwhile, implementing random behaviour in guests will make
us support it forever.


> > 
> > Let's not even try to drive such devices:
> > fail attempts to finalize features.
> > virtio core will detect this and bail out.
> 
> Of course, we can still make the decision to refuse non-VERSION_1
> devices if rev 1 has been negotiated, but I'm still not quite sure what
> this buys us.

less configurations to support.


> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/s390/kvm/virtio_ccw.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
> > index 789275f..f9f87ba 100644
> > --- a/drivers/s390/kvm/virtio_ccw.c
> > +++ b/drivers/s390/kvm/virtio_ccw.c
> > @@ -758,6 +758,13 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
> >  	struct virtio_feature_desc *features;
> >  	struct ccw1 *ccw;
> > 
> > +	if (vcdev->revision == 1 &&
> 
> If we decide to keep this check, it should be for rev >= 1, though.

Fine, though this is theoretical, right?
Ican change this with a patch on top.

> > +	    !__virtio_test_bit(vdev, VIRTIO_F_VERSION_1)) {
> > +		dev_err(&vdev->dev, "virtio: device uses revision 1 "
> > +			"but does not have VIRTIO_F_VERSION_1\n");
> > +		return -EINVAL;
> > +	}
> > +
> >  	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
> >  	if (!ccw)
> >  		return 0;
> 
> I'm still not convinced by this change: I'd prefer to allow rev 1
> without VERSION_1, especially as the core makes all its decisions based
> upon VERSION_1.

At the moment, but this is an implementation detail.
This is exactly why I want this hard requirement in code.


> Unless someone else has a good argument in favour of
> this change.


Let's not commit to something we are not sure we
can support.

We can always remove this code, but once we release
guest we won't be able to drop it.



-- 
MST
