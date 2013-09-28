Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3I1LiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 07:38:19 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42376 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3I1LiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 07:38:14 -0400
Message-ID: <5246CDCC.1090504@kernel.org>
Date: Sat, 28 Sep 2013 13:38:36 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: jianlong <jianlong.gao@cn.bosch.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        ji.chen@cn.bosch.com, yunfei.ma2@cn.bosch.com
Subject: Re: [PATCH] iio: add Bosch BMG160 gyroscope sensor driver
References: <1379914517-2491-1-git-send-email-jianlong.gao@cn.bosch.com>
In-Reply-To: <1379914517-2491-1-git-send-email-jianlong.gao@cn.bosch.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/13 06:35, jianlong wrote:
> This patch adds IIO driver for Bosch BMG160 triaxial gyroscope sensor.
> Thanks a lot.
>
> Signed-off-by: Devin <jianlong.gao@cn.bosch.com>
Hi Devin

Welcome to the IIO list.

Firstly this is a very fully featured driver which is good.

Unfortunately I am guessing it was written in your internal code style and
as Joe as pointed out includes quite a bit of stuff that probably wants to
be ripped out as irrelevant to a mainline kernel driver.

Hence I'm going to take a quick look through this and point out a few examples
of stuff that wants cleaning up rather than do a full review.  Please take
those principles and apply them throughout.

The key thing with getting a Kernel driver accepted is making life as easy
as possible both for reviewers and then to maintain the driver going forward.
I nearly didn't do this review at all based on the fact that post Joe's
cleanups it would have been easier.

Note that whilst there is a lot to do here. It is mostly mechanical stripping
of stuff out so should not be hard and not require too much testing etc.
Hence, may look painful but should not be too time consuming.

Good luck and looking forward to a revised easy to review driver ;)
The device looks reasonably sane which always helps.

Jonathan

