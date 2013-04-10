Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965160Ab3DJRAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:00:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:39173 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965006Ab3DJRAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:00:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,449,1363158000"; 
   d="scan'208";a="293028630"
Date: Wed, 10 Apr 2013 09:57:34 -0700
From: Kevin Strasser <kevin.strasser@linux.intel.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org,
        Michael Brunner <michael.brunner@kontron.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>, Michael Brunner <mibru@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/4] watchdog: Kontron PLD watchdog timer
Message-ID: <20130410165733.GA2769@wrk>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1365441321-21952-4-git-send-email-kevin.strasser@linux.intel.com>
 <20130410164717.GA19533@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410164717.GA19533@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 09:47:17AM -0700, Guenter Roeck wrote:
> On Mon, Apr 08, 2013 at 10:15:21AM -0700, Kevin Strasser wrote:
> > From: Michael Brunner <michael.brunner@kontron.com>
> > 
> > Add watchdog timer support for the on-board PLD found on some Kontron
> > embedded modules.
> > 
> > Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> > Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> 
> Personally I would prefer two separate patches for the two drivers,
> and to have the drivers converted to the watchdog infrastructure.
> Wim's call, of course.
> 
Thanks for the feedback. I'm happy to do both if Wim thinks it's
necessary.

-Kevin

> Thanks,
> Guenter
> 
> > ---
> >  drivers/watchdog/Kconfig           |   20 +
> >  drivers/watchdog/Makefile          |    2 +
> >  drivers/watchdog/kempld_now1_wdt.c |  602 +++++++++++++++++++++++++++
> >  drivers/watchdog/kempld_wdt.c      |  796 ++++++++++++++++++++++++++++++++++++
> >  drivers/watchdog/kempld_wdt.h      |   75 ++++
> >  5 files changed, 1495 insertions(+)
> >  create mode 100644 drivers/watchdog/kempld_now1_wdt.c
> >  create mode 100644 drivers/watchdog/kempld_wdt.c
> >  create mode 100644 drivers/watchdog/kempld_wdt.h
> > 
> > diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> > index 9fcc70c..9ac71ca 100644
> > --- a/drivers/watchdog/Kconfig
> > +++ b/drivers/watchdog/Kconfig
> > @@ -687,6 +687,26 @@ config HP_WATCHDOG
> >  	  To compile this driver as a module, choose M here: the module will be
> >  	  called hpwdt.
> >  
> > +config KEMPLD_WDT
> > +	tristate "Kontron COM watchdog"
> > +	depends on MFD_KEMPLD
> > +	help
> > +	  Support for the PLD watchdog on some Kontron ETX and COMexpress
> > +	  (ETXexpress) modules
> > +
> > +	  This driver can also be built as a module. If so, the module will be
> > +	  called kempld_wdt.
> > +
> > +config KEMPLD_NOW1_WDT
> > +	tristate "Kontron COMe-mSP1 (nanoETXexpress-SP) watchdog"
> > +	depends on MFD_KEMPLD
> > +	help
> > +	  Support for the PLD watchdog on the Kontron COMe-mSP1
> > +	  (nanoETXexpress-SP) module.
> > +
> > +	  This driver can also be built as a module. If so, the module will
> > +	  be called kempld_now1_wdt.
> > +
> >  config HPWDT_NMI_DECODING
> >  	bool "NMI decoding support for the HP ProLiant iLO2+ Hardware Watchdog Timer"
> >  	depends on HP_WATCHDOG
> > diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> > index a300b94..a029930 100644
> > --- a/drivers/watchdog/Makefile
> > +++ b/drivers/watchdog/Makefile
> > @@ -90,6 +90,8 @@ endif
> >  obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
> >  obj-$(CONFIG_IT87_WDT) += it87_wdt.o
> >  obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
> > +obj-$(CONFIG_KEMPLD_WDT) += kempld_wdt.o
> > +obj-$(COnFIG_KEMPLD_NOW1_WDT) += kempld_now1_wdt.o
> >  obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o
> >  obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
> >  obj-$(CONFIG_PC87413_WDT) += pc87413_wdt.o
> > diff --git a/drivers/watchdog/kempld_now1_wdt.c b/drivers/watchdog/kempld_now1_wdt.c
> > new file mode 100644
> > index 0000000..19b7272
> > --- /dev/null
> > +++ b/drivers/watchdog/kempld_now1_wdt.c
> > @@ -0,0 +1,602 @@
> > +/*
> > + *  kempld_now1_wdt.c - Kontron PLD watchdog driver for COMe-mSP1
> > + *
> > + *  Copyright (c) 2011-2012 Kontron Europe GmbH
> > + *  Author: Michael Brunner <michael.brunner@kontron.com>
> > + *
> > + *  Note: The watchdog of the COMe-mSP1 (nanoETXexpress-SP) has one stage and
> > + *        only supports predefined watchdog timeout values.
> > + *
> > + *        The supported timeouts are:
> > + *              1 s, 5 s, 10 s, 30 s, 1 min, 5 min, 10 min, 15 min
> > + *
> > + *  This program is free software; you can redistribute it and/or modify
> > + *  it under the terms of the GNU General Public License 2 as published
> > + *  by the Free Software Foundation.
> > + *
> > + *  This program is distributed in the hope that it will be useful,
> > + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *  GNU General Public License for more details.
> > + *
> > + *  You should have received a copy of the GNU General Public License
> > + *  along with this program; see the file COPYING.  If not, write to
> > + *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/moduleparam.h>
> > +#include <linux/types.h>
> > +#include <linux/miscdevice.h>
> > +#include <linux/watchdog.h>
> > +#include <linux/fs.h>
> > +#include <linux/ioport.h>
> > +#include <linux/init.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/slab.h>
> > +#include <linux/delay.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/mfd/kempld.h>
> > +
> > +#include "kempld_wdt.h"
> > +
> > +#define WATCHDOG_TIMEOUT 30
> > +static int timeout = WATCHDOG_TIMEOUT;
> > +module_param(timeout, int, 0);
> > +MODULE_PARM_DESC(timeout,
> > +		 "Watchdog timeout in seconds. (1, 5, 10, 30, 60, 300, 600, "
> > +		 "900, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
> > +
> > +static bool nowayout = WATCHDOG_NOWAYOUT;
> > +module_param(nowayout, bool, 0);
> > +MODULE_PARM_DESC(nowayout,
> > +		 "Watchdog cannot be stopped once started (default="
> > +		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> > +
> > +/* nanoETXexpress-SP watchdog register definitions */
> > +#define KEMPLD_WDT_NOW1					0xA2
> > +#define		KEMPLD_WDT_NOW1_KICK_MASK		0x80
> > +#define		KEMPLD_WDT_NOW1_ENABLE_MASK		0x40
> > +#define		KEMPLD_WDT_NOW1_TIMEOUT_MASK		0x1f
> > +#define			KEMPLD_WDT_NOW1_TIMEOUT_1SEC	0x00
> > +#define			KEMPLD_WDT_NOW1_TIMEOUT_5SEC	0x01
> > +#define			KEMPLD_WDT_NOW1_TIMEOUT_10SEC	0x02
> > +#define			KEMPLD_WDT_NOW1_TIMEOUT_30SEC	0x03
> > +#define			KEMPLD_WDT_NOW1_TIMEOUT_1MIN	0x10
> > +#define			KEMPLD_WDT_NOW1_TIMEOUT_5MIN	0x11
> > +#define			KEMPLD_WDT_NOW1_TIMEOUT_10MIN	0x12
> > +#define			KEMPLD_WDT_NOW1_TIMEOUT_15MIN	0x13
> > +
> > +/* delay in us necessary due to clock domain sync */
> > +#define		KEMPLD_WDT_NOW1_SYNC_DELAY		31
> > +
> > +static struct kempld_watchdog_data *kempld_now1_wdt;
> > +
> > +static int kempld_now1_wdt_read_supported;
> > +static int kempld_now1_wdt_reg_cache;
> > +
> > +static int kempld_now1_wdt_start(struct kempld_watchdog_data *wdt)
> > +{
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	int wdt_reg;
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_NOW1);
> > +	udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +	if (kempld_now1_wdt_read_supported)
> > +		wdt_reg = kempld_read8(pld, KEMPLD_WDT_NOW1);
> > +	else
> > +		wdt_reg = kempld_now1_wdt_reg_cache;
> > +	wdt_reg |= KEMPLD_WDT_NOW1_ENABLE_MASK;
> > +	udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +	kempld_write8(pld, KEMPLD_WDT_NOW1, wdt_reg);
> > +	kempld_now1_wdt_reg_cache = wdt_reg;
> > +	kempld_release_mutex(pld);
> > +
> > +	if (kempld_now1_wdt_read_supported) {
> > +		/* read out the register again to check if everything worked */
> > +		kempld_get_mutex_set_index(pld, KEMPLD_WDT_NOW1);
> > +		udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +		wdt_reg = kempld_read8(pld, KEMPLD_WDT_NOW1);
> > +		kempld_release_mutex(pld);
> > +
> > +		/* check if the watchdog was disabled */
> > +		if (!(wdt_reg & KEMPLD_WDT_NOW1_ENABLE_MASK))
> > +			return -EACCES;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int kempld_now1_wdt_stop(struct kempld_watchdog_data *wdt)
> > +{
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	int wdt_reg;
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_NOW1);
> > +	if (kempld_now1_wdt_read_supported) {
> > +		udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +		wdt_reg = kempld_read8(pld, KEMPLD_WDT_NOW1);
> > +	} else
> > +		wdt_reg = kempld_now1_wdt_reg_cache;
> > +	wdt_reg &= ~KEMPLD_WDT_NOW1_ENABLE_MASK;
> > +	udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +	kempld_write8(pld, KEMPLD_WDT_NOW1, wdt_reg);
> > +	kempld_now1_wdt_reg_cache = wdt_reg;
> > +	kempld_release_mutex(pld);
> > +
> > +	if (kempld_now1_wdt_read_supported) {
> > +		/* read out the register again to check if everything worked */
> > +		kempld_get_mutex_set_index(pld, KEMPLD_WDT_NOW1);
> > +		udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +		wdt_reg = kempld_read8(pld, KEMPLD_WDT_NOW1);
> > +		kempld_release_mutex(pld);
> > +
> > +		/* check if the watchdog was disabled */
> > +		if (wdt_reg & KEMPLD_WDT_NOW1_ENABLE_MASK)
> > +			return -EACCES;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int kempld_now1_wdt_keepalive(struct kempld_watchdog_data *wdt)
> > +{
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	int wdt_reg;
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_NOW1);
> > +
> > +	udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +
> > +	if (kempld_now1_wdt_read_supported) {
> > +		wdt_reg = kempld_read8(pld, KEMPLD_WDT_NOW1);
> > +	} else {
> > +		wdt_reg = kempld_now1_wdt_reg_cache;
> > +		/* write the state again to be sure the trigger register has
> > +		 * the right level */
> > +		kempld_write8(pld, KEMPLD_WDT_NOW1, wdt_reg);
> > +	}
> > +
> > +	if (wdt_reg & KEMPLD_WDT_NOW1_KICK_MASK)
> > +		wdt_reg &= ~KEMPLD_WDT_NOW1_KICK_MASK;
> > +	else
> > +		wdt_reg |= KEMPLD_WDT_NOW1_KICK_MASK;
> > +
> > +	udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +
> > +	kempld_write8(pld, KEMPLD_WDT_NOW1, wdt_reg);
> > +
> > +	kempld_now1_wdt_reg_cache = wdt_reg;
> > +
> > +	kempld_release_mutex(pld);
> > +
> > +	return 0;
> > +}
> > +
> > +
> > +static int kempld_now1_wdt_settimeout(struct kempld_watchdog_data *wdt,
> > +					int check_only)
> > +{
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	int wdt_reg;
> > +	int ret = 0;
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_NOW1);
> > +
> > +	if (kempld_now1_wdt_read_supported) {
> > +		udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +		wdt_reg = kempld_read8(pld, KEMPLD_WDT_NOW1);
> > +	} else
> > +		wdt_reg = kempld_now1_wdt_reg_cache;
> > +
> > +	wdt_reg &= ~KEMPLD_WDT_NOW1_TIMEOUT_MASK;
> > +
> > +	switch (wdt->timeout) {
> > +	case 1:
> > +		wdt_reg |= KEMPLD_WDT_NOW1_TIMEOUT_1SEC;
> > +		break;
> > +	case 5:
> > +		wdt_reg |= KEMPLD_WDT_NOW1_TIMEOUT_5SEC;
> > +		break;
> > +	case 10:
> > +		wdt_reg |= KEMPLD_WDT_NOW1_TIMEOUT_10SEC;
> > +		break;
> > +	case 30:
> > +		wdt_reg |= KEMPLD_WDT_NOW1_TIMEOUT_30SEC;
> > +		break;
> > +	case 60:
> > +		wdt_reg |= KEMPLD_WDT_NOW1_TIMEOUT_1MIN;
> > +		break;
> > +	case 300:
> > +		wdt_reg |= KEMPLD_WDT_NOW1_TIMEOUT_5MIN;
> > +		break;
> > +	case 600:
> > +		wdt_reg |= KEMPLD_WDT_NOW1_TIMEOUT_10MIN;
> > +		break;
> > +	case 900:
> > +		wdt_reg |= KEMPLD_WDT_NOW1_TIMEOUT_15MIN;
> > +		break;
> > +	default:
> > +		ret = -EINVAL;
> > +		dev_err(wdt->pld->dev,
> > +			"Invalid timeout value given!\n");
> > +	}
> > +
> > +	if (!check_only) {
> > +		if (ret == 0) {
> > +			udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +
> > +			kempld_write8(pld, KEMPLD_WDT_NOW1, wdt_reg);
> > +		}
> > +	}
> > +
> > +	kempld_now1_wdt_reg_cache = wdt_reg;
> > +
> > +	kempld_release_mutex(pld);
> > +
> > +	return ret;
> > +}
> > +
> > +static int kempld_now1_wdt_gettimeout(struct kempld_watchdog_data *wdt,
> > +				 struct kempld_watchdog_stage *stage)
> > +{
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	int wdt_reg;
> > +	int timeout;
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_NOW1);
> > +
> > +	if (kempld_now1_wdt_read_supported) {
> > +		udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +		wdt_reg = kempld_read8(pld, KEMPLD_WDT_NOW1);
> > +		kempld_now1_wdt_reg_cache = wdt_reg;
> > +	} else
> > +		wdt_reg = kempld_now1_wdt_reg_cache;
> > +
> > +	kempld_release_mutex(pld);
> > +
> > +	switch (wdt_reg&KEMPLD_WDT_NOW1_TIMEOUT_MASK) {
> > +	case KEMPLD_WDT_NOW1_TIMEOUT_1SEC:
> > +		timeout = 1;
> > +		break;
> > +	case KEMPLD_WDT_NOW1_TIMEOUT_5SEC:
> > +		timeout = 5;
> > +		break;
> > +	case KEMPLD_WDT_NOW1_TIMEOUT_10SEC:
> > +		timeout = 10;
> > +		break;
> > +	case KEMPLD_WDT_NOW1_TIMEOUT_30SEC:
> > +		timeout = 30;
> > +		break;
> > +	case KEMPLD_WDT_NOW1_TIMEOUT_1MIN:
> > +		timeout = 60;
> > +		break;
> > +	case KEMPLD_WDT_NOW1_TIMEOUT_5MIN:
> > +		timeout = 300;
> > +		break;
> > +	case KEMPLD_WDT_NOW1_TIMEOUT_10MIN:
> > +		timeout = 600;
> > +		break;
> > +	case KEMPLD_WDT_NOW1_TIMEOUT_15MIN:
> > +		timeout = 900;
> > +		break;
> > +	default:
> > +		timeout = -ERANGE;
> > +	}
> > +
> > +	return timeout;
> > +}
> > +
> > +static ssize_t kempld_now1_wdt_write(struct file *file, const char __user
> > +					*data, size_t count, loff_t *ppos)
> > +{
> > +	struct kempld_watchdog_data *wdt = kempld_now1_wdt;
> > +
> > +	BUG_ON(wdt == NULL);
> > +
> > +	if (count) {
> > +		kempld_now1_wdt_keepalive(wdt);
> > +
> > +		if (!nowayout) {
> > +			size_t i;
> > +
> > +			wdt->expect_close = 0;
> > +
> > +			for (i = 0; i < count; i++) {
> > +				char c;
> > +				if (get_user(c, data+i))
> > +					return -EFAULT;
> > +				if (c == 'V')
> > +					wdt->expect_close = 42;
> > +			}
> > +		}
> > +	}
> > +
> > +	return count;
> > +}
> > +
> > +static long kempld_now1_wdt_ioctl(struct file *file, unsigned int cmd,
> > +				unsigned long arg)
> > +{
> > +	void __user *argp = (void __user *)arg;
> > +	int __user *p = argp;
> > +	struct kempld_watchdog_data *wdt = kempld_now1_wdt;
> > +	int options;
> > +	int value;
> > +	int ret = 0;
> > +
> > +	BUG_ON(wdt == NULL);
> > +
> > +	switch (cmd) {
> > +	case WDIOC_GETSUPPORT:
> > +		if (copy_to_user(argp, &wdt->ident, sizeof(wdt->ident)))
> > +			ret = -EFAULT;
> > +		break;
> > +	case WDIOC_GETSTATUS:
> > +	case WDIOC_GETBOOTSTATUS:
> > +		ret = put_user(0, p);
> > +		break;
> > +	case WDIOC_SETOPTIONS:
> > +		if (get_user(options, p)) {
> > +			ret = -EFAULT;
> > +			break;
> > +		}
> > +		if (options & WDIOS_DISABLECARD)
> > +			ret = kempld_now1_wdt_stop(wdt);
> > +		if (options & WDIOS_ENABLECARD) {
> > +			ret = kempld_now1_wdt_start(wdt);
> > +			kempld_now1_wdt_keepalive(wdt);
> > +		}
> > +		break;
> > +	case WDIOC_KEEPALIVE:
> > +		kempld_now1_wdt_keepalive(wdt);
> > +		break;
> > +	case WDIOC_SETTIMEOUT:
> > +		if (get_user(value, p)) {
> > +			ret = -EFAULT;
> > +			break;
> > +		}
> > +		wdt->timeout = value;
> > +		ret = kempld_now1_wdt_settimeout(wdt, 0);
> > +		kempld_now1_wdt_keepalive(wdt);
> > +		break;
> > +	case WDIOC_GETTIMEOUT:
> > +		value = kempld_now1_wdt_gettimeout(wdt, wdt->timeout_stage);
> > +		if (timeout < 0)
> > +			ret = ERANGE;
> > +		else
> > +			ret = put_user(timeout, p);
> > +		break;
> > +	default:
> > +		ret = -ENOTTY;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int kempld_now1_wdt_release(struct inode *inode, struct file *file)
> > +{
> > +	struct kempld_watchdog_data *wdt = kempld_now1_wdt;
> > +
> > +	BUG_ON(wdt == NULL);
> > +
> > +	if (wdt->expect_close)
> > +		kempld_now1_wdt_stop(wdt);
> > +	else {
> > +		dev_warn(wdt->pld->dev,
> > +			 "Unexpected close, not stopping watchdog!\n");
> > +		kempld_now1_wdt_keepalive(wdt);
> > +	}
> > +
> > +	kempld_now1_wdt->expect_close = 0;
> > +
> > +	clear_bit(0, &wdt->is_open);
> > +
> > +	return 0;
> > +}
> > +
> > +static int kempld_now1_wdt_open(struct inode *inode, struct file *file)
> > +{
> > +	int ret;
> > +	struct kempld_watchdog_data *wdt = kempld_now1_wdt;
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	u8 wdt_reg;
> > +
> > +	BUG_ON(wdt == NULL);
> > +
> > +	if (test_and_set_bit(0, &wdt->is_open))
> > +		return -EBUSY;
> > +
> > +	if (nowayout)
> > +		__module_get(THIS_MODULE);
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_NOW1);
> > +	if (kempld_now1_wdt_read_supported) {
> > +		udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +		wdt_reg = kempld_read8(pld, KEMPLD_WDT_NOW1);
> > +	} else {
> > +		wdt_reg = kempld_now1_wdt_reg_cache;
> > +	}
> > +	kempld_now1_wdt_reg_cache = wdt_reg;
> > +	kempld_release_mutex(pld);
> > +
> > +	/* kick the watchdog if it is already enabled, otherwise start it */
> > +	if (wdt_reg & KEMPLD_WDT_NOW1_ENABLE_MASK) {
> > +		kempld_now1_wdt_keepalive(wdt);
> > +	} else {
> > +		ret = kempld_now1_wdt_settimeout(wdt, 0);
> > +		if (ret)
> > +			goto err_enable_wdt;
> > +		ret = kempld_now1_wdt_start(wdt);
> > +		if (ret)
> > +			goto err_enable_wdt;
> > +	}
> > +
> > +	return nonseekable_open(inode, file);
> > +
> > +err_enable_wdt:
> > +	dev_err(wdt->pld->dev, "Failed to enable the watchdog timer!\n");
> > +	wdt->expect_close = 1;
> > +	kempld_now1_wdt_release(inode, file);
> > +
> > +	return ret;
> > +}
> > +
> > +static const struct file_operations kempld_now1_wdt_fops = {
> > +	.owner		= THIS_MODULE,
> > +	.llseek		= no_llseek,
> > +	.write		= kempld_now1_wdt_write,
> > +	.unlocked_ioctl	= kempld_now1_wdt_ioctl,
> > +	.open		= kempld_now1_wdt_open,
> > +	.release	= kempld_now1_wdt_release,
> > +};
> > +
> > +static struct miscdevice kempld_now1_wdt_miscdev = {
> > +	.minor	= WATCHDOG_MINOR,
> > +	.name	= "watchdog",
> > +	.fops	= &kempld_now1_wdt_fops,
> > +};
> > +
> > +static int kempld_now1_wdt_probe(struct platform_device *pdev)
> > +{
> > +	struct kempld_watchdog_data *wdt;
> > +	struct kempld_device_data *pld;
> > +	u8 wdt_reg;
> > +	int ret;
> > +
> > +	if (kempld_now1_wdt != NULL) {
> > +		dev_err(&pdev->dev,
> > +			"unable to support more than one watchdog devices\n");
> > +		return -EMFILE;
> > +	}
> > +
> > +	wdt = kzalloc(sizeof(struct kempld_watchdog_data), GFP_KERNEL);
> > +	if (wdt == NULL) {
> > +		dev_err(&pdev->dev, "unable to get memory for device data\n");
> > +		ret = -ENOMEM;
> > +		goto err_alloc_dev_data;
> > +	}
> > +
> > +	wdt->timeout_stage = kzalloc(sizeof(struct kempld_watchdog_stage),
> > +					GFP_KERNEL);
> > +	if (wdt->timeout_stage == NULL) {
> > +		dev_err(&pdev->dev,
> > +			"unable to get memory for watchdog stage\n");
> > +		ret = -ENOMEM;
> > +		goto err_alloc_dev_data;
> > +	}
> > +
> > +	wdt->stages = 1;
> > +	wdt->stage[0] = wdt->timeout_stage;
> > +
> > +	pld = dev_get_drvdata(pdev->dev.parent);
> > +	wdt->pld = pld;
> > +
> > +	platform_set_drvdata(pdev, wdt);
> > +
> > +	strncpy(wdt->ident.identity, "nanoETXexpress-SP Watchdog",
> > +		sizeof(wdt->ident.identity));
> > +
> > +	/* set default values for the case we start the watchdog or change
> > +	 * the configuration */
> > +	wdt->timeout = timeout;
> > +
> > +	/* use settimeout to check if the timeout parameter is valid */
> > +	ret = kempld_now1_wdt_settimeout(wdt, 1);
> > +	if (ret)
> > +		goto err_check_timeout;
> > +	wdt->ident.firmware_version = (pld->info.major<<8) + pld->info.minor;
> > +	if (pld->info.major > 67)
> > +		kempld_now1_wdt_read_supported = 1;
> > +	else
> > +		dev_info(wdt->pld->dev,
> > +			 "Watchdog revision does not support read - "
> > +			 "unable to get watchdog state!\n");
> > +
> > +	/* get initial watchdog status */
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_NOW1);
> > +	if (kempld_now1_wdt_read_supported) {
> > +		udelay(KEMPLD_WDT_NOW1_SYNC_DELAY);
> > +		wdt_reg = kempld_read8(pld, KEMPLD_WDT_NOW1);
> > +	} else {
> > +		wdt_reg = 0x0;
> > +	}
> > +	kempld_now1_wdt_reg_cache = wdt_reg;
> > +	kempld_release_mutex(wdt->pld);
> > +
> > +	/* check if watchdog is enabled */
> > +	if (wdt_reg & KEMPLD_WDT_NOW1_ENABLE_MASK)
> > +		dev_info(wdt->pld->dev, "Watchdog is already enabled!\n");
> > +
> > +	wdt->ident.options = WDIOF_KEEPALIVEPING;
> > +	wdt->ident.options |= WDIOF_SETTIMEOUT;
> > +	if (!nowayout)
> > +		wdt->ident.options |= WDIOF_MAGICCLOSE;
> > +
> > +	kempld_now1_wdt = wdt;
> > +
> > +	ret = misc_register(&kempld_now1_wdt_miscdev);
> > +	if (ret)
> > +		goto err_misc_register;
> > +
> > +	dev_info(wdt->pld->dev, "watchdog initialized\n");
> > +
> > +	return 0;
> > +
> > +err_misc_register:
> > +	kfree(kempld_now1_wdt);
> > +	kempld_now1_wdt = NULL;
> > +err_check_timeout:
> > +err_alloc_dev_data:
> > +	return ret;
> > +}
> > +
> > +static int kempld_now1_wdt_remove(struct platform_device *pdev)
> > +{
> > +	struct kempld_watchdog_data *wdt = platform_get_drvdata(pdev);
> > +
> > +	BUG_ON(wdt != kempld_now1_wdt);
> > +
> > +	/* stop or at least keepalive the watchdog before we leave */
> > +	if (wdt != NULL) {
> > +		if (!nowayout)
> > +			kempld_now1_wdt_stop(wdt);
> > +		else
> > +			kempld_now1_wdt_keepalive(wdt);
> > +	}
> > +
> > +	misc_deregister(&kempld_now1_wdt_miscdev);
> > +
> > +	kfree(wdt);
> > +	kempld_now1_wdt = NULL;
> > +	platform_set_drvdata(pdev, NULL);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver kempld_now1_wdt_driver = {
> > +	.driver = {
> > +		.name = "kempld_now1-wdt",
> > +		.owner = THIS_MODULE,
> > +	},
> > +	.probe = kempld_now1_wdt_probe,
> > +	.remove = kempld_now1_wdt_remove,
> > +};
> > +
> > +static int __init kempld_now1_wdt_init(void)
> > +{
> > +	return platform_driver_register(&kempld_now1_wdt_driver);
> > +}
> > +
> > +static void __exit kempld_now1_wdt_exit(void)
> > +{
> > +	platform_driver_unregister(&kempld_now1_wdt_driver);
> > +}
> > +
> > +module_init(kempld_now1_wdt_init);
> > +module_exit(kempld_now1_wdt_exit);
> > +
> > +MODULE_DESCRIPTION("KEM PLD nanoETXexpress-SP Watchdog Driver");
> > +MODULE_AUTHOR("Michael Brunner <michael.brunner@kontron.com>");
> > +MODULE_LICENSE("GPL");
> > +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> > diff --git a/drivers/watchdog/kempld_wdt.c b/drivers/watchdog/kempld_wdt.c
> > new file mode 100644
> > index 0000000..bc150e5
> > --- /dev/null
> > +++ b/drivers/watchdog/kempld_wdt.c
> > @@ -0,0 +1,796 @@
> > +/*
> > + *  kempld_wdt.c - Kontron PLD watchdog driver
> > + *
> > + *  Copyright (c) 2010-2012 Kontron Europe GmbH
> > + *  Author: Michael Brunner <michael.brunner@kontron.com>
> > + *
> > + *  Note: From the PLD watchdog point of view timeout and pretimeout are
> > + *        defined differently than in the kernel.
> > + *        First the pretimeout stage runs out before the timeout stage gets
> > + *        active. This has to be kept in mind.
> > + *
> > + *  Kernel/API:                     P-----| pretimeout
> > + *                |-----------------------T timeout
> > + *  Watchdog:     |-----------------P       pretimeout_stage
> > + *                                  |-----T timeout_stage
> > + *
> > + *  This program is free software; you can redistribute it and/or modify
> > + *  it under the terms of the GNU General Public License 2 as published
> > + *  by the Free Software Foundation.
> > + *
> > + *  This program is distributed in the hope that it will be useful,
> > + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *  GNU General Public License for more details.
> > + *
> > + *  You should have received a copy of the GNU General Public License
> > + *  along with this program; see the file COPYING.  If not, write to
> > + *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/moduleparam.h>
> > +#include <linux/types.h>
> > +#include <linux/miscdevice.h>
> > +#include <linux/watchdog.h>
> > +#include <linux/fs.h>
> > +#include <linux/ioport.h>
> > +#include <linux/init.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/slab.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/mfd/kempld.h>
> > +
> > +#include "kempld_wdt.h"
> > +
> > +#define WATCHDOG_DEFAULT_TIMEOUT 20
> > +#define WATCHDOG_DEFAULT_PRETIMEOUT 0
> > +static int timeout = -1;
> > +static int pretimeout = -1;
> > +/* The maximum timeout values have to be probed */
> > +module_param(timeout, int, 0);
> > +MODULE_PARM_DESC(timeout,
> > +		 "Watchdog timeout in seconds. (>0, default="
> > +		__MODULE_STRING(WATCHDOG_DEFAULT_TIMEOUT) ")");
> > +module_param(pretimeout, int, 0);
> > +MODULE_PARM_DESC(pretimeout,
> > +		 "Watchdog pretimeout in seconds. (>=0, default="
> > +		__MODULE_STRING(WATCHDOG_DEFAULT_PRETIMEOUT) ")");
> > +
> > +static bool nowayout = WATCHDOG_NOWAYOUT;
> > +module_param(nowayout, bool, 0);
> > +MODULE_PARM_DESC(nowayout,
> > +		 "Watchdog cannot be stopped once started (default="
> > +		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> > +
> > +static struct kempld_watchdog_data *kempld_wdt;
> > +
> > +static int kempld_wdt_start(struct kempld_watchdog_data *wdt)
> > +{
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	u8 status;
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_CFG);
> > +
> > +	status = kempld_read8(pld, KEMPLD_WDT_CFG);
> > +	status |= KEMPLD_WDT_CFG_ENABLE;
> > +	kempld_write8(pld, KEMPLD_WDT_CFG, status);
> > +	status = kempld_read8(pld, KEMPLD_WDT_CFG);
> > +
> > +	kempld_release_mutex(pld);
> > +
> > +	/* check if the watchdog was enabled */
> > +	if (!(status & KEMPLD_WDT_CFG_ENABLE))
> > +		return -EACCES;
> > +
> > +	return 0;
> > +}
> > +
> > +static int kempld_wdt_stop(struct kempld_watchdog_data *wdt)
> > +{
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	u8 status;
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_CFG);
> > +
> > +	status = kempld_read8(pld, KEMPLD_WDT_CFG);
> > +	status &= ~KEMPLD_WDT_CFG_ENABLE;
> > +	kempld_write8(pld, KEMPLD_WDT_CFG, status);
> > +	status = kempld_read8(pld, KEMPLD_WDT_CFG);
> > +
> > +	kempld_release_mutex(pld);
> > +
> > +	/* check if the watchdog was disabled */
> > +	if (status & KEMPLD_WDT_CFG_ENABLE)
> > +		return -EACCES;
> > +
> > +	return 0;
> > +}
> > +
> > +static int kempld_wdt_keepalive(struct kempld_watchdog_data *wdt)
> > +{
> > +	struct kempld_device_data *pld = wdt->pld;
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_CFG);
> > +
> > +	kempld_write8(pld, KEMPLD_WDT_KICK, 'K');
> > +
> > +	kempld_release_mutex(pld);
> > +
> > +	return 0;
> > +}
> > +
> > +static int kempld_wdt_gettimeout(struct kempld_watchdog_data *wdt,
> > +				 struct kempld_watchdog_stage *stage)
> > +{
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	u8 stage_cfg;
> > +	int bits;
> > +	u64 timeout;
> > +	u32 remainder;
> > +
> > +	if (stage == NULL)
> > +		return 0;
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_STAGE_CFG(stage->num));
> > +
> > +	stage_cfg = kempld_read8(pld, KEMPLD_WDT_STAGE_CFG(stage->num));
> > +	timeout = kempld_read32(pld, KEMPLD_WDT_STAGE_TIMEOUT(stage->num));
> > +
> > +	kempld_release_mutex(pld);
> > +
> > +	bits = KEMPLD_WDT_STAGE_CFG_GET_PRESCALER(stage_cfg);
> > +	timeout = (timeout & stage->timeout_mask) * KEMPLD_PRESCALER(bits);
> > +	remainder = do_div(timeout, pld->pld_clock);
> > +
> > +	/* Round up the return value if necessary */
> > +	if ((timeout > 0) && (remainder >= (pld->pld_clock/2)))
> > +		timeout++;
> > +
> > +	return timeout;
> > +}
> > +
> > +static int kempld_wdt_setstageaction(struct kempld_watchdog_data *wdt,
> > +				 struct kempld_watchdog_stage *stage,
> > +				 int action)
> > +{
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	u8 stage_cfg;
> > +
> > +	if (stage == NULL)
> > +		return -EINVAL;
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_STAGE_CFG(stage->num));
> > +
> > +	stage_cfg = kempld_read8(pld, KEMPLD_WDT_STAGE_CFG(stage->num));
> > +	stage_cfg &= ~KEMPLD_WDT_STAGE_CFG_ACTION_MASK;
> > +	stage_cfg |= (action & KEMPLD_WDT_STAGE_CFG_ACTION_MASK);
> > +	if (action == KEMPLD_WDT_ACTION_RESET)
> > +		stage_cfg |= KEMPLD_WDT_STAGE_CFG_ASSERT;
> > +	else
> > +		stage_cfg &= ~KEMPLD_WDT_STAGE_CFG_ASSERT;
> > +
> > +	kempld_write8(pld, KEMPLD_WDT_STAGE_CFG(stage->num), stage_cfg);
> > +
> > +	kempld_release_mutex(pld);
> > +
> > +	return 0;
> > +}
> > +
> > +static int kempld_wdt_setstagetimeout(struct kempld_watchdog_data *wdt,
> > +				 struct kempld_watchdog_stage *stage,
> > +				 int timeout)
> > +{
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	u8 stage_cfg;
> > +	u8 prescaler;
> > +	u64 stage_timeout64;
> > +	u32 stage_timeout;
> > +	u32 remainder;
> > +
> > +	if (stage == NULL)
> > +		return -EINVAL;
> > +
> > +	prescaler = KEMPLD_WDT_PRESCALER_21BIT;
> > +
> > +	stage_timeout64 = ((u64)timeout*pld->pld_clock);
> > +	remainder = do_div(stage_timeout64, KEMPLD_PRESCALER(prescaler));
> > +	if (remainder)
> > +		stage_timeout64++;
> > +	stage_timeout = stage_timeout64 & stage->timeout_mask;
> > +
> > +	if (stage_timeout64 != (u64)stage_timeout)
> > +		return -EINVAL;
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_STAGE_CFG(stage->num));
> > +
> > +	stage_cfg = kempld_read8(pld, KEMPLD_WDT_STAGE_CFG(stage->num));
> > +	stage_cfg &= ~KEMPLD_WDT_STAGE_CFG_PRESCALER_MASK;
> > +	stage_cfg |= KEMPLD_WDT_STAGE_CFG_SET_PRESCALER(prescaler);
> > +	kempld_write8(pld, KEMPLD_WDT_STAGE_CFG(stage->num), stage_cfg);
> > +	kempld_write32(pld, KEMPLD_WDT_STAGE_TIMEOUT(stage->num),
> > +			stage_timeout);
> > +
> > +	kempld_release_mutex(pld);
> > +
> > +	return 0;
> > +}
> > +
> > +static void kempld_wdt_update_timeouts(struct kempld_watchdog_data *wdt)
> > +{
> > +	int pretimeout_stage;
> > +	int timeout_stage;
> > +
> > +	pretimeout_stage = kempld_wdt_gettimeout(wdt, wdt->pretimeout_stage);
> > +	timeout_stage = kempld_wdt_gettimeout(wdt, wdt->timeout_stage);
> > +
> > +	if (pretimeout_stage)
> > +		wdt->pretimeout = timeout_stage;
> > +	else
> > +		wdt->pretimeout = 0;
> > +
> > +	wdt->timeout = pretimeout_stage + timeout_stage;
> > +
> > +	if (wdt->pretimeout < 0) {
> > +		wdt->pretimeout = WATCHDOG_DEFAULT_PRETIMEOUT;
> > +		dev_err(wdt->pld->dev, "failed to get valid pretimeout value\n"
> > +			" -> using driver default\n");
> > +	}
> > +	if (wdt->timeout < 0) {
> > +		wdt->timeout = WATCHDOG_DEFAULT_TIMEOUT;
> > +		dev_err(wdt->pld->dev, "failed to get valid timeout value\n"
> > +			" -> using driver default\n");
> > +	}
> > +}
> > +
> > +static int kempld_wdt_settimeout(struct kempld_watchdog_data *wdt)
> > +{
> > +	int stage_timeout;
> > +	int stage_pretimeout;
> > +	int ret;
> > +
> > +	if ((wdt->timeout <= 0) ||
> > +		(wdt->pretimeout < 0) ||
> > +		(wdt->pretimeout > wdt->timeout)) {
> > +		ret = -EINVAL;
> > +		goto err_check_values;
> > +	}
> > +
> > +	if ((wdt->pretimeout == 0) || (wdt->pretimeout_stage == NULL)) {
> > +		if (wdt->pretimeout != 0)
> > +			dev_warn(wdt->pld->dev,
> > +				 "no pretimeout stage available\n"
> > +				 " -> only enabling reset\n");
> > +		stage_pretimeout = 0;
> > +		stage_timeout = wdt->timeout;
> > +	} else {
> > +		stage_pretimeout = wdt->timeout - wdt->pretimeout;
> > +		stage_timeout = wdt->pretimeout;
> > +	}
> > +
> > +	if (stage_pretimeout != 0) {
> > +		ret = kempld_wdt_setstageaction(wdt, wdt->pretimeout_stage,
> > +						KEMPLD_WDT_ACTION_NMI);
> > +	} else if ((stage_pretimeout == 0)
> > +			&& (wdt->pretimeout_stage != NULL)) {
> > +		ret = kempld_wdt_setstageaction(wdt, wdt->pretimeout_stage,
> > +						KEMPLD_WDT_ACTION_NONE);
> > +	} else
> > +		ret = 0;
> > +	if (ret)
> > +		goto err_setstage;
> > +
> > +	if (stage_pretimeout != 0) {
> > +		ret = kempld_wdt_setstagetimeout(wdt, wdt->pretimeout_stage,
> > +						 stage_pretimeout);
> > +		if (ret)
> > +			goto err_setstage;
> > +	}
> > +
> > +	ret = kempld_wdt_setstageaction(wdt, wdt->timeout_stage,
> > +					KEMPLD_WDT_ACTION_RESET);
> > +	if (ret)
> > +		goto err_setstage;
> > +
> > +	ret = kempld_wdt_setstagetimeout(wdt, wdt->timeout_stage,
> > +					 stage_timeout);
> > +	if (ret)
> > +		goto err_setstage;
> > +
> > +	return 0;
> > +err_setstage:
> > +err_check_values:
> > +	return ret;
> > +}
> > +
> > +static ssize_t kempld_wdt_write(struct file *file, const char __user *data,
> > +				size_t count, loff_t *ppos)
> > +{
> > +	struct kempld_watchdog_data *wdt = kempld_wdt;
> > +
> > +	BUG_ON(wdt == NULL);
> > +
> > +	if (count) {
> > +		kempld_wdt_keepalive(wdt);
> > +
> > +		if (!nowayout) {
> > +			size_t i;
> > +
> > +			wdt->expect_close = 0;
> > +
> > +			for (i = 0; i < count; i++) {
> > +				char c;
> > +				if (get_user(c, data+i))
> > +					return -EFAULT;
> > +				if (c == 'V')
> > +					wdt->expect_close = 42;
> > +			}
> > +		}
> > +	}
> > +
> > +	return count;
> > +}
> > +
> > +static long kempld_wdt_ioctl(struct file *file, unsigned int cmd,
> > +				unsigned long arg)
> > +{
> > +	void __user *argp = (void __user *)arg;
> > +	int __user *p = argp;
> > +	struct kempld_watchdog_data *wdt = kempld_wdt;
> > +	int options;
> > +	int value;
> > +	int ret = 0;
> > +
> > +	BUG_ON(wdt == NULL);
> > +
> > +	switch (cmd) {
> > +	case WDIOC_GETSUPPORT:
> > +		if (copy_to_user(argp, &wdt->ident, sizeof(wdt->ident)))
> > +			ret = -EFAULT;
> > +		break;
> > +	case WDIOC_GETSTATUS:
> > +	case WDIOC_GETBOOTSTATUS:
> > +		ret = put_user(0, p);
> > +		break;
> > +	case WDIOC_SETOPTIONS:
> > +		if (get_user(options, p)) {
> > +			ret = -EFAULT;
> > +			break;
> > +		}
> > +		if (options & WDIOS_DISABLECARD)
> > +			ret = kempld_wdt_stop(wdt);
> > +		if (options & WDIOS_ENABLECARD) {
> > +			ret = kempld_wdt_start(wdt);
> > +			kempld_wdt_keepalive(wdt);
> > +		}
> > +		break;
> > +	case WDIOC_KEEPALIVE:
> > +		kempld_wdt_keepalive(wdt);
> > +		break;
> > +	case WDIOC_SETTIMEOUT:
> > +		if (get_user(value, p)) {
> > +			ret = -EFAULT;
> > +			break;
> > +		}
> > +		kempld_wdt_update_timeouts(wdt);
> > +		wdt->timeout = value;
> > +		ret = kempld_wdt_settimeout(wdt);
> > +		kempld_wdt_keepalive(wdt);
> > +		break;
> > +	case WDIOC_GETTIMEOUT:
> > +		value = kempld_wdt_gettimeout(wdt, wdt->timeout_stage);
> > +		value += kempld_wdt_gettimeout(wdt, wdt->pretimeout_stage);
> > +		if (value < 0)
> > +			ret = ERANGE;
> > +		else
> > +			ret = put_user(value, p);
> > +		break;
> > +	case WDIOC_SETPRETIMEOUT:
> > +		if (get_user(value, p)) {
> > +			ret = -EFAULT;
> > +			break;
> > +		}
> > +		kempld_wdt_update_timeouts(wdt);
> > +		wdt->pretimeout = value;
> > +		ret = kempld_wdt_settimeout(wdt);
> > +		kempld_wdt_keepalive(wdt);
> > +		break;
> > +	case WDIOC_GETPRETIMEOUT:
> > +		value = kempld_wdt_gettimeout(wdt, wdt->pretimeout_stage);
> > +		if (value)
> > +			value = kempld_wdt_gettimeout(wdt, wdt->timeout_stage);
> > +		if (value < 0)
> > +			ret = ERANGE;
> > +		else
> > +			ret = put_user(value, p);
> > +		break;
> > +	default:
> > +		ret = -ENOTTY;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int kempld_wdt_release(struct inode *inode, struct file *file)
> > +{
> > +	struct kempld_watchdog_data *wdt = kempld_wdt;
> > +
> > +	BUG_ON(wdt == NULL);
> > +
> > +	if (wdt->expect_close)
> > +		kempld_wdt_stop(wdt);
> > +	else {
> > +		dev_warn(wdt->pld->dev,
> > +			 "Unexpected close, not stopping watchdog!\n");
> > +		kempld_wdt_keepalive(wdt);
> > +	}
> > +
> > +	kempld_wdt->expect_close = 0;
> > +
> > +	clear_bit(0, &wdt->is_open);
> > +
> > +	return 0;
> > +}
> > +
> > +static int kempld_wdt_open(struct inode *inode, struct file *file)
> > +{
> > +	int ret;
> > +	struct kempld_watchdog_data *wdt = kempld_wdt;
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	u8 status;
> > +
> > +	BUG_ON(wdt == NULL);
> > +
> > +	if (test_and_set_bit(0, &wdt->is_open))
> > +		return -EBUSY;
> > +
> > +	if (nowayout)
> > +		__module_get(THIS_MODULE);
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_CFG);
> > +	status = kempld_read8(pld, KEMPLD_WDT_CFG);
> > +	kempld_release_mutex(pld);
> > +
> > +	/* kick the watchdog if it is already enabled, otherwise start it */
> > +	if (status & KEMPLD_WDT_CFG_ENABLE) {
> > +		kempld_wdt_keepalive(wdt);
> > +	} else {
> > +		ret = kempld_wdt_settimeout(wdt);
> > +		if (ret)
> > +			goto err_enable_wdt;
> > +		ret = kempld_wdt_start(wdt);
> > +		if (ret)
> > +			goto err_enable_wdt;
> > +	}
> > +
> > +	return nonseekable_open(inode, file);
> > +
> > +err_enable_wdt:
> > +	dev_err(wdt->pld->dev, "Failed to enable the watchdog timer!\n");
> > +	wdt->expect_close = 1;
> > +	kempld_wdt_release(inode, file);
> > +
> > +	return ret;
> > +}
> > +
> > +static void kempld_wdt_release_stages(struct kempld_watchdog_data *wdt)
> > +{
> > +	int stage;
> > +
> > +	wdt->timeout_stage = NULL;
> > +	wdt->pretimeout_stage = NULL;
> > +
> > +	for (stage = 0; stage < KEMPLD_WDT_MAX_STAGES; stage++) {
> > +		kfree(wdt->stage[stage]);
> > +		wdt->stage[stage] = NULL;
> > +	}
> > +}
> > +
> > +static int kempld_wdt_probe_stages(struct kempld_watchdog_data *wdt)
> > +{
> > +	struct kempld_device_data *pld = wdt->pld;
> > +	int i, ret;
> > +	u32 timeout_mask;
> > +	struct kempld_watchdog_stage *stage;
> > +
> > +	wdt->stages = 0;
> > +	wdt->timeout_stage = NULL;
> > +	wdt->pretimeout_stage = NULL;
> > +
> > +	for (i = 0; i < KEMPLD_WDT_MAX_STAGES; i++) {
> > +		int j;
> > +		u8 index, data, data_orig;
> > +
> > +		index = KEMPLD_WDT_STAGE_TIMEOUT(i);
> > +		timeout_mask = ~0;
> > +
> > +		kempld_get_mutex_set_index(pld, index);
> > +
> > +		/* Probe each byte individually according to new spec revision.
> > +		 * Register content is restored afterwards. */
> > +		for (j = 0; j < 4; j++) {
> > +			data_orig = kempld_read8(pld, index);
> > +			kempld_write8(pld, index, 0x00);
> > +			data = kempld_read8(pld, index);
> > +			kempld_write8(pld, index, data_orig);
> > +			*(((u8 *)&timeout_mask)+j) &= data;
> > +			if (data != 0x0)
> > +				break;
> > +			index++;
> > +		}
> > +
> > +		kempld_release_mutex(pld);
> > +
> > +		if ((timeout_mask & 0xff) != 0xff) {
> > +			stage = kzalloc(sizeof(struct kempld_watchdog_stage),
> > +					GFP_KERNEL);
> > +			if (stage == NULL) {
> > +				ret = -ENOMEM;
> > +				goto err_alloc_stages;
> > +			}
> > +			stage->num = i;
> > +			stage->timeout_mask = ~timeout_mask;
> > +			wdt->stage[i] = stage;
> > +			wdt->stages++;
> > +
> > +			/* assign available stages to timeout and pretimeout */
> > +			if (wdt->timeout_stage == NULL) {
> > +				wdt->timeout_stage = stage;
> > +			} else if ((wdt->pretimeout_stage == NULL) &&
> > +				(pld->feature_mask & KEMPLD_FEATURE_BIT_NMI)) {
> > +				wdt->pretimeout_stage = wdt->timeout_stage;
> > +				wdt->timeout_stage = stage;
> > +			}
> > +		} else
> > +			wdt->stage[i] = NULL;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_alloc_stages:
> > +	kempld_wdt_release_stages(wdt);
> > +
> > +	return ret;
> > +}
> > +
> > +static const struct file_operations kempld_wdt_fops = {
> > +	.owner		= THIS_MODULE,
> > +	.llseek		= no_llseek,
> > +	.write		= kempld_wdt_write,
> > +	.unlocked_ioctl	= kempld_wdt_ioctl,
> > +	.open		= kempld_wdt_open,
> > +	.release	= kempld_wdt_release,
> > +};
> > +
> > +static struct miscdevice kempld_wdt_miscdev = {
> > +	.minor	= WATCHDOG_MINOR,
> > +	.name	= "watchdog",
> > +	.fops	= &kempld_wdt_fops,
> > +};
> > +
> > +static int kempld_wdt_probe(struct platform_device *pdev)
> > +{
> > +	struct kempld_watchdog_data *wdt;
> > +	struct kempld_device_data *pld;
> > +	u8 status;
> > +	int ret;
> > +
> > +	if (kempld_wdt != NULL) {
> > +		dev_err(&pdev->dev,
> > +			"unable to support more than one watchdog devices\n");
> > +		return -EMFILE;
> > +	}
> > +
> > +	wdt = kzalloc(sizeof(struct kempld_watchdog_data), GFP_KERNEL);
> > +	if (wdt == NULL) {
> > +		dev_err(&pdev->dev, "unable to get memory for device data\n");
> > +		ret = -ENOMEM;
> > +		goto err_alloc_dev_data;
> > +	}
> > +
> > +	pld = dev_get_drvdata(pdev->dev.parent);
> > +	wdt->pld = pld;
> > +
> > +	platform_set_drvdata(pdev, wdt);
> > +
> > +	strncpy(wdt->ident.identity, "KEMPLD Watchdog",
> > +		sizeof(wdt->ident.identity));
> > +
> > +	/* watchdog firmware version is identical to the CPLD version */
> > +	wdt->ident.firmware_version = (pld->info.major<<24)
> > +		| (pld->info.minor<<16) | pld->info.buildnr;
> > +
> > +	/* probe how many usable stages we have */
> > +	ret = kempld_wdt_probe_stages(wdt);
> > +	if (ret)
> > +		goto err_probe_stages;
> > +
> > +	/* get initial watchdog status */
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_CFG);
> > +	status = kempld_read8(pld, KEMPLD_WDT_CFG);
> > +	kempld_release_mutex(wdt->pld);
> > +
> > +	/* check if the watchdog is already locked and enable the nowayout
> > +	 * option in that case */
> > +	if (status & (KEMPLD_WDT_CFG_ENABLE_LOCK |
> > +			KEMPLD_WDT_CFG_GLOBAL_LOCK)) {
> > +		if (!nowayout)
> > +			dev_warn(wdt->pld->dev,
> > +				 "Forcing nowayout - watchdog lock enabled!\n");
> > +		nowayout = 1;
> > +	}
> > +
> > +	/* set default values for the case we start the watchdog or change
> > +	 * the configuration */
> > +	wdt->timeout = WATCHDOG_DEFAULT_TIMEOUT;
> > +	wdt->pretimeout = WATCHDOG_DEFAULT_PRETIMEOUT;
> > +
> > +	/* check if watchdog is enabled */
> > +	if (status & KEMPLD_WDT_CFG_ENABLE) {
> > +		/* Get current watchdog settings */
> > +		kempld_wdt_update_timeouts(wdt);
> > +
> > +		dev_info(wdt->pld->dev, "Watchdog is already enabled:\n"
> > +			 "%d s timeout and %d s pretimeout!\n",
> > +			 wdt->timeout, wdt->pretimeout);
> > +	}
> > +
> > +	/* update the timeout settings if requested by module parameters */
> > +	if (timeout > 0)
> > +		wdt->timeout = timeout;
> > +	if (pretimeout >= 0)
> > +		wdt->pretimeout = pretimeout;
> > +
> > +	dev_info(wdt->pld->dev, "watchdog will be set on (re)start\n"
> > +		 "new settings: %d s timeout and %d s pretimeout\n",
> > +		 wdt->timeout, wdt->pretimeout);
> > +
> > +	wdt->ident.options = WDIOF_KEEPALIVEPING;
> > +	if ((wdt->timeout_stage) && !(status & KEMPLD_WDT_CFG_GLOBAL_LOCK))
> > +		wdt->ident.options |= WDIOF_SETTIMEOUT;
> > +	if (wdt->pretimeout_stage)
> > +		wdt->ident.options |= WDIOF_PRETIMEOUT;
> > +	if (!nowayout)
> > +		wdt->ident.options |= WDIOF_MAGICCLOSE;
> > +
> > +	kempld_wdt = wdt;
> > +
> > +	ret = misc_register(&kempld_wdt_miscdev);
> > +	if (ret)
> > +		goto err_misc_register;
> > +
> > +	dev_info(wdt->pld->dev,
> > +		 "%d stage watchdog initialized, pretimeout %ssupported\n",
> > +		 wdt->stages, wdt->pretimeout_stage ? "" : "not ");
> > +
> > +	return 0;
> > +
> > +err_probe_stages:
> > +err_misc_register:
> > +	kfree(kempld_wdt);
> > +	kempld_wdt = NULL;
> > +err_alloc_dev_data:
> > +	return ret;
> > +}
> > +
> > +static void kempld_wdt_shutdown(struct platform_device *pdev)
> > +{
> > +	struct kempld_watchdog_data *wdt = platform_get_drvdata(pdev);
> > +
> > +	BUG_ON(wdt != kempld_wdt);
> > +
> > +	/* stop or at least keepalive the watchdog before we leave */
> > +	if (wdt != NULL) {
> > +		if (!nowayout)
> > +			kempld_wdt_stop(wdt);
> > +		else
> > +			kempld_wdt_keepalive(wdt);
> > +	}
> > +}
> > +
> > +static int kempld_wdt_remove(struct platform_device *pdev)
> > +{
> > +	struct kempld_watchdog_data *wdt = platform_get_drvdata(pdev);
> > +
> > +	BUG_ON(wdt != kempld_wdt);
> > +
> > +	/* stop or at least keepalive the watchdog before we leave */
> > +	kempld_wdt_shutdown(pdev);
> > +
> > +	misc_deregister(&kempld_wdt_miscdev);
> > +
> > +	kempld_wdt_release_stages(wdt);
> > +
> > +	kfree(wdt);
> > +	kempld_wdt = NULL;
> > +	platform_set_drvdata(pdev, NULL);
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_PM
> > +static int wdt_pm_status_store;
> > +
> > +/* Disable watchdog if it is active during suspend */
> > +static int kempld_wdt_suspend(struct platform_device *pdev,
> > +				pm_message_t message)
> > +{
> > +	struct kempld_watchdog_data *wdt = platform_get_drvdata(pdev);
> > +	struct kempld_device_data *pld = dev_get_drvdata(pdev->dev.parent);
> > +
> > +	kempld_get_mutex_set_index(pld, KEMPLD_WDT_CFG);
> > +	wdt_pm_status_store = kempld_read8(pld, KEMPLD_WDT_CFG);
> > +	kempld_release_mutex(pld);
> > +
> > +	kempld_wdt_update_timeouts(wdt);
> > +
> > +	if (wdt_pm_status_store & KEMPLD_WDT_CFG_ENABLE)
> > +		kempld_wdt_shutdown(pdev);
> > +
> > +	return 0;
> > +}
> > +
> > +/* Enable watchdog and configure it if necessary */
> > +static int kempld_wdt_resume(struct platform_device *pdev)
> > +{
> > +	struct kempld_watchdog_data *wdt = platform_get_drvdata(pdev);
> > +	int ret;
> > +
> > +	/* if watchdog was stopped before suspend be sure it gets disabled
> > +	 * again, for the case BIOS has enabled it during resume */
> > +	if (wdt_pm_status_store & KEMPLD_WDT_CFG_ENABLE) {
> > +		ret = kempld_wdt_settimeout(wdt);
> > +		if (ret)
> > +			goto err_enable_wdt;
> > +		ret = kempld_wdt_start(wdt);
> > +		if (ret)
> > +			goto err_enable_wdt;
> > +
> > +		dev_info(wdt->pld->dev, "Resuming watchdog operation:\n"
> > +			 "%d s timeout and %d s pretimeout\n", wdt->timeout,
> > +			 wdt->pretimeout);
> > +	} else
> > +		kempld_wdt_shutdown(pdev);
> > +
> > +	return 0;
> > +
> > +err_enable_wdt:
> > +	dev_err(wdt->pld->dev,
> > +		"Failed to reenable the watchdog timer after resume!\n");
> > +
> > +	return ret;
> > +}
> > +#else
> > +#define kempld_wdt_suspend	NULL
> > +#define kempld_wdt_resume	NULL
> > +#endif
> > +
> > +static struct platform_driver kempld_wdt_driver = {
> > +	.driver = {
> > +		.name = "kempld-wdt",
> > +		.owner = THIS_MODULE,
> > +	},
> > +	.probe = kempld_wdt_probe,
> > +	.remove = kempld_wdt_remove,
> > +	.shutdown = kempld_wdt_shutdown,
> > +	.suspend = kempld_wdt_suspend,
> > +	.resume = kempld_wdt_resume,
> > +};
> > +
> > +static int __init kempld_wdt_init(void)
> > +{
> > +	return platform_driver_register(&kempld_wdt_driver);
> > +}
> > +
> > +static void __exit kempld_wdt_exit(void)
> > +{
> > +	platform_driver_unregister(&kempld_wdt_driver);
> > +}
> > +
> > +module_init(kempld_wdt_init);
> > +module_exit(kempld_wdt_exit);
> > +
> > +MODULE_DESCRIPTION("KEM PLD Watchdog Driver");
> > +MODULE_AUTHOR("Michael Brunner <michael.brunner@kontron.com>");
> > +MODULE_LICENSE("GPL");
> > +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> > diff --git a/drivers/watchdog/kempld_wdt.h b/drivers/watchdog/kempld_wdt.h
> > new file mode 100644
> > index 0000000..80f68f6
> > --- /dev/null
> > +++ b/drivers/watchdog/kempld_wdt.h
> > @@ -0,0 +1,75 @@
> > +/*
> > + *  kempld_wdt.h - Kontron PLD watchdog driver definitions
> > + *
> > + *  Copyright (c) 2010-2012 Kontron Europe GmbH
> > + *  Author: Michael Brunner <michael.brunner@kontron.com>
> > + *
> > + *  This program is free software; you can redistribute it and/or modify
> > + *  it under the terms of the GNU General Public License 2 as published
> > + *  by the Free Software Foundation.
> > + *
> > + *  This program is distributed in the hope that it will be useful,
> > + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *  GNU General Public License for more details.
> > + *
> > + *  You should have received a copy of the GNU General Public License
> > + *  along with this program; see the file COPYING.  If not, write to
> > + *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> > + */
> > +
> > +#ifndef _KEMPLD_WDT_H_
> > +#define _KEMPLD_WDT_H_
> > +
> > +/* watchdog register definitions */
> > +#define KEMPLD_WDT_KICK			0x16
> > +#define KEMPLD_WDT_CFG			0x17
> > +#define		KEMPLD_WDT_CFG_STAGE_TIMEOUT_OCCURED(x)	(1<<x)
> > +#define		KEMPLD_WDT_CFG_ENABLE_LOCK		0x8
> > +#define		KEMPLD_WDT_CFG_ENABLE			0x10
> > +#define		KEMPLD_WDT_CFG_AUTO_RELOAD		0x40
> > +#define		KEMPLD_WDT_CFG_GLOBAL_LOCK		0x80
> > +#define KEMPLD_WDT_STAGE_CFG(x)		(0x18+x)
> > +#define		KEMPLD_WDT_STAGE_CFG_ACTION_MASK	0x7
> > +#define		KEMPLD_WDT_STAGE_CFG_GET_ACTION(x)	(x & 0x7)
> > +#define		KEMPLD_WDT_STAGE_CFG_ASSERT		(1<<3)
> > +#define		KEMPLD_WDT_STAGE_CFG_PRESCALER_MASK	0x30
> > +#define		KEMPLD_WDT_STAGE_CFG_GET_PRESCALER(x)	((x & 0x30)>>4)
> > +#define		KEMPLD_WDT_STAGE_CFG_SET_PRESCALER(x)	((x & 0x30)<<4)
> > +#define KEMPLD_WDT_STAGE_TIMEOUT(x)	(0x1b+x*4)
> > +#define KEMPLD_WDT_MAX_STAGES		3
> > +
> > +#define	KEMPLD_WDT_ACTION_NONE		0x0
> > +#define	KEMPLD_WDT_ACTION_RESET		0x1
> > +#define	KEMPLD_WDT_ACTION_NMI		0x2
> > +#define	KEMPLD_WDT_ACTION_SMI		0x3
> > +#define	KEMPLD_WDT_ACTION_SCI		0x4
> > +#define	KEMPLD_WDT_ACTION_DELAY		0x5
> > +
> > +#define	KEMPLD_WDT_PRESCALER_21BIT	0x0
> > +#define	KEMPLD_WDT_PRESCALER_17BIT	0x1
> > +#define	KEMPLD_WDT_PRESCALER_12BIT	0x2
> > +
> > +const int kempld_prescaler_bits[] = { 21, 17, 12 };
> > +#define KEMPLD_PRESCALER(x)	(0xffffffff>>(32-kempld_prescaler_bits[x]))
> > +
> > +
> > +struct kempld_watchdog_stage {
> > +	int	num;
> > +	u32	timeout_mask;
> > +};
> > +
> > +struct kempld_watchdog_data {
> > +	int				timeout;
> > +	int				pretimeout;
> > +	unsigned long			is_open;
> > +	unsigned long			expect_close;
> > +	int				stages;
> > +	struct kempld_watchdog_stage	*timeout_stage;
> > +	struct kempld_watchdog_stage	*pretimeout_stage;
> > +	struct kempld_device_data	*pld;
> > +	struct watchdog_info		ident;
> > +	struct kempld_watchdog_stage	*stage[KEMPLD_WDT_MAX_STAGES];
> > +};
> > +
> > +#endif /* _KEMPLD_WDT_H_ */
> > -- 
> > 1.7.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
