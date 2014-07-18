Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbaGRI5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:57:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaGRI5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:57:34 -0400
Date: Fri, 18 Jul 2014 14:26:26 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org
Subject: Re: [RFC PATCH 1/3] hw_random: allow RNG devices to give early
 randomness after a delay
Message-ID: <20140718085626.GA15020@grmbl.mre>
References: <cover.1405277045.git.amit.shah@redhat.com>
 <685be569a29015d3ee56cc3f782d81cae06d52b9.1405277045.git.amit.shah@redhat.com>
 <20140714123700.GP13108@titan.lakedaemon.net>
 <20140714124246.GA1520@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714124246.GA1520@grmbl.mre>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 14 Jul 2014 [18:12:46], Amit Shah wrote:
> On (Mon) 14 Jul 2014 [08:37:00], Jason Cooper wrote:
> > On Mon, Jul 14, 2014 at 10:05:19AM +0530, Amit Shah wrote:
> > > Some RNG devices may not be ready to give early randomness at probe()
> > > time, and hence lose out on the opportunity to contribute to system
> > > randomness at boot- or device hotplug- time.
> > > 
> > > This commit schedules a delayed work item for such devices, and fetches
> > > early randomness after a delay.  Currently the delay is 500ms, which is
> > > enough for the lone device that needs such treatment: virtio-rng.
> > > 
> > > CC: Kees Cook <keescook@chromium.org>
> > > CC: Jason Cooper <jason@lakedaemon.net>
> > > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > > ---
> > >  drivers/char/hw_random/core.c | 20 +++++++++++++++++++-
> > >  include/linux/hw_random.h     |  8 ++++++++
> > >  2 files changed, 27 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> > > index c4419ea..2a765fd 100644
> > > --- a/drivers/char/hw_random/core.c
> > > +++ b/drivers/char/hw_random/core.c
> > > @@ -63,7 +63,7 @@ static size_t rng_buffer_size(void)
> > >  	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
> > >  }
> > >  
> > > -static void add_early_randomness(struct hwrng *rng)
> > > +static void get_early_randomness(struct hwrng *rng)
> > >  {
> > >  	unsigned char bytes[16];
> > >  	int bytes_read;
> > > @@ -79,6 +79,21 @@ static void add_early_randomness(struct hwrng *rng)
> > >  		add_device_randomness(bytes, bytes_read);
> > >  }
> > >  
> > > +static void sched_init_random(struct work_struct *work)
> > > +{
> > > +	struct hwrng *rng = container_of(work, struct hwrng, dwork.work);
> > > +
> > > +	get_early_randomness(rng);
> > > +}
> > > +
> > > +static void add_early_randomness(struct hwrng *rng)
> > 
> > The add/get naming seems awkward in the above hunks.
> 
> Yea; I felt that too.  I thought of a do_add_early_randomness()
> instead, but that seemed awkward too.  I forgot to mention I was
> planning on revisiting this naming for v1.
> 
> > > +{
> > > +	if (!(rng->flags & HWRNG_DELAY_READ_AT_INIT))
> > > +		return get_early_randomness(rng);
> > > +
> > > +	schedule_delayed_work(&rng->dwork, msecs_to_jiffies(500));
> > > +}
> > > +
> > 
> > Perhaps instead of rng->flags and a hardcoded delay, we could have
> > rng->seed_delay = msecs_to_jiffies(500) in virtio-rng?  Then you can
> > just call unconditionally:
> > 
> > 	schedule_delayed_work(&rng->dwork, rng->seed_delay);

BTW I didn't want to make this call unconditional -- i.e. the existing
behaviour of in-line fetching of randomness for all devices but one
should not be affected.

If indeed people are OK with this being done by a delayed work item
for all the drivers, the code can get a bit simpler here.

> > I think that would be a more extensible solution should other drivers
> > show up with the same issue.
> 
> Sounds like a good idea to me.  Though, changes in core.c that
> increase the time in hwrng_register() or hwrng_init() may not get
> noticed by rng drivers and they may suddenly start failing for no
> apparent reason.  Seems like a far stretch, though.  Does anyone else
> have an opinion on this?

Herbert, do you have any preference?

Thanks,
		Amit
