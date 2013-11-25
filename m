Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab3KYPh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:37:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60788 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421Ab3KYPhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:37:24 -0500
Date: Mon, 25 Nov 2013 15:37:21 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
Message-ID: <20131125153721.GH32081@e106331-lin.cambridge.arm.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
 <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 07:46:04PM +0000, Eduardo Valentin wrote:
> This patch introduces a device tree bindings for
> describing the hardware thermal behavior and limits.
> Also a parser to read and interpret the data and feed
> it in the thermal framework is presented.
> 
> This patch introduces a thermal data parser for device
> tree. The parsed data is used to build thermal zones
> and thermal binding parameters. The output data
> can then be used to deploy thermal policies.
> 
> This patch adds also documentation regarding this
> API and how to define tree nodes to use
> this infrastructure.
> 
> Note that, in order to be able to have control
> on the sensor registration on the DT thermal zone,
> it was required to allow changing the thermal zone
> .get_temp callback. For this reason, this patch
> also removes the 'const' modifier from the .ops
> field of thermal zone devices.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
> 
> Hello all,
> 
> Very minor changes from v8 to v9.
> 
> Changelog:
> 
> - Rephrase a couple of sentences in the binding document
> - Fixed a couple of property types in the binding document
> - Removed the constant macro definitions for trip type. This
> change also affected the bindings posted on patches 09/14/15.
> 
>  .../devicetree/bindings/thermal/thermal.txt        | 586 ++++++++++++++
>  drivers/thermal/Kconfig                            |  13 +
>  drivers/thermal/Makefile                           |   1 +
>  drivers/thermal/of-thermal.c                       | 849 +++++++++++++++++++++
>  drivers/thermal/thermal_core.c                     |   9 +-
>  drivers/thermal/thermal_core.h                     |   9 +
>  include/dt-bindings/thermal/thermal.h              |  17 +
>  include/linux/thermal.h                            |  28 +-
>  8 files changed, 1509 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/thermal/thermal.txt
>  create mode 100644 drivers/thermal/of-thermal.c
>  create mode 100644 include/dt-bindings/thermal/thermal.h
> 
> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
> new file mode 100644
> index 0000000..59f5bd2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
> @@ -0,0 +1,586 @@
> +* Thermal Framework Device Tree descriptor
> +
> +This file describes a generic binding to provide a way of
> +defining hardware thermal structure using device tree.
> +A thermal structure includes thermal zones and their components,
> +such as trip points, polling intervals, sensors and cooling devices
> +binding descriptors.
> +
> +The target of device tree thermal descriptors is to describe only
> +the hardware thermal aspects. The thermal device tree bindings are
> +not about how the system must control or which algorithm or policy
> +must be taken in place.
> +
> +There are five types of nodes involved to describe thermal bindings:
> +- thermal sensors: devices which may be used to take temperature
> +  measurements.
> +- cooling devices: devices which may be used to dissipate heat.
> +- trip points: describe key temperatures at which cooling is recommended. The
> +  set of points should be chosen based on hardware limits.
> +- cooling maps: used to describe links between trip points and cooling devices;
> +- thermal zones: used to describe thermal data within the hardware;
> +
> +The following is a description of each of these node types.
> +
> +* Thermal sensor devices
> +
> +Thermal sensor devices are nodes providing temperature sensing capabilities on
> +thermal zones. Typical devices are I2C ADC converters and bandgaps. These are
> +nodes providing temperature data to thermal zones. Thermal sensor devices may
> +control one or more internal sensors.
> +
> +Required property:
> +- #thermal-sensor-cells: Used to provide sensor device specific information
> +  Type: unsigned        while referring to it. Typically 0 on thermal sensor
> +  Size: one cell        nodes with only one sensor, and at least 1 on nodes
> +                        with several internal sensors, in order
> +                        to identify uniquely the sensor instances within
> +                        the IC. See thermal zone binding for more details
> +                        on how consumers refer to sensor devices.
> +
> +* Cooling device nodes
> +
> +Cooling devices are nodes providing control on power dissipation. There
> +are essentially two ways to provide control on power dissipation. First
> +is by means of regulating device performance, which is known as passive
> +cooling. A typical passive cooling is a CPU that has dynamic voltage and
> +frequency scaling (DVFS), and uses lower frequencies as cooling states.
> +Second is by means of activating devices in order to remove
> +the dissipated heat, which is known as active cooling, e.g. regulating
> +fan speeds. In both cases, cooling devices shall have a way to determine
> +the state of cooling in which the device is.
> +
> +Required properties:
> +- cooling-min-state:   An integer indicating the smallest
> +  Type: unsigned       cooling state accepted. Typically 0.
> +  Size: one cell
> +
> +- cooling-max-state:   An integer indicating the largest
> +  Type: unsigned       cooling state accepted.
> +  Size: one cell
> +
> +- #cooling-cells:      Used to provide cooling device specific information
> +  Type: unsigned       while referring to it. Must be at least 2, in order
> +  Size: one cell       to specify minimum and maximum cooling state used
> +                       in the reference. The first cell is the minimum
> +                       cooling state requested and the second cell is
> +                       the maximum cooling state requested in the reference.
> +                       See Cooling device maps section below for more details
> +                       on how consumers refer to cooling devices.

This is the point I'm still most concerned with, as it provides a
definite meaning to an otherwise abstract property. However, if you
believe this is sane and unlikely to be problematic, then I am happy to
leave the decision to you.

> +
> +* Trip points
> +
> +The trip node is a node to describe a point in the temperature domain
> +in which the system takes an action. This node describes just the point,
> +not the action.
> +
> +Required properties:
> +- temperature:         An integer indicating the trip temperature level,
> +  Type: signed         in millicelsius.
> +  Size: one cell
> +
> +- hysteresis:          A low hysteresis value on temperature property (above).
> +  Type: unsigned       This is a relative value, in millicelsius.
> +  Size: one cell
> +
> +- type:                        a string containing the trip type. Supported values are:

Get rid of the "Supported", that's a Linux detail.

s/Supported/expected/ ?

Given the discussion has otherwise boiled down to bits that I think can
change later, I'm happy to give my ack:

Acked-by: Mark Rutland <mark.rutland@arm.com>

I'll leave it to the others to fight against this if they still have
concerns.

Thanks,
Mark.
