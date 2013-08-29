Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3H2Xhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:37:46 -0400
Received: from gloria.sntech.de ([95.129.55.99]:50614 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab3H2Xho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:37:44 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Input: add driver for Neonode zForce based touchscreens
Date: Fri, 30 Aug 2013 01:37:39 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
References: <201308161359.40134.heiko@sntech.de> <20130829162903.GB1576@core.coreip.homeip.net>
In-Reply-To: <20130829162903.GB1576@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201308300137.40020.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Am Donnerstag, 29. August 2013, 18:29:04 schrieb Dmitry Torokhov:
> Hi Heiko,
> 
> On Fri, Aug 16, 2013 at 01:59:39PM +0200, Heiko Stübner wrote:
> > This adds a driver for touchscreens using the zforce infrared
> > technology from Neonode connected via i2c to the host system.
> > 
> > It supports multitouch with up to two fingers and tracking of the
> > contacts in hardware.
> 
> Generally looks good, just a few comments...
> 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> > 
> >  drivers/input/touchscreen/Kconfig     |   13 +
> >  drivers/input/touchscreen/Makefile    |    1 +
> >  drivers/input/touchscreen/zforce_ts.c |  837
> >  +++++++++++++++++++++++++++++++++ include/linux/input/zforce_ts.h      
> >  |   26 +
> >  4 files changed, 877 insertions(+)
> >  create mode 100644 drivers/input/touchscreen/zforce_ts.c
> >  create mode 100644 include/linux/input/zforce_ts.h
> > 
> > diff --git a/drivers/input/touchscreen/Kconfig
> > b/drivers/input/touchscreen/Kconfig index 3b9758b..ade11b7 100644
> > --- a/drivers/input/touchscreen/Kconfig
> > +++ b/drivers/input/touchscreen/Kconfig
> > @@ -919,4 +919,17 @@ config TOUCHSCREEN_TPS6507X
> > 
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called tps6507x_ts.
> > 
> > +config TOUCHSCREEN_ZFORCE
> > +	tristate "Neonode zForce infrared touchscreens"
> > +	depends on I2C
> > +	depends on GPIOLIB
> > +	help
> > +	  Say Y here if you have a touchscreen using the zforce
> > +	  infraread technology from Neonode.
> > +
> > +	  If unsure, say N.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called zforce_ts.
> > +
> > 
> >  endif
> > 
> > diff --git a/drivers/input/touchscreen/Makefile
> > b/drivers/input/touchscreen/Makefile index f5216c1..7587883 100644
> > --- a/drivers/input/touchscreen/Makefile
> > +++ b/drivers/input/touchscreen/Makefile
> > @@ -75,3 +75,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+=
> > mainstone-wm97xx.o
> > 
> >  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
> >  obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
> >  obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+= tps6507x-ts.o
> > 
> > +obj-$(CONFIG_TOUCHSCREEN_ZFORCE)	+= zforce_ts.o
> > diff --git a/drivers/input/touchscreen/zforce_ts.c
> > b/drivers/input/touchscreen/zforce_ts.c new file mode 100644
> > index 0000000..92af632
> > --- /dev/null
> > +++ b/drivers/input/touchscreen/zforce_ts.c
> > @@ -0,0 +1,837 @@
> > +/*
> > + * Copyright (C) 2012-2013 MundoReader S.L.
> > + * Author: Heiko Stuebner <heiko@sntech.de>
> > + *
> > + * based in parts on Nook zforce driver
> > + *
> > + * Copyright (C) 2010 Barnes & Noble, Inc.
> > + * Author: Pieter Truter<ptruter@intrinsyc.com>
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/hrtimer.h>
> > +#include <linux/slab.h>
> > +#include <linux/input.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/i2c.h>
> > +#include <linux/delay.h>
> > +#include <linux/gpio.h>
> > +#include <linux/device.h>
> > +#include <linux/sysfs.h>
> > +#include <linux/input/zforce_ts.h>
> > +#include <linux/input/mt.h>
> > +
> > +#define WAIT_TIMEOUT		msecs_to_jiffies(1000)
> > +
> > +#define FRAME_START		0xee
> > +
> > +/* Offsets of the different parts of the payload the controller sends */
> > +#define PAYLOAD_HEADER		0
> > +#define PAYLOAD_LENGTH		1
> > +#define PAYLOAD_BODY		2
> > +
> > +/* Response offsets */
> > +#define RESPONSE_ID		0
> > +#define RESPONSE_DATA		1
> > +
> > +/* Commands */
> > +#define COMMAND_DEACTIVATE	0x00
> > +#define COMMAND_INITIALIZE	0x01
> > +#define COMMAND_RESOLUTION	0x02
> > +#define COMMAND_SETCONFIG	0x03
> > +#define COMMAND_DATAREQUEST	0x04
> > +#define COMMAND_SCANFREQ	0x08
> > +#define COMMAND_STATUS		0X1e
> > +
> > +/*
> > + * Responses the controller sends as a result of
> > + * command requests
> > + */
> > +#define RESPONSE_DEACTIVATE	0x00
> > +#define RESPONSE_INITIALIZE	0x01
> > +#define RESPONSE_RESOLUTION	0x02
> > +#define RESPONSE_SETCONFIG	0x03
> > +#define RESPONSE_SCANFREQ	0x08
> > +#define RESPONSE_STATUS		0X1e
> > +
> > +/*
> > + * Notifications are send by the touch controller without
> > + * being requested by the driver and include for example
> > + * touch indications
> > + */
> > +#define NOTIFICATION_TOUCH		0x04
> > +#define NOTIFICATION_BOOTCOMPLETE	0x07
> > +#define NOTIFICATION_OVERRUN		0x25
> > +#define NOTIFICATION_PROXIMITY		0x26
> > +#define NOTIFICATION_INVALID_COMMAND	0xfe
> > +
> > +#define ZFORCE_REPORT_POINTS		2
> > +#define ZFORCE_MAX_AREA			0xff
> > +
> > +#define STATE_DOWN			0
> > +#define STATE_MOVE			1
> > +#define STATE_UP			2
> > +
> > +#define SETCONFIG_DUALTOUCH		(1 << 0)
> > +
> > +struct zforce_point {
> > +	int coord_x;
> > +	int coord_y;
> > +	int state;
> > +	int id;
> > +	int area_major;
> > +	int area_minor;
> > +	int orientation;
> > +	int pressure;
> > +	int prblty;
> > +};
> > +
> > +/*
> > + * @client		the i2c_client
> > + * @input		the input device
> > + * @suspending		in the process of going to suspend (don't emit 
wakeup
> > + *			events for commands executed to suspend the device)
> > + * @suspended		device suspended
> > + * @access_mutex	serialize i2c-access, to keep multipart reads together
> > + * @command_done	completion to wait for the command result
> > + * @command_mutex	serialize commands send to the ic
> > + * @command_waiting	the id of the command that that is currently 
waiting
> > + *			for a result
> > + * @command_result	returned result of the command
> > + */
> > +struct zforce_ts {
> > +	struct i2c_client	*client;
> > +	struct input_dev	*input;
> > +	const struct zforce_ts_platdata *pdata;
> > +	char			phys[32];
> > +
> > +	bool			suspending;
> > +	bool			suspended;
> > +	bool			boot_complete;
> > +
> > +	/* Firmware version information */
> > +	u16			version_major;
> > +	u16			version_minor;
> > +	u16			version_build;
> > +	u16			version_rev;
> > +
> > +	struct mutex		access_mutex;
> > +
> > +	struct completion	command_done;
> > +	struct mutex		command_mutex;
> > +	int			command_waiting;
> > +	int			command_result;
> > +};
> > +
> > +static int zforce_command(struct zforce_ts *ts, u8 cmd)
> > +{
> > +	struct i2c_client *client = ts->client;
> > +	char buf[3];
> > +	int ret;
> > +
> > +	dev_dbg(&client->dev, "%s: 0x%x\n", __func__, cmd);
> > +
> > +	buf[0] = FRAME_START;
> > +	buf[1] = 1; /* data size, command only */
> > +	buf[2] = cmd;
> > +
> > +	mutex_lock(&ts->access_mutex);
> > +	ret = i2c_master_send(client, &buf[0], ARRAY_SIZE(buf));
> > +	mutex_unlock(&ts->access_mutex);
> 
> I am unsure why you need this lock. Doesn't i2c core already ensure
> necessary locking?

The access_lock is really only there to ensure the multi-reads stay together 
and do not get split up. For individual reads the i2c core of course does all 
the necessary things.


> Also, it does not look like zforec_command() will reace with your
> interrupt handler that does multi-reads...

I'm unsure :-) ... what about the following scenario:

- touch -> interrupt
- isr reads first packet
- user closes device -> stop command sent
- isr reads payload


I'll fix the rest of the issues in the next version too.


Thanks for the review
Heiko