p.s. I tend to review backwards as code is often easier to follow that way around
so you might want to start at the end to have this make much sense!
> ---
>  drivers/iio/gyro/Kconfig          |   14 +
>  drivers/iio/gyro/Makefile         |    4 +
>  drivers/iio/gyro/bmg160_api.c     | 1047 ++++++++++++++++++++++++++++
>  drivers/iio/gyro/bmg160_core.c    |  868 +++++++++++++++++++++++
>  drivers/iio/gyro/bmg160_ring.c    |   69 ++
>  drivers/iio/gyro/bmg160_trigger.c |  122 ++++
>  drivers/iio/gyro/bmg_iio.h        | 1371 +++++++++++++++++++++++++++++++++++++
>  7 files changed, 3495 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/iio/gyro/bmg160_api.c
>  create mode 100644 drivers/iio/gyro/bmg160_core.c
>  create mode 100644 drivers/iio/gyro/bmg160_ring.c
>  create mode 100644 drivers/iio/gyro/bmg160_trigger.c
>  create mode 100644 drivers/iio/gyro/bmg_iio.h
>
> diff --git a/drivers/iio/gyro/Kconfig b/drivers/iio/gyro/Kconfig
> index 41c64a4..3e5f898 100644
> --- a/drivers/iio/gyro/Kconfig
> +++ b/drivers/iio/gyro/Kconfig
> @@ -98,4 +98,18 @@ config ITG3200
>  	  Say yes here to add support for the InvenSense ITG3200 digital
>  	  3-axis gyroscope sensor.
>
> +config SENSORS_BMG160_IIO
> +	tristate "BMG160 Gyroscope IIO Driver"
> +	depends on I2C
> +	help
> +	  If you say yes here you get support for Bosch Sensortec's
> +	  gyroscope sensor drivers of BMG160/BMI055.
> +
> +config SENSORS_BMG160_IIO_RING
> +	tristate "BMG160 IIO Ring Buffer Support"
> +	depends on SENSORS_BMG160_IIO
> +	select IIO_TRIGGERED_BUFFER if IIO_BUFFER
> +	help
> +	 BMG160 Gyroscope Driver support ring buffer operations.
> +
>  endmenu
> diff --git a/drivers/iio/gyro/Makefile b/drivers/iio/gyro/Makefile
> index 2f2752a..4a65724 100644
> --- a/drivers/iio/gyro/Makefile
> +++ b/drivers/iio/gyro/Makefile
> @@ -21,3 +21,7 @@ st_gyro-$(CONFIG_IIO_BUFFER) += st_gyro_buffer.o
>
>  obj-$(CONFIG_IIO_ST_GYRO_I2C_3AXIS) += st_gyro_i2c.o
>  obj-$(CONFIG_IIO_ST_GYRO_SPI_3AXIS) += st_gyro_spi.o
> +
> +obj-$(CONFIG_SENSORS_BMG160_IIO)    += bmg160_core.o bmg160_api.o
> +obj-$(CONFIG_SENSORS_BMG160_IIO_RING)	+=  bmg160_trigger.o bmg160_ring.o
> +EXTRA_CFLAGS += -D__linux__ -DBMG160_ENABLE_INT1
> diff --git a/drivers/iio/gyro/bmg160_api.c b/drivers/iio/gyro/bmg160_api.c
> new file mode 100644
> index 0000000..4f3481c
> --- /dev/null
> +++ b/drivers/iio/gyro/bmg160_api.c
> @@ -0,0 +1,1047 @@
> +/*
> + * (C) Copyright 2013 Bosch Sensortec GmbH All Rights Reserved
> + *
> + * This software program is licensed subject to the GNU General Public License
> + * (GPL).Version 2,June 1991, available at http://www.fsf.org/copyleft/gpl.html
> + *
> + * BMG160 API functions
> + */
> +
> +#include "bmg_iio.h"
> +struct bmg160_t *p_bmg160;
> +
> +
> +/*****************************************************************************
> + * Description: *//**\brief API Initialization routine
> +  *  \param bmg160_t *bmg160
> + *      Pointer to a structure.
> + *
> + *       structure members are
> + *
> + *       unsigned char chip_id;
> + *       unsigned char dev_addr;
> + *       BMG160_BRD_FUNC_PTR;
> + *       BMG160_WR_FUNC_PTR;
> + *       BMG160_RD_FUNC_PTR;
> + *       void(*delay_msec)( BMG160_MDELAY_DATA_TYPE );
> +  *
> + *  \return result of communication routines
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_init(struct bmg160_t *bmg160)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres = 0;
> +	unsigned char a_data_u8r;
> +	p_bmg160 = bmg160;
> +
That address should come from the probing code of the module, not from in here.
> +	p_bmg160->dev_addr = BMG160_I2C_ADDR;
> +
> +	/*Read CHIP_ID */
> +	comres = p_bmg160->BMG160_BUS_READ_FUNC(p_bmg160->dev_addr,
> +	 BMG160_CHIP_ID_ADDR, &a_data_u8r, 1);
> +	p_bmg160->chip_id = a_data_u8r;
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief Reads Rate dataX from location 02h and 03h
> + * registers
> + *  \param
> + *      BMG160_S16  *data_x   :  Address of data_x
> + *  \return
> + *      result of communication routines
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_dataxyz(struct bmg160_data_t *data)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char a_data_u8r[6];
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		comres = p_bmg160->BMG160_BUS_READ_FUNC(p_bmg160->dev_addr,
> +		 BMG160_RATE_X_LSB_VALUEX__REG, a_data_u8r, 6);
> +		/* Data X */
> +		a_data_u8r[0] =
> +		BMG160_GET_BITSLICE(a_data_u8r[0], BMG160_RATE_X_LSB_VALUEX);
> +		data->datax = (BMG160_S16)
> +		((((BMG160_S16)((signed char)a_data_u8r[1]))
> +		<< BMG160_SHIFT_8_POSITION) | (a_data_u8r[0]));
> +		/* Data Y */
> +		a_data_u8r[2] = BMG160_GET_BITSLICE(a_data_u8r[2],
> +		BMG160_RATE_Y_LSB_VALUEY);
> +		data->datay = (BMG160_S16)
> +		((((BMG160_S16)((signed char)a_data_u8r[3]))
> +		<< BMG160_SHIFT_8_POSITION) | (a_data_u8r[2]));
> +		/* Data Z */
> +		a_data_u8r[4] = BMG160_GET_BITSLICE(a_data_u8r[4],
> +		BMG160_RATE_Z_LSB_VALUEZ);
> +		data->dataz = (BMG160_S16)
> +		((((BMG160_S16)((signed char)a_data_u8r[5]))
> +		<< BMG160_SHIFT_8_POSITION) | (a_data_u8r[4]));
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief Reads data X,Y,Z and Interrupts
> + *							from location 02h to 07h
> + *  \param
> + *      bmg160_data_t *data   :  Address of bmg160_data_t
> + *  \return
> + *      result of communication routines
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_range_reg(unsigned char *range)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data_u8r;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		comres = p_bmg160->BMG160_BUS_READ_FUNC
> +		(p_bmg160->dev_addr,
> +		BMG160_RANGE_ADDR_RANGE__REG, &v_data_u8r, 1);
> +		*range =
> +		BMG160_GET_BITSLICE(v_data_u8r, BMG160_RANGE_ADDR_RANGE);
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API sets the range register 0x0Fh
> + * (0 to 2 bits)
> + *
> + *  \param unsigned char range
> + *
> + *      Range[0....7]
> + *      0 2000/s
> + *      1 1000/s
> + *      2 500/s
> + *      3 250/s
> + *      4 125/s
> + *  \return Communication results
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_range_reg(unsigned char range)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data_u8r;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		if (range < C_BMG160_Five_U8X) {
> +			comres = p_bmg160->BMG160_BUS_READ_FUNC
> +			(p_bmg160->dev_addr,
> +			BMG160_RANGE_ADDR_RANGE__REG, &v_data_u8r, 1);
> +			v_data_u8r = BMG160_SET_BITSLICE(v_data_u8r,
> +			BMG160_RANGE_ADDR_RANGE,
> +			range);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +			(p_bmg160->dev_addr,
> +			BMG160_RANGE_ADDR_RANGE__REG, &v_data_u8r, 1);
> +		} else {
> +			comres = E_BMG160_OUT_OF_RANGE;
> +		}
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API reads the high resolution bit of 0x10h
> + * Register 7th bit
> + *
> + *  \param unsigned char *high_res
> + *                      Pointer to a variable passed as a parameter
> + *  \return communication results
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_bw(unsigned char *bandwidth)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data_u8r;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +		(p_bmg160->dev_addr, BMG160_BW_ADDR__REG, &v_data_u8r, 1);
> +		*bandwidth = BMG160_GET_BITSLICE(v_data_u8r,
> +			BMG160_BW_ADDR);
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API writes the Bandwidth register (0x10h of 0
> + * to 3 bits)
> + *
> + *  \param unsigned char bandwidth,
> + *              The bandwidth to be set passed as a parameter
> + *
> + *              0 no filter(523 Hz)
> + *              1 230Hz
> + *              2 116Hz
> + *              3 47Hz
> + *              4 23Hz
> + *              5 12Hz
> + *              6 64Hz
> + *              7 32Hz
> + *
> + *  \return communication results
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_bw(unsigned char bandwidth)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data_u8r;
> +	unsigned char v_mode_u8r;
> +	unsigned char v_autosleepduration;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		if (bandwidth < C_BMG160_Eight_U8X) {
> +			bmg160_get_mode(&v_mode_u8r);
> +			if (v_mode_u8r == BMG160_MODE_ADVANCEDPOWERSAVING) {
> +				bmg160_get_autosleepdur(&v_autosleepduration);
> +				bmg160_set_autosleepdur(v_autosleepduration,
> +				bandwidth);
> +			}
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +			(p_bmg160->dev_addr,
> +			BMG160_BW_ADDR__REG, &v_data_u8r, 1);
> +			v_data_u8r = BMG160_SET_BITSLICE(v_data_u8r,
> +				BMG160_BW_ADDR, bandwidth);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_BW_ADDR__REG, &v_data_u8r, 1);
> +		} else {
> +			comres = E_BMG160_OUT_OF_RANGE;
> +		}
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API is used to get the output type status
> + *
> + *
> + *  \param unsigned char channel,unsigned char *int_od
> + *                  BMG160_INT1    ->   0
> + *                  BMG160_INT2    ->   1
> + *                  int_od : open drain   ->   1
> + *                           push pull    ->   0
> + *
> + *
> + *  \return
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_int_od(unsigned char param,
> +unsigned char *int_od)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data_u8r;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		switch (param) {
> +		case BMG160_INT1:
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			 BMG160_INT_ENABLE1_IT1_OD__REG, &v_data_u8r, 1);
> +			*int_od = BMG160_GET_BITSLICE(v_data_u8r,
> +			BMG160_INT_ENABLE1_IT1_OD);
> +			break;
> +		case BMG160_INT2:
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			 BMG160_INT_ENABLE1_IT2_OD__REG, &v_data_u8r, 1);
> +			*int_od = BMG160_GET_BITSLICE(v_data_u8r,
> +			BMG160_INT_ENABLE1_IT2_OD);
> +			break;
> +		default:
> +			comres = E_BMG160_OUT_OF_RANGE;
> +			break;
> +		}
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API is used to set the output type status
> + *
> + *  \param unsigned char channel,unsigned char *int_od
> + *                  BMG160_INT1    ->   0
> + *                  BMG160_INT2    ->   1
> + *                  int_od : open drain   ->   1
> + *                           push pull    ->   0
> + *
> + *  \return communication results
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_int_od(unsigned char param,
> +unsigned char int_od)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data_u8r;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		switch (param) {
> +		case BMG160_INT1:
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_INT_ENABLE1_IT1_OD__REG, &v_data_u8r, 1);
> +			v_data_u8r = BMG160_SET_BITSLICE(v_data_u8r,
> +			BMG160_INT_ENABLE1_IT1_OD, int_od);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_INT_ENABLE1_IT1_OD__REG, &v_data_u8r, 1);
> +			break;
> +		case BMG160_INT2:
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_INT_ENABLE1_IT2_OD__REG, &v_data_u8r, 1);
> +			v_data_u8r = BMG160_SET_BITSLICE(v_data_u8r,
> +			BMG160_INT_ENABLE1_IT2_OD, int_od);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_INT_ENABLE1_IT2_OD__REG, &v_data_u8r, 1);
> +			break;
> +		default:
> +			comres = E_BMG160_OUT_OF_RANGE;
> +			break;
> +		}
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API is used to get data Interrupt1 and data
> + * Interrupt2
> + *
> + *  \param unsigned char axis,unsigned char *int_data
> + *                       axis :
> + *                       BMG160_INT1_DATA -> 0
> + *                       BMG160_INT2_DATA -> 1
> + *                       int_data :
> + *                       Disable     -> 0
> + *                       Enable      -> 1
> + *
> + *
> + *  \return
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_int_data(unsigned char axis,
> +unsigned char *int_data)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data_u8r;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		switch (axis) {
> +		case BMG160_INT1_DATA:
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			 BMG160_MAP_1_INT1_DATA__REG, &v_data_u8r, 1);
> +			*int_data = BMG160_GET_BITSLICE(v_data_u8r,
> +				BMG160_MAP_1_INT1_DATA);
> +			break;
> +		case BMG160_INT2_DATA:
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			 BMG160_MAP_1_INT2_DATA__REG, &v_data_u8r, 1);
> +			*int_data = BMG160_GET_BITSLICE(v_data_u8r,
> +				BMG160_MAP_1_INT2_DATA);
> +			break;
> +		default:
> +			comres = E_BMG160_OUT_OF_RANGE;
> +			break;
> +		}
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API is used to set data Interrupt1 and data
> + * Interrupt2
> + *
> + *  \param unsigned char axis,unsigned char *int_data
> + *                       axis :
> + *                       BMG160_INT1_DATA -> 0
> + *                       BMG160_INT2_DATA -> 1
> + *                       int_data :
> + *                       Disable     -> 0
> + *                       Enable      -> 1
> + *
> + *
> + *
> + *  \return communication results
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_int_data(unsigned char axis,
> +unsigned char int_data)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data_u8r;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		switch (axis) {
> +		case BMG160_INT1_DATA:
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MAP_1_INT1_DATA__REG, &v_data_u8r, 1);
> +			v_data_u8r = BMG160_SET_BITSLICE(v_data_u8r,
> +			BMG160_MAP_1_INT1_DATA, int_data);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MAP_1_INT1_DATA__REG, &v_data_u8r, 1);
> +			break;
> +		case BMG160_INT2_DATA:
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MAP_1_INT2_DATA__REG, &v_data_u8r, 1);
> +			v_data_u8r = BMG160_SET_BITSLICE(v_data_u8r,
> +			BMG160_MAP_1_INT2_DATA, int_data);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MAP_1_INT2_DATA__REG, &v_data_u8r, 1);
> +			break;
> +		default:
> +			comres = E_BMG160_OUT_OF_RANGE;
> +			break;
> +		}
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API is used to set the Interrupt Reset
> + *
> + *
> + *
> + *
> + *  \param unsigned char reset_int
> + *                    1 -> Reset All Interrupts
> + *
> + *
> + *
> + *  \return communication results
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_reset_int(unsigned char reset_int)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data_u8r;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		comres = p_bmg160->BMG160_BUS_READ_FUNC(p_bmg160->dev_addr,
> +		BMG160_RST_LATCH_ADDR_RESET_INT__REG, &v_data_u8r, 1);
> +		v_data_u8r = BMG160_SET_BITSLICE(v_data_u8r,
> +		BMG160_RST_LATCH_ADDR_RESET_INT, reset_int);
> +		comres = p_bmg160->BMG160_BUS_WRITE_FUNC(p_bmg160->dev_addr,
> +		BMG160_RST_LATCH_ADDR_RESET_INT__REG, &v_data_u8r, 1);
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API is used to get the status of offset
> + *
> + *
> + *
> + *
> + *  \param unsigned char axis,unsigned char *offset
> + *                         axis ->
> + *                   BMG160_X_AXIS     ->      0
> + *                   BMG160_Y_AXIS     ->      1
> + *                   BMG160_Z_AXIS     ->      2
> + *                   offset -> Any valid value
> + *
> + *  \return
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_offset(unsigned char axis,
> +BMG160_S16 *offset)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data1_u8r, v_data2_u8r;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		switch (axis) {
> +		case BMG160_X_AXIS:
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_TRIM_GP0_ADDR_OFFSET_X__REG, &v_data1_u8r, 1);
> +			v_data1_u8r = BMG160_GET_BITSLICE(v_data1_u8r,
> +			BMG160_TRIM_GP0_ADDR_OFFSET_X);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_OFC1_ADDR_OFFSET_X__REG, &v_data2_u8r, 1);
> +			v_data2_u8r = BMG160_GET_BITSLICE(v_data2_u8r,
> +			BMG160_OFC1_ADDR_OFFSET_X);
> +			v_data2_u8r = ((v_data2_u8r <<
> +			BMG160_SHIFT_2_POSITION) | v_data1_u8r);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +			(p_bmg160->dev_addr, BMG160_OFC2_ADDR, &v_data1_u8r, 1);
> +			*offset = (BMG160_S16)((((BMG160_S16)
> +				((signed char)v_data1_u8r))
> +			<< BMG160_SHIFT_4_POSITION) | (v_data2_u8r));
> +			break;
> +		case BMG160_Y_AXIS:
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_TRIM_GP0_ADDR_OFFSET_Y__REG, &v_data1_u8r, 1);
> +			v_data1_u8r = BMG160_GET_BITSLICE(v_data1_u8r,
> +			BMG160_TRIM_GP0_ADDR_OFFSET_Y);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_OFC1_ADDR_OFFSET_Y__REG, &v_data2_u8r, 1);
> +			v_data2_u8r = BMG160_GET_BITSLICE(v_data2_u8r,
> +			BMG160_OFC1_ADDR_OFFSET_Y);
> +			v_data2_u8r = ((v_data2_u8r <<
> +			BMG160_SHIFT_1_POSITION) | v_data1_u8r);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_OFC3_ADDR, &v_data1_u8r, 1);
> +			*offset = (BMG160_S16)((((BMG160_S16)
> +				((signed char)v_data1_u8r))
> +			<< BMG160_SHIFT_4_POSITION) | (v_data2_u8r));
> +			break;
> +		case BMG160_Z_AXIS:
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_TRIM_GP0_ADDR_OFFSET_Z__REG, &v_data1_u8r, 1);
> +			v_data1_u8r = BMG160_GET_BITSLICE(v_data1_u8r,
> +			BMG160_TRIM_GP0_ADDR_OFFSET_Z);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_OFC1_ADDR_OFFSET_Z__REG, &v_data2_u8r, 1);
> +			v_data2_u8r = BMG160_GET_BITSLICE(v_data2_u8r,
> +			BMG160_OFC1_ADDR_OFFSET_Z);
> +			v_data2_u8r = ((v_data2_u8r << BMG160_SHIFT_1_POSITION)
> +				| v_data1_u8r);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_OFC4_ADDR, &v_data1_u8r, 1);
> +			*offset = (BMG160_S16)((((BMG160_S16)
> +				((signed char)v_data1_u8r))
> +			<< BMG160_SHIFT_4_POSITION) | (v_data2_u8r));
> +			break;
> +		default:
> +			comres = E_BMG160_OUT_OF_RANGE;
> +			break;
> +		}
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API is used to set the status of offset
> + *
> + *  \param unsigned char axis,unsigned char offset
> + *                         axis ->
> + *                   BMG160_X_AXIS     ->      0
> + *                   BMG160_Y_AXIS     ->      1
> + *                   BMG160_Z_AXIS     ->      2
> + *                   offset -> Any valid value
> + *
> + *
> + *  \return
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_offset(
> +unsigned char axis, BMG160_S16 offset)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data1_u8r, v_data2_u8r;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		switch (axis) {
> +		case BMG160_X_AXIS:
> +			v_data1_u8r = ((signed char) (offset & 0x0FF0))
> +			>> BMG160_SHIFT_4_POSITION;
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_OFC2_ADDR, &v_data1_u8r, 1);
> +
> +			v_data1_u8r = (unsigned char) (offset & 0x000C);
> +			v_data2_u8r = BMG160_SET_BITSLICE(v_data2_u8r,
> +			BMG160_OFC1_ADDR_OFFSET_X, v_data1_u8r);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_OFC1_ADDR_OFFSET_X__REG, &v_data2_u8r, 1);
> +
> +			v_data1_u8r = (unsigned char) (offset & 0x0003);
> +			v_data2_u8r = BMG160_SET_BITSLICE(v_data2_u8r,
> +			BMG160_TRIM_GP0_ADDR_OFFSET_X, v_data1_u8r);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_TRIM_GP0_ADDR_OFFSET_X__REG, &v_data2_u8r, 1);
> +			break;
> +		case BMG160_Y_AXIS:
> +			v_data1_u8r = ((signed char) (offset & 0x0FF0)) >>
> +			BMG160_SHIFT_4_POSITION;
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_OFC3_ADDR, &v_data1_u8r, 1);
> +
> +			v_data1_u8r = (unsigned char) (offset & 0x000E);
> +			v_data2_u8r = BMG160_SET_BITSLICE(v_data2_u8r,
> +			BMG160_OFC1_ADDR_OFFSET_Y, v_data1_u8r);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_OFC1_ADDR_OFFSET_Y__REG, &v_data2_u8r, 1);
> +
> +			v_data1_u8r = (unsigned char) (offset & 0x0001);
> +			v_data2_u8r = BMG160_SET_BITSLICE(v_data2_u8r,
> +			BMG160_TRIM_GP0_ADDR_OFFSET_Y, v_data1_u8r);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_TRIM_GP0_ADDR_OFFSET_Y__REG, &v_data2_u8r, 1);
> +			break;
> +		case BMG160_Z_AXIS:
> +			v_data1_u8r = ((signed char) (offset & 0x0FF0)) >>
> +			BMG160_SHIFT_4_POSITION;
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_OFC4_ADDR, &v_data1_u8r, 1);
> +
> +			v_data1_u8r = (unsigned char) (offset & 0x000E);
> +			v_data2_u8r = BMG160_SET_BITSLICE(v_data2_u8r,
> +			BMG160_OFC1_ADDR_OFFSET_Z, v_data1_u8r);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_OFC1_ADDR_OFFSET_Z__REG, &v_data2_u8r, 1);
> +
> +			v_data1_u8r = (unsigned char) (offset & 0x0001);
> +			v_data2_u8r = BMG160_SET_BITSLICE(v_data2_u8r,
> +			BMG160_TRIM_GP0_ADDR_OFFSET_Z, v_data1_u8r);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_TRIM_GP0_ADDR_OFFSET_Z__REG, &v_data2_u8r, 1);
> +			break;
> +		default:
> +			comres = E_BMG160_OUT_OF_RANGE;
> +			break;
> +		}
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API is used to get the operating modes of the
> + * sensor
> + *
> + *  \param unsigned char * Mode : Address of Mode
> + *                       0 -> NORMAL
> + *                       1 -> SUSPEND
> + *                       2 -> DEEP SUSPEND
> + *						 3 -> FAST POWERUP
> + *						 4 -> ADVANCED POWERSAVING
> + *
> + *
> + *  \return
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_mode(unsigned char *mode)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres = C_BMG160_Zero_U8X;
> +	unsigned char data1 = C_BMG160_Zero_U8X;
> +	unsigned char data2 = C_BMG160_Zero_U8X;
> +	unsigned char data3 = C_BMG160_Zero_U8X;
> +	if (p_bmg160 == C_BMG160_Zero_U8X) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		comres = p_bmg160->BMG160_BUS_READ_FUNC(p_bmg160->dev_addr,
> +		BMG160_MODE_LPM1_ADDR, &data1, C_BMG160_One_U8X);
> +		comres = p_bmg160->BMG160_BUS_READ_FUNC(p_bmg160->dev_addr,
> +		BMG160_MODE_LPM2_ADDR, &data2, C_BMG160_One_U8X);
> +		data1  = (data1 & 0xA0) >> 5;
> +		data3  = (data2 & 0x40) >> 6;
> +		data2  = (data2 & 0x80) >> 7;
> +		if (data3 == 0x01) {
> +			*mode  = BMG160_MODE_ADVANCEDPOWERSAVING;
> +		} else {
> +			if ((data1 == 0x00) && (data2 == 0x00)) {
> +				*mode  = BMG160_MODE_NORMAL;
> +				} else {
> +				if ((data1 == 0x01) || (data1 == 0x05)) {
> +					*mode  = BMG160_MODE_DEEPSUSPEND;
> +					} else {
> +					if ((data1 == 0x04) &&
> +					(data2 == 0x00)) {
> +						*mode  = BMG160_MODE_SUSPEND;
> +					} else {
> +					if ((data1 == 0x04) &&
> +						(data2 == 0x01))
> +							*mode  =
> +							BMG160_MODE_FASTPOWERUP;
> +						}
> +					}
> +				}
> +			}
> +		}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API is used to set data enable data
> + *
> + *
> + *	\param unsigned char data_en:
> + *			Value to be written passed as a parameter
> + *			 0 --> Disable
> + *			 1 --> Enable
> + *
> + *
> + *	\return communication results
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_data_enable(unsigned char data_en)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data_u8r;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		comres = p_bmg160->BMG160_BUS_READ_FUNC
> +			(p_bmg160->dev_addr,
> +		BMG160_INT_ENABLE0_DATAEN__REG, &v_data_u8r, 1);
> +		v_data_u8r = BMG160_SET_BITSLICE(v_data_u8r,
> +		BMG160_INT_ENABLE0_DATAEN, data_en);
> +		comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +			(p_bmg160->dev_addr,
> +		BMG160_INT_ENABLE0_DATAEN__REG, &v_data_u8r, 1);
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API is used to set the operating Modes of the
> + * sensor
> + *
> + *
> + *  \param unsigned char Mode
> + *                       0 -> NORMAL
> + *                       1 -> DEEPSUSPEND
> + *                       2 -> SUSPEND
> + *						 3 -> Fast Powerup
> + *						 4 -> Advance Powerup
> + *  \return communication results
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_mode(unsigned char mode)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres = C_BMG160_Zero_U8X;
> +	unsigned char data1;
> +	unsigned char data2;
> +	unsigned char data3;
> +	unsigned char v_autosleepduration;
> +	unsigned char v_bw_u8r;
> +	if (p_bmg160 == C_BMG160_Zero_U8X) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		if (mode < C_BMG160_Five_U8X) {
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM1_ADDR, &data1, C_BMG160_One_U8X);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM2_ADDR, &data2, C_BMG160_One_U8X);
> +			switch (mode) {
> +			case BMG160_MODE_NORMAL:
> +				data1  = BMG160_SET_BITSLICE(data1,
> +				BMG160_MODE_LPM1, C_BMG160_Zero_U8X);
> +				data2  = BMG160_SET_BITSLICE(data2,
> +				BMG160_MODE_LPM2_ADDR_FAST_POWERUP,
> +				C_BMG160_Zero_U8X);
> +				data3  = BMG160_SET_BITSLICE(data2,
> +				BMG160_MODE_LPM2_ADDR_ADV_POWERSAVING,
> +				C_BMG160_Zero_U8X);
> +				comres += p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM1_ADDR, &data1, C_BMG160_One_U8X);
> +			p_bmg160->delay_msec(1);/*A minimum delay of atleast
> +			450us is required for Multiple write.*/
> +			comres += p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM2_ADDR, &data3, C_BMG160_One_U8X);
> +				break;
> +			case BMG160_MODE_DEEPSUSPEND:
> +				data1  = BMG160_SET_BITSLICE(data1,
> +				BMG160_MODE_LPM1, C_BMG160_One_U8X);
> +				data2  = BMG160_SET_BITSLICE(data2,
> +				BMG160_MODE_LPM2_ADDR_FAST_POWERUP,
> +				C_BMG160_Zero_U8X);
> +				data3  = BMG160_SET_BITSLICE(data2,
> +				BMG160_MODE_LPM2_ADDR_ADV_POWERSAVING,
> +				C_BMG160_Zero_U8X);
> +				comres += p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM1_ADDR, &data1, C_BMG160_One_U8X);
> +			p_bmg160->delay_msec(1);/*A minimum delay of atleast
> +			450us is required for Multiple write.*/
> +			comres += p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM2_ADDR, &data3, C_BMG160_One_U8X);
> +				break;
> +			case BMG160_MODE_SUSPEND:
> +				data1  = BMG160_SET_BITSLICE(data1,
> +				BMG160_MODE_LPM1, C_BMG160_Four_U8X);
> +				data2  = BMG160_SET_BITSLICE(data2,
> +				BMG160_MODE_LPM2_ADDR_FAST_POWERUP,
> +				C_BMG160_Zero_U8X);
> +				data3  = BMG160_SET_BITSLICE(data2,
> +				BMG160_MODE_LPM2_ADDR_ADV_POWERSAVING,
> +				C_BMG160_Zero_U8X);
> +				comres += p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM1_ADDR, &data1, C_BMG160_One_U8X);
> +			p_bmg160->delay_msec(1);/*A minimum delay of atleast
> +			450us is required for Multiple write.*/
> +			comres += p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM2_ADDR, &data3, C_BMG160_One_U8X);
> +				break;
> +			case BMG160_MODE_FASTPOWERUP:
> +				data1  = BMG160_SET_BITSLICE(data1,
> +				BMG160_MODE_LPM1, C_BMG160_Four_U8X);
> +				data2  = BMG160_SET_BITSLICE(data2,
> +				BMG160_MODE_LPM2_ADDR_FAST_POWERUP,
> +				C_BMG160_One_U8X);
> +				data3  = BMG160_SET_BITSLICE(data2,
> +				BMG160_MODE_LPM2_ADDR_ADV_POWERSAVING,
> +				C_BMG160_Zero_U8X);
> +				comres += p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM1_ADDR, &data1, C_BMG160_One_U8X);
> +			p_bmg160->delay_msec(1);/*A minimum delay of atleast
> +			450us is required for Multiple write.*/
> +			comres += p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM2_ADDR, &data3, C_BMG160_One_U8X);
> +				break;
> +			case BMG160_MODE_ADVANCEDPOWERSAVING:
> +				/* Configuring the proper settings for auto
> +				sleep duration */
> +				bmg160_get_bw(&v_bw_u8r);
> +				bmg160_get_autosleepdur(&v_autosleepduration);
> +				bmg160_set_autosleepdur(v_autosleepduration,
> +				v_bw_u8r);
> +				comres += p_bmg160->BMG160_BUS_WRITE_FUNC
> +					(p_bmg160->dev_addr,
> +				BMG160_MODE_LPM2_ADDR, &data2,
> +				C_BMG160_One_U8X);
> +				/* Configuring the advanced power saving mode*/
> +				data1  = BMG160_SET_BITSLICE(data1,
> +				BMG160_MODE_LPM1, C_BMG160_Zero_U8X);
> +				data2  = BMG160_SET_BITSLICE(data2,
> +				BMG160_MODE_LPM2_ADDR_FAST_POWERUP,
> +				C_BMG160_Zero_U8X);
> +				data3  = BMG160_SET_BITSLICE(data2,
> +				BMG160_MODE_LPM2_ADDR_ADV_POWERSAVING,
> +				C_BMG160_One_U8X);
> +				comres += p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM1_ADDR, &data1, C_BMG160_One_U8X);
> +			p_bmg160->delay_msec(1);/*A minimum delay of atleast
> +			450us is required for Multiple write.*/
> +			comres += p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM2_ADDR, &data3, C_BMG160_One_U8X);
> +				break;
> +				}
> +		} else {
> +		comres = E_BMG160_OUT_OF_RANGE;
> +		}
> +	}
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief This API is used to to do selftest to sensor
> + * sensor
> + *
> + *
> + *
> + *
> + *  \param unsigned char *result
> + *
> + *
> + *
> + *
> + *  \return communication results
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_selftest(unsigned char *result)
> +	{
> +	BMG160_RETURN_FUNCTION_TYPE comres = C_BMG160_Zero_U8X;
> +	unsigned char data1 = C_BMG160_Zero_U8X;
> +	unsigned char data2 = C_BMG160_Zero_U8X;
> +
> +	comres = p_bmg160->BMG160_BUS_READ_FUNC(p_bmg160->dev_addr,
> +	BMG160_SELF_TEST_ADDR, &data1, C_BMG160_One_U8X);
> +	data2  = BMG160_GET_BITSLICE(data1, BMG160_SELF_TEST_ADDR_RATEOK);
> +	data1  = BMG160_SET_BITSLICE(data1, BMG160_SELF_TEST_ADDR_TRIGBIST,
> +	C_BMG160_One_U8X);
> +	comres += p_bmg160->BMG160_BUS_WRITE_FUNC(p_bmg160->dev_addr,
> +	BMG160_SELF_TEST_ADDR_TRIGBIST__REG, &data1, C_BMG160_One_U8X);
> +
> +	/* Waiting time to complete the selftest process */
> +	p_bmg160->delay_msec(10);
> +
> +	/* Reading Selftest result bir bist_failure */
> +	comres = p_bmg160->BMG160_BUS_READ_FUNC(p_bmg160->dev_addr,
> +	BMG160_SELF_TEST_ADDR_BISTFAIL__REG, &data1, C_BMG160_One_U8X);
> +	data1  = BMG160_GET_BITSLICE(data1, BMG160_SELF_TEST_ADDR_BISTFAIL);
> +	if ((data1 == 0x00) && (data2 == 0x01))
> +		*result = C_BMG160_SUCCESS;
> +	else
> +		*result = C_BMG160_FAILURE;
> +	return comres;
> +}
> +/*****************************************************************************
> + * Description: *//**\brief  This API is used to get data auto sleep duration
> + *
> + *
> + *
> + *
> + *	\param unsigned char *duration : Address of auto sleep duration
> + *		Pointer to a variable passed as a parameter
> + *
> + *
> + *
> + *	\return
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_autosleepdur(unsigned char *duration)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data_u8r;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		comres = p_bmg160->BMG160_BUS_READ_FUNC(p_bmg160->dev_addr,
> +		 BMG160_MODE_LPM2_ADDR_AUTOSLEEPDUR__REG, &v_data_u8r, 1);
> +		*duration = BMG160_GET_BITSLICE(v_data_u8r,
> +		BMG160_MODE_LPM2_ADDR_AUTOSLEEPDUR);
> +	}
> +	return comres;
> +}

Kernel doc, or none if it is obvious.
I am guessing this is part of a shared library for multiple sensor drivers?
If so then you could have it as a separate module.

> +/*****************************************************************************
> + * Description: *//**\brief This API is used to set duration
> + *
> + *
> + *
> + *
> + *  \param unsigned char duration:
> + *          Value to be written passed as a parameter
> + *
> + *
> + *
> + *  \return communication results
> + *
> + *
> + *****************************************************************************/
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_autosleepdur(unsigned char duration,
> +unsigned char bandwith)
> +{
> +	BMG160_RETURN_FUNCTION_TYPE comres;
> +	unsigned char v_data_u8r;
> +	unsigned char v_autosleepduration_u8r = 0xff;
> +	if (p_bmg160 == BMG160_NULL) {
> +		comres = E_BMG160_NULL_PTR;
> +	} else {
> +		comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +			(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM2_ADDR_AUTOSLEEPDUR__REG,
> +			&v_data_u8r, 1);
> +			if (duration < C_BMG160_Eight_U8X) {
> +				switch (bandwith) {
> +				case C_BMG160_No_Filter_U8X:
> +					if (duration >
> +					C_BMG160_4ms_AutoSleepDur_U8X)
> +						v_autosleepduration_u8r =
> +						duration;
> +					else
> +						v_autosleepduration_u8r =
> +						C_BMG160_4ms_AutoSleepDur_U8X;
> +					break;
> +				case C_BMG160_BW_230Hz_U8X:
> +					if (duration >
> +					C_BMG160_4ms_AutoSleepDur_U8X)
> +						v_autosleepduration_u8r =
> +						duration;
> +					else
> +						v_autosleepduration_u8r =
> +						C_BMG160_4ms_AutoSleepDur_U8X;
> +					break;
> +				case C_BMG160_BW_116Hz_U8X:
> +					if (duration >
> +					C_BMG160_4ms_AutoSleepDur_U8X)
> +						v_autosleepduration_u8r =
> +						duration;
> +					else
> +						v_autosleepduration_u8r =
> +						C_BMG160_4ms_AutoSleepDur_U8X;
> +					break;
> +				case C_BMG160_BW_47Hz_U8X:
> +					if (duration >
> +					C_BMG160_5ms_AutoSleepDur_U8X)
> +						v_autosleepduration_u8r =
> +						duration;
> +					else
> +						v_autosleepduration_u8r =
> +						C_BMG160_5ms_AutoSleepDur_U8X;
> +					break;
> +				case C_BMG160_BW_23Hz_U8X:
> +					if (duration >
> +					C_BMG160_10ms_AutoSleepDur_U8X)
> +						v_autosleepduration_u8r =
> +						duration;
> +					else
> +						v_autosleepduration_u8r =
> +						C_BMG160_10ms_AutoSleepDur_U8X;
> +					break;
> +				case C_BMG160_BW_12Hz_U8X:
> +					if (duration >
> +					C_BMG160_20ms_AutoSleepDur_U8X)
> +						v_autosleepduration_u8r =
> +						duration;
> +					else
> +					v_autosleepduration_u8r =
> +					C_BMG160_20ms_AutoSleepDur_U8X;
> +					break;
> +				case C_BMG160_BW_64Hz_U8X:
> +					if (duration >
> +					C_BMG160_10ms_AutoSleepDur_U8X)
> +						v_autosleepduration_u8r =
> +						duration;
> +					else
> +						v_autosleepduration_u8r =
> +						C_BMG160_10ms_AutoSleepDur_U8X;
> +					break;
> +				case C_BMG160_BW_32Hz_U8X:
> +					if (duration >
> +					C_BMG160_20ms_AutoSleepDur_U8X)
> +						v_autosleepduration_u8r =
> +						duration;
> +					else
> +						v_autosleepduration_u8r =
> +						C_BMG160_20ms_AutoSleepDur_U8X;
> +					break;
> +				}
> +			v_data_u8r = BMG160_SET_BITSLIC(Ev_data_u8r,
> +			BMG160_MODE_LPM2_ADDR_AUTOSLEEPDUR,
> +			v_autosleepduration_u8r);
> +			comres = p_bmg160->BMG160_BUS_WRITE_FUNC
> +				(p_bmg160->dev_addr,
> +			BMG160_MODE_LPM2_ADDR_AUTOSLEEPDUR__REG,
> +			&v_data_u8r, 1);
> +		} else {
> +			comres = E_BMG160_OUT_OF_RANGE;
> +		}
> +	}
> +	return comres;
> +}
> +/*End of bmg160 api*/
> +
> diff --git a/drivers/iio/gyro/bmg160_core.c b/drivers/iio/gyro/bmg160_core.c
> new file mode 100644
> index 0000000..0234348
> --- /dev/null
> +++ b/drivers/iio/gyro/bmg160_core.c
> @@ -0,0 +1,868 @@
> +/*
> + * (C) Copyright 2013 Bosch Sensortec GmbH All Rights Reserved
> + *
> + * This software program is licensed subject to the GNU General Public License
> + * (GPL).Version 2,June 1991, available at http://www.fsf.org/copyleft/gpl.html
> + *
> + *	BMG160 Linux IIO Driver
> + */
> +
> +#include <linux/version.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/delay.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +#include <asm/unaligned.h>
> +#include "bmg_iio.h"
> +
> +/* sensor specific */
> +#define SENSOR_NAME "bmg160"
> +
> +#define SENSOR_CHIP_ID_BMG (0x0f)
> +
> +#define BMG_I2C_WRITE_DELAY_TIME 1
> +
> +/* generic */
> +#define BMG_MAX_RETRY_I2C_XFER (100)
> +#define BMG_MAX_RETRY_WAKEUP (5)
> +#define BMG_MAX_RETRY_WAIT_DRDY (100)
> +
> +#define BMG_DELAY_MIN (1)
> +#define BMG_DELAY_DEFAULT (200)
> +
> +#define BYTES_PER_LINE (16)
> +
> +#define BMG_SELF_TEST 0
> +
Don't do this.  If you are writing to sysfs, then PAGE_SIZE
is the correct value.
> +#define BUFF_SIZE 256
> +
> +struct op_mode_map {
> +	char *op_mode_name;
> +	long op_mode;
> +};
> +
Any control of this needs full documentation.  There are occasionaly
reasons to allow userspace to see this, but they have to be very
well justified.

