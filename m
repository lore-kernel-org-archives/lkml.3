Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaLIWnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:43:32 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:55352 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaLIWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:43:30 -0500
Date: Tue, 9 Dec 2014 14:42:08 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i8k: Autodetect maximal fan speed and fan RPM
 multiplier
Message-ID: <20141209224208.GA13149@roeck-us.net>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>
 <1418155621-21644-3-git-send-email-pali.rohar@gmail.com>
 <20141209202023.GA22176@roeck-us.net>
 <201412092123.22271@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412092123.22271@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A010203.54877B12.0326,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 8
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 09:23:22PM +0100, Pali Rohár wrote:
> On Tuesday 09 December 2014 21:20:23 Guenter Roeck wrote:
> > On Tue, Dec 09, 2014 at 09:07:00PM +0100, Pali Rohár wrote:
> > > This patch adds new function i8k_get_fan_nominal_rpm() for
> > > doing SMM call which will return nominal fan RPM for
> > > specified fan speed. It returns nominal RPM value at which
> > > fan operate when speed is set. It looks like RPM value is
> > > not accurate, but still provides very useful information.
> > > 
> > > First it can be used to validate if certain fan speed could
> > > be accepted by SMM for setting fan speed and we can use
> > > this routine to detect maximal fan speed.
> > > 
> > > Second it returns RPM value, so we can check if value looks
> > > correct with multiplier 30 or multiplier 1 (until now only
> > > these two multiplier was used). If RPM value with
> > > multiplier 30 is too high, then multiplier 1 is used.
> > > 
> > > In case when SMM reports that new function is not supported
> > > we will fallback to old hardcoded values. Maximal fan speed
> > > would be 2 and RPM multiplier 30.
> > > 
> > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > ---
> > > I tested this patch only on my Dell Latitude E6440 and
> > > autodetection worked fine Before appying this patch it
> > > should be tested on some other dell machines too but if
> > > machine does not support i8k_get_fan_nominal_rpm() driver
> > > should fallback to old values. So patch should be without
> > > regressions.
> > 
> > It looks like many of your error checks are unnecessary.
> > Why did you add those ?
> > 
> > Please refrain from adding unnecessary code.
> > 
> > Guenter
> > 
> 
> Which error checks do you mean?
> 
There are several you added. I noticed the ones around 'index', which
would only be hit on coding errors. At that point I stopped looking
further and did not verify which of the other added error checks are
unnecessary as well.

A quick additional check reveals that the fan variable range check in
i8k_get_fan_nominal_rpm is completely unnecessary - if the range
was wrong, the calling code would fail as well, since you unconditionally
write into an array indexed by the very same variable. Given the simplicity
of the calling code, it can even be mathematically proven that the error
condition you are checking can never happen.

With that I really stopped looking further.

Guenter

