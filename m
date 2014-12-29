Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaL2SOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 13:14:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:40607 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbaL2SOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 13:14:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,659,1413270000"; 
   d="scan'208";a="654563866"
From: "Tirdea, Irina" <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dogaru, Vlad" <vlad.dogaru@intel.com>,
        "Baluta, Daniel" <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: RE: [PATCH 3/8] iio: core: Introduce SPEED channel type
Thread-Topic: [PATCH 3/8] iio: core: Introduce SPEED channel type
Thread-Index: AQHQIQ/a2ooJZNW3oUOYtS4Ton7SX5yms7pg
Date: Mon, 29 Dec 2014 18:13:08 +0000
Deferred-Delivery: Mon, 29 Dec 2014 18:13:00 +0000
Message-ID: <1F3AC3675D538145B1661F571FE1805F199F7B6F@irsmsx105.ger.corp.intel.com>
References: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com>
 <1419029879-12024-4-git-send-email-irina.tirdea@intel.com>
 <549D6274.8030601@kernel.org>
In-Reply-To: <549D6274.8030601@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.180]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jonathan Cameron [mailto:jic23@kernel.org]
> Sent: 26 December, 2014 15:28
> To: Tirdea, Irina; linux-iio@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Dogaru, Vlad; Baluta, Daniel; Hartmut Knaack; Lars-Peter Clausen; Peter Meerwald
> Subject: Re: [PATCH 3/8] iio: core: Introduce SPEED channel type
> 
> On 19/12/14 22:57, Irina Tirdea wrote:
> > Some devices export the current speed value of the user.
> >
> > One of this devices is Freescale's MMA9553L
> > (http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
> > that computes the speed of the user based on the number of steps and
> > stride length.
> >
> > Introduce a new channel type SPEED to export these values.
> >
> A fun question raised by this is whether we are going to end up with
> both speed and velocity (depending on whether it is signed or not).
> I suppose there isn't much to be done about that though and this looks fine
> to me (as does the previous one).

We might be able to unify speed and velocity if we use modifiers.

I am not sure how a device would export velocity information, but I assume it would be similar to acceleration (since we are talking about a vector as well). In this case we would need one channel type IIO_VELOCITY with modifiers for the 3 axes (IIO_MOD_X, IIO_MOD_Y, IIO_MOD_Z). We can further compute speed as the magnitude or the norm of the velocity vector (root of the sum squared values for x, y, z), so we can export it as an additional modifier IIO_MOD_NORM.

The pedometer only gives speed information without keeping track of the direction, so in this case we will have one channel IIO_VELOCITY with one modifier IIO_MOD_NORM.

Would this be a better approach than just exporting IIO_SPEED?

Thanks,
Irina

> > Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> > ---
> >  Documentation/ABI/testing/sysfs-bus-iio |    9 +++++++++
> >  drivers/iio/industrialio-core.c         |    1 +
> >  include/linux/iio/types.h               |    1 +
> >  3 files changed, 11 insertions(+)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> > index a5c1dcc..07acef7 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-iio
> > +++ b/Documentation/ABI/testing/sysfs-bus-iio
> > @@ -295,6 +295,7 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_rot_from_north_true_tilt_comp_scale
> >  What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_scale
> >  What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_scale
> >  What:		/sys/bus/iio/devices/iio:deviceX/in_humidityrelative_scale
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_speed_scale
> >  KernelVersion:	2.6.35
> >  Contact:	linux-iio@vger.kernel.org
> >  Description:
> > @@ -1146,6 +1147,14 @@ Description:
> >  		present, output should be considered as processed with the
> >  		unit in milliamps.
> >
> > +What:		/sys/.../iio:deviceX/in_speed_input
> > +What:		/sys/.../iio:deviceX/in_speed_raw
> > +KernelVersion:	3.19
> > +Contact:	linux-iio@vger.kernel.org
> > +Description:
> > +		This attribute is used to read the current speed value of the user.
> > +		Units after application of scale are m/s.
> > +
> >  What:		/sys/.../iio:deviceX/in_steps_en
> >  KernelVersion:	3.19
> >  Contact:	linux-iio@vger.kernel.org
> > diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> > index 4a10d31..5e50aca 100644
> > --- a/drivers/iio/industrialio-core.c
> > +++ b/drivers/iio/industrialio-core.c
> > @@ -74,6 +74,7 @@ static const char * const iio_chan_type_name_spec[] = {
> >  	[IIO_STEPS] = "steps",
> >  	[IIO_CALORIES] = "calories",
> >  	[IIO_DISTANCE] = "distance",
> > +	[IIO_SPEED] = "speed",
> >  };
> >
> >  static const char * const iio_modifier_names[] = {
> > diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> > index b98f751..c848f45 100644
> > --- a/include/linux/iio/types.h
> > +++ b/include/linux/iio/types.h
> > @@ -34,6 +34,7 @@ enum iio_chan_type {
> >  	IIO_STEPS,
> >  	IIO_CALORIES,
> >  	IIO_DISTANCE,
> > +	IIO_SPEED,
> >  };
> >
> >  enum iio_modifier {
> >

