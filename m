Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaBOLjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 06:39:54 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44406 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaBOLjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 06:39:51 -0500
Message-ID: <52FF5220.3010702@kernel.org>
Date: Sat, 15 Feb 2014 11:40:16 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matt Porter <mporter@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Linux IIO List <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 4/6] iio: Add ABI docs for pulse capture devices
References: <1391626901-31684-1-git-send-email-mporter@linaro.org> <1391626901-31684-5-git-send-email-mporter@linaro.org>
In-Reply-To: <1391626901-31684-5-git-send-email-mporter@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 19:01, Matt Porter wrote:
> Add standard ABI entries for pulse capture devices. Also add
> a separate ABI entry for the TI ECAP driver polarity option.
>
> Signed-off-by: Matt Porter <mporter@linaro.org>
Lars, I've cc'd you for the various Analog devices dds and frequency devices.
Ideally we want a consistent interface for devices capturing info about these
waveforms and devices generating them.  Please CC anyone else who might have
opinions.  This interface is not obvious, so we need to spend some time getting
it right.
> ---
>   Documentation/ABI/testing/sysfs-bus-iio              | 18 ++++++++++++++++++
>   Documentation/ABI/testing/sysfs-bus-iio-pulse-tiecap |  9 +++++++++
>   2 files changed, 27 insertions(+)
>   create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-pulse-tiecap
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 6e02c50..918a201 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -210,6 +210,14 @@ Contact:	linux-iio@vger.kernel.org
>   Description:
>   		Scaled humidity measurement in milli percent.
>
> +What:		/sys/bus/iio/devices/iio:deviceX/in_pulseY_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_pulse_raw
> +KernelVersion:	3.15
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Raw pulse measurement from channel Y. Units after
> +		application of scale and offset are nanoseconds.
> +
I wonder if we are being a little bit too specific in this interface.  What other things
might we want to capture about a pulse?  Right now you have it either capturing the
'high width' or the 'low width'.  Presumably there are devices that will capture
both via different 'channels'?

So lets list what we might capture about a wave - including values computable from
the base quantities.
* High time
* Low time
* Mark Space Ratio
* Period (rising edge to rising edge  or falling edge to falling edge).
(This might be treated as instantaneous frequency - as would be done in
frequency modulation)
* Peak to peak Amplitude.

For imperfect waves
* Rise time,
* Fall time,

Funnily enough this is pretty much what an oscilloscope will allow you to automatically
measure on a square wave...

So next question is base units for the time measurements.
I'd prefer the base to be seconds rather than nano seconds
for consistency with the other time measurements already in the ABI.  All it will do is
change the type for scale factors output in sysfs.  Userspace can trivially convert
back to nano seconds if that is what it wants.  If we need to futher expand our small
units, then that is fine.

Next, the question is do we want to cover other waveform types. The dds drivers that
are most relevant are still in staging, so we can mess around with their interfaces
without 'too' much pain.  They allow specifying of a waveform 'type' (square, triangle,
sine so far I think).

So do we want to have an iio type corresponding to a time feature of a waveform then
use modifiers for the various characteristics. I'll describe this in the sysfs attribute
names (they translate directly into the buffer channels, but are easier to read!)


We do have a few modifiers that lead to different units already so there is precedence
e.g. IIO_MOD_SUM_SQUARED_X_Y_Z, (often (m/s^2)^2
for the following (as long as well documented!)
in_waveformX_type - (Square, triangle etc).

in_waveformX_hightime_raw
in_waveformX_lowtime_raw
in_waveformX_period_raw
in_waveformX_markspace_raw
in_waveformX_peaktopeak_raw (similar to existing peak abi elements - these are not typically
                             read from a buffer and hence we have rushed them in as a modifier).
in_waveformX_risetime_raw
in_waveformX_falltime_raw


Would this work for both this sort of capture device and for synthesis chips?



>   What:		/sys/bus/iio/devices/iio:deviceX/in_accel_offset
>   What:		/sys/bus/iio/devices/iio:deviceX/in_accel_x_offset
>   What:		/sys/bus/iio/devices/iio:deviceX/in_accel_y_offset
> @@ -220,6 +228,8 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_tempY_offset
>   What:		/sys/bus/iio/devices/iio:deviceX/in_temp_offset
>   What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_offset
>   What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_offset
> +What:		/sys/bus/iio/devices/iio:deviceX/in_pulseY_offset
> +What:		/sys/bus/iio/devices/iio:deviceX/in_pulse_offset
>   KernelVersion:	2.6.35
>   Contact:	linux-iio@vger.kernel.org
>   Description:
> @@ -251,6 +261,8 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_z_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_pulseY_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_pulse_scale
>   KernelVersion:	2.6.35
>   Contact:	linux-iio@vger.kernel.org
>   Description:
> @@ -784,6 +796,8 @@ What:		/sys/.../iio:deviceX/scan_elements/in_incli_x_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_incli_y_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_pressureY_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_pressure_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_pulseY_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_pulse_en
>   KernelVersion:	2.6.37
>   Contact:	linux-iio@vger.kernel.org
>   Description:
> @@ -799,6 +813,8 @@ What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_supply_type
>   What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_type
>   What:		/sys/.../iio:deviceX/scan_elements/in_pressureY_type
>   What:		/sys/.../iio:deviceX/scan_elements/in_pressure_type
> +What:		/sys/.../iio:deviceX/scan_elements/in_pulseY_type
> +What:		/sys/.../iio:deviceX/scan_elements/in_pulse_type
>   KernelVersion:	2.6.37
>   Contact:	linux-iio@vger.kernel.org
>   Description:
> @@ -845,6 +861,8 @@ What:		/sys/.../iio:deviceX/scan_elements/in_incli_y_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_pressureY_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_pressure_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_pulseY_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_pulse_index
>   KernelVersion:	2.6.37
>   Contact:	linux-iio@vger.kernel.org
>   Description:
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-pulse-tiecap b/Documentation/ABI/testing/sysfs-bus-iio-pulse-tiecap
> new file mode 100644
> index 0000000..a9e4a9f
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-pulse-tiecap
> @@ -0,0 +1,9 @@
> +What:		/sys/bus/iio/devices/iio:deviceX/pulse_polarityY
> +What:		/sys/bus/iio/devices/iio:deviceX/pulse_polarity
> +Date:		January 2014
> +KernelVersion:	3.15
> +Contact:	Matt Porter <mporter@linaro.org>
> +Description:
> +		Get and set the polarity of the pulse signal to be captured
> +		for channel Y.  1 indicates a high pulse signal and 0
> +		indicates a low pulse signal.
>

