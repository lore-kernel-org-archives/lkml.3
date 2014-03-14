Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaCNL3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:29:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:6631 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaCNL27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:28:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,654,1389772800"; 
   d="scan'208";a="472275280"
Message-ID: <1394796535.28803.250.camel@smile.fi.intel.com>
Subject: Re: [PATCH v2] dma: dw: Add suspend and resume handling for PCI
 mode DW_DMAC.
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lim Lee Booi <lee.booi.lim@intel.com>
Date: Fri, 14 Mar 2014 13:28:55 +0200
In-Reply-To: <1394820159-562-1-git-send-email-chiau.ee.chew@intel.com>
References: <1394820159-562-1-git-send-email-chiau.ee.chew@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-15 at 02:02 +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> This is to disable/enable DW_DMAC hw during late suspend/early resume.
> Since DMA is providing service to other clients (eg: SPI, HSUART),
> we need to ensure DMA suspends after the clients and resume
> before the clients are active.

Thanks for an update!

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

P.S. It seems a material is for v3.16?

> 
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> ---
>  v2 changelog:
>  * Change suspend_noirq and resume_noirq callback to suspend_late
>    and resume_early.
> 
>  drivers/dma/dw/pci.c |   33 +++++++++++++++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c
> index 755cc6b..fec59f1 100644
> --- a/drivers/dma/dw/pci.c
> +++ b/drivers/dma/dw/pci.c
> @@ -75,6 +75,36 @@ static void dw_pci_remove(struct pci_dev *pdev)
>  		dev_warn(&pdev->dev, "can't remove device properly: %d\n", ret);
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
> +
> +static int dw_pci_suspend_late(struct device *dev)
> +{
> +	struct pci_dev *pci = to_pci_dev(dev);
> +	struct dw_dma_chip *chip = pci_get_drvdata(pci);
> +
> +	return dw_dma_suspend(chip);
> +};
> +
> +static int dw_pci_resume_early(struct device *dev)
> +{
> +	struct pci_dev *pci = to_pci_dev(dev);
> +	struct dw_dma_chip *chip = pci_get_drvdata(pci);
> +
> +	return dw_dma_resume(chip);
> +};
> +
> +#else /* !CONFIG_PM_SLEEP */
> +
> +#define dw_pci_suspend_late	NULL
> +#define dw_pci_resume_early	NULL
> +
> +#endif /* !CONFIG_PM_SLEEP */
> +
> +static const struct dev_pm_ops dw_pci_dev_pm_ops = {
> +	.suspend_late = dw_pci_suspend_late,
> +	.resume_early = dw_pci_resume_early,
> +};
> +
>  static DEFINE_PCI_DEVICE_TABLE(dw_pci_id_table) = {
>  	/* Medfield */
>  	{ PCI_VDEVICE(INTEL, 0x0827), (kernel_ulong_t)&dw_pci_pdata },
> @@ -95,6 +125,9 @@ static struct pci_driver dw_pci_driver = {
>  	.id_table	= dw_pci_id_table,
>  	.probe		= dw_pci_probe,
>  	.remove		= dw_pci_remove,
> +	.driver	= {
> +		.pm	= &dw_pci_dev_pm_ops,
> +	},
>  };
>  
>  module_pci_driver(dw_pci_driver);


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

