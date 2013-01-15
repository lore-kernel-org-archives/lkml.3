Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3AOKgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:36:52 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:58723 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab3AOKgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:36:51 -0500
Message-ID: <50F5313C.8040506@mev.co.uk>
Date: Tue, 15 Jan 2013 10:36:44 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8 v2] staging/comedi: Add macro for registering a comedi
 PCMCIA driver
References: <ADE657CA350FB648AAC2C43247A983F00207A6CBADD1@AUSP01VMBX24.collaborationhost.net> <1358197255-17542-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1358197255-17542-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-14 21:00, Peter Huewe wrote:
> This patch introduces a new macro 'module_comedi_pcmcia_driver'
> for comedi PCMCIA drivers which do not do anything special in module
> init/exit. This eliminates a lot of boilerplate.
>
> Adapted from 'module_comedi_pci_driver'
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> v2:
> Removed unnecessary stuff. Thanks Hartley&Ian

This looks (and builds with and without PCMCIA support) fine.  Thanks!

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
(all 8 patches)

>
>   drivers/staging/comedi/comedidev.h |   21 +++++++++++++++++++++
>   drivers/staging/comedi/drivers.c   |   32 ++++++++++++++++++++++++++++++++
>   2 files changed, 53 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 34a85d3..d0248ed 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -316,6 +316,27 @@ void comedi_pci_driver_unregister(struct comedi_driver *, struct pci_driver *);
>   	module_driver(__comedi_driver, comedi_pci_driver_register, \
>   			comedi_pci_driver_unregister, &(__pci_driver))
>
> +struct pcmcia_driver;
> +
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
>   struct usb_driver;
>
>   int comedi_usb_driver_register(struct comedi_driver *, struct usb_driver *);
> diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
> index b67a0c9..bd9c678 100644
> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -24,6 +24,8 @@
>   #include <linux/device.h>
>   #include <linux/module.h>
>   #include <linux/pci.h>
> +#include <pcmcia/cistpl.h>
> +#include <pcmcia/ds.h>
>   #include <linux/usb.h>
>   #include <linux/errno.h>
>   #include <linux/kconfig.h>
> @@ -954,6 +956,36 @@ void comedi_pci_driver_unregister(struct comedi_driver *comedi_driver,
>   }
>   EXPORT_SYMBOL_GPL(comedi_pci_driver_unregister);
>
> +#if IS_ENABLED(CONFIG_PCMCIA)
> +int comedi_pcmcia_driver_register(struct comedi_driver *comedi_driver,
> +		struct pcmcia_driver *pcmcia_driver)
> +{
> +	int ret;
> +
> +	ret = comedi_driver_register(comedi_driver);
> +	if (ret < 0)
> +		return ret;
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
> +#endif
> +
>   #if IS_ENABLED(CONFIG_USB)
>
>   int comedi_usb_driver_register(struct comedi_driver *comedi_driver,
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
