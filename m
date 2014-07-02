Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaGBNmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:42:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:44089 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751226AbaGBNmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:42:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+lKslftfkk91ptZJ2FJzwXMna/en0c4Js=
X-DKIM: OpenDKIM Filter v2.0.1 titan D719D5A0445
Date: Wed, 2 Jul 2014 09:41:56 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] hwrng: Allow drivers to disable reading during
 probe
Message-ID: <20140702134156.GL23978@titan.lakedaemon.net>
References: <cover.1404296679.git.amit.shah@redhat.com>
 <1404306020-24916-1-git-send-email-jason@lakedaemon.net>
 <20140702132635.GD7505@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702132635.GD7505@grmbl.mre>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 06:56:35PM +0530, Amit Shah wrote:
> Hi Jason,
> 
> On (Wed) 02 Jul 2014 [13:00:19], Jason Cooper wrote:
> > Commit d9e7972619334 "hwrng: add randomness to system from rng sources"
> > added a call to rng_get_data() from the hwrng_register() function.
> > However, some rng devices need initialization before data can be read
> > from them.
> > 
> > Also, the virtio-rng device does not behave properly when this call is
> > made in its probe() routine - the virtio core sets the DRIVER_OK status
> > bit only on a successful probe, which means the host ignores all
> > communication from the guest, and the guest insmod or boot process just
> > sits there doing nothing.
> > 
> > [ jac: Modify the API to allow drivers to disable reading at probe, new
> > patch, copied Amit's commit message. ]
> > 
> > CC: Kees Cook <keescook@chromium.org>
> > CC: Jason Cooper <jason@lakedaemon.net>
> > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > CC: <stable@vger.kernel.org> # v3.15+
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> > ---
> >  drivers/char/hw_random/core.c | 8 +++++---
> >  include/linux/hw_random.h     | 4 ++++
> >  2 files changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> > index 334601cc81cf..b7b6c48ca682 100644
> > --- a/drivers/char/hw_random/core.c
> > +++ b/drivers/char/hw_random/core.c
> > @@ -347,9 +347,11 @@ int hwrng_register(struct hwrng *rng)
> >  	INIT_LIST_HEAD(&rng->list);
> >  	list_add_tail(&rng->list, &rng_list);
> >  
> > -	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
> > -	if (bytes_read > 0)
> > -		add_device_randomness(bytes, bytes_read);
> > +	if (!(rng->flags & HWRNG_NO_READ_AT_PROBE)) {
> > +		bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
> > +		if (bytes_read > 0)
> > +			add_device_randomness(bytes, bytes_read);
> > +	}
> 
> But this has the inverse problem: if there are two hwrngs in the
> system, one will be initialized and probed.  The other will not be
> initialized, but still be probed.

That's a problem outside the scope of this patch.  You're basically
saying the ->init() should be called unconditionally for each hwrng.  If
that's what driver authors assumed, that's not what is happening if
there is more than one driver in the system.

I think you should be changing the code a few lines up to make sure
hwrng_init() is called once for each driver.

> My version was more conservative while this one keeps the bug from the
> current kernels.

Huh?  What do you mean by "keeps the bug from the current kernels." ?

Besides, you're second patch isn't actually doing any ->init to get the
hwrng ready for reading...  If you had a real ->init function, and it
was always called, would rng_get_data() work at probe time for your
driver?

confused,

Jason.
