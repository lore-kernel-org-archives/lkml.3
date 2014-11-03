Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaKCPZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:25:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaKCPZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:25:28 -0500
Date: Mon, 3 Nov 2014 23:24:04 +0800
From: Amos Kong <akong@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        m@bues.ch, mb@bu3sch.de, mpm@selenic.com, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] hw_random: fix unregister race.
Message-ID: <20141103152404.GA6620@air.redhat.com>
References: <87wq91odhf.fsf@rustcorp.com.au>
 <1411008506-28349-1-git-send-email-rusty@rustcorp.com.au>
 <1411008506-28349-3-git-send-email-rusty@rustcorp.com.au>
 <20141021141523.GA18345@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021141523.GA18345@gondor.apana.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 10:15:23PM +0800, Herbert Xu wrote:
> On Thu, Sep 18, 2014 at 12:18:24PM +0930, Rusty Russell wrote:
> > The previous patch added one potential problem: we can still be
> > reading from a hwrng when it's unregistered.  Add a wait for zero
> > in the hwrng_unregister path.
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > ---
> >  drivers/char/hw_random/core.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> > index dc9092a1075d..b4a21e9521cf 100644
> > --- a/drivers/char/hw_random/core.c
> > +++ b/drivers/char/hw_random/core.c
> > @@ -60,6 +60,7 @@ static DEFINE_MUTEX(rng_mutex);
> >  static DEFINE_MUTEX(reading_mutex);
> >  static int data_avail;
> >  static u8 *rng_buffer, *rng_fillbuf;
> > +static DECLARE_WAIT_QUEUE_HEAD(rng_done);
> >  static unsigned short current_quality;
> >  static unsigned short default_quality; /* = 0; default to "off" */
> >  
> > @@ -98,6 +99,7 @@ static inline void cleanup_rng(struct kref *kref)
> >  
> >  	if (rng->cleanup)
> >  		rng->cleanup(rng);

        rng->cleanup_done = true;

> > +	wake_up_all(&rng_done);
> >  }
> >  
> >  static void set_current_rng(struct hwrng *rng)
> > @@ -529,6 +531,9 @@ void hwrng_unregister(struct hwrng *rng)
> >  	}
> >  
> >  	mutex_unlock(&rng_mutex);
> > +
> > +	/* Just in case rng is reading right now, wait. */
> > +	wait_event(rng_done, atomic_read(&rng->ref.refcount) == 0);

Hi Rusty,
 
After initializing (kref_init()), the refcount is 1, so we need one
more kref_put() after each drop_current_rng() to release last
reference count, then cleanup function will be called.


> While it's obviously better than what we have now, I don't believe
> this is 100% safe as the cleanup function might still be running
> even after the ref count hits zero.  Once we return from this function
> the module may be unloaded so we need to ensure that nothing is
> running at this point.

I found wait_event() can still pass and finish unregister even cleanup
function isn't called (wake_up_all() isn't called). So I added a flag
cleanup_done to indicate that the rng device is cleaned up.


+       /* Just in case rng is reading right now, wait. */
+       wait_event(rng_done, rng->cleanup_done &&
+                  atomic_read(&rng->ref.refcount) == 0);

I will post the new v4 later.
 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
			Amos.
