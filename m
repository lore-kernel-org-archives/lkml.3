Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3AUKMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:12:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18317 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3AUKKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Jan 2013 02:08:57 -0800
Message-ID: <50FD1402.4050502@nvidia.com>
Date: Mon, 21 Jan 2013 18:10:10 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Durgadoss R <durgadoss.r@intel.com>
CC: <swarren@wwwdotorg.org>, "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>
Subject: Re: [PATCHv2 0/9] Thermal Framework Enhancements
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
In-Reply-To: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/07/2013 03:13 PM, Durgadoss R wrote:
> This patch set is a v2 of the previous versions submitted here:
> [v1]:  https://lkml.org/lkml/2012/12/18/108 
> [RFC]: https://patchwork.kernel.org/patch/1758921/
> 
> This patch set is based on Rui's -thermal tree, and is
> tested on a Core-i5 and an Atom netbook.
> 
> Changes Since v1:
>  * Removed kobject creation for thermal_trip and thermal_map
>    nodes as per Greg-KH's comments.
>  * Added ABI Documentation under 'testing'.
>  * Modified the GET_INDEX macro to be more linux-like, thanks
>    to Joe Perches.
>  * Added get_[sensor/cdev]_by_name APIs to thermal.h
> 
> This series contains 9 patches:
> Patch 1/9: Creates new sensor level APIs
> Patch 2/9: Creates new zone level APIs. The existing tzd structure is
>            kept as such for clarity and compatibility purposes.
> Patch 3/9: Creates functions to add/remove a cdev to/from a zone. The
>            existing tcd structure need not be modified.
> Patch 4/9: Adds sensorX_trip_[active/passive/hot/critical] sysfs nodes,
> 	   under /sys/class/thermal/zoneY/. This exposes various trip
>            points for sensorX present in zoneY.
> Patch 5/9: Adds mapX sysfs node. It is a compact representation
>            of the binding relationship between a sensor and a cdev,
>            within a zone.
> Patch 6/9: Creates Documentation for the new APIs. A new file is
>            created for clarity. Final goal is to merge with the existing
>            file or refactor the files, as whatever seems appropriate.
> Patch 7/9: Make PER ZONE values configurable through Kconfig
> Patch 8/9: Add ABI documentation for sysfs interfaces introduced in this patch.
> Patch 9/9: A dummy driver that can be used for testing. This is not for merge.
> 
> Thanks to Greg-KH, Hongbo Zhang and Joe Perches for their comments on v1.
> 
> Durgadoss R (9):
>   Thermal: Create sensor level APIs
>   Thermal: Create zone level APIs
>   Thermal: Add APIs to bind cdev to new zone structure
>   Thermal: Add trip point sysfs nodes for sensor
>   Thermal: Create 'mapX' sysfs node for a zone
>   Thermal: Add Documentation to new APIs
>   Thermal: Make PER_ZONE values configurable
>   Thermal: Add ABI Documentation for sysfs interfaces
>   Thermal: Dummy driver used for testing
> 
>  Documentation/ABI/testing/sysfs-class-thermal |   93 +++
>  Documentation/thermal/sysfs-api2.txt          |  248 +++++++
>  drivers/thermal/Kconfig                       |   19 +
>  drivers/thermal/Makefile                      |    3 +
>  drivers/thermal/thermal_sys.c                 |  881 +++++++++++++++++++++++++
>  drivers/thermal/thermal_test.c                |  315 +++++++++
>  include/linux/thermal.h                       |  117 +++-
>  7 files changed, 1675 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-thermal
>  create mode 100644 Documentation/thermal/sysfs-api2.txt
>  create mode 100644 drivers/thermal/thermal_test.c

Hi, Durgadoss
Did you think about how to use this framework for the device tree.
for example, we add a dt node for the lm90 sensor:
lm90: lm90@4c {
    compatible = "lm90";
    ......;
};
This sensor driver can register two sensors to the thermal framework,
which are named as "lm90_remote" and "lm90_local". If we want to add the
"lm90_remote" in the thermal zone, we could add nodes like this:
xxx-thermal {
    compatible = "xxxx";
    sensor-name = "lm90_remote";
    ......;
}
then the xxx-thermal driver can read the sensor-name and use
get_sensor_by_name() to get the snesor.

But this is not the canonical DT way. We think it's better to use
pandle+args to get that sensor, something like this
lm90: lm90@4c {
    compatible = "lm90";
    #sensor-cells = <1>;
    ......;
};
xxx-thermal {
    compatible = "xxxx";
    sensors = <&lm90 0>;
    ......;
}
If we want to use this way, we need to add new APIs to decode it.

Do you have any idea for this issue?

Thanks.
Wei.
> 

