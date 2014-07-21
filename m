Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaGUVlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:41:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45312 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaGUVlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:41:07 -0400
Date: Mon, 21 Jul 2014 14:38:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch V2 40/64] hwmon: ibmaem: Use ktime_get_ns()
Message-ID: <20140721213825.GA2862@birch.djwong.org>
References: <20140716205018.175419210@linutronix.de>
 <20140716205055.584960520@linutronix.de>
 <1405931858.4939.30.camel@chaos.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405931858.4939.30.camel@chaos.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:37:38AM +0200, Jean Delvare wrote:
> Hi Thomas,
> 
> Le Wednesday 16 July 2014 à 21:04 +0000, Thomas Gleixner a écrit :
> > Using the wall clock time for delta time calculations is wrong to
> > begin with because wall clock time can be set from userspace and NTP.
> > Such data wants to be based on clock monotonic.
> > 
> > The calcuations also are done on a nanosecond basis. Use the
> 
> Typo: calculations
> 
> > nanoseconds based interface right away.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Jean Delvare <jdelvare@suse.de>
> > ---
> >  drivers/hwmon/ibmaem.c |    6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > Index: tip/drivers/hwmon/ibmaem.c
> > ===================================================================
> > --- tip.orig/drivers/hwmon/ibmaem.c
> > +++ tip/drivers/hwmon/ibmaem.c
> > @@ -842,11 +842,10 @@ static ssize_t aem_show_power(struct dev
> >  	struct aem_data *data = dev_get_drvdata(dev);
> >  	u64 before, after, delta, time;
> >  	signed long leftover;
> > -	struct timespec b, a;
> >  
> >  	mutex_lock(&data->lock);
> >  	update_aem_energy_one(data, attr->index);
> > -	getnstimeofday(&b);
> > +	time = ktime_get_ns();
> >  	before = data->energy[attr->index];
> >  
> >  	leftover = schedule_timeout_interruptible(
> > @@ -858,11 +857,10 @@ static ssize_t aem_show_power(struct dev
> >  	}
> >  
> >  	update_aem_energy_one(data, attr->index);
> > -	getnstimeofday(&a);
> > +	time = ktime_get_ns() - time;
> >  	after = data->energy[attr->index];
> >  	mutex_unlock(&data->lock);
> >  
> > -	time = timespec_to_ns(&a) - timespec_to_ns(&b);
> >  	delta = (after - before) * UJ_PER_MJ;
> >  
> >  	return sprintf(buf, "%llu\n",
> 
> I'm not familiar with the driver and I can't test it, and I'm not
> familiar with kernel timekeeping either. All I can say is that the
> changes look reasonable and good.
> 
> Acked-by: Jean Delvare <jdelvare@suse.de>
> 
> Darrick, maybe you want to comment or test?

Looks ok to me from a theoretical point of view, but since I no longer work at
IBM, I don't have hardware for a real test. :(

--D
> 
> -- 
> Jean Delvare
> SUSE L3 Support
> 