> +static const struct op_mode_map op_mode_maps[] = {
> +	{"normal", BMG_VAL_NAME(MODE_NORMAL)},
> +	{"deepsuspend", BMG_VAL_NAME(MODE_DEEPSUSPEND)},
> +	{"suspend", BMG_VAL_NAME(MODE_SUSPEND)},
> +	{"fastpowerup", BMG_VAL_NAME(MODE_FASTPOWERUP)},
> +	{"advancedpowersav", BMG_VAL_NAME(MODE_ADVANCEDPOWERSAVING)},
> +};
> +
Do not do this. It is easy to remove this limitation. Just look
at how every other driver does it.

> +static struct i2c_client *bmg_client;
> +
> +/*!
Kernel doc comments only please.
> + * @brief this particular data structure is defined
> + * for BMG full scale or range or sensor resolution.
> + * @gyro_fs_value: the specific value from Register definition.
> + * @gyro_fs_dps: sensor's full scale, the unit is degree pre second.
> + * @gyro_fs_rslt: sensor's resolution.
> + * example: 0(Reg val)----2000dps(full scale)----61000(resolution)
> +*/
> +static struct bmg_fullscale_avl bmg_fs_avl_array[] = {
> +	[0] = {
.gyro_fs_value always corresponds to the location in this array
hence as far as I can see serves no purpose if you use the index
as the variable form which this is accessed rather than
a pointer into this array.
> +		.gyro_fs_value = BMG_FSR_2000DPS_VAL,
> +		.gyro_fs_dps = BMG_FS_AVL_2000DPS,
> +		.gyro_fs_rslt = 61000,
> +	},
> +	[1] = {
> +		.gyro_fs_value = BMG_FSR_1000DPS_VAL,
> +		.gyro_fs_dps = BMG_FS_AVL_1000DPS,
> +		.gyro_fs_rslt = 30500,
> +	},
> +	[2] = {
> +		.gyro_fs_value = BMG_FSR_500DPS_VAL,
> +		.gyro_fs_dps = BMG_FS_AVL_500DPS,
> +		.gyro_fs_rslt = 15300,
> +	},
> +	[3] = {
> +		.gyro_fs_value = BMG_FSR_250DPS_VAL,
> +		.gyro_fs_dps = BMG_FS_AVL_250DPS,
> +		.gyro_fs_rslt = 7600,
> +	},
> +	[4] = {
> +		.gyro_fs_value = BMG_FSR_125DPS_VAL,
> +		.gyro_fs_dps = BMG_FS_AVL_125DPS,
> +		.gyro_fs_rslt = 3800,
> +	},
> +};
> +
> +static const struct bmg_chip_config chip_config_bmg = {
> +	.fsr = BMG_FSR_2000DPS_VAL,
> +	.filter_bw = BMG_FILTER_12HZ,
> +	.gyro_fifo_enable = false,
> +};
> +
> +static const struct bmg_hw bmg_hw_info[NUM_DEVICE_PARTS] = {
> +	{
> +		.name = "bmg160",
> +		.chip_id = SENSOR_CHIP_ID_BMG,
> +		.config = &chip_config_bmg,
> +	},
> +};
> +
> +#define BMG_SENSORS_12_BITS		12
> +#define BMG_SENSORS_16_BITS		16
> +#define BMG_TEMP_SCALE			5000
> +#define BMG_TEMP_OFFSET			12000
> +#define WATER_MARK_LEVEL			40
> +
> +#define BMG_GYRO_CHANNELS_CONFIG(device_type, si, mod, \
> +							endian, bits, addr) \
> +	{ \
> +		.type = device_type, \
> +		.modified = 1, \
> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE), \
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW), \
> +		.scan_index = si, \
> +		.channel2 = mod, \
> +		.address = addr, \
> +		.scan_type = { \
> +			.sign = 's', \
> +			.realbits = bits, \
> +			.shift = 16 - bits, \
> +			.storagebits = 16, \
> +			.endianness = endian, \
> +		}, \
> +	}
> +#define BMG_DEV_ATTR_SAMP_FREQ() \
> +		IIO_DEV_ATTR_SAMP_FREQ(S_IWUSR | S_IRUGO, \
> +			bmg_read_frequency, \
> +			bmg_write_frequency)
> +
> +#define BMG_DEV_ATTR_R_W(name) \
> +	IIO_DEVICE_ATTR(name, S_IRUGO | S_IWUSR , \
> +		bmg_show_##name, \
> +		bmg_store_##name, 0);
> +
> +#define BMG_DEV_ATTR_R(name) \
> +		IIO_DEVICE_ATTR(name, S_IRUGO, \
> +			bmg_show_##name, NULL , 0);
> +
> +#define BMG_DEV_ATTR_W(name) \
> +		IIO_DEVICE_ATTR(name, S_IWUSR, \
> +			NULL, bmg_store_##name, 0);
> +
> +#define BMG_BYTE_FOR_PER_AXIS_CHANNEL		2
> +
This isn't used in this driver currently so drop it.
> +/*iio chan spec for 12bit gyro sensor*/
> +static const struct iio_chan_spec bmg_12bit_raw_channels[] = {
> +	{	.type = IIO_TEMP,
> +		.channel = IIO_NO_MOD,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW)
> +				| BIT(IIO_CHAN_INFO_OFFSET)
> +				| BIT(IIO_CHAN_INFO_SCALE),
> +		.address = BMG160_TEMP_ADDR,
> +		.scan_index = -1,
> +		.scan_type = { .sign = 'u', .realbits = 8,
> +			.storagebits = 8, .shift = 0, .endianness = IIO_LE },
> +	},

> +	BMG_GYRO_CHANNELS_CONFIG(IIO_ANGL_VEL, BMG_SCAN_GYRO_X,
> +	IIO_MOD_X, IIO_LE, BMG_SENSORS_12_BITS, BMG160_RATE_X_LSB_VALUEX__REG),
> +	BMG_GYRO_CHANNELS_CONFIG(IIO_ANGL_VEL, BMG_SCAN_GYRO_Y,
> +	IIO_MOD_Y, IIO_LE, BMG_SENSORS_12_BITS, BMG160_RATE_Y_LSB_VALUEY__REG),
> +	BMG_GYRO_CHANNELS_CONFIG(IIO_ANGL_VEL, BMG_SCAN_GYRO_Z,
> +	IIO_MOD_Z, IIO_LE, BMG_SENSORS_12_BITS, BMG160_RATE_Z_LSB_VALUEZ__REG),
> +	IIO_CHAN_SOFT_TIMESTAMP(BMG_SCAN_TIMESTAMP),
> +
> +};
> +
> +/*iio chan spec for 16bit gyro sensor*/
> +static const struct iio_chan_spec bmg_16bit_raw_channels[] = {
> +	{	.type = IIO_TEMP,
> +		.channel = IIO_NO_MOD,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW)
> +				| BIT(IIO_CHAN_INFO_OFFSET)
> +				| BIT(IIO_CHAN_INFO_SCALE),
> +		.address = BMG160_TEMP_ADDR,
> +		.scan_index = -1,
> +		.scan_type = { .sign = 'u', .realbits = 8,
> +			.storagebits = 8, .shift = 0, .endianness = IIO_LE },
> +	},
This macro can obviously be simplified.
Just have a
BMG_GYRO(X) and build the rest from that. Or have it all in long hand like the
temp channel above.   A few more lines of code, but a lot more readable.
> +	BMG_GYRO_CHANNELS_CONFIG(IIO_ANGL_VEL, BMG_SCAN_GYRO_X,
> +	IIO_MOD_X, IIO_LE, BMG_SENSORS_16_BITS, BMG160_RATE_X_LSB_VALUEX__REG),
> +	BMG_GYRO_CHANNELS_CONFIG(IIO_ANGL_VEL, BMG_SCAN_GYRO_Y,
> +	IIO_MOD_Y, IIO_LE, BMG_SENSORS_16_BITS, BMG160_RATE_Y_LSB_VALUEY__REG),
> +	BMG_GYRO_CHANNELS_CONFIG(IIO_ANGL_VEL, BMG_SCAN_GYRO_Z,
> +	IIO_MOD_Z, IIO_LE, BMG_SENSORS_16_BITS, BMG160_RATE_Z_LSB_VALUEZ__REG),
> +	IIO_CHAN_SOFT_TIMESTAMP(BMG_SCAN_TIMESTAMP),
> +};
> +
I'm not even going to look at this routine.  Strip out the options.
There is a lot of emulated support to handle weird combinations in the
i2c stack so just let it do its job.
> +/* bmg i2c routine read */
> +static char bmg_i2c_read(struct i2c_client *client, u8 reg_addr,
> +		u8 *data, u8 len)
> +{
> +#if !defined BMG_USE_BASIC_I2C_FUNC
> +	s32 dummy;
> +	if (NULL == client)
> +		return -1;
> +
> +	while (0 != len--) {
> +#ifdef BMG_SMBUS
> +		dummy = i2c_smbus_read_byte_data(client, reg_addr);
> +		if (dummy < 0) {
> +			dev_err(&client->dev, "i2c bus read error");
> +			return -1;
> +		}
> +		*data = (u8)(dummy & 0xff);
> +#else
> +		dummy = i2c_master_send(client, (char *)&reg_addr, 1);
> +		if (dummy < 0)
> +			return -1;
> +
> +		dummy = i2c_master_recv(client, (char *)data, 1);
> +		if (dummy < 0)
> +			return -1;
> +#endif
> +		reg_addr++;
> +		data++;
> +	}
> +	return 0;
> +#else
> +	int retry;
> +
> +	struct i2c_msg msg[] = {
> +		{
> +		 .addr = client->addr,
> +		 .flags = 0,
> +		 .len = 1,
> +		 .buf = &reg_addr,
> +		},
> +
> +		{
> +		 .addr = client->addr,
> +		 .flags = I2C_M_RD,
> +		 .len = len,
> +		 .buf = data,
> +		 },
> +	};
> +
> +	for (retry = 0; retry < BMG_MAX_RETRY_I2C_XFER; retry++) {
> +		if (i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg)) > 0)
> +			break;
> +		else
> +			mdelay(BMG_I2C_WRITE_DELAY_TIME);
> +	}
> +
> +	if (BMG_MAX_RETRY_I2C_XFER <= retry) {
> +		dev_err(&client->dev, "I2C xfer error");
> +		return -EIO;
> +	}
> +
> +	return 0;
> +#endif
> +}
> +
get rid of this.
> +static void bmg_i2c_delay(BMG160_S32 msec)
> +{
> +	mdelay(msec);
> +}
> +
Drop this or provide it via debugfs (or use regmap and that
will provide all this for you).
> +static void bmg_dump_reg(struct i2c_client *client)
> +{
> +	int i;
> +	u8 dbg_buf[64];
> +	u8 dbg_buf_str[64 * 3 + 1] = "";
> +
> +	for (i = 0; i < BYTES_PER_LINE; i++) {
> +		dbg_buf[i] = i;
> +		sprintf(dbg_buf_str + i * 3, "%02x%c",
> +				dbg_buf[i],
> +				(((i + 1) % BYTES_PER_LINE == 0) ? '\n' : ' '));
> +	}
> +	dev_dbg(&client->dev, "%s\n", dbg_buf_str);
> +
> +	bmg_i2c_read(client, BMG_REG_NAME(CHIP_ID_ADDR), dbg_buf, 64);
> +	for (i = 0; i < 64; i++) {
> +		sprintf(dbg_buf_str + i * 3, "%02x%c",
> +				dbg_buf[i],
> +				(((i + 1) % BYTES_PER_LINE == 0) ? '\n' : ' '));
> +	}
> +	dev_dbg(&client->dev, "%s\n", dbg_buf_str);
> +}
> +
> +
> +/* i2c operation for API */
> +static int bmg_check_chip_id(struct i2c_client *client)
> +{
> +	int err = 0;
> +	u8 chip_id = 0;
> +
> +	bmg_i2c_read(client, BMG_REG_NAME(CHIP_ID_ADDR), &chip_id, 1);
> +	dev_info(&client->dev, "read chip id result: %#x", chip_id);
> +
> +	if ((chip_id & 0xff) != SENSOR_CHIP_ID_BMG)
> +		err = -1;
> +
> +	return err;
> +}
> +
> +/*	i2c write routine*/
> +static char bmg_i2c_write(struct i2c_client *client, u8 reg_addr,
> +		u8 *data, u8 len)
> +{
Drop the #define mess here. If you have to check the functionality
available and have two write routines depending on what is there.
smbus is emulated on i2c, so I doubt there is any advantage
in doing it by hand here.

> +#if !defined BMG_USE_BASIC_I2C_FUNC
> +	s32 dummy;
> +
> +#ifndef BMG_SMBUS
> +	u8 buffer[2];
> +#endif
> +
> +	if (NULL == client)
> +		return -EPERM;
> +
> +	while (0 != len--) {
> +#ifdef BMG_SMBUS
> +		dummy = i2c_smbus_write_byte_data(client, reg_addr, *data);
> +#else
> +		buffer[0] = reg_addr;
> +		buffer[1] = *data;
> +		dummy = i2c_master_send(client, (char *)buffer, 2);
> +#endif
> +		reg_addr++;
> +		data++;
> +		if (dummy < 0) {
> +			dev_err(&client->dev, "error writing i2c bus");
> +			return -EPERM;
> +		}
> +
> +	}
> +	return 0;
> +#else
> +	u8 buffer[2];
> +	int retry;
> +	struct i2c_msg msg[] = {
> +		{
> +		 .addr = client->addr,
> +		 .flags = 0,
> +		 .len = 2,
> +		 .buf = buffer,
> +		 },
> +	};
> +
> +	while (0 != len--) {
> +		buffer[0] = reg_addr;
> +		buffer[1] = *data;
> +		for (retry = 0; retry < BMG_MAX_RETRY_I2C_XFER; retry++) {
> +			if (i2c_transfer(client->adapter, msg,
> +						ARRAY_SIZE(msg)) > 0) {
> +				break;
> +			} else {
> +				mdelay(BMG_I2C_WRITE_DELAY_TIME);
> +			}
> +		}
> +		if (BMG_MAX_RETRY_I2C_XFER <= retry) {
> +			dev_err(&client->dev, "I2C xfer error");
> +			return -EIO;
> +		}
> +		reg_addr++;
> +		data++;
> +	}
> +
> +	return 0;
> +#endif
> +}
> +
Ah. Now the single device hack makes sense.  Just take a look at one of
the other drivers with i2c and spi support to see how this is handled cleanly.

