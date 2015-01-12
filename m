Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbbALLvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:51:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbbALLvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:51:03 -0500
Message-ID: <1421063449.12454.17.camel@linux-0dmf.site>
Subject: Re: [PATCH 1/2] INPUT/HID: add touch support for SiS touch driver
From: Oliver Neukum <oneukum@suse.de>
To: =?UTF-8?Q?=E6=9B=BE=E5=A9=B7=E8=91=B3?= "(tammy_tseng)" 
	<tammy_tseng@sis.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        tammy0524@gmail.com
Date: Mon, 12 Jan 2015 12:50:49 +0100
In-Reply-To: <8322374EB97AA24A95D0DDBFC8F1CA1DBF987B@SISMBEV01.sis.com.tw>
References: <8322374EB97AA24A95D0DDBFC8F1CA1DBF987B@SISMBEV01.sis.com.tw>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 18:53 +0800, 曾婷葳 (tammy_tseng) wrote:
> Hi,
> This package of patch is to add support for multitouch behavior for SiS touch products.
> The patch of SiS i2c multitouch driver is in input/touchscreen.
> 
> Signed-off-by: Tammy Tseng <tammy_tseng@sis.com>
> 
> ---
> diff --git a/linux-3.18.1/drivers/input/touchscreen/Kconfig b/linux-3.18.1/drivers/input/touchscreen/Kconfig
> index e1d8003..edc8e27 100644
> --- a/linux-3.18.1/drivers/input/touchscreen/Kconfig
> +++ b/linux-3.18.1/drivers/input/touchscreen/Kconfig
> @@ -962,4 +962,18 @@ config TOUCHSCREEN_ZFORCE
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called zforce_ts.
>  
> +config TOUCHSCREEN_SIS_I2C
> +	tristate "SiS 9200 family I2C touchscreen driver"
> +	depends on I2C
> +	default y

Why that default? The majority of systems will not feature this
touchscreens.

> +	help
> +	  This enables support for SiS 9200 family over I2C based touchscreens.
> +
> +config FW_SUPPORT_POWERMODE
> +		default n
> +        bool "SiS FW support power mode"
> +        depends on TOUCHSCREEN_SIS_I2C
> +        help
> +          This enables support power mode provided by SiS firmwave

What does this mode do? The help should be more extensive to be
helpful.

> +
>  endif
> diff --git a/linux-3.18.1/drivers/input/touchscreen/Makefile b/linux-3.18.1/drivers/input/touchscreen/Makefile
> index 090e61c..e316477 100644
> --- a/linux-3.18.1/drivers/input/touchscreen/Makefile
> +++ b/linux-3.18.1/drivers/input/touchscreen/Makefile
> @@ -6,6 +6,10 @@
>  
>  wm97xx-ts-y := wm97xx-core.o
>  
> +ifdef CONFIG_TOUCHSCREEN_SIS_I2C
> +obj-$(CONFIG_TOUCHSCREEN_SIS_I2C)   += sis_i2c.o
> +endif
> +
>  obj-$(CONFIG_OF_TOUCHSCREEN)		+= of_touchscreen.o
>  obj-$(CONFIG_TOUCHSCREEN_88PM860X)	+= 88pm860x-ts.o
>  obj-$(CONFIG_TOUCHSCREEN_AD7877)	+= ad7877.o
> diff --git a/linux-3.18.1/drivers/input/touchscreen/sis_i2c.c b/linux-3.18.1/drivers/input/touchscreen/sis_i2c.c
> new file mode 100644
> index 0000000..2e6fc1a
> --- /dev/null
> +++ b/linux-3.18.1/drivers/input/touchscreen/sis_i2c.c
> @@ -0,0 +1,1725 @@
> +/* drivers/input/touchscreen/sis_i2c.c - I2C Touch panel driver for SiS 9200 family
> + *
> + * Copyright (C) 2011 SiS, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Date: 2012/11/13
> + * Version:	Android_v2.05.00-A639-1113
> + */
> +
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#ifdef CONFIG_HAS_EARLYSUSPEND
> +#include <linux/earlysuspend.h>
> +#endif

