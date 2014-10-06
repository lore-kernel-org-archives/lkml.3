Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaJFSB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:01:27 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:43714 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaJFSBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:01:25 -0400
Date: Mon, 6 Oct 2014 14:01:13 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] thermal: core: fix: Initialize the max_state
 variable to 0
Message-ID: <20141006180110.GA5524@developer>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1411547232-21493-3-git-send-email-l.majewski@samsung.com>
 <20141002222649.GB11510@developer>
 <20141003102628.7a8f36f7@amdc2363>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003102628.7a8f36f7@amdc2363>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 10:26:28AM +0200, Lukasz Majewski wrote:
> Hi Eduardo,
> 
> > Hello Lukasz,
> > 
> > On Wed, Sep 24, 2014 at 10:27:11AM +0200, Lukasz Majewski wrote:
> > > Pointer to the uninitialized max_state variable is passed to get the
> > > maximal cooling state.
> > > For CPU cooling device (cpu_cooling.c) the cpufreq_get_max_state()
> > > is called, which even when error occurs will return the max_state
> > > variable unchanged.
> > > Since error for ->get_max_state() is not checked, the automatically
> > 
> > 
> > Good that you added a fix in your series for this.
> > 
> > 
> > > allocated value of max_state is used for (upper > max_state)
> > > comparison. For any possible max_state value it is very unlikely
> > > that it will be less than upper.
> > > As a consequence, the cooling device is bind even without the backed
> > > cpufreq table initialized.
> > > 
> > > This initialization will prevent from accidental binding trip
> > > points to cpu freq cooling frequencies when cpufreq driver itself
> > > is not yet fully initialized.
> > 
> > Although I agree with the fix, as long as we also include a check for
> > the .get_max_state return value,  I believe the problem you are
> > describing is about initialization sequence.
> 
> As you pointed out - the problem here is with initialization sequence.
> Thermal and cpufreq cores are initialized very early.
> 
> However, the get_max_state() for cpu_cooling.c device (as it is the
> pervasive way of cooling things) accesses cpufreq policy to get the
> freq_table and count available states.
> 
> The issue here is with late initialization of cpufreq policy.
> 
> Up till now the cpu_cooling device was bind even when the
> get_max_state() returned -EINVAL and everything worked after late
> cpufreq policy initialization. However, during this time window the
> thermal driver is not configured.
> 
> > 
> > In general, I believe we need a better
> > sequencing between thermal and cpufreq subsystems. One way out is to
> > include a check for cpufreq driver in the thermal driver, and return
> > -EPROBE_DEFER  when cpufreq is not ready.
> 
> I think that we could return -EPROBE_DEFER when cpufreq's policy is not
> yet available and subscribe to cpufreq notifier to call
> bind_cooling_device then.

I agree with this approach, as long as we keep the existing users of
cpufreq cooling in a working state.

Cheers

> 
> Let's wait for Zhang opinion since he looks after the thermal core code.
> 
> > 
> > > 
> > > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > > ---
> > >  drivers/thermal/thermal_core.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/thermal/thermal_core.c
> > > b/drivers/thermal/thermal_core.c index 454884a..747618a 100644
> > > --- a/drivers/thermal/thermal_core.c
> > > +++ b/drivers/thermal/thermal_core.c
> > > @@ -927,7 +927,7 @@ int thermal_zone_bind_cooling_device(struct
> > > thermal_zone_device *tz, struct thermal_instance *pos;
> > >  	struct thermal_zone_device *pos1;
> > >  	struct thermal_cooling_device *pos2;
> > > -	unsigned long max_state;
> > > +	unsigned long max_state = 0;
> > >  	int result;
> > >  
> > >  	if (trip >= tz->trips || (trip < 0 && trip !=
> > > THERMAL_TRIPS_NONE)) -- 
> > > 2.0.0.rc2
> > > 
> > 
> 
> 
> 
> -- 
> Best regards,
> 
> Lukasz Majewski
> 
> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
