Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549Ab3CZOdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:33:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53744 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759803Ab3CZOdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:33:20 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 26 Mar 2013 07:33:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, linux-i2c@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] watchdog: Add Congatec CGEB watchdog driver
Message-ID: <20130326143331.GA5529@roeck-us.net>
References: <1360663374-30951-1-git-send-email-s.hauer@pengutronix.de>
 <1360663374-30951-4-git-send-email-s.hauer@pengutronix.de>
 <CAH9NwWd7YdtK0urutisVgKoE7NmPFLpG3wFG5W6P7o45vUqAng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH9NwWd7YdtK0urutisVgKoE7NmPFLpG3wFG5W6P7o45vUqAng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 11:16:35AM +0100, Christian Gmeiner wrote:
> 2013/2/12 Sascha Hauer <s.hauer@pengutronix.de>:
> > This driver provides support for the CGEB watchdog found on some
> > Congatec x86 modules.
> >
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  drivers/watchdog/Kconfig                  |   10 ++
> >  drivers/watchdog/Makefile                 |    1 +
> >  drivers/watchdog/congatec_cgeb_watchdog.c |  161 +++++++++++++++++++++++++++++
> >  3 files changed, 172 insertions(+)
> >  create mode 100644 drivers/watchdog/congatec_cgeb_watchdog.c
> >
> > diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> > index 7f809fd..47138fb 100644
> > --- a/drivers/watchdog/Kconfig
> > +++ b/drivers/watchdog/Kconfig
> > @@ -934,6 +934,16 @@ config SBC_EPX_C3_WATCHDOG
> >           To compile this driver as a module, choose M here: the
> >           module will be called sbc_epx_c3.
> >
> > +config CONGATEC_CGEB_WATCHDOG
> > +       depends on CONGATEC_CGEB
> > +       tristate "Congatec CGEB watchdog"
> > +       ---help---
> > +         This driver provides support for the watchdogs found on Congatec
> > +         modules with the CGEB BIOS interface.
> > +
> > +         To compile this driver as a module, choose M here: the
> > +         module will be called congatec_cgeb_wdt.
> > +
> >  # M32R Architecture
> >
> >  # M68K Architecture
> > diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> > index 97bbdb3a..e67eee5 100644
> > --- a/drivers/watchdog/Makefile
> > +++ b/drivers/watchdog/Makefile
> > @@ -108,6 +108,7 @@ obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
> >  obj-$(CONFIG_MACHZ_WDT) += machzwd.o
> >  obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
> >  obj-$(CONFIG_INTEL_SCU_WATCHDOG) += intel_scu_watchdog.o
> > +obj-$(CONFIG_CONGATEC_CGEB_WATCHDOG) += congatec_cgeb_watchdog.o
> >
> >  # M32R Architecture
> >
> > diff --git a/drivers/watchdog/congatec_cgeb_watchdog.c b/drivers/watchdog/congatec_cgeb_watchdog.c
> > new file mode 100644
> > index 0000000..b7b6cf5
> > --- /dev/null
> > +++ b/drivers/watchdog/congatec_cgeb_watchdog.c
> > @@ -0,0 +1,161 @@
> > +/*
> > + * CGEB watchdog driver
> > + *
> > + * (c) 2011 Sascha Hauer, Pengutronix
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/watchdog.h>
> > +#include <asm/congatec-cgeb.h>
> > +
> > +#define CGOS_WDOG_MODE_REBOOT_PC    0
> > +#define CGOS_WDOG_MODE_RESTART_OS   1
> > +#define CGOS_WDOG_MODE_STAGED    0x80
> > +
> > +#define CGOS_WDOG_OPMODE_DISABLED      0
> > +#define CGOS_WDOG_OPMODE_ONETIME_TRIG  1
> > +#define CGOS_WDOG_OPMODE_SINGLE_EVENT  2
> > +#define CGOS_WDOG_OPMODE_EVENT_REPEAT  3
> > +
> > +#define CGOS_WDOG_EVENT_INT 0  /* NMI/IRQ */
> > +#define CGOS_WDOG_EVENT_SCI 1  /* SMI/SCI */
> > +#define CGOS_WDOG_EVENT_RST 2  /* system reset */
> > +#define CGOS_WDOG_EVENT_BTN 3  /* power button */
> > +
> > +#define CGOS_WDOG_EVENT_MAX_STAGES 3
> > +
> > +struct cgeb_watchdog_stage {
> > +       unsigned long timeout;
> > +       unsigned long event;
> > +};
> > +
> > +struct cgeb_watchdog_config {
> > +       unsigned long size;
> > +       unsigned long timeout; /* not used in staged mode */
> > +       unsigned long delay;
> > +       unsigned long mode;
> > +       /* optional parameters for staged watchdog */
> > +       unsigned long op_mode;
> > +       unsigned long stage_count;
> > +       struct cgeb_watchdog_stage stages[CGOS_WDOG_EVENT_MAX_STAGES];
> > +};

Presumably that is a data structure sent to the board. Just wondering - can the
driver ever be build as 64 bit driver ? If so, you might want to use u32 instead
of unsigned long.

