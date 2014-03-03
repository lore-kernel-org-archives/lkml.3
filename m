Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaCCTRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:17:12 -0500
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:41547
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409AbaCCTRI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:17:08 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] Staging: comedi: introduce outl_1564_* and
 inl_1564_* helper functions in hwdrv_apci1564.c
Thread-Topic: [PATCH 1/2] Staging: comedi: introduce outl_1564_* and
 inl_1564_* helper functions in hwdrv_apci1564.c
Thread-Index: AQHPNTj+GcIjUJxw50O9R+0oAzeBMZrPrInw
Date: Mon, 3 Mar 2014 19:17:07 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825D97CD8@P3PWEX4MB008.ex4.secureserver.net>
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
 <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 01, 2014 3:28 AM, Chase Southwood wrote:
> Subject: [PATCH 1/2] Staging: comedi: introduce outl_1564_* and inl_1564_* helper functions in hwdrv_apci1564.c
>
> This patch introduces a handful of outl and inl helper functions with the
> ultimate goal of improving code readability and allowing several lines
> which violate the character limit to be shortened in a sane way.
>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> This patchset serves as a replacement to my previous cleanup patchset for
> hwdrv_apci1564.c
>
> Dan,
> After spending a little bit more time with this and trying out different
> ways of cleaning this up, I decided that making helper functions for all
> of the most common register sets would look the best, but I haven't made
> a helper for a few of the least common inl/outl calls because if I did,
> the sheer number of helper functions would get quite ridiculous.
> Let me know if you think my selections of what to make into helper
> functions seems appropriate.

Chase,

Sorry for jumping in here late.

I think if you just tidy up the register map defines it would help. Some of them
are actually used incorrectly anyway.

For instance, these two define the "base" offset for the digital input registers,
which is also to digital input register, and the offset from the "base" to the
interrupt mode1 register.

#define APCI1564_DIGITAL_IP				0x04
#define APCI1564_DIGITAL_IP_INTERRUPT_MODE1		4

One use of the APCI1564_DIGITAL_IP_INTERRUPT_MODE1 define is in
i_APCI1564_ConfigDigitalInput():

		outl(data[2],
			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
			APCI1564_DIGITAL_IP_INTERRUPT_MODE1);

But in i_APCI1564_Reset () it is used as:

	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE1);

So in the first example the driver is writing to a register at offset 0x08 (0x04 + 4) but
the second is writing to a register at offset 0x04 (4), which is really the digitial input
register.

I suggest you just fix the register map defines so they are the "real" offsets to each
register and not a mix of real offsets and adders to those offsets.

I would also rename them to help with the > 80 char lines.

Something like this:

/*
 * devpriv->i_IobaseAmcc Register map
 */
#define APCI1564_DI_REG					0x04
#define APCI1564_DI_INT_MODE1_REG			0x08
#define APCI1564_DI_INT_MODE2_REG			0x0c
#define APCI1564_DI_INT_STATUS_REG			0x10
#define APCI1564_DI_IRQ_REG				0x14
#define APCI1564_DO_REG					0x18
#define APCI1564_DO_INT_CTRL_REG			0x1c
#define APCI1564_DO_INT_STATUS_REG			0x20
#define APCI1564_DO_IRQ_REG				0x24
#define APCI1564_WDOG_REG				0x28
#define APCI1564_WDOG_RELOAD_REG			0x2c
#define APCI1564_WDOG_TIMEBASE_REG			0x30
#define APCI1564_WDOG_CTRL_REG				0x34
#define APCI1564_WDOG_STATUS_REG			0x38
#define APCI1564_WDOG_IRQ_REG				0x3c
#define APCI1564_WDOG_WARN_TIMEVAL_REG			0x40
#define APCI1564_WDOG_WARN_TIMEBASE_REG			0x44
#define APCI1564_TIMER_REG				0x48
#define APCI1564_TIMER_RELOAD_REG			0x4c
#define APCI1564_TIMER_TIMEBASE_REG			0x50
#define APCI1564_TIMER_CTRL_REG				0x54
#define APCI1564_TIMER_STATUS_REG			0x58
#define APCI1564_TIMER_IRQ_REG				0x5c
#define APCI1564_TIMER_WARN_TIMEVAL_REG			0x60
#define APCI1564_TIMER_WARN_TIMEBASE_REG		0x64

/*
 * devpriv->iobase Register map
 */
#define APCI1564_TCW_REG(x)				(0x00 + ((x) * 20))
#define APCI1564_TCW_RELOAD_REG(x)			(0x04 + ((x) * 20))
#define APCI1564_TCW_TIMEBASE_REG(x)			(0x08 + ((x) * 20))
#define APCI1564_TCW_CTRL_REG(x)			(0x0c + ((x) * 20))
#define APCI1564_TCW_STATUS_REG(x)			(0x10 + ((x) * 20))
#define APCI1564_TCW_IRQ_REG(x)				(0x14 + ((x) * 20))
#define APCI1564_TCW_WARN_TIMEVAL_REG(x)		(0x18 + ((x) * 20))
#define APCI1564_TCW_WARN_TIMEBASE_REG(x)		(0x1c + ((x) * 20))

You will probably want to split this into a couple patches to make reviewing
easier. Maybe do it by subdevice: digital input, digital output, watchdog, timer,
then the counters.

Regards,
Hartley

