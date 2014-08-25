Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaHYC1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 22:27:36 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62410 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaHYC1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 22:27:34 -0400
Message-ID: <53fa9f15.6380460a.72bc.ffff9089@mx.google.com>
X-Google-Original-Message-ID: <000401cfc00c$201129d0$60337d70$@dulixin@gmail.com>
From: "Dudley Du" <dudley.dulixin@gmail.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        "Dudley Du" <dudley.dulixin@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Benson Leung" <bleung@google.com>,
        "Patrik Fimml" <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <53c7730a.a10d450a.407e.4c90@mx.google.com> <20140822235528.GB24242@core.coreip.homeip.net>
In-Reply-To: <20140822235528.GB24242@core.coreip.homeip.net>
Subject: RE: [PATCH v4 6/14] input: cyapa: add gen3 trackpad device basic functions support
Date: Mon, 25 Aug 2014 10:27:21 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac+hi9v+78Ah4dswSd2Tw7b3q0tbDQc+jeMAAGDpzLA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Saturday, August 23, 2014 7:55 AM
> To: Dudley Du
> Cc: Rafael J. Wysocki; Benson Leung; Patrik Fimml; linux-input@vger.kernel.org;
> linux-kernel@vger.kernel.org; Dudley Du
> Subject: Re: [PATCH v4 6/14] input: cyapa: add gen3 trackpad device basic
> functions support
> 
> On Thu, Jul 17, 2014 at 02:53:48PM +0800, Dudley Du wrote:
> > Based on the cyapa core, add the gen3 trackpad device's basic functions
> > supported, so gen3 trackpad device can work with kernel input system.
> > The basic function is absolutely same as previous cyapa driver only
> > support gen3 trackpad device.
> > TEST=test on Chromebooks.
> >
> > Signed-off-by: Dudley Du <dudl@cypress.com>
> > ---
> >  drivers/input/mouse/Makefile     |    2 +-
> >  drivers/input/mouse/cyapa.c      |   96 ++++-
> >  drivers/input/mouse/cyapa.h      |    1 +
> >  drivers/input/mouse/cyapa_gen3.c |  784
> ++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 881 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/input/mouse/cyapa_gen3.c
> >
> > diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
> > index 8608eb7..63b42e0 100644
> > --- a/drivers/input/mouse/Makefile
> > +++ b/drivers/input/mouse/Makefile
> > @@ -35,4 +35,4 @@ psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)	+= trackpoint.o
> >  psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)	+= touchkit_ps2.o
> >  psmouse-$(CONFIG_MOUSE_PS2_CYPRESS)	+= cypress_ps2.o
> >
> > -cyapatp-y := cyapa.o
> > +cyapatp-y := cyapa.o cyapa_gen3.o
> > diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> > index ae24b02..5c62503 100644
> > --- a/drivers/input/mouse/cyapa.c
> > +++ b/drivers/input/mouse/cyapa.c
> > @@ -113,6 +113,15 @@ ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
> >
> >  void cyapa_default_irq_handler(struct cyapa *cyapa)
> >  {
> > +	bool cont;
> > +
> > +	/* Interrupt triggerred by command response in detecting. */
> > +	cont = true;
> > +	if (cyapa_gen3_ops.irq_cmd_handler)
> > +		cont = cyapa_gen3_ops.irq_cmd_handler(cyapa);
> 
> Why not simply
> 
> 	cont = cyapa->ops->irq_cmd_handler(cyapa)?


When this the default irq handler is called, at this time, means the device
haven't been initialized yet, the cyapa->ops hasn't been setup correctly, and
the cyapa->ops->irq_cmd_handler is NULL.
So currently, maybe the driver is still on detecting, which device module should
be setup to cyapa->ops is unknown yet. But like gen5 device, it will execute commands
that based on interrupt signals, so the irq_cmd_handler() must be executed
for each module to complete the possible command response when an interrupt comes.
So, here, for each device module, their irq_cmd_handler() should be called directly.


> 
> 
> > +	if (!cont)
> > +		return;
> > +
> >  	/*
> >  	 * Do redetecting when device states is still unknown and
> >  	 * interrupt envent is received from device.
> > @@ -252,6 +261,9 @@ static int cyapa_check_is_operational(struct cyapa
> *cyapa)
> >  		return ret;
> >
> >  	switch (cyapa->gen) {
> > +	case CYAPA_GEN3:
> > +		cyapa->ops = &cyapa_gen3_ops;
> > +		break;
> >  	default:
> >  		cyapa->ops = &cyapa_default_ops;
> >  		cyapa->gen = CYAPA_GEN_UNKNOWN;
> > @@ -314,9 +326,85 @@ out:
> >   */
> >  static int cyapa_get_state(struct cyapa *cyapa)
> >  {
> > +	int ret;
> > +	u8 status[BL_STATUS_SIZE];
> > +	u8 cmd[32];
> > +	/* The i2c address of gen4 and gen5 trackpad device must be even. */
> > +	bool even_addr = ((cyapa->client->addr & 0x0001) == 0);
> > +	bool smbus = false;
> > +	int retries = 2;
> > +
> >  	cyapa->state = CYAPA_STATE_NO_DEVICE;
> >
> > -	return -ENODEV;
> > +	/*
> > +	 * Get trackpad status by reading 3 registers starting from 0.
> > +	 * If the device is in the bootloader, this will be BL_HEAD.
> > +	 * If the device is in operation mode, this will be the DATA regs.
> > +	 *
> > +	 */
> > +	ret = cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET, BL_STATUS_SIZE,
> > +				       status);
> > +
> > +	/*
> > +	 * On smbus systems in OP mode, the i2c_reg_read will fail with
> > +	 * -ETIMEDOUT.  In this case, try again using the smbus equivalent
> > +	 * command.  This should return a BL_HEAD indicating CYAPA_STATE_OP.
> > +	 */
> > +	if (cyapa->smbus && (ret == -ETIMEDOUT || ret == -ENXIO)) {
> > +		if (!even_addr)
> > +			ret = cyapa_read_block(cyapa,
> > +					CYAPA_CMD_BL_STATUS, status);
> > +		smbus = true;
> > +	}
> > +	if (ret != BL_STATUS_SIZE)
> > +		goto error;
> > +
> > +	/*
> > +	 * Detect trackpad protocol based on characristic registers and bits.
> > +	 */
> > +	do {
> > +		cyapa->status[REG_OP_STATUS] = status[REG_OP_STATUS];
> > +		cyapa->status[REG_BL_STATUS] = status[REG_BL_STATUS];
> > +		cyapa->status[REG_BL_ERROR] = status[REG_BL_ERROR];
> > +
> > +		if (cyapa->gen == CYAPA_GEN_UNKNOWN ||
> > +				cyapa->gen == CYAPA_GEN3) {
> > +			ret = cyapa_gen3_ops.state_parse(cyapa,
> > +					status, BL_STATUS_SIZE);
> > +			if (ret == 0)
> > +				goto out_detected;
> > +		}
> > +
> > +		/*
> > +		 * Cannot detect communication protocol based on current
> > +		 * charateristic registers and bits.
> > +		 * So write error command to do further detection.
> > +		 * this method only valid on I2C bus.
> > +		 * for smbus interface, it won't have overwrite issue.
> > +		 */
> > +		if (!smbus) {
> > +			cmd[0] = 0x00;
> > +			cmd[1] = 0x00;
> > +			ret = cyapa_i2c_write(cyapa, 0, 2, cmd);
> > +			if (ret)
> > +				goto error;
> > +
> > +			msleep(50);
> > +
> > +			ret = cyapa_i2c_read(cyapa, BL_HEAD_OFFSET,
> > +					BL_STATUS_SIZE, status);
> > +			if (ret < 0)
> > +				goto error;
> > +		}
> > +	} while (--retries > 0 && !smbus);
> > +
> > +	goto error;
> > +
> > +out_detected:
> > +	return 0;
> > +
> > +error:
> > +	return (ret < 0) ? ret : -EAGAIN;
> >  }
> >
> >  /*
> > @@ -994,11 +1082,17 @@ static void cyapa_detect_and_start(void *data,
> async_cookie_t cookie)
> >
> >  static int cyapa_tp_modules_init(struct cyapa *cyapa)
> >  {
> > +	if (cyapa_gen3_ops.initialize)
> > +		return cyapa_gen3_ops.initialize(cyapa);
> 
> Same here.

Same reason as above.

> 
> > +
> >  	return 0;
> >  }
> >
> >  static int cyapa_tp_modules_uninit(struct cyapa *cyapa)
> >  {
> > +	if (cyapa_gen3_ops.uninitialize)
> > +		return cyapa_gen3_ops.uninitialize(cyapa);
> 
> And here.
> 
> Thanks.
> 
> --
> Dmitry

