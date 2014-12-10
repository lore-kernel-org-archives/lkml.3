Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbaLJXUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:20:36 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41485 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758284AbaLJXUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:20:33 -0500
Date: Thu, 11 Dec 2014 01:14:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v8 02/14] Documentation: leds: Add description of LED
 Flash class extension
Message-ID: <20141210231431.GP15559@valkosipuli.retiisi.org.uk>
References: <20141129125832.GA315@amd>
 <547C539A.4010500@samsung.com>
 <20141201130437.GB24737@amd>
 <547C7420.4080801@samsung.com>
 <CAK5ve-KMNszyz6br_Q_dOhvk=_8ev6Uz-ZhPnYBn-ZvuohQpVA@mail.gmail.com>
 <20141206124310.GB3411@amd>
 <5485D7F8.10807@samsung.com>
 <20141208201855.GA16648@amd>
 <5486B8AE.5000408@samsung.com>
 <20141209155033.GB21422@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209155033.GB21422@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel and Jacek,

On Tue, Dec 09, 2014 at 04:50:33PM +0100, Pavel Machek wrote:
> On Tue 2014-12-09 09:54:06, Jacek Anaszewski wrote:
> > Hi Pavel,
> > 
> > On 12/08/2014 09:18 PM, Pavel Machek wrote:
> > >On Mon 2014-12-08 17:55:20, Jacek Anaszewski wrote:
> > >>On 12/06/2014 01:43 PM, Pavel Machek wrote:
> > >>>
> > >>>>>The format of a sysfs attribute should be concise.
> > >>>>>The error codes are generic and map directly to the V4L2 Flash
> > >>>>>error codes.
> > >>>>>
> > >>>>
> > >>>>Actually I'd like to see those flash fault code defined in LED
> > >>>>subsystem. And V4L2 will just include LED flash header file to use it.
> > >>>>Because flash fault code is not for V4L2 specific but it's a feature
> > >>>>of LED flash devices.
> > >>>>
> > >>>>For clearing error code of flash devices, I think it depends on the
> > >>>>hardware. If most of our LED flash is using reading to clear error
> > >>>>code, we probably can make it simple as this now. But what if some
> > >>>>other LED flash devices are using writing to clear error code? we
> > >>>>should provide a API to that?
> > >>>
> > >>>Actually, we should provide API that makes sense, and that is easy to
> > >>>use by userspace.
> > >>>
> > >>>I believe "read" is called read because it does not change anything,
> > >>>and it should stay that way in /sysfs. You may want to talk to sysfs
> > >>>maintainers if you plan on doing another semantics.
> > >>
> > >>How would you proceed in case of devices which clear their fault
> > >>register upon I2C readout (e.g. AS3645)? In this case read does have
> > >>a side effect. For such devices attribute semantics would have to be
> > >>different than for the devices which don't clear faults on readout.
> > >
> > >No, semantics should be same for all devices.
> > >
> > >If device clears fault register during I2C readout, kernel will simply
> > >gather faults in an variable, and clear them upon write to sysfs file.
> > 
> > This approach would require implementing additional mechanisms on
> > both sides: LED Flash class core and a LED Flash class driver.
> > In the former the sysfs attribute write permissions would have
> > to be decided in the runtime and in the latter caching mechanism
> 
> Write attributes at runtime? Why? We can emulate sane and consistent
> behaviour for all the controllers: read gives you list of faults,
> write clears it. We can do it for all the controllers.
> 
> Only cost is few lines of code in the drivers where hardware clears
> faults at read.

Please take the time to read this, and consider it.

I'd say the cost is I2C register access, not so much a few lines added to
the drivers. The functionality and behaviour between the flash controllers
varies. They have different faults, presence of (some) faults may prevent
strobing, some support reading the flash status and some don't.

Some of the flash faults are mostly relevant in production testing, some can
be used to find hardware issues during use (rare) and some are produced in
common use (timeout, for instance).

The V4L2 flash API defines that reading the faults clears them, but does not
state whether presence of faults would prevent further use of the flash.
This is flash controller chip specific.

I think you *could* force a policy on the level of kernel API, for instance
require that the user clears the faults before strobing again rather than
relying on the chip requiring this instead.

Most of the time there are no faults. When there are, they may appear at
some point of time after the strobing, but how long? Probably roughly after
the timeout period the flash should have faults available if there were any
--- except if the strobe is external such as a sensor timed strobe. In that
case the software running on the CPU has no knowledge when the flash is
strobed nor when the faults should be read. So the requirement of checking
the faults would probably have to be limited to software strobe only. The
user would still have to be able to check the faults for externally strobed
pulses. Would it be acceptable that the interface was different there?

So, after the user has strobed, when the user should check the flash faults?
After the timeout period has passed? Right before strobing again? If this
was a requirement, it adds an additional I2C access to potentially the place
which should absolutely have no extra delay --- the flash strobe time. This
would be highly unwanted.

The faults seldom happened in regular use, but more recent flash controllers
have LED overtemperature or undervoltage faults, the latter of which isn't
really a fault, but status information telling that the flash current will
be limited. Reading the faults in this case is more important than it has
used to be.

Finally, should the LED flash class enforce such a policy, would the V4L2
flash API which is provided to the same devices be changed as well? I'm not
against that if we have

	1) can come up with a good policy that is understood to be
	   meaningful for all thinkable flash controller implementations and

	2) agreement the behaviour can be changed.


Btw. I think I'm slightly leaning towards liking flash faults in form of
strings better; that's what much of the sysfs interface already uses. V4L2
is quite a bit different from that; we have a bitmask control for faults
with well defined meanings for the bits in the spec. The LED class API is
much more usable from the command line, and using strings for flash faults
is in line with that. I have no strict stance towards that however;
hexadecimal numbers have advantages as well such as being slightly more
practicable to check in a C program. The importance of good documentatation
increases in that case though, and probably a header file with the bit
definitions is needed as well.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
