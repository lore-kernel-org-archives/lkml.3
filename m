Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaGBMOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:14:48 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44302 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaGBMOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:14:46 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ICyDoUvLfkRJb4EOTq86JALGKAPf+zsM=
X-DKIM: OpenDKIM Filter v2.0.1 titan B5A9B5A02C8
Date: Wed, 2 Jul 2014 08:14:38 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] hwrng: don't fetch rng from sources without init
Message-ID: <20140702121438.GK23978@titan.lakedaemon.net>
References: <cover.1404296679.git.amit.shah@redhat.com>
 <c911b7944f2d05f5c6f5cf5dc37b8dbb99fd0b14.1404296679.git.amit.shah@redhat.com>
 <20140702115823.GJ23978@titan.lakedaemon.net>
 <20140702121120.GB7505@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702121120.GB7505@grmbl.mre>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 05:41:20PM +0530, Amit Shah wrote:
> On (Wed) 02 Jul 2014 [07:58:23], Jason Cooper wrote:
> > On Wed, Jul 02, 2014 at 03:58:15PM +0530, Amit Shah wrote:
> > > Commit d9e7972619334 "hwrng: add randomness to system from rng sources"
> > > added a call to rng_get_data() from the hwrng_register() function.
> > > However, some rng devices need initialization before data can be read
> > > from them.
> > > 
> > > Also, the virtio-rng device does not behave properly when this call is
> > > made in its probe() routine - the virtio core sets the DRIVER_OK status
> > > bit only on a successful probe, which means the host ignores all
> > > communication from the guest, and the guest insmod or boot process just
> > > sits there doing nothing.
> > > 
> > > This commit makes the call to rng_get_data() depend on no init fn
> > > pointer being registered by the device.  If an init function is
> > > registered, this call isn't made.
> > > 
> > > CC: Kees Cook <keescook@chromium.org>
> > > CC: Jason Cooper <jason@lakedaemon.net>
> > > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > > CC: <stable@vger.kernel.org> # For 3.15 only
> > 
> > # v3.15+ should be fine here.
> > 
> > > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > > ---
> > >  drivers/char/hw_random/core.c | 8 +++++---
> > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> > > index 334601c..3f3941d 100644
> > > --- a/drivers/char/hw_random/core.c
> > > +++ b/drivers/char/hw_random/core.c
> > > @@ -347,9 +347,11 @@ int hwrng_register(struct hwrng *rng)
> > >  	INIT_LIST_HEAD(&rng->list);
> > >  	list_add_tail(&rng->list, &rng_list);
> > >  
> > > -	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
> > > -	if (bytes_read > 0)
> > > -		add_device_randomness(bytes, bytes_read);
> > > +	if (!rng->init) {
> > > +		bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
> > > +		if (bytes_read > 0)
> > > +			add_device_randomness(bytes, bytes_read);
> > > +	}
> > 
> > afaict, this is redundant at initialization time.  current_rng shouldn't
> > be set yet, so hwrng_init(rng) will get called at line 333.  Or, am I
> > missing something?
> 
> You're right -- the device will have been initialized if it's the
> first hwrng device to be registered.  And in that case, this device
> won't contribute to the initial pool (and that's the only case).
> 
> Can someone think of a better way to handle this for that case, then?

I'm cooking up something...

thx,

Jason.
