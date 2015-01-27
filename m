Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbbA0RJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:09:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:13155 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbbA0RJ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:09:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,475,1418112000"; 
   d="scan'208";a="657428438"
From: "Tirdea, Irina" <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dogaru, Vlad" <vlad.dogaru@intel.com>,
        "Baluta, Daniel" <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        "Peter Meerwald" <pmeerw@pmeerw.net>
Subject: RE: [PATCH v2 10/10] iio: add driver for Freescale MMA9553
Thread-Topic: [PATCH v2 10/10] iio: add driver for Freescale MMA9553
Thread-Index: AQHQOakGmXQlOwKwcUyfTbfzFmA0WpzUJsgw
Date: Tue, 27 Jan 2015 17:09:20 +0000
Deferred-Delivery: Tue, 27 Jan 2015 17:09:00 +0000
Message-ID: <1F3AC3675D538145B1661F571FE1805F19A0F752@irsmsx105.ger.corp.intel.com>
References: <1421003416-27557-1-git-send-email-irina.tirdea@intel.com>
 <1421003416-27557-11-git-send-email-irina.tirdea@intel.com>
 <54C6A724.1000506@kernel.org>
In-Reply-To: <54C6A724.1000506@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jonathan Cameron [mailto:jic23@kernel.org]
> Sent: 26 January, 2015 22:44
> To: Tirdea, Irina; linux-iio@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Dogaru, Vlad; Baluta, Daniel; Hartmut Knaack; Lars-Peter Clausen; Peter Meerwald
> Subject: Re: [PATCH v2 10/10] iio: add driver for Freescale MMA9553
> 
> On 11/01/15 19:10, Irina Tirdea wrote:
> > Add support for Freescale MMA9553L Intelligent Pedometer Platform.
> >
> > The following functionalities are supported:
> >  - step counter (counts the number of steps using a HW register)
> >  - step detector (generates an iio event at every step the user takes)
> >  - activity recognition (rest, walking, jogging, running)
> >  - speed
> >  - calories
> >  - distance
> >
> > To get accurate pedometer results, the user's height, weight and gender
> > need to be configured.
> >
> > The specifications can be downloaded from:
> > http://www.freescale.com/files/sensors/doc/ref_manual/MMA955xLSWRM.pdf
> > http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf
> >
> > Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> One thing noticed in passing.  Calibheight is in cm whereas distance is
> in m. This seems inconsistent.  Would you mind changing to meters for
> calibheight?
> (lets do it whilst we don't really have any users yet).
Sure, using meters is better. 
I'll make the change to the iio Documentation and the driver.
> 
> 
> A very nice driver, just a few minor queries in line.  Also of course
> the interface for the debounce of steps as discussed in the thread
> hanging off earlier in this series.
> 
> I'm not keen on the addition to iio.h (yet) as it is only used by this
> one driver and as a general rule macros that simple are best avoided
> (tend to limit things rather than help).
Ok, I'll move the code to the driver.
> 
> > ---
> >  Documentation/ABI/testing/sysfs-bus-iio |   49 +-
> >  drivers/iio/accel/Kconfig               |   10 +
> >  drivers/iio/accel/Makefile              |    1 +
> >  drivers/iio/accel/mma9551_core.c        |  183 +++++
> >  drivers/iio/accel/mma9551_core.h        |   17 +-
> >  drivers/iio/accel/mma9553.c             | 1321 +++++++++++++++++++++++++++++++
> >  include/linux/iio/iio.h                 |   11 +
> >  7 files changed, 1587 insertions(+), 5 deletions(-)
> >  create mode 100644 drivers/iio/accel/mma9553.c
> >
> > diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> > index e009f49..732d018 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-iio
> > +++ b/Documentation/ABI/testing/sysfs-bus-iio
> > @@ -343,7 +343,30 @@ Description:
> >  		production inaccuracies).  If shared across all channels,
> >  		<type>_calibscale is used.
> >
> > -What:		/sys/bus/iio/devices/iio:deviceX/in_steps_calibheight
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_activity_calibgender
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_energy_calibgender
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_distance_calibgender
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_velocity_calibgender
> > +KernelVersion:	3.20
> > +Contact:	linux-iio@vger.kernel.org
> > +Description:
> > +		Gender of the user (e.g.: male, female) used by some pedometers
> > +		to compute the stride length, distance, speed and activity
> > +		type.
> > +
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_activity_calibgender_available
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_energy_calibgender_available
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_distance_calibgender_available
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_velocity_calibgender_available
> > +KernelVersion:	3.20
> > +Contact:	linux-iio@vger.kernel.org
> > +Description:
> > +		Lists all available gender values (e.g.: male, female).
> > +
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_activity_calibheight
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_energy_calibheight
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_distance_calibheight
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_velocity_calibheight
> >  KernelVersion:	3.19
> >  Contact:	linux-iio@vger.kernel.org
> >  Description:
> > @@ -818,6 +841,14 @@ What:		/sys/.../events/in_tempY_roc_falling_period
> >  What:		/sys/.../events/in_accel_x&y&z_mag_falling_period
> >  What:		/sys/.../events/in_intensity0_thresh_period
> >  What:		/sys/.../events/in_proximity0_thresh_period
> > +What:		/sys/.../events/in_activity_still_thresh_rising_period
> > +What:		/sys/.../events/in_activity_still_thresh_falling_period
> > +What:		/sys/.../events/in_activity_walking_thresh_rising_period
> > +What:		/sys/.../events/in_activity_walking_thresh_falling_period
> > +What:		/sys/.../events/in_activity_jogging_thresh_rising_period
> > +What:		/sys/.../events/in_activity_jogging_thresh_falling_period
> > +What:		/sys/.../events/in_activity_running_thresh_rising_period
> > +What:		/sys/.../events/in_activity_running_thresh_falling_period
> >  KernelVersion:	2.6.37
> >  Contact:	linux-iio@vger.kernel.org
> >  Description:
> > @@ -1142,6 +1173,12 @@ Description:
> >  		This attribute is used to get/set the integration time in
> >  		seconds.
> >
> > +What:		/sys/.../iio:deviceX/in_velocity_sqrt(x^2+y^2+z^2)_integration_time
> > +KernelVersion:	3.20
> > +Contact:	linux-iio@vger.kernel.org
> > +Description:
> > +		Number of seconds in which to compute speed.
> > +
> >  What:		/sys/bus/iio/devices/iio:deviceX/in_rot_quaternion_raw
> >  KernelVersion:	3.15
> >  Contact:	linux-iio@vger.kernel.org
> > @@ -1170,13 +1207,17 @@ Description:
> >  		present, output should be considered as processed with the
> >  		unit in milliamps.
> >
> > +What:		/sys/.../iio:deviceX/in_energy_en
> > +What:		/sys/.../iio:deviceX/in_distance_en
> > +What:		/sys/.../iio:deviceX/in_velocity_sqrt(x^2+y^2+z^2)_en
> The speed one is interesting.  It's an instantaneous measure (unlike the
> others that are cumulative).  As such I'd normally expect it not to need
> an enable (nothing is getting reset).  However as you describe above we
> have a speed calculation over a number of seconds so I can see where
> this comes from.  Hmm.  Not sure on the right answer for this one.
The problem is that all the attributes this driver exports  (speed, energy, distance) are based on the step counter.

Although the step counter is always enabled, we do not want to keep the power on if nobody is using it. The *_en attributes are used to start the step counter by powering on the device.
We cannot use one _en attribute for all exported values because we are using different iio types, but internally all _en attributes are treated as one flag to power on/off the device.
I'm thinking of this scenario: I want to go run, so I start my running application that can show me speed and steps, but I do not want to keep the pedometer on once I'm done.

The _en attribute is more related to power management in this case (although other pedometers have a special register to enable/disable the step counter).

