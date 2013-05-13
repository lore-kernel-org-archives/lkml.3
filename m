Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab3EML4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 07:56:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:24551 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab3EML4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 07:56:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,662,1363158000"; 
   d="scan'208";a="240736147"
Message-ID: <1368446193.16445.88.camel@intelbox>
Subject: Re: [PATCH 04/11] hwmon/lm63,lm90: take msecs_to_jiffies_min into
 use
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org
Date: Mon, 13 May 2013 14:56:33 +0300
In-Reply-To: <20130513094700.7d134abc@endymion.delvare>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
	 <1368188011-23661-4-git-send-email-imre.deak@intel.com>
	 <20130513094700.7d134abc@endymion.delvare>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 09:47 +0200, Jean Delvare wrote:
> Hi Imre,
> 
> On Fri, 10 May 2013 15:13:22 +0300, Imre Deak wrote:
> > Use msecs_to_jiffies_min instead of open-coding the same.
> > 
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > ---
> >  drivers/hwmon/lm63.c |    2 +-
> >  drivers/hwmon/lm90.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
> > index f644a2e..db44bcb 100644
> > --- a/drivers/hwmon/lm63.c
> > +++ b/drivers/hwmon/lm63.c
> > @@ -248,7 +248,7 @@ static struct lm63_data *lm63_update_device(struct device *dev)
> >  	mutex_lock(&data->update_lock);
> >  
> >  	next_update = data->last_updated
> > -	  + msecs_to_jiffies(data->update_interval) + 1;
> > +	  + msecs_to_jiffies_min(data->update_interval);
> >  
> >  	if (time_after(jiffies, next_update) || !data->valid) {
> >  		if (data->config & 0x04) { /* tachometer enabled  */
> > diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> > index 8eeb141..314f9d3 100644
> > --- a/drivers/hwmon/lm90.c
> > +++ b/drivers/hwmon/lm90.c
> > @@ -471,7 +471,7 @@ static struct lm90_data *lm90_update_device(struct device *dev)
> >  	mutex_lock(&data->update_lock);
> >  
> >  	next_update = data->last_updated
> > -	  + msecs_to_jiffies(data->update_interval) + 1;
> > +	  + msecs_to_jiffies_min(data->update_interval);
> >  	if (time_after(jiffies, next_update) || !data->valid) {
> >  		u8 h, l;
> >  		u8 alarms;
> 
> I don't like this. The + 1 aren't there because msecs_to_jiffies() may
> return less than the required time, as you claim. I don't think this is
> the case (see the doubts expressed in my reply to patch 1/11.)
> 
> These + 1 are there because the chip may need exactly
> data->update_interval for the data sampling and the datasheet isn't
> completely clear about what would happen if the host polls for results
> at exactly the same frequency the chip is sampling.
> 
> Most likely it is just paranoia from me and the + 1 can be removed.
> Especially when time_after (as opposed to time_after_eq) already adds
> some margin - probably exactly what we need here. I have a few chips
> here I could test this on, BTW (ADM1032 and LM64.)

Yes I realize now that time_after() vs. time_after_eq() guarantees
already that we wait at least data->update_interval. Moreover +1 was
there to wait more than this, so clearly my change here was incorrect.

> And even if this was actually needed, then it is written the wrong way.
> We don't need one more jiffy, the SMBus slave doesn't even know what a
> jiffy is. We need an arbitrary additional amount of time, expressed in
> a standard time unit like ms. So
>   msecs_to_jiffies(data->update_interval + 1)
> would be the right way to write it.

Agreed, this describes the intention better.

> On top of that, your proposed change will make the resulting binary
> larger, the compilation longer,

True. This could be solved by turning the macros into uninlined
functions.

> the future code reviews harder,

Not sure what you mean by this. Having a properly named helper instead
of just writing +1 makes it more obvious what the intention was and
easier to spot places that are doing the wrong thing.

> and backporting these drivers harder.

This would be the case for places where the adjustment is already there
and we would just make this more explicit with the new helper. But for
places we actually fix in the current code backporting the fix would be
a benefit.

A was planning to send a patchset with the actual fixes after there is
some consensus that the approach is viable at all..

> Each of these points only by a very
> small fraction, of course, but for a benefit which is even smaller
> IMHO, if it even exists (which I doubt.)

I think there is a clear benefit.

> So I'm not going to apply this patch, sorry.

Ok, this particular change was done without enough thought and we should
drop it, but I hope you agree we need a generic solution for this
problem.

Thanks a lot for the review and thoughts,
Imre