> > > ---
> > > 
> > >  drivers/char/i8k.c       |  122
> > >  ++++++++++++++++++++++++++++++++++++++--------
> > >  include/uapi/linux/i8k.h |    4 +-
> > >  2 files changed, 104 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> > > index 31e4beb..8bdbed2 100644
> > > --- a/drivers/char/i8k.c
> > > +++ b/drivers/char/i8k.c
> > > @@ -42,12 +42,14 @@
> > > 
> > >  #define I8K_SMM_GET_FAN_SPEED	0x00a3
> > >  #define I8K_SMM_SET_FAN_SPEED	0x01a3
> > >  #define I8K_SMM_GET_FAN_RPM	0x02a3
> > > 
> > > +#define I8K_SMM_GET_FAN_NOM_RPM	0x04a3
> > > 
> > >  #define I8K_SMM_GET_TEMP	0x10a3
> > >  #define I8K_SMM_GET_TEMP_TYPE	0x11a3
> > >  #define I8K_SMM_GET_DELL_SIG1	0xfea3
> > >  #define I8K_SMM_GET_DELL_SIG2	0xffa3
> > > 
> > > -#define I8K_FAN_MULT		30
> > > +#define I8K_FAN_DEFAULT_MULT	30
> > > +#define I8K_FAN_MAX_RPM		30000
> > > 
> > >  #define I8K_MAX_TEMP		127
> > >  
> > >  #define I8K_FN_NONE		0x00
> > > 
> > > @@ -64,9 +66,9 @@ static DEFINE_MUTEX(i8k_mutex);
> > > 
> > >  static char bios_version[4];
> > >  static struct device *i8k_hwmon_dev;
> > >  static u32 i8k_hwmon_flags;
> > > 
> > > -static int i8k_fan_mult;
> > > -static int i8k_pwm_mult;
> > > -static int i8k_fan_max = I8K_FAN_HIGH;
> > > +static int i8k_fan_mult[I8K_FAN_COUNT];
> > > +static int i8k_pwm_mult[I8K_FAN_COUNT];
> > > +static int i8k_fan_max[I8K_FAN_COUNT];
> > > 
> > >  #define I8K_HWMON_HAVE_TEMP1	(1 << 0)
> > >  #define I8K_HWMON_HAVE_TEMP2	(1 << 1)
> > > 
> > > @@ -95,13 +97,13 @@ static bool power_status;
> > > 
> > >  module_param(power_status, bool, 0600);
> > >  MODULE_PARM_DESC(power_status, "Report power status in
> > >  /proc/i8k");
> > > 
> > > -static int fan_mult = I8K_FAN_MULT;
> > > +static int fan_mult;
> > > 
> > >  module_param(fan_mult, int, 0);
> > > 
> > > -MODULE_PARM_DESC(fan_mult, "Factor to multiply fan rpm
> > > with"); +MODULE_PARM_DESC(fan_mult, "Factor to multiply fan
> > > rpm with (default: autodetect)");
> > > 
> > > -static int fan_max = I8K_FAN_HIGH;
> > > +static int fan_max;
> > > 
> > >  module_param(fan_max, int, 0);
> > > 
> > > -MODULE_PARM_DESC(fan_max, "Maximum configurable fan
> > > speed"); +MODULE_PARM_DESC(fan_max, "Maximum configurable
> > > fan speed (default: autodetect)");
> > > 
> > >  static int i8k_open_fs(struct inode *inode, struct file
> > >  *file); static long i8k_ioctl(struct file *, unsigned int,
> > >  unsigned long);
> > > 
> > > @@ -271,8 +273,25 @@ static int i8k_get_fan_rpm(int fan)
> > > 
> > >  {
> > >  
> > >  	struct smm_regs regs = { .eax = I8K_SMM_GET_FAN_RPM, };
> > > 
> > > +	if (fan < 0 || fan >= I8K_FAN_COUNT)
> > > +		return -EINVAL;
> > > +
> > > 
> > >  	regs.ebx = fan & 0xff;
> > > 
> > > -	return i8k_smm(&regs) ? : (regs.eax & 0xffff) *
> > > i8k_fan_mult; +	return i8k_smm(&regs) ? : (regs.eax &
> > > 0xffff) * i8k_fan_mult[fan]; +}
> > > +
> > > +/*
> > > + * Read the fan nominal rpm for specific fan speed.
> > > + */
> > > +static int i8k_get_fan_nominal_rpm(int fan, int speed)
> > > +{
> > > +	struct smm_regs regs = { .eax = I8K_SMM_GET_FAN_NOM_RPM,
> > > }; +
> > > +	if (fan < 0 || fan >= I8K_FAN_COUNT)
> > > +		return -EINVAL;
> > > +
> > > +	regs.ebx = (fan & 0xff) | (speed << 8);
> > > +	return i8k_smm(&regs) ? : (regs.eax & 0xffff) *
> > > i8k_fan_mult[fan];
> > > 
> > >  }
> > >  
> > >  /*
> > > 
> > > @@ -282,9 +301,12 @@ static int i8k_set_fan_speed(int fan,
> > > int speed)
> > > 
> > >  {
> > >  
> > >  	struct smm_regs regs = { .eax = I8K_SMM_SET_FAN_SPEED, };
> > > 
> > > -	speed = (speed < 0) ? 0 : ((speed > i8k_fan_max) ?
> > > i8k_fan_max : speed); -	regs.ebx = (fan & 0xff) | (speed <<
> > > 8);
> > > +	if (speed < 0)
> > > +		speed = 0;
> > > +	if (fan >= 0 && fan < I8K_FAN_COUNT && speed >
> > > i8k_fan_max[fan]) +		speed = i8k_fan_max[fan];
> > > 
> > > +	regs.ebx = (fan & 0xff) | (speed << 8);
> > > 
> > >  	return i8k_smm(&regs) ? : i8k_get_fan_speed(fan);
> > >  
> > >  }
> > > 
> > > @@ -559,10 +581,14 @@ static ssize_t
> > > i8k_hwmon_show_pwm(struct device *dev,
> > > 
> > >  	int index = to_sensor_dev_attr(devattr)->index;
> > >  	int fan_speed;
> > > 
> > > +	if (index < 0 || index >= I8K_FAN_COUNT)
> > > +		return -EINVAL;
> > > +
> > > 
> > >  	fan_speed = i8k_get_fan_speed(index);
> > >  	if (fan_speed < 0)
> > >  	
> > >  		return -EIO;
> > > 
> > > -	return sprintf(buf, "%d\n", clamp_val(fan_speed *
> > > i8k_pwm_mult, 0, 255)); +	return sprintf(buf, "%d\n",
> > > clamp_val(fan_speed * i8k_pwm_mult[index], +					
>       0,
> > > 255));
> > > 
> > >  }
> > >  
> > >  static ssize_t i8k_hwmon_set_pwm(struct device *dev,
> > > 
> > > @@ -573,10 +599,14 @@ static ssize_t
> > > i8k_hwmon_set_pwm(struct device *dev,
> > > 
> > >  	unsigned long val;
> > >  	int err;
> > > 
> > > +	if (index < 0 || index >= I8K_FAN_COUNT)
> > > +		return -EINVAL;
> > > +
> > > 
> > >  	err = kstrtoul(buf, 10, &val);
> > >  	if (err)
> > >  	
> > >  		return err;
> > > 
> > > -	val = clamp_val(DIV_ROUND_CLOSEST(val, i8k_pwm_mult), 0,
> > > i8k_fan_max); +	val = clamp_val(DIV_ROUND_CLOSEST(val,
> > > i8k_pwm_mult[index]), 0, +			i8k_fan_max[index]);
> > > 
> > >  	mutex_lock(&i8k_mutex);
> > >  	err = i8k_set_fan_speed(index, val);
> > > 
> > > @@ -854,7 +884,9 @@ MODULE_DEVICE_TABLE(dmi, i8k_dmi_table);
> > > 
> > >   */
> > >  
> > >  static int __init i8k_probe(void)
> > >  {
> > > 
> > > +	const struct i8k_config_data *conf;
> > > 
> > >  	const struct dmi_system_id *id;
> > > 
> > > +	int fan, val, ret;
> > > 
> > >  	/*
> > >  	
> > >  	 * Get DMI information
> > > 
> > > @@ -883,18 +915,66 @@ static int __init i8k_probe(void)
> > > 
> > >  			return -ENODEV;
> > >  	
> > >  	}
> > > 
> > > -	i8k_fan_mult = fan_mult;
> > > -	i8k_fan_max = fan_max ? : I8K_FAN_HIGH;	/* Must not be 0
> > > */ +	/*
> > > +	 * Autodetect fan multiplier and maximal fan speed from
> > > dmi config +	 * Values specified in module parameters
> > > override values from dmi +	 */
> > > 
> > >  	id = dmi_first_match(i8k_dmi_table);
> > >  	if (id && id->driver_data) {
> > > 
> > > -		const struct i8k_config_data *conf = id->driver_data;
> > > +		conf = id->driver_data;
> > > +		if (fan_mult <= 0 && conf->fan_mult > 0)
> > > +			fan_mult = conf->fan_mult;
> > > +		if (fan_max <= 0 && conf->fan_max > 0)
> > > +			fan_max = conf->fan_max;
> > > +	}
> > > 
> > > -		if (fan_mult == I8K_FAN_MULT && conf->fan_mult)
> > > -			i8k_fan_mult = conf->fan_mult;
> > > -		if (fan_max == I8K_FAN_HIGH && conf->fan_max)
> > > -			i8k_fan_max = conf->fan_max;
> > > +	if (fan_mult <= 0) {
> > > +		/*
> > > +		 * Autodetect fan multiplier for each fan based on
> > > nominal rpm +		 * First set default fan multiplier for each
> > > fan +		 * And if it reports rpm value too high then set
> > > multiplier to 1 +		 */
> > > +		for (fan = 0; fan < I8K_FAN_COUNT; ++fan) {
> > > +			i8k_fan_mult[fan] = I8K_FAN_DEFAULT_MULT;
> > > +			for (val = 0; val < 256; ++val) {
> > > +				ret = i8k_get_fan_nominal_rpm(fan, val);
> > > +				if (ret > I8K_FAN_MAX_RPM) {
> > > +					i8k_fan_mult[fan] = 1;
> > > +					break;
> > > +				} else if (ret < 0) {
> > > +					break;
> > > +				}
> > > +			}
> > > +		}
> > > +	} else {
> > > +		/* Fan multiplier was specified in module param or in 
> dmi
> > > */ +		for (fan = 0; fan < I8K_FAN_COUNT; ++fan)
> > > +			i8k_fan_mult[fan] = fan_mult;
> > > 
> > >  	}
> > > 
> > > -	i8k_pwm_mult = DIV_ROUND_UP(255, i8k_fan_max);
> > > +
> > > +	if (fan_max <= 0) {
> > > +		/*
> > > +		 * Autodetect maximal fan speed value for each fan
> > > +		 * Speed value is valid if i8k_get_fan_nominal_rpm() 
> not
> > > fail +		 */
> > > +		for (fan = 0; fan < I8K_FAN_COUNT; ++fan) {
> > > +			for (val = 0; val < 256; ++val) {
> > > +				if (i8k_get_fan_nominal_rpm(fan, val) < 0)
> > > +					break;
> > > +			}
> > > +			--val; /* set last value which not failed */
> > > +			if (val <= 0) /* Must not be 0 (and non negative) 
> */
> > > +				val = I8K_FAN_HIGH;
> > > +			i8k_fan_max[fan] = val;
> > > +		}
> > > +	} else {
> > > +		/* Maximal fan speed was specified in module param or 
> in
> > > dmi */ +		for (fan = 0; fan < I8K_FAN_COUNT; ++fan)
> > > +			i8k_fan_max[fan] = fan_max;
> > > +	}
> > > +
> > > +	for (fan = 0; fan < I8K_FAN_COUNT; ++fan)
> > > +		i8k_pwm_mult[fan] = DIV_ROUND_UP(255, 
> i8k_fan_max[fan]);
> > > 
> > >  	return 0;
> > >  
> > >  }
> > > 
> > > diff --git a/include/uapi/linux/i8k.h
> > > b/include/uapi/linux/i8k.h index 133d02f..60ef0ea 100644
> > > --- a/include/uapi/linux/i8k.h
> > > +++ b/include/uapi/linux/i8k.h
> > > @@ -29,8 +29,10 @@
> > > 
> > >  #define I8K_GET_FAN		_IOWR('i', 0x86, size_t)
> > >  #define I8K_SET_FAN		_IOWR('i', 0x87, size_t)
> > > 
> > > -#define I8K_FAN_LEFT		1
> > > 
> > >  #define I8K_FAN_RIGHT		0
> > > 
> > > +#define I8K_FAN_LEFT		1
> > > +#define I8K_FAN_COUNT		(I8K_FAN_LEFT + 1)
> > > +
> > > 
> > >  #define I8K_FAN_OFF		0
> > >  #define I8K_FAN_LOW		1
> > >  #define I8K_FAN_HIGH		2
> 
> -- 
> Pali Rohár
> pali.rohar@gmail.com


