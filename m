Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaHNRoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:44:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53452 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbaHNRoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:44:16 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "madcatxster@devoid-pointer.net" <madcatxster@devoid-pointer.net>,
        "simon@mungewell.org" <simon@mungewell.org>,
        "elias.vds@gmail.com" <elias.vds@gmail.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v5] input: drv260x: Add TI drv260x haptics driver
Thread-Topic: [PATCH v5] input: drv260x: Add TI drv260x haptics driver
Thread-Index: AQHPrPO0tYMQlTI4yUqEx0SWRNhMRw==
Date: Thu, 14 Aug 2014 17:44:04 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DE6FF3@DFLE09.ent.ti.com>
References: <1406834089-15095-1-git-send-email-dmurphy@ti.com>
 <20140813092001.GB32644@leverpostej>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark

On 08/13/2014 04:20 AM, Mark Rutland wrote:
> Hi Dan,
> 
> Apologies for the delay.
> 

No worries.  Thanks for the comments

> On Thu, Jul 31, 2014 at 08:14:49PM +0100, Dan Murphy wrote:
>> Add the TI drv260x haptics/vibrator driver.
>> This device uses the input force feedback
>> to produce a wave form to driver an
>> ERM or LRA actuator device.
>>
>> The initial driver supports the devices
>> real time playback mode.  But the device
>> has additional wave patterns in ROM.
>>
>> This functionality will be added in
>> future patchsets.
>>
>> Product data sheet is located here:
>> http://www.ti.com/product/drv2605
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>
>> v5 - Move register defines to c file and rm header file, error check
>> init in probe, fixed identation, remove empty labels in probe
>> and just return on fail and removed the remove callback and function.
>> Did not factor out the suspend into a stop function. - https://patchwork.kernel.org/patch/4649631/
>> v4 - Convert regulator to devm, added error checking where required,
>> updated bindings doc, moved dt parsing to separate call and made platform
>> data the first data point, moved vibrator enable and mode programming from
>> play entry to worker thread, added user check and input mutex in suspend/resume
>> calls, moved platform data to individual file and into include platform-data directory,
>> removed file names from file headers - https://patchwork.kernel.org/patch/4642221/
>> v3 - Updated binding doc, changed to memless device, updated input alloc to
>> devm, removed mutex locking, add sanity checks for mode and library - https://patchwork.kernel.org/patch/4635421/
>> v2 - Fixed binding doc and patch headline - https://patchwork.kernel.org/patch/4619641/
>>
>>
>>  .../devicetree/bindings/input/ti,drv260x.txt       |   50 ++
>>  drivers/input/misc/Kconfig                         |    9 +
>>  drivers/input/misc/Makefile                        |    1 +
>>  drivers/input/misc/drv260x.c                       |  697 ++++++++++++++++++++
>>  include/dt-bindings/input/ti-drv260x.h             |   35 +
>>  include/linux/platform_data/drv260x-pdata.h        |   29 +
>>  6 files changed, 821 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/input/ti,drv260x.txt
>>  create mode 100644 drivers/input/misc/drv260x.c
>>  create mode 100644 include/dt-bindings/input/ti-drv260x.h
>>  create mode 100644 include/linux/platform_data/drv260x-pdata.h
>>
>> diff --git a/Documentation/devicetree/bindings/input/ti,drv260x.txt b/Documentation/devicetree/bindings/input/ti,drv260x.txt
>> new file mode 100644
>> index 0000000..8e6970d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/input/ti,drv260x.txt
>> @@ -0,0 +1,50 @@
>> +Texas Instruments - drv260x Haptics driver family
>> +
>> +The drv260x family serial control bus communicates through I2C protocols
>> +
>> +Required properties:
>> +       - compatible - One of:
>> +               "ti,drv2604" - DRV2604
>> +               "ti,drv2605" - DRV2605
>> +               "ti,drv2605l" - DRV2605L
>> +       - reg -  I2C slave address
>> +       - supply- Required supply regulators are:
>> +               "vbat" - battery voltage
> 
> This looks a bit odd, and seems to imply the name would be supply-vbat,
> which doesn't sound right. I assume this should be vbat-supply?
> 
> If so, just have this as:
> 
> - vbat-supply - regulator supplying battery voltage.

Will change this.

> 
>> +       - mode - Power up mode of the chip (defined in include/dt-bindings/input/ti-drv260x.h)
>> +               DRV260X_LRA_MODE - Linear Resonance Actuator mode (Piezoelectric)
>> +               DRV260X_LRA_NO_CAL_MODE - This is a LRA Mode but there is no calibration
>> +                               sequence during init.  And the device is configured for real
>> +                               time playback mode (RTP mode).
>> +               DRV260X_ERM_MODE - Eccentric Rotating Mass mode (Rotary vibrator)
>> +       - library-sel - These are ROM based waveforms pre-programmed into the IC.
>> +                               This should be set to set the library to use at power up.
>> +                               (defined in include/dt-bindings/input/ti-drv260x.h)
>> +               DRV260X_LIB_A - Pre-programmed Library
>> +               DRV260X_LIB_B - Pre-programmed Library
>> +               DRV260X_LIB_C - Pre-programmed Library
>> +               DRV260X_LIB_D - Pre-programmed Library
>> +               DRV260X_LIB_E - Pre-programmed Library
>> +               DRV260X_LIB_F - Pre-programmed Library
> 
> In the datasheet these seem to be ERM libraries A-E, then LRA library
> (not F).
> 
> How does the library selection interact with the mode? Surely it only
> makes sense to select an ERM library in ERM mode?
> 

OK yeah.  I will update these to call out ERM vs LRA libraries and add a check in the code
to make sure there is no mis-match of lib to mode


>> +
>> +Optional properties:
>> +       - enable-gpio - gpio pin to enable/disable the device.
>> +       - vib_rated_voltage - The rated voltage of the actuator in millivolts.
>> +                         If this is not set then the value will be defaulted to
>> +                         3.2 v.
>> +       - vib_overdrive_voltage - The overdrive voltage of the actuator in millivolts.
>> +                         If this is not set then the value will be defaulted to
>> +                         3.2 v.
> 
> It looks like you forogt to s/_/-/ here when the code was last updated.
> 
> These would be better suffixed with -mv given they are in millivolts
> rather than volts.

SGTM.  Will update

> 
>> +               enable-gpio = <&gpio1 28 GPIO_ACTIVE_HIGH>;
>> +               mode = <DRV260X_LRA_MODE>;
>> +               library-sel = <DRV260X_LIB_SEL_DEFAULT>;
> 
> This value is not described above. What happens if
> DRV260X_LIB_SEL_DEFAULT is selected?
> 

I removed the default and change to empty as that is what the
default mode is is an empty library.

> [...]
> 
>> +/**
>> + * Rated and Overdriver Voltages:
>> + * Calculated using the formula r = v * 255 / 5.6
>> + * where r is what will be written to the register
>> + * and v is the rated or overdriver voltage of the actuator
>> + **/
>> +#define DRV260X_DEF_RATED_VOLT         0x90
>> +#define DRV260X_DEF_OD_CLAMP_VOLT      0x90
>> +
>> +static int drv260x_calculate_voltage(int voltage)
>> +{
>> +       return (voltage * 255 / 5600);
>> +}
>> +
> 
> Shouldn't the comment be attached to the function rather than the
> defines?

Moved

Thanks Again
Dan

> 
> Thanks,
> Mark.
> 


-- 
------------------
Dan Murphy
