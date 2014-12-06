Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaLGRnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 12:43:43 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39890 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaLGRne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 12:43:34 -0500
Message-ID: <54830E09.2040102@kernel.org>
Date: Sat, 06 Dec 2014 14:09:13 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v3 1/5] iio: common: ssp_sensors: Add sensorhub driver
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com> <1417809290-9662-2-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1417809290-9662-2-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 19:54, Karol Wrona wrote:
> Sensorhub  is MCU dedicated to collect data and manage several sensors.
> Sensorhub is a spi device which provides a layer for IIO devices. It provides
> some data parsing and common mechanism for sensorhub sensors.
> 
> Adds common sensorhub library for sensorhub driver and iio drivers
> which uses sensorhub MCU to communicate with sensors.
> 
> Change-Id: I4f066e9f3f477d4f6faabd4507be98e32f79e344
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Nice bit of code.  A few comments inline, mostly slight preferences rather
than anything else.  I wonder if it's worth centralising some of the buffers
to cut down on the large number of little allocations.


> ---
>  drivers/iio/common/Kconfig               |    1 +
>  drivers/iio/common/Makefile              |    1 +
>  drivers/iio/common/ssp_sensors/Kconfig   |   24 ++
>  drivers/iio/common/ssp_sensors/Makefile  |    6 +
>  drivers/iio/common/ssp_sensors/ssp.h     |  254 +++++++++++
>  drivers/iio/common/ssp_sensors/ssp_dev.c |  693 ++++++++++++++++++++++++++++++
>  drivers/iio/common/ssp_sensors/ssp_spi.c |  644 +++++++++++++++++++++++++++
>  include/linux/iio/common/ssp_sensors.h   |   80 ++++
>  8 files changed, 1703 insertions(+)
>  create mode 100644 drivers/iio/common/ssp_sensors/Kconfig
>  create mode 100644 drivers/iio/common/ssp_sensors/Makefile
>  create mode 100644 drivers/iio/common/ssp_sensors/ssp.h
>  create mode 100644 drivers/iio/common/ssp_sensors/ssp_dev.c
>  create mode 100644 drivers/iio/common/ssp_sensors/ssp_spi.c
>  create mode 100644 include/linux/iio/common/ssp_sensors.h
> 
> diff --git a/drivers/iio/common/Kconfig b/drivers/iio/common/Kconfig
> index 0b6e97d..790f106 100644
> --- a/drivers/iio/common/Kconfig
> +++ b/drivers/iio/common/Kconfig
> @@ -3,4 +3,5 @@
>  #
>  
>  source "drivers/iio/common/hid-sensors/Kconfig"
> +source "drivers/iio/common/ssp_sensors/Kconfig"
>  source "drivers/iio/common/st_sensors/Kconfig"
> diff --git a/drivers/iio/common/Makefile b/drivers/iio/common/Makefile
> index 3112df0..b1e4d9c 100644
> --- a/drivers/iio/common/Makefile
> +++ b/drivers/iio/common/Makefile
> @@ -8,4 +8,5 @@
>  
>  # When adding new entries keep the list in alphabetical order
>  obj-y += hid-sensors/
> +obj-y += ssp_sensors/
>  obj-y += st_sensors/
> diff --git a/drivers/iio/common/ssp_sensors/Kconfig b/drivers/iio/common/ssp_sensors/Kconfig
> new file mode 100644
> index 0000000..c1d054e
> --- /dev/null
> +++ b/drivers/iio/common/ssp_sensors/Kconfig
> @@ -0,0 +1,24 @@
> +#
> +# SSP sensor drivers and commons configuration
> +#
> +menu "SSP Sensor Common"
> +
> +config IIO_SSP_SENSOR
> +	tristate "Commons for all SSP Sensor IIO drivers"
> +	depends on SSP_SENSORS
> +	select IIO_BUFFER
> +	select IIO_KFIFO_BUF
> +	help
> +	  Say yes here to build commons for SSP sensors.
> +
> +config SSP_SENSORS
> +	tristate "Samsung Sensorhub driver"
> +	depends on SPI
> +	help
> +	  SSP driver for sensorhub.
> +	  If you say yes here you get ssp support for
> +	  sensorhub.
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called sensorhub.
> +
> +endmenu
> diff --git a/drivers/iio/common/ssp_sensors/Makefile b/drivers/iio/common/ssp_sensors/Makefile
> new file mode 100644
> index 0000000..7aede30
> --- /dev/null
> +++ b/drivers/iio/common/ssp_sensors/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for SSP sensor drivers and commons.
> +#
> +
> +obj-$(CONFIG_IIO_SSP_SENSOR) 		+= ssp_iio.o
> +obj-$(CONFIG_SSP_SENSORS)	+= ssp_dev.o ssp_spi.o
> diff --git a/drivers/iio/common/ssp_sensors/ssp.h b/drivers/iio/common/ssp_sensors/ssp.h
> new file mode 100644
> index 0000000..b2fbc82
> --- /dev/null
> +++ b/drivers/iio/common/ssp_sensors/ssp.h
> @@ -0,0 +1,254 @@
> +/*
> + *  Copyright (C) 2014, Samsung Electronics Co. Ltd. All Rights Reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __SSP_SENSORHUB_H__
> +#define __SSP_SENSORHUB_H__
> +
> +#include <linux/delay.h>
> +#include <linux/gpio.h>
> +#include <linux/iio/common/ssp_sensors.h>
> +#include <linux/iio/iio.h>
> +#include <linux/spi/spi.h>
> +
> +#define SSP_DEVICE_ID		0x55
> +
> +#ifdef SSP_DBG
> +#define ssp_dbg(format, ...) pr_info("[SSP] "format, ##__VA_ARGS__)
> +#else
> +#define ssp_dbg(format, ...)
> +#endif
> +
> +#define SSP_SW_RESET_TIME		3000
> +/* Sensor polling in ms */
> +#define SSP_DEFAULT_POLLING_DELAY	200
> +#define SSP_DEFAULT_RETRIES		3
> +#define SSP_DATA_PACKET_SIZE		960
> +
> +enum {
> +	SSP_KERNEL_BINARY = 0,
> +	SSP_KERNEL_CRASHED_BINARY,
> +};
> +
> +enum {
> +	SSP_INITIALIZATION_STATE = 0,
> +	SSP_NO_SENSOR_STATE,
> +	SSP_ADD_SENSOR_STATE,
> +	SSP_RUNNING_SENSOR_STATE,
> +};
> +
> +/* Firmware download STATE */
> +enum {
> +	SSP_FW_DL_STATE_FAIL = -1,
> +	SSP_FW_DL_STATE_NONE = 0,
> +	SSP_FW_DL_STATE_NEED_TO_SCHEDULE,
> +	SSP_FW_DL_STATE_SCHEDULED,
> +	SSP_FW_DL_STATE_DOWNLOADING,
> +	SSP_FW_DL_STATE_SYNC,
> +	SSP_FW_DL_STATE_DONE,
> +};
> +
> +#define SSP_INVALID_REVISION			99999
> +#define SSP_INVALID_REVISION2			0xffffff
> +
> +/* AP -> SSP Instruction */
> +#define SSP_MSG2SSP_INST_BYPASS_SENSOR_ADD	0xa1
> +#define SSP_MSG2SSP_INST_BYPASS_SENSOR_RM	0xa2
> +#define SSP_MSG2SSP_INST_REMOVE_ALL		0xa3
> +#define SSP_MSG2SSP_INST_CHANGE_DELAY		0xa4
> +#define SSP_MSG2SSP_INST_LIBRARY_ADD		0xb1
> +#define SSP_MSG2SSP_INST_LIBRARY_REMOVE		0xb2
> +#define SSP_MSG2SSP_INST_LIB_NOTI		0xb4
> +#define SSP_MSG2SSP_INST_LIB_DATA		0xc1
> +
> +#define SSP_MSG2SSP_AP_MCU_SET_GYRO_CAL		0xcd
> +#define SSP_MSG2SSP_AP_MCU_SET_ACCEL_CAL	0xce
> +#define SSP_MSG2SSP_AP_STATUS_SHUTDOWN		0xd0
> +#define SSP_MSG2SSP_AP_STATUS_WAKEUP		0xd1
> +#define SSP_MSG2SSP_AP_STATUS_SLEEP		0xd2
> +#define SSP_MSG2SSP_AP_STATUS_RESUME		0xd3
> +#define SSP_MSG2SSP_AP_STATUS_SUSPEND		0xd4
> +#define SSP_MSG2SSP_AP_STATUS_RESET		0xd5
> +#define SSP_MSG2SSP_AP_STATUS_POW_CONNECTED	0xd6
> +#define SSP_MSG2SSP_AP_STATUS_POW_DISCONNECTED	0xd7
> +#define SSP_MSG2SSP_AP_TEMPHUMIDITY_CAL_DONE	0xda
> +#define SSP_MSG2SSP_AP_MCU_SET_DUMPMODE		0xdb
> +#define SSP_MSG2SSP_AP_MCU_DUMP_CHECK		0xdc
> +#define SSP_MSG2SSP_AP_MCU_BATCH_FLUSH		0xdd
> +#define SSP_MSG2SSP_AP_MCU_BATCH_COUNT		0xdf
> +
> +#define SSP_MSG2SSP_AP_WHOAMI				0x0f
> +#define SSP_MSG2SSP_AP_FIRMWARE_REV			0xf0
> +#define SSP_MSG2SSP_AP_SENSOR_FORMATION			0xf1
> +#define SSP_MSG2SSP_AP_SENSOR_PROXTHRESHOLD		0xf2
> +#define SSP_MSG2SSP_AP_SENSOR_BARCODE_EMUL		0xf3
> +#define SSP_MSG2SSP_AP_SENSOR_SCANNING			0xf4
> +#define SSP_MSG2SSP_AP_SET_MAGNETIC_HWOFFSET		0xf5
> +#define SSP_MSG2SSP_AP_GET_MAGNETIC_HWOFFSET		0xf6
> +#define SSP_MSG2SSP_AP_SENSOR_GESTURE_CURRENT		0xf7
> +#define SSP_MSG2SSP_AP_GET_THERM			0xf8
> +#define SSP_MSG2SSP_AP_GET_BIG_DATA			0xf9
> +#define SSP_MSG2SSP_AP_SET_BIG_DATA			0xfa
> +#define SSP_MSG2SSP_AP_START_BIG_DATA			0xfb
> +#define SSP_MSG2SSP_AP_SET_MAGNETIC_STATIC_MATRIX	0xfd
> +#define SSP_MSG2SSP_AP_SENSOR_TILT			0xea
> +#define SSP_MSG2SSP_AP_MCU_SET_TIME			0xfe
> +#define SSP_MSG2SSP_AP_MCU_GET_TIME			0xff
> +
> +#define SSP_MSG2SSP_AP_FUSEROM				0x01
> +
> +/* voice data */
> +#define SSP_TYPE_WAKE_UP_VOICE_SERVICE			0x01
> +#define SSP_TYPE_WAKE_UP_VOICE_SOUND_SOURCE_AM		0x01
> +#define SSP_TYPE_WAKE_UP_VOICE_SOUND_SOURCE_GRAMMER	0x02
> +
> +/* Factory Test */
> +#define SSP_ACCELEROMETER_FACTORY			0x80
> +#define SSP_GYROSCOPE_FACTORY				0x81
> +#define SSP_GEOMAGNETIC_FACTORY				0x82
> +#define SSP_PRESSURE_FACTORY				0x85
> +#define SSP_GESTURE_FACTORY				0x86
> +#define SSP_TEMPHUMIDITY_CRC_FACTORY			0x88
> +#define SSP_GYROSCOPE_TEMP_FACTORY			0x8a
> +#define SSP_GYROSCOPE_DPS_FACTORY			0x8b
> +#define SSP_MCU_FACTORY					0x8c
> +#define SSP_MCU_SLEEP_FACTORY				0x8d
> +
> +/* SSP -> AP ACK about write CMD */
> +#define SSP_MSG_ACK		0x80	/* ACK from SSP to AP */
> +#define SSP_MSG_NAK		0x70	/* NAK from SSP to AP */
> +
> +struct ssp_sensorhub_info {
> +	char *fw_name;
> +	char *fw_crashed_name;
> +	unsigned int fw_rev;
> +	const u8 * const mag_table;
> +	const unsigned int mag_length;
> +};
> +
> +/* ssp_msg options bit */
> +#define SSP_RW		0
> +#define SSP_INDEX	3
> +
> +#define SSP_AP2HUB_READ		0
> +#define SSP_AP2HUB_WRITE	1
> +#define SSP_HUB2AP_WRITE	2
> +#define SSP_AP2HUB_READY	3
> +#define SSP_AP2HUB_RETURN	4
> +
> +/**
> + * struct ssp_data - ssp platformdata structure
> + * @spi:		spi device
> + * @sensorhub_info:	info about sensorhub board specific features
> + * @wdt_timer:		watchdog timer
> + * @work_wdt:		watchdog work
> + * @work_firmware:	firmware upgrade work queue
> + * @work_refresh:	refresh work queue for reset request from MCU
> + * @shut_down:		shut down flag
> + * @mcu_dump_mode:	mcu dump mode for debug
> + * @time_syncing:	time syncing indication flag
> + * @timestamp:		previous time in ns calculated for time syncing
> + * @check_status:	status table for each sensor
> + * @com_fail_cnt:	communication fail count
> + * @reset_cnt:		reset count
> + * @timeout_cnt:	timeout count
> + * @available_sensors:	available sensors seen by sensorhub (bit array)
> + * @cur_firm_rev:	cached current firmware revision
> + * @last_resume_state:	last AP resume/suspend state used to handle the PM
> + *                      state of ssp
> + * @last_ap_state:	(obsolete) sleep notification for MCU
> + * @sensor_enable:	sensor enable mask
> + * @delay_buf:		data acquisition intervals table
> + * @batch_latency_buf:	yet unknown but existing in communication protocol
> + * @batch_opt_buf:	yet unknown but existing in communication protocol
> + * @accel_position:	yet unknown but existing in communication protocol
> + * @mag_position:	yet unknown but existing in communication protocol
> + * @fw_dl_state:	firmware download state
> + * @comm_lock:		lock protecting the handshake
> + * @pending_lock:	lock protecting pending list and completion
> + * @mcu_reset:		mcu reset line
> + * @ap_mcu_gpio:	ap to mcu gpio line
> + * @mcu_ap_gpio:	mcu to ap gpio line
> + * @pending_list:	pending list for messages queued to be sent/read
> + * @sensor_devs:	registered IIO devices table
> + * @enable_refcount:	enable reference count for wdt (watchdog timer)
Good docs. Thanks.
> + */
> +struct ssp_data {
> +	struct spi_device *spi;
> +	struct ssp_sensorhub_info *sensorhub_info;
> +	struct timer_list wdt_timer;
> +	struct work_struct work_wdt;
> +	struct delayed_work work_refresh;
> +
> +	bool shut_down;
> +	bool mcu_dump_mode;
> +	bool time_syncing;
> +	int64_t timestamp;
> +
> +	int check_status[SSP_SENSOR_MAX];
> +
> +	unsigned int com_fail_cnt;
> +	unsigned int reset_cnt;
> +	unsigned int timeout_cnt;
> +
> +	unsigned int available_sensors;
> +	unsigned int cur_firm_rev;
> +
> +	char last_resume_state;
> +	char last_ap_state;
> +
> +	unsigned int sensor_enable;
> +	u32 delay_buf[SSP_SENSOR_MAX];
> +	s32 batch_latency_buf[SSP_SENSOR_MAX];
> +	s8 batch_opt_buf[SSP_SENSOR_MAX];
> +
> +	int accel_position;
> +	int mag_position;
> +	int fw_dl_state;
> +
> +	struct mutex comm_lock;
> +	struct mutex pending_lock;
> +
> +	int mcu_reset;
> +	int ap_mcu_gpio;
> +	int mcu_ap_gpio;
> +
> +	struct list_head pending_list;
> +
> +	struct iio_dev *sensor_devs[SSP_SENSOR_MAX];
> +	atomic_t enable_refcount;
> +};
> +
> +void ssp_clean_pending_list(struct ssp_data *data);
> +
> +int ssp_command(struct ssp_data *data, char command, int arg);
> +
> +int ssp_send_instruction(struct ssp_data *data, u8 inst, u8 sensor_type,
> +			 u8 *send_buf, u8 length);
> +
> +int ssp_irq_msg(struct ssp_data *data);
> +
> +int ssp_get_chipid(struct ssp_data *data);
> +
> +int ssp_set_sensor_position(struct ssp_data *data);
> +
> +int ssp_set_magnetic_matrix(struct ssp_data *data);
> +
> +unsigned int ssp_get_sensor_scanning_info(struct ssp_data *data);
> +
> +unsigned int ssp_get_firmware_rev(struct ssp_data *data);
> +
> +int ssp_queue_ssp_refresh_task(struct ssp_data *data, unsigned int delay);
> +
> +#endif /* __SSP_SENSORHUB_H__ */
> diff --git a/drivers/iio/common/ssp_sensors/ssp_dev.c b/drivers/iio/common/ssp_sensors/ssp_dev.c
> new file mode 100644
> index 0000000..5e43ff3
> --- /dev/null
> +++ b/drivers/iio/common/ssp_sensors/ssp_dev.c
> @@ -0,0 +1,693 @@
> +/*
> + *  Copyright (C) 2014, Samsung Electronics Co. Ltd. All Rights Reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/iio/iio.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_platform.h>
> +#include "ssp.h"
> +
> +#define SSP_WDT_TIME			10000
> +#define SSP_LIMIT_RESET_CNT		20
> +#define SSP_LIMIT_TIMEOUT_CNT		3
> +
> +/* It is possible that it is max clk rate for version 1.0 of bootcode */
> +#define SSP_BOOT_SPI_HZ	400000
> +
> +static const u8 ssp_magnitude_table[] = {110, 85, 171, 71, 203, 195, 0, 67, 208,
> +	56, 175, 244, 206, 213, 0, 92, 250, 0, 55, 48, 189, 252, 171, 243, 13,
> +	45, 250};
> +
> +static const struct ssp_sensorhub_info ssp_rinato_info = {
> +	.fw_name = "ssp_B2.fw",
> +	.fw_crashed_name = "ssp_crashed.fw",
> +	.fw_rev = 14052300,
> +	.mag_table = ssp_magnitude_table,
> +	.mag_length = ARRAY_SIZE(ssp_magnitude_table),
> +};
> +
> +static const struct ssp_sensorhub_info ssp_thermostat_info = {
> +	.fw_name = "thermostat_B2.fw",
> +	.fw_crashed_name = "ssp_crashed.fw",
> +	.fw_rev = 14080600,
> +	.mag_table = ssp_magnitude_table,
> +	.mag_length = ARRAY_SIZE(ssp_magnitude_table),
> +};
> +
> +static void ssp_toggle_mcu_reset(struct ssp_data *data)
> +{
> +	gpio_set_value(data->mcu_reset, 0);
> +	usleep_range(1000, 1200);
> +	gpio_set_value(data->mcu_reset, 1);
> +	msleep(50);
> +}
> +
> +static void ssp_sync_available_sensors(struct ssp_data *data)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i < SSP_SENSOR_MAX; ++i) {
> +		if (data->available_sensors & BIT(i)) {
> +			ret = ssp_enable_sensor(data, i, data->delay_buf[i]);
> +			if (ret < 0) {
> +				dev_err(&data->spi->dev, "Sync sensor nr: %d fail\n",
> +					i);
> +				continue;
> +			}
> +		}
> +	}
> +
> +	ret = ssp_command(data, SSP_MSG2SSP_AP_MCU_SET_DUMPMODE,
> +			  data->mcu_dump_mode);
> +	if (ret < 0)
> +		dev_err(&data->spi->dev, "SSP_MSG2SSP_AP_MCU_SET_DUMPMODE failed\n");
> +}
> +
> +static void ssp_enable_mcu(struct ssp_data *data, bool enable)
> +{
> +	dev_info(&data->spi->dev, "current shutdown  = %d, old = %d\n", enable,
> +		 data->shut_down);
> +
> +	if (enable && data->shut_down) {
> +		data->shut_down = false;
> +		enable_irq(data->spi->irq);
> +		enable_irq_wake(data->spi->irq);
> +	} else if (!enable && !data->shut_down) {
> +		data->shut_down = true;
> +		disable_irq(data->spi->irq);
> +		disable_irq_wake(data->spi->irq);
> +	} else {
> +		dev_warn(&data->spi->dev, "current shutdown = %d, old = %d\n",
> +			 enable, data->shut_down);
> +	}
> +}
> +
> +/*
> + * This function is the first one which communicates with the mcu so it is
> + * possible that the first attempt will fail
> + */
> +static int ssp_check_fwbl(struct ssp_data *data)
> +{
> +	int retries = 0;
> +
> +	while (retries++ < 5) {
> +		data->cur_firm_rev = ssp_get_firmware_rev(data);
> +		if (data->cur_firm_rev == SSP_INVALID_REVISION ||
> +		    data->cur_firm_rev == SSP_INVALID_REVISION2) {
> +			dev_warn(&data->spi->dev,
> +				 "Invalid revision, trying %d time\n", retries);
> +		} else {
> +			break;
> +		}
> +	}
> +
> +	if (data->cur_firm_rev == SSP_INVALID_REVISION ||
> +	    data->cur_firm_rev == SSP_INVALID_REVISION2) {
> +		dev_err(&data->spi->dev, "SSP_INVALID_REVISION\n");
> +		return SSP_FW_DL_STATE_NEED_TO_SCHEDULE;
> +	}
> +
> +	dev_info(&data->spi->dev,
> +		 "MCU Firm Rev : Old = %8u, New = %8u\n",
> +		 data->cur_firm_rev,
> +		 data->sensorhub_info->fw_rev);
> +
> +	if (data->cur_firm_rev != data->sensorhub_info->fw_rev)
> +		return SSP_FW_DL_STATE_NEED_TO_SCHEDULE;
> +
> +	return SSP_FW_DL_STATE_NONE;
> +}
> +
> +static void ssp_reset_mcu(struct ssp_data *data)
> +{
> +	ssp_enable_mcu(data, false);
> +	ssp_clean_pending_list(data);
> +	ssp_toggle_mcu_reset(data);
> +	ssp_enable_mcu(data, true);
> +}
> +
> +static void ssp_wdt_work_func(struct work_struct *work)
> +{
> +	struct ssp_data *data = container_of(work, struct ssp_data, work_wdt);
> +
> +	dev_err(&data->spi->dev, "%s - Sensor state: 0x%x, RC: %u, CC: %u\n",
> +		__func__, data->available_sensors, data->reset_cnt,
> +		data->com_fail_cnt);
> +
> +	ssp_reset_mcu(data);
> +	data->com_fail_cnt = 0;
> +	data->timeout_cnt = 0;
> +}
> +
> +static void ssp_wdt_timer_func(unsigned long ptr)
> +{
> +	struct ssp_data *data = (struct ssp_data *)ptr;
> +
> +	switch (data->fw_dl_state) {
> +	case SSP_FW_DL_STATE_FAIL:
> +	case SSP_FW_DL_STATE_DOWNLOADING:
> +	case SSP_FW_DL_STATE_SYNC:
> +		goto _mod;
> +	}
> +
> +	if (data->timeout_cnt > SSP_LIMIT_TIMEOUT_CNT ||
> +	    data->com_fail_cnt > SSP_LIMIT_RESET_CNT)
> +		queue_work(system_power_efficient_wq, &data->work_wdt);
> +_mod:
> +	mod_timer(&data->wdt_timer, jiffies + msecs_to_jiffies(SSP_WDT_TIME));
> +}
> +
> +static void ssp_enable_wdt_timer(struct ssp_data *data)
> +{
> +	mod_timer(&data->wdt_timer, jiffies + msecs_to_jiffies(SSP_WDT_TIME));
> +}
> +
> +static void ssp_disable_wdt_timer(struct ssp_data *data)
> +{
> +	del_timer_sync(&data->wdt_timer);
> +	cancel_work_sync(&data->work_wdt);
> +}
> +
> +/**
> + * ssp_get_sensor_delay() - gets sensor data acquisition period
> + * @data:	sensorhub structure
> + * @type:	SSP sensor type
> + *
> + * Returns acquisition period in ms
> + */
> +u32 ssp_get_sensor_delay(struct ssp_data *data, enum ssp_sensor_type type)
> +{
> +	return data->delay_buf[type];
> +}
> +EXPORT_SYMBOL(ssp_get_sensor_delay);
> +
> +/**
> + * ssp_enable_sensor() - enables data acquisition for sensor
> + * @data:	sensorhub structure
> + * @type:	SSP sensor type
> + * @delay:	delay in ms
> + *
> + * Returns 0 or negative value in case of error
> + */
> +int ssp_enable_sensor(struct ssp_data *data, enum ssp_sensor_type type,
> +		      u32 delay)
> +{
> +	int ret;
> +	struct {
> +		__le32 a;
> +		__le32 b;
> +		u8 c;
> +	} __attribute__((__packed__)) to_send;
> +
> +	to_send.a = cpu_to_le32(delay);
> +	to_send.b = cpu_to_le32(data->batch_latency_buf[type]);
> +	to_send.c = data->batch_opt_buf[type];
> +
> +	switch (data->check_status[type]) {
> +	case SSP_INITIALIZATION_STATE:
> +		/* do calibration step, now just enable */
> +	case SSP_ADD_SENSOR_STATE:
> +		ret = ssp_send_instruction(data,
> +					   SSP_MSG2SSP_INST_BYPASS_SENSOR_ADD,
> +					   type,
> +					   (u8 *)&to_send, sizeof(to_send));
> +		if (ret < 0) {
> +			dev_err(&data->spi->dev, "Enabling sensor failed\n");
> +			data->check_status[type] = SSP_NO_SENSOR_STATE;
> +			goto derror;
> +		}
> +
> +		data->sensor_enable |= BIT(type);
> +		data->check_status[type] = SSP_RUNNING_SENSOR_STATE;
> +		break;
> +	case SSP_RUNNING_SENSOR_STATE:
> +		ret = ssp_send_instruction(data,
> +					   SSP_MSG2SSP_INST_CHANGE_DELAY, type,
> +					   (u8 *)&to_send, sizeof(to_send));
> +		if (ret < 0) {
> +			dev_err(&data->spi->dev,
> +				"Changing sensor delay failed\n");
> +			goto derror;
> +		}
> +		break;
> +	default:
> +		data->check_status[type] = SSP_ADD_SENSOR_STATE;
> +		break;
> +	}
> +
> +	data->delay_buf[type] = delay;
> +
> +	if (atomic_inc_return(&data->enable_refcount) == 1)
> +		ssp_enable_wdt_timer(data);
> +
> +	return 0;
> +
> +derror:
> +	return ret;
> +}
> +EXPORT_SYMBOL(ssp_enable_sensor);
> +
> +/**
> + * ssp_change_delay() - changes data acquisition for sensor
> + * @data:	sensorhub structure
> + * @type:	SSP sensor type
> + * @delay:	delay in ms
> + *
> + * Returns 0 or negative value in case of error
> + */
> +int ssp_change_delay(struct ssp_data *data, enum ssp_sensor_type type,
> +		     u32 delay)
> +{
> +	int ret;
> +	struct {
> +		__le32 a;
> +		__le32 b;
> +		u8 c;
> +	} __attribute__((__packed__)) to_send;
This structure gets used in a couple of places.  Worth giving it
a type and pulling it out of the functions?
> +
> +	to_send.a = cpu_to_le32(delay);
> +	to_send.b = cpu_to_le32(data->batch_latency_buf[type]);
> +	to_send.c = data->batch_opt_buf[type];
> +
> +	ret = ssp_send_instruction(data, SSP_MSG2SSP_INST_CHANGE_DELAY, type,
> +				   (u8 *)&to_send, sizeof(to_send));
> +	if (ret < 0) {
> +		dev_err(&data->spi->dev, "Changing delay sensor failed\n");
> +		return ret;
> +	}
> +
> +	data->delay_buf[type] = delay;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ssp_change_delay);
> +
> +/**
> + * ssp_disable_sensor() - disables sensor
> + *
> + * @data:	sensorhub structure
> + * @type:	SSP sensor type
> + *
> + * Returns 0 or negative value in case of error
Nice docs. Though why this rather obvious one gets docs and the less
obvious ones don't is an interesting question...
> + */
> +int ssp_disable_sensor(struct ssp_data *data, enum ssp_sensor_type type)
> +{
> +	int ret;
> +	__le32 command;
> +
> +	if (data->sensor_enable & BIT(type)) {
> +		command = cpu_to_le32(data->delay_buf[type]);
> +
> +		ret = ssp_send_instruction(data,
> +					   SSP_MSG2SSP_INST_BYPASS_SENSOR_RM,
> +					   type, (u8 *)&command,
> +					   sizeof(command));
> +		if (ret < 0) {
> +			dev_err(&data->spi->dev, "Remove sensor fail\n");
> +			return ret;
> +		}
> +
> +		data->sensor_enable &= ~BIT(type);
> +	}
> +
> +	data->check_status[type] = SSP_ADD_SENSOR_STATE;
> +
> +	if (atomic_dec_and_test(&data->enable_refcount))
> +		ssp_disable_wdt_timer(data);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ssp_disable_sensor);
> +
> +static irqreturn_t sensordata_irq_thread_fn(int irq, void *dev_id)
> +{
> +	struct ssp_data *data = dev_id;
> +
> +	ssp_irq_msg(data);
Why have this trivial wrapper instead of just having the code here?
Might make sense but please explain.
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int ssp_initialize_mcu(struct ssp_data *data)
> +{
> +	int ret;
> +
> +	ssp_clean_pending_list(data);
> +
> +	ret = ssp_get_chipid(data);
> +	if (ret != SSP_DEVICE_ID) {
> +		dev_err(&data->spi->dev, "%s - MCU %s ret = %d\n", __func__,
> +			ret < 0 ? "is not working" : "identification failed",
> +			ret);
> +		return ret < 0 ? ret : -ENODEV;
> +	}
> +
> +	dev_info(&data->spi->dev, "MCU device ID = %d\n", ret);
> +
> +	ret = ssp_set_sensor_position(data);
> +	if (ret < 0) {
> +		dev_err(&data->spi->dev, "ssp_set_sensor_position failed\n");
> +		return ret;
> +	}
> +
> +	ret = ssp_set_magnetic_matrix(data);
Hmm. It feels like this might belong more in the iio driver than here.
Please justify.
> +	if (ret < 0) {
> +		dev_err(&data->spi->dev,
> +			"%s - ssp_set_magnetic_matrix failed\n", __func__);
> +		return ret;
> +	}
> +
> +	data->available_sensors = ssp_get_sensor_scanning_info(data);
> +	if (data->available_sensors == 0) {
> +		dev_err(&data->spi->dev,
> +			"%s - ssp_get_sensor_scanning_info failed\n", __func__);
> +		return -EIO;
> +	}
> +
> +	data->cur_firm_rev = ssp_get_firmware_rev(data);
> +	dev_info(&data->spi->dev, "MCU Firm Rev : New = %8u\n",
> +		 data->cur_firm_rev);
> +
> +	return ssp_command(data, SSP_MSG2SSP_AP_MCU_DUMP_CHECK, 0);
> +}
> +
What's this doing?  Perhaps a bit of documentation to explain why a
task might want refreshing?
> +static void ssp_refresh_task(struct work_struct *work)
> +{
> +	struct ssp_data *data = container_of((struct delayed_work *)work,
> +					     struct ssp_data, work_refresh);
> +
> +	dev_info(&data->spi->dev, "refreshing\n");
> +
> +	data->reset_cnt++;
> +
> +	if (ssp_initialize_mcu(data) >= 0) {
> +		ssp_sync_available_sensors(data);
> +		if (data->last_ap_state != 0)
> +			ssp_command(data, data->last_ap_state, 0);
> +
> +		if (data->last_resume_state != 0)
> +			ssp_command(data, data->last_resume_state, 0);
> +
> +		data->timeout_cnt = 0;
> +		data->com_fail_cnt = 0;
> +	}
> +}
> +
> +int ssp_queue_ssp_refresh_task(struct ssp_data *data, unsigned int delay)
> +{
> +	cancel_delayed_work_sync(&data->work_refresh);
> +
> +	return queue_delayed_work(system_power_efficient_wq,
> +				  &data->work_refresh,
> +				  msecs_to_jiffies(delay));
> +}
> +
> +#ifdef CONFIG_OF
> +static struct of_device_id ssp_of_match[] = {
> +	{
> +		.compatible	= "samsung,sensorhub-rinato",
> +		.data		= &ssp_rinato_info,
> +	}, {
> +		.compatible	= "samsung,sensorhub-thermostat",
> +		.data		= &ssp_thermostat_info,
> +	},
> +};
> +MODULE_DEVICE_TABLE(of, ssp_of_match);
> +
> +static struct ssp_data *ssp_parse_dt(struct device *dev)
> +{
> +	int ret;
> +	struct ssp_data *data;
> +	struct device_node *node = dev->of_node;
> +	const struct of_device_id *match;
> +
> +	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return NULL;
> +
> +	data->mcu_ap_gpio = of_get_named_gpio(node, "mcu-ap-gpio", 0);
> +	if (data->mcu_ap_gpio < 0)
> +		goto err_free_pd;
> +
> +	data->ap_mcu_gpio = of_get_named_gpio(node, "ap-mcu-gpio", 0);
> +	if (data->ap_mcu_gpio < 0)
> +		goto err_free_pd;
> +
This looks a little inconsistent as your previous gpio's have had -gpio
on the end (not saying that's a good idea, but should be the same for all
I would guess).
> +	data->mcu_reset = of_get_named_gpio(node, "mcu-reset", 0);
> +	if (data->mcu_reset < 0)
> +		goto err_free_pd;
> +
> +	ret = devm_gpio_request_one(dev, data->ap_mcu_gpio, GPIOF_OUT_INIT_HIGH,
> +				    "ap-mcu-gpio");
> +	if (ret)
> +		goto err_free_pd;
> +
> +	ret = devm_gpio_request_one(dev, data->mcu_reset, GPIOF_OUT_INIT_HIGH,
> +				    "mcu-reset");
> +	if (ret)
> +		goto err_ap_mcu;
> +
> +	match = of_match_node(ssp_of_match, node);
> +	if (!match)
> +		goto err_mcu_reset;
> +
> +	data->sensorhub_info = (struct ssp_sensorhub_info *)match->data;
> +
> +	dev_set_drvdata(dev, data);
> +
> +	ret = of_platform_populate(node, NULL, NULL, dev);
> +	if (ret < 0) {
> +		dev_err(dev, "of_platform_populate fail\n");
> +		goto err_mcu_reset;
> +	}
> +
> +	return data;
> +
> +err_mcu_reset:
> +	devm_gpio_free(dev, data->mcu_reset);
> +err_ap_mcu:
> +	devm_gpio_free(dev, data->ap_mcu_gpio);
> +err_free_pd:
> +	devm_kfree(dev, data);
> +	return NULL;
> +}
> +#else
> +static struct ssp_data *ssp_parse_dt(struct platform_device *pdev)
> +{
> +	return NULL;
> +}
> +#endif
> +
> +/**
> + * ssp_register_consumer() - registers iio consumer in ssp framework
> + *
> + * @indio_dev:	consumer iio device
> + * @type:	ssp sensor type
> + */
> +void ssp_register_consumer(struct iio_dev *indio_dev, enum ssp_sensor_type type)
> +{
> +	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
That's one uggly way to get to the ssp_data structure.  Perhaps we need
a few macros to make it obvious what we are jumping through?

> +
> +	data->sensor_devs[type] = indio_dev;
> +}
> +EXPORT_SYMBOL(ssp_register_consumer);
> +
> +static int ssp_probe(struct spi_device *spi)
> +{
> +	int ret, i;
> +	struct ssp_data *data;
> +
> +	data = ssp_parse_dt(&spi->dev);
> +	if (!data) {
> +		dev_err(&spi->dev, "Failed to find platform data\n");
> +		return -ENODEV;
> +	}
> +
> +	spi->mode = SPI_MODE_1;
> +	ret = spi_setup(spi);
> +	if (ret < 0) {
> +		dev_err(&spi->dev, "Failed to setup spi in %s\n", __func__);
> +		return ret;
> +	}
> +
> +	data->fw_dl_state = SSP_FW_DL_STATE_NONE;
> +	data->spi = spi;
> +	spi_set_drvdata(spi, data);
> +
> +	mutex_init(&data->comm_lock);
> +	mutex_init(&data->pending_lock);
> +
> +	for (i = 0; i < SSP_SENSOR_MAX; ++i) {
> +		data->delay_buf[i] = SSP_DEFAULT_POLLING_DELAY;
> +		data->batch_latency_buf[i] = 0;
> +		data->batch_opt_buf[i] = 0;
> +		data->check_status[i] = SSP_INITIALIZATION_STATE;
> +	}
> +
> +	data->delay_buf[SSP_BIO_HRM_LIB] = 100;
> +
> +	data->time_syncing = true;
> +
> +	INIT_LIST_HEAD(&data->pending_list);
The ordering in here is perhaps less than ideal. I'd expect to see this
list init next to the mutex that protects it. 
> +
> +	atomic_set(&data->enable_refcount, 0);
> +
> +	INIT_WORK(&data->work_wdt, ssp_wdt_work_func);
> +	INIT_DELAYED_WORK(&data->work_refresh, ssp_refresh_task);
> +
> +	setup_timer(&data->wdt_timer, ssp_wdt_timer_func, (unsigned long)data);
> +
> +	ret = request_threaded_irq(data->spi->irq, NULL,
> +				   sensordata_irq_thread_fn,
> +				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +				   "SSP_Int", data);
> +	if (ret < 0) {
> +		dev_err(&spi->dev, "Irq request fail\n");
> +		goto err_setup_irq;
> +	}
> +
> +	/* Let's start with enabled one so irq balance could be ok */
> +	data->shut_down = false;
> +
> +	/* just to avoid unbalanced irq set wake up */
> +	enable_irq_wake(data->spi->irq);
> +
> +	data->fw_dl_state = ssp_check_fwbl(data);
> +	if (data->fw_dl_state == SSP_FW_DL_STATE_NONE) {
> +		ret = ssp_initialize_mcu(data);
> +		if (ret < 0) {
> +			dev_err(&spi->dev, "Initialize_mcu failed\n");
> +			goto err_read_reg;
> +		}
> +	} else {
> +		dev_err(&spi->dev, "Firmware version not supported\n");
> +		ret = -EPERM;
> +		goto err_read_reg;
> +	}
> +
> +	return 0;
> +
> +err_read_reg:
> +	free_irq(data->spi->irq, data);
> +err_setup_irq:
> +	mutex_destroy(&data->pending_lock);
> +	mutex_destroy(&data->comm_lock);
> +
> +	dev_err(&spi->dev, "Probe failed!\n");
> +
> +	return ret;
> +}
> +
> +static int ssp_remove(struct spi_device *spi)
> +{
> +	struct ssp_data *data = spi_get_drvdata(spi);
> +
> +	if (ssp_command(data, SSP_MSG2SSP_AP_STATUS_SHUTDOWN, 0) < 0)
> +		dev_err(&data->spi->dev, "SSP_MSG2SSP_AP_STATUS_SHUTDOWN failed\n");
> +
> +	ssp_enable_mcu(data, false);
> +	ssp_disable_wdt_timer(data);
> +
> +	ssp_clean_pending_list(data);
> +
> +	free_irq(data->spi->irq, data);
> +
> +	del_timer_sync(&data->wdt_timer);
> +	cancel_work_sync(&data->work_wdt);
> +
> +	mutex_destroy(&data->comm_lock);
> +	mutex_destroy(&data->pending_lock);
> +
> +#ifdef CONFIG_OF
> +	of_platform_depopulate(&spi->dev);
> +#endif
> +
> +	return 0;
> +}
> +
> +static int ssp_suspend(struct device *dev)
> +{
> +	int ret;
> +	struct ssp_data *data = spi_get_drvdata(to_spi_device(dev));
> +
> +	data->last_resume_state = SSP_MSG2SSP_AP_STATUS_SUSPEND;
> +
> +	if (atomic_read(&data->enable_refcount) > 0)
> +		ssp_disable_wdt_timer(data);
> +
> +	ret = ssp_command(data, SSP_MSG2SSP_AP_STATUS_SUSPEND, 0);
> +	if (ret < 0) {
> +		dev_err(&data->spi->dev,
> +			"%s SSP_MSG2SSP_AP_STATUS_SUSPEND failed\n", __func__);
> +
> +		ssp_enable_wdt_timer(data);
> +		return ret;
> +	}
> +
> +	data->time_syncing = false;
> +	disable_irq(data->spi->irq);
> +
> +	return 0;
> +}
> +
> +static int ssp_resume(struct device *dev)
> +{
> +	int ret;
> +	struct ssp_data *data = spi_get_drvdata(to_spi_device(dev));
> +
> +	enable_irq(data->spi->irq);
> +
> +	if (atomic_read(&data->enable_refcount) > 0)
> +		ssp_enable_wdt_timer(data);
> +
> +	ret = ssp_command(data, SSP_MSG2SSP_AP_STATUS_RESUME, 0);
> +	if (ret < 0) {
> +		dev_err(&data->spi->dev,
> +			"%s SSP_MSG2SSP_AP_STATUS_RESUME failed\n", __func__);
> +		ssp_disable_wdt_timer(data);
> +		return ret;
> +	}
> +
> +	/* timesyncing is set by MCU */
> +
> +	data->last_resume_state = SSP_MSG2SSP_AP_STATUS_RESUME;
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops ssp_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(ssp_suspend, ssp_resume)
> +};
> +
> +static struct spi_driver ssp_driver = {
> +	.probe = ssp_probe,
> +	.remove = ssp_remove,
> +	.driver = {
> +		.pm = &ssp_pm_ops,
> +		.bus = &spi_bus_type,
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(ssp_of_match),
> +		.name = "sensorhub"
> +	},
> +};
> +
> +module_spi_driver(ssp_driver);
> +
> +MODULE_DESCRIPTION("ssp sensorhub driver");
> +MODULE_AUTHOR("Samsung Electronics");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/iio/common/ssp_sensors/ssp_spi.c b/drivers/iio/common/ssp_sensors/ssp_spi.c
> new file mode 100644
> index 0000000..44b99bc
> --- /dev/null
> +++ b/drivers/iio/common/ssp_sensors/ssp_spi.c
> @@ -0,0 +1,644 @@
> +/*
> + *  Copyright (C) 2014, Samsung Electronics Co. Ltd. All Rights Reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + */
> +
> +#include "ssp.h"
> +
> +#define SSP_DEV (&data->spi->dev)
> +#define SSP_GET_MESSAGE_TYPE(data) (data & (3 << SSP_RW))
> +
> +/*
> + * SSP -> AP Instruction
> + * They tell what packet type can be expected. In the future there will
> + * be less of them. BYPASS means common sensor packets with accel, gyro,
> + * hrm etc. data. LIBRARY and META are mock-up's for now.
> + */
> +#define SSP_MSG2AP_INST_BYPASS_DATA		0x37
> +#define SSP_MSG2AP_INST_LIBRARY_DATA		0x01
> +#define SSP_MSG2AP_INST_DEBUG_DATA		0x03
> +#define SSP_MSG2AP_INST_BIG_DATA		0x04
> +#define SSP_MSG2AP_INST_META_DATA		0x05
> +#define SSP_MSG2AP_INST_TIME_SYNC		0x06
> +#define SSP_MSG2AP_INST_RESET			0x07
> +
> +#define SSP_UNIMPLEMENTED -1
> +
> +struct ssp_msg_header {
> +	u8 cmd;
> +	__le16 length;
> +	__le16 options;
> +	__le32 data;
> +} __attribute__((__packed__));
> +
> +struct ssp_msg {
> +	u16 length;
> +	u16 options;
> +	struct list_head list;
> +	struct completion *done;
> +	struct ssp_msg_header *h;
> +	char *buffer;
> +};
> +
> +static const int ssp_offset_map[SSP_SENSOR_MAX] = {
> +	[SSP_ACCELEROMETER_SENSOR] =		SSP_ACCELEROMETER_SIZE +
> +						SSP_TIME_SIZE,
> +	[SSP_GYROSCOPE_SENSOR] =		SSP_GYROSCOPE_SIZE +
> +						SSP_TIME_SIZE,
> +	[SSP_GEOMAGNETIC_UNCALIB_SENSOR] =	SSP_UNIMPLEMENTED,
> +	[SSP_GEOMAGNETIC_RAW] =			SSP_UNIMPLEMENTED,
> +	[SSP_GEOMAGNETIC_SENSOR] =		SSP_UNIMPLEMENTED,
> +	[SSP_PRESSURE_SENSOR] =			SSP_UNIMPLEMENTED,
> +	[SSP_GESTURE_SENSOR] =			SSP_UNIMPLEMENTED,
> +	[SSP_PROXIMITY_SENSOR] =		SSP_UNIMPLEMENTED,
> +	[SSP_TEMPERATURE_HUMIDITY_SENSOR] =	SSP_UNIMPLEMENTED,
> +	[SSP_LIGHT_SENSOR] =			SSP_UNIMPLEMENTED,
> +	[SSP_PROXIMITY_RAW] =			SSP_UNIMPLEMENTED,
> +	[SSP_ORIENTATION_SENSOR] =		SSP_UNIMPLEMENTED,
> +	[SSP_STEP_DETECTOR] =			SSP_UNIMPLEMENTED,
> +	[SSP_SIG_MOTION_SENSOR] =		SSP_UNIMPLEMENTED,
> +	[SSP_GYRO_UNCALIB_SENSOR] =		SSP_UNIMPLEMENTED,
> +	[SSP_GAME_ROTATION_VECTOR] =		SSP_UNIMPLEMENTED,
> +	[SSP_ROTATION_VECTOR] =			SSP_UNIMPLEMENTED,
> +	[SSP_STEP_COUNTER] =			SSP_UNIMPLEMENTED,
> +	[SSP_BIO_HRM_RAW] =			SSP_BIO_HRM_RAW_SIZE +
> +						SSP_TIME_SIZE,
> +	[SSP_BIO_HRM_RAW_FAC] =			SSP_BIO_HRM_RAW_FAC_SIZE +
> +						SSP_TIME_SIZE,
> +	[SSP_BIO_HRM_LIB] =			SSP_BIO_HRM_LIB_SIZE +
> +						SSP_TIME_SIZE,
> +};
> +
> +#define SSP_HEADER_SIZE		(sizeof(struct ssp_msg_header))
> +#define SSP_HEADER_SIZE_ALIGNED	(ALIGN(SSP_HEADER_SIZE, 4))
> +
It strikes me that you do a lot of allocating and freeing of the buffers
in here.  Whilst this is fine, perhaps preallocating space in your
ssp_data (making sure to enforce cache alignment) would be simpler
and quicker?  That is the common way to avoid allocating spi buffers
on every transaction.

You could perhaps even roll the message header stuff etc into ssp_spi_sync?
(I haven't yet looked at that many call sites so that might not make sense!)
Would cut down on the boiler plate in the short functions towards the
end of this patch.
> +static struct ssp_msg *ssp_create_msg(u8 cmd, u16 len, u16 opt, u32 data)
> +{
> +	struct ssp_msg_header h;
> +	struct ssp_msg *msg;
> +
> +	msg = kzalloc(sizeof(*msg), GFP_KERNEL);
> +	if (!msg)
> +		return NULL;
> +
> +	h.cmd = cmd;
> +	h.length = cpu_to_le16(len);
> +	h.options = cpu_to_le16(opt);
> +	h.data = cpu_to_le32(data);
> +
> +	msg->buffer = kzalloc(SSP_HEADER_SIZE_ALIGNED + len,
> +			      GFP_KERNEL | GFP_DMA);
> +	if (!msg->buffer) {
> +		kfree(msg);
> +		return NULL;
> +	}
> +
> +	msg->length = len;
> +	msg->options = opt;
> +
> +	memcpy(msg->buffer, &h, SSP_HEADER_SIZE);
> +
> +	return msg;
> +}
> +
> +static inline void ssp_fill_buffer(struct ssp_msg *m, unsigned int offset,
> +				   const void *src, unsigned int len)
> +{
> +	memcpy(&m->buffer[SSP_HEADER_SIZE_ALIGNED + offset], src, len);

These seem a little heavy handed. Could you do this by getting a pointer
to the appropriate location instead?  That way you'll often save on the
memory copies.  Not that they are that extensive.

> +}
> +
> +static inline void ssp_get_buffer(struct ssp_msg *m, unsigned int offset,
> +				  void *dest, unsigned int len)
> +{
> +	memcpy(dest, &m->buffer[SSP_HEADER_SIZE_ALIGNED + offset],  len);
> +}
> +
> +#define ssp_get_buffer_AT_INDEX(m, index) \
> +	(m->buffer[SSP_HEADER_SIZE_ALIGNED + index])
Novel mixture of upper and lower case.  Please go with upper.
> +#define SSP_SET_BUFFER_AT_INDEX(m, index, val) \
> +	(m->buffer[SSP_HEADER_SIZE_ALIGNED + index] = val)
> +
> +static void ssp_clean_msg(struct ssp_msg *m)
> +{
> +	kfree(m->buffer);
> +	kfree(m);
> +}
> +
> +static int ssp_print_mcu_debug(char *data_frame, int *data_index,
> +			       int received_len)
> +{
> +	int length = data_frame[(*data_index)++];
> +
> +	if (length > received_len - *data_index || length <= 0) {
> +		ssp_dbg("[SSP]: MSG From MCU-invalid debug length(%d/%d)\n",
> +			length, received_len);
> +		return length ? length : -EPROTO;
> +	}
> +
> +	ssp_dbg("[SSP]: MSG From MCU - %s\n", &data_frame[*data_index]);
> +
> +	*data_index += length;
> +
> +	return 0;
> +}
> +
> +/*
> + * It was designed that way - additional lines to some kind of handshake,
> + * please do not ask why - only the firmware guy can know it.
Indeed crazy.
> + */
> +static int ssp_check_lines(struct ssp_data *data, bool state)
> +{
> +	int delay_cnt = 0;
> +
> +	gpio_set_value_cansleep(data->ap_mcu_gpio, state);
> +
> +	while (gpio_get_value_cansleep(data->mcu_ap_gpio) != state) {
> +		usleep_range(3000, 3500);
> +
> +		if (data->shut_down || delay_cnt++ > 500) {
> +			dev_err(SSP_DEV, "%s:timeout, hw ack wait fail %d\n",
> +				__func__, state);
> +
> +			if (!state)
> +				gpio_set_value_cansleep(data->ap_mcu_gpio, 1);
> +
> +			return -ETIMEDOUT;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int ssp_do_transfer(struct ssp_data *data, struct ssp_msg *msg,
> +			   struct completion *done, int timeout)
> +{
> +	int status;
> +	/*
> +	 * check if this is a short one way message or the whole transfer has
> +	 * second part after an interrupt
> +	 */
> +	const bool use_no_irq = msg->length == 0;

I wonder if you'd be better off having a separate short_write function.
Might take a line or two more code, but would make it a little clearer
what is going on and simplify the code flow in this function a fair bit.

> +
> +	if (data->shut_down)
> +		return -EPERM;
> +
> +	msg->done = done;
> +
> +	mutex_lock(&data->comm_lock);
> +
> +	status = ssp_check_lines(data, false);
> +	if (status < 0)
> +		goto _error_locked;
> +
> +	status = spi_write(data->spi, msg->buffer, SSP_HEADER_SIZE);
> +	if (status < 0) {
> +		gpio_set_value_cansleep(data->ap_mcu_gpio, 1);
> +		dev_err(SSP_DEV, "%s spi_write fail\n", __func__);
> +		goto _error_locked;
> +	}
> +
> +	if (!use_no_irq) {
> +		mutex_lock(&data->pending_lock);
> +		list_add_tail(&msg->list, &data->pending_list);
> +		mutex_unlock(&data->pending_lock);
> +	}
> +
> +	status = ssp_check_lines(data, true);
> +	if (status < 0) {
> +		if (!use_no_irq) {
> +			mutex_lock(&data->pending_lock);
> +			list_del(&msg->list);
> +			mutex_unlock(&data->pending_lock);
> +		}
> +		goto _error_locked;
> +	}
> +
> +	mutex_unlock(&data->comm_lock);
> +
> +	if (!use_no_irq && done)
> +		if (wait_for_completion_timeout(done,
> +						msecs_to_jiffies(timeout)) ==
> +		    0) {
> +			mutex_lock(&data->pending_lock);
> +			list_del(&msg->list);
> +			mutex_unlock(&data->pending_lock);
> +
> +			data->timeout_cnt++;
> +			return -ETIMEDOUT;
> +		}
> +
> +	return 0;
> +
> +_error_locked:
> +	mutex_unlock(&data->comm_lock);
> +	data->timeout_cnt++;
> +	return status;
> +}
> +
> +static inline int ssp_spi_sync_command(struct ssp_data *data,
> +				       struct ssp_msg *msg)
> +{
> +	return ssp_do_transfer(data, msg, NULL, 0);
> +}
> +
> +static int ssp_spi_sync(struct ssp_data *data, struct ssp_msg *msg,
> +			int timeout)
> +{
> +	DECLARE_COMPLETION_ONSTACK(done);
> +
> +	if (WARN_ON(!msg->length))
> +		return -EPERM;
> +
> +	return ssp_do_transfer(data, msg, &done, timeout);
> +}
> +
> +static int ssp_handle_big_data(struct ssp_data *data, char *dataframe, int *idx)
> +{
> +	/* mock-up, it will be changed with adding another sensor types */
> +	*idx += 8;
> +	return 0;
> +}
> +
> +static int ssp_parse_dataframe(struct ssp_data *data, char *dataframe, int len)
> +{
> +	int idx, sd;
> +	struct timespec ts;
> +	struct ssp_sensor_data *spd;
> +	struct iio_dev **indio_devs = data->sensor_devs;
> +
> +	getnstimeofday(&ts);
> +
> +	for (idx = 0; idx < len;) {
> +		switch (dataframe[idx++]) {
> +		case SSP_MSG2AP_INST_BYPASS_DATA:
> +			sd = dataframe[idx++];
> +			if (sd < 0 || sd >= SSP_SENSOR_MAX) {
> +				dev_err(SSP_DEV,
> +					"Mcu data frame1 error %d\n", sd);
> +				return -EPROTO;
> +			}
> +
> +			if (indio_devs[sd]) {
> +				spd = iio_priv(indio_devs[sd]);
> +				if (spd->process_data)
> +					spd->process_data(indio_devs[sd],
> +							    &dataframe[idx],
> +							    data->timestamp);
> +			} else {
> +				dev_err(SSP_DEV, "no client for frame\n");
> +			}
> +
> +			idx += ssp_offset_map[sd];
> +			break;
> +		case SSP_MSG2AP_INST_DEBUG_DATA:
> +			sd = ssp_print_mcu_debug(dataframe, &idx, len);
> +			if (sd) {
> +				dev_err(SSP_DEV,
> +					"Mcu data frame3 error %d\n", sd);
> +				return sd;
> +			}
> +			break;
> +		case SSP_MSG2AP_INST_LIBRARY_DATA:
> +			idx += len;
That looks fun.  What the heck is library data?  Just curious ;)
> +			break;
> +		case SSP_MSG2AP_INST_BIG_DATA:
> +			ssp_handle_big_data(data, dataframe, &idx);
> +			break;
> +		case SSP_MSG2AP_INST_TIME_SYNC:
> +			data->time_syncing = true;
> +			break;
> +		case SSP_MSG2AP_INST_RESET:
> +			ssp_queue_ssp_refresh_task(data, 0);
> +			break;
> +		}
> +	}
> +
> +	if (data->time_syncing)
> +		data->timestamp = ts.tv_sec * 1000000000ULL + ts.tv_nsec;
> +
> +	return 0;
> +}
> +
> +/* threaded irq */
> +int ssp_irq_msg(struct ssp_data *data)
> +{
> +	bool found = false;
> +	char *buffer;
> +	__le16 *temp_buf;
> +	u8 msg_type;
> +	int ret;
> +	u16 length, msg_options;
> +	struct ssp_msg *msg, *n;
> +
> +	temp_buf = kmalloc(4, GFP_KERNEL | GFP_DMA);
> +	if (!temp_buf)
> +		return -ENOMEM;
I'd poke this buffer in to ssp_data to avoid the need to allocate
it in this which is a moderately fast path.  Remember to cacheline align
it.
> +
> +	ret = spi_read(data->spi, temp_buf, 4);
> +	if (ret < 0) {
> +		dev_err(SSP_DEV, "header read fail\n");
> +		kfree(temp_buf);
> +		return ret;
> +	}
> +
> +	length = le16_to_cpu(temp_buf[1]);
> +	msg_options = le16_to_cpu(temp_buf[0]);
> +
> +	kfree(temp_buf);
> +
> +	if (length == 0) {
> +		dev_err(SSP_DEV, "length received from mcu is 0\n");
> +		return -EINVAL;
> +	}
> +
> +	msg_type = SSP_GET_MESSAGE_TYPE(msg_options);
> +
> +	switch (msg_type) {
> +	case SSP_AP2HUB_READ:
> +	case SSP_AP2HUB_WRITE:
> +		/*
> +		 * this is a small list, a few elements - the packets can be
> +		 * received with no order
Ouch.
> +		 */
> +		mutex_lock(&data->pending_lock);
> +		list_for_each_entry_safe(msg, n, &data->pending_list, list) {
> +			if (msg->options == msg_options) {
> +				list_del(&msg->list);
> +				found = true;
> +				break;
> +			}
> +		}
> +
> +		if (!found) {
> +			/*
> +			 * here can be implemented dead messages handling
> +			 * but the slave should not send such ones - it is to
> +			 * check but let's handle this
> +			 */
> +			buffer = kmalloc(length, GFP_KERNEL | GFP_DMA);
> +			if (!buffer) {
> +				ret = -ENOMEM;
> +				goto _unlock;
> +			}
> +
> +			/* got dead packet so it is always an error */
> +			ret = spi_read(data->spi, buffer, length);
> +			if (ret >= 0)
> +				ret = -EPROTO;
> +
> +			kfree(buffer);
> +
> +			dev_err(SSP_DEV, "No match error %x\n",
> +				msg_options);
> +
> +			goto _unlock;
> +		}
> +
> +		if (msg_type == SSP_AP2HUB_READ)
> +			ret = spi_read(data->spi,
> +				       &msg->buffer[SSP_HEADER_SIZE_ALIGNED],
> +				       msg->length);
> +
> +		if (msg_type == SSP_AP2HUB_WRITE) {
> +			ret = spi_write(data->spi,
> +					&msg->buffer[SSP_HEADER_SIZE_ALIGNED],
> +					msg->length);
> +			if (msg_options & SSP_AP2HUB_RETURN) {
> +				msg->options =
> +					SSP_AP2HUB_READ | SSP_AP2HUB_RETURN;
> +				msg->length = 1;
> +
> +				list_add_tail(&msg->list, &data->pending_list);
> +				goto _unlock;
> +			}
> +		}
> +
> +		if (msg->done)
> +			if (!completion_done(msg->done))
> +				complete(msg->done);
> +_unlock:
> +		mutex_unlock(&data->pending_lock);
> +		break;
> +	case SSP_HUB2AP_WRITE:
> +		buffer = kzalloc(length, GFP_KERNEL | GFP_DMA);
> +		if (!buffer)
> +			return -ENOMEM;
> +
> +		ret = spi_read(data->spi, buffer, length);
> +		if (ret < 0) {
> +			dev_err(SSP_DEV, "spi read fail\n");
> +			kfree(buffer);
> +			break;
> +		}
> +
> +		ret = ssp_parse_dataframe(data, buffer, length);
> +
> +		kfree(buffer);
> +		break;
> +
> +	default:
> +		dev_err(SSP_DEV, "unknown msg type\n");
> +		return -EPROTO;
> +	}
> +
> +	return ret;
> +}
> +
> +void ssp_clean_pending_list(struct ssp_data *data)
> +{
> +	struct ssp_msg *msg, *n;
> +
> +	mutex_lock(&data->pending_lock);
> +	list_for_each_entry_safe(msg, n, &data->pending_list, list) {
> +		list_del(&msg->list);
> +
> +		if (msg->done)
> +			if (!completion_done(msg->done))
> +				complete(msg->done);
> +	}
> +	mutex_unlock(&data->pending_lock);
> +}
> +
> +int ssp_command(struct ssp_data *data, char command, int arg)
> +{
> +	int ret;
> +	struct ssp_msg *msg;
> +
> +	msg = ssp_create_msg(command, 0, SSP_AP2HUB_WRITE, arg);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	ssp_dbg("%s - command 0x%x %d\n", __func__, command, arg);
> +
> +	ret = ssp_spi_sync_command(data, msg);
> +	ssp_clean_msg(msg);
> +
> +	return ret;
> +}
> +
> +int ssp_send_instruction(struct ssp_data *data, u8 inst, u8 sensor_type,
> +			 u8 *send_buf, u8 length)
> +{
> +	int ret;
> +	struct ssp_msg *msg;
> +
> +	if (data->fw_dl_state == SSP_FW_DL_STATE_DOWNLOADING) {
> +		dev_err(SSP_DEV, "%s - Skip Inst! DL state = %d\n",
> +			__func__, data->fw_dl_state);
> +		return -EBUSY;
> +	} else if (!(data->available_sensors & BIT(sensor_type)) &&
> +		   (inst <= SSP_MSG2SSP_INST_CHANGE_DELAY)) {
> +		dev_err(SSP_DEV, "%s - Bypass Inst Skip! - %u\n",
> +			__func__, sensor_type);
> +		return -EIO; /* just fail */
> +	}
> +
> +	msg = ssp_create_msg(inst, length + 2, SSP_AP2HUB_WRITE, 0);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	ssp_fill_buffer(msg, 0, &sensor_type, 1);
> +	ssp_fill_buffer(msg, 1, send_buf, length);
> +
> +	ssp_dbg("%s - Inst = 0x%x, Sensor Type = 0x%x, data = %u\n",
> +		__func__, inst, sensor_type, send_buf[1]);
> +
> +	ret = ssp_spi_sync(data, msg, 1000);
> +	ssp_clean_msg(msg);
> +
> +	return ret;
> +}
> +
> +int ssp_get_chipid(struct ssp_data *data)
> +{
> +	int ret;
> +	char buffer;
> +	struct ssp_msg *msg;
> +
> +	msg = ssp_create_msg(SSP_MSG2SSP_AP_WHOAMI, 1, SSP_AP2HUB_READ, 0);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	ret = ssp_spi_sync(data, msg, 1000);
> +
> +	buffer = ssp_get_buffer_AT_INDEX(msg, 0);
> +
> +	ssp_clean_msg(msg);
> +
> +	return ret < 0 ? ret : buffer;
> +}
> +
Perhaps some comments on what these functions are actually doing?  I have
several ideas what a set_sensor_position function, might be doing :)
Ah, I see from your comments that you don't know what it is doing either ;)
> +int ssp_set_sensor_position(struct ssp_data *data)
> +{
> +	int ret;
> +
> +	struct ssp_msg *msg = ssp_create_msg(SSP_MSG2SSP_AP_SENSOR_FORMATION, 3,
> +					 SSP_AP2HUB_WRITE, 0);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	/*
> +	 * this needs some clarification with the protocol, default they will
> +	 * be 0 so it is ok
> +	 */
> +	SSP_SET_BUFFER_AT_INDEX(msg, 0, data->accel_position);
> +	SSP_SET_BUFFER_AT_INDEX(msg, 1, data->accel_position);
> +	SSP_SET_BUFFER_AT_INDEX(msg, 2, data->mag_position);
> +
> +	ret = ssp_spi_sync(data, msg, 1000);
> +	if (ret < 0) {
> +		dev_err(SSP_DEV, "%s - fail to ssp_set_sensor_position %d\n",
> +			__func__, ret);
> +	} else {
> +		dev_info(SSP_DEV,
> +			 "Sensor Position A : %u, G : %u, M: %u, P: %u\n",
> +			 data->accel_position, data->accel_position,
> +			 data->mag_position, 0);
> +	}
> +
> +	ssp_clean_msg(msg);
> +
> +	return ret;
> +}
> +
> +int ssp_set_magnetic_matrix(struct ssp_data *data)
> +{
> +	int ret;
> +	struct ssp_msg *msg;
> +
> +	msg = ssp_create_msg(SSP_MSG2SSP_AP_SET_MAGNETIC_STATIC_MATRIX,
> +			     data->sensorhub_info->mag_length, SSP_AP2HUB_WRITE,
> +			     0);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	ssp_fill_buffer(msg, 0, data->sensorhub_info->mag_table,
> +			data->sensorhub_info->mag_length);
> +
> +	ret = ssp_spi_sync(data, msg, 1000);
> +	ssp_clean_msg(msg);
> +
> +	return ret;
> +}
> +
> +unsigned int ssp_get_sensor_scanning_info(struct ssp_data *data)
> +{
> +	int ret;
> +	__le32 result;
> +	u32 cpu_result = 0;
> +
> +	struct ssp_msg *msg = ssp_create_msg(SSP_MSG2SSP_AP_SENSOR_SCANNING, 4,
> +					     SSP_AP2HUB_READ, 0);
> +	if (!msg)
> +		return 0;
> +
> +	ret = ssp_spi_sync(data, msg, 1000);
> +	if (ret < 0) {
> +		dev_err(SSP_DEV, "%s - spi read fail %d\n", __func__, ret);
> +		goto _exit;
> +	}
> +
> +	ssp_get_buffer(msg, 0, &result, 4);
> +	cpu_result = le32_to_cpu(result);
> +
> +	dev_info(SSP_DEV, "%s state: 0x%08x\n", __func__, cpu_result);
> +
> +_exit:
> +	ssp_clean_msg(msg);
> +	return cpu_result;
> +}
> +
> +unsigned int ssp_get_firmware_rev(struct ssp_data *data)
> +{
> +	int ret;
> +	__le32 result;
> +
> +	struct ssp_msg *msg = ssp_create_msg(SSP_MSG2SSP_AP_FIRMWARE_REV, 4,
> +					 SSP_AP2HUB_READ, 0);
> +	if (!msg)
> +		return SSP_INVALID_REVISION;
> +
> +	ret = ssp_spi_sync(data, msg, 1000);
> +	ssp_get_buffer(msg, 0, &result, 4);
Seems a little odd to get the buffer before checking the return value.
Is there a reason for this that I'm missing.  If not please reorder.

> +	if (ret < 0) {
> +		dev_err(SSP_DEV, "%s - transfer fail %d\n", __func__, ret);
> +		ret = SSP_INVALID_REVISION;
> +		goto _exit;
> +	}
> +
> +	ret = le32_to_cpu(result);
> +
> +_exit:
> +	ssp_clean_msg(msg);
> +	return ret;
> +}
> diff --git a/include/linux/iio/common/ssp_sensors.h b/include/linux/iio/common/ssp_sensors.h
> new file mode 100644
> index 0000000..c6001e9
> --- /dev/null
> +++ b/include/linux/iio/common/ssp_sensors.h
> @@ -0,0 +1,80 @@
> +/*
> + *  Copyright (C) 2014, Samsung Electronics Co. Ltd. All Rights Reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + */
> +#ifndef _SSP_SENSORS_H_
> +#define _SSP_SENSORS_H_
> +
> +#include <linux/iio/iio.h>
> +
> +#define SSP_TIME_SIZE				4
> +#define SSP_ACCELEROMETER_SIZE			6
> +#define SSP_GYROSCOPE_SIZE			6
> +#define SSP_BIO_HRM_RAW_SIZE			8
> +#define SSP_BIO_HRM_RAW_FAC_SIZE		36
> +#define SSP_BIO_HRM_LIB_SIZE			8
> +
> +/**
> + * enum ssp_sensor_type - SSP sensor type
> + */
> +enum ssp_sensor_type {
> +	SSP_ACCELEROMETER_SENSOR = 0,
> +	SSP_GYROSCOPE_SENSOR,
> +	SSP_GEOMAGNETIC_UNCALIB_SENSOR,
> +	SSP_GEOMAGNETIC_RAW,
> +	SSP_GEOMAGNETIC_SENSOR,
> +	SSP_PRESSURE_SENSOR,
> +	SSP_GESTURE_SENSOR,
> +	SSP_PROXIMITY_SENSOR,
> +	SSP_TEMPERATURE_HUMIDITY_SENSOR,
> +	SSP_LIGHT_SENSOR,
> +	SSP_PROXIMITY_RAW,
> +	SSP_ORIENTATION_SENSOR,
> +	SSP_STEP_DETECTOR,
> +	SSP_SIG_MOTION_SENSOR,
> +	SSP_GYRO_UNCALIB_SENSOR,
> +	SSP_GAME_ROTATION_VECTOR,
> +	SSP_ROTATION_VECTOR,
> +	SSP_STEP_COUNTER,
> +	SSP_BIO_HRM_RAW,
> +	SSP_BIO_HRM_RAW_FAC,
> +	SSP_BIO_HRM_LIB,
> +	SSP_SENSOR_MAX,
> +};
Just looking at this list, I guess one or two won't ultimately fit
in IIO, but the majority will (and we already do similar to this
with the hid-sensors driver which supports the odd thing outside
IIO).
> +
> +struct ssp_data;
> +
> +/**
> + * struct ssp_sensor_data - Sensor object
> + * @process_data:	Callback to feed sensor data.
> + * @type:		Used sensor type.
> + */
> +struct ssp_sensor_data {
> +	int (*process_data)(struct iio_dev *indio_dev, void *buf,
> +			    int64_t timestamp);
> +	enum ssp_sensor_type type;
> +};
> +
> +void ssp_register_consumer(struct iio_dev *indio_dev,
> +			   enum ssp_sensor_type type);
> +
> +int ssp_enable_sensor(struct ssp_data *data, enum ssp_sensor_type type,
> +		      u32 delay);
> +
> +int ssp_disable_sensor(struct ssp_data *data, enum ssp_sensor_type type);
> +
> +u32 ssp_get_sensor_delay(struct ssp_data *data, enum ssp_sensor_type);
> +
> +int ssp_change_delay(struct ssp_data *data, enum ssp_sensor_type type,
> +		     u32 delay);
> +#endif /* _SSP_SENSORS_H_ */
> 

