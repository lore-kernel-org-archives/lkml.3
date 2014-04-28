Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaD1B5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:57:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:62664 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbaD1B5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:57:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,940,1389772800"; 
   d="scan'208";a="530655066"
Message-ID: <1398650265.2443.13.camel@rzhang1-mobl4>
Subject: Re: [PATCH V5 08/12] ACPI: introduce dummy lpss scan handler
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Date: Mon, 28 Apr 2014 09:57:45 +0800
In-Reply-To: <27436911.aPCCdOpgZ6@vostro.rjw.lan>
References: <1396886819-2637-1-git-send-email-rui.zhang@intel.com>
	 <1396886819-2637-9-git-send-email-rui.zhang@intel.com>
	 <27436911.aPCCdOpgZ6@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 00:23 +0200, Rafael J. Wysocki wrote:
> On Tuesday, April 08, 2014 12:06:55 AM Zhang Rui wrote:
> > When the lpss scan handler is compiled out, aka, CONFIG_X86_INTEL_LPSS
> > is cleared, those ACPI device objects will be recgonized as regular
> > _HID devices, and a platform device would be created for each of them.
> > This is wrong because the platform drivers for those devices would
> > be loaded, but with broken behavior.
> > 
> > In order to fix this, a dummy lpss scan handler is introduced
> > to prevent those platform devices from being created.
> > Plus, if lpt_clk_init() fails, we need this dummy scan handler as well.
> > 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> 
> All of the patches adding dummy scan handlers should go before [7/12] I think.
> 
agreed, will do it in next version.

