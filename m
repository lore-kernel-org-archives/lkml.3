Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763408Ab3IEHiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:38:46 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:59878 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763341Ab3IEHip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:38:45 -0400
Date: Thu, 5 Sep 2013 08:38:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Denis CIOCCA <denis.ciocca@st.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 05/11] iio: pressure-core: st: Describe LPS331AP defines
 by name
Message-ID: <20130905073837.GE8980@lee--X1>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-6-git-send-email-lee.jones@linaro.org>
 <522793A9.8040300@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <522793A9.8040300@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > They're currently named *_1_*, for 'Sensor 1', but the code will be much
> > more readable if we use the naming convention *_LPS331AP_* instead.
> You are right, but the reason is to maintain the same structure of the 
> other sensors drivers (like accel, gyro and magn). Often some sensors 
> can use the same data and using 1,2,... I think it's more general.

I've just coded this up for the pressure sensor [1] and in my opinion it
looks pretty ugly. We save 5 lines in this usecase, but we're
separating out some of the register addresses from the masks
etc.

Besides some code space #defines don't actually cost anything, so
unless the register set is almost identical I'd suggest putting them
in a header file out the way and separating them out like in the
original patch. I personally think it makes things so much clearer for
the reader.

I haven't looked at the other sensors yet, so perhaps we need to
evaluate this on a case by case basis, but certainly for this driver,
as we only support two sensors currently and for the sake of 5 lines I
think it's better to have them clearly defined per-sensor.

What do you think?

[1]:

/* GROUP VALUES SENSOR */
#define ST_PRESS_1_ODR_ADDR			0x20
#define ST_PRESS_1_ODR_AVL_1HZ_VAL		0x01
#define ST_PRESS_1_PW_ADDR			0x20
#define ST_PRESS_1_BDU_ADDR			0x20
#define ST_PRESS_1_MULTIREAD_BIT		true

/* CUSTOM VALUES FOR LPS331AP SENSOR */
#define ST_PRESS_LPS331AP_WAI_EXP		0xbb
#define ST_PRESS_LPS331AP_ODR_MASK		0x70
#define ST_PRESS_LPS331AP_ODR_AVL_7HZ_VAL	0x05
#define ST_PRESS_LPS331AP_ODR_AVL_13HZ_VAL	0x06
#define ST_PRESS_LPS331AP_ODR_AVL_25HZ_VAL	0x07
#define ST_PRESS_LPS331AP_PW_MASK		0x80
#define ST_PRESS_LPS331AP_FS_ADDR		0x23
#define ST_PRESS_LPS331AP_FS_MASK		0x30
#define ST_PRESS_LPS331AP_FS_AVL_1260_VAL	0x00
#define ST_PRESS_LPS331AP_FS_AVL_1260_GAIN	ST_PRESS_MBAR_TO_KPASCAL(244141)
#define ST_PRESS_LPS331AP_FS_AVL_TEMP_GAIN	2083000
#define ST_PRESS_LPS331AP_BDU_MASK		0x04
#define ST_PRESS_LPS331AP_DRDY_IRQ_ADDR		0x22
#define ST_PRESS_LPS331AP_DRDY_IRQ_MASK		0x04
#define ST_PRESS_LPS331AP_TEMP_OFFSET		42500
#define ST_PRESS_LPS331AP_OUT_XL_ADDR		0x28
#define ST_TEMP_LPS331AP_OUT_L_ADDR		0x2b

/* CUSTOM VALUES FOR LPS001WP SENSOR */
#define ST_PRESS_LPS001WP_WAI_EXP		0xba
#define ST_PRESS_LPS001WP_ODR_MASK		0x30
#define ST_PRESS_LPS001WP_ODR_AVL_7HZ_VAL	0x02
#define ST_PRESS_LPS001WP_ODR_AVL_13HZ_VAL	0x03
#define ST_PRESS_LPS001WP_PW_MASK		0x40
#define ST_PRESS_LPS001WP_BDU_MASK		0x04
#define ST_PRESS_LPS001WP_OUT_L_ADDR		0x28
#define ST_TEMP_LPS001WP_OUT_L_ADDR		0x2a