> +static char bmg_i2c_read_wrapper(u8 dev_addr, u8 reg_addr, u8 *data, u8 len)
> +{
> +	char err;
> +	err = bmg_i2c_read(bmg_client, reg_addr, data, len);
> +	return err;
> +}
> +
> +static char bmg_i2c_write_wrapper(u8 dev_addr, u8 reg_addr, u8 *data, u8 len)
> +{
> +	char err;
> +	err = bmg_i2c_write(bmg_client, reg_addr, data, len);
> +	return err;
> +}
> +
> +
> +static int bmg_read_axis_data(struct iio_dev *indio_dev, u8 reg_address,
> +		int *data)
> +{
> +	int ret;
> +	unsigned char axis_outdata[BMG_BYTE_FOR_PER_AXIS_CHANNEL];
> +	struct  bmg_client_data *client_data = iio_priv(indio_dev);
> +
> +	ret = bmg_i2c_read(client_data->client, reg_address,
> +				axis_outdata, BMG_BYTE_FOR_PER_AXIS_CHANNEL);
> +	if (ret < 0)
> +		return ret;
> +
> +	*data = (s16)get_unaligned_le16(axis_outdata);
> +	return 0;
> +}
> +
> +static int bmg_read_temp_data(struct iio_dev *indio_dev, u8 reg_address,
> +		int *data)
> +{
> +	int ret;
> +	signed char temp_outdata;
> +	struct  bmg_client_data *client_data = iio_priv(indio_dev);
> +
> +	ret = bmg_i2c_read(client_data->client, reg_address, &temp_outdata, 1);
> +	if (ret < 0)
> +		return ret;
> +	*data = (temp_outdata) & 0xff;
> +	return 0;
> +}
> +
> +static ssize_t bmg_read_frequency(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	int ret;
> +	unsigned char bandwidth = 0;
> +
> +	mutex_lock(&indio_dev->mlock);
> +	BMG_CALL_API(get_bw)(&bandwidth);
> +	mutex_unlock(&indio_dev->mlock);
> +
> +	ret = scnprintf(buf, BUFF_SIZE, "%d\n", bandwidth);
> +	return ret;
> +}
> +
> +static ssize_t bmg_write_frequency(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	int err;
> +	unsigned long bandwidth;
> +	err = kstrtoul(buf, 10, &bandwidth);
> +	if (err)
> +		return err;
> +
> +	mutex_lock(&indio_dev->mlock);
> +	BMG_CALL_API(set_bw)(bandwidth);
> +	mutex_unlock(&indio_dev->mlock);
> +
> +	return count;
> +}
> +
> +static ssize_t bmg_show_op_mode(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	int ret;
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	u8 op_mode = 0xff;
> +
> +	mutex_lock(&indio_dev->mlock);
> +	BMG_CALL_API(get_mode)(&op_mode);
> +	mutex_unlock(&indio_dev->mlock);
> +
> +	ret = scnprintf(buf, BUFF_SIZE, "%d\n", op_mode);
> +
> +	return ret;
> +}
> +
> +static ssize_t bmg_store_op_mode(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	int err;
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	long op_mode;
> +
> +	err = kstrtoul(buf, 10, &op_mode);
> +	if (err)
> +		return err;
> +
> +	dev_notice(indio_dev->dev.parent, "%s:set op-mode[%ld]",
> +		__func__, op_mode);
> +
> +	mutex_lock(&indio_dev->mlock);
> +	err = BMG_CALL_API(set_mode)(op_mode);
> +	mutex_unlock(&indio_dev->mlock);
> +
> +	if (err)
> +		return err;
> +	else
> +		return count;
> +}
> +
> +static ssize_t bmg_show_bandwidth(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	int err;
> +	unsigned char bandwidth = 0;
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +
> +	mutex_lock(&indio_dev->mlock);
> +	BMG_CALL_API(get_bw)(&bandwidth);
> +	mutex_unlock(&indio_dev->mlock);
> +
> +	err = scnprintf(buf, BUFF_SIZE, "%d\n", bandwidth);
> +	return err;
> +}
> +
> +static ssize_t bmg_store_bandwidth(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	int err;
> +	unsigned long bandwidth;
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	err = kstrtoul(buf, 10, &bandwidth);
> +	if (err)
> +		return err;
> +
> +	mutex_lock(&indio_dev->mlock);
> +	BMG_CALL_API(set_bw)(bandwidth);
> +	mutex_unlock(&indio_dev->mlock);
> +
> +	return count;
> +}
> +
> +static ssize_t bmg_show_selftest(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	int err;
> +	unsigned char selftest;
> +	BMG160_U16 datax_check = 0;
> +	BMG160_U16 datay_check = 0;
> +	BMG160_U16 dataz_check = 0;
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct bmg_client_data *client_data = iio_priv(indio_dev);
> +
> +	BMG_CALL_API(selftest)(&selftest);
> +	if (selftest)	{
> +		dev_err(&indio_dev->dev, "gyro driver self test can not pass!\n");
> +		return C_BMG160_FAILURE;
> +	}
> +	BMG_CALL_API(set_bw)(C_BMG160_Three_U8X);/*set bandwidth 47Hz*/
> +	mutex_lock(&indio_dev->mlock);
> +	BMG_CALL_API(get_dataxyz)(&client_data->value);
> +	datax_check = abs(1000 * client_data->value.datax / 16384);
> +	datay_check = abs(1000 * client_data->value.datay / 16384);
> +	dataz_check = abs(1000 * client_data->value.dataz / 16384);
> +	mutex_unlock(&indio_dev->mlock);
> +	if ((datax_check <= 5) && (datay_check <= 5) && (dataz_check <= 5))
> +		dev_notice(&indio_dev->dev, "Self test successfully!\n");
> +	else {
> +		dev_err(&indio_dev->dev, "Self test checking value failed!");
> +		dev_err(&indio_dev->dev, "x y z axis values:%d,%d,%d\n",
> +			datax_check, datay_check, dataz_check);
> +		selftest |= C_BMG160_FAILURE;
> +	}
> +	err = scnprintf(buf, BUFF_SIZE, "%d\n", selftest);
> +	return err;
> +}
> +
> +static int bmg_set_fullscale(struct bmg_client_data *client_data, int val)
> +{
> +	int i;
> +	if ((val > C_BMG160_Four_U8X) || (val < C_BMG160_Zero_U8X))
> +		return -EINVAL;
> +	for (i = 0; i < NUM_BMG_FSR_VAL; i++) {
> +		if (val == bmg_fs_avl_array[i].gyro_fs_value) {
> +			BMG_CALL_API(set_range_reg)(val);

As I have suggested below, if this were simply an index into the array
e.g. client_data->current_fullscale = i;
> +			client_data->current_fullscale =
> +			(struct bmg_fullscale_avl *)&bmg_fs_avl_array[i];
> +			return 0;
> +		} else if (i == NUM_BMG_FSR_VAL)
> +			return -EINVAL;
> +	}
> +	return -EINVAL;
> +}
> +
> +static int bmg_read_raw(struct iio_dev *indio_dev,
> +			struct iio_chan_spec const *ch, int *val,
> +							int *val2, long mask)
> +{
> +	int ret, result;
> +	struct bmg_client_data *client_data = iio_priv(indio_dev);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +	{
> +		result = 0;
> +		ret = IIO_VAL_INT;
> +		mutex_lock(&indio_dev->mlock);
> +		switch (ch->type) {
> +		case IIO_ANGL_VEL:
> +			result = bmg_read_axis_data(indio_dev,
> +							ch->address, val);
> +			*val = *val >> ch->scan_type.shift;
> +			break;
> +		case IIO_TEMP:
> +			result = bmg_read_temp_data(indio_dev,
> +							ch->address, val);
> +			*val = *val >> ch->scan_type.shift;
> +			break;
> +		default:
> +			ret = -EINVAL;
> +			break;
> +		}
> +	mutex_unlock(&indio_dev->mlock);
> +	if (result < 0)
> +		return result;
> +	return ret;
> +	}
> +
> +	case IIO_CHAN_INFO_SCALE:
> +	{
> +		switch (ch->type) {
> +		case IIO_ANGL_VEL:
> +			*val = 0;
With current_full_scale as index into array you get
*val2 = bmg_fs_avl_array[client_data->current_fullscale].gyro_fs_rslt;

> +			*val2 = client_data->current_fullscale->gyro_fs_rslt;
> +			return IIO_VAL_INT_PLUS_MICRO;
> +		case IIO_TEMP:
> +			*val = 0;
Put the value here directly.
> +			*val2 = BMG_TEMP_SCALE;
> +			return IIO_VAL_INT_PLUS_MICRO;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
> +	case IIO_CHAN_INFO_OFFSET:
> +	{
> +		switch (ch->type) {
> +		case IIO_TEMP:
Just put the value here. No need to have the define.
> +			*val = BMG_TEMP_OFFSET;
> +			return IIO_VAL_INT;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +}
> +
write
> +static int bmg_wirte_raw(struct iio_dev *indio_dev,
> +			struct iio_chan_spec const *ch, int val,
> +							int val2, long mask)
> +{
> +	int ret;
> +	struct bmg_client_data *client_data = iio_priv(indio_dev);
> +
> +	mutex_lock(&indio_dev->mlock);
> +	switch (mask) {
> +	case IIO_CHAN_INFO_SCALE:
> +		switch (ch->type) {
> +		case IIO_ANGL_VEL:
> +			ret = bmg_set_fullscale(client_data, val);
> +			break;
> +		default:
> +			ret = -EINVAL;
> +			break;
> +		}
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	mutex_unlock(&indio_dev->mlock);
> +	return ret;
> +}
> +
> +static IIO_CONST_ATTR_SAMP_FREQ_AVAIL("100 200 400 1000 2000");
> +static BMG_DEV_ATTR_SAMP_FREQ();
> +static BMG_DEV_ATTR_R_W(op_mode);
> +static BMG_DEV_ATTR_R_W(bandwidth);
More macros that hide the details whilst adding nothing.  Please put
this stuff out long hand.
> +static BMG_DEV_ATTR_R(selftest);
> +
> +static struct attribute *bmg_attributes[] = {
> +	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
> +	&iio_dev_attr_sampling_frequency.dev_attr.attr,
We now have info_mask_shared_by_all to handle sampling frequency.
> +	&iio_dev_attr_op_mode.dev_attr.attr,
It rarely makes sense to expose a device mode to userspace explicitly
(and the interface never standardizes well so the vast majority
of userspace code won't make use of it.)

> +	&iio_dev_attr_bandwidth.dev_attr.attr,
Probably a filter related element?  In which case, we do have
some filter elements defined - see the abi docs.

Anything in here that is not in the ABI docs needs documentation
and justification.  See Documentation/ABI/testing/sysfs-bus-iio

Self test for example is usually only done on driver initial probe
thus avoiding the need for a userspace interface.
> +	&iio_dev_attr_selftest.dev_attr.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group bmg_attribute_group = {
> +	.attrs = bmg_attributes,
> +};
> +
> +static const struct iio_info bmg_iio_info = {
> +	.driver_module = THIS_MODULE,
prefix should be bmg160. I assume there will be other parts in future
and this way there is no possibility of confusion  or naming clashes.
> +	.attrs = &bmg_attribute_group,
> +	.read_raw = &bmg_read_raw,
> +	.write_raw = &bmg_wirte_raw,
> +};
> +
1 blank line is always enough.
> +
> +
> +
> +static int bmg_probe(struct i2c_client *client, const struct i2c_device_id *id)
> +{
> +	int err = 0;
> +	struct iio_dev *indio_dev;
> +	struct bmg_client_data *client_data = NULL;
> +	struct device_node *np = client->dev.of_node;

Drop these debugging stuff from the driver before posting.
> +	dev_info(&client->dev, "function entrance");
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_err(&client->dev, "i2c_check_functionality error!");
> +		err = -EIO;
> +		goto exit_err_clean;
> +	}
> +
> +	if (NULL == bmg_client) {
Other way around is conventional.

This code has to go.  The driver must support multiple devices before
we will take it. It is not hard to do so I have no idea why you have
limited it like this.

> +		bmg_client = client;
> +	} else {
> +		dev_err(&client->dev,
> +			"this driver does not support multiple clients");
> +		err = -EINVAL;
> +		goto exit_err_clean;
> +	}
> +
> +	err = bmg_check_chip_id(client);
> +	if (!err) {
This positive confirmation is just noise.  So don't bother.
> +		dev_notice(&client->dev,
> +			"Bosch Sensortec Device %s detected", SENSOR_NAME);
> +	} else {
The negative is however useful so keep this.
> +		dev_err(&client_data->client->dev,
> +			"Bosch Sensortec Device not found, chip id mismatch");
> +		err = -ENXIO;
> +		goto exit_err_clean;
> +	}
> +
> +	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*client_data));
> +	if (indio_dev == NULL) {
> +		dev_err(indio_dev->dev.parent,
> +				"IIO device alloc err %d\n", err);
> +		return -ENOMEM;
> +	}
> +
> +	client_data = iio_priv(indio_dev);
> +	client_data->client = client;
> +	i2c_set_clientdata(client, indio_dev);
> +/* get gpio interrupt pin number from DTS
> + * need to set in the dts file by using "gpio_int" key word.
> + */
I've not seen an device tree docs for this in the patch?
Those need to be added and posted to devicetree@vger.kernel.org
before we take this driver.

> +	err = of_property_read_u32(np, "gpio_int",
> +				&client_data->gpio_interrupt_pin);
> +	if (err) {
> +		dev_err(&client_data->client->dev,
> +			"Not found usable gpio interrupt pin!\n");
> +		client_data->gpio_interrupt_pin = 0;
> +	}
> +	indio_dev->dev.parent = &client->dev;
> +	indio_dev->name = client->name;
This driver only contains these channels, so naming should simply
be bmg160_channels.
> +	indio_dev->channels = bmg_16bit_raw_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(bmg_16bit_raw_channels);
> +	indio_dev->info = &bmg_iio_info;

With index into array for current_fullscale this becomes
client_data->current_fullscale = 0; or = BMG_FSR_2000DPS_VAL; for added clarity.
> +	client_data->current_fullscale = (struct bmg_fullscale_avl *)
> +							&bmg_fs_avl_array[0];
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	/* h/w init */
As mentioned below, rip this wrapper layer out or ideally move to regmap
so you are using a standard layer which will then handle spi trivially
when you add it.

> +	client_data->device.bus_read = bmg_i2c_read_wrapper;
> +	client_data->device.bus_write = bmg_i2c_write_wrapper;
> +	client_data->device.delay_msec = bmg_i2c_delay;
> +
> +
> +	BMG_CALL_API(init)(&client_data->device);
Drop this debug stuff.
> +	bmg_dump_reg(client);
> +	client_data->enable = 0;
> +
This needs to come from platform data or the device tree. Not
some defines in the driver.
> +#ifdef BMG160_ENABLE_INT1
> +	/* maps interrupt to INT1 pin */
> +	BMG_CALL_API(set_int_od)(BMG160_INT1, INT_PIN_PUSH_PULL);
> +	BMG_CALL_API(set_int_data)(BMG160_INT1, INT_ENABLE);
> +#endif
> +
> +#ifdef BMG160_ENABLE_INT2
> +	/* maps interrupt to INT2 pin */
> +	BMG_CALL_API(set_int_data)(BMG160_INT2, INT_ENABLE);
> +	BMG_CALL_API(set_int_od)(BMG160_INT2, INT_PIN_PUSH_PULL);
> +#endif
> +
> +	memcpy(&client_data->chip_config,
> +			bmg_hw_info[client_data->chip_type].config,
> +				sizeof(struct bmg_chip_config));
> +	client_data->IRQ = client->irq;
> +
> +	err = bmg_allocate_ring(indio_dev);
> +	if (err < 0) {
> +		dev_err(indio_dev->dev.parent,
> +				"bmg configure buffer fail %d\n", err);
> +		return err;
> +	}
> +	err = bmg_probe_trigger(indio_dev);
> +	if (err) {
> +		dev_err(indio_dev->dev.parent,
> +				"bmg trigger probe fail %d\n", err);
> +		goto bmg_probe_trigger_error;
> +	}
> +	BMG_CALL_API(set_bw)(3); /*set bandwidth to 47Hz*/
> +	err = iio_device_register(indio_dev);
> +	if (err) {
> +		dev_err(indio_dev->dev.parent,
> +				"bmg IIO device register failed %d\n", err);
> +		goto bmg_probe_error;
> +	}
> +
> +
> +	BMG_CALL_API(set_data_enable)(INT_ENABLE);
> +	/* now it's power on which is considered as resuming from suspend */
> +	err = BMG_CALL_API(set_mode)(
> +			BMG_VAL_NAME(MODE_SUSPEND));
Handle the error? Why not have this before the register (at which point the
device is available to userspace)
> +
> +	dev_notice(indio_dev->dev.parent,
> +		"IIO device sensor %s probed successfully", SENSOR_NAME);
> +
> +	return 0;
> +
> +bmg_probe_error:
> +	bmg_remove_trigger(indio_dev);
> +bmg_probe_trigger_error:
> +	bmg_deallocate_ring(indio_dev);
> +exit_err_clean:
> +	bmg_client = NULL;
> +	return err;
> +
No blank space here.
> +}
> +
> +
> +static int bmg_remove(struct i2c_client *client)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +
> +	iio_device_unregister(indio_dev);
> +	iio_triggered_buffer_cleanup(indio_dev);
> +	iio_device_free(indio_dev);

Use devm_iio_device_alloc above then you don't need to do this free.


> +	return 0;
> +}
> +
> +static const struct i2c_device_id bmg_id[] = {
> +	{ SENSOR_NAME, 0 },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, bmg_id);
> +
> +static struct i2c_driver bmg_driver = {
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = SENSOR_NAME,
> +	},
> +	.id_table = bmg_id,
> +	.probe = bmg_probe,
> +	.remove = bmg_remove,
> +};
> +
Use MODULE_I2C_DRIVER to replace this boilerplate.

> +static int __init bmg_init(void)
> +{
> +	return i2c_add_driver(&bmg_driver);
> +}
> +
> +static void __exit bmg_exit(void)
> +{
> +	i2c_del_driver(&bmg_driver);
> +}
> +
> +MODULE_AUTHOR("contact@bosch-sensortec.com");
> +MODULE_DESCRIPTION("driver for " SENSOR_NAME);
> +MODULE_LICENSE("GPL v2");
> +
> +module_init(bmg_init);
> +module_exit(bmg_exit);
> diff --git a/drivers/iio/gyro/bmg160_ring.c b/drivers/iio/gyro/bmg160_ring.c
> new file mode 100644
> index 0000000..ffc51d1
> --- /dev/null
> +++ b/drivers/iio/gyro/bmg160_ring.c
> @@ -0,0 +1,69 @@
> +/*
> + * (C) Copyright 2013 Bosch Sensortec GmbH All Rights Reserved
> + *
> + * This software program is licensed subject to the GNU General Public License
> + * (GPL).Version 2,June 1991, available at http://www.fsf.org/copyleft/gpl.html
> + *
> + *	BMG160 Linux IIO Driver
> + */
> +
> +#include "bmg_iio.h"
> +
I'm not actually seeing this being used anywhere...
> +extern char bmg_i2c_burst_read(struct i2c_client *client, u8 reg_addr,
> +		u8 *data, u16 len);
> +
> +static irqreturn_t bmg_buffer_handler(int irq, void *p)
> +{
> +	struct iio_poll_func *pf = p;
> +	struct iio_dev *indio_dev = pf->indio_dev;
> +	struct bmg_client_data *client_data = iio_priv(indio_dev);
> +	size_t bytes_per_datum = 0;
> +	s64 timestamp =  iio_get_time_ns();
> +
> +	u8 buffer_data_out[BMG160_OUTPUT_DATA_SIZE];
> +	/*storge new axis data(or every frame)*/
> +
> +	mutex_lock(&indio_dev->mlock);
> +	if (!(client_data->chip_config.gyro_fifo_enable))
> +		goto bmg_buffer_handler_error;
> +	bytes_per_datum = 0;
> +	if (client_data->chip_config.gyro_fifo_enable)
> +		bytes_per_datum = BMG160_BYTES_PER_3AXIS_SENSOR;
How would you get here if no channels are enabled?  Where is the
interrupt coming from?
> +/*
> +* There is new data to push to IIO ring buffer
> +* please give attentions to the data format
> +*/
> +	BMG_CALL_API(get_dataxyz)(&client_data->value);
This is a typical example of why those macros are hideous.
ret = bm160_get_dataxyz(&client_data->value);

Also note you haven't handled the errors that might occur.
There is no way to signalling them from this handler
unfortunately, but you don't want to push the corrupt
data into the buffer.

> +
Standard endian conversion functions will make this much simpler
eg be16_to_cpu (or which ever is relevant. I've not had enough coffee to think
about it this morning :)
> +	buffer_data_out[0] = client_data->value.datax & 0xff;
> +	buffer_data_out[1] = (client_data->value.datax >> 8) & 0xff;
> +	buffer_data_out[2] = client_data->value.datay & 0xff;
> +	buffer_data_out[3] = (client_data->value.datay >> 8) & 0xff;
> +	buffer_data_out[4] = client_data->value.dataz & 0xff;
> +	buffer_data_out[5] = (client_data->value.dataz >> 8) & 0xff;

So you always push all channels.  As that is the case you will want
to appropriately define iio_dev->available_scan_masks so the demux
code in the core can provide what is actually requested.

> +	/*for every frame, need 8 bytes to axis data storage*/
> +	iio_push_to_buffers_with_timestamp(indio_dev, buffer_data_out, timestamp);
> +
> +
> +bmg_buffer_handler_error:
> +	mutex_unlock(&indio_dev->mlock);
> +	iio_trigger_notify_done(indio_dev->trig);
> +
> +	return IRQ_HANDLED;
> +
> +}
> +
One blank line only.
> +
> +int bmg_allocate_ring(struct iio_dev *indio_dev)
> +{
> +	return iio_triggered_buffer_setup(indio_dev, &iio_pollfunc_store_time,
> +			&bmg_buffer_handler, NULL);
> +}
> +
> +void bmg_deallocate_ring(struct iio_dev *indio_dev)
> +{
> +	iio_triggered_buffer_cleanup(indio_dev);
> +}
> +
> +
> +
Run checkpatch over your file and Sparse when building.

Something should have moaned about blank lines at the end of a file.  One is always enough ;)
> diff --git a/drivers/iio/gyro/bmg160_trigger.c b/drivers/iio/gyro/bmg160_trigger.c
> new file mode 100644
> index 0000000..a374c72
> --- /dev/null
> +++ b/drivers/iio/gyro/bmg160_trigger.c
> @@ -0,0 +1,122 @@
> +/*
> + * (C) Copyright 2013 Bosch Sensortec GmbH All Rights Reserved
> + *
> + * This software program is licensed subject to the GNU General Public License
> + * (GPL).Version 2,June 1991, available at http://www.fsf.org/copyleft/gpl.html
> + *
> + * BMG160 Linux IIO Driver
> + */
> +
> +#include "bmg_iio.h"
> +
> +#include <asm/irq.h>
> +#include <linux/gpio.h>
> +#include <linux/of_irq.h>
> +

Just to check, what is this trigger firing on?
Every new set of data (3 readings, one per channel)
A fifo watershead interrupt?

If it is the fifo watershead, then you'll want to look at how we handled
this in the recent support added to iio/adc/ti_am355x_adc.
In short, the trigger has no meaning, so drop it and push directly to the
buffer.

> +
> +static void bmg_scan_query(struct iio_dev *indio_dev)
> +{
> +	 struct bmg_client_data *client_data = iio_priv(indio_dev);
> +
> +	 client_data->chip_config.gyro_fifo_enable =
> +		test_bit(BMG_SCAN_GYRO_X, indio_dev->active_scan_mask) ||
> +		test_bit(BMG_SCAN_GYRO_Y, indio_dev->active_scan_mask) ||
> +		test_bit(BMG_SCAN_GYRO_Z, indio_dev->active_scan_mask);
> +}
> +
> + /**
> +  *  bmg_set_trig_ready_enable() - enable related functions such as new data mode.
> +  *  @indio_dev: Device driver instance.
> +  *  @enable: enable/disable
> +  */
> +static int bmg_set_trig_ready_enable(struct iio_dev *indio_dev, bool enable)
> +{
> +	 struct bmg_client_data *client_data = iio_priv(indio_dev);
> +
> +	if (enable) {
> +		bmg_scan_query(indio_dev);
> +		if (client_data->chip_config.gyro_fifo_enable)
> +			dev_notice(indio_dev->dev.parent, "bmg scan query active enable.\n");
> +#if defined(BMG160_ENABLE_INT1) || defined(BMG160_ENABLE_INT2)
> +	BMG_CALL_API(set_data_enable)(INT_ENABLE);
> +	dev_notice(indio_dev->dev.parent, "bmg new data ready enable.\n");
> +#endif
> +	} else {
> +	BMG_CALL_API(set_reset_int)(1);
> +#if defined(BMG160_ENABLE_INT1) || defined(BMG160_ENABLE_INT2)
> +	BMG_CALL_API(set_data_enable)(INT_DISABLE);
Drop this from a posted driver.  Useful for debugging, but not necessary after that.

> +	dev_notice(indio_dev->dev.parent, "bmg new data ready disabled.\n");
> +#endif
> +	}
> +	 return 0;
> +}
> +
> + /**
> +  * bmg_data_rdy_trigger_set_state() - set data ready state
> +  * @trig: Trigger instance
> +  * @state: Desired trigger state
> +  */
> +static int bmg_data_rdy_trigger_set_state(struct iio_trigger *trig,
> +						 bool state)
> +{
> +	return bmg_set_trig_ready_enable(iio_trigger_get_drvdata(trig), state);
> +}
> +
> +static const struct iio_trigger_ops bmg_trigger_ops = {
> +	 .owner = THIS_MODULE,
> +	 .set_trigger_state = &bmg_data_rdy_trigger_set_state,
> +};
> +
> +int bmg_probe_trigger(struct iio_dev *indio_dev)
> +{
> +	int ret;
> +	struct bmg_client_data *client_data = iio_priv(indio_dev);
> +	int irq_num = 0;
blank line here please.
> +	client_data->trig = iio_trigger_alloc("%s-dev%d",
> +					 indio_dev->name,
> +					 indio_dev->id);
> +	if (client_data->trig == NULL) {
> +		ret = -ENOMEM;
> +		dev_err(&indio_dev->dev, "bmg failed to allocate iio trigger.\n");
This dev_err doesn't really provide any useful information.  I'd drop it.
> +		goto error_alloc_trigger;
Recently kernel coding convention has come out very much against
having gotos when there is no cleanup to be done.  Hence
just return -ENOMEM here.

> +	}
> +	/*inital the gpio input direction*/

It's an interrupt pin.  The driver should not care that it is a gpio.
This should be handled by the gpio controller on the interrupt being
requested. If that is not working then there is a bug somewhere else.
> +	gpio_direction_input(client_data->gpio_interrupt_pin);
> +	irq_num = gpio_to_irq(client_data->gpio_interrupt_pin);
Also the flags field is where you should set your IRQ type.
IRQF_TRIGGER_RISING and probably IRQ_ONESHOT to ensure the previous handler is
finished before we fire another one.

> +	ret = devm_request_irq(irq_num, &iio_trigger_generic_data_rdy_poll, 0,
> +					"bmg_iio_int", client_data->trig);
> +	if (ret) {
> +		dev_err(&client_data->client->dev,
> +				"bmg could not request irq! err = %d\n", ret);
> +		goto error_irq_request;
> +	}
> +	/*gpio interrupt trig type*/

> +	irq_set_irq_type(irq_num, IRQ_TYPE_EDGE_RISING);
> +	iio_trigger_set_drvdata(client_data->trig, indio_dev);
> +	client_data->trig->dev.parent = &client_data->client->dev;
> +	client_data->trig->ops = &bmg_trigger_ops;
> +	ret = iio_trigger_register(client_data->trig);
> +	 if (ret < 0) {
> +		dev_err(&indio_dev->dev, "bmg iio trigger failed to register.\n");
> +		goto erro_iio_trigger_register;
> +	 }
> +	 indio_dev->trig = client_data->trig;
> +
> +	 return 0;
> +
> +erro_iio_trigger_register:
> +	free_irq(gpio_to_irq(client_data->client->irq), client_data->trig);
> + error_irq_request:
> +	 iio_trigger_free(client_data->trig);
> + error_alloc_trigger:
> +	 return ret;
> +}
> +
> +void bmg_remove_trigger(struct iio_dev *indio_dev)
> +{
> +	struct bmg_client_data *client_data = iio_priv(indio_dev);
> +	iio_trigger_unregister(client_data->trig);
> +	free_irq(client_data->client->irq, client_data->trig);

There is now a devm managed allocator for triggers.  Please use it to simplify
this and the error paths above.

> +	iio_trigger_free(client_data->trig);
> +}
> +
> diff --git a/drivers/iio/gyro/bmg_iio.h b/drivers/iio/gyro/bmg_iio.h
> new file mode 100644
> index 0000000..010961f
> --- /dev/null
> +++ b/drivers/iio/gyro/bmg_iio.h
> @@ -0,0 +1,1371 @@
> +/*
> + * (C) Copyright 2013 Bosch Sensortec GmbH All Rights Reserved
> + *
> + * This software program is licensed subject to the GNU General Public License
> + * (GPL).Version 2,June 1991, available at http://www.fsf.org/copyleft/gpl.html
> + *
> + *	BMG160 IIO driver releated definition
> + */
> +
> +#ifndef __BMG_IIO_H__
> +#define __BMG_IIO_H__
> +
> +#include <linux/delay.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/i2c.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/buffer.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/iio/trigger.h>
> +#include <linux/iio/triggered_buffer.h>
> +#include <linux/iio/trigger_consumer.h>
> +
> +#ifdef __linux__
> +#define BMG160_U16 unsigned short       /* 16 bit achieved with short */
> +#define BMG160_S16 signed short
> +#define BMG160_S32 signed int           /* 32 bit achieved with int   */
> +#else
> +#include <linux/limits.h> /*needed to test integer limits */
> +
> +
As Joe pointed out, all this needs ripping out.  You are proposing we
merge this into the mainline linux kernel.  Types are pretty well
defined and predictable!

> +/* find correct data type for signed/unsigned 16 bit variables \
> +by checking max of unsigned variant */
> +#if USHRT_MAX == 0xFFFF
> +		/* 16 bit achieved with short */
> +		#define BMG160_U16 unsigned short
> +		#define BMG160_S16 signed short
> +#elif UINT_MAX == 0xFFFF
> +		/* 16 bit achieved with int */
> +		#define BMG160_U16 unsigned int
> +		#define BMG160_S16 signed int
> +#else
> +		#error BMG160_U16 and BMG160_S16 could not be
> +		#error defined automatically, please do so manually
> +#endif
> +
> +/* find correct data type for signed 32 bit variables */
> +#if INT_MAX == 0x7FFFFFFF
> +		/* 32 bit achieved with int */
> +		#define BMG160_S32 signed int
> +#elif LONG_MAX == 0x7FFFFFFF
> +		/* 32 bit achieved with long int */
> +		#define BMG160_S32 signed long int
> +#else
> +		#error BMG160_S32 could not be
> +		#error defined automatically, please do so manually
> +#endif
> +#endif
> +
> +/**\brief defines the calling parameter types of the BMG160_WR_FUNCTION */
> +#define BMG160_BUS_WR_RETURN_TYPE char
> +
> +/**\brief links the order of parameters defined in
> +BMG160_BUS_WR_PARAM_TYPE to function calls used inside the API*/
> +#define BMG160_BUS_WR_PARAM_TYPES unsigned char, unsigned char,\
> +unsigned char *, unsigned char
> +
> +/**\brief links the order of parameters defined in
> +BMG160_BUS_WR_PARAM_TYPE to function calls used inside the API*/
> +#define BMG160_BUS_WR_PARAM_ORDER(device_addr, register_addr,\
> +register_data, wr_len)
> +
> +/* never change this line */
> +#define BMG160_BUS_WRITE_FUNC(device_addr, register_addr,\
> +register_data, wr_len) bus_write(device_addr, register_addr,\
> +register_data, wr_len)
> +/**\brief defines the return parameter type of the BMG160_RD_FUNCTION
> +*/
> +#define BMG160_BUS_RD_RETURN_TYPE char
> +/**\brief defines the calling parameter types of the BMG160_RD_FUNCTION
> +*/
> +#define BMG160_BUS_RD_PARAM_TYPES unsigned char, unsigned char,\
> +unsigned char *, unsigned char
> +/**\brief links the order of parameters defined in \
> +BMG160_BUS_RD_PARAM_TYPE to function calls used inside the API
> +*/
> +#define BMG160_BUS_RD_PARAM_ORDER (device_addr, register_addr,\
> +register_data)
> +/* never change this line */
> +#define BMG160_BUS_READ_FUNC(device_addr, register_addr,\
> +register_data, rd_len)bus_read(device_addr, register_addr,\
> +register_data, rd_len)
> +/**\brief defines the return parameter type of the BMG160_RD_FUNCTION
> +*/
> +#define BMG160_BURST_RD_RETURN_TYPE char
> +/**\brief defines the calling parameter types of the BMG160_RD_FUNCTION
> +*/
> +#define BMG160_BURST_RD_PARAM_TYPES unsigned char,\
> +unsigned char, unsigned char *, signed int
> +/**\brief links the order of parameters defined in \
> +BMG160_BURST_RD_PARAM_TYPE to function calls used inside the API
> +*/
> +#define BMG160_BURST_RD_PARAM_ORDER (device_addr, register_addr,\
> +register_data)
Err?  I'm guessing this driver got written into a template.  You want
to rip out anything left from that in the next version!

