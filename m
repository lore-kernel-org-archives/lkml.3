Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaGNMhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:37:16 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48027 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaGNMhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:37:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19m0c3eoYCsJ1YB+Etg13bWTIvtYmJW8+4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 4102C5AA9E5
Date: Mon, 14 Jul 2014 08:37:00 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org
Subject: Re: [RFC PATCH 1/3] hw_random: allow RNG devices to give early
 randomness after a delay
Message-ID: <20140714123700.GP13108@titan.lakedaemon.net>
References: <cover.1405277045.git.amit.shah@redhat.com>
 <685be569a29015d3ee56cc3f782d81cae06d52b9.1405277045.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <685be569a29015d3ee56cc3f782d81cae06d52b9.1405277045.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:05:19AM +0530, Amit Shah wrote:
> Some RNG devices may not be ready to give early randomness at probe()
> time, and hence lose out on the opportunity to contribute to system
> randomness at boot- or device hotplug- time.
> 
> This commit schedules a delayed work item for such devices, and fetches
> early randomness after a delay.  Currently the delay is 500ms, which is
> enough for the lone device that needs such treatment: virtio-rng.
> 
> CC: Kees Cook <keescook@chromium.org>
> CC: Jason Cooper <jason@lakedaemon.net>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> ---
>  drivers/char/hw_random/core.c | 20 +++++++++++++++++++-
>  include/linux/hw_random.h     |  8 ++++++++
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index c4419ea..2a765fd 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -63,7 +63,7 @@ static size_t rng_buffer_size(void)
>  	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
>  }
>  
> -static void add_early_randomness(struct hwrng *rng)
> +static void get_early_randomness(struct hwrng *rng)
>  {
>  	unsigned char bytes[16];
>  	int bytes_read;
> @@ -79,6 +79,21 @@ static void add_early_randomness(struct hwrng *rng)
>  		add_device_randomness(bytes, bytes_read);
>  }
>  
> +static void sched_init_random(struct work_struct *work)
> +{
> +	struct hwrng *rng = container_of(work, struct hwrng, dwork.work);
> +
> +	get_early_randomness(rng);
> +}
> +
> +static void add_early_randomness(struct hwrng *rng)

The add/get naming seems awkward in the above hunks.

> +{
> +	if (!(rng->flags & HWRNG_DELAY_READ_AT_INIT))
> +		return get_early_randomness(rng);
> +
> +	schedule_delayed_work(&rng->dwork, msecs_to_jiffies(500));
> +}
> +

Perhaps instead of rng->flags and a hardcoded delay, we could have
rng->seed_delay = msecs_to_jiffies(500) in virtio-rng?  Then you can
just call unconditionally:

	schedule_delayed_work(&rng->dwork, rng->seed_delay);

I think that would be a more extensible solution should other drivers
show up with the same issue.

thx,

Jason.
