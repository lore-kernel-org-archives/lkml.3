Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaEUO5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:57:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:28353 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbaEUO5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:57:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,880,1392192000"; 
   d="scan'208";a="435054125"
Message-ID: <1400684219.13930.37.camel@rzhang1-toshiba>
Subject: Re: [PATCH V6 07/11] ACPI: introduce dummy lpss scan handler
From: Zhang Rui <rui.zhang@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Date: Wed, 21 May 2014 22:56:59 +0800
In-Reply-To: <20140521084807.GQ1651@lahna.fi.intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
	 <1400136256-2218-8-git-send-email-rui.zhang@intel.com>
	 <20140521084807.GQ1651@lahna.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 三, 2014-05-21 at 11:48 +0300, Mika Westerberg wrote:
> On Thu, May 15, 2014 at 02:44:12PM +0800, Zhang Rui wrote:
> > The new ACPI device enumeration mechanism, which will be introduced
> > in a later patch, will enumerate the _HID devices w/o any scan
> > handler attached to platform bus.
> > This means that, for the devices that are attached to a configurable
> > scan handler, we should make sure no platform devices would be
> > created for them even if the scan handler is compiled out.
> > 
> > Fix this problem for lpss devices by introducing a dummy
> > lpss scan handler in this patch.
> > 
> > Plus, if lpt_clk_init() fails, we need this dummy scan handler as well.
> > 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> >  drivers/acpi/Makefile    |  2 +-
> >  drivers/acpi/acpi_lpss.c | 69 ++++++++++++++++++++++++++++++++++--------------
> >  drivers/acpi/internal.h  |  4 ---
> >  3 files changed, 50 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> > index 171efc2..605eff7 100644
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
> 
> This whole #ifndef dance is ugly as hell. Can't we do any better?
> 
> > +	acpi_scan_add_handler(&lpss_dummy_handler);
> 
> Also I don't like these "dummy" things at all. Can't we make the code
> work so that those are not needed?
> 
well, I'm not sure how to make it work w/o dummy handlers.
Do you have any idea?

Oh, wait, as the .attach() callback for all the dummy handler just do
one thing, aka, return 1 to attach the device, I think maybe we can have
an acpi_scan_handler_dummy_attach() which does the same thing in
drivers/acpi/scan.c, and invoke it for scan handlers w/o .attach().
In this way, we do not need a dummy handler, but the #ifdef thing is
still needed, to set/clear the .attach() callback.
I will do a double check if this proposal sounds okay to you.

thanks,
rui

> >  }
> > diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> > index 4a9e999..bc7d102 100644
> > --- a/drivers/acpi/internal.h
> > +++ b/drivers/acpi/internal.h
> > @@ -65,11 +65,7 @@ int acpi_debugfs_init(void);
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
> > -- 
> > 1.8.3.2
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