In fact pretty much all fo this wants to go.
> +/* never change this line */
> +#define BMG160_BURST_READ_FUNC(device_addr, register_addr,\
> +register_data, rd_len)burst_read(device_addr, \
> +register_addr, register_data, rd_len)
> +/**\brief defines the return parameter type of the BMG160_DELAY_FUNCTION
> +*/

This lot all need to go in favour of using their actual types in the code.
> +#define BMG160_DELAY_RETURN_TYPE void
> +/**\brief defines the calling parameter types of the BMG160_DELAY_FUNCTION
> +*/
> +#define BMG160_DELAY_PARAM_TYPES BMG160_U16
> +/* never change this line */
> +#define BMG160_DELAY_FUNC(delay_in_msec)\
> +		delay_func(delay_in_msec)
> +#define BMG160_RETURN_FUNCTION_TYPE	int
> +/**< This refers BMG160 return type as char */
> +
These should come from outside the driver.
> +#define	BMG160_I2C_ADDR1				0x68
> +#define	BMG160_I2C_ADDR					BMG160_I2C_ADDR1
> +#define	BMG160_I2C_ADDR2				0x69
> +
> +
> +
> +/*Define of registers*/
> +
> +/* Hard Wired */
> +#define BMG160_CHIP_ID_ADDR						0x00
> +/**<Address of Chip ID Register*/
> +
All in all, this is a frightingly long and unweildy set of #defines
I've made a few suggestions to blugeon them into shape.
> +
> +/* Data Register */
> +#define BMG160_RATE_X_LSB_ADDR                   0x02
> +/**<        Address of X axis Rate LSB Register       */
> +#define BMG160_RATE_X_MSB_ADDR                   0x03
> +/**<        Address of X axis Rate MSB Register       */
> +#define BMG160_RATE_Y_LSB_ADDR                   0x04
> +/**<        Address of Y axis Rate LSB Register       */
> +#define BMG160_RATE_Y_MSB_ADDR                   0x05
> +/**<        Address of Y axis Rate MSB Register       */
> +#define BMG160_RATE_Z_LSB_ADDR                   0x06
> +/**<        Address of Z axis Rate LSB Register       */
> +#define BMG160_RATE_Z_MSB_ADDR                   0x07
> +/**<        Address of Z axis Rate MSB Register       */
> +#define BMG160_TEMP_ADDR                        0x08
> +/**<        Address of Temperature Data LSB Register  */
> +
> +/* Status Register */
> +#define BMG160_INT_STATUS0_ADDR                 0x09
> +/**<        Address of Interrupt status Register 0    */
> +#define BMG160_INT_STATUS1_ADDR                 0x0A
> +/**<        Address of Interrupt status Register 1    */
> +#define BMG160_INT_STATUS2_ADDR                 0x0B
> +/**<        Address of Interrupt status Register 2    */
> +#define BMG160_INT_STATUS3_ADDR                 0x0C
> +/**<        Address of Interrupt status Register 3    */
> +#define BMG160_FIFO_STATUS_ADDR                 0x0E
> +/**<        Address of FIFO status Register           */
> +
> +/* Control Register */
> +#define BMG160_RANGE_ADDR                  0x0F
> +/**<        Address of Range address Register     */
> +#define BMG160_BW_ADDR                     0x10
> +/**<        Address of Bandwidth Register         */
> +#define BMG160_MODE_LPM1_ADDR              0x11
> +/**<        Address of Mode LPM1 Register         */
> +#define BMG160_MODE_LPM2_ADDR              0x12
> +/**<        Address of Mode LPM2 Register         */
> +#define BMG160_RATED_HBW_ADDR              0x13
> +/**<        Address of Rate HBW Register          */
> +#define BMG160_BGW_SOFTRESET_ADDR          0x14
> +/**<        Address of BGW Softreset Register      */
> +#define BMG160_INT_ENABLE0_ADDR            0x15
> +/**<        Address of Interrupt Enable 0             */
> +#define BMG160_INT_ENABLE1_ADDR            0x16
> +/**<        Address of Interrupt Enable 1             */
> +#define BMG160_INT_MAP_0_ADDR              0x17
> +/**<        Address of Interrupt MAP 0                */
> +#define BMG160_INT_MAP_1_ADDR              0x18
> +/**<        Address of Interrupt MAP 1                */
> +#define BMG160_INT_MAP_2_ADDR              0x19
> +/**<        Address of Interrupt MAP 2                */
> +#define BMG160_INT_0_ADDR                  0x1A
> +/**<        Address of Interrupt 0 register   */
> +#define BMG160_INT_1_ADDR                  0x1B
> +/**<        Address of Interrupt 1 register   */
> +#define BMG160_INT_2_ADDR                  0x1C
> +/**<        Address of Interrupt 2 register   */
> +#define BMG160_INT_4_ADDR                  0x1E
> +/**<        Address of Interrupt 4 register   */
> +#define BMG160_RST_LATCH_ADDR              0x21
> +/**<        Address of Reset Latch Register           */
> +#define BMG160_HIGH_TH_X_ADDR              0x22
> +/**<        Address of High Th x Address register     */
> +#define BMG160_HIGH_DUR_X_ADDR             0x23
> +/**<        Address of High Dur x Address register    */
> +#define BMG160_HIGH_TH_Y_ADDR              0x24
> +/**<        Address of High Th y  Address register    */
> +#define BMG160_HIGH_DUR_Y_ADDR             0x25
> +/**<        Address of High Dur y Address register    */
> +#define BMG160_HIGH_TH_Z_ADDR              0x26
> +/**<        Address of High Th z Address register  */
> +#define BMG160_HIGH_DUR_Z_ADDR             0x27
> +/**<        Address of High Dur z Address register  */
> +#define BMG160_SOC_ADDR                        0x31
> +/**<        Address of SOC register        */
> +#define BMG160_A_FOC_ADDR                      0x32
> +/**<        Address of A_FOC Register        */
> +#define BMG160_TRIM_NVM_CTRL_ADDR          0x33
> +/**<        Address of Trim NVM control register      */
> +#define BMG160_BGW_SPI3_WDT_ADDR           0x34
> +/**<        Address of BGW SPI3,WDT Register           */
> +
> +
> +/* Trim Register */
> +#define BMG160_OFC1_ADDR                   0x36
> +/**<        Address of OFC1 Register          */
> +#define BMG160_OFC2_ADDR                       0x37
> +/**<        Address of OFC2 Register          */
> +#define BMG160_OFC3_ADDR                   0x38
> +/**<        Address of OFC3 Register          */
> +#define BMG160_OFC4_ADDR                   0x39
> +/**<        Address of OFC4 Register          */
> +#define BMG160_TRIM_GP0_ADDR               0x3A
> +/**<        Address of Trim GP0 Register              */
> +#define BMG160_TRIM_GP1_ADDR               0x3B
> +/**<        Address of Trim GP1 Register              */
> +#define BMG160_SELF_TEST_ADDR              0x3C
> +/**<        Address of BGW Selftest Register           */
> +
> +/* Control Register */
> +#define BMG160_FIFO_CGF1_ADDR              0x3D
> +/**<        Address of FIFO CGF0 Register             */
> +#define BMG160_FIFO_CGF0_ADDR              0x3E
> +
> +
> +/* Data Register */
> +#define BMG160_FIFO_DATA_ADDR              0x3F
> +
> +
> +/* Rate X LSB Register */
> +#define BMG160_RATE_X_LSB_VALUEX__POS        0
> +
> +/**< Last 8 bits of RateX LSB Registers */
> +#define BMG160_RATE_X_LSB_VALUEX__LEN        8
> +#define BMG160_RATE_X_LSB_VALUEX__MSK        0xFF
> +#define BMG160_RATE_X_LSB_VALUEX__REG        BMG160_RATE_X_LSB_ADDR
> +
> +/* Rate Y LSB Register */
> +/**<  Last 8 bits of RateY LSB Registers */
> +#define BMG160_RATE_Y_LSB_VALUEY__POS        0
> +#define BMG160_RATE_Y_LSB_VALUEY__LEN        8
> +#define BMG160_RATE_Y_LSB_VALUEY__MSK        0xFF
> +#define BMG160_RATE_Y_LSB_VALUEY__REG        BMG160_RATE_Y_LSB_ADDR
> +
> +/* Rate Z LSB Register */
> +/**< Last 8 bits of RateZ LSB Registers */
> +#define BMG160_RATE_Z_LSB_VALUEZ__POS        0
> +#define BMG160_RATE_Z_LSB_VALUEZ__LEN        8
> +#define BMG160_RATE_Z_LSB_VALUEZ__MSK        0xFF
> +#define BMG160_RATE_Z_LSB_VALUEZ__REG        BMG160_RATE_Z_LSB_ADDR
> +
> +/* Interrupt status 0 Register */
> +   /**< 2th bit of Interrupt status 0 register */
> +#define BMG160_INT_STATUS0_ANY_INT__POS     2
> +#define BMG160_INT_STATUS0_ANY_INT__LEN     1
> +#define BMG160_INT_STATUS0_ANY_INT__MSK     0x04
> +#define BMG160_INT_STATUS0_ANY_INT__REG     BMG160_INT_STATUS0_ADDR
> +
> +/**< 1st bit of Interrupt status 0 register */
> +#define BMG160_INT_STATUS0_HIGH_INT__POS    1
> +#define BMG160_INT_STATUS0_HIGH_INT__LEN    1
> +#define BMG160_INT_STATUS0_HIGH_INT__MSK    0x02
> +#define BMG160_INT_STATUS0_HIGH_INT__REG    BMG160_INT_STATUS0_ADDR
> +
> + /**< 1st and 2nd bit of Interrupt status 0 register */
> +#define BMG160_INT_STATUSZERO__POS    1
> +#define BMG160_INT_STATUSZERO__LEN    2
> +#define BMG160_INT_STATUSZERO__MSK    0x06
> +#define BMG160_INT_STATUSZERO__REG    BMG160_INT_STATUS0_ADDR
> +
> +/* Interrupt status 1 Register */
> +/**< 7th bit of Interrupt status 1 register */
> +#define BMG160_INT_STATUS1_DATA_INT__POS           7
> +#define BMG160_INT_STATUS1_DATA_INT__LEN           1
> +#define BMG160_INT_STATUS1_DATA_INT__MSK           0x80
> +#define BMG160_INT_STATUS1_DATA_INT__REG           BMG160_INT_STATUS1_ADDR
> +
> + /**< 6th bit of Interrupt status 1 register */
> +#define BMG160_INT_STATUS1_AUTO_OFFSET_INT__POS    6
> +#define BMG160_INT_STATUS1_AUTO_OFFSET_INT__LEN    1
> +#define BMG160_INT_STATUS1_AUTO_OFFSET_INT__MSK    0x40
> +#define BMG160_INT_STATUS1_AUTO_OFFSET_INT__REG    BMG160_INT_STATUS1_ADDR
> +
> +/**< 5th bit of Interrupt status 1 register */
> +#define BMG160_INT_STATUS1_FAST_OFFSET_INT__POS    5
> +#define BMG160_INT_STATUS1_FAST_OFFSET_INT__LEN    1
> +#define BMG160_INT_STATUS1_FAST_OFFSET_INT__MSK    0x20
> +#define BMG160_INT_STATUS1_FAST_OFFSET_INT__REG    BMG160_INT_STATUS1_ADDR
> +
> +/**< 4th bit of Interrupt status 1 register */
> +#define BMG160_INT_STATUS1_FIFO_INT__POS           4
> +#define BMG160_INT_STATUS1_FIFO_INT__LEN           1
> +#define BMG160_INT_STATUS1_FIFO_INT__MSK           0x10
> +#define BMG160_INT_STATUS1_FIFO_INT__REG           BMG160_INT_STATUS1_ADDR
> +
> +/**< MSB 4 bits of Interrupt status1 register */
> +#define BMG160_INT_STATUSONE__POS           4
> +#define BMG160_INT_STATUSONE__LEN           4
> +#define BMG160_INT_STATUSONE__MSK           0xF0
> +#define BMG160_INT_STATUSONE__REG           BMG160_INT_STATUS1_ADDR
> +
> +/* Interrupt status 2 Register */
> +/**< 3th bit of Interrupt status 2 register */
> +#define BMG160_INT_STATUS2_ANY_SIGN_INT__POS     3
> +#define BMG160_INT_STATUS2_ANY_SIGN_INT__LEN     1
> +#define BMG160_INT_STATUS2_ANY_SIGN_INT__MSK     0x08
> +#define BMG160_INT_STATUS2_ANY_SIGN_INT__REG     BMG160_INT_STATUS2_ADDR
> +
> +/**< 2th bit of Interrupt status 2 register */
> +#define BMG160_INT_STATUS2_ANY_FIRSTZ_INT__POS   2
> +#define BMG160_INT_STATUS2_ANY_FIRSTZ_INT__LEN   1
> +#define BMG160_INT_STATUS2_ANY_FIRSTZ_INT__MSK   0x04
> +#define BMG160_INT_STATUS2_ANY_FIRSTZ_INT__REG   BMG160_INT_STATUS2_ADDR
> +
> +/**< 1st bit of Interrupt status 2 register */
> +#define BMG160_INT_STATUS2_ANY_FIRSTY_INT__POS   1
> +#define BMG160_INT_STATUS2_ANY_FIRSTY_INT__LEN   1
> +#define BMG160_INT_STATUS2_ANY_FIRSTY_INT__MSK   0x02
> +#define BMG160_INT_STATUS2_ANY_FIRSTY_INT__REG   BMG160_INT_STATUS2_ADDR
> +
> +/**< 0th bit of Interrupt status 2 register */
> +#define BMG160_INT_STATUS2_ANY_FIRSTX_INT__POS   0
> +#define BMG160_INT_STATUS2_ANY_FIRSTX_INT__LEN   1
> +#define BMG160_INT_STATUS2_ANY_FIRSTX_INT__MSK   0x01
> +#define BMG160_INT_STATUS2_ANY_FIRSTX_INT__REG   BMG160_INT_STATUS2_ADDR
> +
> +/**< 4 bits of Interrupt status 2 register */
> +#define BMG160_INT_STATUSTWO__POS   0
> +#define BMG160_INT_STATUSTWO__LEN   4
> +#define BMG160_INT_STATUSTWO__MSK   0x0F
> +#define BMG160_INT_STATUSTWO__REG   BMG160_INT_STATUS2_ADDR
> +
> +/* Interrupt status 3 Register */
> +/**< 3th bit of Interrupt status 3 register */
> +#define BMG160_INT_STATUS3_HIGH_SIGN_INT__POS     3
> +#define BMG160_INT_STATUS3_HIGH_SIGN_INT__LEN     1
> +#define BMG160_INT_STATUS3_HIGH_SIGN_INT__MSK     0x08
> +#define BMG160_INT_STATUS3_HIGH_SIGN_INT__REG     BMG160_INT_STATUS3_ADDR
> +
> +/**< 2th bit of Interrupt status 3 register */
> +#define BMG160_INT_STATUS3_HIGH_FIRSTZ_INT__POS   2
> +#define BMG160_INT_STATUS3_HIGH_FIRSTZ_INT__LEN   1
> +#define BMG160_INT_STATUS3_HIGH_FIRSTZ_INT__MSK   0x04
> +#define BMG160_INT_STATUS3_HIGH_FIRSTZ_INT__REG  BMG160_INT_STATUS3_ADDR
> +
> +/**< 1st bit of Interrupt status 3 register */
> +#define BMG160_INT_STATUS3_HIGH_FIRSTY_INT__POS   1
> +#define BMG160_INT_STATUS3_HIGH_FIRSTY_INT__LEN   1
> +#define BMG160_INT_STATUS3_HIGH_FIRSTY_INT__MSK   0x02
> +#define BMG160_INT_STATUS3_HIGH_FIRSTY_INT__REG   BMG160_INT_STATUS3_ADDR
> +
> +/**< 0th bit of Interrupt status 3 register */
> +#define BMG160_INT_STATUS3_HIGH_FIRSTX_INT__POS   0
> +#define BMG160_INT_STATUS3_HIGH_FIRSTX_INT__LEN   1
> +#define BMG160_INT_STATUS3_HIGH_FIRSTX_INT__MSK   0x01
> +#define BMG160_INT_STATUS3_HIGH_FIRSTX_INT__REG   BMG160_INT_STATUS3_ADDR
> +
> +/**< LSB 4 bits of Interrupt status 3 register */
> +#define BMG160_INT_STATUSTHREE__POS   0
> +#define BMG160_INT_STATUSTHREE__LEN   4
> +#define BMG160_INT_STATUSTHREE__MSK   0x0F
> +#define BMG160_INT_STATUSTHREE__REG   BMG160_INT_STATUS3_ADDR
> +
> +/* BMG160 FIFO Status Register */
> +/**< 7th bit of FIFO status Register */
> +#define BMG160_FIFO_STATUS_OVERRUN__POS         7
> +#define BMG160_FIFO_STATUS_OVERRUN__LEN         1
> +#define BMG160_FIFO_STATUS_OVERRUN__MSK         0x80
> +#define BMG160_FIFO_STATUS_OVERRUN__REG         BMG160_FIFO_STATUS_ADDR
> +
> +/**< First 7 bits of FIFO status Register */
> +#define BMG160_FIFO_STATUS_FRAME_COUNTER__POS   0
> +#define BMG160_FIFO_STATUS_FRAME_COUNTER__LEN   7
> +#define BMG160_FIFO_STATUS_FRAME_COUNTER__MSK   0x7F
> +#define BMG160_FIFO_STATUS_FRAME_COUNTER__REG   BMG160_FIFO_STATUS_ADDR
> +
> +/**< First 3 bits of range Registers */
> +#define BMG160_RANGE_ADDR_RANGE__POS           0
> +#define BMG160_RANGE_ADDR_RANGE__LEN           3
> +#define BMG160_RANGE_ADDR_RANGE__MSK           0x07
> +#define BMG160_RANGE_ADDR_RANGE__REG           BMG160_RANGE_ADDR
> +
> +/**< Last bit of Bandwidth Registers */
> +#define BMG160_BW_ADDR_HIGH_RES__POS       7
> +#define BMG160_BW_ADDR_HIGH_RES__LEN       1
> +#define BMG160_BW_ADDR_HIGH_RES__MSK       0x80
> +#define BMG160_BW_ADDR_HIGH_RES__REG       BMG160_BW_ADDR
> +
> +/**< First 3 bits of Bandwidth Registers */
> +#define BMG160_BW_ADDR__POS             0
> +#define BMG160_BW_ADDR__LEN             3
> +#define BMG160_BW_ADDR__MSK             0x07
> +#define BMG160_BW_ADDR__REG             BMG160_BW_ADDR
> +
> +/**< 6th bit of Bandwidth Registers */
> +#define BMG160_BW_ADDR_IMG_STB__POS             6
> +#define BMG160_BW_ADDR_IMG_STB__LEN             1
> +#define BMG160_BW_ADDR_IMG_STB__MSK             0x40
> +#define BMG160_BW_ADDR_IMG_STB__REG             BMG160_BW_ADDR
> +
> +/**< 5th and 7th bit of LPM1 Register */
> +#define BMG160_MODE_LPM1__POS             5
> +#define BMG160_MODE_LPM1__LEN             3
> +#define BMG160_MODE_LPM1__MSK             0xA0
> +#define BMG160_MODE_LPM1__REG             BMG160_MODE_LPM1_ADDR
> +
> +/**< 1st to 3rd bit of LPM1 Register */
> +#define BMG160_MODELPM1_ADDR_SLEEPDUR__POS              1
> +#define BMG160_MODELPM1_ADDR_SLEEPDUR__LEN              3
> +#define BMG160_MODELPM1_ADDR_SLEEPDUR__MSK              0x0E
> +#define BMG160_MODELPM1_ADDR_SLEEPDUR__REG              BMG160_MODE_LPM1_ADDR
> +
> +/**< 7th bit of Mode LPM2 Register */
> +#define BMG160_MODE_LPM2_ADDR_FAST_POWERUP__POS         7
> +#define BMG160_MODE_LPM2_ADDR_FAST_POWERUP__LEN         1
> +#define BMG160_MODE_LPM2_ADDR_FAST_POWERUP__MSK         0x80
> +#define BMG160_MODE_LPM2_ADDR_FAST_POWERUP__REG         BMG160_MODE_LPM2_ADDR
> +
> +/**< 6th bit of Mode LPM2 Register */
> +#define BMG160_MODE_LPM2_ADDR_ADV_POWERSAVING__POS      6
> +#define BMG160_MODE_LPM2_ADDR_ADV_POWERSAVING__LEN      1
> +#define BMG160_MODE_LPM2_ADDR_ADV_POWERSAVING__MSK      0x40
> +#define BMG160_MODE_LPM2_ADDR_ADV_POWERSAVING__REG      BMG160_MODE_LPM2_ADDR
> +
> +/**< 4th & 5th bit of Mode LPM2 Register */
> +#define BMG160_MODE_LPM2_ADDR_EXT_TRI_SEL__POS          4
> +#define BMG160_MODE_LPM2_ADDR_EXT_TRI_SEL__LEN          2
> +#define BMG160_MODE_LPM2_ADDR_EXT_TRI_SEL__MSK          0x30
> +#define BMG160_MODE_LPM2_ADDR_EXT_TRI_SEL__REG          BMG160_MODE_LPM2_ADDR
> +
> +/**< 0th to 2nd bit of LPM2 Register */
> +#define BMG160_MODE_LPM2_ADDR_AUTOSLEEPDUR__POS  0
> +#define BMG160_MODE_LPM2_ADDR_AUTOSLEEPDUR__LEN  3
> +#define BMG160_MODE_LPM2_ADDR_AUTOSLEEPDUR__MSK  0x07
> +#define BMG160_MODE_LPM2_ADDR_AUTOSLEEPDUR__REG  BMG160_MODE_LPM2_ADDR
> +
> +/**< 7th bit of HBW Register */
> +#define BMG160_RATED_HBW_ADDR_DATA_HIGHBW__POS         7
> +#define BMG160_RATED_HBW_ADDR_DATA_HIGHBW__LEN         1
> +#define BMG160_RATED_HBW_ADDR_DATA_HIGHBW__MSK         0x80
> +#define BMG160_RATED_HBW_ADDR_DATA_HIGHBW__REG         BMG160_RATED_HBW_ADDR
> +
> +/**< 6th bit of HBW Register */
> +#define BMG160_RATED_HBW_ADDR_SHADOW_DIS__POS          6
> +#define BMG160_RATED_HBW_ADDR_SHADOW_DIS__LEN          1
> +#define BMG160_RATED_HBW_ADDR_SHADOW_DIS__MSK          0x40
> +#define BMG160_RATED_HBW_ADDR_SHADOW_DIS__REG          BMG160_RATED_HBW_ADDR
> +
> +/**< 7th bit of Interrupt Enable 0 Registers */
> +#define BMG160_INT_ENABLE0_DATAEN__POS               7
> +#define BMG160_INT_ENABLE0_DATAEN__LEN               1
> +#define BMG160_INT_ENABLE0_DATAEN__MSK               0x80
> +#define BMG160_INT_ENABLE0_DATAEN__REG               BMG160_INT_ENABLE0_ADDR
> +
> +/**< 6th bit of Interrupt Enable 0 Registers */
> +#define BMG160_INT_ENABLE0_FIFOEN__POS               6
> +#define BMG160_INT_ENABLE0_FIFOEN__LEN               1
> +#define BMG160_INT_ENABLE0_FIFOEN__MSK               0x40
> +#define BMG160_INT_ENABLE0_FIFOEN__REG               BMG160_INT_ENABLE0_ADDR
> +
> +/**< 2nd bit of Interrupt Enable 0 Registers */
> +#define BMG160_INT_ENABLE0_AUTO_OFFSETEN__POS        2
> +#define BMG160_INT_ENABLE0_AUTO_OFFSETEN__LEN        1
> +#define BMG160_INT_ENABLE0_AUTO_OFFSETEN__MSK        0x04
> +#define BMG160_INT_ENABLE0_AUTO_OFFSETEN__REG        BMG160_INT_ENABLE0_ADDR
> +
> +/**< 3rd bit of Interrupt Enable 1 Registers */
> +#define BMG160_INT_ENABLE1_IT2_OD__POS               3
> +#define BMG160_INT_ENABLE1_IT2_OD__LEN               1
> +#define BMG160_INT_ENABLE1_IT2_OD__MSK               0x08
> +#define BMG160_INT_ENABLE1_IT2_OD__REG               BMG160_INT_ENABLE1_ADDR
> +
> +/**< 2nd bit of Interrupt Enable 1 Registers */
> +#define BMG160_INT_ENABLE1_IT2_LVL__POS              2
> +#define BMG160_INT_ENABLE1_IT2_LVL__LEN              1
> +#define BMG160_INT_ENABLE1_IT2_LVL__MSK              0x04
> +#define BMG160_INT_ENABLE1_IT2_LVL__REG              BMG160_INT_ENABLE1_ADDR
> +
> +/**< 1st bit of Interrupt Enable 1 Registers */
> +#define BMG160_INT_ENABLE1_IT1_OD__POS               1
> +#define BMG160_INT_ENABLE1_IT1_OD__LEN               1
> +#define BMG160_INT_ENABLE1_IT1_OD__MSK               0x02
> +#define BMG160_INT_ENABLE1_IT1_OD__REG               BMG160_INT_ENABLE1_ADDR
> +
> +/**< 0th bit of Interrupt Enable 1 Registers */
> +#define BMG160_INT_ENABLE1_IT1_LVL__POS              0
> +#define BMG160_INT_ENABLE1_IT1_LVL__LEN              1
> +#define BMG160_INT_ENABLE1_IT1_LVL__MSK              0x01
> +#define BMG160_INT_ENABLE1_IT1_LVL__REG              BMG160_INT_ENABLE1_ADDR
> +
> +/**< 3rd bit of Interrupt MAP 0 Registers */
> +#define BMG160_INT_MAP_0_INT1_HIGH__POS            3
> +#define BMG160_INT_MAP_0_INT1_HIGH__LEN            1
> +#define BMG160_INT_MAP_0_INT1_HIGH__MSK            0x08
> +#define BMG160_INT_MAP_0_INT1_HIGH__REG            BMG160_INT_MAP_0_ADDR
> +
> +/**< 1st bit of Interrupt MAP 0 Registers */
> +#define BMG160_INT_MAP_0_INT1_ANY__POS             1
> +#define BMG160_INT_MAP_0_INT1_ANY__LEN             1
> +#define BMG160_INT_MAP_0_INT1_ANY__MSK             0x02
> +#define BMG160_INT_MAP_0_INT1_ANY__REG             BMG160_INT_MAP_0_ADDR
> +
> +/**< 7th bit of MAP_1Registers */
> +#define BMG160_MAP_1_INT2_DATA__POS                  7
> +#define BMG160_MAP_1_INT2_DATA__LEN                  1
> +#define BMG160_MAP_1_INT2_DATA__MSK                  0x80
> +#define BMG160_MAP_1_INT2_DATA__REG                  BMG160_INT_MAP_1_ADDR
> +
> +/**< 6th bit of MAP_1Registers */
> +#define BMG160_MAP_1_INT2_FAST_OFFSET__POS           6
> +#define BMG160_MAP_1_INT2_FAST_OFFSET__LEN           1
> +#define BMG160_MAP_1_INT2_FAST_OFFSET__MSK           0x40
> +#define BMG160_MAP_1_INT2_FAST_OFFSET__REG           BMG160_INT_MAP_1_ADDR
> +
> +/**< 5th bit of MAP_1Registers */
> +#define BMG160_MAP_1_INT2_FIFO__POS                  5
> +#define BMG160_MAP_1_INT2_FIFO__LEN                  1
> +#define BMG160_MAP_1_INT2_FIFO__MSK                  0x20
> +#define BMG160_MAP_1_INT2_FIFO__REG                  BMG160_INT_MAP_1_ADDR
> +
> +/**< 4th bit of MAP_1Registers */
> +#define BMG160_MAP_1_INT2_AUTO_OFFSET__POS           4
> +#define BMG160_MAP_1_INT2_AUTO_OFFSET__LEN           1
> +#define BMG160_MAP_1_INT2_AUTO_OFFSET__MSK           0x10
> +#define BMG160_MAP_1_INT2_AUTO_OFFSET__REG           BMG160_INT_MAP_1_ADDR
> +
> +/**< 3rd bit of MAP_1Registers */
> +#define BMG160_MAP_1_INT1_AUTO_OFFSET__POS           3
> +#define BMG160_MAP_1_INT1_AUTO_OFFSET__LEN           1
> +#define BMG160_MAP_1_INT1_AUTO_OFFSET__MSK           0x08
> +#define BMG160_MAP_1_INT1_AUTO_OFFSET__REG           BMG160_INT_MAP_1_ADDR
> +
> +/**< 2nd bit of MAP_1Registers */
> +#define BMG160_MAP_1_INT1_FIFO__POS                  2
> +#define BMG160_MAP_1_INT1_FIFO__LEN                  1
> +#define BMG160_MAP_1_INT1_FIFO__MSK                  0x04
> +#define BMG160_MAP_1_INT1_FIFO__REG                  BMG160_INT_MAP_1_ADDR
> +
> +/**< 1st bit of MAP_1Registers */
> +#define BMG160_MAP_1_INT1_FAST_OFFSET__POS           1
> +#define BMG160_MAP_1_INT1_FAST_OFFSET__LEN           1
> +#define BMG160_MAP_1_INT1_FAST_OFFSET__MSK           0x02
> +#define BMG160_MAP_1_INT1_FAST_OFFSET__REG           BMG160_INT_MAP_1_ADDR
> +
> +/**< 0th bit of MAP_1Registers */
> +#define BMG160_MAP_1_INT1_DATA__POS                  0
> +#define BMG160_MAP_1_INT1_DATA__LEN                  1
> +#define BMG160_MAP_1_INT1_DATA__MSK                  0x01
> +#define BMG160_MAP_1_INT1_DATA__REG                  BMG160_INT_MAP_1_ADDR
> +
> +/**< 3rd bit of Interrupt Map 2 Registers */
> +#define BMG160_INT_MAP_2_INT2_HIGH__POS            3
> +#define BMG160_INT_MAP_2_INT2_HIGH__LEN            1
> +#define BMG160_INT_MAP_2_INT2_HIGH__MSK            0x08
> +#define BMG160_INT_MAP_2_INT2_HIGH__REG            BMG160_INT_MAP_2_ADDR
> +
> +/**< 1st bit of Interrupt Map 2 Registers */
> +#define BMG160_INT_MAP_2_INT2_ANY__POS             1
> +#define BMG160_INT_MAP_2_INT2_ANY__LEN             1
> +#define BMG160_INT_MAP_2_INT2_ANY__MSK             0x02
> +#define BMG160_INT_MAP_2_INT2_ANY__REG             BMG160_INT_MAP_2_ADDR
> +
> +/**< 5th bit of Interrupt 0 Registers */
> +#define BMG160_INT_0_ADDR_SLOW_OFFSET_UNFILT__POS          5
> +#define BMG160_INT_0_ADDR_SLOW_OFFSET_UNFILT__LEN          1
> +#define BMG160_INT_0_ADDR_SLOW_OFFSET_UNFILT__MSK          0x20
> +#define BMG160_INT_0_ADDR_SLOW_OFFSET_UNFILT__REG          BMG160_INT_0_ADDR
> +
> +/**< 3rd bit of Interrupt 0 Registers */
> +#define BMG160_INT_0_ADDR_HIGH_UNFILT_DATA__POS            3
> +#define BMG160_INT_0_ADDR_HIGH_UNFILT_DATA__LEN            1
> +#define BMG160_INT_0_ADDR_HIGH_UNFILT_DATA__MSK            0x08
> +#define BMG160_INT_0_ADDR_HIGH_UNFILT_DATA__REG            BMG160_INT_0_ADDR
> +
> +/**< 1st bit of Interrupt 0 Registers */
> +#define BMG160_INT_0_ADDR_ANY_UNFILT_DATA__POS             1
> +#define BMG160_INT_0_ADDR_ANY_UNFILT_DATA__LEN             1
> +#define BMG160_INT_0_ADDR_ANY_UNFILT_DATA__MSK             0x02
> +#define BMG160_INT_0_ADDR_ANY_UNFILT_DATA__REG             BMG160_INT_0_ADDR
> +
> +/**< 7th bit of INT_1  Registers */
> +#define BMG160_INT_1_ADDR_FAST_OFFSET_UNFILT__POS            7
> +#define BMG160_INT_1_ADDR_FAST_OFFSET_UNFILT__LEN            1
> +#define BMG160_INT_1_ADDR_FAST_OFFSET_UNFILT__MSK            0x80
> +#define BMG160_INT_1_ADDR_FAST_OFFSET_UNFILT__REG            BMG160_INT_1_ADDR
> +
> +/**< First 7 bits of INT_1  Registers */
> +#define BMG160_INT_1_ADDR_ANY_TH__POS                       0
> +#define BMG160_INT_1_ADDR_ANY_TH__LEN                       7
> +#define BMG160_INT_1_ADDR_ANY_TH__MSK                       0x7F
> +#define BMG160_INT_1_ADDR_ANY_TH__REG                       BMG160_INT_1_ADDR
> +
> +/**< Last 2 bits of INT 2Registers */
> +#define BMG160_INT_2_ADDR_AWAKE_DUR__POS          6
> +#define BMG160_INT_2_ADDR_AWAKE_DUR__LEN          2
> +#define BMG160_INT_2_ADDR_AWAKE_DUR__MSK          0xC0
> +#define BMG160_INT_2_ADDR_AWAKE_DUR__REG          BMG160_INT_2_ADDR
> +
> +/**< 4th & 5th bit of INT 2Registers */
> +#define BMG160_INT_2_ADDR_ANY_DURSAMPLE__POS      4
> +#define BMG160_INT_2_ADDR_ANY_DURSAMPLE__LEN      2
> +#define BMG160_INT_2_ADDR_ANY_DURSAMPLE__MSK      0x30
> +#define BMG160_INT_2_ADDR_ANY_DURSAMPLE__REG      BMG160_INT_2_ADDR
> +
> +/**< 2nd bit of INT 2Registers */
> +#define BMG160_INT_2_ADDR_ANY_EN_Z__POS           2
> +#define BMG160_INT_2_ADDR_ANY_EN_Z__LEN           1
> +#define BMG160_INT_2_ADDR_ANY_EN_Z__MSK           0x04
> +#define BMG160_INT_2_ADDR_ANY_EN_Z__REG           BMG160_INT_2_ADDR
> +
> +/**< 1st bit of INT 2Registers */
> +#define BMG160_INT_2_ADDR_ANY_EN_Y__POS           1
> +#define BMG160_INT_2_ADDR_ANY_EN_Y__LEN           1
> +#define BMG160_INT_2_ADDR_ANY_EN_Y__MSK           0x02
> +#define BMG160_INT_2_ADDR_ANY_EN_Y__REG           BMG160_INT_2_ADDR
> +
> +/**< 0th bit of INT 2Registers */
> +#define BMG160_INT_2_ADDR_ANY_EN_X__POS           0
> +#define BMG160_INT_2_ADDR_ANY_EN_X__LEN           1
> +#define BMG160_INT_2_ADDR_ANY_EN_X__MSK           0x01
> +#define BMG160_INT_2_ADDR_ANY_EN_X__REG           BMG160_INT_2_ADDR
> +
> +/**< Last bit of INT 4 Registers */
> +#define BMG160_INT_4_FIFO_WM_EN__POS           7
> +#define BMG160_INT_4_FIFO_WM_EN__LEN           1
> +#define BMG160_INT_4_FIFO_WM_EN__MSK           0x80
> +#define BMG160_INT_4_FIFO_WM_EN__REG           BMG160_INT_4_ADDR
> +
> +/**< Last bit of Reset Latch Registers */
> +#define BMG160_RST_LATCH_ADDR_RESET_INT__POS           7
> +#define BMG160_RST_LATCH_ADDR_RESET_INT__LEN           1
> +#define BMG160_RST_LATCH_ADDR_RESET_INT__MSK           0x80
> +#define BMG160_RST_LATCH_ADDR_RESET_INT__REG           BMG160_RST_LATCH_ADDR
> +
> +/**< 6th bit of Reset Latch Registers */
> +#define BMG160_RST_LATCH_ADDR_OFFSET_RESET__POS        6
> +#define BMG160_RST_LATCH_ADDR_OFFSET_RESET__LEN        1
> +#define BMG160_RST_LATCH_ADDR_OFFSET_RESET__MSK        0x40
> +#define BMG160_RST_LATCH_ADDR_OFFSET_RESET__REG        BMG160_RST_LATCH_ADDR
> +
> +/**< 4th bit of Reset Latch Registers */
> +#define BMG160_RST_LATCH_ADDR_LATCH_STATUS__POS        4
> +#define BMG160_RST_LATCH_ADDR_LATCH_STATUS__LEN        1
> +#define BMG160_RST_LATCH_ADDR_LATCH_STATUS__MSK        0x10
> +#define BMG160_RST_LATCH_ADDR_LATCH_STATUS__REG        BMG160_RST_LATCH_ADDR
> +
> +/**< First 4 bits of Reset Latch Registers */
> +#define BMG160_RST_LATCH_ADDR_LATCH_INT__POS           0
> +#define BMG160_RST_LATCH_ADDR_LATCH_INT__LEN           4
> +#define BMG160_RST_LATCH_ADDR_LATCH_INT__MSK           0x0F
> +#define BMG160_RST_LATCH_ADDR_LATCH_INT__REG           BMG160_RST_LATCH_ADDR
> +
> +/**< Last 2 bits of HIGH_TH_X Registers */
> +#define BMG160_HIGH_HY_X__POS        6
> +#define BMG160_HIGH_HY_X__LEN        2
> +#define BMG160_HIGH_HY_X__MSK        0xC0
> +#define BMG160_HIGH_HY_X__REG        BMG160_HIGH_TH_X_ADDR
> +
> +/**< 5 bits of HIGH_TH_X Registers */
> +#define BMG160_HIGH_TH_X__POS        1
> +#define BMG160_HIGH_TH_X__LEN        5
> +#define BMG160_HIGH_TH_X__MSK        0x3E
> +#define BMG160_HIGH_TH_X__REG        BMG160_HIGH_TH_X_ADDR
> +
> +/**< 0th bit of HIGH_TH_X Registers */
> +#define BMG160_HIGH_EN_X__POS        0
> +#define BMG160_HIGH_EN_X__LEN        1
> +#define BMG160_HIGH_EN_X__MSK        0x01
> +#define BMG160_HIGH_EN_X__REG        BMG160_HIGH_TH_X_ADDR
> +
> +/**< Last 2 bits of HIGH_TH_Y Registers */
> +#define BMG160_HIGH_HY_Y__POS        6
> +#define BMG160_HIGH_HY_Y__LEN        2
> +#define BMG160_HIGH_HY_Y__MSK        0xC0
> +#define BMG160_HIGH_HY_Y__REG        BMG160_HIGH_TH_Y_ADDR
> +
> +/**< 5 bits of HIGH_TH_Y Registers */
> +#define BMG160_HIGH_TH_Y__POS        1
> +#define BMG160_HIGH_TH_Y__LEN        5
> +#define BMG160_HIGH_TH_Y__MSK        0x3E
> +#define BMG160_HIGH_TH_Y__REG        BMG160_HIGH_TH_Y_ADDR
> +
> +/**< 0th bit of HIGH_TH_Y Registers */
> +#define BMG160_HIGH_EN_Y__POS        0
> +#define BMG160_HIGH_EN_Y__LEN        1
> +#define BMG160_HIGH_EN_Y__MSK        0x01
> +#define BMG160_HIGH_EN_Y__REG        BMG160_HIGH_TH_Y_ADDR
> +
> +/**< Last 2 bits of HIGH_TH_Z Registers */
> +#define BMG160_HIGH_HY_Z__POS        6
> +#define BMG160_HIGH_HY_Z__LEN        2
> +#define BMG160_HIGH_HY_Z__MSK        0xC0
> +#define BMG160_HIGH_HY_Z__REG        BMG160_HIGH_TH_Z_ADDR
> +
> +/**< 5 bits of HIGH_TH_Z Registers */
> +#define BMG160_HIGH_TH_Z__POS        1
> +#define BMG160_HIGH_TH_Z__LEN        5
> +#define BMG160_HIGH_TH_Z__MSK        0x3E
> +#define BMG160_HIGH_TH_Z__REG        BMG160_HIGH_TH_Z_ADDR
> +
> +/**< 0th bit of HIGH_TH_Z Registers */
> +#define BMG160_HIGH_EN_Z__POS        0
> +#define BMG160_HIGH_EN_Z__LEN        1
> +#define BMG160_HIGH_EN_Z__MSK        0x01
> +#define BMG160_HIGH_EN_Z__REG        BMG160_HIGH_TH_Z_ADDR
> +
> +/**< Last 3 bits of INT OFF0 Registers */
> +#define BMG160_SLOW_OFFSET_TH__POS          6
> +#define BMG160_SLOW_OFFSET_TH__LEN          2
> +#define BMG160_SLOW_OFFSET_TH__MSK          0xC0
> +#define BMG160_SLOW_OFFSET_TH__REG          BMG160_SOC_ADDR
> +
> +/**< 2  bits of INT OFF0 Registers */
> +#define BMG160_SLOW_OFFSET_DUR__POS         3
> +#define BMG160_SLOW_OFFSET_DUR__LEN         3
> +#define BMG160_SLOW_OFFSET_DUR__MSK         0x38
> +#define BMG160_SLOW_OFFSET_DUR__REG         BMG160_SOC_ADDR
> +
> +/**< 2nd bit of INT OFF0 Registers */
> +#define BMG160_SLOW_OFFSET_EN_Z__POS        2
> +#define BMG160_SLOW_OFFSET_EN_Z__LEN        1
> +#define BMG160_SLOW_OFFSET_EN_Z__MSK        0x04
> +#define BMG160_SLOW_OFFSET_EN_Z__REG        BMG160_SOC_ADDR
> +
> +/**< 1st bit of INT OFF0 Registers */
> +#define BMG160_SLOW_OFFSET_EN_Y__POS        1
> +#define BMG160_SLOW_OFFSET_EN_Y__LEN        1
> +#define BMG160_SLOW_OFFSET_EN_Y__MSK        0x02
> +#define BMG160_SLOW_OFFSET_EN_Y__REG        BMG160_SOC_ADDR
> +
> +/**< 0th bit of INT OFF0 Registers */
> +#define BMG160_SLOW_OFFSET_EN_X__POS        0
> +#define BMG160_SLOW_OFFSET_EN_X__LEN        1
> +#define BMG160_SLOW_OFFSET_EN_X__MSK        0x01
> +#define BMG160_SLOW_OFFSET_EN_X__REG        BMG160_SOC_ADDR
> +
> +/**< Last 2 bits of INT OFF1 Registers */
> +#define BMG160_AUTO_OFFSET_WL__POS        6
> +#define BMG160_AUTO_OFFSET_WL__LEN        2
> +#define BMG160_AUTO_OFFSET_WL__MSK        0xC0
> +#define BMG160_AUTO_OFFSET_WL__REG        BMG160_A_FOC_ADDR
> +
> +/**< 2  bits of INT OFF1 Registers */
> +#define BMG160_FAST_OFFSET_WL__POS        4
> +#define BMG160_FAST_OFFSET_WL__LEN        2
> +#define BMG160_FAST_OFFSET_WL__MSK        0x30
> +#define BMG160_FAST_OFFSET_WL__REG        BMG160_A_FOC_ADDR
> +
> +/**< 3nd bit of INT OFF1 Registers */
> +#define BMG160_FAST_OFFSET_EN__POS        3
> +#define BMG160_FAST_OFFSET_EN__LEN        1
> +#define BMG160_FAST_OFFSET_EN__MSK        0x08
> +#define BMG160_FAST_OFFSET_EN__REG        BMG160_A_FOC_ADDR
> +
> +/**< 2nd bit of INT OFF1 Registers */
> +#define BMG160_FAST_OFFSET_EN_Z__POS      2
> +#define BMG160_FAST_OFFSET_EN_Z__LEN      1
> +#define BMG160_FAST_OFFSET_EN_Z__MSK      0x04
> +#define BMG160_FAST_OFFSET_EN_Z__REG      BMG160_A_FOC_ADDR
> +
> +/**< 1st bit of INT OFF1 Registers */
> +#define BMG160_FAST_OFFSET_EN_Y__POS      1
> +#define BMG160_FAST_OFFSET_EN_Y__LEN      1
> +#define BMG160_FAST_OFFSET_EN_Y__MSK      0x02
> +#define BMG160_FAST_OFFSET_EN_Y__REG      BMG160_A_FOC_ADDR
> +
> +/**< 0th bit of INT OFF1 Registers */
> +#define BMG160_FAST_OFFSET_EN_X__POS      0
> +#define BMG160_FAST_OFFSET_EN_X__LEN      1
> +#define BMG160_FAST_OFFSET_EN_X__MSK      0x01
> +#define BMG160_FAST_OFFSET_EN_X__REG      BMG160_A_FOC_ADDR
> +
This comment is another obvious one that wants to go.
> +/**< 0 to 2 bits of INT OFF1 Registers */
> +#define BMG160_FAST_OFFSET_EN_XYZ__POS      0
> +#define BMG160_FAST_OFFSET_EN_XYZ__LEN      3
> +#define BMG160_FAST_OFFSET_EN_XYZ__MSK      0x07
> +#define BMG160_FAST_OFFSET_EN_XYZ__REG      BMG160_A_FOC_ADDR
> +
> +/**< Last 4 bits of Trim NVM control Registers */
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_REMAIN__POS        4
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_REMAIN__LEN        4
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_REMAIN__MSK        0xF0
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_REMAIN__REG        \
> +BMG160_TRIM_NVM_CTRL_ADDR
> +
> +/**< 3rd bit of Trim NVM control Registers */
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_LOAD__POS          3
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_LOAD__LEN          1
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_LOAD__MSK          0x08
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_LOAD__REG          \
> +BMG160_TRIM_NVM_CTRL_ADDR
> +
> +/**< 2nd bit of Trim NVM control Registers */
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_RDY__POS           2
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_RDY__LEN           1
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_RDY__MSK           0x04
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_RDY__REG           \
> +BMG160_TRIM_NVM_CTRL_ADDR
> +
> + /**< 1st bit of Trim NVM control Registers */
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_PROG_TRIG__POS     1
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_PROG_TRIG__LEN     1
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_PROG_TRIG__MSK     0x02
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_PROG_TRIG__REG     \
> +BMG160_TRIM_NVM_CTRL_ADDR
> +
> +/**< 0th bit of Trim NVM control Registers */
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_PROG_MODE__POS     0
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_PROG_MODE__LEN     1
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_PROG_MODE__MSK     0x01
> +#define BMG160_TRIM_NVM_CTRL_ADDR_NVM_PROG_MODE__REG     \
> +BMG160_TRIM_NVM_CTRL_ADDR
> +
> + /**< 2nd bit of SPI3 WDT Registers */
> +#define BMG160_BGW_SPI3_WDT_ADDR_I2C_WDT_EN__POS      2
> +#define BMG160_BGW_SPI3_WDT_ADDR_I2C_WDT_EN__LEN      1
> +#define BMG160_BGW_SPI3_WDT_ADDR_I2C_WDT_EN__MSK      0x04
> +#define BMG160_BGW_SPI3_WDT_ADDR_I2C_WDT_EN__REG      \
> +BMG160_BGW_SPI3_WDT_ADDR
> +
> + /**< 1st bit of SPI3 WDT Registers */
> +#define BMG160_BGW_SPI3_WDT_ADDR_I2C_WDT_SEL__POS     1
> +#define BMG160_BGW_SPI3_WDT_ADDR_I2C_WDT_SEL__LEN     1
> +#define BMG160_BGW_SPI3_WDT_ADDR_I2C_WDT_SEL__MSK     0x02
> +#define BMG160_BGW_SPI3_WDT_ADDR_I2C_WDT_SEL__REG     \
> +BMG160_BGW_SPI3_WDT_ADDR
> +
> +/**< 0th bit of SPI3 WDT Registers */
> +#define BMG160_BGW_SPI3_WDT_ADDR_SPI3__POS            0
> +#define BMG160_BGW_SPI3_WDT_ADDR_SPI3__LEN            1
> +#define BMG160_BGW_SPI3_WDT_ADDR_SPI3__MSK            0x01
> +#define BMG160_BGW_SPI3_WDT_ADDR_SPI3__REG            \
> +BMG160_BGW_SPI3_WDT_ADDR
> +
> +/**< 4th bit of Self test Registers */
> +#define BMG160_SELF_TEST_ADDR_RATEOK__POS            4
> +#define BMG160_SELF_TEST_ADDR_RATEOK__LEN            1
> +#define BMG160_SELF_TEST_ADDR_RATEOK__MSK            0x10
> +#define BMG160_SELF_TEST_ADDR_RATEOK__REG            \
> +BMG160_SELF_TEST_ADDR
> +
> +/**< 2nd bit of Self test Registers */
> +#define BMG160_SELF_TEST_ADDR_BISTFAIL__POS          2
> +#define BMG160_SELF_TEST_ADDR_BISTFAIL__LEN          1
> +#define BMG160_SELF_TEST_ADDR_BISTFAIL__MSK          0x04
> +#define BMG160_SELF_TEST_ADDR_BISTFAIL__REG          \
> +BMG160_SELF_TEST_ADDR
> +
> +/**< 1st bit of Self test Registers */
> +#define BMG160_SELF_TEST_ADDR_BISTRDY__POS           1
> +#define BMG160_SELF_TEST_ADDR_BISTRDY__LEN           1
> +#define BMG160_SELF_TEST_ADDR_BISTRDY__MSK           0x02
> +#define BMG160_SELF_TEST_ADDR_BISTRDY__REG           \
> +BMG160_SELF_TEST_ADDR
> +
> +/**< 0th bit of Self test Registers */
> +#define BMG160_SELF_TEST_ADDR_TRIGBIST__POS          0
> +#define BMG160_SELF_TEST_ADDR_TRIGBIST__LEN          1
> +#define BMG160_SELF_TEST_ADDR_TRIGBIST__MSK          0x01
> +#define BMG160_SELF_TEST_ADDR_TRIGBIST__REG          \
> +BMG160_SELF_TEST_ADDR
> +
> +/**< 7th bit of FIFO CGF1 Registers */
> +#define BMG160_FIFO_CGF1_ADDR_TAG__POS     7
> +#define BMG160_FIFO_CGF1_ADDR_TAG__LEN     1
> +#define BMG160_FIFO_CGF1_ADDR_TAG__MSK     0x80
> +#define BMG160_FIFO_CGF1_ADDR_TAG__REG     BMG160_FIFO_CGF1_ADDR
> +
> +/**< First 7 bits of FIFO CGF1 Registers */
> +#define BMG160_FIFO_CGF1_ADDR_WML__POS     0
> +#define BMG160_FIFO_CGF1_ADDR_WML__LEN     7
> +#define BMG160_FIFO_CGF1_ADDR_WML__MSK     0x7F
> +#define BMG160_FIFO_CGF1_ADDR_WML__REG     BMG160_FIFO_CGF1_ADDR
> +
> +/**< Last 2 bits of FIFO CGF0 Addr Registers */
> +#define BMG160_FIFO_CGF0_ADDR_MODE__POS         6
> +#define BMG160_FIFO_CGF0_ADDR_MODE__LEN         2
> +#define BMG160_FIFO_CGF0_ADDR_MODE__MSK         0xC0
> +#define BMG160_FIFO_CGF0_ADDR_MODE__REG         BMG160_FIFO_CGF0_ADDR
> +
> +/**< First 2 bits of FIFO CGF0 Addr Registers */
> +#define BMG160_FIFO_CGF0_ADDR_DATA_SEL__POS     0
> +#define BMG160_FIFO_CGF0_ADDR_DATA_SEL__LEN     2
> +#define BMG160_FIFO_CGF0_ADDR_DATA_SEL__MSK     0x03
> +#define BMG160_FIFO_CGF0_ADDR_DATA_SEL__REG     BMG160_FIFO_CGF0_ADDR
> +
> + /**< Last 2 bits of INL Offset MSB Registers */
> +#define BMG160_OFC1_ADDR_OFFSET_X__POS       6
> +#define BMG160_OFC1_ADDR_OFFSET_X__LEN       2
> +#define BMG160_OFC1_ADDR_OFFSET_X__MSK       0xC0
> +#define BMG160_OFC1_ADDR_OFFSET_X__REG       BMG160_OFC1_ADDR
> +
> +/**< 3 bits of INL Offset MSB Registers */
> +#define BMG160_OFC1_ADDR_OFFSET_Y__POS       3
> +#define BMG160_OFC1_ADDR_OFFSET_Y__LEN       3
> +#define BMG160_OFC1_ADDR_OFFSET_Y__MSK       0x38
> +#define BMG160_OFC1_ADDR_OFFSET_Y__REG       BMG160_OFC1_ADDR
> +
> +/**< First 3 bits of INL Offset MSB Registers */
> +#define BMG160_OFC1_ADDR_OFFSET_Z__POS       0
> +#define BMG160_OFC1_ADDR_OFFSET_Z__LEN       3
> +#define BMG160_OFC1_ADDR_OFFSET_Z__MSK       0x07
> +#define BMG160_OFC1_ADDR_OFFSET_Z__REG       BMG160_OFC1_ADDR
> +
> +/**< 4 bits of Trim GP0 Registers */
> +#define BMG160_TRIM_GP0_ADDR_GP0__POS            4
> +#define BMG160_TRIM_GP0_ADDR_GP0__LEN            4
> +#define BMG160_TRIM_GP0_ADDR_GP0__MSK            0xF0
The naming of this next #define kind of already tells you waht the
value will be.  Whenever that happens you might as well just use the
value.  Hence replace all BMG160_TRIM_GP0_ADDR_*__REG with BM160_TRIM_GP0_ADDR
and drop all the dfine.   Clearly you want to do this for all the similar
cases above.