Conditional includes should be avoided if possible.

> +#include <linux/hrtimer.h>
> +#include <linux/i2c.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include "sis_i2c.h"
> +#include <linux/linkage.h>
> +#include <linux/slab.h>
> +#include <linux/gpio.h>
> +#include <asm/uaccess.h>
> +#include <linux/irq.h>
> +
> +#ifdef _STD_RW_IO

???

> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/cdev.h>
> +#define DEVICE_NAME "sis_aegis_touch_device"
> +static int sis_char_devs_count = 1;        /* device count */

Why start with 1 ?
> +static int sis_char_major = 0;
> +static struct cdev sis_char_cdev;
> +static struct class *sis_char_class = NULL;
> +#endif
> +
> +/* Addresses to scan */
> +static const unsigned short normal_i2c[] = { SIS_SLAVE_ADDR, I2C_CLIENT_END };
> +static struct workqueue_struct *sis_wq;
> +struct sis_ts_data *ts_bak = 0;
> +struct sisTP_driver_data *TPInfo = NULL;

Are you really sure you are limited to a single device?
> +static void sis_tpinfo_clear(struct sisTP_driver_data *TPInfo, int max);
> +
> +#ifdef CONFIG_HAS_EARLYSUSPEND
> +static void sis_ts_early_suspend(struct early_suspend *h);
> +static void sis_ts_late_resume(struct early_suspend *h);
> +#endif
> +
> +#ifdef CONFIG_X86
> +//static const struct i2c_client_address_data addr_data;
> +/* Insmod parameters */
> +static int sis_ts_detect(struct i2c_client *client, struct i2c_board_info *info);
> +#endif
> +
> +#ifdef _CHECK_CRC
> +uint16_t cal_crc (char* cmd, int start, int end);
> +#endif
> +
> +void PrintBuffer(int start, int length, char* buf)

Polluting the name space like this is really nasty.
Could you check which of your declarations can be
declared "static"?

