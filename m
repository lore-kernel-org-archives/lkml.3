Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab3GULIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 07:08:01 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44062 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3GULH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 07:07:59 -0400
Date: Sun, 21 Jul 2013 04:08:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, wni@nvidia.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, l.stach@pengutronix.de
Subject: Re: [lm-sensors] [RESEND PATCH V1 0/9] thermal: introduce DT thermal
 zone build
Message-ID: <20130721110807.GC24303@roeck-us.net>
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com>
 <20130717220942.GB990@roeck-us.net>
 <51E7F341.8020508@ti.com>
 <51E8234D.1020607@wwwdotorg.org>
 <20130718212108.GC4110@roeck-us.net>
 <51E98A07.4050402@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E98A07.4050402@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 12:48:39PM -0600, Stephen Warren wrote:
> On 07/18/2013 03:21 PM, Guenter Roeck wrote:
> > On Thu, Jul 18, 2013 at 11:18:05AM -0600, Stephen Warren wrote:
> >> On 07/18/2013 07:53 AM, Eduardo Valentin wrote:
> >>> Hello Guenter,
> >>>
> >>> On 17-07-2013 18:09, Guenter Roeck wrote:
> >>>> On Wed, Jul 17, 2013 at 11:17:19AM -0400, Eduardo Valentin
> >>>> wrote:
> >>>>> Hello all,
> >>>>>
> >>>>> As you noticed, I am working in a way to represent thermal
> >>>>> data using device tree [1]. Essentially, this should be a way
> >>>>> to say what to do with a sensor and how to associate (cooling)
> >>>>> actions with it.
> >>>>>
> >>>> Seems to me that goes way beyond the supposed scope of devicetree
> >>>> data. Devicetree data is supposed to describe hardware, not its
> >>>> configuration or use. This is clearly a use case.
> >>>
> >>> Thanks for rising your voice here. It is important to know what
> >>> hwmon ppl think about this.
> >>
> >> I meant to find time to read Guenter's original email where he
> >> initially objected to putting data into DT, and determine exactly what
> >> was being objected to. I still haven't:-( However, the arguments that
> >> Eduardo stated in his email do make sense to me; I agree that
> >> temperature limits really are a description of HW. Details of which
> >> cooling methods to invoke when certain temperature limits are reached
> >> is also part of the HW/system design, and hence I would tend to agree
> >> that they're appropriate to include in DT. Anyway, that's just my 2
> >> cents on the matter:-)
> > 
> > Many systems have multiple profiles for various use cases (high performance,
> > low power etc), and limits are different based on the use case. If that means
> > you are going to have multiple devicetree variants based on the profile,
> > I would argue that you crossed the line.
> 
> Yes, I can see that argument. However, a counter-point:
> 
> * I believe we do need a DT binding to describe the absolute thermal
> limits of a system, for safety/correctness of system operation.
> 
> * We need to define a syntax/schema to represent that.
> 
> * If we then want to implement additional profiles with stricter limits,
> do we really want to invent a different syntax/schema to represent
> those? Representing them in the same way seems like good use of the
> design, mind-share, etc.
> 
> * Perhaps that doesn't mean that the additional profiles have to be in
> DT though; just that we somehow make any other representation of those
> profiles as close to the DT representation in syntax/structure as we
> can, to get maximum re-use.
> 
> > With thermal profiles it gets even more
> > complicated, as those parameters may be played around with and changed
> > multiple times to find the best settings to achieve optimal cooling.
> 
> To me, that sounds more like fixing a bug in the initial data, rather
> than something which fundamentally affects how the data should be
> represented.
> 

For me, a bug in devicetree data would be if a wrong gpio pin is assigned ... if
a wrong clock frequency is specified, or a wrong clock input. I would not expect
a clock rate or pin assignment to be played around with to find the optimal
setting. Either it works or it doesn't.

Note that we don't really talk about pure thermal limits here. We are talking
about association between thermal sensors and cooling devices, which is much
more abstract and not as well defined as clock pin assignments. In many case,
more than one cooling device exists, and there is no well defined means to cool
the system. It may be cooled with a fan, or by reducing the CPU clock speed.
There may be multiple fans interacting with each other, and not all may be
present at all times. There may be secondary cooling options if primary cooling
fails (eg reduce CPU speed or increase speed of a secondary fan if a primary fan
fails).

Yes, I understand you need a means to describe thermal profiles. Putting one of
those into DT and declaring it to be the "absolute thermal limit", however, is
really just asking for putting other thermal profiles into DT as well ..
if you want a different thermal profile, just load a different devicetree, and
possibly make it configurable in BIOS/ROMMON. Of course you can declare that not
to be "intentional", but what do you think would happen in the real world ?
Do you really think anyone would bother putting one profile into DT and others
into some other database ? Not really, especially if the kernel would not even
support reading that other database. And if it would, you would not need the
DT data in the first place.

This is completely different to the intended use of devicetree information.
An instance of devicetree data should be tied to a specific piece of hardware.
Changing it may enable or disable pieces of that hardware, but change its
operation, as in "optimize for performance" or "optimize for low power
consumption" ? Yes, again, I understand you are saying that this is not the
_intent_, but that is what it enables.

Other but related subject .. from a thermal / hwmon driver's perspective, if
such a driver supports thermal subsystem, it should just register itself as
thermal sensor device, because that is what it is. If and how it is tied to
cooling devices should be part of the thermal subsystem and be decided there.
I don't think it is necessary for a thermal sensor to read devicetree data
in order to determine if it is supposed to register as thermal device or not.
That _is_ configuration and does not describe hardware - the mere fact that
a thermal sensor exists in the system already identifies it as thermal sensor
device, not anything in devicetree data. This would be similar to, say, a clock
device. A clock is a clock, and registers itself with the clock subsystem even
if there is no consumer. Sure, its interconnection with clock consumers would
be determined by devicetree data, but that is a different subject. So, even if
devicetree maintainers accept your definition of thermal profiles as hardware,
I think your approach is still wrong, and a thermal sensor device should
register itself as thermal device independently of its association with
cooling devices.

Thanks,
Guenter
