Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaINPnI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:43:08 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55084 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaINPnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:43:04 -0400
Message-ID: <5415B781.9010701@kernel.org>
Date: Sun, 14 Sep 2014 16:42:57 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 2/6] misc: sensorhub: Add sensorhub driver
References: <1409756150-30889-1-git-send-email-k.wrona@samsung.com> <1409756150-30889-3-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1409756150-30889-3-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 15:55, Karol Wrona wrote:
> Sensorhub  is MCU dedicated to collect data and manage several sensors.
> Sensorhub is a spi device which provides a layer for IIO devices. It provides
> some data parsing and common mechanism for sensorhub sensors.
>
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

General comments

* Please use a prefix for pretty much everything as it will avoid possible
  name clashes in future.  This is particularly true for anything that isn't
  static, but applies to all function names and definitions etc.
  ssp_ and SSP_ would be the obvious choices.
* Never do spi transfers using data that can share a cacheline with anything
  else.  Some places in this driver may be fine, but others are definitely not.
* The firmware loader looks like it might be a generic stm32 boatloader
  firmware interface.  If so should probably be factored out so as to allow
  other devices to use it.

A fair number of little bits inline.

This is a complex part, and on the whole your driver is reasonably
easy to follow so keep up the good work!

Jonathan

> ---
>  drivers/misc/Kconfig                  |    1 +
>  drivers/misc/Makefile                 |    1 +
>  drivers/misc/sensorhub/Kconfig        |   13 +
>  drivers/misc/sensorhub/Makefile       |    8 +
>  drivers/misc/sensorhub/ssp.h          |  323 ++++++++++++++
>  drivers/misc/sensorhub/ssp_data.c     |   61 +++
>  drivers/misc/sensorhub/ssp_dev.c      |  782 +++++++++++++++++++++++++++++++++
>  drivers/misc/sensorhub/ssp_firmware.c |  571 ++++++++++++++++++++++++
>  drivers/misc/sensorhub/ssp_spi.c      |  700 +++++++++++++++++++++++++++++
>  9 files changed, 2460 insertions(+)
>  create mode 100644 drivers/misc/sensorhub/Kconfig
>  create mode 100644 drivers/misc/sensorhub/Makefile
>  create mode 100644 drivers/misc/sensorhub/ssp.h
>  create mode 100644 drivers/misc/sensorhub/ssp_data.c
>  create mode 100644 drivers/misc/sensorhub/ssp_dev.c
>  create mode 100644 drivers/misc/sensorhub/ssp_firmware.c
>  create mode 100644 drivers/misc/sensorhub/ssp_spi.c
>
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index b841180..faf8521 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -527,4 +527,5 @@ source "drivers/misc/vmw_vmci/Kconfig"
>  source "drivers/misc/mic/Kconfig"
>  source "drivers/misc/genwqe/Kconfig"
>  source "drivers/misc/echo/Kconfig"
> +source "drivers/misc/sensorhub/Kconfig"
>  endmenu
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 5497d02..9c36078 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -55,3 +55,4 @@ obj-y				+= mic/
>  obj-$(CONFIG_GENWQE)		+= genwqe/
>  obj-$(CONFIG_ECHO)		+= echo/
>  obj-$(CONFIG_VEXPRESS_SYSCFG)	+= vexpress-syscfg.o
> +obj-$(CONFIG_SENSORS_SSP)	+= sensorhub/
> diff --git a/drivers/misc/sensorhub/Kconfig b/drivers/misc/sensorhub/Kconfig
> new file mode 100644
> index 0000000..0af30ec
> --- /dev/null
> +++ b/drivers/misc/sensorhub/Kconfig
> @@ -0,0 +1,13 @@
> +#
> +# sensor drivers configuration
> +#
> +config SENSORS_SSP
> +	tristate "Sensors ssp"
> +	default n
> +	depends on SPI
> +	help
> +	  SSP driver for sensor hub.
> +	  If you say yes here you get ssp support for
> +	  sensor hub.
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ssp_dev.
> diff --git a/drivers/misc/sensorhub/Makefile b/drivers/misc/sensorhub/Makefile
> new file mode 100644
> index 0000000..754da8b
> --- /dev/null
> +++ b/drivers/misc/sensorhub/Makefile
> @@ -0,0 +1,8 @@
> +#
> +# Makefile for the sensor drivers.
> +#
> +
> +# Each configuration option enables a list of files.
> +obj-$(CONFIG_SENSORS_SSP)		+= ssp_dev.o ssp_spi.o ssp_data.o \
> +					   ssp_firmware.o
> +
> diff --git a/drivers/misc/sensorhub/ssp.h b/drivers/misc/sensorhub/ssp.h
> new file mode 100644
> index 0000000..c49f958
> --- /dev/null
> +++ b/drivers/misc/sensorhub/ssp.h
> @@ -0,0 +1,323 @@
> +/*
> + *  Copyright (C) 2011, Samsung Electronics Co. Ltd. All Rights Reserved.
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
> +#include <linux/gpio.h>
> +#include <linux/delay.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/spi/spi.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/common/ssp_sensors.h>
> +
> +#define DEVICE_ID		0x55
> +
> +#ifdef SSP_DBG
> +#define ssp_info(fmt, ...) pr_info("[SSP] "fmt, ##__VA_ARGS__)
> +
> +#define ssp_dbg(format, ...) pr_info("[SSP] "format, ##__VA_ARGS__)
> +#else
> +#define ssp_info(fmt, ...)
> +
> +#define ssp_dbg(format, ...)
> +#endif
> +
> +#define SSP_SW_RESET_TIME	3000
> +/* Sensor polling in ms */
> +#define DEFUALT_POLLING_DELAY	200
> +#define DEFAULT_RETRIES		3
> +#define DATA_PACKET_SIZE	960
> +
> +enum {
> +	KERNEL_BINARY = 0,
> +	KERNEL_CRASHED_BINARY,
> +};
> +
> +enum {
> +	INITIALIZATION_STATE = 0,
> +	NO_SENSOR_STATE,
> +	ADD_SENSOR_STATE,
> +	RUNNING_SENSOR_STATE,
> +};
> +
> +/* Firmware download STATE */
> +enum {
> +	FW_DL_STATE_FAIL = -1,
> +	FW_DL_STATE_NONE = 0,
> +	FW_DL_STATE_NEED_TO_SCHEDULE,
> +	FW_DL_STATE_SCHEDULED,
> +	FW_DL_STATE_DOWNLOADING,
> +	FW_DL_STATE_SYNC,
> +	FW_DL_STATE_DONE,
> +};
> +
> +#define SSP_INVALID_REVISION	99999
> +#define SSP_INVALID_REVISION2	0xFFFFFF
> +
> +/* AP -> SSP Instruction */
> +#define MSG2SSP_INST_BYPASS_SENSOR_ADD		0xA1
> +#define MSG2SSP_INST_BYPASS_SENSOR_REMOVE	0xA2
> +#define MSG2SSP_INST_REMOVE_ALL			0xA3
> +#define MSG2SSP_INST_CHANGE_DELAY		0xA4
> +#define MSG2SSP_INST_LIBRARY_ADD		0xB1
> +#define MSG2SSP_INST_LIBRARY_REMOVE		0xB2
> +#define MSG2SSP_INST_LIB_NOTI			0xB4
> +#define MSG2SSP_INST_LIB_DATA			0xC1
> +
> +#define MSG2SSP_AP_MCU_SET_GYRO_CAL		0xCD
> +#define MSG2SSP_AP_MCU_SET_ACCEL_CAL		0xCE
> +#define MSG2SSP_AP_STATUS_SHUTDOWN		0xD0
> +#define MSG2SSP_AP_STATUS_WAKEUP		0xD1
> +#define MSG2SSP_AP_STATUS_SLEEP			0xD2
> +#define MSG2SSP_AP_STATUS_RESUME		0xD3
> +#define MSG2SSP_AP_STATUS_SUSPEND		0xD4
> +#define MSG2SSP_AP_STATUS_RESET			0xD5
> +#define MSG2SSP_AP_STATUS_POW_CONNECTED		0xD6
> +#define MSG2SSP_AP_STATUS_POW_DISCONNECTED	0xD7
> +#define MSG2SSP_AP_TEMPHUMIDITY_CAL_DONE	0xDA
> +#define MSG2SSP_AP_MCU_SET_DUMPMODE		0xDB
> +#define MSG2SSP_AP_MCU_DUMP_CHECK		0xDC
> +#define MSG2SSP_AP_MCU_BATCH_FLUSH		0xDD
> +#define MSG2SSP_AP_MCU_BATCH_COUNT		0xDF
> +
> +#define MSG2SSP_AP_WHOAMI			0x0F
> +#define MSG2SSP_AP_FIRMWARE_REV			0xF0
> +#define MSG2SSP_AP_SENSOR_FORMATION		0xF1
> +#define MSG2SSP_AP_SENSOR_PROXTHRESHOLD		0xF2
> +#define MSG2SSP_AP_SENSOR_BARCODE_EMUL		0xF3
> +#define MSG2SSP_AP_SENSOR_SCANNING		0xF4
> +#define MSG2SSP_AP_SET_MAGNETIC_HWOFFSET	0xF5
> +#define MSG2SSP_AP_GET_MAGNETIC_HWOFFSET	0xF6
> +#define MSG2SSP_AP_SENSOR_GESTURE_CURRENT	0xF7
> +#define MSG2SSP_AP_GET_THERM			0xF8
> +#define MSG2SSP_AP_GET_BIG_DATA			0xF9
> +#define MSG2SSP_AP_SET_BIG_DATA			0xFA
> +#define MSG2SSP_AP_START_BIG_DATA		0xFB
> +#define MSG2SSP_AP_SET_MAGNETIC_STATIC_MATRIX	0xFD
> +#define MSG2SSP_AP_SENSOR_TILT			0xEA
> +#define MSG2SSP_AP_MCU_SET_TIME			0xFE
> +#define MSG2SSP_AP_MCU_GET_TIME			0xFF
> +
> +#define MSG2SSP_AP_FUSEROM			0X01
> +/* voice data */
> +#define TYPE_WAKE_UP_VOICE_SERVICE		0x01
> +#define TYPE_WAKE_UP_VOICE_SOUND_SOURCE_AM	0x01
> +#define TYPE_WAKE_UP_VOICE_SOUND_SOURCE_GRAMMER	0x02
> +
> +/* Factory Test */
> +#define ACCELEROMETER_FACTORY			0x80
> +#define GYROSCOPE_FACTORY			0x81
> +#define GEOMAGNETIC_FACTORY			0x82
> +#define PRESSURE_FACTORY			0x85
> +#define GESTURE_FACTORY				0x86
> +#define TEMPHUMIDITY_CRC_FACTORY		0x88
> +#define GYROSCOPE_TEMP_FACTORY			0x8A
> +#define GYROSCOPE_DPS_FACTORY			0x8B
> +#define MCU_FACTORY				0x8C
> +#define MCU_SLEEP_FACTORY			0x8D
> +
> +/* Factory data length */
> +#define ACCEL_FACTORY_DATA_LENGTH		1
> +#define GYRO_FACTORY_DATA_LENGTH		36
> +#define MAGNETIC_FACTORY_DATA_LENGTH		26
> +#define PRESSURE_FACTORY_DATA_LENGTH		1
> +#define MCU_FACTORY_DATA_LENGTH			5
Interesting spacing.
> +#define	GYRO_TEMP_FACTORY_DATA_LENGTH		2
> +#define	GYRO_DPS_FACTORY_DATA_LENGTH		1
> +#define TEMPHUMIDITY_FACTORY_DATA_LENGTH	1
> +#define MCU_SLEEP_FACTORY_DATA_LENGTH		FACTORY_DATA_MAX
> +#define GESTURE_FACTORY_DATA_LENGTH		4
> +
> +/* SSP -> AP ACK about write CMD */
> +#define MSG_ACK		0x80	/* ACK from SSP to AP */
> +#define MSG_NAK		0x70	/* NAK from SSP to AP */
> +
> +/* Accelerometer sensor*/
> +/* 16bits */
> +#define MAX_ACCEL_1G	16384
> +#define MAX_ACCEL_2G	32767
> +#define MIN_ACCEL_2G	-32768
We have min for 2G but not 1G or 4G?
> +#define MAX_ACCEL_4G	65536
> +
> +#define MAX_GYRO	32767
> +#define MIN_GYRO	-32768
> +
> +struct sensorhub_info {
> +	char *fw_name;
> +	char *fw_crashed_name;
> +	unsigned int fw_rev;
> +};
> +
> +struct calibraion_data {
> +	s16 x;
> +	s16 y;
> +	s16 z;
> +};
> +
> +/* ssp_msg options bit*/
> +#define SSP_SPI		0	/* read write mask */
> +#define SSP_RETURN	2	/* write and read option */
> +#define SSP_GYRO_DPS	3	/* gyro dps mask */
> +#define SSP_INDEX	3	/* data index mask */
> +
> +#define SSP_SPI_MASK		(3 << SSP_SPI)	/* read write mask */
> +#define SSP_GYRO_DPS_MASK	(3 << SSP_GYRO_DPS)
> +				/* dump index mask. Index is up to 8191 */
> +#define SSP_INDEX_MASK		(8191 << SSP_INDEX)
> +
> +struct ssp_msg {
Please make it clear that this first part is used as the buffer for spi
writes.  I don't think this will give you any grief with cacheline corruption
as nothing else should touch the rest of the structure whilst dma is
going on, but it does give me a slight worry...  I'd prefer this split
up or this section at the end then use the magic cacheline alignment
to avoid any possible problems (as an embedded structure to make referencing
it simple)
> +	u8 cmd;
> +	/* FIXME it is pushed to STM as first 9 bytes */
> +	u16 length;
> +	u16 options;
> +	__le32 data;
> +
> +	struct list_head list;
> +	struct completion *done;
> +	char *buffer;
> +	u8 free_buffer;
> +	bool *dead_hook;
> +	bool dead;
> +} __attribute__((__packed__));
> +
> +enum {
> +	AP2HUB_READ = 0,
> +	AP2HUB_WRITE,
> +	HUB2AP_WRITE,
> +	AP2HUB_READY,
> +	AP2HUB_RETURN
> +};
> +
> +enum {
> +	BIG_TYPE_DUMP = 0,
> +	BIG_TYPE_READ_LIB,
> +	BIG_TYPE_VOICE_NET,
> +	BIG_TYPE_VOICE_GRAM,
> +	BIG_TYPE_VOICE_PCM,
> +	BIG_TYPE_TEMP,
> +	BIG_TYPE_MAX,
> +};
> +