> +{
> +	int i;
> +	for ( i = start; i < length; i++ )
> +	{
> +		printk("%02x ", buf[i]);
> +		if (i != 0 && i % 30 == 0)
> +			printk("\n");
> +	}
> +	printk("\n");	
> +}
> +
> +int sis_command_for_write(struct i2c_client *client, int wlength, unsigned char *wdata)
> +{
> +    int ret = -1;
> +    struct i2c_msg msg[1];

Why on earth an array of a single element?

> +
> +    msg[0].addr = client->addr;
> +    msg[0].flags = 0; //Write
> +    msg[0].len = wlength;
> +    msg[0].buf = (unsigned char *)wdata;
> +
> +    ret = i2c_transfer(client->adapter, msg, 1);
> +
> +    return ret;
> +}
> +
> +int sis_command_for_read(struct i2c_client *client, int rlength, unsigned char *rdata)
> +{
> +    int ret = -1;
> +    struct i2c_msg msg[1];

Likewise

> +
> +    msg[0].addr = client->addr;
> +    msg[0].flags = I2C_M_RD; //Read
> +    msg[0].len = rlength;
> +    msg[0].buf = rdata;
> +
> +    ret = i2c_transfer(client->adapter, msg, 1);
> +
> +    return ret;
> +}
> +
> +int sis_cul_unit(uint8_t report_id)
> +{
> +	int basic = 6;
> +	int area = 2;
> +	int pressure = 1;
> +	int ret = basic;

Why ???
> +	
> +	if (report_id != ALL_IN_ONE_PACKAGE)
> +	{
> +		if (IS_AREA(report_id) /*&& IS_TOUCH(report_id)*/)
> +		{
> +			ret += area;
> +		}
> +		if (IS_PRESSURE(report_id))
> +		{
> +			ret += pressure;
> +		}
> +	}
> +	
> +	return ret;	
> +}
> +
> +int sis_ReadPacket(struct i2c_client *client, uint8_t cmd, uint8_t* buf)
> +{
> +	uint8_t tmpbuf[MAX_BYTE] = {0};	//MAX_BYTE = 64;
> +#ifdef _CHECK_CRC
> +	uint16_t buf_crc = 0;
> +	uint16_t package_crc = 0;
> +	int l_package_crc = 0;
> +	int crc_end = 0;
> +#endif
> +    int ret = -1;
> +    int touchnum = 0;
> +    int p_count = 0;
> +    int touc_formate_id = 0;
> +    int locate = 0;
> +    bool read_first = true;
> +    
> +/*
> +		New i2c format 
> +	* buf[0] = Low 8 bits of byte count value
> +	* buf[1] = High 8 bits of byte counte value
> +	* buf[2] = Report ID
> +	* buf[touch num * 6 + 2 ] = Touch informations; 1 touch point has 6 bytes, it could be none if no touch 
> +	* buf[touch num * 6 + 3] = Touch numbers
> +	* 
> +	* One touch point information include 6 bytes, the order is 
> +	* 
> +	* 1. status = touch down or touch up
> +	* 2. id = finger id 
> +	* 3. x axis low 8 bits
> +	* 4. x axis high 8 bits
> +	* 5. y axis low 8 bits
> +	* 6. y axis high 8 bits
> +	* 
> +*/
> +	do
> +	{
> +		if (locate >= PACKET_BUFFER_SIZE)
> +		{
> +			printk(KERN_ERR "sis_ReadPacket: Buf Overflow\n");
> +			return -1;
> +		}
> +		
> +		ret = sis_command_for_read(client, MAX_BYTE, tmpbuf);
> +
> +#ifdef _DEBUG_PACKAGE
> +		printk(KERN_INFO "chaoban test: Buf_Data [0~63] \n");
> +		PrintBuffer(0, 64, tmpbuf);	
> +#endif			
> +
> +		if(ret < 0 )
> +		{
> +			printk(KERN_ERR "sis_ReadPacket: i2c transfer error\n");

It would be nicer to use the debug methods defined for devices, so that
you get device identification in the log for free.

> +			return ret;
> +		}
> +		// error package length of receiving data
> +		else if (tmpbuf[P_BYTECOUNT] > MAX_BYTE)

This looks like a bug. You are checking only the lower byte.

> +		{
> +			printk(KERN_ERR "sis_ReadPacket: Error Bytecount\n");
> +			return -1;	
> +		}
> +		
> +		if (read_first)
> +		{
> +#ifdef _SUPPORT_BUTTON_TOUCH
> +			// access BUTTON TOUCH event and BUTTON NO TOUCH event
> +			if (tmpbuf[P_REPORT_ID] ==  BUTTON_FORMAT)
> +			{
> +				memcpy(&buf[0], &tmpbuf[0], 7);
> +				return touchnum; 	//touchnum is 0

So why not return 0 ?

> +			}
> +#endif 
> +			// access NO TOUCH event unless BUTTON NO TOUCH event
> +			if (tmpbuf[P_BYTECOUNT] == 0/*NO_TOUCH_BYTECOUNT*/)
> +			{
> +				return touchnum;	//touchnum is 0
> +			}
> +		}
> +
> +		//skip parsing data when two devices are registered at the same slave address
> +		//parsing data when P_REPORT_ID && 0xf is TOUCH_FORMAT or P_REPORT_ID is ALL_IN_ONE_PACKAGE
> +		touc_formate_id = tmpbuf[P_REPORT_ID] & 0xf;
> +		if ((touc_formate_id != TOUCH_FORMAT) && (touc_formate_id != HIDI2C_FORMAT) && (tmpbuf[P_REPORT_ID] != ALL_IN_ONE_PACKAGE))
> +		{
> +			printk(KERN_ERR "sis_ReadPacket: Error Report_ID\n");
> +			return -1;		
> +		}
> +		
> +		p_count = (int) tmpbuf[P_BYTECOUNT] - 1;	//start from 0
> +		if (tmpbuf[P_REPORT_ID] != ALL_IN_ONE_PACKAGE)
> +		{
> +			if (IS_TOUCH(tmpbuf[P_REPORT_ID]))
> +			{
> +				p_count -= BYTE_CRC_I2C;	//delete 2 byte crc
> +			}
> +			else if (IS_HIDI2C(tmpbuf[P_REPORT_ID]))
> +			{
> +				p_count -= BYTE_CRC_HIDI2C;
> +			}
> +			else	//should not be happen
> +			{
> +				printk(KERN_ERR "sis_ReadPacket: delete crc error\n");
> +				return -1;
> +			}
> +
> +			if (IS_SCANTIME(tmpbuf[P_REPORT_ID]))
> +			{
> +				p_count -= BYTE_SCANTIME;
> +			}
> +		}
> +		//else {}    						// For ALL_IN_ONE_PACKAGE
> +		
> +		if (read_first)
> +		{
> +			touchnum = tmpbuf[p_count]; 	
> +		}
> +		else
> +		{
> +			if (tmpbuf[p_count] != 0)
> +			{
> +				printk(KERN_ERR "sis_ReadPacket: get error package\n");
> +				return -1;
> +			}
> +		}
> +
> +#ifdef _CHECK_CRC
> +		crc_end = p_count + (IS_SCANTIME(tmpbuf[P_REPORT_ID]) * 2);
> +		buf_crc = cal_crc(tmpbuf, 2, crc_end); //sub bytecount (2 byte)
> +		l_package_crc = p_count + 1 + (IS_SCANTIME(tmpbuf[P_REPORT_ID]) * 2);
> +		package_crc = ((tmpbuf[l_package_crc] & 0xff) | ((tmpbuf[l_package_crc + 1] & 0xff) << 8));

We have macros to read data in a defined endianness

> +			
> +		if (buf_crc != package_crc)
> +		{
> +			printk(KERN_ERR "sis_ReadPacket: CRC Error\n");
> +			return -1;
> +		}
> +#endif	
> +		memcpy(&buf[locate], &tmpbuf[0], 64);	//Buf_Data [0~63] [64~128]
> +		locate += 64;
> +		read_first = false;
> +		
> +	}while(tmpbuf[P_REPORT_ID] != ALL_IN_ONE_PACKAGE  &&  tmpbuf[p_count] > 5);
> +
> +	return touchnum;
> +}	
> +
> +
> +int check_gpio_interrupt(void)
> +{
> +    int ret = 0;
> +    //TODO
> +    //CHECK GPIO INTERRUPT STATUS BY YOUR PLATFORM SETTING.
> +    ret = gpio_get_value(GPIO_IRQ);
> +    return ret;
> +}
> +
> +void ts_report_key(struct i2c_client *client, uint8_t keybit_state)
> +{
> +	int i = 0;
> +	uint8_t diff_keybit_state= 0x0; //check keybit_state is difference with pre_keybit_state
> +	uint8_t key_value = 0x0; //button location for binary
> +	uint8_t  key_pressed = 0x0; //button is up or down
> +	struct sis_ts_data *ts = i2c_get_clientdata(client);
> +
> +	if (!ts)
> +	{
> +		printk(KERN_ERR "%s error: Missing Platform Data!\n", __func__);
> +		return;
> +	}
> +
> +	diff_keybit_state = TPInfo->pre_keybit_state ^ keybit_state;
> +
> +	if (diff_keybit_state)
> +	{
> +		for (i = 0; i < BUTTON_KEY_COUNT; i++)
> +		{
> +		    if ((diff_keybit_state >> i) & 0x01)
> +			{
> +				key_value = diff_keybit_state & (0x01 << i);
> +				key_pressed = (keybit_state >> i) & 0x01;
> +				switch (key_value)
> +				{
> +					case MSK_COMP:
> +						input_report_key(ts->input_dev, KEY_COMPOSE, key_pressed);
> +						printk(KERN_ERR "%s : MSK_COMP %d \n", __func__ , key_pressed);
> +						break;
> +					case MSK_BACK:
> +						input_report_key(ts->input_dev, KEY_BACK, key_pressed);
> +						printk(KERN_ERR "%s : MSK_BACK %d \n", __func__ , key_pressed);
> +						break;
> +					case MSK_MENU:
> +						input_report_key(ts->input_dev, KEY_MENU, key_pressed);
> +						printk(KERN_ERR "%s : MSK_MENU %d \n", __func__ , key_pressed);
> +						break;
> +					case MSK_HOME:
> +						input_report_key(ts->input_dev, KEY_HOME, key_pressed);
> +						printk(KERN_ERR "%s : MSK_HOME %d \n", __func__ , key_pressed);
> +						break;
> +					case MSK_NOBTN:
> +						//Release the button if it touched.
> +					default:
> +						break;
> +				}
> +			}
> +		}
> +		TPInfo->pre_keybit_state = keybit_state;
> +	}
> +}
> +
> +
> +static void sis_ts_work_func(struct work_struct *work)
> +{
> +	struct sis_ts_data *ts = container_of(work, struct sis_ts_data, work);
> +    int ret = -1;
> +    int point_unit;  
> +	uint8_t buf[PACKET_BUFFER_SIZE] = {0};
> +	uint8_t i = 0, fingers = 0;
> +	uint8_t px = 0, py = 0, pstatus = 0;
> +	uint8_t p_area = 0;
> +    uint8_t p_preasure = 0;
> +#ifdef _SUPPORT_BUTTON_TOUCH	
> +	int button_key;
> +	uint8_t button_buf[10] = {0};
> +#endif
> +
> +#ifdef _ANDROID_4
> +	bool all_touch_up = true;
> +#endif
> +	
> +	mutex_lock(&ts->mutex_wq); 
> +
> +    /* I2C or SMBUS block data read */
> +    ret = sis_ReadPacket(ts->client, SIS_CMD_NORMAL, buf);
> +#ifdef _DEBUG_PACKAGE_WORKFUNC
> +	printk(KERN_INFO "chaoban test: Buf_Data [0~63] \n");
> +	PrintBuffer(0, 64, buf);			
> +	if ((buf[P_REPORT_ID] != ALL_IN_ONE_PACKAGE) && (ret > 5))
> +	{
> +		printk(KERN_INFO "chaoban test: Buf_Data [64~125] \n");
> +		PrintBuffer(64, 128, buf);	
> +	}
> +#endif
> +
> +// add 
> +#ifdef _SUPPORT_BUTTON_TOUCH
> +	 sis_ReadPacket(ts->client, SIS_CMD_NORMAL, button_buf);
> +#endif
> +
> +	if (ret < 0) // Error Number
> +	{
> +	    printk(KERN_INFO "chaoban test: ret = -1\n");
> +		goto err_free_allocate;
> +	}
> +#ifdef _SUPPORT_BUTTON_TOUCH
> +	// access BUTTON TOUCH event and BUTTON NO TOUCH even
> +	else if (button_buf[P_REPORT_ID] == BUTTON_FORMAT)
> +	{
> +		//fingers = 0; //modify
> +		button_key = ((button_buf[BUTTON_STATE] & 0xff) | ((button_buf[BUTTON_STATE + 1] & 0xff)<< 8));	

Again macros for endianness

And the driver has a great number of conditional compilations are they
really needed? The driver as is has a number of issues and is hard to
review due to the use of "//" for comments and a lot of conditional
compilation and unnecessary variables used for constants. Could you
fix this up and resubmit?

	Regards
		Oliver