> 
> 
> 
> >  What:		/sys/.../iio:deviceX/in_steps_en
> >  KernelVersion:	3.19
> >  Contact:	linux-iio@vger.kernel.org
> >  Description:
> > -		Activates the step counter. After activation, the number of steps
> > -		taken by the user will be counted in hardware and exported through
> > -		in_steps_input.
> > +		Activates a device feature that runs in firmware/hardware.
> > +		E.g. for steps: the pedometer saves power while not used;
> > +		when activated, it will count the steps taken by the user in
> > +		firmware and export them through in_steps_input.
> >
> >  What:		/sys/.../iio:deviceX/in_steps_input
> >  KernelVersion:	3.19
> > diff --git a/drivers/iio/accel/Kconfig b/drivers/iio/accel/Kconfig
> > index c53047d..7c9a9a9 100644
> > --- a/drivers/iio/accel/Kconfig
> > +++ b/drivers/iio/accel/Kconfig
> > @@ -126,4 +126,14 @@ config MMA9551
> >  	  To compile this driver as a module, choose M here: the module
> >  	  will be called mma9551.
> >
> > +config MMA9553
> > +	tristate "Freescale MMA9553L Intelligent Pedometer Platform Driver"
> > +	depends on I2C
> > +	select MMA9551_CORE
> > +	help
> > +	  Say yes here to build support for the Freescale MMA9553L
> > +	  Intelligent Pedometer Platform Driver.
> > +
> > +	  To compile this driver as a module, choose M here: the module
> > +	  will be called mma9553.
> >  endmenu
> > diff --git a/drivers/iio/accel/Makefile b/drivers/iio/accel/Makefile
> > index 8105316..f815695 100644
> > --- a/drivers/iio/accel/Makefile
> > +++ b/drivers/iio/accel/Makefile
> > @@ -12,6 +12,7 @@ obj-$(CONFIG_MMA8452)	+= mma8452.o
> >
> >  obj-$(CONFIG_MMA9551_CORE)	+= mma9551_core.o
> >  obj-$(CONFIG_MMA9551)		+= mma9551.o
> > +obj-$(CONFIG_MMA9553)		+= mma9553.o
> >
> >  obj-$(CONFIG_IIO_ST_ACCEL_3AXIS) += st_accel.o
> >  st_accel-y := st_accel_core.o
> > diff --git a/drivers/iio/accel/mma9551_core.c b/drivers/iio/accel/mma9551_core.c
> > index 7f1a73e..7f55a6d 100644
> > --- a/drivers/iio/accel/mma9551_core.c
> > +++ b/drivers/iio/accel/mma9551_core.c
> > @@ -53,6 +53,11 @@
> >  #define MMA9551_AFE_Y_ACCEL_REG		0x02
> >  #define MMA9551_AFE_Z_ACCEL_REG		0x04
> >
> > +/* Reset/Suspend/Clear application */
> > +#define MMA9551_RSC_RESET		0x00
> > +#define MMA9551_RSC_OFFSET(mask)	(3 - (ffs(mask) - 1) / 8)
> > +#define MMA9551_RSC_VAL(mask)		(mask >> (((ffs(mask) - 1) / 8) * 8))
> > +
> >  /*
> >   * A response is composed of:
> >   * - control registers: MB0-3
> > @@ -275,6 +280,64 @@ int mma9551_read_status_byte(struct i2c_client *client, u8 app_id,
> >  EXPORT_SYMBOL(mma9551_read_status_byte);
> >
> >  /**
> > + * mma9551_read_config_word() - read 1 config word
> > + * @client:	I2C client
> > + * @app_id:	Application ID
> > + * @reg:	Application register
> > + * @val:	Pointer to store value read
> > + *
> > + * Read one configuration word from the device using MMA955xL command format.
> > + * Commands to the MMA955xL platform consist of a write followed by one or
> > + * more reads.
> > + *
> > + * Locking note: This function must be called with the device lock held.
> > + * Locking is not handled inside the function. Callers should ensure they
> > + * serialize access to the HW.
> > + *
> > + * Returns: 0 on success, negative value on failure.
> > + */
> > +int mma9551_read_config_word(struct i2c_client *client, u8 app_id,
> > +			    u16 reg, u16 *val)
> > +{
> > +	int ret;
> > +	__be16 v;
> > +
> > +	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_CONFIG,
> > +			       reg, NULL, 0, (u8 *)&v, 2);
> > +	*val = be16_to_cpu(v);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(mma9551_read_config_word);
> > +
> > +/**
> > + * mma9551_write_config_word() - write 1 config word
> > + * @client:	I2C client
> > + * @app_id:	Application ID
> > + * @reg:	Application register
> > + * @val:	Value to write
> > + *
> > + * Write one configuration word from the device using MMA955xL command format.
> > + * Commands to the MMA955xL platform consist of a write followed by one or
> > + * more reads.
> > + *
> > + * Locking note: This function must be called with the device lock held.
> > + * Locking is not handled inside the function. Callers should ensure they
> > + * serialize access to the HW.
> > + *
> > + * Returns: 0 on success, negative value on failure.
> > + */
> > +int mma9551_write_config_word(struct i2c_client *client, u8 app_id,
> > +			     u16 reg, u16 val)
> > +{
> > +	__be16 v = cpu_to_be16(val);
> > +
> > +	return mma9551_transfer(client, app_id, MMA9551_CMD_WRITE_CONFIG, reg,
> > +				(u8 *) &v, 2, NULL, 0);
> > +}
> > +EXPORT_SYMBOL(mma9551_write_config_word);
> > +
> > +/**
> >   * mma9551_read_status_word() - read 1 status word
> >   * @client:	I2C client
> >   * @app_id:	Application ID
> > @@ -306,6 +369,107 @@ int mma9551_read_status_word(struct i2c_client *client, u8 app_id,
> >  EXPORT_SYMBOL(mma9551_read_status_word);
> >
> >  /**
> > + * mma9551_read_config_words() - read multiple config words
> > + * @client:	I2C client
> > + * @app_id:	Application ID
> > + * @reg:	Application register
> > + * @len:	Length of array to read in bytes
> > + * @val:	Array of words to read
> > + *
> > + * Read multiple configuration registers (word-sized registers).
> > + *
> > + * Locking note: This function must be called with the device lock held.
> > + * Locking is not handled inside the function. Callers should ensure they
> > + * serialize access to the HW.
> > + *
> > + * Returns: 0 on success, negative value on failure.
> > + */
> > +int mma9551_read_config_words(struct i2c_client *client, u8 app_id,
> > +			     u16 reg, u8 len, u16 *buf)
> > +{
> > +	int ret, i;
> > +	int len_words = len / sizeof(u16);
> > +	__be16 be_buf[MMA9551_MAX_MAILBOX_DATA_REGS];
> > +
> > +	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_CONFIG,
> > +			       reg, NULL, 0, (u8 *) be_buf, len);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	for (i = 0; i < len_words; i++)
> > +		buf[i] = be16_to_cpu(be_buf[i]);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(mma9551_read_config_words);
> > +
> > +/**
> > + * mma9551_read_status_words() - read multiple status words
> > + * @client:	I2C client
> > + * @app_id:	Application ID
> > + * @reg:	Application register
> > + * @len:	Length of array to read in bytes
> > + * @val:	Array of words to read
> > + *
> > + * Read multiple status registers (word-sized registers).
> > + *
> > + * Locking note: This function must be called with the device lock held.
> > + * Locking is not handled inside the function. Callers should ensure they
> > + * serialize access to the HW.
> > + *
> > + * Returns: 0 on success, negative value on failure.
> > + */
> > +int mma9551_read_status_words(struct i2c_client *client, u8 app_id,
> > +			      u16 reg, u8 len, u16 *buf)
> > +{
> > +	int ret, i;
> > +	int len_words = len / sizeof(u16);
> > +	__be16 be_buf[MMA9551_MAX_MAILBOX_DATA_REGS];
> > +
> > +	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_STATUS,
> > +			       reg, NULL, 0, (u8 *) be_buf, len);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	for (i = 0; i < len_words; i++)
> > +		buf[i] = be16_to_cpu(be_buf[i]);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(mma9551_read_status_words);
> > +
> > +/**
> > + * mma9551_write_config_words() - write multiple config words
> > + * @client:	I2C client
> > + * @app_id:	Application ID
> > + * @reg:	Application register
> > + * @len:	Length of array to write in bytes
> > + * @val:	Array of words to write
> > + *
> > + * Write multiple configuration registers (word-sized registers).
> > + *
> > + * Locking note: This function must be called with the device lock held.
> > + * Locking is not handled inside the function. Callers should ensure they
> > + * serialize access to the HW.
> > + *
> > + * Returns: 0 on success, negative value on failure.
> > + */
> > +int mma9551_write_config_words(struct i2c_client *client, u8 app_id,
> > +			       u16 reg, u8 len, u16 *buf)
> > +{
> > +	int i;
> > +	int len_words = len / sizeof(u16);
> > +	__be16 be_buf[MMA9551_MAX_MAILBOX_DATA_REGS];
> > +
> > +	for (i = 0; i < len_words; i++)
> > +		be_buf[i] = cpu_to_be16(buf[i]);
> > +
> > +	return mma9551_transfer(client, app_id, MMA9551_CMD_WRITE_CONFIG,
> > +				reg, (u8 *) be_buf, len, NULL, 0);
> > +}
> > +EXPORT_SYMBOL(mma9551_write_config_words);
> > +
> > +/**
> >   * mma9551_update_config_bits() - update bits in register
> >   * @client:	I2C client
> >   * @app_id:	Application ID
> > @@ -609,6 +773,25 @@ int mma9551_read_accel_scale(int *val, int *val2)
> >  }
> >  EXPORT_SYMBOL(mma9551_read_accel_scale);
> >
> > +/**
> > + * mma9551_app_reset() - reset application
> > + * @client:	I2C client
> > + * @app_mask:	Application to reset
> > + *
> > + * Reset the given application (using the Reset/Suspend/Clear
> > + * Control Application)
> > + *
> > + * Returns: 0 on success, negative value on failure.
> > + */
> > +int mma9551_app_reset(struct i2c_client *client, u32 app_mask)
> > +{
> > +	return mma9551_write_config_byte(client, MMA9551_APPID_RCS,
> > +					 MMA9551_RSC_RESET +
> > +					 MMA9551_RSC_OFFSET(app_mask),
> > +					 MMA9551_RSC_VAL(app_mask));
> > +}
> > +EXPORT_SYMBOL(mma9551_app_reset);
> > +
> >  MODULE_AUTHOR("Irina Tirdea <irina.tirdea@intel.com>");
> >  MODULE_AUTHOR("Vlad Dogaru <vlad.dogaru@intel.com>");
> >  MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/iio/accel/mma9551_core.h b/drivers/iio/accel/mma9551_core.h
> > index e6efd02..edaa56b 100644
> > --- a/drivers/iio/accel/mma9551_core.h
> > +++ b/drivers/iio/accel/mma9551_core.h
> > @@ -21,9 +21,13 @@
> >  #define MMA9551_APPID_AFE		0x06
> >  #define MMA9551_APPID_TILT		0x0B
> >  #define MMA9551_APPID_SLEEP_WAKE	0x12
> > -#define MMA9551_APPID_RESET		0x17
> > +#define MMA9551_APPID_PEDOMETER	        0x15
> > +#define MMA9551_APPID_RCS		0x17
> >  #define MMA9551_APPID_NONE		0xff
> >
> > +/* Reset/Suspend/Clear application app masks */
> > +#define MMA9551_RSC_PED			BIT(21)
> > +
> >  #define MMA9551_AUTO_SUSPEND_DELAY_MS	2000
> >
> >  enum mma9551_gpio_pin {
> > @@ -48,8 +52,18 @@ int mma9551_write_config_byte(struct i2c_client *client, u8 app_id,
> >  			      u16 reg, u8 val);
> >  int mma9551_read_status_byte(struct i2c_client *client, u8 app_id,
> >  			     u16 reg, u8 *val);
> > +int mma9551_read_config_word(struct i2c_client *client, u8 app_id,
> > +			    u16 reg, u16 *val);
> > +int mma9551_write_config_word(struct i2c_client *client, u8 app_id,
> > +			     u16 reg, u16 val);
> >  int mma9551_read_status_word(struct i2c_client *client, u8 app_id,
> >  			     u16 reg, u16 *val);
> > +int mma9551_read_config_words(struct i2c_client *client, u8 app_id,
> > +			     u16 reg, u8 len, u16 *buf);
> > +int mma9551_read_status_words(struct i2c_client *client, u8 app_id,
> > +			      u16 reg, u8 len, u16 *buf);
> > +int mma9551_write_config_words(struct i2c_client *client, u8 app_id,
> > +			       u16 reg, u8 len, u16 *buf);
> >  int mma9551_update_config_bits(struct i2c_client *client, u8 app_id,
> >  			       u16 reg, u8 mask, u8 val);
> >  int mma9551_gpio_config(struct i2c_client *client, enum mma9551_gpio_pin pin,
> > @@ -62,5 +76,6 @@ int mma9551_read_accel_chan(struct i2c_client *client,
> >  			    const struct iio_chan_spec *chan,
> >  			    int *val, int *val2);
> >  int mma9551_read_accel_scale(int *val, int *val2);
> > +int mma9551_app_reset(struct i2c_client *client, u32 app_mask);
> >
> >  #endif /* _MMA9551_CORE_H_ */
> > diff --git a/drivers/iio/accel/mma9553.c b/drivers/iio/accel/mma9553.c
> > new file mode 100644
> > index 0000000..ef6a6e3
> > --- /dev/null
> > +++ b/drivers/iio/accel/mma9553.c
> > @@ -0,0 +1,1321 @@
> > +/*
> > + * Freescale MMA9553L Intelligent Pedometer driver
> > + * Copyright (c) 2014, Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/i2c.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/slab.h>
> > +#include <linux/acpi.h>
> > +#include <linux/gpio/consumer.h>
> > +#include <linux/iio/iio.h>
> > +#include <linux/iio/sysfs.h>
> > +#include <linux/iio/events.h>
> > +#include <linux/pm_runtime.h>
> > +#include "mma9551_core.h"
> > +
> > +#define MMA9553_DRV_NAME			"mma9553"
> > +#define MMA9553_IRQ_NAME			"mma9553_event"
> > +#define MMA9553_GPIO_NAME			"mma9553_int"
> > +
> > +/* Pedometer configuration registers (R/W) */
> > +#define MMA9553_CONF_SLEEPMIN		0x00
> > +#define MMA9553_CONF_SLEEPMAX		0x02
> > +#define MMA9553_CONF_SLEEPTHD		0x04
> > +#define MMA9553_CONF_WORD		GENMASK(15, 0)
> > +
> > +#define MMA9553_CONF_CONF_STEPLEN	0x06
> > +#define MMA9553_CONF_CONFIG		BIT(15)
> > +#define MMA9553_CONF_ACT_DBCNTM		BIT(14)
> > +#define MMA9553_CONF_SLP_DBCNTM		BIT(13)
> > +#define MMA9553_CONF_STEPLEN		GENMASK(7, 0)
> > +
> > +#define MMA9553_CONF_HEIGHT_WEIGHT	0x08
> Some of this naming is less than clear.  Which ones
> are the register addresses and which the internal masks?
> (obvious really, but names should reflect this perhaps)
> 
That's true. I'll rename them to make it more clear.

> > +#define MMA9553_CONF_HEIGHT		GENMASK(15, 8)
> > +#define MMA9553_CONF_WEIGHT		GENMASK(7, 0)
> > +
> > +#define MMA9553_CONF_FILTER		0x0A
> > +#define MMA9553_CONF_FILTSTEP		GENMASK(15, 8)
> > +#define MMA9553_CONF_MALE		BIT(7)
> > +#define MMA9553_CONF_FILTTIME		GENMASK(6, 0)
> > +
> > +#define MMA9553_CONF_SPEED_STEP		0x0C
> > +#define MMA9553_CONF_SPDPRD		GENMASK(15, 8)
> > +#define MMA9553_CONF_STEPCOALESCE	GENMASK(7, 0)
> > +
> > +#define MMA9553_CONF_ACTTHD		0x0E
> > +
> > +/* Pedometer status registers (R-only) */
> > +#define MMA9553_STATUS			0x00
> > +#define MMA9553_STATUS_MRGFL		BIT(15)
> > +#define MMA9553_STATUS_SUSPCHG		BIT(14)
> > +#define MMA9553_STATUS_STEPCHG		BIT(13)
> > +#define MMA9553_STATUS_ACTCHG		BIT(12)
> > +#define MMA9553_STATUS_SUSP		BIT(11)
> > +#define MMA9553_STATUS_ACTIVITY		(BIT(10) | BIT(9) | BIT(8))
> > +#define MMA9553_STATUS_VERSION		0x00FF
> > +
> > +#define MMA9553_STEPCNT			0x02
> > +#define MMA9553_DISTANCE		0x04
> > +#define MMA9553_SPEED			0x06
> > +#define MMA9553_CALORIES		0x08
> > +#define MMA9553_SLEEPCNT		0x0A
> > +
> > +/* Pedometer events are always mapped to this pin. */
> > +#define MMA9553_DEFAULT_GPIO_PIN	mma9551_gpio6
> > +#define MMA9553_DEFAULT_GPIO_POLARITY	0
> > +
> > +/* Bitnum used for gpio configuration = bit number in high status byte */
> > +#define STATUS_TO_BITNUM(bit)		(ffs(bit) - 9)
> > +
> > +#define MMA9553_DEFAULT_SAMPLE_RATE	30	/* Hz */
> > +
> > +/*
> > + * The internal activity level must be stable for ACTTHD samples before
> > + * ACTIVITY is updated.The ACTIVITY variable contains the current activity
> > + * level and is updated every time a step is detected or once a second
> > + * if there are no steps.
> > + */
> > +#define MMA9553_ACTIVITY_THD_TO_SEC(thd) ((thd) / MMA9553_DEFAULT_SAMPLE_RATE)
> > +#define MMA9553_ACTIVITY_SEC_TO_THD(sec) ((sec) * MMA9553_DEFAULT_SAMPLE_RATE)
> > +
> > +/*
> > + * Autonomously suspend pedometer if acceleration vector magnitude
> > + * is near 1g (4096 at 0.244 mg/LSB resolution) for 30 seconds.
> > + */
> > +#define MMA9553_DEFAULT_SLEEPMIN	3688	/* 0,9 g */
> > +#define MMA9553_DEFAULT_SLEEPMAX	4508	/* 1,1 g */
> > +#define MMA9553_DEFAULT_SLEEPTHD	(MMA9553_DEFAULT_SAMPLE_RATE * 30)
> > +
> > +#define MMA9553_CONFIG_RETRIES		2
> > +
> > +/* Status register - activity field  */
> > +enum activity_level {
> > +	ACTIVITY_UNKNOWN,
> > +	ACTIVITY_REST,
> > +	ACTIVITY_WALKING,
> > +	ACTIVITY_JOGGING,
> > +	ACTIVITY_RUNNING,
> > +};
> > +
> > +static struct mma9553_event_info {
> > +	enum iio_chan_type type;
> > +	enum iio_modifier mod;
> > +	enum iio_event_direction dir;
> > +} mma9553_events_info[] = {
> > +	{
> > +		.type = IIO_STEPS,
> > +		.mod = IIO_NO_MOD,
> > +		.dir = IIO_EV_DIR_NONE,
> > +	},
> > +	{
> > +		.type = IIO_ACTIVITY,
> > +		.mod = IIO_MOD_STILL,
> > +		.dir = IIO_EV_DIR_RISING,
> > +	},
> > +	{
> > +		.type = IIO_ACTIVITY,
> > +		.mod = IIO_MOD_STILL,
> > +		.dir = IIO_EV_DIR_FALLING,
> > +	},
> > +	{
> > +		.type = IIO_ACTIVITY,
> > +		.mod = IIO_MOD_WALKING,
> > +		.dir = IIO_EV_DIR_RISING,
> > +	},
> > +	{
> > +		.type = IIO_ACTIVITY,
> > +		.mod = IIO_MOD_WALKING,
> > +		.dir = IIO_EV_DIR_FALLING,
> > +	},
> > +	{
> > +		.type = IIO_ACTIVITY,
> > +		.mod = IIO_MOD_JOGGING,
> > +		.dir = IIO_EV_DIR_RISING,
> > +	},
> > +	{
> > +		.type = IIO_ACTIVITY,
> > +		.mod = IIO_MOD_JOGGING,
> > +		.dir = IIO_EV_DIR_FALLING,
> > +	},
> > +	{
> > +		.type = IIO_ACTIVITY,
> > +		.mod = IIO_MOD_RUNNING,
> > +		.dir = IIO_EV_DIR_RISING,
> > +	},
> > +	{
> > +		.type = IIO_ACTIVITY,
> > +		.mod = IIO_MOD_RUNNING,
> > +		.dir = IIO_EV_DIR_FALLING,
> > +	},
> > +};
> > +
> > +#define MMA9553_EVENTS_INFO_SIZE ARRAY_SIZE(mma9553_events_info)
> > +
> > +struct mma9553_event {
> > +	struct mma9553_event_info *info;
> > +	bool enabled;
> > +};
> > +
> > +struct mma9553_conf_regs {
> > +	u16 sleepmin;
> > +	u16 sleepmax;
> > +	u16 sleepthd;
> > +	u16 config;
> > +	u16 height_weight;
> > +	u16 filter;
> > +	u16 speed_step;
> > +	u16 actthd;
> > +} __packed;
> > +
> > +struct mma9553_data {
> > +	struct i2c_client *client;
> > +	struct mutex mutex;
> > +	struct mma9553_conf_regs conf;
> > +	struct mma9553_event events[MMA9553_EVENTS_INFO_SIZE];
> > +	int num_events;
> > +	u8 gpio_bitnum;
> > +	/*
> > +	 * This is used for all features that depend on step count:
> > +	 * step count, distance, speed, calories.
> > +	 */
> > +	bool stepcnt_enabled;
> > +	u16 stepcnt;
> > +	u8 activity;
> > +	s64 timestamp;
> > +};
> > +
> > +static u8 mma9553_get_bits(u16 val, u16 mask)
> > +{
> > +	return (val & mask) >> (ffs(mask) - 1);
> > +}
> > +
> > +static u16 mma9553_set_bits(u16 current_val, u16 val, u16 mask)
> > +{
> > +	return (current_val & ~mask) | (val << (ffs(mask) - 1));
> > +}
> > +
> > +static enum iio_modifier mma9553_activity_to_mod(enum activity_level activity)
> > +{
> > +	switch (activity) {
> > +	case ACTIVITY_RUNNING:
> > +		return IIO_MOD_RUNNING;
> > +	case ACTIVITY_JOGGING:
> > +		return IIO_MOD_JOGGING;
> > +	case ACTIVITY_WALKING:
> > +		return IIO_MOD_WALKING;
> > +	case ACTIVITY_REST:
> > +		return IIO_MOD_STILL;
> > +	case ACTIVITY_UNKNOWN:
> > +	default:
> > +		return IIO_NO_MOD;
> > +	}
> > +}
> > +
> > +static void mma9553_init_events(struct mma9553_data *data)
> > +{
> > +	int i;
> > +
> > +	data->num_events = MMA9553_EVENTS_INFO_SIZE;
> > +	for (i = 0; i < data->num_events; i++) {
> > +		data->events[i].info = &mma9553_events_info[i];
> > +		data->events[i].enabled = false;
> > +	}
> > +}
> > +
> > +static struct mma9553_event *mma9553_get_event(struct mma9553_data *data,
> > +					       enum iio_chan_type type,
> > +					       enum iio_modifier mod,
> > +					       enum iio_event_direction dir)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < data->num_events; i++)
> > +		if (data->events[i].info->type == type &&
> > +		    data->events[i].info->mod == mod &&
> > +		    data->events[i].info->dir == dir)
> > +			return &data->events[i];
> > +
> > +	return NULL;
> > +}
> > +
> > +static bool mma9553_is_any_event_enabled(struct mma9553_data *data,
> > +					 bool check_type,
> > +					 enum iio_chan_type type)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < data->num_events; i++)
> > +		if ((check_type && data->events[i].info->type == type &&
> > +		     data->events[i].enabled) ||
> > +		     (!check_type && data->events[i].enabled))
> > +			return true;
> > +
> > +	return false;
> > +}
> > +
> > +static int mma9553_set_config(struct mma9553_data *data, u16 reg,
> > +			      u16 *p_reg_val, u16 val, u16 mask)
> > +{
> > +	int ret, retries;
> > +	u16 reg_val, config;
> > +
> > +	reg_val = *p_reg_val;
> > +	if (val == mma9553_get_bits(reg_val, mask))
> > +		return 0;
> > +
> > +	reg_val = mma9553_set_bits(reg_val, val, mask);
> > +	ret = mma9551_write_config_word(data->client, MMA9551_APPID_PEDOMETER,
> > +					reg, reg_val);
> > +	if (ret < 0) {
> > +		dev_err(&data->client->dev,
> > +			"error writing config register 0x%x\n", reg);
> > +		return ret;
> > +	}
> > +
> > +	*p_reg_val = reg_val;
> > +
> > +	/* Reinitializes the pedometer with current configuration values */
> > +	config = mma9553_set_bits(data->conf.config, 1, MMA9553_CONF_CONFIG);
> > +
> > +	ret = mma9551_write_config_word(data->client, MMA9551_APPID_PEDOMETER,
> > +					MMA9553_CONF_CONF_STEPLEN, config);
> > +	if (ret < 0) {
> > +		dev_err(&data->client->dev,
> > +			"error writing config register 0x%x\n",
> > +			MMA9553_CONF_CONF_STEPLEN);
> > +		return ret;
> > +	}
> > +
> > +	retries = MMA9553_CONFIG_RETRIES;
> > +	do {
> > +		mma9551_sleep(MMA9553_DEFAULT_SAMPLE_RATE);
> > +		ret = mma9551_read_config_word(data->client,
> > +					       MMA9551_APPID_PEDOMETER,
> > +					       MMA9553_CONF_CONF_STEPLEN,
> > +					       &config);
> > +		if (ret < 0)
> > +			return ret;
> > +	} while (mma9553_get_bits(config, MMA9553_CONF_CONFIG) &&
> > +		 --retries > 0);
> > +
> > +	return 0;
> > +}
> > +
> > +static int mma9553_read_activity_stepcnt(struct mma9553_data *data,
> > +					 u8 *activity, u16 *stepcnt)
> > +{
> > +	u32 status_stepcnt;
> > +	u16 status;
> > +	int ret;
> > +
> > +	ret = mma9551_read_status_words(data->client, MMA9551_APPID_PEDOMETER,
> > +					MMA9553_STATUS, sizeof(u32),
> > +					(u16 *) &status_stepcnt);
> > +	if (ret < 0) {
> > +		dev_err(&data->client->dev,
> > +			"error reading status and stepcnt\n");
> > +		return ret;
> > +	}
> > +
> > +	status = status_stepcnt & MMA9553_CONF_WORD;
> > +	*activity = mma9553_get_bits(status, MMA9553_STATUS_ACTIVITY);
> > +	*stepcnt = status_stepcnt >> 16;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mma9553_conf_gpio(struct mma9553_data *data)
> > +{
> > +	u8 bitnum = 0, appid = MMA9551_APPID_PEDOMETER;
> > +	int ret;
> > +	struct mma9553_event *ev_step_detect;
> > +	bool activity_enabled;
> > +
> > +	activity_enabled =
> > +	    mma9553_is_any_event_enabled(data, true, IIO_ACTIVITY);
> > +	ev_step_detect =
> > +	    mma9553_get_event(data, IIO_STEPS, IIO_NO_MOD, IIO_EV_DIR_NONE);
> > +
> > +	/*
> > +	 * If both step detector and activity are enabled, use the MRGFL bit.
> > +	 * This bit is the logical OR of the SUSPCHG, STEPCHG, and ACTCHG flags.
> > +	 */
> > +	if (activity_enabled && ev_step_detect->enabled)
> > +		bitnum = STATUS_TO_BITNUM(MMA9553_STATUS_MRGFL);
> > +	else if (ev_step_detect->enabled)
> > +		bitnum = STATUS_TO_BITNUM(MMA9553_STATUS_STEPCHG);
> > +	else if (activity_enabled)
> > +		bitnum = STATUS_TO_BITNUM(MMA9553_STATUS_ACTCHG);
> > +	else			/* Reset */
> > +		appid = MMA9551_APPID_NONE;
> > +
> > +	if (data->gpio_bitnum == bitnum)
> > +		return 0;
> > +
> > +	/* Save initial values for activity and stepcnt */
> > +	if (activity_enabled || ev_step_detect->enabled)
> > +		mma9553_read_activity_stepcnt(data, &data->activity,
> > +					      &data->stepcnt);
> > +
> > +	ret = mma9551_gpio_config(data->client,
> > +				  MMA9553_DEFAULT_GPIO_PIN,
> > +				  appid, bitnum, MMA9553_DEFAULT_GPIO_POLARITY);
> > +	if (ret < 0)
> > +		return ret;
> > +	data->gpio_bitnum = bitnum;
> > +
> > +	return 0;
> > +}
> > +
> > +static int mma9553_init(struct mma9553_data *data)
> > +{
> > +	int ret;
> > +
> > +	ret = mma9551_read_version(data->client);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * Read all the pedometer configuration registers. This is used as
> > +	 * a device identification command to differentiate the MMA9553L
> > +	 * from the MMA9550L.
> > +	 */
> > +	ret =
> > +	    mma9551_read_config_words(data->client, MMA9551_APPID_PEDOMETER,
> > +				      MMA9553_CONF_SLEEPMIN,
> > +				      sizeof(data->conf), (u16 *) &data->conf);
> > +	if (ret < 0) {
> > +		dev_err(&data->client->dev,
> > +			"device is not MMA9553L: failed to read cfg regs\n");
> > +		return ret;
> > +	}
> > +
> > +
> > +	/* Reset gpio */
> > +	data->gpio_bitnum = -1;
> > +	ret = mma9553_conf_gpio(data);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = mma9551_app_reset(data->client, MMA9551_RSC_PED);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/* Init config registers */
> > +	data->conf.sleepmin = MMA9553_DEFAULT_SLEEPMIN;
> > +	data->conf.sleepmax = MMA9553_DEFAULT_SLEEPMAX;
> > +	data->conf.sleepthd = MMA9553_DEFAULT_SLEEPTHD;
> > +	data->conf.config =
> > +	    mma9553_set_bits(data->conf.config, 1, MMA9553_CONF_CONFIG);
> > +	/*
> > +	 * Clear the activity debounce counter when the activity level changes,
> > +	 * so that the confidence level applies for any activity level.
> > +	 */
> > +	data->conf.config =
> > +	    mma9553_set_bits(data->conf.config, 1, MMA9553_CONF_ACT_DBCNTM);
> > +	ret =
> > +	    mma9551_write_config_words(data->client, MMA9551_APPID_PEDOMETER,
> > +				       MMA9553_CONF_SLEEPMIN,
> > +				       sizeof(data->conf), (u16 *) &data->conf);
> > +	if (ret < 0) {
> > +		dev_err(&data->client->dev,
> > +			"failed to write configuration registers\n");
> > +		return ret;
> > +	}
> > +
> > +	return mma9551_set_device_state(data->client, true);
> > +}
> > +
> > +static int mma9553_read_raw(struct iio_dev *indio_dev,
> > +			    struct iio_chan_spec const *chan,
> > +			    int *val, int *val2, long mask)
> > +{
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +	int ret;
> > +	u16 tmp;
> > +	u8 activity;
> > +	bool powered_on;
> > +
> > +	switch (mask) {
> > +	case IIO_CHAN_INFO_PROCESSED:
> > +		switch (chan->type) {
> > +		case IIO_STEPS:
> > +			/*
> > +			 * The HW only counts steps and other dependent
> > +			 * parameters (speed, distance, calories, activity)
> > +			 * if power is on (from enabling an event or the
> > +			 * step counter */
> > +			powered_on =
> > +			    mma9553_is_any_event_enabled(data, false, 0) ||
> > +			    data->stepcnt_enabled;
> > +			if (!powered_on) {
> > +				dev_err(&data->client->dev,
> > +					"No channels enabled\n");
> > +				return -EINVAL;
> > +			}
> > +			mutex_lock(&data->mutex);
> > +			ret = mma9551_read_status_word(data->client,
> > +						       MMA9551_APPID_PEDOMETER,
> > +						       MMA9553_STEPCNT, &tmp);
> > +			mutex_unlock(&data->mutex);
> > +			if (ret < 0)
> > +				return ret;
> > +			*val = tmp;
> > +			return IIO_VAL_INT;
> > +		case IIO_DISTANCE:
> > +			powered_on =
> > +			    mma9553_is_any_event_enabled(data, false, 0) ||
> > +			    data->stepcnt_enabled;
> > +			if (!powered_on) {
> > +				dev_err(&data->client->dev,
> > +					"No channels enabled\n");
> > +				return -EINVAL;
> > +			}
> > +			mutex_lock(&data->mutex);
> > +			ret = mma9551_read_status_word(data->client,
> > +						       MMA9551_APPID_PEDOMETER,
> > +						       MMA9553_DISTANCE, &tmp);
> > +			mutex_unlock(&data->mutex);
> > +			if (ret < 0)
> > +				return ret;
> > +			*val = tmp;
> > +			return IIO_VAL_INT;
> > +		case IIO_ACTIVITY:
> > +			powered_on =
> > +			    mma9553_is_any_event_enabled(data, false, 0) ||
> > +			    data->stepcnt_enabled;
> > +			if (!powered_on) {
> > +				dev_err(&data->client->dev,
> > +					"No channels enabled\n");
> > +				return -EINVAL;
> > +			}
> > +			mutex_lock(&data->mutex);
> > +			ret = mma9551_read_status_word(data->client,
> > +						       MMA9551_APPID_PEDOMETER,
> > +						       MMA9553_STATUS, &tmp);
> > +			mutex_unlock(&data->mutex);
> > +			if (ret < 0)
> > +				return ret;
> > +
> > +			activity =
> > +			    mma9553_get_bits(tmp, MMA9553_STATUS_ACTIVITY);
> > +
> > +			/*
> > +			 * The device does not support confidence value levels,
> > +			 * so we will always have 100% for current activity and
> > +			 * 0% for the others.
> > +			 */
> > +			if (chan->channel2 == mma9553_activity_to_mod(activity))
> > +				*val = 100;
> > +			else
> > +				*val = 0;
> > +			return IIO_VAL_INT;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	case IIO_CHAN_INFO_RAW:
> > +		switch (chan->type) {
> > +		case IIO_VELOCITY:	/* m/h */
> > +			if (chan->channel2 != IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z)
> > +				return -EINVAL;
> > +			powered_on =
> > +			    mma9553_is_any_event_enabled(data, false, 0) ||
> > +			    data->stepcnt_enabled;
> > +			if (!powered_on) {
> > +				dev_err(&data->client->dev,
> > +					"No channels enabled\n");
> > +				return -EINVAL;
> > +			}
> > +			mutex_lock(&data->mutex);
> > +			ret = mma9551_read_status_word(data->client,
> > +						       MMA9551_APPID_PEDOMETER,
> > +						       MMA9553_SPEED, &tmp);
> > +			mutex_unlock(&data->mutex);
> > +			if (ret < 0)
> > +				return ret;
> > +			*val = tmp;
> > +			return IIO_VAL_INT;
> > +		case IIO_ENERGY:	/* Cal or kcal */
> > +			powered_on =
> > +			    mma9553_is_any_event_enabled(data, false, 0) ||
> > +			    data->stepcnt_enabled;
> > +			if (!powered_on) {
> > +				dev_err(&data->client->dev,
> > +					"No channels enabled\n");
> > +				return -EINVAL;
> > +			}
> > +			mutex_lock(&data->mutex);
> > +			ret = mma9551_read_status_word(data->client,
> > +						       MMA9551_APPID_PEDOMETER,
> > +						       MMA9553_CALORIES, &tmp);
> > +			mutex_unlock(&data->mutex);
> > +			if (ret < 0)
> > +				return ret;
> > +			*val = tmp;
> > +			return IIO_VAL_INT;
> > +		case IIO_ACCEL:
> > +			mutex_lock(&data->mutex);
> > +			ret = mma9551_read_accel_chan(data->client,
> > +						      chan, val, val2);
> > +			mutex_unlock(&data->mutex);
> > +			return ret;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	case IIO_CHAN_INFO_SCALE:
> > +		switch (chan->type) {
> > +		case IIO_VELOCITY:	/* m/h to m/s */
> > +			if (chan->channel2 != IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z)
> > +				return -EINVAL;
> > +			*val = 0;
> > +			*val2 = 277;	/* 0.000277 */
> > +			return IIO_VAL_INT_PLUS_MICRO;
> > +		case IIO_ENERGY:	/* Cal or kcal to J */
> > +			*val = 4184;
> > +			return IIO_VAL_INT;
> > +		case IIO_ACCEL:
> > +			return mma9551_read_accel_scale(val, val2);
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	case IIO_CHAN_INFO_ENABLE:
> > +		*val = data->stepcnt_enabled;
> > +		return IIO_VAL_INT;
> > +	case IIO_CHAN_INFO_CALIBHEIGHT:
> > +		*val = mma9553_get_bits(data->conf.height_weight,
> > +					MMA9553_CONF_HEIGHT);
> > +		return IIO_VAL_INT;
> > +	case IIO_CHAN_INFO_CALIBWEIGHT:
> > +		*val = mma9553_get_bits(data->conf.height_weight,
> > +					MMA9553_CONF_WEIGHT);
> > +		return IIO_VAL_INT;
> > +	case IIO_CHAN_INFO_FILTER_OUTLIERS_THRESH:
> > +		switch (chan->type) {
> > +		case IIO_STEPS:
> > +			*val = mma9553_get_bits(data->conf.filter,
> > +						MMA9553_CONF_FILTSTEP);
> > +			return IIO_VAL_INT;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	case IIO_CHAN_INFO_FILTER_OUTLIERS_PERIOD:
> > +		switch (chan->type) {
> > +		case IIO_STEPS:
> > +			*val = mma9553_get_bits(data->conf.filter,
> > +						MMA9553_CONF_FILTTIME);
> > +			return IIO_VAL_INT;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	case IIO_CHAN_INFO_INT_TIME:
> > +		switch (chan->type) {
> > +		case IIO_VELOCITY:
> > +			if (chan->channel2 != IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z)
> > +				return -EINVAL;
> > +			*val = mma9553_get_bits(data->conf.speed_step,
> > +						MMA9553_CONF_SPDPRD);
> > +			return IIO_VAL_INT;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > +
> > +static int mma9553_write_raw(struct iio_dev *indio_dev,
> > +			     struct iio_chan_spec const *chan,
> > +			     int val, int val2, long mask)
> > +{
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +	int ret;
> > +
> > +	switch (mask) {
> > +	case IIO_CHAN_INFO_ENABLE:
> > +		if (data->stepcnt_enabled == !!val)
> > +			return 0;
> > +		mutex_lock(&data->mutex);
> > +		ret = mma9551_set_power_state(data->client, val);
> > +		if (ret < 0) {
> > +			mutex_unlock(&data->mutex);
> > +			return ret;
> > +		}
> > +		data->stepcnt_enabled = val;
> > +		mutex_unlock(&data->mutex);
> > +		return 0;
> > +	case IIO_CHAN_INFO_CALIBHEIGHT:
> > +		if (val < 0 || val > 255)
> > +			return -EINVAL;
> We are being rather inconsistent in having calibheight in cm rather than
> m (as per distance etc). I wonder if now is the time to change it whilst
> we have few users...

Sure, I'll change it.
> > +		mutex_lock(&data->mutex);
> > +		ret = mma9553_set_config(data,
> > +					 MMA9553_CONF_HEIGHT_WEIGHT,
> > +					 &data->conf.height_weight,
> > +					 val, MMA9553_CONF_HEIGHT);
> > +		mutex_unlock(&data->mutex);
> > +		return ret;
> > +	case IIO_CHAN_INFO_CALIBWEIGHT:
> > +		if (val < 0 || val > 255)
> > +			return -EINVAL;
> > +		mutex_lock(&data->mutex);
> > +		ret = mma9553_set_config(data,
> > +					 MMA9553_CONF_HEIGHT_WEIGHT,
> > +					 &data->conf.height_weight,
> > +					 val, MMA9553_CONF_WEIGHT);
> > +		mutex_unlock(&data->mutex);
> > +		return ret;
> > +	case IIO_CHAN_INFO_FILTER_OUTLIERS_THRESH:
> > +		switch (chan->type) {
> > +		case IIO_STEPS:
> > +			/*
> > +			 * Set to 0 to disable step filtering. If the value
> > +			 * specified is greater than 6, then 6 will be used.
> > +			 */
> > +			if (val < 0)
> > +				return -EINVAL;
> > +			if (val > 6)
> > +				val = 6;
> > +			mutex_lock(&data->mutex);
> > +			ret = mma9553_set_config(data, MMA9553_CONF_FILTER,
> > +						 &data->conf.filter, val,
> > +						 MMA9553_CONF_FILTSTEP);
> > +			mutex_unlock(&data->mutex);
> > +			return ret;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	case IIO_CHAN_INFO_FILTER_OUTLIERS_PERIOD:
> > +		switch (chan->type) {
> > +		case IIO_STEPS:
> > +			if (val < 0 || val > 127)
> > +				return -EINVAL;
> > +			mutex_lock(&data->mutex);
> > +			ret = mma9553_set_config(data, MMA9553_CONF_FILTER,
> > +						 &data->conf.filter, val,
> > +						 MMA9553_CONF_FILTTIME);
> > +			mutex_unlock(&data->mutex);
> > +			return ret;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	case IIO_CHAN_INFO_INT_TIME:
> > +		switch (chan->type) {
> > +		case IIO_VELOCITY:
> > +			if (chan->channel2 != IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z)
> > +				return -EINVAL;
> > +			/*
> > +			 * If set to a value greater than 5, then 5 will be
> > +			 * used. Warning: Do not set SPDPRD to 0 or 1 as
> > +			 * this may cause undesirable behavior.
> > +			 */
> > +			if (val < 2)
> > +				return -EINVAL;
> > +			if (val > 5)
> > +				val = 5;
> > +			mutex_lock(&data->mutex);
> > +			ret = mma9553_set_config(data, MMA9553_CONF_SPEED_STEP,
> > +						 &data->conf.speed_step, val,
> > +						 MMA9553_CONF_SPDPRD);
> > +			mutex_unlock(&data->mutex);
> > +			return ret;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > +
> > +static int mma9553_read_event_config(struct iio_dev *indio_dev,
> > +				     const struct iio_chan_spec *chan,
> > +				     enum iio_event_type type,
> > +				     enum iio_event_direction dir)
> > +{
> > +
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +	struct mma9553_event *event;
> > +
> > +	event = mma9553_get_event(data, chan->type, chan->channel2, dir);
> > +	if (!event)
> > +		return -EINVAL;
> > +
> > +	return event->enabled;
> > +}
> > +
> > +static int mma9553_write_event_config(struct iio_dev *indio_dev,
> > +				      const struct iio_chan_spec *chan,
> > +				      enum iio_event_type type,
> > +				      enum iio_event_direction dir, int state)
> > +{
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +	struct mma9553_event *event;
> > +	int ret;
> > +
> > +	event = mma9553_get_event(data, chan->type, chan->channel2, dir);
> > +	if (!event)
> > +		return -EINVAL;
> > +
> > +	if (event->enabled == state)
> > +		return 0;
> > +
> > +	mutex_lock(&data->mutex);
> > +
> > +	ret = mma9551_set_power_state(data->client, state);
> > +	if (ret < 0)
> > +		goto err_out;
> > +	event->enabled = state;
> > +
> > +	ret = mma9553_conf_gpio(data);
> > +	if (ret < 0)
> > +		goto err_conf_gpio;
> > +
> > +	mutex_unlock(&data->mutex);
> > +
> > +	return ret;
> > +
> > +err_conf_gpio:
> > +	if (state) {
> > +		event->enabled = false;
> > +		mma9551_set_power_state(data->client, false);
> > +	}
> > +err_out:
> > +	mutex_unlock(&data->mutex);
> > +	return ret;
> > +}
> > +
> > +static int mma9553_read_event_value(struct iio_dev *indio_dev,
> > +				    const struct iio_chan_spec *chan,
> > +				    enum iio_event_type type,
> > +				    enum iio_event_direction dir,
> > +				    enum iio_event_info info,
> > +				    int *val, int *val2)
> > +{
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +
> > +	*val2 = 0;
> > +	switch (info) {
> > +	case IIO_EV_INFO_VALUE:
> > +		switch (chan->type) {
> > +		case IIO_STEPS:
> > +			*val = mma9553_get_bits(data->conf.speed_step,
> > +						MMA9553_CONF_STEPCOALESCE);
> > +			return IIO_VAL_INT;
> > +		case IIO_ACTIVITY:
> > +			/*
> > +			 * The device does not support confidence value levels.
> > +			 * We set an average of 50%.
> > +			 */
> > +			*val = 50;
> > +			return IIO_VAL_INT;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	case IIO_EV_INFO_PERIOD:
> > +		switch (chan->type) {
> > +		case IIO_ACTIVITY:
> > +			*val = MMA9553_ACTIVITY_THD_TO_SEC(data->conf.actthd);
> > +			return IIO_VAL_INT;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > +
> > +static int mma9553_write_event_value(struct iio_dev *indio_dev,
> > +				     const struct iio_chan_spec *chan,
> > +				     enum iio_event_type type,
> > +				     enum iio_event_direction dir,
> > +				     enum iio_event_info info,
> > +				     int val, int val2)
> > +{
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +	int ret;
> > +
> > +	switch (info) {
> > +	case IIO_EV_INFO_VALUE:
> > +		switch (chan->type) {
> > +		case IIO_STEPS:
> > +			if (val < 0 || val > 255)
> > +				return -EINVAL;
> > +			mutex_lock(&data->mutex);
> > +			ret = mma9553_set_config(data, MMA9553_CONF_SPEED_STEP,
> > +						 &data->conf.speed_step, val,
> > +						 MMA9553_CONF_STEPCOALESCE);
> > +			mutex_unlock(&data->mutex);
> > +			return ret;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	case IIO_EV_INFO_PERIOD:
> > +		switch (chan->type) {
> > +		case IIO_ACTIVITY:
> > +			mutex_lock(&data->mutex);
> > +			ret = mma9553_set_config(data, MMA9553_CONF_ACTTHD,
> > +						 &data->conf.actthd,
> > +						 MMA9553_ACTIVITY_SEC_TO_THD
> > +						 (val), MMA9553_CONF_WORD);
> > +			mutex_unlock(&data->mutex);
> > +			return ret;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > +
> > +static int mma9553_get_calibgender_mode(struct iio_dev *indio_dev,
> > +					const struct iio_chan_spec *chan)
> > +{
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +	u8 gender;
> > +
> > +	gender = mma9553_get_bits(data->conf.filter, MMA9553_CONF_MALE);
> > +	/*
> > +	 * HW expects 0 for female and 1 for male,
> > +	 * while iio index is 0 for male and 1 for female
> > +	 */
> > +	return !gender;
> > +}
> > +
> > +static int mma9553_set_calibgender_mode(struct iio_dev *indio_dev,
> > +					const struct iio_chan_spec *chan,
> > +					unsigned int mode)
> > +{
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +	u8 gender = !mode;
> > +	int ret;
> > +
> > +	if ((mode != 0) && (mode != 1))
> > +		return -EINVAL;
> > +	mutex_lock(&data->mutex);
> > +	ret = mma9553_set_config(data, MMA9553_CONF_FILTER, &data->conf.filter,
> > +				 gender, MMA9553_CONF_MALE);
> > +	mutex_unlock(&data->mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static const struct iio_event_spec mma9553_step_event = {
> > +	.type = IIO_EV_TYPE_CHANGE,
> > +	.dir = IIO_EV_DIR_NONE,
> > +	.mask_separate = BIT(IIO_EV_INFO_ENABLE) | BIT(IIO_EV_INFO_VALUE),
> > +};
> > +
> > +static const struct iio_event_spec mma9553_activity_events[] = {
> > +	{
> > +		.type = IIO_EV_TYPE_THRESH,
> > +		.dir = IIO_EV_DIR_RISING,
> > +		.mask_separate = BIT(IIO_EV_INFO_ENABLE) |
> > +				 BIT(IIO_EV_INFO_VALUE) |
> > +				 BIT(IIO_EV_INFO_PERIOD),
> > +	 },
> > +	{
> > +		.type = IIO_EV_TYPE_THRESH,
> > +		.dir = IIO_EV_DIR_FALLING,
> > +		.mask_separate = BIT(IIO_EV_INFO_ENABLE) |
> > +				 BIT(IIO_EV_INFO_VALUE) |
> > +				 BIT(IIO_EV_INFO_PERIOD),
> > +	},
> > +};
> > +
> > +static const char * const calibgender_modes[] = { "male", "female" };
> > +
> > +static const struct iio_enum mma9553_calibgender_enum = {
> > +	.items = calibgender_modes,
> > +	.num_items = ARRAY_SIZE(calibgender_modes),
> > +	.get = mma9553_get_calibgender_mode,
> > +	.set = mma9553_set_calibgender_mode,
> > +};
> > +
> > +static const struct iio_chan_spec_ext_info mma9553_ext_info[] = {
> > +	IIO_CALIBGENDER_EXT_INFO(IIO_SHARED_BY_TYPE, &mma9553_calibgender_enum),
> > +	{},
> > +};
> > +
> > +#define MMA9553_PEDOMETER_CHANNEL(_type, _mask) {		\
> > +	.type = _type,						\
> > +	.info_mask_separate = BIT(IIO_CHAN_INFO_ENABLE)      |	\
> > +			      BIT(IIO_CHAN_INFO_CALIBHEIGHT) |	\
> > +			      _mask,				\
> > +	.ext_info = mma9553_ext_info,				\
> > +}
> > +
> > +#define MMA9553_ACTIVITY_CHANNEL(_chan2) {				\
> > +	.type = IIO_ACTIVITY,						\
> > +	.modified = 1,							\
> > +	.channel2 = _chan2,						\
> > +	.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),		\
> > +	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_CALIBHEIGHT),	\
> > +	.event_spec = mma9553_activity_events,				\
> > +	.num_event_specs = ARRAY_SIZE(mma9553_activity_events),		\
> > +	.ext_info = mma9553_ext_info,					\
> > +}
> > +
> > +static const struct iio_chan_spec mma9553_channels[] = {
> > +	MMA9551_ACCEL_CHANNEL(IIO_MOD_X),
> > +	MMA9551_ACCEL_CHANNEL(IIO_MOD_Y),
> > +	MMA9551_ACCEL_CHANNEL(IIO_MOD_Z),
> > +
> > +	{
> > +		.type = IIO_STEPS,
> > +		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED) |
> > +				     BIT(IIO_CHAN_INFO_ENABLE) |
> > +				     BIT(IIO_CHAN_INFO_FILTER_OUTLIERS_THRESH) |
> > +				     BIT(IIO_CHAN_INFO_FILTER_OUTLIERS_PERIOD),
> > +		.event_spec = &mma9553_step_event,
> > +		.num_event_specs = 1,
> > +	},
> > +
> > +	MMA9553_PEDOMETER_CHANNEL(IIO_DISTANCE, BIT(IIO_CHAN_INFO_PROCESSED)),
> > +	{
> > +		.type = IIO_VELOCITY,
> > +		.modified = 1,
> > +		.channel2 = IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z,
> > +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
> > +				      BIT(IIO_CHAN_INFO_SCALE) |
> > +				      BIT(IIO_CHAN_INFO_INT_TIME) |
> > +				      BIT(IIO_CHAN_INFO_ENABLE),
> > +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_CALIBHEIGHT),
> > +		.ext_info = mma9553_ext_info,
> > +	},
> > +	MMA9553_PEDOMETER_CHANNEL(IIO_ENERGY, BIT(IIO_CHAN_INFO_RAW) |
> > +				  BIT(IIO_CHAN_INFO_SCALE) |
> > +				  BIT(IIO_CHAN_INFO_CALIBWEIGHT)),
> > +
> > +	MMA9553_ACTIVITY_CHANNEL(IIO_MOD_RUNNING),
> > +	MMA9553_ACTIVITY_CHANNEL(IIO_MOD_JOGGING),
> > +	MMA9553_ACTIVITY_CHANNEL(IIO_MOD_WALKING),
> > +	MMA9553_ACTIVITY_CHANNEL(IIO_MOD_STILL),
> > +};
> > +
> > +static const struct iio_info mma9553_info = {
> > +	.driver_module = THIS_MODULE,
> > +	.read_raw = mma9553_read_raw,
> > +	.write_raw = mma9553_write_raw,
> > +	.read_event_config = mma9553_read_event_config,
> > +	.write_event_config = mma9553_write_event_config,
> > +	.read_event_value = mma9553_read_event_value,
> > +	.write_event_value = mma9553_write_event_value,
> > +};
> > +
> > +static irqreturn_t mma9553_irq_handler(int irq, void *private)
> > +{
> > +	struct iio_dev *indio_dev = private;
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +
> > +	data->timestamp = iio_get_time_ns();
> > +	/*
> > +	 * Since we only configure the interrupt pin when an
> > +	 * event is enabled, we are sure we have at least
> > +	 * one event enabled at this point.
> > +	 */
> > +	return IRQ_WAKE_THREAD;
> > +}
> > +
> > +static irqreturn_t mma9553_event_handler(int irq, void *private)
> > +{
> > +	struct iio_dev *indio_dev = private;
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +	u16 stepcnt;
> > +	u8 activity;
> > +	struct mma9553_event *ev_activity, *ev_prev_activity, *ev_step_detect;
> > +	int ret;
> > +
> > +	mutex_lock(&data->mutex);
> > +	ret = mma9553_read_activity_stepcnt(data, &activity, &stepcnt);
> > +	if (ret < 0) {
> > +		mutex_unlock(&data->mutex);
> > +		return IRQ_HANDLED;
> > +	}
> > +
> > +	ev_prev_activity =
> > +	    mma9553_get_event(data, IIO_ACTIVITY,
> > +			      mma9553_activity_to_mod(data->activity),
> > +			      IIO_EV_DIR_FALLING);
> > +	ev_activity =
> > +	    mma9553_get_event(data, IIO_ACTIVITY,
> > +			      mma9553_activity_to_mod(activity),
> > +			      IIO_EV_DIR_RISING);
> > +	ev_step_detect =
> > +	    mma9553_get_event(data, IIO_STEPS, IIO_NO_MOD, IIO_EV_DIR_NONE);
> > +
> > +	if (ev_step_detect->enabled && (stepcnt != data->stepcnt)) {
> > +		data->stepcnt = stepcnt;
> > +		iio_push_event(indio_dev,
> > +			       IIO_EVENT_CODE(IIO_STEPS, 0, IIO_NO_MOD,
> > +			       IIO_EV_DIR_NONE, IIO_EV_TYPE_CHANGE, 0, 0, 0),
> > +			       data->timestamp);
> > +	}
> > +
> > +	if (activity != data->activity) {
> > +		data->activity = activity;
> > +		/* ev_activity can be NULL if activity == ACTIVITY_UNKNOWN */
> > +		if (ev_prev_activity && ev_prev_activity->enabled)
> > +			iio_push_event(indio_dev,
> > +				       IIO_EVENT_CODE(IIO_ACTIVITY, 0,
> > +				       ev_prev_activity->info->mod,
> > +				       IIO_EV_DIR_FALLING,
> > +				       IIO_EV_TYPE_THRESH, 0, 0, 0),
> > +				       data->timestamp);
> > +
> > +		if (ev_activity && ev_activity->enabled)
> > +			iio_push_event(indio_dev,
> > +				       IIO_EVENT_CODE(IIO_ACTIVITY, 0,
> > +				       ev_activity->info->mod,
> > +				       IIO_EV_DIR_RISING,
> > +				       IIO_EV_TYPE_THRESH, 0, 0, 0),
> > +				       data->timestamp);
> > +	}
> > +	mutex_unlock(&data->mutex);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int mma9553_gpio_probe(struct i2c_client *client)
> > +{
> > +	struct device *dev;
> > +	struct gpio_desc *gpio;
> > +	int ret;
> > +
> > +	if (!client)
> > +		return -EINVAL;
> > +
> > +	dev = &client->dev;
> > +
> > +	/* data ready gpio interrupt pin */
> > +	gpio = devm_gpiod_get_index(dev, MMA9553_GPIO_NAME, 0);
> > +	if (IS_ERR(gpio)) {
> > +		dev_err(dev, "acpi gpio get index failed\n");
> > +		return PTR_ERR(gpio);
> > +	}
> > +
> > +	ret = gpiod_direction_input(gpio);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = gpiod_to_irq(gpio);
> > +
> > +	dev_dbg(dev, "gpio resource, no:%d irq:%d\n", desc_to_gpio(gpio), ret);
> > +
> > +	return ret;
> > +}
> > +
> > +static const char *mma9553_match_acpi_device(struct device *dev)
> > +{
> > +	const struct acpi_device_id *id;
> > +
> > +	id = acpi_match_device(dev->driver->acpi_match_table, dev);
> > +	if (!id)
> > +		return NULL;
> > +
> > +	return dev_name(dev);
> > +}
> > +
> > +static int mma9553_probe(struct i2c_client *client,
> > +			 const struct i2c_device_id *id)
> > +{
> > +	struct mma9553_data *data;
> > +	struct iio_dev *indio_dev;
> > +	const char *name = NULL;
> > +	int ret;
> > +
> > +	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
> > +	if (!indio_dev)
> > +		return -ENOMEM;
> > +
> > +	data = iio_priv(indio_dev);
> > +	i2c_set_clientdata(client, indio_dev);
> > +	data->client = client;
> > +
> > +	if (id)
> > +		name = id->name;
> > +	else if (ACPI_HANDLE(&client->dev))
> > +		name = mma9553_match_acpi_device(&client->dev);
> > +	else
> > +		return -ENOSYS;
> > +
> > +	mutex_init(&data->mutex);
> > +	mma9553_init_events(data);
> > +
> > +	ret = mma9553_init(data);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	indio_dev->dev.parent = &client->dev;
> > +	indio_dev->channels = mma9553_channels;
> > +	indio_dev->num_channels = ARRAY_SIZE(mma9553_channels);
> > +	indio_dev->name = name;
> > +	indio_dev->modes = INDIO_DIRECT_MODE;
> > +	indio_dev->info = &mma9553_info;
> > +
> > +	if (client->irq < 0)
> > +		client->irq = mma9553_gpio_probe(client);
> > +
> > +	if (client->irq >= 0) {
> > +		ret = devm_request_threaded_irq(&client->dev, client->irq,
> > +						mma9553_irq_handler,
> > +						mma9553_event_handler,
> > +						IRQF_TRIGGER_RISING,
> > +						MMA9553_IRQ_NAME, indio_dev);
> > +		if (ret < 0) {
> > +			dev_err(&client->dev, "request irq %d failed\n",
> > +				client->irq);
> > +			goto out_poweroff;
> > +		}
> > +
> > +	}
> > +
> > +	ret = iio_device_register(indio_dev);
> > +	if (ret < 0) {
> > +		dev_err(&client->dev, "unable to register iio device\n");
> > +		goto out_poweroff;
> > +	}
> > +
> > +	ret = pm_runtime_set_active(&client->dev);
> > +	if (ret < 0)
> > +		goto out_iio_unregister;
> > +
> > +	pm_runtime_enable(&client->dev);
> > +	pm_runtime_set_autosuspend_delay(&client->dev,
> > +					 MMA9551_AUTO_SUSPEND_DELAY_MS);
> > +	pm_runtime_use_autosuspend(&client->dev);
> > +
> > +	dev_dbg(&indio_dev->dev, "Registered device %s\n", name);
> > +
> > +	return 0;
> > +
> > +out_iio_unregister:
> > +	iio_device_unregister(indio_dev);
> > +out_poweroff:
> > +	mma9551_set_device_state(client, false);
> > +	return ret;
> > +}
> > +
> > +static int mma9553_remove(struct i2c_client *client)
> > +{
> > +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +
> > +	pm_runtime_disable(&client->dev);
> > +	pm_runtime_set_suspended(&client->dev);
> > +	pm_runtime_put_noidle(&client->dev);
> > +
> > +	iio_device_unregister(indio_dev);
> > +	mutex_lock(&data->mutex);
> > +	mma9551_set_device_state(data->client, false);
> > +	mutex_unlock(&data->mutex);
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_PM
> > +static int mma9553_runtime_suspend(struct device *dev)
> > +{
> > +	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +	int ret;
> > +
> > +	mutex_lock(&data->mutex);
> > +	ret = mma9551_set_device_state(data->client, false);
> > +	mutex_unlock(&data->mutex);
> > +	if (ret < 0) {
> > +		dev_err(&data->client->dev, "powering off device failed\n");
> > +		return -EAGAIN;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int mma9553_runtime_resume(struct device *dev)
> > +{
> > +	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +	int ret;
> > +
> > +	ret = mma9551_set_device_state(data->client, true);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	mma9551_sleep(MMA9553_DEFAULT_SAMPLE_RATE);
> > +
> > +	return 0;
> > +}
> > +#endif
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int mma9553_suspend(struct device *dev)
> > +{
> > +	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +	int ret;
> > +
> > +	mutex_lock(&data->mutex);
> > +	ret = mma9551_set_device_state(data->client, false);
> > +	mutex_unlock(&data->mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static int mma9553_resume(struct device *dev)
> > +{
> > +	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
> > +	struct mma9553_data *data = iio_priv(indio_dev);
> > +	int ret;
> > +
> > +	mutex_lock(&data->mutex);
> > +	ret = mma9551_set_device_state(data->client, true);
> > +	mutex_unlock(&data->mutex);
> > +
> > +	return ret;
> > +}
> > +#endif
> > +
> > +static const struct dev_pm_ops mma9553_pm_ops = {
> > +	SET_SYSTEM_SLEEP_PM_OPS(mma9553_suspend, mma9553_resume)
> > +	SET_RUNTIME_PM_OPS(mma9553_runtime_suspend,
> > +			   mma9553_runtime_resume, NULL)
> > +};
> > +
> > +static const struct acpi_device_id mma9553_acpi_match[] = {
> > +	{"MMA9553", 0},
> > +	{},
> > +};
> > +
> > +MODULE_DEVICE_TABLE(acpi, mma9553_acpi_match);
> > +
> > +static const struct i2c_device_id mma9553_id[] = {
> > +	{"mma9553", 0},
> > +	{},
> > +};
> > +
> > +MODULE_DEVICE_TABLE(i2c, mma9553_id);
> > +
> > +static struct i2c_driver mma9553_driver = {
> > +	.driver = {
> > +		   .name = MMA9553_DRV_NAME,
> > +		   .acpi_match_table = ACPI_PTR(mma9553_acpi_match),
> > +		   .pm = &mma9553_pm_ops,
> > +		   },
> > +	.probe = mma9553_probe,
> > +	.remove = mma9553_remove,
> > +	.id_table = mma9553_id,
> > +};
> > +
> > +module_i2c_driver(mma9553_driver);
> > +
> > +MODULE_AUTHOR("Irina Tirdea <irina.tirdea@intel.com>");
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_DESCRIPTION("MMA9553L pedometer platform driver");
> > diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
> > index b6b12ac..6770a2f 100644
> > --- a/include/linux/iio/iio.h
> > +++ b/include/linux/iio/iio.h
> > @@ -634,4 +634,15 @@ int iio_str_to_fixpoint(const char *str, int fract_mult, int *integer,
> >   */
> >  #define IIO_G_TO_M_S_2(g) ((g) * 980665ULL / 100000ULL)
> >
> > +/**
> > + * IIO_CALIBGENDER_EXT_INFO() - define the gender of the user
> > + *
> > + * @_shared:	Whether the attribute is shared between all channels
> > + * @_e:		Pointer to an iio_enum struct
> > + *
> > + */
> > +#define IIO_CALIBGENDER_EXT_INFO(_shared, _e)			       \
> > +	IIO_ENUM("calibgender", _shared, _e),			       \
> > +	IIO_ENUM_AVAILABLE("calibgender", _e)
> > +
> For now this is a little obscure to drop into the main header.
> If we get lots of instances, then perhaps it'll make sense to
> move it here.  Right now, please keep it in the driver.


Ok, will move this to the driver.
> >  #endif /* _INDUSTRIAL_IO_H_ */
> >

