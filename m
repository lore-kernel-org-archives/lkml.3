Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaJYTYk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:24:40 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49945 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaJYTYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:24:39 -0400
Message-ID: <544BF8F4.1020406@kernel.org>
Date: Sat, 25 Oct 2014 20:24:36 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>
CC: irina.tirdea@intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/7] iio: core: Introduce HEIGHT channel type
References: <1412858385-11954-1-git-send-email-daniel.baluta@intel.com> <1412858385-11954-6-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1412858385-11954-6-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/14 13:39, Daniel Baluta wrote:
> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> Some devices need the height of the user to compute various
> parameters. One of this devices is Freescale's MMA9553L
> (http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
> that needs the height of the user to compute the stride length which
> is used further to determine distance, speed and activity type.
> 
> Introduce a new channel type HEIGHT to export these values.

Now I'd love to make this generic as
in_distance_z_input etc but I guess that's pretty confusing for users ;)
Sadly altitude is going to be even more confusing.

I wonder if we should make this more explicit and have it as
in_steps_calibheight (repeated for all the channels whose computation
it effects).  It's really a parameter of those channels rather than on
its own.

It should be out_height_input etc given you are setting it (like a trim
DAC on some ADC setup)

The there is an implication as that you are changing the users height
which, whilst it would be 'interesting', is probably the wrong impression!

*laughs* Maybe you were right to keep this an RFC for now ;)
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-iio | 9 +++++++++
>  drivers/iio/industrialio-core.c         | 1 +
>  include/linux/iio/types.h               | 1 +
>  3 files changed, 11 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 3557a69..fc027cb 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -256,6 +256,7 @@ What:		/sys/bus/iio/devices/iio:deviceX/out_altvoltageY_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_accel_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_accel_peak_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_anglvel_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_height_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_magn_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_scale
> @@ -1010,6 +1011,14 @@ Description:
>  		For a list of available output power modes read
>  		in_accel_power_mode_available.
>  
> +What:		/sys/.../iio:deviceX/in_height_input
> +What:		/sys/.../iio:deviceX/in_height_raw
> +KernelVersion:	3.17
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This attribute is used to set and read the user's height.
> +		Units after application of scale are centimeters.
> +
>  What:		/sys/bus/iio/devices/iio:deviceX/store_eeprom
>  KernelVersion:	3.4.0
>  Contact:	linux-iio@vger.kernel.org
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index 1e060f3..f08b278 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -72,6 +72,7 @@ static const char * const iio_chan_type_name_spec[] = {
>  	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
>  	[IIO_ACTIVITY] = "activity",
>  	[IIO_STEPS] = "steps",
> +	[IIO_HEIGHT] = "height",
>  };
>  
>  static const char * const iio_modifier_names[] = {
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index af0b6e0..a23b2e7 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -32,6 +32,7 @@ enum iio_chan_type {
>  	IIO_HUMIDITYRELATIVE,
>  	IIO_ACTIVITY,
>  	IIO_STEPS,
> +	IIO_HEIGHT,
>  };
>  
>  enum iio_modifier {
> 