There is a lot of repeated information in these defines as well.
For example, the pos and len are both apparent from the msk in all cases
that I can see.  You could if you want to do this use standard funcitons
to find the offset and the length from that.  They 'should' be complied
out to the same you have here.  (Not entirely sure this is a good idea though)

> +#define BMG160_TRIM_GP0_ADDR_GP0__REG            BMG160_TRIM_GP0_ADDR
> +
> +/**< 2 bits of Trim GP0 Registers */
> +#define BMG160_TRIM_GP0_ADDR_OFFSET_X__POS       2
> +#define BMG160_TRIM_GP0_ADDR_OFFSET_X__LEN       2
> +#define BMG160_TRIM_GP0_ADDR_OFFSET_X__MSK       0x0C
> +#define BMG160_TRIM_GP0_ADDR_OFFSET_X__REG       BMG160_TRIM_GP0_ADDR
> +
> +/**< 1st bit of Trim GP0 Registers */
> +#define BMG160_TRIM_GP0_ADDR_OFFSET_Y__POS       1
> +#define BMG160_TRIM_GP0_ADDR_OFFSET_Y__LEN       1
> +#define BMG160_TRIM_GP0_ADDR_OFFSET_Y__MSK       0x02
> +#define BMG160_TRIM_GP0_ADDR_OFFSET_Y__REG       BMG160_TRIM_GP0_ADDR
> +
> +/**< First bit of Trim GP0 Registers */
Note this comment syntax does not meet the kernel style.
/* First bit of Trim GP0 Registers */
> +#define BMG160_TRIM_GP0_ADDR_OFFSET_Z__POS       0
> +#define BMG160_TRIM_GP0_ADDR_OFFSET_Z__LEN       1
> +#define BMG160_TRIM_GP0_ADDR_OFFSET_Z__MSK       0x01
> +#define BMG160_TRIM_GP0_ADDR_OFFSET_Z__REG       BMG160_TRIM_GP0_ADDR
> +
> +
> +/* For Axis Selection   */
> +/**< It refers BMG160 X-axis */
Another case of the somewhat obvious comment given that
the name is already perfectly clear!
> +#define BMG160_X_AXIS           0
> +/**< It refers BMG160 Y-axis */
> +#define BMG160_Y_AXIS           1
> +/**< It refers BMG160 Z-axis */
> +#define BMG160_Z_AXIS           2
> +
> +/* For Mode Settings    */
> +#define BMG160_MODE_NORMAL              0
> +#define BMG160_MODE_DEEPSUSPEND         1
> +#define BMG160_MODE_SUSPEND             2
> +#define BMG160_MODE_FASTPOWERUP			3
> +#define BMG160_MODE_ADVANCEDPOWERSAVING 4
> +
> +/* get bit slice  */
> +#define BMG160_GET_BITSLIC(Eregvar, bitname)\
> +((regvar & bitname##__MSK) >> bitname##__POS)
> +
> +/* Set bit slice */
> +#define BMG160_SET_BITSLICE(regvar, bitname, val)\
> +((regvar&~bitname##__MSK)|((val<<bitname##__POS)&bitname##__MSK))
This macro is hard to folow and I suspect makes the code less readable
rather than improving it.  Please just do the explicit masking where this
is used.  Might be a line or two more code, but it will be easier to
read which is more important.


> +/* Constants */
> +
> +#define BMG160_NULL                             0
> +/**< constant declaration of NULL */
> +#define BMG160_DISABLE                          0
> +/**< It refers BMG160 disable */
> +#define BMG160_ENABLE                           1
> +/**< It refers BMG160 enable */
> +#define BMG160_OFF                              0
> +/**< It refers BMG160 OFF state */
> +#define BMG160_ON                               1
> +/**< It refers BMG160 ON state  */
> +
> +
> +#define BMG160_TURN1                            0
> +/**< It refers BMG160 TURN1 */
> +#define BMG160_TURN2                            1
> +/**< It refers BMG160 TURN2 */
> +
> +#define BMG160_INT1                             0
> +/**< It refers BMG160 INT1 */
> +#define BMG160_INT2                             1
> +/**< It refers BMG160 INT2 */
> +
> +#define BMG160_SLOW_OFFSET                      0
> +/**< It refers BMG160 Slow Offset */
The names are pretty self explanatory which is good.
So drop all all these explaining comments.
> +#define BMG160_AUTO_OFFSET                      1
> +/**< It refers BMG160 Auto Offset */
> +#define BMG160_FAST_OFFSET                      2
> +/**< It refers BMG160 Fast Offset */
> +#define BMG160_S_TAP                            0
> +/**< It refers BMG160 Single Tap */
> +#define BMG160_D_TAP                            1
> +/**< It refers BMG160 Double Tap */
> +#define BMG160_INT1_DATA                        0
> +/**< It refers BMG160 Int1 Data */
> +#define BMG160_INT2_DATA                        1
> +/**< It refers BMG160 Int2 Data */
> +#define BMG160_TAP_UNFILT_DATA                   0
> +/**< It refers BMG160 Tap unfilt data */
> +#define BMG160_HIGH_UNFILT_DATA                  1
> +/**< It refers BMG160 High unfilt data */
> +#define BMG160_CONST_UNFILT_DATA                 2
> +/**< It refers BMG160 Const unfilt data */
> +#define BMG160_ANY_UNFILT_DATA                   3
> +/**< It refers BMG160 Any unfilt data */
> +#define BMG160_SHAKE_UNFILT_DATA                 4
> +/**< It refers BMG160 Shake unfilt data */
> +#define BMG160_SHAKE_TH                         0
> +/**< It refers BMG160 Shake Threshold */
> +#define BMG160_SHAKE_TH2                        1
> +/**< It refers BMG160 Shake Threshold2 */
> +#define BMG160_AUTO_OFFSET_WL                   0
> +/**< It refers BMG160 Auto Offset word length */
> +#define BMG160_FAST_OFFSET_WL                   1
> +/**< It refers BMG160 Fast Offset word length */
> +#define BMG160_I2C_WDT_EN                       0
> +/**< It refers BMG160 I2C WDT En */
> +#define BMG160_I2C_WDT_SEL                      1
> +/**< It refers BMG160 I2C WDT Sel */
> +#define BMG160_EXT_MODE                         0
> +/**< It refers BMG160 Ext Mode */
> +#define BMG160_EXT_PAGE                         1
> +/**< It refers BMG160 Ext page */
> +#define BMG160_START_ADDR                       0
> +/**< It refers BMG160 Start Address */
> +#define BMG160_STOP_ADDR                        1
> +/**< It refers BMG160 Stop Address */
> +#define BMG160_SLOW_CMD                         0
> +/**< It refers BMG160 Slow Command */
> +#define BMG160_FAST_CMD                         1
> +/**< It refers BMG160 Fast Command */
> +#define BMG160_TRIM_VRA                         0
> +/**< It refers BMG160 Trim VRA */
> +#define BMG160_TRIM_VRD                         1
> +/**< It refers BMG160 Trim VRD */
> +#define BMG160_LOGBIT_EM                        0
> +/**< It refers BMG160 LogBit Em */
> +#define BMG160_LOGBIT_VM                        1
> +/**< It refers BMG160 LogBit VM */
> +#define BMG160_GP0                              0
> +/**< It refers BMG160 GP0 */
> +#define BMG160_GP1                              1
> +/**< It refers BMG160 GP1*/
> +#define BMG160_LOW_SPEED                        0
> +/**< It refers BMG160 Low Speed Oscilator */
> +#define BMG160_HIGH_SPEED                       1
> +/**< It refers BMG160 High Speed Oscilator */
> +#define BMG160_DRIVE_OFFSET_P                   0
> +/**< It refers BMG160 Drive Offset P */
> +#define BMG160_DRIVE_OFFSET_N                   1
> +/**< It refers BMG160 Drive Offset N */
> +#define BMG160_TEST_MODE_EN                     0
> +/**< It refers BMG160 Test Mode Enable */
> +#define BMG160_TEST_MODE_REG                    1
> +/**< It refers BMG160 Test Mode reg */
> +#define BMG160_IBIAS_DRIVE_TRIM                 0
> +/**< It refers BMG160 IBIAS Drive Trim */
> +#define BMG160_IBIAS_RATE_TRIM                  1
> +/**< It refers BMG160 IBIAS Rate Trim */
> +#define BMG160_BAA_MODE                         0
> +/**< It refers BMG160 BAA Mode Trim */
> +#define BMG160_BMA_MODE                         1
> +/**< It refers BMG160 BMA Mode Trim */
> +#define BMG160_PI_KP                            0
> +/**< It refers BMG160 PI KP */
> +#define BMG160_PI_KI                            1
> +/**< It refers BMG160 PI KI */
> +
> +
> +#define C_BMG160_SUCCESS						0
> +/**< It refers BMG160 operation is success */
> +#define C_BMG160_FAILURE						1
> +/**< It refers BMG160 operation is Failure */
Please change to using standard linux errno values for errors.  If you
have an error the return value will be negative.  Typically -EINVAL etc.
That conveys more information and can be passed on up the software stack
without additional conversions.

> +
> +#define BMG160_SPI_RD_MASK                      0x80
> +/**< Read mask **/
> +#define BMG160_READ_SET                         0x01
> +/**< Setting for rading data **/
> +

Again, don't provide defines for values that are more
obvious if just used directly.  The fact they are shifts
will be readily apparent by where they are used,
> +#define BMG160_SHIFT_1_POSITION                 1
> +/**< Shift bit by 1 Position **/
> +#define BMG160_SHIFT_2_POSITION                 2
> +/**< Shift bit by 2 Position **/
> +#define BMG160_SHIFT_3_POSITION                 3
> +/**< Shift bit by 3 Position **/
> +#define BMG160_SHIFT_4_POSITION                 4
> +/**< Shift bit by 4 Position **/
> +#define BMG160_SHIFT_5_POSITION                 5
> +/**< Shift bit by 5 Position **/
> +#define BMG160_SHIFT_6_POSITION                 6
> +/**< Shift bit by 6 Position **/
> +#define BMG160_SHIFT_7_POSITION                 7
> +/**< Shift bit by 7 Position **/
> +#define BMG160_SHIFT_8_POSITION                 8
> +/**< Shift bit by 8 Position **/
> +#define BMG160_SHIFT_12_POSITION                12
> +/**< Shift bit by 12 Position **/
> +

Don't redefine simple numbers.  The code will be much cleaner if
you just use the numbers wherever they are needed. As a side
note, if this driver had been cleaner this review would have
taken me a fraction of the time and I would probably have done it
over lunch one day during the week.

> +#define         C_BMG160_Null_U8X                              0
> +#define         C_BMG160_Zero_U8X                              0
> +#define         C_BMG160_One_U8X                               1
> +#define         C_BMG160_Two_U8X                               2
> +#define         C_BMG160_Three_U8X                             3
> +#define         C_BMG160_Four_U8X                              4
> +#define         C_BMG160_Five_U8X                              5
> +#define         C_BMG160_Six_U8X                               6
> +#define         C_BMG160_Seven_U8X                             7
> +#define         C_BMG160_Eight_U8X                             8
> +#define         C_BMG160_Nine_U8X                              9
> +#define         C_BMG160_Ten_U8X                               10
> +#define         C_BMG160_Eleven_U8X                            11
> +#define         C_BMG160_Twelve_U8X                            12
> +#define         C_BMG160_Thirteen_U8X                          13
> +#define         C_BMG160_Fifteen_U8X                           15
> +#define         C_BMG160_Sixteen_U8X                           16
> +#define         C_BMG160_TwentyTwo_U8X                         22
> +#define         C_BMG160_TwentyThree_U8X                       23
> +#define         C_BMG160_TwentyFour_U8X                        24
> +#define         C_BMG160_TwentyFive_U8X                        25
> +#define         C_BMG160_ThirtyTwo_U8X                         32
> +#define         C_BMG160_Hundred_U8X                           100
> +#define         C_BMG160_OneTwentySeven_U8X                    127
> +#define         C_BMG160_OneTwentyEight_U8X                    128
> +#define         C_BMG160_TwoFiftyFive_U8X                      255
> +#define         C_BMG160_TwoFiftySix_U16X                      256
> +
> +#define E_BMG160_NULL_PTR               (char)(-127)
> +#define E_BMG160_COMM_RES               (char)(-1)
> +#define E_BMG160_OUT_OF_RANGE           (signed char)(-2)
> +
> +#define C_BMG160_No_Filter_U8X			0
> +#define	C_BMG160_BW_230Hz_U8X			1
> +#define	C_BMG160_BW_116Hz_U8X			2
> +#define	C_BMG160_BW_47Hz_U8X			3
> +#define	C_BMG160_BW_23Hz_U8X			4
> +#define	C_BMG160_BW_12Hz_U8X			5
> +#define	C_BMG160_BW_64Hz_U8X			6
> +#define	C_BMG160_BW_32Hz_U8X			7
> +
Why the C_ prefix?
> +#define C_BMG160_No_AutoSleepDur_U8X	0
> +#define	C_BMG160_4ms_AutoSleepDur_U8X	1
> +#define	C_BMG160_5ms_AutoSleepDur_U8X	2
> +#define	C_BMG160_8ms_AutoSleepDur_U8X	3
> +#define	C_BMG160_10ms_AutoSleepDur_U8X	4
> +#define	C_BMG160_15ms_AutoSleepDur_U8X	5
> +#define	C_BMG160_20ms_AutoSleepDur_U8X	6
> +#define	C_BMG160_40ms_AutoSleepDur_U8X	7
> +
> +
> +
Don't define these types here, just put them in where they are needed.
That will give easier to review code.
> +#define BMG160_WR_FUNC_PTR char (*bus_write)\
> +(unsigned char, unsigned char, unsigned char *, unsigned char)
> +#define BMG160_RD_FUNC_PTR char (*bus_read)\
> +(unsigned char, unsigned char, unsigned char *, unsigned char)
> +#define BMG160_BRD_FUNC_PTR char (*burst_read)\
> +(unsigned char, unsigned char, unsigned char *, BMG160_S32)
> +#define BMG160_MDELAY_DATA_TYPE BMG160_S32
> +
> +
> +
> +/*user defined Structures*/
> +struct bmg160_data_t {
s16 datax; etc.
> +		BMG160_S16 datax;
> +		BMG160_S16 datay;
> +		BMG160_S16 dataz;
> +		char intstatus[5];
> +};
> +
> +
This is not used anywhere in the driver (that i can spot!)
> +struct bmg160_offset_t {
> +		BMG160_U16 datax;
> +		BMG160_U16 datay;
> +		BMG160_U16 dataz;
> +};
> +
> +
What is this about?  If you have multiple buses to support then use
regmap which is defined for that exact purpose. If not, then please
rip this out of the code. I see the part does support spi as well.
If it is not a good fit for regmap (I haven't yet looked at the
relevant code so can't tell) then look at how other drivers
handle this in a clean fashion.

> +struct bmg160_t {
> +		unsigned char chip_id;
> +		unsigned char dev_addr;
> +		BMG160_BRD_FUNC_PTR;
> +		BMG160_WR_FUNC_PTR;
> +		BMG160_RD_FUNC_PTR;

Why would you have different implementations of a simple delay?
> +		void(*delay_msec)(BMG160_MDELAY_DATA_TYPE);
> +};
> +
> +BMG160_RETURN_FUNCTION_TYPE bmg160_init(struct bmg160_t *p_bmg160);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_dataxyz(struct bmg160_data_t *data);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_bw(unsigned char *bandwidth);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_bw(unsigned char bandwidth);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_data_enable(unsigned char data_en);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_int_od(unsigned char param,
> +	unsigned char *int_od);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_int_od(unsigned char param,
> +	unsigned char int_od);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_int_data(unsigned char axis,
> +	unsigned char *int_data);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_int_data(unsigned char axis,
> +	unsigned char int_data);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_reset_int
> +(unsigned char reset_int);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_offset
> +(unsigned char axis, BMG160_S16 *offset);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_offset
> +(unsigned char axis, BMG160_S16 offset);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_range_reg
> +(unsigned char *range);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_range_reg
> +(unsigned char range);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_mode(unsigned char *mode);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_mode(unsigned char mode);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_selftest(unsigned char *result);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_get_autosleepdur(unsigned char *duration);
> +BMG160_RETURN_FUNCTION_TYPE bmg160_set_autosleepdur(unsigned char duration,
> +unsigned char bandwith);
Don't define your own version of standard types.
Please replace all instances of BMG160_RETURN_TYPE with int throughout the code.

> +
> +
> +#define BMG_SENSOR_UP_TIME           15
> +#define BMG_TIME_STAMP_TOR                        5
> +#define BMG160_BYTES_PER_3AXIS_SENSOR 6
> +#define BMG160_OUTPUT_DATA_SIZE         16
Please ensure consistent naming, so these need a
BMG160 prefix.

> +#define INT_PIN_PUSH_PULL     0
> +#define INT_PIN_OPEN_DRAIN    1

Drop these two. As far as I can quickly see they are just
used to define your own local version of a boolean for one
function call.
> +#define INT_DISABLE           0
> +#define INT_ENABLE            1
> +
> +
> +#define BMG_REG_NAME(name) BMG160_##name
> +#define BMG_VAL_NAME(name) BMG160_##name
> +#define BMG_CALL_API(name) bmg160_##name
Please get rid of all of these though out the code.
They just make it messier and harder to read.

> +
> +/*Related with output data type*/
> +enum BMG_SCAN_INDEX {
> +		BMG_SCAN_GYRO_X,
> +		BMG_SCAN_GYRO_Y,
> +		BMG_SCAN_GYRO_Z,
> +		BMG_SCAN_TIMESTAMP,
> +};
> +
> +/*Related with output data rate*/
> +enum BMG_FILTER_BW {
> +		BMG_523HZ_Unfilter = 0,
> +		BMG_FILTER_230HZ,
> +		BMG_FILTER_116HZ,
> +		BMG_FILTER_47HZ,
> +		BMG_FILTER_23HZ,
> +		BMG_FILTER_12HZ,
> +		BMG_FILTER_64HZ,
> +		BMG_FILTER_32HZ,
> +		NUM_BMG_FILTER
> +};
> +
> +/*full scale releated definition*/
> +enum BMG_FSR_VAL {
> +		BMG_FSR_2000DPS_VAL = 0,
> +		BMG_FSR_1000DPS_VAL,
> +		BMG_FSR_500DPS_VAL,
> +		BMG_FSR_250DPS_VAL,
> +		BMG_FSR_125DPS_VAL,
> +		NUM_BMG_FSR_VAL
> +};
This enum is only used to provide an index within an array
above (which is then stored in the array?)

> +
> +#define BMG_FULLSCALE_AVL_MAX		10
I would have guesed that this would be the number of
fullscale elements by its name, but ther eare only 5 defined here?
> +#define BMG_FS_AVL_125DPS			125
> +#define BMG_FS_AVL_250DPS			250
> +#define BMG_FS_AVL_500DPS			500
> +#define BMG_FS_AVL_1000DPS		1000
> +#define BMG_FS_AVL_2000DPS		2000
These defines serve no purpose, using the values directly is
just as clear in the code and avoids anyone reviewing it having
to track down the definition.
> +
> +/**
> + *	struct bmg_fullscale_avl - bmg full scale releated feture.
> + *	@gyro_fs_value: the reg value.
> + *	@gyro_fs_dps: full scale range.
> + *	@gyro_fs_rslt: scale resolution.
> + */
Drop the blank line here to clearly associate this bit of
kernel doc with what it is describing. (pretty much a
convention though I suspect this one may not be documented
anywhere!)
> +
> +struct bmg_fullscale_avl {
> +		u8 gyro_fs_value;
> +		unsigned int gyro_fs_dps;
> +		unsigned int gyro_fs_rslt;
> +};
> +
> +
> +enum bmg_devices {
> +		BMG160,
> +		NUM_DEVICE_PARTS
> +};
> +
This is nicely commented with just the right level
of detail.
> +/**
> + *	struct bmg_chip_config - chip configuration data.
> + *	@fsr:		full scale range.
> + *	@filter_bw:	bandwidth frequency.
> + *	@gyro_fifo_enable: gyro data ready enable.
> + */
> +struct bmg_chip_config {
> +	unsigned int fsr:3;
> +	unsigned int filter_bw:3;
> +	unsigned int gyro_fifo_enable:1;
> +};
> +

Unless you are very soon going to introduced additional parts to
this driver then please drop the multiple part support (it is easy enough
to add back in when needed!)
> +/**
> + *	struct bmg_hw - Other important hardware information.
> + *	@name:		name of the chip.
> + *	@chip_id:	value of chip id.
> + *	@config:	configuration of the chip.
> + */
> +struct bmg_hw {
> +	u8 *name;
> +	u8 chip_id;
> +	const struct bmg_chip_config *config;
> +};
> +
In general your white space needs cleaning up.  I know Joe
picked up on some of this as well.
> +struct bmg_config {
> +			struct bmg_chip_config chip_config;
> +			const struct bmg_hw *hw;
> +			enum   bmg_devices chip_type;
> +};
> +
The spacing this structure is a bit random.
> +struct bmg_client_data {
> +	struct bmg160_t device;
> +	struct i2c_client *client;

If you just made this an integer index into the array I think
the code would get somewhat cleaner?
> +	struct bmg_fullscale_avl *current_fullscale;
> +	struct iio_trigger	*trig;
> +	struct bmg_chip_config chip_config;
> +	const struct bmg_hw *hw;
> +	enum bmg_devices chip_type;
> +	struct device *dev;
> +	atomic_t delay;
> +	unsigned int gpio_interrupt_pin;
> +	struct bmg160_data_t value;
> +	u8 enable:1;
Not capitals for IRQ please. Generally anything
defined in capitals is assumed to be a '#define'd value.
> +	int IRQ;
> +};
> +
> +
> +/* CONFIG_IIO_BUFFER */
> +#ifdef CONFIG_IIO_BUFFER
> +int bmg_allocate_ring(struct iio_dev *indio_dev);
> +void bmg_deallocate_ring(struct iio_dev *indio_dev);
> +
> +#else
> +static inline int bmg_allocate_ring(struct iio_dev *indio_dev)
> +{
> +	return 0;
> +}
> +static inline void bmg_deallocate_ring(struct iio_dev *indio_dev)
> +{
> +}
> +#endif /* CONFIG_IIO_BUFFER */
> +
> +#ifdef CONFIG_IIO_TRIGGER
> +int bmg_probe_trigger(struct iio_dev *indio_dev);
> +
> +void bmg_remove_trigger(struct iio_dev *indio_dev);
> +
> +#else
> +static inline int bmg_probe_trigger(struct iio_dev *indio_dev)
> +{
> +	return 0;
> +}
> +static inline void bmg_remove_trigger(struct iio_dev *indio_dev)
> +{
> +	return;
> +}
> +#endif
> +
> +#endif	/*END FILE*/
A golden rule of kernel development, never state the obvious in comments!
Hence loose that /*END FILE*/

Generally we keep comments for when the code is non obvious in someway
or when an interface expected to be used by other elements of the kernel
is being defined.

> --
> 1.7.5.4
>
