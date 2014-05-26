Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaEZLgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:36:38 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57192 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752464AbaEZLgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:36:36 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        matthew.garrett@nebula.com, rafael.j.wysocki@intel.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH V7 08/11] ACPI: always register memory hotplug scan handler even if CONFIG_X86_INTEL_LPSS is cleared
Date: Mon, 26 May 2014 13:53:39 +0200
Message-ID: <4177604.8JWRhYqtaS@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140526105636.GC1765@lahna.fi.intel.com>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com> <1400781753-2682-9-git-send-email-rui.zhang@intel.com> <20140526105636.GC1765@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 26, 2014 01:56:36 PM Mika Westerberg wrote:
> On Fri, May 23, 2014 at 02:02:30AM +0800, Zhang Rui wrote:
> > The new ACPI device enumeration mechanism, which will be introduced
> > in a later patch, will enumerate the _HID devices w/o any scan
> > handler attached to platform bus.
> > This means that, for the devices that are attached to a configurable
> > scan handler, we should make sure no platform devices would be
> > created for them even if the scan handler is compiled out.
> > 
> > Fix this problem for lpss devices by always register the lpss scan handler,
> > but with meaningful callbacks only when CONFIG_X86_INTEL_LPSS is set.
> > 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> >  drivers/acpi/Makefile    |  2 +-
> >  drivers/acpi/acpi_lpss.c | 63 ++++++++++++++++++++++++++++++------------------
> >  drivers/acpi/internal.h  |  4 ---
> >  3 files changed, 41 insertions(+), 28 deletions(-)
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
> > index 69e29f4..bb5b3f2 100644
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
> > @@ -503,18 +515,23 @@ static void acpi_lpss_unbind(struct device *dev)
> >  {
> >  	dev->power.set_latency_tolerance = NULL;
> >  }
> > +#endif /* CONFIG_X86_INTEL_LPSS */
> >  
> >  static struct acpi_scan_handler lpss_handler = {
> >  	.ids = acpi_lpss_device_ids,
> > -	.attach = acpi_lpss_create_device,
> > -	.bind = acpi_lpss_bind,
> > -	.unbind = acpi_lpss_unbind,
> >  };
> >  
> >  void __init acpi_lpss_init(void)
> >  {
> > +#ifdef CONFIG_X86_INTEL_LPSS
> >  	if (!lpt_clk_init()) {
> >  		bus_register_notifier(&platform_bus_type, &acpi_lpss_nb);
> > +		lpss_handler.attach = acpi_lpss_create_device;
> > +		lpss_handler.bind = acpi_lpss_bind;
> > +		lpss_handler.unbind = acpi_lpss_unbind;
> >  		acpi_scan_add_handler(&lpss_handler);
> > +		return;
> >  	}
> > +#endif
> > +	acpi_scan_add_handler(&lpss_handler);
> 
> I'm wondering whether it is worth the ugliness to get platform bus
> enumeration the default?
> 
> Since you already have the PNP whitelist, can't we just use that for PNP
> and keep these files as they are? In other words, don't make any kind of
> physical device by default and let the scan handlers to decide.

Well, that's tempting, but then we'd get one more whitelist pretty much without
any benefit, because we'd be still going to have the list in acpi_platform.c.

The purpose of the whole exercise is not to prevent PNP devices from being
created by default (which admittedly is a nice side effect), but to get rid
of the white list in acpi_platform.c - and in particular, to avoid the
necessity to add every ACPI-enumerated platform device to that list in the
future.

Rafael

