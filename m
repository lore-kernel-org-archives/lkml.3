Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3LRO3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:29:33 -0500
Received: from smtp207.alice.it ([82.57.200.103]:40645 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab3LRO3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:29:30 -0500
Date: Wed, 18 Dec 2013 15:29:26 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-kernel@vger.kernel.org, input-tools@lists.freedesktop.org
Subject: Re: [PATCH 4/4] Input: add motion-tracking ABS_* bits and docs
Message-Id: <20131218152926.5bd31cf7d46dc5ce68bbfd0a@studenti.unina.it>
In-Reply-To: <1387295334-1744-5-git-send-email-dh.herrmann@gmail.com>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
	<1387295334-1744-5-git-send-email-dh.herrmann@gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013 16:48:54 +0100
David Herrmann <dh.herrmann@gmail.com> wrote:

> Motion sensors are getting quite common in mobile devices. To avoid
> returning accelerometer data via ABS_X/Y/Z and irritating the Xorg
> mouse-driver, this adds separate ABS_* bits for that.
> 
> This is needed if gaming devices want to report their normal data plus
> accelerometer/gyro data. Usually, ABS_X/Y are already used by analog
> sticks, so need separate definitions, anyway.

What about:
	...so motion sensors need separate definitions anyway.
              ^^^^^^^^^^^^^^
It was not immediately clear to me what the "need" referred to.

> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---
>  Documentation/input/gamepad.txt         |   7 ++
>  Documentation/input/motion-tracking.txt | 149 ++++++++++++++++++++++++++++++++
>  include/linux/mod_devicetable.h         |   2 +-
>  include/uapi/linux/input.h              |   9 +-
>  4 files changed, 165 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/input/motion-tracking.txt
> 
> diff --git a/Documentation/input/gamepad.txt b/Documentation/input/gamepad.txt
> index 196dc42..eeda685 100644
> --- a/Documentation/input/gamepad.txt
> +++ b/Documentation/input/gamepad.txt
> @@ -57,6 +57,9 @@ Most gamepads have the following features:
>    - Rumble
>      Many devices provide force-feedback features. But are mostly just
>      simple rumble motors.
> +  - Motion-tracking
> +    Gamepads may include motion-tracking sensors like accelerometers and
> +    gyroscopes.
>  
>  3. Detection
>  ~~~~~~~~~~~~
> @@ -153,5 +156,9 @@ Menu-Pad:
>  Rumble:
>    Rumble is adverticed as FF_RUMBLE.
>  
> +Motion-tracking:
> +  Motion-tracking is defined in ./Documentation/input/motion-tracking.txt and
> +  gamepads shall comply to the rules defined there.
> +

./Documentation/... looks like it's relative to this document, drop
the leading ./

>  ----------------------------------------------------------------------------
>    Written 2013 by David Herrmann <dh.herrmann@gmail.com>
> diff --git a/Documentation/input/motion-tracking.txt b/Documentation/input/motion-tracking.txt
> new file mode 100644
> index 0000000..0885c9a
> --- /dev/null
> +++ b/Documentation/input/motion-tracking.txt
> @@ -0,0 +1,149 @@
> +                           Motion Tracking API
> +----------------------------------------------------------------------------
> +
> +1. Intro
> +~~~~~~~~
> +Motion tracking devices produce device motion events generated from an
> +accelerometer, gyroscope or compass. This data can be returned to user-space
> +via input events. This document defines how this data is reported.
> +
> +2. Devices
> +~~~~~~~~~~
> +In this document, a "device" is one of:
> + - accelerometer
> + - gyroscope
> + - compass
> +
> +These devices returned their information via different APIs in the past. To
> +unify them and define a common API, a set of input evdev codes was created. Old
> +drivers might continue using their API, but developers are encouraged to use
> +the input evdev API for new drivers.
> +
> +2.1 Axes
> +~~~~~~~~
> +Movement data is usually returned as absolute data for the 3 axes of a device.
> +In this context, the three axes are defined as:
> + - X: Axis goes from the left to the right side of the device
> + - Y: Axis goes from the bottom to the top of the device
> + - Z: Axis goes from the back to the front of the device
> +
> +The front of a device is the side faced to the user. For a mobile-phone it
> +would be the screen. For devices without a screen, the front is usually the
> +side with the most buttons on it.
> +
> +                           Example: Mobile-Phone
> +  +-------------------------------------------------------------------------+
> +  |                      TOP                                                |
> +  |                                                                         |
> +  |                                                                         |
> +  |          +---------------------------+                                  |
> +  |          |\  ________________________ \      .__                        |
> +  |          \ \ \                       \ \     |\                         |
> +  |           \ \ \              __       \ \      \                   RIGHT|
> +  |            \ \ \              /|       \ \      \__                     |
> +  |             \ \ \          __/          \ \     |\                      |
> +  |              \ \ \          /|           \ \      \ (Y Axis)            |
> +  |               \ \ \      __/  (Z axis)    \ \      \__                  |
> +  |                \ \ \      /|               \ \     |\                   |
> +  | LEFT            \ \ \    /                  \ \      \                  |
> +  |                  \ \ \         FRONT         \ \      \                 |
> +  |                   \ \ \                       \ \                       |
> +  |                    \ \ \_______________________\ \                      |
> +  |                     \ \             ___           \                     |
> +  |                     /\ \            \__\           \                    |
> +  |                  __/  \ +---------------------------+                   |
> +  |                   /|   \|___________________________|                   |
> +  |                  / BACK                                                 |
> +  |                                      (X axis)                           |
> +  |                        ------->------->------->------->                 |
> +  |                                                                         |
> +  |                                                                         |
> +  |                                         BOTTOM                          |
> +  +-------------------------------------------------------------------------+
> +
> +Rotation-data is reported as clock-wise rotation on an axis. For a given axes,
> +the reported rotation would be:
> +                                          ___
> +                                            /|
> +                                           / | (axis)
> +                                          /
> +                                    .-**-.
> +                                   /    / \
> +                                  |    / \ | /
> +                                   \  /   \|/  (clock-wise rotation)
> +                                     /
> +                                    /
> +                                   /
> +
> +2.2 Calibration
> +~~~~~~~~~~~~~~~
> +Motion sensors are often highly sensitive and need precise calibration. Users
> +are adviced to perform neutral-point calibration themselves or to implement a
       ^^^^^^^
       advised

> +state-machine to normalize input data automatically.
> +
> +Kernel devices may perform their own calibration and/or normalization. However,
> +this is usually sparse and, if implemented, transparent to the user.
> +
> +There is currently no way to feed calibration data into the kernel in a generic
> +way. Proposals welcome!
> +
> +2.3 Units
> +~~~~~~~~~
> +(NOTE: This section describes an experimental API. Currently, no device complies
> +to these rules so this might change in the future.)
> +
> +Reported data shall be returned as:
> + - Acceleration: 1/1000 m per s^2

Do you think it is worth mentioning that most hardware tend to report
the values as relative to some multiple of G (9.8 m/s^2)?

Or maybe we can get back to that when some actual driver (Wiimote, PS3
controller) start using that part of the API.

> + - Rotation: 1/1000 degree per second
> +
> +However, for most devices the reported units are unknown (more precisely: no
> +one has the time to measure them and figure them out). Therefore, user-space
> +shall use abs-minimum and abs-maximum to calculate relative data and use that
> +instead. Devices which return wrong units may be fixed in the future to comply
> +to these rules.
> +
> +3.1 Accelerometer
> +~~~~~~~~~~~~~~~~~
> +Accelerometers measure movement acceleration of devices. Any combination of the
> +three available axes can be used. Usually, all three are supported.
> +
> +Data is provided as absolute acceleration. A positive integer defines the
> +acceleration in the direction of an axis. A negative integer defines
> +acceleration in the opposite direction.
> +
> +The evdev ABS codes used are:
> + - ABS_ACCEL_X: X axis
> + - ABS_ACCEL_Y: Y axis
> + - ABS_ACCEL_Z: Z axis
> +
> +3.2 Gyroscope
> +~~~~~~~~~~~~~
> +A gyroscope measures rotational speed (*not* acceleration!). Any combination of
> +the three available axes can be used. Usually, all three are supported.
> +
> +Data is provided as absolute speed. A positive integer defines the rotational
> +speed in clock-wise order around a given axis. A negative integer defines it in
> +counter-clock-wise order.
> +
> +The evdev ABS codes used are:
> + - ABS_GYRO_X: X axis (also: Pitch)
> + - ABS_GYRO_Y: Y axis (also: Roll)
> + - ABS_GYRO_Z: Z axis (also: Azimuth/Yaw)
> +
> +3.3 Compass
> +~~~~~~~~~~~
> +(NOTE: No compass device currently uses the evdev input subsystem. Thus, this
> +API is only a proposal, it hasn't been implemented, yet.)
> +
> +A compass measures the ambient magnetic field of the three defined axes. This
> +makes the data self-contained and independent of the current device position.
> +Any combination of the three axes can be used. Usually all three are supported,
> +otherwise, it's not really useful as a compass.
> +
> +Proposed evdev ABS codes are:
> + - ABS_COMPASS_X: X axis
> + - ABS_COMPASS_Y: Y axis
> + - ABS_COMPASS_Z: Z axis
> +
> +----------------------------------------------------------------------------
> +  Written 2013 by David Herrmann <dh.herrmann@gmail.com>
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 45e9214..329aa30 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -277,7 +277,7 @@ struct pcmcia_device_id {
>  #define INPUT_DEVICE_ID_KEY_MIN_INTERESTING	0x71
>  #define INPUT_DEVICE_ID_KEY_MAX		0x2ff
>  #define INPUT_DEVICE_ID_REL_MAX		0x0f
> -#define INPUT_DEVICE_ID_ABS_MAX		0x3f
> +#define INPUT_DEVICE_ID_ABS_MAX		0x4f
>  #define INPUT_DEVICE_ID_MSC_MAX		0x07
>  #define INPUT_DEVICE_ID_LED_MAX		0x0f
>  #define INPUT_DEVICE_ID_SND_MAX		0x07
> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> index 1856461..e4c3596 100644
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -869,12 +869,19 @@ struct input_keymap_entry {
>  #define ABS_MAX			0x3f
>  #define ABS_CNT			(ABS_MAX+1)
>  
> +#define ABS_ACCEL_X		0x40	/* Accelerometer X axis */
> +#define ABS_ACCEL_Y		0x41	/* Accelerometer Y axis */
> +#define ABS_ACCEL_Z		0x42	/* Accelerometer Z axis */
> +#define ABS_GYRO_X		0x43	/* Gyroscope X axis */
> +#define ABS_GYRO_Y		0x44	/* Gyroscope Y axis */
> +#define ABS_GYRO_Z		0x45	/* Gyroscope Z axis */
> +
>  /*
>   * Due to API restrictions the legacy evdev API only supports ABS values up to
>   * ABS_MAX/CNT. Use the extended *ABS2 ioctls to operate on any ABS values in
>   * between ABS_MAX and ABS_MAX2.
>   */
> -#define ABS_MAX2		0x3f
> +#define ABS_MAX2		0x4f
>  #define ABS_CNT2		(ABS_MAX2+1)
>  
>  /*
> -- 
> 1.8.5.1
> 

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