static const struct iio_chan_spec st_press_lsp331ap_channels[] = {
	{
		.type = IIO_PRESSURE,
		.channel2 = IIO_NO_MOD,
		.address = ST_PRESS_LPS331AP_OUT_XL_ADDR,
		.scan_index = ST_SENSORS_SCAN_X,
		.scan_type = {
			.sign = 'u',
			.realbits = 24,
			.storagebits = 24,
			.endianness = IIO_LE,
		},
		.info_mask_separate =
			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE),
		.modified = 0,
	},
	{
		.type = IIO_TEMP,
		.channel2 = IIO_NO_MOD,
		.address = ST_TEMP_LPS331AP_OUT_L_ADDR,
		.scan_index = -1,
		.scan_type = {
			.sign = 'u',
			.realbits = 16,
			.storagebits = 16,
			.endianness = IIO_LE,
		},
		.info_mask_separate =
			BIT(IIO_CHAN_INFO_RAW) |
			BIT(IIO_CHAN_INFO_SCALE) |
			BIT(IIO_CHAN_INFO_OFFSET),
		.modified = 0,
	},
	IIO_CHAN_SOFT_TIMESTAMP(1)
};

static const struct iio_chan_spec st_press_lps001wp_channels[] = {
	{
		.type = IIO_PRESSURE,
		.channel2 = IIO_NO_MOD,
		.address = ST_PRESS_LPS001WP_OUT_L_ADDR,
		.scan_index = ST_SENSORS_SCAN_X,
		.scan_type = {
			.sign = 'u',
			.realbits = 16,
			.storagebits = 16,
			.endianness = IIO_LE,
		},
		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
		.modified = 0,
	},
	{
		.type = IIO_TEMP,
		.channel2 = IIO_NO_MOD,
		.address = ST_TEMP_LPS001WP_OUT_L_ADDR,
		.scan_index = -1,
		.scan_type = {
			.sign = 'u',
			.realbits = 16,
			.storagebits = 16,
			.endianness = IIO_LE,
		},
		.info_mask_separate =
			BIT(IIO_CHAN_INFO_RAW) |
			BIT(IIO_CHAN_INFO_OFFSET),
		.modified = 0,
	},
	IIO_CHAN_SOFT_TIMESTAMP(1)
};

static const struct st_sensors st_press_sensors[] = {
	{
		.wai = ST_PRESS_LPS331AP_WAI_EXP,
		.sensors_supported = {
			[0] = LPS331AP_PRESS_DEV_NAME,
		},
		.ch = (struct iio_chan_spec *)st_press_lsp331ap_channels,
		.num_ch = ARRAY_SIZE(st_press_lsp331ap_channels),
		.odr = {
			.addr = ST_PRESS_1_ODR_ADDR,
			.mask = ST_PRESS_LPS331AP_ODR_MASK,
			.odr_avl = {
				{ 1, ST_PRESS_1_ODR_AVL_1HZ_VAL, },
				{ 7, ST_PRESS_LPS331AP_ODR_AVL_7HZ_VAL, },
				{ 13, ST_PRESS_LPS331AP_ODR_AVL_13HZ_VAL, },
				{ 25, ST_PRESS_LPS331AP_ODR_AVL_25HZ_VAL, },
			},
		},
		.pw = {
			.addr = ST_PRESS_1_PW_ADDR,
			.mask = ST_PRESS_LPS331AP_PW_MASK,
			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
		},
		.fs = {
			.addr = ST_PRESS_LPS331AP_FS_ADDR,
			.mask = ST_PRESS_LPS331AP_FS_MASK,
			.fs_avl = {
				[0] = {
					.num = ST_PRESS_FS_AVL_1260MB,
					.value = ST_PRESS_LPS331AP_FS_AVL_1260_VAL,
					.gain = ST_PRESS_LPS331AP_FS_AVL_1260_GAIN,
					.gain2 = ST_PRESS_LPS331AP_FS_AVL_TEMP_GAIN,
				},
			},
		},
		.bdu = {
			.addr = ST_PRESS_1_BDU_ADDR,
			.mask = ST_PRESS_LPS331AP_BDU_MASK,
		},
		.drdy_irq = {
			.addr = ST_PRESS_LPS331AP_DRDY_IRQ_ADDR,
			.mask = ST_PRESS_LPS331AP_DRDY_IRQ_MASK,
		},
		.multi_read_bit = ST_PRESS_1_MULTIREAD_BIT,
		.bootime = 2,
	},
	{
		.wai = ST_PRESS_LPS001WP_WAI_EXP,
		.sensors_supported = {
			[0] = LPS001WP_PRESS_DEV_NAME,
		},
		.ch = (struct iio_chan_spec *)st_press_lps001wp_channels,
		.num_ch = ARRAY_SIZE(st_press_lps001wp_channels),
		.odr = {
			.addr = ST_PRESS_1_ODR_ADDR,
			.mask = ST_PRESS_LPS001WP_ODR_MASK,
			.odr_avl = {
				{ 1, ST_PRESS_1_ODR_AVL_1HZ_VAL, },
				{ 7, ST_PRESS_LPS001WP_ODR_AVL_7HZ_VAL, },
				{ 13, ST_PRESS_LPS001WP_ODR_AVL_13HZ_VAL, },
			},
		},
		.pw = {
			.addr = ST_PRESS_1_PW_ADDR,
			.mask = ST_PRESS_LPS001WP_PW_MASK,
			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
		},
		.fs = {
			.addr = 0,
		},
		.bdu = {
			.addr = ST_PRESS_1_BDU_ADDR,
			.mask = ST_PRESS_LPS001WP_BDU_MASK,
		},
		.drdy_irq = {
			.addr = 0,
		},
		.multi_read_bit = ST_PRESS_1_MULTIREAD_BIT,
		.bootime = 2,
	},
};


