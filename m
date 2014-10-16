Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaJPMNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:13:47 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:59409 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaJPMNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:13:43 -0400
Date: Thu, 16 Oct 2014 14:13:20 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Yijing Wang <wangyijing@huawei.com>
cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xinwei Hu <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-arch@vger.kernel.org,
        arnab.basu@freescale.com, Bharat.Bhushan@freescale.com, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org, Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Liviu Dudau <liviu@dudau.co.uk>
Subject: Re: [PATCH v3 22/27] s390/MSI: Use MSI chip framework to configure
 MSI/MSI-X irq
In-Reply-To: <1413342435-7876-23-git-send-email-wangyijing@huawei.com>
Message-ID: <alpine.LFD.2.11.1410161411340.1575@denkbrett>
References: <1413342435-7876-1-git-send-email-wangyijing@huawei.com> <1413342435-7876-23-git-send-email-wangyijing@huawei.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101612-0025-0000-0000-000001EA0EFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014, Yijing Wang wrote:
> Use MSI chip framework instead of arch MSI functions to configure
> MSI/MSI-X irq. So we can manage MSI/MSI-X irq in a unified framework.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
> Hi Sebastian,
>    I dropped the Acked-by , because this version has a
> lot changes compared to last. So, I guess you may want to check it again.

I did and I agree with that one too.

Regards,
Sebastian

> ---
>  arch/s390/include/asm/pci.h |    9 +++++++++
>  arch/s390/pci/pci.c         |   12 ++++++++++--
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index c030900..4d41f08 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -88,6 +88,8 @@ struct zpci_dev {
>  	u32 uid;			/* user defined id */
>  	u8 util_str[CLP_UTIL_STR_LEN];	/* utility string */
> 
> +	struct msi_chip *msi_chip;
> +
>  	/* IRQ stuff */
>  	u64		msi_addr;	/* MSI address */
>  	struct airq_iv *aibv;		/* adapter interrupt bit vector */
> @@ -121,6 +123,13 @@ struct zpci_dev {
>  	struct dentry	*debugfs_perf;
>  };
> 
> +static inline struct msi_chip *pci_msi_chip(struct pci_bus *bus)
> +{
> +	struct zpci_dev *zpci = bus->sysdata;
> +
> +	return zpci->msi_chip;
> +}
> +
>  static inline bool zdev_enabled(struct zpci_dev *zdev)
>  {
>  	return (zdev->fh & (1UL << 31)) ? true : false;
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index 552b990..bf6732f 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -358,7 +358,8 @@ static void zpci_irq_handler(struct airq_struct *airq)
>  	}
>  }
> 
> -int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
> +static int zpci_setup_msi_irqs(struct msi_chip *chip,
> +		struct pci_dev *pdev, int nvec, int type)
>  {
>  	struct zpci_dev *zdev = get_zdev(pdev);
>  	unsigned int hwirq, msi_vecs;
> @@ -434,7 +435,8 @@ out:
>  	return rc;
>  }
> 
> -void arch_teardown_msi_irqs(struct pci_dev *pdev)
> +static void zpci_teardown_msi_irqs(struct msi_chip *chip,
> +		struct pci_dev *pdev)
>  {
>  	struct zpci_dev *zdev = get_zdev(pdev);
>  	struct msi_desc *msi;
> @@ -464,6 +466,11 @@ void arch_teardown_msi_irqs(struct pci_dev *pdev)
>  	airq_iv_free_bit(zpci_aisb_iv, zdev->aisb);
>  }
> 
> +static struct msi_chip zpci_msi_chip = {
> +	.setup_irqs = zpci_setup_msi_irqs,
> +	.teardown_irqs = zpci_teardown_msi_irqs,
> +};
> +
>  static void zpci_map_resources(struct zpci_dev *zdev)
>  {
>  	struct pci_dev *pdev = zdev->pdev;
> @@ -749,6 +756,7 @@ static int zpci_scan_bus(struct zpci_dev *zdev)
>  	if (ret)
>  		return ret;
> 
> +	zdev->msi_chip = &zpci_msi_chip;
>  	zdev->bus = pci_scan_root_bus(NULL, ZPCI_BUS_NR, &pci_root_ops,
>  				      zdev, &resources);
>  	if (!zdev->bus) {
> -- 
> 1.7.1
> 
> 

