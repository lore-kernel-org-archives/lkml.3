Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab3FTMf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:35:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57064 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3FTMf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:35:56 -0400
Message-ID: <51C2F70A.3040708@ti.com>
Date: Thu, 20 Jun 2013 15:35:22 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <stern@rowland.harvard.edu>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
References: <1371650753-11452-1-git-send-email-rogerq@ti.com> <1371650753-11452-5-git-send-email-rogerq@ti.com> <20130620121151.GD9817@arwen.pp.htv.fi>
In-Reply-To: <20130620121151.GD9817@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 03:11 PM, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Jun 19, 2013 at 05:05:51PM +0300, Roger Quadros wrote:
>> Runtime suspend the controller during bus suspend and resume it
>> during bus resume. This will ensure that the USB Host power domain
>> enters lower power state and does not prevent the SoC from
>> endering deeper sleep states.
>>
>> Remote wakeup will come up as an interrupt while the controller
>> is suspended, so tackle it carefully using a workqueue.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  drivers/usb/host/ehci-omap.c |   82 ++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 82 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
>> index 16d7150..91f14f1 100644
>> --- a/drivers/usb/host/ehci-omap.c
>> +++ b/drivers/usb/host/ehci-omap.c
>> @@ -44,6 +44,8 @@
>>  #include <linux/usb/hcd.h>
>>  #include <linux/of.h>
>>  #include <linux/dma-mapping.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/spinlock.h>
>>  
>>  #include "ehci.h"
>>  
>> @@ -69,6 +71,7 @@ static const char hcd_name[] = "ehci-omap";
>>  struct omap_hcd {
>>  	struct usb_phy *phy[OMAP3_HS_USB_PORTS]; /* one PHY for each port */
>>  	int nports;
>> +	struct work_struct work;
>>  };
>>  
>>  static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
>> @@ -81,6 +84,76 @@ static inline u32 ehci_read(void __iomem *base, u32 reg)
>>  	return __raw_readl(base + reg);
>>  }
>>  
>> +static void omap_ehci_work(struct work_struct *work)
>> +{
>> +	struct omap_hcd *omap = container_of(work, struct omap_hcd, work);
>> +	struct ehci_hcd *ehci = container_of((void *) omap,
>> +						struct ehci_hcd, priv);
>> +	struct usb_hcd *hcd = ehci_to_hcd(ehci);
>> +	struct device *dev = hcd->self.controller;
>> +
>> +	pm_runtime_get_sync(dev);
>> +	enable_irq(hcd->irq);
>> +	/*
>> +	 * enable_irq() should preempt us with a pending IRQ
>> +	 * so we can be sure that IRQ handler completes before
>> +	 * we call pm_runtime_put_sync()
>> +	 */
>> +	pm_runtime_put_sync(dev);
>> +}
>> +
>> +static irqreturn_t omap_ehci_irq(struct usb_hcd *hcd)
>> +{
>> +	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
>> +	struct device *dev = hcd->self.controller;
>> +	irqreturn_t ret;
>> +
>> +	if (pm_runtime_suspended(dev)) {
>> +		schedule_work(&omap->work);
>> +		disable_irq_nosync(hcd->irq);
>> +		ret = IRQ_HANDLED;
> 
> looks like this could be done as:
> 
> if (pm_runtime_suspended(dev)) {
> 	pm_runtime_get(dev);
> 	omap->flags |= OMAP_EHCI_IRQ_PENDING;
> 	disable_irq_nosync(hcd->irq);
> 	ret = IRQ_HANDLED;
> }
> 
> then on your ->runtime_resume():
> 
> runtime_resume(dev)
> {
> 	...
> 
> 	if (omap->flags & OMAP_EHCI_IRQ_PENDING) {
> 		process_pending_irqs(omap);

OK, thanks. 

But I'm not sure if the generic ehci_irq handler is able to
run in a process context. Maybe if we replace spin_lock(&ehci->lock);
with spin_lock_irqsave() there, it will work.

Alan is this a doable option?

> 		omap->flags &= ~OMAP_EHCI_IRQ_PENDING;
> 	}
> 
> 	return 0;
> }
> 
> or something similar
> 

cheers,
-roger
