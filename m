Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaJXWbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:31:46 -0400
Received: from mout.gmx.net ([212.227.17.21]:56847 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905AbaJXWbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:31:44 -0400
Message-ID: <544AD34A.9070005@gmx.de>
Date: Sat, 25 Oct 2014 00:31:38 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org
CC: irina.tirdea@intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/7] iio: core: Introduce STEPS channel
 type, ENABLE mask and INSTANCE event
References: <1412858385-11954-1-git-send-email-daniel.baluta@intel.com> <1412858385-11954-5-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1412858385-11954-5-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:3keKRB+Wg5DNUuFP5HaN9+CDz89l1/AYY16YTw4xLpafQAsAz4J
 3SFohG58YViRSX6W05gOrlsZ2chgrzs3++W2ZwVD8YO9HzDjzu7eeqcdHqj/EBvA7TOBRwm
 0CGMG2EtT6Uu+VQjOhUy0LZN3V5yDSEJJDjuLOhMDNZvuV39ciOqCRIyLXAX9c3CRmqaoYJ
 C2jIPwjKfDj+iNIyw+5dg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta schrieb am 09.10.2014 14:39:
> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> These changes are needed to support the functionality of a pedometer.
> A pedometer has two basic functionalities: step counter and step detector.
> 
> The step counter needs to be enabled and then it will count the steps
> in its hardware register. Whenever the application needs to check
> the step count, it will read the step counter register. To support the
> step counter a new channel type STEPS is added. Since the pedometer needs
> to be enabled first so that the hardware can count and store the steps,
> we need a specific ENABLE channel info mask.
> 
> The step detector will generate an interrupt each time a step is detected.
> To support this functionality we add a new event type INSTANCE.
> 
Hi,
I was wondering, if it would be better to name this channel somehow more generic. What you are actually counting are some pulses, and only the implementation of the hardware leads to the interpretation of these pulses as for example steps.
Other devices for this category would be pulse counters - either stand alone, or as part of SoCs. Some use cases I could think of are: liquid/gas flow measurements, engine rotation/RPM counts, object counts, ...
Any opinions?
Thanks

Hartmut
> For more information on the Android requirements for step counter and step
> detector see:
> http://source.android.com/devices/sensors/composite_sensors.html#counter
> and http://source.android.com/devices/sensors/composite_sensors.html#detector.
> 
> A device that has the pedometer functionality this interface needs to
> support is Freescale's MMA9553L:
> http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-iio | 22 ++++++++++++++++++++++
>  drivers/iio/industrialio-core.c         |  2 ++
>  drivers/iio/industrialio-event.c        |  1 +
>  include/linux/iio/iio.h                 |  1 +
>  include/linux/iio/types.h               |  2 ++
>  5 files changed, 28 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 12d0385..3557a69 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -842,6 +842,13 @@ Description:
>  		number or direction is not specified, applies to all channels of
>  		this type.
>  
> +What:		/sys/.../events/in_steps_instance_en
> +KernelVersion:	3.19
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Enables or disables step detection. Each time the user takes a step an
> +		event of this type will be generated.
> +
>  What:		/sys/bus/iio/devices/iio:deviceX/trigger/current_trigger
>  KernelVersion:	2.6.35
>  Contact:	linux-iio@vger.kernel.org
> @@ -1072,3 +1079,18 @@ Contact:	linux-iio@vger.kernel.org
>  Description:
>  		Raw value of rotation from true/magnetic north measured with
>  		or without compensation from tilt sensors.
> +
> +What:		/sys/.../iio:deviceX/in_steps_enable
> +KernelVersion:	3.19
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Activates the step counter. After activation, the number of steps
> +		taken by the user will be counted in hardware and exported through
> +		in_steps_input.
> +
> +What:		/sys/.../iio:deviceX/in_steps_input
> +KernelVersion:	3.19
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This attribute is used to read the number of steps taken by the user
> +		since the last reboot while activated.
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index e453ef9..1e060f3 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -71,6 +71,7 @@ static const char * const iio_chan_type_name_spec[] = {
>  	[IIO_PRESSURE] = "pressure",
>  	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
>  	[IIO_ACTIVITY] = "activity",
> +	[IIO_STEPS] = "steps",
>  };
>  
>  static const char * const iio_modifier_names[] = {
> @@ -118,6 +119,7 @@ static const char * const iio_chan_info_postfix[] = {
>  	[IIO_CHAN_INFO_HARDWAREGAIN] = "hardwaregain",
>  	[IIO_CHAN_INFO_HYSTERESIS] = "hysteresis",
>  	[IIO_CHAN_INFO_INT_TIME] = "integration_time",
> +	[IIO_CHAN_INFO_ENABLE] = "en",
>  };
>  
>  /**
> diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
> index a9c9f34..db63d29 100644
> --- a/drivers/iio/industrialio-event.c
> +++ b/drivers/iio/industrialio-event.c
> @@ -198,6 +198,7 @@ static const char * const iio_ev_type_text[] = {
>  	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
>  	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
>  	[IIO_EV_TYPE_TRANSITION] = "transition",
> +	[IIO_EV_TYPE_INSTANCE] = "instance",
>  };
>  
>  static const char * const iio_ev_dir_text[] = {
> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
> index 15dc6bc..3d3f06f 100644
> --- a/include/linux/iio/iio.h
> +++ b/include/linux/iio/iio.h
> @@ -37,6 +37,7 @@ enum iio_chan_info_enum {
>  	IIO_CHAN_INFO_HARDWAREGAIN,
>  	IIO_CHAN_INFO_HYSTERESIS,
>  	IIO_CHAN_INFO_INT_TIME,
> +	IIO_CHAN_INFO_ENABLE,
>  };
>  
>  enum iio_shared_by {
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index 9a1cc01..af0b6e0 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -31,6 +31,7 @@ enum iio_chan_type {
>  	IIO_PRESSURE,
>  	IIO_HUMIDITYRELATIVE,
>  	IIO_ACTIVITY,
> +	IIO_STEPS,
>  };
>  
>  enum iio_modifier {
> @@ -74,6 +75,7 @@ enum iio_event_type {
>  	IIO_EV_TYPE_THRESH_ADAPTIVE,
>  	IIO_EV_TYPE_MAG_ADAPTIVE,
>  	IIO_EV_TYPE_TRANSITION,
> +	IIO_EV_TYPE_INSTANCE,
>  };
>  
>  enum iio_event_info {
> 

