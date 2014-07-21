Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbaGUMlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:41:31 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:45166 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbaGUMl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:41:29 -0400
Date: Mon, 21 Jul 2014 20:41:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, keescook@chromium.org,
        Amos Kong <akong@redhat.com>
Subject: Re: [PATCH v2 3/4] virtio: rng: delay hwrng_register() till driver
 is ready
Message-ID: <20140721124124.GA7846@gondor.apana.org.au>
References: <cover.1405942162.git.amit.shah@redhat.com>
 <91cb7c5b87cf2ba5ef1bacd55a7ee7bc827293a2.1405942162.git.amit.shah@redhat.com>
 <20140721121116.GA18750@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721121116.GA18750@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 08:11:16AM -0400, Jason Cooper wrote:
>
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

Why? Probing involves finding out whether the hardware is present.
While hwrng_register is about adding an entry in the hwrng system
which may only be one aspect of the given hardware.

For example, the same hardware may support other features that are
used outside of the hwrng system, e.g., crypto.

So there's nothing special about probe that requires us to have the
hwrng_register call there.  In practice, the only difference between
having it in probe vs. scan is that you can return errors.  The only
error that can be returned is ENOMEM which isn't of much interest to
the caller of probe anyway.

On the other hand, if you are calling hwrng_register you better be
damn sure that your hardware is ready to answer requests from the
hwrng system.  Please don't add silly flags to work around this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