> > -/* CUSTOM VALUES FOR SENSOR 1 */
> > -#define ST_PRESS_1_WAI_EXP			0xbb
> > -#define ST_PRESS_1_ODR_ADDR			0x20
> > -#define ST_PRESS_1_ODR_MASK			0x70
> > -#define ST_PRESS_1_ODR_AVL_1HZ_VAL		0x01
> > -#define ST_PRESS_1_ODR_AVL_7HZ_VAL		0x05
> > -#define ST_PRESS_1_ODR_AVL_13HZ_VAL		0x06
> > -#define ST_PRESS_1_ODR_AVL_25HZ_VAL		0x07
> > -#define ST_PRESS_1_PW_ADDR			0x20
> > -#define ST_PRESS_1_PW_MASK			0x80
> > -#define ST_PRESS_1_FS_ADDR			0x23
> > -#define ST_PRESS_1_FS_MASK			0x30
> > -#define ST_PRESS_1_FS_AVL_1260_VAL		0x00
> > -#define ST_PRESS_1_FS_AVL_1260_GAIN		ST_PRESS_MBAR_TO_KPASCAL(244141)
> > -#define ST_PRESS_1_FS_AVL_TEMP_GAIN		2083000
> > -#define ST_PRESS_1_BDU_ADDR			0x20
> > -#define ST_PRESS_1_BDU_MASK			0x04
> > -#define ST_PRESS_1_DRDY_IRQ_ADDR		0x22
> > -#define ST_PRESS_1_DRDY_IRQ_MASK		0x04
> > -#define ST_PRESS_1_MULTIREAD_BIT		true
> > -#define ST_PRESS_1_TEMP_OFFSET			42500
> > +/* CUSTOM VALUES FOR LPS331AP SENSOR */
> > +#define ST_PRESS_LPS331AP_WAI_EXP		0xbb
> > +#define ST_PRESS_LPS331AP_ODR_ADDR		0x20
> > +#define ST_PRESS_LPS331AP_ODR_MASK		0x70
> > +#define ST_PRESS_LPS331AP_ODR_AVL_1HZ_VAL	0x01
> > +#define ST_PRESS_LPS331AP_ODR_AVL_7HZ_VAL	0x05
> > +#define ST_PRESS_LPS331AP_ODR_AVL_13HZ_VAL	0x06
> > +#define ST_PRESS_LPS331AP_ODR_AVL_25HZ_VAL	0x07
> > +#define ST_PRESS_LPS331AP_PW_ADDR		0x20
> > +#define ST_PRESS_LPS331AP_PW_MASK		0x80
> > +#define ST_PRESS_LPS331AP_FS_ADDR		0x23
> > +#define ST_PRESS_LPS331AP_FS_MASK		0x30
> > +#define ST_PRESS_LPS331AP_FS_AVL_1260_VAL	0x00
> > +#define ST_PRESS_LPS331AP_FS_AVL_1260_GAIN	ST_PRESS_MBAR_TO_KPASCAL(244141)
> > +#define ST_PRESS_LPS331AP_FS_AVL_TEMP_GAIN	2083000
> > +#define ST_PRESS_LPS331AP_BDU_ADDR		0x20
> > +#define ST_PRESS_LPS331AP_BDU_MASK		0x04
> > +#define ST_PRESS_LPS331AP_DRDY_IRQ_ADDR		0x22
> > +#define ST_PRESS_LPS331AP_DRDY_IRQ_MASK		0x04
> > +#define ST_PRESS_LPS331AP_MULTIREAD_BIT		true
> > +#define ST_PRESS_LPS331AP_TEMP_OFFSET		42500
> > +#define ST_PRESS_LPS331AP_OUT_XL_ADDR		0x28
> > +#define ST_TEMP_LPS331AP_OUT_L_ADDR		0x2b
> >   
> >   static const struct iio_chan_spec st_press_channels[] = {
> >   	ST_SENSORS_LSM_CHANNELS(IIO_PRESSURE,
> >   			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE),
> >   			ST_SENSORS_SCAN_X, 0, IIO_NO_MOD, 'u', IIO_LE, 24, 24,
> > -			ST_PRESS_DEFAULT_OUT_XL_ADDR),
> > +			ST_PRESS_LPS331AP_OUT_XL_ADDR),
> >   	ST_SENSORS_LSM_CHANNELS(IIO_TEMP,
> >   			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE) |
> >   						BIT(IIO_CHAN_INFO_OFFSET),
> >   			-1, 0, IIO_NO_MOD, 's', IIO_LE, 16, 16,
> > -			ST_TEMP_DEFAULT_OUT_L_ADDR),
> > +			ST_TEMP_LPS331AP_OUT_L_ADDR),
> >   	IIO_CHAN_SOFT_TIMESTAMP(1)
> >   };
> >   
> >   static const struct st_sensors st_press_sensors[] = {
> >   	{
> > -		.wai = ST_PRESS_1_WAI_EXP,
> > +		.wai = ST_PRESS_LPS331AP_WAI_EXP,
> >   		.sensors_supported = {
> >   			[0] = LPS331AP_PRESS_DEV_NAME,
> >   		},
> >   		.ch = (struct iio_chan_spec *)st_press_channels,
> >   		.odr = {
> > -			.addr = ST_PRESS_1_ODR_ADDR,
> > -			.mask = ST_PRESS_1_ODR_MASK,
> > +			.addr = ST_PRESS_LPS331AP_ODR_ADDR,
> > +			.mask = ST_PRESS_LPS331AP_ODR_MASK,
> >   			.odr_avl = {
> > -				{ 1, ST_PRESS_1_ODR_AVL_1HZ_VAL, },
> > -				{ 7, ST_PRESS_1_ODR_AVL_7HZ_VAL, },
> > -				{ 13, ST_PRESS_1_ODR_AVL_13HZ_VAL, },
> > -				{ 25, ST_PRESS_1_ODR_AVL_25HZ_VAL, },
> > +				{ 1, ST_PRESS_LPS331AP_ODR_AVL_1HZ_VAL, },
> > +				{ 7, ST_PRESS_LPS331AP_ODR_AVL_7HZ_VAL, },
> > +				{ 13, ST_PRESS_LPS331AP_ODR_AVL_13HZ_VAL, },
> > +				{ 25, ST_PRESS_LPS331AP_ODR_AVL_25HZ_VAL, },
> >   			},
> >   		},
> >   		.pw = {
> > -			.addr = ST_PRESS_1_PW_ADDR,
> > -			.mask = ST_PRESS_1_PW_MASK,
> > +			.addr = ST_PRESS_LPS331AP_PW_ADDR,
> > +			.mask = ST_PRESS_LPS331AP_PW_MASK,
> >   			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
> >   			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
> >   		},
> >   		.fs = {
> > -			.addr = ST_PRESS_1_FS_ADDR,
> > -			.mask = ST_PRESS_1_FS_MASK,
> > +			.addr = ST_PRESS_LPS331AP_FS_ADDR,
> > +			.mask = ST_PRESS_LPS331AP_FS_MASK,
> >   			.fs_avl = {
> >   				[0] = {
> >   					.num = ST_PRESS_FS_AVL_1260MB,
> > -					.value = ST_PRESS_1_FS_AVL_1260_VAL,
> > -					.gain = ST_PRESS_1_FS_AVL_1260_GAIN,
> > -					.gain2 = ST_PRESS_1_FS_AVL_TEMP_GAIN,
> > +					.value = ST_PRESS_LPS331AP_FS_AVL_1260_VAL,
> > +					.gain = ST_PRESS_LPS331AP_FS_AVL_1260_GAIN,
> > +					.gain2 = ST_PRESS_LPS331AP_FS_AVL_TEMP_GAIN,
> >   				},
> >   			},
> >   		},
> >   		.bdu = {
> > -			.addr = ST_PRESS_1_BDU_ADDR,
> > -			.mask = ST_PRESS_1_BDU_MASK,
> > +			.addr = ST_PRESS_LPS331AP_BDU_ADDR,
> > +			.mask = ST_PRESS_LPS331AP_BDU_MASK,
> >   		},
> >   		.drdy_irq = {
> > -			.addr = ST_PRESS_1_DRDY_IRQ_ADDR,
> > -			.mask = ST_PRESS_1_DRDY_IRQ_MASK,
> > +			.addr = ST_PRESS_LPS331AP_DRDY_IRQ_ADDR,
> > +			.mask = ST_PRESS_LPS331AP_DRDY_IRQ_MASK,
> >   		},
> > -		.multi_read_bit = ST_PRESS_1_MULTIREAD_BIT,
> > +		.multi_read_bit = ST_PRESS_LPS331AP_MULTIREAD_BIT,
> >   		.bootime = 2,
> >   	},
> >   };

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
