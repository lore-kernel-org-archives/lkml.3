Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaGUMWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:22:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbaGUMWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:22:00 -0400
Date: Mon, 21 Jul 2014 17:51:02 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, Amos Kong <akong@redhat.com>
Subject: Re: [PATCH v2 3/4] virtio: rng: delay hwrng_register() till driver
 is ready
Message-ID: <20140721122102.GC12925@grmbl.mre>
References: <cover.1405942162.git.amit.shah@redhat.com>
 <91cb7c5b87cf2ba5ef1bacd55a7ee7bc827293a2.1405942162.git.amit.shah@redhat.com>
 <20140721121116.GA18750@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721121116.GA18750@titan.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 21 Jul 2014 [08:11:16], Jason Cooper wrote:
> On Mon, Jul 21, 2014 at 05:15:51PM +0530, Amit Shah wrote:
> > Instead of calling hwrng_register() in the probe routing, call it in the
> > scan routine.  This ensures that when hwrng_register() is successful,
> > and it requests a few random bytes to seed the kernel's pool at init,
> > we're ready to service that request.
> > 
> > This will also enable us to remove the workaround added previously to
> > check whether probe was completed, and only then ask for data from the
> > host.  The revert follows in the next commit.
> > 
> > There's a slight behaviour change here on unsuccessful hwrng_register().
> > Previously, when hwrng_unregister() failed, the probe() routine would
> > fail, and the vqs would be torn down, and driver would be marked not
> > initialized.  Now, the vqs will remain initialized, driver would be
> > marked initialized as well, but won't be available in the list of RNGs
> > available to hwrng core.  To fix the failures, the procedure remains the
> > same, i.e. unload and re-load the module, and hope things succeed the
> > next time around.
> 
> I'm not too comfortable with this.  I'll try to take a closer look
> tonight, but in the meantime...
> 
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > ---
> >  drivers/char/hw_random/virtio-rng.c | 25 +++++++++++++++----------
> >  1 file changed, 15 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> > index a156284..d9927eb 100644
> > --- a/drivers/char/hw_random/virtio-rng.c
> > +++ b/drivers/char/hw_random/virtio-rng.c
> > @@ -35,6 +35,7 @@ struct virtrng_info {
> >  	unsigned int data_avail;
> >  	int index;
> >  	bool busy;
> > +	bool hwrng_register_done;
> >  };
> >  
> >  static bool probe_done;
> > @@ -136,15 +137,6 @@ static int probe_common(struct virtio_device *vdev)
> >  		return err;
> >  	}
> >  
> > -	err = hwrng_register(&vi->hwrng);
> > -	if (err) {
> > -		vdev->config->del_vqs(vdev);
> > -		vi->vq = NULL;
> > -		kfree(vi);
> > -		ida_simple_remove(&rng_index_ida, index);
> > -		return err;
> > -	}
> > -
> 
> This needs to stay.  register, and failure to do so, should occur in the
> probe routine.

Can you elaborate why?

> >  	probe_done = true;
> >  	return 0;
> >  }
> > @@ -152,9 +144,11 @@ static int probe_common(struct virtio_device *vdev)
> >  static void remove_common(struct virtio_device *vdev)
> >  {
> >  	struct virtrng_info *vi = vdev->priv;
> > +
> >  	vdev->config->reset(vdev);
> >  	vi->busy = false;
> > -	hwrng_unregister(&vi->hwrng);
> > +	if (vi->hwrng_register_done)
> > +		hwrng_unregister(&vi->hwrng);
> >  	vdev->config->del_vqs(vdev);
> >  	ida_simple_remove(&rng_index_ida, vi->index);
> >  	kfree(vi);
> > @@ -170,6 +164,16 @@ static void virtrng_remove(struct virtio_device *vdev)
> >  	remove_common(vdev);
> >  }
> >  
> > +static void virtrng_scan(struct virtio_device *vdev)
> > +{
> > +	struct virtrng_info *vi = vdev->priv;
> > +	int err;
> > +
> > +	err = hwrng_register(&vi->hwrng);
> > +	if (!err)
> > +		vi->hwrng_register_done = true;
> 
> Instead, perhaps we should just feed the entropy pool from here?  We
> would still need to prevent the core from doing so.  Perhaps back to the
> flag idea?

No way hwrng knows the difference between probe and scan for
virtio-rng, so it's back to the delayed workqueue idea, if this isn't
usable..

But I need to understand why this isn't workable.

Thanks,

		Amit
