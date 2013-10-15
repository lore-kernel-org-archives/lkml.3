Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab3JOLWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:22:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:47974 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851Ab3JOLWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:22:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,498,1378882800"; 
   d="scan'208";a="307952094"
Message-ID: <1381836130.2080.56.camel@rzhang1-mobl4>
Subject: Re: [PATCHv4 0/9] Thermal Framework Enhancements
From: Zhang Rui <rui.zhang@intel.com>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: eduardo.valentin@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com,
        wni@nvidia.com
Date: Tue, 15 Oct 2013 19:22:10 +0800
In-Reply-To: <1380652688-5787-1-git-send-email-durgadoss.r@intel.com>
References: <1380652688-5787-1-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Durga,

On Wed, 2013-10-02 at 00:07 +0530, Durgadoss R wrote:
> This patch set is a v4 of the previous versions submitted here:
> [v3]: https://lkml.org/lkml/2013/2/5/228 
> [v2]: http://lwn.net/Articles/531720/
> [v1]: https://lkml.org/lkml/2012/12/18/108 
> [RFC]:https://patchwork.kernel.org/patch/1758921/
> 
> This patch set is based on Rui's -next tree, on top
> of commit 'f61d5b4d52e077756ce9dbc47ce737da898ad01d'
> This is tested on a Core-i5 and an Atom netbook,
> running ubuntu 12.04.
> 
> Changes since v3:
>  * Added a patch to conditionally do kfree(cdev) in
>    thermal_release function.
>  * Reworked all sysfs attributes to have one value per file
>    This includes sensor_trip_* and map_weight* attributes.
>  * Added 'lock' variable in thermal_zone structure to
>    protect its members.
>  * Added Documentation to all functions in thermal_core.c
>  * Changes all strcpy() to strlcpy()
>  * Used devm_kzalloc() in places where applicable
>  * Address some buffer overflow conditions and contentions
>    in tz->sensors[] and tz->cdevs[].
> Changes since v2:
>  * Reworked the map sysfs attributes in patch [5/8]
>  * Dropped configuration for maximum sensors and
>    cooling devices, through Kconfig.
>  * Added __remove_trip_attr method
>  * Renamed __clean_map_entry to __remove_map_entry
>    for consistency in naming.
> Changes Since v1:
>  * Removed kobject creation for thermal_trip and thermal_map
>    nodes as per Greg-KH's comments.
>  * Added ABI Documentation under 'testing'.
>  * Modified the GET_INDEX macro to be more linux-like, thanks
>    to Joe Perches.
>  * Added get_[sensor/cdev]_by_name APIs to thermal.h
> 
> This series contains 9 patches:
> Patch 1/9: Fixes a kfree issue. This is required so that the new sensor
> 	   and zone devices are not freed accidently.
> 	   We can do two things here:
> 	   1) Conditionally free every device
> 	   2) Remove this _release function, and free the memory
>               in corresponding _unregister functions.
> 	   I prefer 2) and we can have this as a separate patch
> 	   outside this series; but would like to see the opinion
> 	   of maintainers'.
this is a general fix that I will push it in next merge window.

> Patch 2/9: Creates new sensor level APIs
> Patch 3/9: Creates new zone level APIs. The existing tzd structure is
>            kept as such for clarity and compatibility purposes.
> Patch 4/9: Creates functions to add/remove a cdev to/from a zone. The
>            existing tcd structure need not be modified.
> Patch 5/9: Adds sensorX_trip_[active/passive/hot/critical] sysfs nodes,
> 	   under /sys/class/thermal/zoneY/. This exposes various trip
>            points for sensorX present in zoneY.
> Patch 6/9: Adds mapY_* sysfs node. These attributes represent

After reading these patch, here are some questions,
1. this patch set introduces a new thermal sysfs I/F layout, but in
fact, the thermal core can do nothing except exposing those interfaces.
Say, no thermal policy is supported in the new hierarchy, i.e. we can
not take any cooling action from kernel side, right?
2. as we are introducing three new devices, and these devices will not
invoke the existing thermal core functions. Then there are few things
left that can be shared between the current thermal model and your new
one. Thus, can we have a separate .c file for the new code only?

I'm not sure if you have time to do this, if yes, can you please rebase
the patch set and send it out ASAP, if no, I can work on this stuff and
re-base your patches. what do you think?

thanks,
rui
> Patch 7/9: Creates Documentation for the new APIs. A new file is
>            created for clarity. Final goal is to merge with the existing
>            file or refactor the files, as whatever seems appropriate.
> Patch 8/9: Add ABI documentation for sysfs interfaces introduced in this patch.
> Patch 9/9: A dummy driver that can be used for testing. This is not for merge.
> 
> Sorry for the long delay in resubmitting this patch set.
> Thanks to Eduardo, Wei Ni, for their comments on v3.
> 
> Durgadoss R (9):
>   Thermal: Check for validity before doing kfree
>   Thermal: Create sensor level APIs
>   Thermal: Create zone level APIs
>   Thermal: Add APIs to bind cdev to new zone structure
>   Thermal: Add trip point sysfs nodes for sensor
>   Thermal: Create Thermal map sysfs attributes for a zone
>   Thermal: Add Documentation to new APIs
>   Thermal: Add ABI Documentation for sysfs interfaces
>   Thermal: Dummy driver used for testing
> 
>  Documentation/ABI/testing/sysfs-class-thermal |  137 +++
>  Documentation/thermal/sysfs-api2.txt          |  248 +++++
>  drivers/thermal/Kconfig                       |    5 +
>  drivers/thermal/Makefile                      |    3 +
>  drivers/thermal/thermal_core.c                | 1406 +++++++++++++++++++++++--
>  drivers/thermal/thermal_test.c                |  322 ++++++
>  include/linux/thermal.h                       |  127 ++-
>  7 files changed, 2180 insertions(+), 68 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-thermal
>  create mode 100644 Documentation/thermal/sysfs-api2.txt
>  create mode 100644 drivers/thermal/thermal_test.c
> 


