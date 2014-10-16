Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbaJPPZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:25:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbaJPPZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:25:21 -0400
Message-ID: <1413473093.2985.15.camel@deneb.redhat.com>
Subject: Re: [PATCH 42/44] efi: Register poweroff handler with kernel
 poweroff handler
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Date: Thu, 16 Oct 2014 11:24:53 -0400
In-Reply-To: <20141016145927.GI14343@console-pimps.org>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
	 <1412659726-29957-43-git-send-email-linux@roeck-us.net>
	 <20141016145927.GI14343@console-pimps.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 15:59 +0100, Matt Fleming wrote:
> On Mon, 06 Oct, at 10:28:44PM, Guenter Roeck wrote:
> > Register with kernel poweroff handler instead of setting pm_power_off
> > directly. Register with low priority value of 64 since the efi code
> > states that this is a poweroff handler of last resort.
> > 
> > Cc: Matt Fleming <matt.fleming@intel.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  drivers/firmware/efi/reboot.c | 23 +++++++++++++++++++----
> >  1 file changed, 19 insertions(+), 4 deletions(-)
>  
> Looks OK to me. Mark?

Me too.

Acked-by: Mark Salter <msalter@redhat.com>

> 
> > diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
> > index 9c59d1c..c082439 100644
> > --- a/drivers/firmware/efi/reboot.c
> > +++ b/drivers/firmware/efi/reboot.c
> > @@ -3,6 +3,8 @@
> >   * Copyright (c) 2014 Red Hat, Inc., Mark Salter <msalter@redhat.com>
> >   */
> >  #include <linux/efi.h>
> > +#include <linux/notifier.h>
> > +#include <linux/pm.h>
> >  #include <linux/reboot.h>
> >  
> >  int efi_reboot_quirk_mode = -1;
> > @@ -38,19 +40,32 @@ bool __weak efi_poweroff_required(void)
> >  	return false;
> >  }
> >  
> > -static void efi_power_off(void)
> > +static int efi_power_off(struct notifier_block *this,
> > +			 unsigned long unused1, void *unused2)
> >  {
> >  	efi.reset_system(EFI_RESET_SHUTDOWN, EFI_SUCCESS, 0, NULL);
> > +
> > +	return NOTIFY_DONE;
> >  }
> >  
> > +static struct notifier_block efi_poweroff_nb = {
> > +	.notifier_call = efi_power_off,
> > +	.priority = 64,
> > +};
> > +
> >  static int __init efi_shutdown_init(void)
> >  {
> > +	int ret = 0;
> > +
> >  	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> >  		return -ENODEV;
> >  
> > -	if (efi_poweroff_required())
> > -		pm_power_off = efi_power_off;
> > +	if (efi_poweroff_required()) {
> > +		ret = register_poweroff_handler(&efi_poweroff_nb);
> > +		if (ret)
> > +			pr_err("efi: Failed to register poweroff handler\n");
> > +	}
> >  
> > -	return 0;
> > +	return ret;
> >  }
> >  late_initcall(efi_shutdown_init);
> > -- 
> > 1.9.1
> 
> 


