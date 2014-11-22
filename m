Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaKVBwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 20:52:20 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48106 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbaKVBwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 20:52:19 -0500
Message-ID: <546FEC46.8010406@gmail.com>
Date: Fri, 21 Nov 2014 17:52:06 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-pm@vger.kernel.org, edubezval@gmail.com, rui.zhang@intel.com,
        computersforpeace@gmail.com
Subject: Re: [PATCH v2] thermal: provide an UAPI header file
References: <1416501177-17504-1-git-send-email-f.fainelli@gmail.com>
In-Reply-To: <1416501177-17504-1-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 08:32 AM, Florian Fainelli wrote:
> include/linux/thermal.h contains definitions for the Thermal generic
> netlink family, but none of the valuable information relevant to
> user-space such as the Genl family name, multicast group, version or
> command set and data types is exported to user-space.
> 
> Export all the relevant generic netlink information to user-space to
> make this genl family usable by user-space, and while at it, export
> THERMAL_NAME_LENGTH since it limits name length for thermal_hwmon
> devices.
> 
> Kbuild and MAINTAINERS are also updated accordingly to reflect this new
> file: include/uapi/linux/thermal.h.

I forgot to include the definition for the thermal_event structure which
is multi-casted through netlink, will resubmit with that.

> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
> - rebase against Eduardo's thermal/next tree
> 
>  MAINTAINERS                  |  1 +
>  include/linux/thermal.h      | 31 +------------------------------
>  include/uapi/linux/Kbuild    |  1 +
>  include/uapi/linux/thermal.h | 35 +++++++++++++++++++++++++++++++++++
>  4 files changed, 38 insertions(+), 30 deletions(-)
>  create mode 100644 include/uapi/linux/thermal.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c444907ccd69..790752a4fad2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9294,6 +9294,7 @@ Q:	https://patchwork.kernel.org/project/linux-pm/list/
>  S:	Supported
>  F:	drivers/thermal/
>  F:	include/linux/thermal.h
> +F:	include/uapi/linux/thermal.h
>  F:	include/linux/cpu_cooling.h
>  F:	Documentation/devicetree/bindings/thermal/
>  
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 5bc28a70014e..be959e9df06c 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -29,10 +29,10 @@
>  #include <linux/idr.h>
>  #include <linux/device.h>
>  #include <linux/workqueue.h>
> +#include <uapi/linux/thermal.h>
>  
>  #define THERMAL_TRIPS_NONE	-1
>  #define THERMAL_MAX_TRIPS	12
> -#define THERMAL_NAME_LENGTH	20
>  
>  /* invalid cooling state */
>  #define THERMAL_CSTATE_INVALID -1UL
> @@ -49,11 +49,6 @@
>  #define MILLICELSIUS_TO_DECI_KELVIN_WITH_OFFSET(t, off) (((t) / 100) + (off))
>  #define MILLICELSIUS_TO_DECI_KELVIN(t) MILLICELSIUS_TO_DECI_KELVIN_WITH_OFFSET(t, 2732)
>  
> -/* Adding event notification support elements */
> -#define THERMAL_GENL_FAMILY_NAME                "thermal_event"
> -#define THERMAL_GENL_VERSION                    0x01
> -#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_grp"
> -
>  /* Default Thermal Governor */
>  #if defined(CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE)
>  #define DEFAULT_THERMAL_GOVERNOR       "step_wise"
> @@ -86,30 +81,6 @@ enum thermal_trend {
>  	THERMAL_TREND_DROP_FULL, /* apply lowest cooling action */
>  };
>  
> -/* Events supported by Thermal Netlink */
> -enum events {
> -	THERMAL_AUX0,
> -	THERMAL_AUX1,
> -	THERMAL_CRITICAL,
> -	THERMAL_DEV_FAULT,
> -};
> -
> -/* attributes of thermal_genl_family */
> -enum {
> -	THERMAL_GENL_ATTR_UNSPEC,
> -	THERMAL_GENL_ATTR_EVENT,
> -	__THERMAL_GENL_ATTR_MAX,
> -};
> -#define THERMAL_GENL_ATTR_MAX (__THERMAL_GENL_ATTR_MAX - 1)
> -
> -/* commands supported by the thermal_genl_family */
> -enum {
> -	THERMAL_GENL_CMD_UNSPEC,
> -	THERMAL_GENL_CMD_EVENT,
> -	__THERMAL_GENL_CMD_MAX,
> -};
> -#define THERMAL_GENL_CMD_MAX (__THERMAL_GENL_CMD_MAX - 1)
> -
>  struct thermal_zone_device_ops {
>  	int (*bind) (struct thermal_zone_device *,
>  		     struct thermal_cooling_device *);
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index 4c94f31a8c99..a1943e2d1264 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -383,6 +383,7 @@ header-y += tcp.h
>  header-y += tcp_metrics.h
>  header-y += telephony.h
>  header-y += termios.h
> +header-y += thermal.h
>  header-y += time.h
>  header-y += times.h
>  header-y += timex.h
> diff --git a/include/uapi/linux/thermal.h b/include/uapi/linux/thermal.h
> new file mode 100644
> index 000000000000..ac5535855982
> --- /dev/null
> +++ b/include/uapi/linux/thermal.h
> @@ -0,0 +1,35 @@
> +#ifndef _UAPI_LINUX_THERMAL_H
> +#define _UAPI_LINUX_THERMAL_H
> +
> +#define THERMAL_NAME_LENGTH	20
> +
> +/* Adding event notification support elements */
> +#define THERMAL_GENL_FAMILY_NAME                "thermal_event"
> +#define THERMAL_GENL_VERSION                    0x01
> +#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_grp"
> +
> +/* Events supported by Thermal Netlink */
> +enum events {
> +	THERMAL_AUX0,
> +	THERMAL_AUX1,
> +	THERMAL_CRITICAL,
> +	THERMAL_DEV_FAULT,
> +};
> +
> +/* attributes of thermal_genl_family */
> +enum {
> +	THERMAL_GENL_ATTR_UNSPEC,
> +	THERMAL_GENL_ATTR_EVENT,
> +	__THERMAL_GENL_ATTR_MAX,
> +};
> +#define THERMAL_GENL_ATTR_MAX (__THERMAL_GENL_ATTR_MAX - 1)
> +
> +/* commands supported by the thermal_genl_family */
> +enum {
> +	THERMAL_GENL_CMD_UNSPEC,
> +	THERMAL_GENL_CMD_EVENT,
> +	__THERMAL_GENL_CMD_MAX,
> +};
> +#define THERMAL_GENL_CMD_MAX (__THERMAL_GENL_CMD_MAX - 1)
> +
> +#endif /* _UAPI_LINUX_THERMAL_H */
> 

