Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3HUXpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:45:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:32191 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab3HUXpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:45:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,930,1367996400"; 
   d="scan'208";a="384625478"
From: "Jiang, Dave" <dave.jiang@intel.com>
To: "Mason, Jon" <jon.mason@intel.com>
CC: Dan Williams <djbw@fb.com>, "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ioat: PM Support
Thread-Topic: [PATCH] ioat: PM Support
Thread-Index: AQHOnsgyPFyt3F2jEEKij2DcBzQbv5mgyKOA
Date: Wed, 21 Aug 2013 23:44:52 +0000
Message-ID: <1377128691.27193.39.camel@djiang5-linux2.ch.intel.com>
References: <1377128574-19121-1-git-send-email-jon.mason@intel.com>
In-Reply-To: <1377128574-19121-1-git-send-email-jon.mason@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.2.105.54]
Content-Type: text/plain; charset="utf-8"
Content-ID: <658C3526F4A31243B19DD8E1AD577818@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7LNjFML026761

Acked-by: Dave Jiang <dave.jiang@intel.com>

On Wed, 2013-08-21 at 16:42 -0700, Jon Mason wrote:
> Add power management support in the IOAT driver.  Adding this feature
> resolves a known issue when attempting to suspend on systems with IOAT
> enabled.  On those systems, IOAT would experience a DMA channel error
> when attempting to resume due to the channels not being suspended
> properly.  Currently, all channels errors cause panics, thus bringing
> the system down.
> 
> Unfortunately, a hardware errata needs to be worked around on Xeon IOAT
> devices.  The channel cannot be suspended or reset if there are active
> XOR transactions.  To get around this, check to see if XOR is enabled on
> the channel and the channel has pending transactions.  If so, then grab
> the lock and wait for the queue to drain.  It might be more elegant to
> see if there are any XOR operations pending in the list, but by that
> time the queue will have drained anyway.
> 
> See BF509S in
> http://www.intel.com/content/dam/www/public/us/en/documents/specification-updates/xeon-c5500-c3500-spec-update.pdf
> See BT92 in
> http://www.intel.com/content/dam/www/public/us/en/documents/specification-updates/xeon-e5-family-spec-update.pdf
> 
> Tested-by: Gary Hade <garyhade@us.ibm.com>
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> ---
>  drivers/dma/ioat/dma.c    |    1 +
>  drivers/dma/ioat/dma.h    |    1 +
>  drivers/dma/ioat/dma_v2.c |    1 +
>  drivers/dma/ioat/dma_v3.c |   60 ++++++++++++++++++++++++++++++++++++++++++---
>  drivers/dma/ioat/pci.c    |   39 +++++++++++++++++++++++++++++
>  5 files changed, 99 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
> index 17a2393..44d5f3a 100644
> --- a/drivers/dma/ioat/dma.c
> +++ b/drivers/dma/ioat/dma.c
> @@ -1203,6 +1203,7 @@ int ioat1_dma_probe(struct ioatdma_device *device, int dca)
>  	device->self_test = ioat_dma_self_test;
>  	device->timer_fn = ioat1_timer_event;
>  	device->cleanup_fn = ioat1_cleanup_event;
> +	device->suspend = ioat_suspend;
>  	dma = &device->common;
>  	dma->device_prep_dma_memcpy = ioat1_dma_prep_memcpy;
>  	dma->device_issue_pending = ioat1_dma_memcpy_issue_pending;
> diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
> index 54fb7b9..1372c8e 100644
> --- a/drivers/dma/ioat/dma.h
> +++ b/drivers/dma/ioat/dma.h
> @@ -97,6 +97,7 @@ struct ioatdma_device {
>  	void (*cleanup_fn)(unsigned long data);
>  	void (*timer_fn)(unsigned long data);
>  	int (*self_test)(struct ioatdma_device *device);
> +	void (*suspend)(struct ioat_chan_common *chan);
>  };
>  
>  struct ioat_chan_common {
> diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
> index b925e1b..bd21dcb 100644
> --- a/drivers/dma/ioat/dma_v2.c
> +++ b/drivers/dma/ioat/dma_v2.c
> @@ -890,6 +890,7 @@ int ioat2_dma_probe(struct ioatdma_device *device, int dca)
>  	device->cleanup_fn = ioat2_cleanup_event;
>  	device->timer_fn = ioat2_timer_event;
>  	device->self_test = ioat_dma_self_test;
> +	device->suspend = ioat_suspend;
>  	dma = &device->common;
>  	dma->device_prep_dma_memcpy = ioat2_dma_prep_memcpy_lock;
>  	dma->device_issue_pending = ioat2_issue_pending;
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index a17ef21..2aaad1e 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -653,12 +653,63 @@ static void ioat3_cleanup_event(unsigned long data)
>  	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
>  }
>  
> +static inline void ioat3_suspend(struct ioat_chan_common *chan)
> +{
> +	struct pci_dev *pdev = to_pdev(chan);
> +	struct dma_device *dma = &chan->device->common;
> +	struct ioat2_dma_chan *ioat = container_of(chan, struct ioat2_dma_chan,
> +						   base);
> +
> +	/* Due to HW errata on Xeon, we must make sure to flush the device prior
> +	 * to suspend or reset of the device if there are any XOR operations
> +	 * pending.  Instead of inspecting the pending operations, just flush it
> +	 * if the channel supports XOR.
> +	 */
> +	if (is_xeon_cb32(pdev) && dma_has_cap(DMA_XOR, dma->cap_mask) &&
> +	    is_ioat_active(ioat_chansts(chan))) {
> +		unsigned long end = jiffies + msecs_to_jiffies(100);
> +
> +		spin_lock_bh(&ioat->prep_lock);
> +		while (is_ioat_active(ioat_chansts(chan))) {
> +			if (time_after(jiffies, end)) {
> +				dev_err(&pdev->dev, "Timeout trying to suspend");
> +				break;
> +			}
> +			cpu_relax();
> +		}
> +		ioat_suspend(chan);
> +		spin_unlock_bh(&ioat->prep_lock);
> +	} else
> +		ioat_suspend(chan);
> +}
> +
> +static int ioat3_quiesce(struct ioat_chan_common *chan, unsigned long tmo)
> +{
> +	unsigned long end = jiffies + tmo;
> +	int err = 0;
> +	u32 status;
> +
> +	status = ioat_chansts(chan);
> +	if (is_ioat_active(status) || is_ioat_idle(status))
> +		ioat3_suspend(chan);
> +	while (is_ioat_active(status) || is_ioat_idle(status)) {
> +		if (tmo && time_after(jiffies, end)) {
> +			err = -ETIMEDOUT;
> +			break;
> +		}
> +		status = ioat_chansts(chan);
> +		cpu_relax();
> +	}
> +
> +	return err;
> +}
> +
>  static void ioat3_restart_channel(struct ioat2_dma_chan *ioat)
>  {
>  	struct ioat_chan_common *chan = &ioat->base;
>  	u64 phys_complete;
>  
> -	ioat2_quiesce(chan, 0);
> +	ioat3_quiesce(chan, 0);
>  	if (ioat3_cleanup_preamble(chan, &phys_complete))
>  		__cleanup(ioat, phys_complete);
>  
> @@ -1793,7 +1844,7 @@ static int ioat3_reset_hw(struct ioat_chan_common *chan)
>  	u16 dev_id;
>  	int err;
>  
> -	ioat2_quiesce(chan, msecs_to_jiffies(100));
> +	ioat3_quiesce(chan, msecs_to_jiffies(100));
>  
>  	chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
>  	writel(chanerr, chan->reg_base + IOAT_CHANERR_OFFSET);
> @@ -1873,6 +1924,7 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
>  	device->reset_hw = ioat3_reset_hw;
>  	device->self_test = ioat3_dma_self_test;
>  	device->intr_quirk = ioat3_intr_quirk;
> +	device->suspend = ioat3_suspend;
>  	dma = &device->common;
>  	dma->device_prep_dma_memcpy = ioat2_dma_prep_memcpy_lock;
>  	dma->device_issue_pending = ioat2_issue_pending;
> @@ -1891,8 +1943,10 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
>  		device->cap &= ~(IOAT_CAP_XOR | IOAT_CAP_PQ | IOAT_CAP_RAID16SS);
>  
>  	/* dca is incompatible with raid operations */
> -	if (dca_en && (device->cap & (IOAT_CAP_XOR|IOAT_CAP_PQ)))
> +	if (dca_en && (device->cap & (IOAT_CAP_XOR|IOAT_CAP_PQ))) {
> +		pr_info("%s: DCA enabled, disabling XOR\n", __func__);
>  		device->cap &= ~(IOAT_CAP_XOR|IOAT_CAP_PQ);
> +	}
>  
>  	if (device->cap & IOAT_CAP_XOR) {
>  		is_raid_device = true;
> diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
> index 2c8d560..136b10a 100644
> --- a/drivers/dma/ioat/pci.c
> +++ b/drivers/dma/ioat/pci.c
> @@ -126,11 +126,50 @@ struct kmem_cache *ioat2_cache;
>  
>  #define DRV_NAME "ioatdma"
>  
> +#ifdef CONFIG_PM
> +static int ioat_pm_suspend(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct ioatdma_device *device = pci_get_drvdata(pdev);
> +	struct dma_device *dma = &device->common;
> +	struct dma_chan *chan;
> +
> +	list_for_each_entry(chan, &dma->channels, device_node) {
> +		struct ioat_dma_chan *ioat = to_ioat_chan(chan);
> +
> +		dev_info(dev, "Suspending Chan %d\n", chan->chan_id);
> +		if (device->suspend)
> +			device->suspend(&ioat->base);
> +	}
> +
> +	return 0;
> +}
> +
> +static int ioat_pm_resume(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct ioatdma_device *device = pci_get_drvdata(pdev);
> +	struct dma_device *dma = &device->common;
> +	struct dma_chan *chan;
> +
> +	list_for_each_entry(chan, &dma->channels, device_node) {
> +		struct ioat_dma_chan *ioat = to_ioat_chan(chan);
> +		dev_info(dev, "Starting Chan %d\n", chan->chan_id);
> +		ioat_start(&ioat->base);
> +	}
> +
> +	return 0;
> +}
> +#endif
> +
> +SIMPLE_DEV_PM_OPS(ioat_pm_ops, ioat_pm_suspend, ioat_pm_resume);
> +
>  static struct pci_driver ioat_pci_driver = {
>  	.name		= DRV_NAME,
>  	.id_table	= ioat_pci_tbl,
>  	.probe		= ioat_pci_probe,
>  	.remove		= ioat_remove,
> +	.driver.pm	= &ioat_pm_ops,
>  };
>  
>  static struct ioatdma_device *

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
