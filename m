Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab3ANQof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:44:35 -0500
Received: from mail160.messagelabs.com ([216.82.253.99]:30327 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab3ANQoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:44:34 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1358181831!8441713!16
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.8; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Peter Huewe <peterhuewe@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ian Abbott <abbotti@mev.co.uk>, Mori Hess <fmhess@users.sourceforge.net>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Jan 2013 10:44:29 -0600
Subject: RE: [PATCH 1/8] staging/comedi: Add macro for registering a comedi
 PCMCIA driver
Thread-Topic: [PATCH 1/8] staging/comedi: Add macro for registering a comedi
 PCMCIA driver
Thread-Index: Ac3xMulQ+8YEeW8/T3C0nrt3UCtFSgBQofYA
Message-ID: <ADE657CA350FB648AAC2C43247A983F00207A6CBADD1@AUSP01VMBX24.collaborationhost.net>
References: <1358043073-12328-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1358043073-12328-1-git-send-email-peterhuewe@gmx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 12, 2013 7:11 PM, Peter Huewe wrote:
> This patch introduces a new macro 'module_comedi_pcmcia_driver'
> for comedi PCMCIA drivers which do not do anything special in module
> init/exit. This eliminates a lot of boilerplate.
>
> Adapted from 'module_comedi_pci_driver'
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/staging/comedi/comedidev.h |   22 ++++++++++++++++++++++
>  drivers/staging/comedi/drivers.c   |   34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 692e1e6..ccb22dd 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -41,6 +41,9 @@
>  #include <linux/io.h>
>  #include <linux/timer.h>
>  #include <linux/pci.h>
> +#include <pcmcia/cistpl.h>
> +#include <pcmcia/cisreg.h>
> +#include <pcmcia/ds.h>

Are these includes actually needed here?

We need to work on getting rid of relying on comedidev.h to include everything,

>  #include <linux/usb.h>
>  
>  #include "comedi.h"
> @@ -342,6 +345,25 @@ void comedi_pci_driver_unregister(struct comedi_driver *, struct pci_driver *);
>  	module_driver(__comedi_driver, comedi_pci_driver_register, \
>  			comedi_pci_driver_unregister, &(__pci_driver))
>  
> +int comedi_pcmcia_driver_register(struct comedi_driver *,
> +					struct pcmcia_driver *);
> +void comedi_pcmcia_driver_unregister(struct comedi_driver *,
> +					struct pcmcia_driver *);
> +
> +/**
> + * module_comedi_pcmcia_driver() - Helper macro for registering a comedi PCMCIA driver
> + * @__comedi_driver: comedi_driver struct
> + * @__pcmcia_driver: pcmcia_driver struct
> + *
> + * Helper macro for comedi PCMCIA drivers which do not do anything special
> + * in module init/exit. This eliminates a lot of boilerplate. Each
> + * module may only use this macro once, and calling it replaces
> + * module_init() and module_exit()
> + */
> +#define module_comedi_pcmcia_driver(__comedi_driver, __pcmcia_driver) \
> +	module_driver(__comedi_driver, comedi_pcmcia_driver_register, \
> +			comedi_pcmcia_driver_unregister, &(__pcmcia_driver))
> +
>  struct usb_driver;
>  
>  int comedi_usb_driver_register(struct comedi_driver *, struct usb_driver *);
> diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
> index 50cf498..17a9e35 100644
> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -24,6 +24,9 @@
>  #include <linux/device.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
> +#include <pcmcia/cistpl.h>
> +#include <pcmcia/cisreg.h>
> +#include <pcmcia/ds.h>
>  #include <linux/usb.h>
>  #include <linux/errno.h>
>  #include <linux/kconfig.h>
> @@ -958,6 +961,37 @@ void comedi_pci_driver_unregister(struct comedi_driver *comedi_driver,
>  }
>  EXPORT_SYMBOL_GPL(comedi_pci_driver_unregister);
>  
> +int comedi_pcmcia_driver_register(struct comedi_driver *comedi_driver,
> +		struct pcmcia_driver *pcmcia_driver)
> +{
> +	int ret;
> +
> +	ret = comedi_driver_register(comedi_driver);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* FIXME: Remove this test after auditing all comedi pci drivers */
> +	if (!pcmcia_driver->name)
> +		pcmcia_driver->name = comedi_driver->driver_name;

This chunk should not be here. All the comedi pcmcia drivers have the 'name'
field properly initialized.

> +
> +	ret = pcmcia_register_driver(pcmcia_driver);
> +	if (ret < 0) {
> +		comedi_driver_unregister(comedi_driver);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(comedi_pcmcia_driver_register);
> +
> +void comedi_pcmcia_driver_unregister(struct comedi_driver *comedi_driver,
> +		struct pcmcia_driver *pcmcia_driver)
> +{
> +	pcmcia_unregister_driver(pcmcia_driver);
> +	comedi_driver_unregister(comedi_driver);
> +}
> +EXPORT_SYMBOL_GPL(comedi_pcmcia_driver_unregister);
> +
>  #if IS_ENABLED(CONFIG_USB)
>  
>  int comedi_usb_driver_register(struct comedi_driver *comedi_driver,

Regards,
Hartley