I think this structure would benefit from full kernel doc description.
> +struct ssp_data {
> +	struct spi_device *spi;
> +	struct sensorhub_info *sensorhub_info;
> +	struct timer_list wdt_timer;
> +	struct workqueue_struct *wdt_wq;
> +	struct work_struct work_wdt;
> +
> +	struct regulator *hrm_supply_18;
> +	struct regulator *hrm_supply_33;
> +
> +	struct delayed_work work_firmware;
> +	struct delayed_work work_refresh;
> +
> +	bool shut_down;
> +	bool mcu_dump_mode;
> +	bool time_syncing;
> +
> +	unsigned char fuse_rom_data[3];
> +	unsigned char mag_reg_data;
> +	int library_length;
> +	int check_status[SSP_SENSOR_MAX];
> +
> +	unsigned int com_fail_cnt;
> +	unsigned int reset_cnt;
> +	unsigned int time_out_cnt;
> +	unsigned int irq_cnt;
> +
> +	unsigned int sensor_state;
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
> +	u32 mag_matrix_size;
> +	u8 *mag_matrix;
> +
> +	struct mutex comm_mutex;
> +	struct mutex pending_mutex;
> +
> +	void (*get_positions)(int *, int *);
> +
> +	int mcu_reset;
> +	int ap_mcu_int;
> +	int mcu_ap_int;
> +	struct list_head pending_list;
> +
> +	void (*ssp_big_task[BIG_TYPE_MAX])(struct work_struct *);
> +	u64 timestamp;
> +
> +	struct iio_dev *sensor_devs[SSP_SENSOR_MAX];
> +	atomic_t enable_refcount;
> +};
> +
> +struct ssp_big {
> +	struct ssp_data *data;
> +	struct work_struct work;
> +	u32 length;
> +	u32 addr;
> +};
> +
> +void ssp_enable(struct ssp_data *, bool);
> +
> +void clean_pending_list(struct ssp_data *);
> +
> +void toggle_mcu_reset(struct ssp_data *);
> +
> +int initialize_mcu(struct ssp_data *);
> +
> +void initialize_function_pointer(struct ssp_data *);
> +
> +int check_fwbl(struct ssp_data *);
> +
> +int ssp_send_cmd(struct ssp_data *, char, int);
> +
> +int ssp_send_instruction(struct ssp_data *, u8, u8, u8 *, u8);
> +
> +int flush(struct ssp_data *, u8);
> +
> +int select_irq_msg(struct ssp_data *);
> +
> +int get_chipid(struct ssp_data *);
> +
> +int get_fuserom_data(struct ssp_data *);
> +
> +int set_big_data_start(struct ssp_data *, u8 , u32);
> +
> +int set_sensor_position(struct ssp_data *);
> +
> +int set_magnetic_static_matrix(struct ssp_data *);
> +
> +unsigned int get_sensor_scanning_info(struct ssp_data *);
> +
> +unsigned int get_firmware_rev(struct ssp_data *);
> +
> +int forced_to_download_binary(struct ssp_data *, int);
Please put parameter names in. Makes it a little easier to review later
patches.
> +
> +int queue_refresh_task(struct ssp_data *data, int delay);
> +
> +int ssp_start_big_data(struct ssp_data *data, u8 type, u32 len);
> +
> +#endif /* __SSP_SENSORHUB_H__ */
> diff --git a/drivers/misc/sensorhub/ssp_data.c b/drivers/misc/sensorhub/ssp_data.c
> new file mode 100644
> index 0000000..4112cf2
> --- /dev/null
> +++ b/drivers/misc/sensorhub/ssp_data.c
> @@ -0,0 +1,61 @@
> +/*
> + *  Copyright (C) 2012, Samsung Electronics Co. Ltd. All Rights Reserved.
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
> +#include "ssp.h"
Why the separate file?  Not much in here really..
> +
> +static void sync_sensor_state(struct ssp_data *data)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i < SSP_SENSOR_MAX; ++i) {
> +		if ((data->sensor_state << i)  == 1)
> +			ret = ssp_enable_sensor(data, i, data->delay_buf[i]);
> +			if (ret < 0)
> +				continue;
> +	}
> +
> +	ret  = ssp_send_cmd(data, MSG2SSP_AP_MCU_SET_DUMPMODE,
> +			    data->mcu_dump_mode);
> +	if (ret < 0) {
> +		pr_err("[SSP]: %s - MSG2SSP_AP_MCU_SET_DUMPMODE failed\n",
> +		       __func__);
> +	}
> +}
> +
> +void refresh_task(struct work_struct *work)
> +{
> +	struct ssp_data *data = container_of((struct delayed_work *)work,
> +			struct ssp_data, work_refresh);
> +
> +	data->reset_cnt++;
> +
> +	if (initialize_mcu(data) > 0) {
> +		sync_sensor_state(data);
> +		if (data->last_ap_state != 0)
> +			ssp_send_cmd(data, data->last_ap_state, 0);
> +		if (data->last_resume_state != 0)
> +			ssp_send_cmd(data, data->last_resume_state, 0);
> +		data->time_out_cnt = 0;
> +	}
> +}
> +
> +int queue_refresh_task(struct ssp_data *data, int delay)
> +{
> +	cancel_delayed_work_sync(&data->work_refresh);
> +
> +	INIT_DELAYED_WORK(&data->work_refresh, refresh_task);
> +
> +	return queue_delayed_work(data->wdt_wq, &data->work_refresh,
> +			msecs_to_jiffies(delay));
> +}
> diff --git a/drivers/misc/sensorhub/ssp_dev.c b/drivers/misc/sensorhub/ssp_dev.c
> new file mode 100644
> index 0000000..6b42a3b
> --- /dev/null
> +++ b/drivers/misc/sensorhub/ssp_dev.c
> @@ -0,0 +1,782 @@
> +/*
> + *  Copyright (C) 2012, Samsung Electronics Co. Ltd. All Rights Reserved.
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
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_platform.h>
> +#include <linux/io.h>
> +#include <linux/iio/iio.h>
> +#include "ssp.h"
> +
> +#define SSP_WDT_TIME		(10 * HZ)
> +#define LIMIT_RESET_CNT		20
> +#define LIMIT_TIMEOUT_CNT	3
> +
> +const struct sensorhub_info rinato_info = {
> +	.fw_name = "ssp_B2.fw",
> +	.fw_crashed_name = "ssp_crashed.fw",
> +	.fw_rev = 14031200,
> +};
> +
> +const struct sensorhub_info thermostat_info = {
> +	.fw_name = "thermostat_B2.fw",
> +	.fw_crashed_name = "ssp_crashed.fw",
> +	.fw_rev = 14080600,
> +};
> +
> +static void reset_mcu(struct ssp_data *data)
> +{
> +	ssp_enable(data, false);
> +	clean_pending_list(data);
> +	toggle_mcu_reset(data);
> +	ssp_enable(data, true);
> +}
> +
> +static void wdt_work_func(struct work_struct *work)
> +{
> +	struct ssp_data *data = container_of(work, struct ssp_data, work_wdt);
> +
> +	ssp_dbg("%s(%u) - Sensor state: 0x%x, RC: %u, CC: %u\n", __func__,
> +		data->irq_cnt, data->sensor_state, data->reset_cnt,
> +		data->com_fail_cnt);
> +
> +	switch (data->fw_dl_state) {
> +	case FW_DL_STATE_FAIL:
> +	case FW_DL_STATE_DOWNLOADING:
> +	case FW_DL_STATE_SYNC:
> +		ssp_dbg("[SSP] : %s firmware downloading state = %d\n",
> +			__func__, data->fw_dl_state);
> +		return;
> +	}
> +	/* FIXME time_out_cnt should be atomc*/
> +	if (data->time_out_cnt > LIMIT_TIMEOUT_CNT) {
> +		if (data->com_fail_cnt < LIMIT_RESET_CNT) {
> +			pr_info("[SSP] : %s - time_out_cnt(%u), pending(%u)\n",
> +				__func__, data->time_out_cnt,
> +				!list_empty(&data->pending_list));
> +			data->com_fail_cnt++;
> +			reset_mcu(data);
> +		} else
> +			ssp_enable(data, false);
> +
> +		data->time_out_cnt = 0;
> +	}
> +
> +	data->irq_cnt = 0;
> +}
> +
> +static void wdt_timer_func(unsigned long ptr)
> +{
> +	struct ssp_data *data = (struct ssp_data *)ptr;
> +
> +	queue_work(data->wdt_wq, &data->work_wdt);
> +	mod_timer(&data->wdt_timer,
> +		  round_jiffies_up(jiffies + SSP_WDT_TIME));
> +}
> +
> +static void enable_wdt_timer(struct ssp_data *data)
> +{
> +	mod_timer(&data->wdt_timer,
> +		  round_jiffies_up(jiffies + SSP_WDT_TIME));
> +}
> +
> +static void disable_wdt_timer(struct ssp_data *data)
> +{
> +	del_timer_sync(&data->wdt_timer);
> +	cancel_work_sync(&data->work_wdt);
> +}
> +
> +static int initialize_wdt_timer(struct ssp_data *data)
> +{
> +	setup_timer(&data->wdt_timer, wdt_timer_func,
> +		    (unsigned long)data);
> +
> +	data->wdt_wq = create_singlethread_workqueue("ssp_wdt_wq");
> +	if (IS_ERR(data->wdt_wq))
> +		return PTR_ERR(data->wdt_wq);
> +
> +	INIT_WORK(&data->work_wdt, wdt_work_func);
> +
> +	return 0;
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
> + */
> +int ssp_enable_sensor(struct ssp_data *data, enum ssp_sensor_type type,
> +		       u32 delay)
> +{
> +	int ret = 0;
> +	struct {
> +		__le32 a;
> +		__le32 b;
> +		u8 c;
> +	} __attribute__((__packed__)) to_send;
No actual need to pack given what is in it...
> +
> +	to_send.a = cpu_to_le32(delay);
> +	to_send.b = cpu_to_le32(data->batch_latency_buf[type]);
> +	to_send.c = data->batch_opt_buf[type];
> +
> +	switch (data->check_status[type]) {
> +	case INITIALIZATION_STATE:
> +		/*FIXME do calibration step*/
> +	case ADD_SENSOR_STATE:
> +		ret = ssp_send_instruction(data, MSG2SSP_INST_BYPASS_SENSOR_ADD,
> +				       type, (char *)&to_send, sizeof(to_send));
> +		if (ret < 0) {
> +			dev_err(&data->spi->dev, "Enabling sensor failed\n");
> +			data->check_status[type] = NO_SENSOR_STATE;
> +			goto derror;
> +		}
> +
> +		data->sensor_enable |= 1 << type;
> +		data->check_status[type] = RUNNING_SENSOR_STATE;
> +		break;
> +	case RUNNING_SENSOR_STATE:
> +		ret = ssp_send_instruction(data,
> +					   MSG2SSP_INST_CHANGE_DELAY, type,
> +				       (char *)&to_send, sizeof(to_send));
> +		if (ret < 0) {
> +			dev_err(&data->spi->dev,
> +				"Changing delay sensor failed\n");
> +			goto derror;
> +		}
> +		break;
> +	default:
> +		data->check_status[type] = ADD_SENSOR_STATE;
> +		break;
> +	}
> +
> +	data->delay_buf[type] = delay;
> +
> +	if (atomic_inc_return(&data->enable_refcount) == 1)
> +		enable_wdt_timer(data);
> +
> +	return 0;
> +
> +derror:
> +	return -EIO;
> +}
> +EXPORT_SYMBOL(ssp_enable_sensor);
> +
> +/**
> + * ssp_change_delay() - changes data acquisition for sensor
> + * @data:	sensorhub structure
> + * @type:	SSP sensor type
> + * @delay:	delay in ms
> + */
> +int ssp_change_delay(struct ssp_data *data, enum ssp_sensor_type type,
> +		     u32 delay)
> +{
> +	int ret = 0;
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
> +	ret = ssp_send_instruction(data, MSG2SSP_INST_CHANGE_DELAY, type,
> +			       (char *)&to_send, sizeof(to_send));
> +	if (ret < 0) {
> +		dev_err(&data->spi->dev,
> +			"Changing delay sensor failed\n");
> +		return ret;
> +	}
> +
> +	data->delay_buf[type] = delay;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ssp_change_delay);
> +
> +/**
> + * ssp_disable_sensor() - disables sensor
> + *
> + * @data:	sensorhub structure
> + * @type:	SSP sensor type
> + *
> + * Returns  < 0 if not succeed
> + */
> +int ssp_disable_sensor(struct ssp_data *data, enum ssp_sensor_type type)
> +{
> +	int ret = 0;
> +	__le32 command;
> +
> +	if (data->sensor_enable & (1 << type)) {
> +		command  = cpu_to_le32(data->delay_buf[type]);
> +		ret = ssp_send_instruction(data,
> +					   MSG2SSP_INST_BYPASS_SENSOR_REMOVE,
> +				       type, (char *)&command, sizeof(__le32));
> +		if (ret < 0) {
> +			dev_err(&data->spi->dev, "Remove sensor fail\n");
> +			return ret;
> +		}
> +
> +		data->sensor_enable &= (~(1 << type));
> +	}
> +
> +	data->check_status[type] = ADD_SENSOR_STATE;
> +
> +	if (atomic_dec_and_test(&data->enable_refcount))
> +		disable_wdt_timer(data);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ssp_disable_sensor);
> +
> +void ssp_enable(struct ssp_data *data, bool enable)
> +{
> +	dev_info(&data->spi->dev, "Enable = %d, old enable = %d\n", enable,
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
> +		dev_err(&data->spi->dev,
> +			"Error / enable = %d, old enable = %d\n", enable,
> +			data->shut_down);
> +	}
> +}
> +
> +static irqreturn_t sensordata_irq_thread_fn(int irq, void *dev_id)
> +{
> +	struct ssp_data *data = dev_id;
> +
> +	select_irq_msg(data);
> +	data->irq_cnt++;
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void initialize_variable(struct ssp_data *data)
> +{
> +	int sensor_index;
> +
> +	for (sensor_index = 0; sensor_index < SSP_SENSOR_MAX; sensor_index++) {
> +		data->delay_buf[sensor_index] = DEFUALT_POLLING_DELAY;
> +		data->batch_latency_buf[sensor_index] = 0;
> +		data->batch_opt_buf[sensor_index] = 0;
> +		data->check_status[sensor_index] = INITIALIZATION_STATE;
> +	}
> +
> +	data->delay_buf[SSP_BIO_HRM_LIB] = 100;
> +
> +	data->shut_down = true;
> +	data->time_syncing = true;
> +
> +	INIT_LIST_HEAD(&data->pending_list);
> +
> +	atomic_set(&data->enable_refcount, 0);
> +}
> +
> +int initialize_mcu(struct ssp_data *data)
> +{
> +	int ret;
> +
> +	clean_pending_list(data);
> +
> +	ret = get_chipid(data);
> +	if (ret != DEVICE_ID) {
> +		dev_err(&data->spi->dev, "%s - MCU %s ret = %d\n", __func__,
> +		       ret < 0 ? "is not working" : "identyfication failed",
> +		       ret);
> +		return ret >= 0 ? -ENODEV : ret;
> +	}
> +
> +	dev_info(&data->spi->dev, "MCU device ID = %d, reading ID = %d\n",
> +		 DEVICE_ID, ret);
> +
> +	ret = set_sensor_position(data);
> +	if (ret < 0) {
> +		dev_err(&data->spi->dev, "%s - set_sensor_position failed\n",
> +			__func__);
> +		return ret;
> +	}
> +
> +	ret = set_magnetic_static_matrix(data);
> +	if (ret < 0)
> +		dev_err(&data->spi->dev,
> +			"%s - set_magnetic_static_matrix failed\n", __func__);
> +
> +	ret = get_fuserom_data(data);
> +	if (ret < 0)
> +		dev_err(&data->spi->dev,
> +			"%s - get_fuserom_data failed\n", __func__);
> +
> +	data->sensor_state = get_sensor_scanning_info(data);
> +	if (data->sensor_state == 0) {
> +		dev_err(&data->spi->dev,
> +			"%s - get_sensor_scanning_info failed\n", __func__);
> +		return -1;
> +	}
> +
> +	data->cur_firm_rev = get_firmware_rev(data);
> +	dev_info(&data->spi->dev, "MCU Firm Rev : New = %8u\n",
> +		 data->cur_firm_rev);
> +
> +	return ssp_send_cmd(data, MSG2SSP_AP_MCU_DUMP_CHECK, 0);
> +}
> +
> +static void work_function_firmware_update(struct work_struct *work)
> +{
> +	struct ssp_data *data = container_of((struct delayed_work *)work,
> +				struct ssp_data, work_firmware);
> +	int ret;
> +
> +	dev_info(&data->spi->dev, "%s, is called\n", __func__);
> +
> +	ret = forced_to_download_binary(data, KERNEL_BINARY);
> +	if (ret < 0) {
> +		dev_err(&data->spi->dev,
> +			 "%s, forced_to_download_binary failed!\n",
> +			__func__);
> +		return;
> +	}
> +
> +	queue_refresh_task(data, SSP_SW_RESET_TIME);
> +
> +	dev_info(&data->spi->dev, "%s done\n", __func__);
> +}
> +
> +#ifdef CONFIG_OF
> +static struct of_device_id ssp_of_match[] = {
> +	{
> +		.compatible	= "samsung,sensorhub-rinato",
> +		.data		= &rinato_info,
> +	}, {
> +		.compatible	= "samsung,sensorhub-thermostat",
> +		.data		= &thermostat_info,
> +	},
> +};
> +MODULE_DEVICE_TABLE(of, ssp_of_match);
> +
> +static struct ssp_data *ssp_parse_dt(struct device *dev)
> +{
> +	int ret, len;
> +	struct ssp_data *pdata;
> +	struct device_node *node = dev->of_node;
> +	const void *prop;
> +	const struct of_device_id *match;
> +
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return NULL;
> +
> +	pdata->mcu_ap_int = of_get_named_gpio(node, "mcu-ap-int", 0);
> +	if (pdata->mcu_ap_int < 0)
> +		goto err_free_pd;
Do these need to be gpios?  Can't you use interrupts instead and make
things more general?
> +
> +	pdata->ap_mcu_int = of_get_named_gpio(node, "ap-mcu-int", 0);
> +	if (pdata->ap_mcu_int < 0)
> +		goto err_free_pd;
> +
> +	pdata->mcu_reset = of_get_named_gpio(node, "mcu-reset", 0);
> +	if (pdata->mcu_reset < 0)
> +		goto err_free_pd;
> +
> +	ret = devm_gpio_request_one(dev, pdata->ap_mcu_int, GPIOF_OUT_INIT_HIGH,
> +				"ap-mcu-int");
> +	if (ret)
> +		goto err_free_pd;
> +
> +	ret = devm_gpio_request_one(dev, pdata->mcu_reset, GPIOF_OUT_INIT_HIGH,
> +			"mcu-reset");
> +	if (ret)
> +		goto err_ap_mcu;
> +
> +	match = of_match_node(ssp_of_match, node);
> +	if (!match)
> +		goto err_ap_mcu;
> +
> +	pdata->sensorhub_info = (struct sensorhub_info *) match->data;
> +
> +	ret = of_platform_populate(node, NULL, NULL, dev);
> +	if (ret < 0) {
> +		dev_err(dev, "of_platform_populate fail\n");
> +		goto err_ap_mcu;
> +	}
> +
> +	prop = of_get_property(node, "mag-table", &len);
> +	if (IS_ERR(prop)) {
> +		dev_err(dev, "get prop failed\n");
> +		goto err_mcu_reset;
> +	}
> +
> +	pdata->mag_matrix_size = len;
> +
> +	pdata->mag_matrix = devm_kzalloc(dev, sizeof(len), GFP_KERNEL);
sizeof(len) rather than len?
> +	if (pdata->mag_matrix == NULL)
> +		goto err_mcu_reset;
> +
> +	memcpy(pdata->mag_matrix, prop, len);
> +
> +	return pdata;
> +
> +err_mcu_reset:
> +	devm_gpio_free(dev, pdata->mcu_reset);
> +err_ap_mcu:
> +	devm_gpio_free(dev, pdata->ap_mcu_int);
> +err_free_pd:
> +	kfree(pdata);
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
> +	/*TODO 3rd level device - hide it*/
> +	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
> +
> +	data->sensor_devs[type] = indio_dev;
> +}
> +EXPORT_SYMBOL(ssp_register_consumer);
> +
> +
> +static int ssp_probe(struct spi_device *spi)
> +{
> +	int ret = 0;
> +	struct ssp_data *data;
> +
> +	data = (struct ssp_data *)spi->dev.platform_data;
No need for the cast - platform_data is a void *.
> +	if (!data) {
> +		data = ssp_parse_dt(&spi->dev);
> +		if (!data) {
> +			dev_err(&spi->dev,
> +				"%s:Failed to find platform data\n", __func__);
> +			return -ENODEV;
> +		}
> +	}
> +
> +	/* FIXME */
Why?
Use regulator_get_optional given you allow it to continue without the regulator.
> +	data->hrm_supply_18 = regulator_get(&spi->dev, "hrm18");
> +	if (IS_ERR(data->hrm_supply_18)) {
> +		data->hrm_supply_18 = NULL;
> +		dev_err(&spi->dev, "Regulator get fail\n");
> +	}
> +
> +	/* FIXME */
> +	data->hrm_supply_33 = regulator_get(&spi->dev, "hrm33");
> +	if (IS_ERR(data->hrm_supply_33)) {
> +		data->hrm_supply_33 = NULL;
> +		dev_err(&spi->dev, "Regulator get fail\n");
> +	}
> +
> +	if (data->get_positions) {
> +		data->get_positions(&data->accel_position,
> +			&data->mag_position);
> +	} else {
> +		data->accel_position = 0;
> +		data->mag_position = 0;
> +	}
> +
> +	spi->mode = SPI_MODE_1;
> +	if (spi_setup(spi)) {
Please don't eat up the error code spi_setup returns.  Pass it onwards.
> +		dev_err(&spi->dev, "Failed to setup spi\n");
> +		goto err_setup;
> +	}
> +
> +	data->fw_dl_state = FW_DL_STATE_NONE;
> +	data->spi = spi;
> +	spi_set_drvdata(spi, data);
> +
> +	mutex_init(&data->comm_mutex);
> +	mutex_init(&data->pending_mutex);
> +
> +	initialize_variable(data);
> +	INIT_DELAYED_WORK(&data->work_firmware, work_function_firmware_update);
> +
> +	ret = initialize_wdt_timer(data);
> +	if (ret < 0) {
> +		dev_err(&spi->dev, "Could not create workqueue\n");
> +		goto err_create_workqueue;
> +	}
> +
> +	ret = request_threaded_irq(data->spi->irq, NULL,
> +				   sensordata_irq_thread_fn,
Spacing around the |
> +				   IRQF_TRIGGER_FALLING|IRQF_ONESHOT,
> +				   "SSP_Int", data);
> +	if (ret < 0) {
> +		dev_err(&spi->dev, "Irq request fail\n");
> +		goto err_setup_irq;
> +	}
> +
There is a window here in which the irq is enabled.  As a general rule,
needing to explicitly disable an irq is a sign that something interesting
is going on in the handling.  Explain why it should be disabled...
> +	disable_irq(data->spi->irq);
> +	ssp_enable(data, true);
> +
> +	data->fw_dl_state = check_fwbl(data);
> +
> +	if (data->fw_dl_state == FW_DL_STATE_NONE) {
> +		ret = initialize_mcu(data);
> +		if (ret < 0) {
> +			dev_err(&spi->dev, "Initialize_mcu failed\n");
> +			goto err_read_reg;
> +		}
> +	}
> +
> +	if (data->hrm_supply_18) {
Why wait until here?  Either move the initial get of the regulators to here
or this to the initial get.  No obvious reason to separate them.
> +		ret = regulator_enable(data->hrm_supply_18);
> +		if (ret < 0) {
> +			dev_err(&spi->dev, "Regulator enable fail\n");
> +			goto err_read_reg;
> +		}
> +	}
> +
> +	if (data->hrm_supply_33) {
> +		ret = regulator_enable(data->hrm_supply_33);
> +		if (ret < 0) {
> +			dev_err(&spi->dev,
> +				"Regulator enable 3.3 V fail\n");
> +			goto err_read_reg;
> +		}
> +	}
> +
> +	if (data->fw_dl_state == FW_DL_STATE_NEED_TO_SCHEDULE) {
> +		dev_info(&spi->dev, "Firmware update is scheduled\n");
> +		queue_delayed_work(system_power_efficient_wq,
> +				&data->work_firmware, msecs_to_jiffies(1000));
> +		data->fw_dl_state = FW_DL_STATE_SCHEDULED;
> +	} else if (data->fw_dl_state == FW_DL_STATE_FAIL) {
> +		data->shut_down = true;
> +	}
> +
> +	return 0;
> +
> +err_read_reg:
> +	free_irq(data->spi->irq, data);
> +err_setup_irq:
> +	destroy_workqueue(data->wdt_wq);
> +err_create_workqueue:
> +	mutex_destroy(&data->comm_mutex);
> +	mutex_destroy(&data->pending_mutex);
> +err_setup:
> +	kfree(data);
You didn't necessarily create data.  Hence I'd suggest making
a copy in the platformdata case so that you are always able to free it.
> +	dev_err(&spi->dev, "Probe failed!\n");
> +
> +	return ret;
> +}
> +
> +static void ssp_shutdown(struct spi_device *spi)
> +{
> +	struct ssp_data *data = spi_get_drvdata(spi);
> +
> +	if (ssp_send_cmd(data, MSG2SSP_AP_STATUS_SHUTDOWN, 0) < 0)
> +		dev_err(&data->spi->dev, "MSG2SSP_AP_STATUS_SHUTDOWN failed\n");
> +
> +	ssp_enable(data, false);
> +	disable_wdt_timer(data);
> +
> +	if (data->hrm_supply_18)
> +		regulator_put(data->hrm_supply_18);
> +
> +	if (data->hrm_supply_33)
> +		regulator_put(data->hrm_supply_33);
> +}
> +
> +
> +static int ssp_remove(struct spi_device *spi)
> +{
> +	struct ssp_data *data = spi_get_drvdata(spi);
> +
> +	if (data->fw_dl_state >= FW_DL_STATE_SCHEDULED &&
> +		data->fw_dl_state < FW_DL_STATE_DONE) {
> +		dev_err(&data->spi->dev,
> +			"cancel_delayed_work_sync state = %d\n",
> +			data->fw_dl_state);
> +		cancel_delayed_work_sync(&data->work_firmware);
> +	}
> +
> +	if (ssp_send_cmd(data, MSG2SSP_AP_STATUS_SHUTDOWN, 0) < 0)
> +		dev_err(&data->spi->dev, "MSG2SSP_AP_STATUS_SHUTDOWN failed\n");
> +
> +	ssp_enable(data, false);
> +	disable_wdt_timer(data);
> +
> +	clean_pending_list(data);
> +
> +	free_irq(data->spi->irq, data);
> +
> +	del_timer_sync(&data->wdt_timer);
> +	cancel_work_sync(&data->work_wdt);
> +	destroy_workqueue(data->wdt_wq);
> +
> +	mutex_destroy(&data->comm_mutex);
> +	mutex_destroy(&data->pending_mutex);
> +
> +	if (data->hrm_supply_18)
> +		regulator_put(data->hrm_supply_18);
> +
> +	if (data->hrm_supply_33)
> +		regulator_put(data->hrm_supply_33);
> +
> +	kfree(data->mag_matrix);
> +
> +#ifdef CONFIG_OF
> +	of_platform_depopulate(&spi->dev);
> +#endif
> +
> +	kfree(data);
Hmm. You only allocate data is some paths. Best bet is probably to
copy the platform data into a local copy so that you are always safe
freeing it later.
> +
> +	return 0;
> +}
> +
> +static int ssp_suspend(struct device *dev)
> +{
> +	int ret = 0;
> +	struct ssp_data *data = spi_get_drvdata(to_spi_device(dev));
> +
> +	data->last_resume_state = MSG2SSP_AP_STATUS_SUSPEND;
> +
> +	if (atomic_read(&data->enable_refcount) > 0)
> +		disable_wdt_timer(data);
> +
> +	if (ssp_send_cmd(data, MSG2SSP_AP_STATUS_SUSPEND, 0) < 0)
> +		dev_err(&data->spi->dev,
> +			"%s MSG2SSP_AP_STATUS_SUSPEND failed\n", __func__);
> +
> +	data->time_syncing = false;
> +	disable_irq(data->spi->irq);
> +
> +	if (data->hrm_supply_18) {
> +		ret = regulator_disable(data->hrm_supply_18);
> +		if (ret < 0) {
> +			dev_err(&data->spi->dev,
> +				"Regulator disable fail\n");
> +		}
> +	}
> +
> +	if (data->hrm_supply_33) {
> +		ret = regulator_disable(data->hrm_supply_33);
> +		if (ret < 0) {
> +			dev_err(&data->spi->dev,
> +				"Regulator disable fail\n");
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int ssp_resume(struct device *dev)
> +{
> +	int ret = 0;
> +	struct ssp_data *data = spi_get_drvdata(to_spi_device(dev));
> +
> +	if (data->hrm_supply_18) {
> +		ret = regulator_enable(data->hrm_supply_18);
> +		if (ret < 0) {
> +			dev_err(&data->spi->dev,
> +				"Regulator enable hrm 1.8 fail\n");
> +		} /* do not return jet */
> +	}
> +
Either do your suspend and resume so that the orders are an exact mirror
image or comment on why not.
> +	if (data->hrm_supply_33) {
> +		ret = regulator_enable(data->hrm_supply_33);
> +		if (ret < 0) {
> +			dev_err(&data->spi->dev,
> +				"Regulator enable hrm 3.3 fail\n");
> +		} /* do not return jet */
yet
> +	}
> +
> +	enable_irq(data->spi->irq);
> +
> +	if (atomic_read(&data->enable_refcount) > 0)
> +		enable_wdt_timer(data);
> +
> +	if (ssp_send_cmd(data, MSG2SSP_AP_STATUS_RESUME, 0) < 0)
> +		dev_err(&data->spi->dev,
> +			"%s MSG2SSP_AP_STATUS_RESUME failed\n", __func__);
> +
> +	data->last_resume_state = MSG2SSP_AP_STATUS_RESUME;
> +
> +	return ret;
> +}
> +
> +static const struct dev_pm_ops ssp_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(ssp_suspend, ssp_resume)
> +};
> +
> +static struct spi_driver ssp_driver = {
> +	.probe = ssp_probe,
> +	.remove = ssp_remove,
> +	.shutdown = ssp_shutdown,
Do we need a separate shutdown rather than just relying on device removal
occuring?  Not sure I've ever seen anyone implement it before!
> +	.driver = {
> +		.pm = &ssp_pm_ops,
> +		.bus = &spi_bus_type,
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(ssp_of_match),
> +		.name = "ssp-spi"
> +	},
> +};
> +
> +static int __init ssp_stm_spi_init(void)
> +{
> +	int ret;
> +
> +	ret = spi_register_driver(&ssp_driver);
> +	if (ret)
> +		pr_err("Failed to register ssp-spi %x\n", ret);
> +
> +	return ret;
> +}
> +
> +static void __exit ssp_stm_spi_exit(void)
> +{
> +	spi_unregister_driver(&ssp_driver);
> +}
> +
> +module_init(ssp_stm_spi_init);
> +module_exit(ssp_stm_spi_exit);
module_spi_driver

> +
> +MODULE_DESCRIPTION("ssp spi driver");
> +MODULE_AUTHOR("Samsung Electronics");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/misc/sensorhub/ssp_firmware.c b/drivers/misc/sensorhub/ssp_firmware.c
> new file mode 100644
> index 0000000..2554d64
> --- /dev/null
> +++ b/drivers/misc/sensorhub/ssp_firmware.c
> @@ -0,0 +1,571 @@
> +/*
> + *  Copyright (C) 2012, Samsung Electronics Co. Ltd. All Rights Reserved.
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
Is this a generic stm32 firmware loader?  If so will it work with other
such parts?  If so it should probably be factored out of the driver so
it can be shared with other drivers using this part.

I note some at least of this looks like the protocols in:
http://www.st.com/st-web-ui/static/active/en/resource/technical/document/application_note/DM00081379.pdf

> +#include <linux/firmware.h>
> +#include "ssp.h"
> +
> +#define BOOT_SPI_HZ	500000
> +#define NORM_SPI_HZ	5000000
> +
> +#define APP_SLAVE_ADDR			0x18
> +#define BOOTLOADER_SLAVE_ADDR		0x26
> +
> +/* Bootloader mode status */
> +#define BL_WAITING_BOOTLOAD_CMD		0xc0	/* valid 7 6 bit only */
> +#define BL_WAITING_FRAME_DATA		0x80	/* valid 7 6 bit only */
> +#define BL_FRAME_CRC_CHECK		0x02
> +#define BL_FRAME_CRC_FAIL		0x03
> +#define BL_FRAME_CRC_PASS		0x04
> +#define BL_APP_CRC_FAIL			0x40	/* valid 7 8 bit only */
> +#define BL_BOOT_STATUS_MASK		0x3f
> +
> +/* Command to unlock bootloader */
> +#define BL_UNLOCK_CMD_MSB		0xaa
> +#define BL_UNLOCK_CMD_LSB		0xdc
> +
> +#define SEND_ADDR_LEN	5
> +#define BL_SPI_SOF 0x5A
> +#define BL_ACK  0x79
> +#define BL_ACK2  0xF9
> +#define BL_NACK 0x1F
> +
> +#define STM_MAX_XFER_SIZE 256
> +#define STM_MAX_BUFFER_SIZE 260
> +#define STM_APP_ADDR	0x08000000
> +
> +#define BYTE_DELAY_READ 10
> +#define BYTE_DELAY_WRITE 8
> +
> +#define DEF_ACK_ERASE_NUMBER 7000
> +#define DEF_ACKCMD_NUMBER    30
> +#define DEF_ACKROOF_NUMBER   20
> +
> +#define WMEM_COMMAND           0x31  /* Write Memory command          */
> +#define GO_COMMAND             0x21  /* GO command                    */
> +#define EXT_ER_COMMAND         0x44  /* Erase Memory command          */
> +
> +#define XOR_RMEM_COMMAND       0xEE  /* Read Memory command           */
> +
> +#define XOR_WMEM_COMMAND       0xCE  /* Write Memory command          */
> +#define XOR_GO_COMMAND         0xDE  /* GO command                    */
> +#define XOR_EXT_ER_COMMAND     0xBB  /* Erase Memory command          */
> +
> +#define EXT_ER_DATA_LEN		3
> +#define BLMODE_RETRYCOUNT	3
> +
> +struct stm32fwu_spi_cmd {
> +	u8 cmd;
> +	u8 xor_cmd;
> +	u8 ack_pad; /* Send this when waiting for an ACK */
> +	u8 reserved;
> +	int status; /* ACK or NACK (or error) */
> +	int timeout; /* This is number of retries */
> +	int ack_loops;
> +};
> +
> +static int stm32fwu_spi_wait_for_ack(struct spi_device *spi,
> +				struct stm32fwu_spi_cmd *cmd, u8 dummy_bytes)
> +{
> +	struct spi_message m;
> +	char tx_buf = 0x0;
> +	char rx_buf = 0x0;
> +	struct spi_transfer	t = {
> +		.tx_buf		= &tx_buf,
> +		.rx_buf		= &rx_buf,
> +		.len		= 1,
> +		.bits_per_word = 8,
> +	};
> +	int i = 0;
> +	int ret;
> +
> +	while (i < cmd->timeout) {
> +		tx_buf = dummy_bytes;
> +		spi_message_init(&m);
> +		spi_message_add_tail(&t, &m);
> +
> +		ret = spi_sync(spi, &m);
> +		if (ret < 0) {
> +			dev_err(&spi->dev, "%s: spi_sync error returned %d\n",
> +						__func__, ret);
> +			return ret;
> +		} else  if ((rx_buf == BL_ACK) || (rx_buf == BL_ACK2)) {
> +			cmd->ack_loops = i;
> +			return BL_ACK;
> +		} else if (rx_buf == BL_NACK) {
> +			return (int)rx_buf;
> +		}
> +		usleep_range(1000, 1100);
> +		i++;
> +	}
> +
> +	dev_err(&spi->dev, "%s, Timeout after %d loops\n", __func__,
> +		cmd->timeout);
> +
> +	return -EIO;
> +}
> +
> +static int stm32fwu_spi_send_cmd(struct spi_device *spi,
> +					struct stm32fwu_spi_cmd *cmd)
> +{
> +	u8 tx_buf[3] = {0,};
> +	u8 rx_buf[3] = {0,};
Now, if it were fine to have these buffers on the stack, you should be filling
tx_buf approriately here, not futher down.

> +	u8 dummy_byte = 0;
> +	struct spi_message m;
> +	int ret;
> +	struct spi_transfer	t = {
> +		.tx_buf		= tx_buf,
> +		.rx_buf		= rx_buf,
> +		.len		= 3,
> +		.bits_per_word = 8,
> +	};
> +
> +	spi_message_init(&m);
> +
> +	tx_buf[0] = BL_SPI_SOF;
> +	tx_buf[1] = cmd->cmd;
> +	tx_buf[2] = cmd->xor_cmd;
> +
> +	spi_message_add_tail(&t, &m);
> +
> +	ret = spi_sync(spi, &m);
> +	if (ret < 0) {
> +		dev_err(&spi->dev, "%s: spi_sync error returned %d\n",
> +					__func__, ret);
> +		return ret;
> +	}
> +
> +	dummy_byte = cmd->ack_pad;
> +
> +	/* check for ack/nack and loop until found */
> +	ret = stm32fwu_spi_wait_for_ack(spi, cmd, dummy_byte);
> +	cmd->status = ret;
> +	if (ret != BL_ACK) {
> +		dev_err(&spi->dev, "%s, Got NAK or Error %d\n", __func__, ret);
> +		return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +
> +static int stm32fwu_spi_write(struct spi_device *spi,
> +					const u8 *buffer, ssize_t len)
> +{
> +	int ret;
> +	u8 rx_buf[STM_MAX_BUFFER_SIZE] = {0,};
> +	struct spi_message m;
> +	struct spi_transfer	t = {
> +		.tx_buf		= buffer,
> +		.rx_buf		= rx_buf,
Don't use buffers on the stack.  Will get cacheline corruption from
dma based SPI transfers.
> +		.len		= len,
> +		.bits_per_word = 8,
> +	};
> +
> +	spi_message_init(&m);
> +	spi_message_add_tail(&t, &m);
> +
> +	ret = spi_sync(spi, &m);
> +	if (ret < 0) {
> +		dev_err(&spi->dev, "%s: spi_sync error returned %d\n",
> +					__func__, ret);
> +		return ret;
> +	}
> +
> +	return len;
> +}
> +
> +static int send_addr(struct spi_device *spi, u32 fw_addr, int send_short)
> +{
> +	int res;
> +	int i = send_short;
> +	int len = SEND_ADDR_LEN - send_short;
> +	u8 header[SEND_ADDR_LEN];
> +	struct stm32fwu_spi_cmd dummy_cmd;
> +
> +	dummy_cmd.timeout = DEF_ACKROOF_NUMBER;
> +
> +	header[0] = (u8)((fw_addr >> 24) & 0xFF);
> +	header[1] = (u8)((fw_addr >> 16) & 0xFF);
> +	header[2] = (u8)((fw_addr >> 8) & 0xFF);
> +	header[3] = (u8)(fw_addr & 0xFF);
> +	header[4] = header[0] ^ header[1] ^ header[2] ^ header[3];
> +
> +	res = stm32fwu_spi_write(spi, &header[i], len);
> +	if (res <  len) {
> +		dev_err(&spi->dev, "%s, spi_write returned %d\n", __func__,
> +			res);
> +		return (res > 0) ? -EIO : res;
> +	}
> +
> +	res = stm32fwu_spi_wait_for_ack(spi, &dummy_cmd, BL_ACK);
> +	if (res != BL_ACK) {
> +		dev_err(&spi->dev, "%s, rcv_ack returned 0x%x\n", __func__,
> +			res);
> +		return res;
> +	}
> +	return 0;
> +}
> +
> +static int fw_write_stm(struct spi_device *spi, u32 fw_addr,
> +	int len, const u8 *buffer)
> +{
> +	int res;
> +	struct stm32fwu_spi_cmd cmd;
> +	struct stm32fwu_spi_cmd dummy_cmd;
> +	int i;
> +	u8 xor = 0;
> +	u8 send_buff[STM_MAX_BUFFER_SIZE] = {0,};
> +
> +	cmd.cmd = WMEM_COMMAND;
> +	cmd.xor_cmd = XOR_WMEM_COMMAND;
> +	cmd.timeout = DEF_ACKCMD_NUMBER;
> +	cmd.ack_pad = (u8)((fw_addr >> 24) & 0xFF);
> +
> +	if (len > STM_MAX_XFER_SIZE) {
> +		dev_err(&spi->dev,
> +			"Can't send more than 256 bytes per transaction\n");
> +		return -EINVAL;
> +	}
> +
> +	send_buff[0] = len - 1;
> +	memcpy(&send_buff[1], buffer, len);
> +	for (i = 0; i < (len + 1); i++)
> +		xor ^= send_buff[i];
> +
> +	send_buff[len + 1] = xor;
> +
> +	res = stm32fwu_spi_send_cmd(spi, &cmd);
> +	if (res != BL_ACK) {
> +		dev_err(&spi->dev, "%s, spi_send_cmd returned %d\n", __func__,
> +			res);
> +		return res;
> +	}
> +
> +	if (cmd.ack_loops > 0)
> +		res = send_addr(spi, fw_addr, 1);
> +	else
> +		res = send_addr(spi, fw_addr, 0);
> +
> +	if (res != 0) {
> +		dev_err(&spi->dev, "%s, send_addr returned %d\n", __func__,
> +			res);
> +		return res;
> +	}
> +
> +	res = stm32fwu_spi_write(spi, send_buff, len + 2);
> +	if (res <  len) {
> +		dev_err(&spi->dev, "%s, spi_write returned %d\n", __func__,
> +			res);
> +		return ((res > 0) ? -EIO : res);
> +	}
> +
> +	dummy_cmd.timeout = DEF_ACKROOF_NUMBER;
> +
> +	usleep_range(100, 150);
> +
> +	res = stm32fwu_spi_wait_for_ack(spi, &dummy_cmd, BL_ACK);
> +	if (res == BL_ACK) {
> +		return len;
> +	} else if (res == BL_NACK) {
> +		dev_err(&spi->dev,
> +			"Got NAK waiting for WRITE_MEM to complete\n");
> +		return -EPROTO;
> +	}
> +
> +	dev_err(&spi->dev, "timeout waiting for ACK for WRITE_MEM command\n");
> +	return -ETIME;
> +}
> +
> +static int fw_erase_stm(struct spi_device *spi)
> +{
> +	struct stm32fwu_spi_cmd cmd;
> +	struct stm32fwu_spi_cmd dummy_cmd;
> +	int ret;
> +	char buff[EXT_ER_DATA_LEN] = {0xff, 0xff, 0x00};
> +
> +	cmd.cmd = EXT_ER_COMMAND;
> +	cmd.xor_cmd = XOR_EXT_ER_COMMAND;
> +	cmd.timeout = DEF_ACKCMD_NUMBER;
> +	cmd.ack_pad = 0xFF;
> +
> +	ret = stm32fwu_spi_send_cmd(spi, &cmd);
> +	if (ret < 0) {
> +		dev_err(&spi->dev, "fw_erase failed (-EIO)\n");
> +		return -EIO;
> +	} else if (ret != BL_ACK) {
> +		return ret;
> +	}
> +
> +	if (cmd.ack_loops == 0)
> +		ret = stm32fwu_spi_write(spi, buff, EXT_ER_DATA_LEN);
> +	else
> +		ret = stm32fwu_spi_write(spi, buff, EXT_ER_DATA_LEN-1);
> +
> +	if (ret < (EXT_ER_DATA_LEN - cmd.ack_loops))
> +		return -EPROTO;
> +
> +	dummy_cmd.timeout = DEF_ACK_ERASE_NUMBER;
> +	ret = stm32fwu_spi_wait_for_ack(spi, &dummy_cmd, BL_ACK);
> +
> +	ssp_info("%s: stm32fwu_spi_wait_for_ack returned %d (0x%x)\n",
> +		__func__, ret, ret);
> +
> +	if (ret == BL_ACK)
> +		return 0;
> +	else if (ret == BL_NACK)
> +		return -EPROTO;
> +
> +	return -ETIME;
> +
> +}
> +
> +static int load_kernel_fw_bootmode(struct spi_device *spi, const char *pfn)
> +{
> +	int ret, remaining;
> +	unsigned int pos = 0;
> +	unsigned int fw_addr = STM_APP_ADDR;
> +	int block = STM_MAX_XFER_SIZE;
> +	int count = 0, err_count = 0, retry_count = 0;
> +	const struct firmware *fw = NULL;
> +
> +	dev_info(&spi->dev, "ssp_load_fw start\n");
> +
> +	ret = request_firmware(&fw, pfn, &spi->dev);
> +	if (ret) {
> +		dev_err(&spi->dev, "Unable to open firmware %s\n", pfn);
> +		return ret;
> +	}
> +
> +	remaining = fw->size;
> +	while (remaining > 0) {
> +		if (block > remaining)
> +			block = remaining;
> +
> +		while (retry_count < 3) {
> +			ret = fw_write_stm(spi, fw_addr, block, fw->data + pos);
> +			if (ret < block) {
> +				dev_err(&spi->dev,
> +					"Returned %d writing to addr 0x%08X\n",
> +					ret,
> +					fw_addr);
> +				retry_count++;
> +				err_count++;
> +			} else {
> +				retry_count = 0;
> +				break;
> +			}
> +		}
> +
Spacing around the <
> +		if (ret  < block) {
> +			dev_err(&spi->dev,
> +				"Writing MEM failed: %d, retry cont: %d\n",
> +				ret, err_count);
> +			ret = -EIO;
> +			goto out_load_kernel;
> +		}
> +
> +		remaining -= block;
> +		pos += block;
> +		fw_addr += block;
> +		if (count++ == 20) {
> +			dev_info(&spi->dev, "Updated %u bytes / %u bytes\n",
> +				 pos, fw->size);
> +			count = 0;
> +		}
> +	}
> +
> +	dev_info(&spi->dev,
> +		 "Firmware download success.(%d bytes, retry %d)\n", pos,
> +		 err_count);
> +
> +out_load_kernel:
> +	release_firmware(fw);
> +	return ret;
> +}
> +
> +static int change_to_bootmode(struct ssp_data *data)
> +{
> +	int ret, i;
> +	char syncb = BL_SPI_SOF;
> +	struct stm32fwu_spi_cmd dummy_cmd;
> +
> +	dev_info(&data->spi->dev, "ssp_change_to_bootmode\n");
> +
> +	dummy_cmd.timeout = DEF_ACKCMD_NUMBER;
> +
> +	gpio_set_value(data->mcu_reset, 0);
> +	usleep_range(4000, 4100);
> +	gpio_set_value(data->mcu_reset, 1);
> +	msleep(45);
> +
> +	for (i = 0; i < 9; i++) {
> +		gpio_set_value(data->mcu_reset, 0);
> +		usleep_range(4000, 4100);
> +		gpio_set_value(data->mcu_reset, 1);
> +		usleep_range(15000, 15500);
> +	}
> +
> +	ret = stm32fwu_spi_write(data->spi, &syncb, 1);
> +	ssp_info("stm32fwu_spi_write(sync byte) returned %d\n", ret);
> +
> +	ret = stm32fwu_spi_wait_for_ack(data->spi, &dummy_cmd, BL_ACK);
> +	ssp_info("stm32fwu_spi_wait_for_ack returned %d (0x%x)\n", ret, ret);
> +
> +	return ret;
> +}
> +
> +void toggle_mcu_reset(struct ssp_data *data)
> +{
> +	gpio_set_value(data->mcu_reset, 0);
> +	usleep_range(1000, 1200);
> +	gpio_set_value(data->mcu_reset, 1);
> +	msleep(50);
> +}
> +
> +static int update_mcu_bin(struct ssp_data *data, int bin_type)
> +{
> +	int retry = BLMODE_RETRYCOUNT, ret = 0;
> +	struct stm32fwu_spi_cmd cmd;
> +
> +	cmd.cmd = GO_COMMAND;
> +	cmd.xor_cmd = XOR_GO_COMMAND;
> +	cmd.timeout = 1000;
> +	cmd.ack_pad = (u8)((STM_APP_ADDR >> 24) & 0xFF);
> +
> +	dev_info(&data->spi->dev, "update_mcu_bin\n");
> +
> +	do {
> +		ret = change_to_bootmode(data);
> +		dev_info(&data->spi->dev, "bootmode %d, retry = %d\n", ret,
> +			 3 - retry);
> +	} while (retry-- > 0 && ret != BL_ACK);
> +
> +	if (ret != BL_ACK) {
> +		dev_err(&data->spi->dev, "%s, change_to_bootmode failed %d\n",
> +			__func__, ret);
> +		return ret;
> +	}
> +
> +	ret = fw_erase_stm(data->spi);
> +	if (ret < 0) {
> +		dev_err(&data->spi->dev, "%s, fw_erase_stm failed %d\n",
> +			__func__, ret);
> +		return ret;
> +	}
> +
> +	switch (bin_type) {
> +	case KERNEL_BINARY:
> +		ret = load_kernel_fw_bootmode(data->spi,
> +					      data->sensorhub_info->fw_name);
> +		break;
> +	case KERNEL_CRASHED_BINARY:
> +		ret = load_kernel_fw_bootmode(data->spi,
> +			data->sensorhub_info->fw_crashed_name);
> +		break;
> +	default:
> +		dev_err(&data->spi->dev, "binary type error!!\n");
> +	}
> +
> +	/* STM : GO USER ADDR */
> +	stm32fwu_spi_send_cmd(data->spi, &cmd);
> +	if (cmd.ack_loops > 0)
> +		send_addr(data->spi, STM_APP_ADDR, 1);
> +	else
> +		send_addr(data->spi, STM_APP_ADDR, 0);
> +
> +	return ret;
> +}
> +
> +int forced_to_download_binary(struct ssp_data *data, int bin_type)
> +{
> +	int ret = 0, retry = 3;
> +
> +	ssp_dbg("%s, mcu binany update!\n", __func__);
> +	ssp_enable(data, false);
> +
> +	data->fw_dl_state = FW_DL_STATE_DOWNLOADING;
> +	dev_info(&data->spi->dev, "%s, DL state = %d\n", __func__,
> +		 data->fw_dl_state);
> +
> +	data->spi->max_speed_hz = BOOT_SPI_HZ;
> +	if (spi_setup(data->spi))
> +		dev_err(&data->spi->dev, "failed to setup spi for ssp_boot\n");
> +
> +	do {
> +		dev_info(&data->spi->dev, "%d try\n", 3 - retry);
> +		ret = update_mcu_bin(data, bin_type);
> +	} while (retry-- > 0 && ret < 0);
> +
> +	/* FIXME*/
> +	data->spi->max_speed_hz = NORM_SPI_HZ;
> +	if (spi_setup(data->spi))
> +		dev_err(&data->spi->dev, "failed to setup spi for ssp_norm\n");
> +
> +	if (ret < 0) {
> +		ssp_dbg("%s - update_mcu_bin failed!\n", __func__);
> +		data->fw_dl_state = FW_DL_STATE_FAIL;
> +		return ret;
> +	}
> +
> +	data->fw_dl_state = FW_DL_STATE_SYNC;
> +	dev_info(&data->spi->dev, "%s, DL state = %d\n", __func__,
> +		 data->fw_dl_state);
> +
> +	ssp_enable(data, true);
> +
> +	data->fw_dl_state = FW_DL_STATE_DONE;
> +	dev_info(&data->spi->dev, "%s, DL state = %d\n", __func__,
> +		 data->fw_dl_state);
> +
> +	return ret;
> +}
> +
> +int check_fwbl(struct ssp_data *data)
> +{
> +	int retries = 0;
> +
> +	while (retries++ < 5) {
> +		data->cur_firm_rev = get_firmware_rev(data);
> +		if (data->cur_firm_rev == SSP_INVALID_REVISION
> +			|| data->cur_firm_rev == SSP_INVALID_REVISION2
> +			|| data->cur_firm_rev < 0) {
> +			pr_warn("Invalid revision, trying %d time\n", retries);
> +		} else {
> +			break;
> +		}
> +	}
> +
> +	if (data->cur_firm_rev == SSP_INVALID_REVISION
> +		|| data->cur_firm_rev == SSP_INVALID_REVISION2) {
> +		dev_err(&data->spi->dev, "SSP_INVALID_REVISION\n");
> +		return FW_DL_STATE_NEED_TO_SCHEDULE;
> +
> +	} else {
> +		if (data->cur_firm_rev != data->sensorhub_info->fw_rev) {
> +			dev_info(&data->spi->dev,
> +				 "MCU Firm Rev : Old = %8u, New = %8u\n",
> +				 data->cur_firm_rev,
> +				 data->sensorhub_info->fw_rev);
> +
> +			return FW_DL_STATE_NEED_TO_SCHEDULE;
> +		}
> +		dev_info(&data->spi->dev,
> +			 "MCU Firm Rev : Old = %8u, New = %8u\n",
> +			 data->cur_firm_rev,
> +			 data->sensorhub_info->fw_rev);
> +	}
> +
> +	return FW_DL_STATE_NONE;
> +}
> diff --git a/drivers/misc/sensorhub/ssp_spi.c b/drivers/misc/sensorhub/ssp_spi.c
> new file mode 100644
> index 0000000..c546c4e
> --- /dev/null
> +++ b/drivers/misc/sensorhub/ssp_spi.c
> @@ -0,0 +1,700 @@
> +/*
> + *  Copyright (C) 2012, Samsung Electronics Co. Ltd. All Rights Reserved.
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
> +#define GET_MESSAGE_TYPE(data) (data & (3 << SSP_SPI))
> +
> +/* SSP -> AP Instruction */
A description of these would be good.
> +#define MSG2AP_INST_BYPASS_DATA			0x37
> +#define MSG2AP_INST_LIBRARY_DATA		0x01
> +#define MSG2AP_INST_DEBUG_DATA			0x03
> +#define MSG2AP_INST_BIG_DATA			0x04
> +#define MSG2AP_INST_META_DATA			0x05
> +#define MSG2AP_INST_TIME_SYNC			0x06
> +#define MSG2AP_INST_RESET			0x07
> +
> +#define UNINPLEMENTED -1
> +
> +static const int offset_map[SSP_SENSOR_MAX] = {
> +	[SSP_ACCELEROMETER_SENSOR] =		SSP_ACCELEROMETER_SIZE +
> +						SSP_TIME_SIZE,
> +	[SSP_GYROSCOPE_SENSOR] =		SSP_GYROSCOPE_SIZE+
> +						SSP_TIME_SIZE,
> +	[SSP_GEOMAGNETIC_UNCALIB_SENSOR] =	UNINPLEMENTED,
> +	[SSP_GEOMAGNETIC_RAW] =			UNINPLEMENTED,
> +	[SSP_GEOMAGNETIC_SENSOR] =		UNINPLEMENTED,
> +	[SSP_PRESSURE_SENSOR] =			UNINPLEMENTED,
> +	[SSP_GESTURE_SENSOR] =			UNINPLEMENTED,
> +	[SSP_PROXIMITY_SENSOR] =		UNINPLEMENTED,
> +	[SSP_TEMPERATURE_HUMIDITY_SENSOR] =	UNINPLEMENTED,
> +	[SSP_LIGHT_SENSOR] =			UNINPLEMENTED,
> +	[SSP_PROXIMITY_RAW] =			UNINPLEMENTED,
> +	[SSP_ORIENTATION_SENSOR] =		UNINPLEMENTED,
> +	[SSP_STEP_DETECTOR] =			UNINPLEMENTED,
> +	[SSP_SIG_MOTION_SENSOR] =		UNINPLEMENTED,
> +	[SSP_GYRO_UNCALIB_SENSOR] =		UNINPLEMENTED,
> +	[SSP_GAME_ROTATION_VECTOR] =		UNINPLEMENTED,
> +	[SSP_ROTATION_VECTOR] =			UNINPLEMENTED,
> +	[SSP_STEP_COUNTER] =			UNINPLEMENTED ,
> +	[SSP_BIO_HRM_RAW] =			SSP_BIO_HRM_RAW_SIZE +
> +						SSP_TIME_SIZE,
> +	[SSP_BIO_HRM_RAW_FAC] =			SSP_BIO_HRM_RAW_FAC_SIZE +
> +						SSP_TIME_SIZE,
> +	[SSP_BIO_HRM_LIB] =			SSP_BIO_HRM_LIB_SIZE +
> +						SSP_TIME_SIZE,
> +};
> +
> +static int print_mcu_debug(char *data_frame, int *data_index,
> +		    int received_len)
> +{
> +	int length = data_frame[(*data_index)++];
> +
> +	if (length > received_len - *data_index || length <= 0) {
> +		ssp_dbg("[SSP]: MSG From MCU-invalid debug length(%d/%d)\n",
> +			length, received_len);
> +		return length ? length : -1;
> +	}
> +
> +	ssp_dbg("[SSP]: MSG From MCU - %s\n", &data_frame[*data_index]);
> +	*data_index += length;
> +	return 0;
> +}
> +
> +static void clean_msg(struct ssp_msg *msg)
> +{
> +	if (msg->free_buffer)
> +		kfree(msg->buffer);
> +	kfree(msg);
> +}
> +
> +static int do_transfer(struct ssp_data *data, struct ssp_msg *msg,
> +		       struct completion *done, int timeout)
> +{
This may be the most complex write sequence I've seen for what
is basically an spi device!  If possible I'd like some comments
saying why it is doing the various steps.
> +	int status = 0;
> +	int delay_cnt = 0;
> +	bool msg_dead = false, ssp_down = false;
> +	/*FIXME REVISIT*/
Why do I get a feeling there might be something wrong in here? :)
> +	const bool use_no_irq = msg->length == 0;
> +
> +	msg->dead_hook = &msg_dead;
> +	msg->dead = false;
> +	msg->done = done;
> +
> +	mutex_lock(&data->comm_mutex);
> +
What's going on here?  What is going to wrench the gpio high
again between the set and the read back? If anything can perhaps
we should be looking at locking to prevent it rather than
effectively doing bus access negotiation using the gpio pin..

Also is this just a chip select control?  If so should be handled
by the spi bus, not this driver.
> +	gpio_set_value_cansleep(data->ap_mcu_int, 0);
> +	while (gpio_get_value_cansleep(data->mcu_ap_int)) {
> +		usleep_range(3000, 3500);
> +		ssp_down = data->shut_down;
> +		if (ssp_down || delay_cnt++ > 500) {
Please use slightly less cryptic error messages.
> +			dev_err(SSP_DEV, " %s - timeout 1\n", __func__);
> +			gpio_set_value_cansleep(data->ap_mcu_int, 1);
> +			status = -1;
> +			goto exit;
> +		}
> +	}
> +
> +	status = spi_write(data->spi, msg, 9);

> +	if (status != 0) {
> +		dev_err(SSP_DEV, "%s spi_write fail\n", __func__);
> +		gpio_set_value_cansleep(data->ap_mcu_int, 1);
> +		status = -1;
Meaningful error codes please.  I'd keep the result of spi_write in status
and return that.
> +		goto exit;
> +	}
> +
So if using irqs the message needs to be added to a list of messages
we are expecting a response for?
> +	if (!use_no_irq) {
> +		mutex_lock(&data->pending_mutex);
> +		list_add_tail(&msg->list, &data->pending_list);
> +		mutex_unlock(&data->pending_mutex);
> +	}
> +
> +	delay_cnt = 0;
This is another bit that looks like a work around for not having
appropriate locking.
> +	gpio_set_value_cansleep(data->ap_mcu_int, 1);
> +	while (!gpio_get_value_cansleep(data->mcu_ap_int)) {
> +		usleep_range(3000, 3500);
> +		ssp_down = data->shut_down;
> +		if (ssp_down || delay_cnt++ > 500) {
> +			dev_err(SSP_DEV, "%s - timeout 2\n", __func__);
> +			status = -2;
> +			goto exit;
> +		}
> +	}
> +
> +exit:
> +	mutex_unlock(&data->comm_mutex);
> +
> +	if (ssp_down)
> +		dev_err(SSP_DEV, "%s ssp down", __func__);
> +
Please don't mess with the return codes.  Handle the correct ones
or if absolutely necessary introduce another variable to indicate
which ones need this handling.  Here I can't see any reason
not to move this handling up to the cases that can cause it.
> +	if (status == -1) {
data->time_out_cnt += !ssp_down;
> +		data->time_out_cnt += ssp_down ? 0 : 1;
> +		clean_msg(msg);
> +		return status;
> +	}
> +
> +	if (status == 0 && done != NULL)
> +		if (wait_for_completion_timeout(done,
> +						msecs_to_jiffies(timeout)) == 0)
> +			status = -2;
> +
> +	mutex_lock(&data->pending_mutex);
> +	if (!msg_dead) {
> +		msg->done = NULL;
> +		msg->dead_hook = NULL;
> +
> +		if (status != 0)
> +			msg->dead = true;
> +		if (status == -2)
> +			data->time_out_cnt += ssp_down ? 0 : 1;
> +	}
> +	mutex_unlock(&data->pending_mutex);
> +
> +	if (use_no_irq)
> +		clean_msg(msg);
> +
> +	return status;
> +}
> +
> +static inline int ssp_spi_async(struct ssp_data *data, struct ssp_msg *msg)
> +{
> +	return do_transfer(data, msg, NULL, 0);
> +}
> +
> +static int ssp_spi_sync(struct ssp_data *data, struct ssp_msg *msg, int timeout)
> +{
> +	DECLARE_COMPLETION_ONSTACK(done);
> +
> +	/* len 0 means that we do not expect an answer after an interrupt */
> +	if (msg->length == 0) {
> +		dev_err(SSP_DEV, "%s length must not be 0\n", __func__);
> +		clean_msg(msg);
> +		return 0;
> +	}
> +
> +	return do_transfer(data, msg, &done, timeout);
> +}
> +
Could do with a descriptive comment.  What is 'big' in this context?
> +static int handle_big_data(struct ssp_data *data, char *dataframe,
> +			   int *idx) {
> +	/* FIXME REWORK*/
> +	u8 big_type = 0;
> +	struct ssp_big *big = kzalloc(sizeof(*big), GFP_KERNEL);
> +
> +	big->data = data;
> +	big_type = dataframe[(*idx)++];
> +	memcpy(&big->length, dataframe + *idx, 4);
> +	*idx += 4;
> +	memcpy(&big->addr, dataframe + *idx, 4);
> +	*idx += 4;
> +
> +	if (big_type >= BIG_TYPE_MAX) {
> +		kfree(big);
> +		return -EINVAL;
> +	}
> +
> +	INIT_WORK(&big->work, data->ssp_big_task[big_type]);
> +	queue_work(data->wdt_wq, &big->work);
> +
> +	return 0;
> +}
> +
> +static int parse_dataframe(struct ssp_data *data, char *dataframe,
> +				int len)
> +{
> +	int idx, sd, ret = 0;
> +	u16 length = 0;
> +	struct timespec ts;
> +	struct ssp_sensor_data *sdata;
> +	struct iio_dev **indio_devs = data->sensor_devs;
> +
> +	getnstimeofday(&ts);
> +
> +	for (idx = 0; idx < len;) {
> +		switch (dataframe[idx++]) {
> +		case MSG2AP_INST_BYPASS_DATA:
> +			sd = dataframe[idx++];
> +			if ((sd < 0) || (sd >= SSP_SENSOR_MAX)) {
> +				dev_err(SSP_DEV,
> +					"Mcu data frame1 error %d\n", sd);
> +				return -1;
> +			}
> +
> +			if (indio_devs[sd] != NULL) {
> +				sdata = iio_priv(indio_devs[sd]);
> +				if (sdata->process_data)
> +					sdata->process_data(
> +							indio_devs[sd],
> +							&dataframe[idx],
> +							data->timestamp);
> +			}
> +			idx += offset_map[sd];
> +			break;
> +		case MSG2AP_INST_DEBUG_DATA:
> +			sd = print_mcu_debug(dataframe, &idx, len);
> +			if (sd) {
> +				dev_err(SSP_DEV,
> +					"Mcu data frame3 error %d\n", sd);
> +				return -1;
> +			}
> +			break;
> +		case MSG2AP_INST_LIBRARY_DATA:
> +			idx += length;
> +			break;
> +		case MSG2AP_INST_BIG_DATA:
> +			handle_big_data(data, dataframe, &idx);
> +			break;
> +		case MSG2AP_INST_TIME_SYNC:
> +			data->time_syncing = true;
> +			break;
> +		case MSG2AP_INST_RESET:
> +			queue_refresh_task(data, 0);
> +			break;
> +		}
> +	}
> +
> +	if (data->time_syncing)
> +		data->timestamp = ts.tv_sec * 1000000000ULL + ts.tv_nsec;
> +
> +	return ret;
> +}
> +
> +int select_irq_msg(struct ssp_data *data)
> +{
> +	bool found = false;
> +	char *buffer;
> +	unsigned char msg_type = 0;
> +	char temp_buf[4] = {-1};
> +	int ret = 0;
> +	unsigned short length, msg_options;
> +	__le16 len, mo;
> +	struct ssp_msg *msg, *n;
> +
temp_buf is not in it's own cacheline and so you might run into problems
with cacheline corruption from the dma transfer.  Use a kmalloc for it
to avoid this.
> +	ret = spi_read(data->spi, temp_buf, sizeof(temp_buf));
> +	if (ret < 0) {
> +		dev_err(SSP_DEV, "header read fail\n");
> +		return ret;
> +	}
> +
> +	memcpy(&mo, temp_buf, 2);
> +	memcpy(&len, &temp_buf[2], 2);
Just make temp_buf an array of __le16 and then access it directly.
> +
> +	length = le16_to_cpu(len);
> +	msg_options = le16_to_cpu(mo);
> +
> +	msg_type = GET_MESSAGE_TYPE(msg_options);
> +
> +	switch (msg_type) {
> +	case AP2HUB_READ:
> +	case AP2HUB_WRITE:
> +		mutex_lock(&data->pending_mutex);
So from this I guess there is no guarantee about the order in which
the sensor hub replies?  Just how many entries might this list have?
Do we need something more sophisticated than a simple linked list
to make the search quick enough?
> +		if (!list_empty(&data->pending_list)) {
> +			list_for_each_entry_safe(msg, n, &data->pending_list,
> +						 list) {
> +				if (msg->options == msg_options) {
> +					list_del(&msg->list);
> +					found = true;
> +					break;
> +				}
> +			}
> +
> +			if (!found) {
> +				dev_err(SSP_DEV, "Not match error %x\n",
> +					msg_options);
> +				goto exit;
> +			}
> +
> +			if (msg->dead && !msg->free_buffer) {
> +				msg->buffer = kzalloc(msg->length, GFP_KERNEL);
> +				msg->free_buffer = 1;
> +			} /* For dead msg, make a temporary buffer to read. */
> +
> +			if (msg_type == AP2HUB_READ)
> +				ret = spi_read(data->spi, msg->buffer,
> +					       msg->length);
> +			if (msg_type == AP2HUB_WRITE) {
> +				ret = spi_write(data->spi, msg->buffer,
> +						msg->length);
> +				if (msg_options & AP2HUB_RETURN) {
> +					msg->options =
> +						AP2HUB_READ | AP2HUB_RETURN;
> +					msg->length = 1;
> +					list_add_tail(&msg->list,
> +						      &data->pending_list);
> +					goto exit;
> +				}
> +			}
> +
> +			if (msg->done != NULL && !completion_done(msg->done))
> +				complete(msg->done);
> +			if (msg->dead_hook != NULL)
> +				*(msg->dead_hook) = true;
> +
> +			clean_msg(msg);
> +		} else
> +			dev_err(SSP_DEV, "List empty error(%d)\n",
> +				msg_type);
> +exit:
> +		mutex_unlock(&data->pending_mutex);
> +		break;
> +	case HUB2AP_WRITE:
> +		buffer = kzalloc(length, GFP_KERNEL);
> +		if (buffer == NULL) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		ret = spi_read(data->spi, buffer, length);
> +		if (ret < 0) {
> +			dev_err(SSP_DEV, "spi read fail\n");
  Not freeing buffer...
> +			break;
> +		}
> +
> +		/* FIXME no return ! */
> +		parse_dataframe(data, buffer, length);
> +
> +		kfree(buffer);
> +		break;
> +
> +	default:
> +		dev_err(SSP_DEV, "unknown msg type\n");
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +void clean_pending_list(struct ssp_data *data)
> +{
> +	struct ssp_msg *msg, *n;
> +
> +	mutex_lock(&data->pending_mutex);
> +	list_for_each_entry_safe(msg, n, &data->pending_list, list) {
> +		list_del(&msg->list);
> +		if (msg->done != NULL && !completion_done(msg->done))
> +			complete(msg->done);
> +		if (msg->dead_hook != NULL)
> +			*(msg->dead_hook) = true;
> +
> +		clean_msg(msg);
> +	}
> +	mutex_unlock(&data->pending_mutex);
> +}
> +
> +int ssp_send_cmd(struct ssp_data *data, char command, int arg)
> +{
> +	struct ssp_msg *msg = kzalloc(sizeof(*msg), GFP_KERNEL);
> +
> +	if (msg == NULL)
> +		return -ENOMEM;
> +
One blank line only please.
> +
> +	msg->cmd = command;
> +	msg->length = 0;
> +	msg->options = AP2HUB_WRITE;
> +	msg->data = cpu_to_le32(arg);
> +	msg->free_buffer = 0;
> +
> +	ssp_dbg("%s - command 0x%x %d\n", __func__, command, arg);
> +
> +	return ssp_spi_async(data, msg);
> +}
> +
> +int ssp_send_instruction(struct ssp_data *data, unsigned char inst,
> +		     unsigned char  sensor_type,  unsigned char  *send_buf,
> +		     unsigned char length)
> +{
> +	struct ssp_msg *msg;
> +
> +	if (data->fw_dl_state == FW_DL_STATE_DOWNLOADING) {
> +		dev_err(SSP_DEV, "%s - Skip Inst! DL state = %d\n",
> +			__func__, data->fw_dl_state);
> +		return -EBUSY;
> +	} else if ((!(data->sensor_state & (1 << sensor_type)))
> +		   && (inst <= MSG2SSP_INST_CHANGE_DELAY)) {
> +		dev_err(SSP_DEV, "%s - Bypass Inst Skip! - %u\n",
> +			__func__, sensor_type);
> +		return -1; /* just fail */
> +	}
> +
> +	msg = kzalloc(sizeof(*msg), GFP_KERNEL);
> +	if (msg == NULL)
> +		return -ENOMEM;
> +
> +	msg->cmd = inst;
> +	msg->length = length + 2;
> +	msg->options = AP2HUB_WRITE;
> +	msg->buffer = kzalloc(length + 2, GFP_KERNEL);
> +	if (!msg->buffer) {
> +		kfree(msg);
> +		return -ENOMEM;
> +	}
> +	msg->free_buffer = 1;
> +
> +	msg->buffer[0] = sensor_type;
> +	memcpy(&msg->buffer[1], send_buf, length);
> +
> +	ssp_dbg("%s - Inst = 0x%x, Sensor Type = 0x%x, data = %u\n",
> +		__func__, command, sensor_type, msg->buffer[1]);
> +
> +	return ssp_spi_sync(data, msg, 1000);
> +}
> +
Comment on why we might want to flush.
> +int flush(struct ssp_data *data, u8 sensor_type)
> +{
> +	int ret = 0;
> +	char buffer = 0;
> +
> +	struct ssp_msg *msg = kzalloc(sizeof(*msg), GFP_KERNEL);
> +
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	msg->cmd = MSG2SSP_AP_MCU_BATCH_FLUSH;
> +	msg->length = 1;
> +	msg->options = AP2HUB_READ;
> +	msg->data = cpu_to_le32(sensor_type);
> +	msg->buffer = &buffer;
> +	msg->free_buffer = 0;
> +
> +	ret = ssp_spi_sync(data, msg, 1000);
> +	if (ret < 0) {
> +		dev_err(SSP_DEV, "%s - fail %d\n", __func__, ret);
> +		return ret;
> +	}
> +
> +	ssp_dbg("%s Sensor Type = 0x%x, data = %u\n", __func__, sensor_type,
> +			buffer);
> +
> +	return buffer ? 0 : -1;
> +}
> +
> +int get_chipid(struct ssp_data *data)
> +{
> +	int ret, retries = 0;
> +	char buffer = 0;
> +	struct ssp_msg *msg;
> +
Why would we need retries for this?  To have this in the driver
you need an explanation of why it might validly not work first time.

> +	while (retries++ < 3) {
> +		msg = kzalloc(sizeof(*msg), GFP_KERNEL);
> +		if (!msg)
> +			return -ENOMEM;
> +
> +		msg->cmd = MSG2SSP_AP_WHOAMI;
> +		msg->length = 1;
> +		msg->options = AP2HUB_READ;
> +		msg->buffer = &buffer;
> +		msg->free_buffer = 0;
> +
> +		ret = ssp_spi_sync(data, msg, 1000);
> +		if (ret < 0) {
> +			dev_err(SSP_DEV, "%s read fail\n", __func__);
> +			continue;
> +		}
> +
> +		if (buffer == DEVICE_ID)
> +			return buffer;
> +	}
> +
> +	dev_err(SSP_DEV, "%s get chip ID fail\n", __func__);
> +
> +	return -EIO;
> +}
> +
> +
Single blank lines are almost always enough so clean these double ones
out.
> +int set_sensor_position(struct ssp_data *data)
> +{
> +	int ret = 0;
No need for the initialization.
> +
No need for a blank line here.
> +	struct ssp_msg *msg = kzalloc(sizeof(*msg), GFP_KERNEL);
> +
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	msg->cmd = MSG2SSP_AP_SENSOR_FORMATION;
> +	msg->length = 3;
> +	msg->options = AP2HUB_WRITE;
> +	msg->buffer = kzalloc(3, GFP_KERNEL);
> +	if (!msg->buffer) {
> +		kfree(msg);
> +		return -ENOMEM;
> +	}
> +
> +	msg->free_buffer = 1;
> +	/*FIXME char = int*/
Please deal with all these FIXME points before next version.
Fair enough in an RFC but not always obvious what you are getting at!
> +	msg->buffer[0] = data->accel_position;
> +	msg->buffer[1] = data->accel_position;
> +	msg->buffer[2] = data->mag_position;
> +
> +	ret = ssp_spi_async(data, msg);
> +	if (ret < 0) {
> +		dev_err(SSP_DEV, "%s -fail to set_sensor_position %d\n",
> +			__func__, ret);
> +	} else {
> +		dev_info(SSP_DEV,
> +			 "Sensor Posision A : %u, G : %u, M: %u, P: %u\n",
> +			 data->accel_position, data->accel_position,
> +			 data->mag_position, 0);
> +	}
> +
> +	return ret;
> +}
> +
> +int set_magnetic_static_matrix(struct ssp_data *data)
> +{
> +	struct ssp_msg *msg = kzalloc(sizeof(*msg), GFP_KERNEL);
> +
> +	if (msg == NULL)
> +		return -ENOMEM;
> +
> +	msg->cmd = MSG2SSP_AP_SET_MAGNETIC_STATIC_MATRIX;
> +	msg->length = data->mag_matrix_size;
> +	msg->options = AP2HUB_WRITE;
> +
> +	msg->buffer = kzalloc(data->mag_matrix_size, GFP_KERNEL);
> +	if (!msg->buffer) {
> +		kfree(msg);
> +		return -ENOMEM;
> +	}
> +
> +	msg->free_buffer = 1;
> +	/* matrix is u8 so do not bother with endianness*/
> +	memcpy(msg->buffer, data->mag_matrix, data->mag_matrix_size);
> +
> +	return ssp_spi_async(data, msg);
> +}
> +
> +unsigned int get_sensor_scanning_info(struct ssp_data *data)
> +{
> +	int ret, z;
> +	__le32 result;
> +	u32 cpu_result;
> +	char bin[SSP_SENSOR_MAX + 1] = {0};
Any need to initialize this other than the last element?
> +
> +	struct ssp_msg *msg = kzalloc(sizeof(*msg), GFP_KERNEL);
> +
> +	if (!msg)
> +		return 0;
> +
> +	msg->cmd = MSG2SSP_AP_SENSOR_SCANNING;
> +	msg->length = 4;
> +	msg->options = AP2HUB_READ;
> +	msg->buffer = (char *)&result;
> +	msg->free_buffer = 0;
> +
> +	ret = ssp_spi_sync(data, msg, 1000);
> +	if (ret < 0) {
> +		dev_err(SSP_DEV, "%s - spi read fail %d\n", __func__, ret);
> +		return 0;
> +	}
> +
> +	cpu_result = le32_to_cpu(result);
> +
> +	for (z = 0; z < SSP_SENSOR_MAX; ++z)
> +		bin[SSP_SENSOR_MAX - 1 - z] =
!(cpu_result & (1 << z));
> +			(cpu_result & (1 << z)) ? '1' : '0';
> +
> +	dev_info(SSP_DEV, "%s state: %s\n", __func__, bin);
> +
> +	return cpu_result;
> +}
> +
> +unsigned int get_firmware_rev(struct ssp_data *data)
> +{
> +	int ret;
> +	__le32 result;
> +
> +	struct ssp_msg *msg = kzalloc(sizeof(*msg), GFP_KERNEL);
> +
> +	if (!msg)
> +		return  SSP_INVALID_REVISION;
> +
> +	msg->cmd = MSG2SSP_AP_FIRMWARE_REV;
> +	msg->length = 4;
> +	msg->options = AP2HUB_READ;
> +	msg->buffer = (char *)&result;
> +	msg->free_buffer = 0;
> +
> +	ret = ssp_spi_sync(data, msg, 1000);
> +	if (ret  < 0) {
> +		dev_err(SSP_DEV, "%s - transfer fail %d\n", __func__, ret);
> +		return SSP_INVALID_REVISION;
> +	}
> +
> +	return le32_to_cpu(result);
> +}
> +
Please prefix everything with ssp to avoid possible name clashes in future
> +int get_fuserom_data(struct ssp_data *data)
> +{
> +	int ret = 0;
> +	char buffer[3] = {0};
> +
> +	struct ssp_msg *msg = kzalloc(sizeof(*msg), GFP_KERNEL);
> +
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	msg->cmd = MSG2SSP_AP_FUSEROM;
> +	msg->length = sizeof(buffer);
> +	msg->options = AP2HUB_READ;
> +	msg->buffer = buffer;
> +	msg->free_buffer = 0;
> +
> +	ret = ssp_spi_sync(data, msg, 1000);
> +	if (ret >= 0) {
> +		data->fuse_rom_data[0] = buffer[0];
> +		data->fuse_rom_data[1] = buffer[1];
> +		data->fuse_rom_data[2] = buffer[2];
> +	} else {
> +		data->fuse_rom_data[0] = 0;
> +		data->fuse_rom_data[1] = 0;
> +		data->fuse_rom_data[2] = 0;
> +		return ret;
> +	}
> +
> +	dev_info(SSP_DEV, "FUSE ROM Data %d , %d, %d\n",
> +		 data->fuse_rom_data[0], data->fuse_rom_data[1],
> +		 data->fuse_rom_data[2]);
> +
> +	return 0;
> +}
> +
> +int ssp_start_big_data(struct ssp_data *data, u8 type, u32 len)
> +{
> +	__le32 llen;
> +
> +	struct ssp_msg *msg = kzalloc(sizeof(*msg), GFP_KERNEL);
> +
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	msg->cmd = MSG2SSP_AP_START_BIG_DATA;
> +	msg->length = 5;
> +	msg->options = AP2HUB_WRITE;
> +	msg->buffer = kzalloc(msg->length, GFP_KERNEL);
> +	if (!msg->buffer) {
> +		kfree(msg);
> +		return -ENOMEM;
> +	}
> +
> +	msg->free_buffer = 1;
> +	msg->buffer[0] = type;
You put type in buffer[0] here..
> +
> +	llen = cpu_to_le32(len);
> +	memcpy(&msg->buffer, &llen, sizeof(unsigned int));
This is unusual.  You then write the address of buffer with its length
rather than, as I suspect, was intended the first element.  But you've
just written type into the first element...

> +
> +	return ssp_spi_async(data, msg);
> +}
>
