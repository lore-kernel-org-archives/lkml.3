Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab3KSJk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:40:28 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:45065 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3KSJkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:40:23 -0500
Date: Tue, 19 Nov 2013 10:39:48 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 06/20] hwmon: lm75: expose to thermal fw via DT nodes
Message-ID: <20131119103948.0ec9daba@endymion.delvare>
In-Reply-To: <528A23DD.2070406@ti.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
	<1384285582-16933-7-git-send-email-eduardo.valentin@ti.com>
	<20131115084354.656452b9@endymion.delvare>
	<528A23DD.2070406@ti.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On Mon, 18 Nov 2013 10:27:41 -0400, Eduardo Valentin wrote:
> The patch series have been looked and contributed by several people and
> a couple o maintainers now. Starts to be way better than the original
> RFC. The core idea still holds though.

I have no objection to the core idea, it's great :-)

> >> (...)
> >>  /*-----------------------------------------------------------------------*/
> >>  
> >> +static inline long lm75_reg_to_mc(s16 temp, u8 resolution)
> >> +{
> >> +	return ((temp >> (16 - resolution)) * 1000) >> (resolution - 8);
> >> +}
> >> +
> >>  /* sysfs attributes for hwmon */
> >>  
> >> +static int lm75_read_temp(void *dev, long *temp)
> >> +{
> >> +	struct lm75_data *data = lm75_update_device(dev);
> >> +
> >> +	if (IS_ERR(data))
> >> +		return PTR_ERR(data);
> >> +
> >> +	*temp = lm75_reg_to_mc(data->temp[0], data->resolution);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>  static ssize_t show_temp(struct device *dev, struct device_attribute *da,
> >>  			 char *buf)
> >>  {
> >>  	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
> >>  	struct lm75_data *data = lm75_update_device(dev);
> >> -	long temp;
> >>  
> >>  	if (IS_ERR(data))
> >>  		return PTR_ERR(data);
> >>  
> >> -	temp = ((data->temp[attr->index] >> (16 - data->resolution)) * 1000)
> >> -	       >> (data->resolution - 8);
> >> -
> >> -	return sprintf(buf, "%ld\n", temp);
> >> +	return sprintf(buf, "%ld\n", lm75_reg_to_mc(data->temp[attr->index],
> >> +						    data->resolution));
> >>  }
> > 
> > I am a bit worried by this. I did expect that you'd have to split a
> > piece of show_temp() into one separate function, not two. Here you have
> > quite some redundancy between lm75_read_temp and show_temp. Sure these
> > are small functions so the duplicate code is limited, but if you
> > multiply by the number of hwmon drivers which are candidates for this
> > change, this all adds up.
> 
> Can you please elaborate a bit more on which way you think the code
> above shall be improved? Are you suggesting we should make show_temp
> call lm75_read_temp?

Yes, that's pretty much what I had in mind.

> On this specific case, I believe the code
> duplication is minor, although I haven't measured.

I do agree the duplication in a single driver is minor. However I
expect more hwmon drivers to be converted to cooperate with the thermal
subsystem in the future. Duplicated code adds up, in terms of build
time, storage space and run-time memory consumption. Plus it hurts CPU
caching even though I don't expect these code paths to be particularly
hot.

OTOH I suppose that the compiler will inline lm75_reg_to_mc() in this
specific case, saving one function call. It wouldn't possibly inline
lm75_read_temp() so it is quite possible that your implementation
actually performs better than what I am suggesting.

We're speaking of hardly measurable differences anyway. My other point
below is probably more important...

> >>  
> >>  static ssize_t set_temp(struct device *dev, struct device_attribute *da,
> >> @@ -271,6 +288,13 @@ lm75_probe(struct i2c_client *client, const struct i2c_device_id *id)
> >>  		goto exit_remove;
> >>  	}
> >>  
> >> +	data->tz = thermal_zone_of_sensor_register(&client->dev,
> >> +						   0,
> >> +						   &client->dev,
> >> +						   lm75_read_temp, NULL);
> > 
> > I am also worried by this interface. Basically a separate callback
> > function (here lm75_read_temp) is needed for every thermal input. Some
> > hwmon drivers have many of these! This will result in duplicate code
> 
> The code registering a callback can actually have a private data, in
> case you need to differentiate between inputs or in case you need to
> derive specific data in order to access the correct input.

Are you talking about void *dev? OK, you can virtually pass anything in
that pointer, but...

> > again. If you could just pass a sensor ID as an extra parameter to
> > lm75_read_temp, you could use the same callback for all sensors. This
> 
> Wouldn't the private pointer be enough?

I am worried that this won't be practical at all for the real world
cases. I expect that most drivers will need to pass the device plus one
index-like value. Having a single void pointer for that is certainly
flexible but it will also be inefficient, as every driver will have to
define its own custom structure to embed the needed information. You
_do_ pass a sensor_id to thermal_zone_of_sensor_register() so it
shouldn't be hard to pass it to the callback function(s) as well
(assuming the indexing in the device tree matches the one done by the
driver - I certainly hope so.) I'd even suggest passing the device
unconditionally too, as I just can't see how a driver could do without
it. If you pass the right parameters then you may not even need a void
pointer.

> I think it is a matter of checking what is the best way for the
> candidates of users of this new API.

I agree. But two drivers are probably too few to make an educated
decision, I suppose we'll need to convert some more to get a clearer
view. Note that most things can be changed later if needed, so my
comments aren't meant to block the integration of your patches. 

> In theory it is enough to hold the
> ID on the data structure you pass through the void * parameter. However,
> that would cause less impact if you have the users of the API already
> structured in that way. Let me know what is best for your case.

We do not have that structure (struct device *, int index) ready yet,
so we'd have to add it to every driver with more than one input. We
could have a generic structure for that in some header file, to avoid
the duplicated work, but if we need to do that, I'd say this is a good
hint that we settled for the wrong API in the first place.

> > (...)
> > I also note the lack of support for limits. Thermal zones can have
> > limits, and the various hwmon drivers do support that, yet your
> > interface offers no possibility to expose them. Wouldn't that be useful?

No comment on that? I'd expect the get_temp() callback to take an extra
parameter so that it can return the value of a specific subfeature, for
example INPUT, HOT, CRITICAL etc. Or leave get_temp() as is but add a
get_trip_temp() callback to retrieve limit information (not sure if
thermal zones can have more than one limit?)

I think thermal zones support hysteresis as well, and so do many hwmon
drivers. It seems unfortunate that your proposed "bridge" between the
hwmon and thermal subsystems doesn't map all the features which are
supported on both sides.

> >> +	if (IS_ERR(data->tz))
> >> +		data->tz = NULL;
> > 
> > If you are doing that in all drivers, I would question the point of
> > having thermal_zone_of_sensor_register() return a PTR_ERR in the first
> > place.
> 
> Yeah, maybe it should simply return NULL in the fail path and drivers
> would not need to bother about it. What do you think?

I think exactly what I wrote above, no more no less. I don't think I
can add anything, and the decision is up to you.

-- 
Jean Delvare