thanks,
rui
> > ---
> >  drivers/acpi/Makefile    |    2 +-
> >  drivers/acpi/acpi_lpss.c |   69 ++++++++++++++++++++++++++++++++--------------
> >  drivers/acpi/internal.h  |    4 ---
> >  3 files changed, 50 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> > index 9a43893..2173e30 100644
> > --- a/drivers/acpi/Makefile
> > +++ b/drivers/acpi/Makefile
> > @@ -39,7 +39,7 @@ acpi-y				+= processor_core.o
> >  acpi-y				+= ec.o
> >  acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
> >  acpi-y				+= pci_root.o pci_link.o pci_irq.o
> > -acpi-$(CONFIG_X86_INTEL_LPSS)	+= acpi_lpss.o
> > +acpi-y				+= acpi_lpss.o
> >  acpi-y				+= acpi_platform.o
> >  acpi-y				+= acpi_pnp.o
> >  acpi-y				+= power.o
> > diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> > index 69e29f4..965428f 100644
> > --- a/drivers/acpi/acpi_lpss.c
> > +++ b/drivers/acpi/acpi_lpss.c
> > @@ -24,6 +24,8 @@
> >  
> >  ACPI_MODULE_NAME("acpi_lpss");
> >  
> > +#ifdef CONFIG_X86_INTEL_LPSS
> > +
> >  #define LPSS_CLK_SIZE	0x04
> >  #define LPSS_LTR_SIZE	0x18
> >  
> > @@ -159,40 +161,50 @@ static struct lpss_device_desc byt_i2c_dev_desc = {
> >  	.shared_clock = &i2c_clock,
> >  };
> >  
> > +#define LPSS_PTR(desc) ((unsigned long)&desc)
> > +
> > +#else
> > +
> > +#define LPSS_PTR(desc) 0
> > +
> > +#endif
> > +
> >  static const struct acpi_device_id acpi_lpss_device_ids[] = {
> >  	/* Generic LPSS devices */
> > -	{ "INTL9C60", (unsigned long)&lpss_dma_desc },
> > +	{ "INTL9C60", LPSS_PTR(lpss_dma_desc) },
> >  
> >  	/* Lynxpoint LPSS devices */
> > -	{ "INT33C0", (unsigned long)&lpt_dev_desc },
> > -	{ "INT33C1", (unsigned long)&lpt_dev_desc },
> > -	{ "INT33C2", (unsigned long)&lpt_dev_desc },
> > -	{ "INT33C3", (unsigned long)&lpt_dev_desc },
> > -	{ "INT33C4", (unsigned long)&lpt_uart_dev_desc },
> > -	{ "INT33C5", (unsigned long)&lpt_uart_dev_desc },
> > -	{ "INT33C6", (unsigned long)&lpt_sdio_dev_desc },
> > +	{ "INT33C0", LPSS_PTR(lpt_dev_desc) },
> > +	{ "INT33C1", LPSS_PTR(lpt_dev_desc) },
> > +	{ "INT33C2", LPSS_PTR(lpt_dev_desc) },
> > +	{ "INT33C3", LPSS_PTR(lpt_dev_desc) },
> > +	{ "INT33C4", LPSS_PTR(lpt_uart_dev_desc) },
> > +	{ "INT33C5", LPSS_PTR(lpt_uart_dev_desc) },
> > +	{ "INT33C6", LPSS_PTR(lpt_sdio_dev_desc) },
> >  	{ "INT33C7", },
> >  
> >  	/* BayTrail LPSS devices */
> > -	{ "80860F09", (unsigned long)&byt_pwm_dev_desc },
> > -	{ "80860F0A", (unsigned long)&byt_uart_dev_desc },
> > -	{ "80860F0E", (unsigned long)&byt_spi_dev_desc },
> > -	{ "80860F14", (unsigned long)&byt_sdio_dev_desc },
> > -	{ "80860F41", (unsigned long)&byt_i2c_dev_desc },
> > +	{ "80860F09", LPSS_PTR(byt_pwm_dev_desc) },
> > +	{ "80860F0A", LPSS_PTR(byt_uart_dev_desc) },
> > +	{ "80860F0E", LPSS_PTR(byt_spi_dev_desc) },
> > +	{ "80860F14", LPSS_PTR(byt_sdio_dev_desc) },
> > +	{ "80860F41", LPSS_PTR(byt_i2c_dev_desc) },
> >  	{ "INT33B2", },
> >  
> > -	{ "INT3430", (unsigned long)&lpt_dev_desc },
> > -	{ "INT3431", (unsigned long)&lpt_dev_desc },
> > -	{ "INT3432", (unsigned long)&lpt_dev_desc },
> > -	{ "INT3433", (unsigned long)&lpt_dev_desc },
> > -	{ "INT3434", (unsigned long)&lpt_uart_dev_desc },
> > -	{ "INT3435", (unsigned long)&lpt_uart_dev_desc },
> > -	{ "INT3436", (unsigned long)&lpt_sdio_dev_desc },
> > +	{ "INT3430", LPSS_PTR(lpt_dev_desc) },
> > +	{ "INT3431", LPSS_PTR(lpt_dev_desc) },
> > +	{ "INT3432", LPSS_PTR(lpt_dev_desc) },
> > +	{ "INT3433", LPSS_PTR(lpt_dev_desc) },
> > +	{ "INT3434", LPSS_PTR(lpt_uart_dev_desc) },
> > +	{ "INT3435", LPSS_PTR(lpt_uart_dev_desc) },
> > +	{ "INT3436", LPSS_PTR(lpt_sdio_dev_desc) },
> >  	{ "INT3437", },
> >  
> >  	{ }
> >  };
> >  
> > +#ifdef CONFIG_X86_INTEL_LPSS
> > +
> >  static int is_memory(struct acpi_resource *res, void *not_used)
> >  {
> >  	struct resource r;
> > @@ -511,10 +523,27 @@ static struct acpi_scan_handler lpss_handler = {
> >  	.unbind = acpi_lpss_unbind,
> >  };
> >  
> > +#endif /* CONFIG_X86_INTEL_LPSS */
> > +
> > +static int acpi_lpss_dummy_attach(struct acpi_device *adev,
> > +				const struct acpi_device_id *id)
> > +{
> > +	return 1;
> > +}
> > +
> > +static struct acpi_scan_handler lpss_dummy_handler = {
> > +	.ids = acpi_lpss_device_ids,
> > +	.attach = acpi_lpss_dummy_attach,
> > +};
> > +
> >  void __init acpi_lpss_init(void)
> >  {
> > +#ifdef CONFIG_X86_INTEL_LPSS
> >  	if (!lpt_clk_init()) {
> >  		bus_register_notifier(&platform_bus_type, &acpi_lpss_nb);
> >  		acpi_scan_add_handler(&lpss_handler);
> > +		return;
> >  	}
> > +#endif
> > +	acpi_scan_add_handler(&lpss_dummy_handler);
> >  }
> > diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> > index 3a12866..40ce814 100644
> > --- a/drivers/acpi/internal.h
> > +++ b/drivers/acpi/internal.h
> > @@ -73,11 +73,7 @@ int acpi_debugfs_init(void);
> >  #else
> >  static inline void acpi_debugfs_init(void) { return; }
> >  #endif
> > -#ifdef CONFIG_X86_INTEL_LPSS
> >  void acpi_lpss_init(void);
> > -#else
> > -static inline void acpi_lpss_init(void) {}
> > -#endif
> >  
> >  acpi_status acpi_hotplug_schedule(struct acpi_device *adev, u32 src);
> >  bool acpi_queue_hotplug_work(struct work_struct *work);
> > 
> 