> > +
> > +struct cgeb_watchdog_priv {
> > +       struct cgeb_board_data  *board;
> > +       struct watchdog_device  wdd;
> > +       int unit;
> > +};
> > +
> > +static struct watchdog_info cgeb_wdd_info = {
> > +       .options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
> > +       .firmware_version = 0,
> > +       .identity = "cgeb watchdog",
> > +};
> > +
> > +static unsigned int watchdog_set_config(struct cgeb_watchdog_priv *priv,
> > +               unsigned int timeout_s)
> > +{
> > +       struct cgeb_board_data *board = priv->board;
> > +       struct cgeb_watchdog_config wdi;
> > +       struct cgeb_function_parameters fps;
> > +
> > +       memset(&wdi, 0, sizeof(wdi));
> > +       memset(&fps, 0, sizeof(fps));
> > +
> > +       fps.unit = priv->unit;
> > +       fps.iptr = &wdi;
> > +
> > +       wdi.timeout = timeout_s * 1000;
> > +       wdi.delay = 0;
> > +       wdi.size = sizeof(wdi);
> > +       wdi.mode = CGOS_WDOG_MODE_REBOOT_PC;
> > +
> > +       return cgeb_call(board, &fps, CgebWDogSetConfig);
> > +}
> > +
> > +static int cgeb_watchdog_start(struct watchdog_device *wdd)
> > +{
> > +       struct cgeb_watchdog_priv *priv = watchdog_get_drvdata(wdd);
> > +
> > +       return watchdog_set_config(priv, wdd->timeout);
> > +}
> > +
> > +static int cgeb_watchdog_stop(struct watchdog_device *wdd)
> > +{
> > +       struct cgeb_watchdog_priv *priv = watchdog_get_drvdata(wdd);
> > +
> > +       return watchdog_set_config(priv, 0);
> > +}
> > +
> > +static int cgeb_watchdog_set_timeout(struct watchdog_device *wdd,
> > +               unsigned int timeout_s)
> > +{
> > +       return 0;
> > +}

That doesn't make any sense - it means wdd->timeout is never set. That also
means it is never started.

> > +
> > +struct watchdog_ops cgeb_watchdog_ops = {
> > +       .start = cgeb_watchdog_start,
> > +       .stop = cgeb_watchdog_stop,
> > +       .set_timeout = cgeb_watchdog_set_timeout,
> > +};
> > +
> > +static int cgeb_watchdog_probe(struct platform_device *pdev)
> > +{
> > +       struct cgeb_watchdog_priv *priv;
> > +       struct cgeb_pdata *pdata = pdev->dev.platform_data;
> > +       int ret;
> > +
> > +       priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> > +       if (!priv)
> > +               return -ENOMEM;
> > +
> > +       priv->wdd.ops = &cgeb_watchdog_ops;
> > +       priv->wdd.info = &cgeb_wdd_info;
> > +       priv->wdd.min_timeout = 1;
> > +       priv->wdd.max_timeout = 3600;

Might make sense to also set wdd.timeout to a default value, especially since
watchdog_init_timeout is not called.

On a side note, if the driver supports devicetree, it might make sense to call
watchdog_init_timeout, since it initializes the timeout from devicetree data.


> > +       priv->board = pdata->board;
> > +       priv->unit = pdata->unit;
> > +
> > +       watchdog_set_drvdata(&priv->wdd, priv);
> > +       platform_set_drvdata(pdev, priv);
> > +
> > +       ret = watchdog_register_device(&priv->wdd);
> > +       if (ret)
> > +               return ret;
> > +
> > +       dev_info(&pdev->dev, "registered\n");
> > +
> > +       return 0;
> > +}
> > +
> > +static int cgeb_watchdog_remove(struct platform_device *pdev)
> > +{
> > +       struct cgeb_watchdog_priv *priv = platform_get_drvdata(pdev);
> > +
> > +       watchdog_unregister_device(&priv->wdd);
> > +
> > +       return 0;
> > +}
> > +
> > +static struct platform_driver cgeb_watchdog_driver = {
> > +       .probe          = cgeb_watchdog_probe,
> > +       .remove         = cgeb_watchdog_remove,
> > +       .driver = {
> > +               .name   = "cgeb-watchdog",
> > +               .owner  = THIS_MODULE,
> > +       },
> > +};
> > +module_platform_driver(cgeb_watchdog_driver);
> > +
> > +MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
> > +MODULE_DESCRIPTION("cgeb watchdog driver");
> > +MODULE_LICENSE("GPL v2");
> > --
> 
> There seems to be a problem:
> 
> Mar 26 16:11:25 OT kernel: [   80.207514] cgeb-watchdog
> cgeb-watchdog.0: registered
> Mar 26 16:11:38 OT watchdog[2519]: stopping daemon (5.9)
> Mar 26 16:11:43 OT watchdog[2750]: starting daemon (5.9):
> Mar 26 16:11:43 OT watchdog[2750]: int=1s realtime=yes sync=no soft=no
> mla=0 mem=0
> Mar 26 16:11:43 OT watchdog[2750]: ping: no machine to check
> Mar 26 16:11:43 OT watchdog[2750]: file: no file to check
> Mar 26 16:11:43 OT watchdog[2750]: pidfile: no server process to check
> Mar 26 16:11:43 OT watchdog[2750]: interface: no interface to check
> Mar 26 16:11:43 OT watchdog[2750]: test=none(0) repair=none(0)
> alive=/dev/watchdog heartbeat=none temp=none to=root no_act=no
> Mar 26 16:11:43 OT watchdog[2750]: cannot set timeout 60 (errno = 95 =
> 'Operation not supported')
> Mar 26 16:11:43 OT watchdog[2750]: hardware wartchdog identity: cgeb watchdog
> 
> Will look into it until friday.
> 
> --
> Christian Gmeiner, MSc
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
