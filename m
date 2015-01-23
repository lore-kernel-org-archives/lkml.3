Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbbAWL5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:57:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:36172 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbbAWL5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:57:51 -0500
Date: Fri, 23 Jan 2015 12:57:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Hilman <khilman@kernel.org>
cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Frederic Weisbecker <fweisbec@gmail.com>, preeti@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] clockevents: introduce ->set_dev_mode() which can
 return error
In-Reply-To: <1418162614-19182-2-git-send-email-khilman@kernel.org>
Message-ID: <alpine.DEB.2.11.1501231223470.5526@nanos>
References: <1418162614-19182-1-git-send-email-khilman@kernel.org> <1418162614-19182-2-git-send-email-khilman@kernel.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2014, Kevin Hilman wrote:
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index 55449909f114..f7614041240e 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -105,7 +105,16 @@ void clockevents_set_mode(struct clock_event_device *dev,
>  				 enum clock_event_mode mode)
>  {
>  	if (dev->mode != mode) {
> -		dev->set_mode(mode, dev);
> +		if (dev->set_dev_mode) {
> +			int ret = dev->set_dev_mode(mode, dev);
> +
> +			/* Currently available modes shouldn't fail */
> +			WARN_ONCE(ret, "Requested mode: %d, error: %d\n",
> +				  mode, ret);
> +		} else {
> +			dev->set_mode(mode, dev);
> +		}
> +
>  		dev->mode = mode;
>  
>  		/*
> @@ -448,8 +457,14 @@ int __clockevents_update_freq(struct clock_event_device *dev, u32 freq)
>  	if (dev->mode == CLOCK_EVT_MODE_ONESHOT)
>  		return clockevents_program_event(dev, dev->next_event, false);
>  
> -	if (dev->mode == CLOCK_EVT_MODE_PERIODIC)
> -		dev->set_mode(CLOCK_EVT_MODE_PERIODIC, dev);
> +	if (dev->mode == CLOCK_EVT_MODE_PERIODIC) {
> +		/* Shouldn't fail while switching to PERIODIC MODE */
> +		if (dev->set_dev_mode)
> +			WARN_ON_ONCE(dev->set_dev_mode(CLOCK_EVT_MODE_PERIODIC,
> +						       dev));
> +		else
> +			dev->set_mode(CLOCK_EVT_MODE_PERIODIC, dev);

Please split that out into

static int __clockevents_set_mode(dev, mode)
{
	int ret = 0;

	if (dev->set_dev_mode) {
	        ret = set_dev_mode(mode, dev);
		WARN_ON_ONCE(ret);
	} else {
		dev->set_mode(CLOCK_EVT_MODE_PERIODIC, dev);
	}
	return ret;
}

Now looking at the conversion patch, it looks like we add lots of

    case X:
    case Y:
    	 return 0;
	 
to avoid the

    default:
	 return -ENOSYS;

After staring at that I'm less convinced about this approach. So lets
think about something different:

static int __clockevents_set_mode(dev, mode)
{
	/* Transition mode */
	if (dev->set_mode) {
	   if (mode > CLOCK_EVT_MODE_RESUME)
	         return -ENOSYS;
	   dev->set_mode(mode, dev);
	   return 0;
	}

	if (dev->features & CLOCK_EVT_FEAT_DUMMY)
	   return 0;

	switch (mode) {
	/*
	 * This is an internal state, which is guaranteed to
	 * go from SHUTDOWN to UNUSED. No driver interaction
	 * required.
	 */
	case CLOCK_EVT_MODE_UNUSED:
	     return 0;   

	case CLOCK_EVT_MODE_SHUTDOWN:
	     return dev->shutdown(dev);

	case CLOCK_EVT_MODE_PERIODIC:
	     /* Core internal bug */
	     if (!(dev->features & CLOCK_EVT_FEAT_PERIODIC))
	     	   return -ENOSYS;
	     return dev->setup_periodic(dev);

	case CLOCK_EVT_MODE_ONESHOT:
	     /* Core internal bug */
	     if (!(dev->features & CLOCK_EVT_FEAT_ONESHOT))
	     	   return -ENOSYS;
	     return dev->setup_oneshot(dev);

	case CLOCK_EVT_MODE_RESUME:
	     return dev->setup_resume(dev);

     	default:
	     return -ENOSYS;
}

And do sanity checking on registration time:

static int ce_check(dev)
{
       if (dev->set_mode)
       	   return 0;

       if (dev->features & CLOCK_EVT_FEAT_DUMMY)
	   return 0;

       if (!dev->shutdown)
       	   return -EMORON;

       if ((dev->features & CLOCK_EVT_FEAT_PERIODIC) &&
       	   !dev->setup_periodic)
       	   return -EMORON;

       if ((dev->features & CLOCK_EVT_FEAT_ONESHOT) &&
       	   !dev->setup_oneshot)
       	   return -EMORON;

       /* Optional callbacks */       
       if (!dev->setup_resume)
       	  dev->setup_resume = setup_noop();

       return 0;
}

That gives us a clear distinction of required and optional callbacks,
which will make error handling and recovery simpler as well.

Thanks,

	tglx


