Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab3GXKpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:45:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62497 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820Ab3GXKps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:45:48 -0400
Date: Wed, 24 Jul 2013 11:45:42 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Durgadoss R <durgadoss.r@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>, Wei Ni <wni@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: device thermal limits represented in device tree nodes
Message-ID: <20130724104542.GB306@e106331-lin.cambridge.arm.com>
References: <51ED40E3.5020703@ti.com>
 <51EF3186.9060001@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EF3186.9060001@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 02:44:38AM +0100, Stephen Warren wrote:
> On 07/22/2013 07:25 AM, Eduardo Valentin wrote:
> > Hello Grant and Rob,
> > 
> > (Resending, as I got a message saying: 
> > <devicetree-discuss@lists.ozlabs.org>: Recipient address rejected:
> > User has moved to devicetree at vger.kernel.org)
> > 
> > I am writing this email to you specifically to ask your technical 
> > assessment with respect to representing device thermal limits as
> > device tree nodes. I am proposing to introduce device tree nodes to
> > describe these limits as thermal zones, their composition and their
> > relations with cooling devices and other thermal zones (thermal
> > data).
> 
> Given:
> https://lkml.org/lkml/2013/7/20/69
> [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
> 
> I'm explicitly CCing a few people besides Grant/Rob, and qouting the
> whole email.
> 
> From my perspective, the concept of including thermal limits in DT
> seems reasonable, although I haven't looked at the proposed binding
> itself in detail yet.

The concept of defining hard thermal limits in DT certianly seems
reasonable.

>From a quick look at the version on lkml [1], it seems like this leaks a
Linux implementation details (e.g. governer names) into the binding, and
I think that the linkage of devices to thermal zones should be definedd
more explicitly. A reposting of the series to devicetree (and lakml?)
would be helpful for review.

Thanks,
Mark.

[1] https://lkml.org/lkml/2013/7/17/379

> 
> > As you should know, device thermal limits are part of hardware 
> > specification. Considering your board layout, mechanics, power 
> > dissipation and composition of ICs, etc, that will impose thermal 
> > requirements on your system, and infringing these limits can lead
> > to device damage, device life time reduction or even end user harm.
> > Thus, the thermal data help to describe the hardware limits and
> > what needs to be done if those limits are crosses, as part of your
> > board design and non-functional requirements. Obviously that is
> > very dependent on your hardware, and not all of them will have
> > these non-functional requirements. Besides, describing these limits
> > has *nothing* to do with how you actually find these limits.
> > 
> > In any case, there is a need to properly represent these
> > requirements and I am proposing to have this representation in
> > device tree. There were already couple of counter-arguments
> > claiming this is actually about configuration and performance
> > profile description. But I still stand against these two readings
> > of this proposal and again state that if one interprets it as
> > configuration or performance profile, that is a mis-understanding
> > [0]. Let me state it clear (again [1]), my proposal is to describe
> > hardware thermal limits, because these limits are part of a 
> > hardware specification; representing in device tree would not
> > infringe the original purpose of this data structure  ("The Device
> > Tree is a data structure for describing hardware."[2]).
> > 
> > Before I explain my proposal, I want to highlight also that these
> > data is represented elsewhere already and it is reused across
> > different OS's. Thermal data is described using ACPI [3] and
> > operating systems ACPI-aware do support the interpretation of
> > thermal data. Linux is one example of such systems (I believe I do
> > not need to enlist here all systems supporting ACPI). On the other
> > hand, not all systems have ACPI or are specified to use ACPI.
> > Thus, here is another reason to represent properly thermal data, so
> > that we can scale across systems.
> > 
> > In the specific case of Linux, the common thermal concepts between
> > ACPI systems and non-ACPI systems have been represented in the
> > thermal framework (CONFIG_THERMAL). Today, on ACPI systems, thermal
> > data is fetched from bootloader with help from the common ACPI
> > parser. For non-ACPI systems, the thermal data is actually coded as
> > part of device drivers.
> > 
> > So, to the point, a brief explanation of my proposal goes as
> > follows: i   - trip points: a node to describe a point in the
> > temperature domain in which the system has to take an action. This
> > node describes just the point, not the action. Properties here are
> > temperature, hysteresis, and type (critical, hot, passive, active,
> > etc). ii  - binding parameters: the bind_param node is a node to
> > describe how actions (cooling devices) get assigned to trip points.
> > Cooling devices are expected to be loaded in the target system.
> > Properties here are: cooling device name, weight, trip_mask and
> > limits. iii - thermal zones: the thermal_zone node is the node
> > containing all the required info for describing a thermal zone with
> > hardware thermal limitation, including its bindings with cooling
> > devices. Properties here are:  type, passive_delay, polling_delay,
> > governor. The thermal_zone node must contain, apart from its own
> > properties, one node containing trip nodes and one node containing
> > all the zone bind parameters.
> > 
> > Here is an example (on OMAP4430): thermal_zone { type = "CPU"; mask
> > = <0x03>; /* trips writability */ passive_delay = <250>; /*
> > milliseconds */ polling_delay = <1000>; /* milliseconds */ governor
> > = "step_wise"; trips { alert@100000{ temperature = <100000>; /*
> > milliCelsius hysteresis = <2000>; /* milliCelsius */ type =
> > <THERMAL_TRIP_PASSIVE>; }; crit@125000{ temperature = <125000>; /*
> > milliCelsius hysteresis = <2000>; /* milliCelsius */ type =
> > <THERMAL_TRIP_CRITICAL>; }; }; bind_params { action@0{ 
> > cooling_device = "thermal-cpufreq"; weight = <100>; /* percentage
> > */ mask = <0x01>; /* no limits, using defaults */ }; }; };
> > 
> > In this current proposal, a 'thermal_zone' node would be embedded
> > inside a temperature sensor node, for simplicity. But other
> > possible builds could embedded them in the device with thermal
> > limits (CPU nodes, for instance) or they could be not embedded in
> > any specific node.
> > 
> > A full documented description can be found here [4]. Also a branch 
> > containing: (a) needed changes in order to have this DT parser; (b)
> > the DT parser with documentation (c) examples on how drivers could
> > be changes to use the parser can be found in my branch here [5]. I
> > wrote the thermal DT parser to build thermal zones with the thermal
> > framework API. However, if one does not want to do that, it can
> > simple do not include a CONFIG_THERMAL_OF=y in her/his build, and
> > the calls will be translated to nops, and the device tree thermal
> > data can be parsed to somewhere else interested (other subsystem or
> > even user land). A TODO on this implementation is that it still
> > lacks the representation of thermal zones composed by several
> > sensors. However, I believe it is better to take an incremental 
> > approach here.  This series can already be used to improve most of
> > the existing platform thermal drivers (most are CPU thermal
> > drivers) and to reuse the existing code of some hwmon sensors to
> > build thermal zones for board thermal requirements.
> > 
> > I have already posted a patch series with this proposal on [6],
> > that contains a reference for the original RFC. But looks like my
> > messages got moderated on device tree mailing list. Obviously,
> > within PM forum, feedback was quite positive. However, we cannot
> > proceed without proper assessment of other subsystems. lm-sensors
> > folks (Guenter) seam to be strongly against this series, as there
> > is a fear that this may introduce a mis-usage of DT. I still
> > believe this is needed for  hardware description, and thus not a
> > infringement on DT purposes.
> > 
> > Please let me know your thoughts on this topic and apologize me if
> > my previous messages on this topic did not reach you (hope they
> > reach now).
> > 
> > All best,
> > 
> > Eduardo Valentin
> > 
> > [0] - https://lkml.org/lkml/2013/7/17/621 [1] -
> > https://lkml.org/lkml/2013/7/18/279 [2] - www.devicetree.org [3] -
> > http://www.acpi.info/ [4] - 
> > https://git.kernel.org/cgit/linux/kernel/git/evalenti/linux.git/diff/Documentation/devicetree/bindings/thermal/thermal.txt?h=thermal_work/thermal_core/dt_parser&id=405bf0b51457ed055a082af2653d7ce757bc2e91
> >
> > 
> [5] -
> > https://git.kernel.org/cgit/linux/kernel/git/evalenti/linux.git/log/?h=thermal_work/thermal_core/dt_parser
> >
> > 
> [6] - https://lkml.org/lkml/2013/7/17/923
> > 
> > 
> 
> 
