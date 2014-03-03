Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaCCNfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:35:13 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:50234 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaCCNfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:35:10 -0500
Date: Mon, 3 Mar 2014 14:35:04 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Bjorn Helgaas <bhelgaas@google.com>
cc: linux-pci@vger.kernel.org, Jan Glauber <jang@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com
Subject: Re: [PATCH 7/7] s390/PCI: Use generic pci_enable_resources()
In-Reply-To: <20140226234215.18970.1743.stgit@bhelgaas-glaptop.roam.corp.google.com>
Message-ID: <alpine.LFD.2.11.1403031429080.1476@denkbrett>
References: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com>  <20140226234215.18970.1743.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030313-1948-0000-0000-0000080061AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bjorn,

On Wed, 26 Feb 2014, Bjorn Helgaas wrote:

> The generic pci_enable_resources() does essentially the same thing as the
> code in the s390 version of pcibios_enable_device().
> 
> There are differences, but I don't think any of them are a problem.  The
> generic code:
> 
>   - Checks everything up to PCI_NUM_RESOURCES, not PCI_BAR_COUNT (6), so
>     we'll now check the ROM resource, IOV resources, and bridge windows.
> 
>   - Checks for res->flags & IORESOURCE_UNSET.  The s390 code never sets
>     IORESOURCE_UNSET, so this isn't a problem.
> 
>   - Checks res->parent.  The s390 pcibios_add_device() calls
>     pci_claim_resource() on all BARs (except ROM, IOV, and bridge windows)
>     so this isn't a problem either.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> CC: Heiko Carstens <heiko.carstens@de.ibm.com>
> CC: Sebastian Ott <sebott@linux.vnet.ibm.com>
> CC: Jan Glauber <jang@linux.vnet.ibm.com>
> CC: linux390@de.ibm.com
> ---
>  arch/s390/pci/pci.c |   13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index 66670ff262a0..7d5fcaed3361 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -695,18 +695,7 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
>  	zpci_fmb_enable_device(zdev);
>  	zpci_map_resources(zdev);
> 
> -	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
> -	for (i = 0; i < PCI_BAR_COUNT; i++) {
> -		res = &pdev->resource[i];
> -
> -		if (res->flags & IORESOURCE_IO)
> -			return -EINVAL;
> -
> -		if (res->flags & IORESOURCE_MEM)
> -			cmd |= PCI_COMMAND_MEMORY;
> -	}
> -	pci_write_config_word(pdev, PCI_COMMAND, cmd);
> -	return 0;
> +	return pci_enable_resources(pdev, mask);
>  }
> 
>  void pcibios_disable_device(struct pci_dev *pdev)
> 

Let's also remove some now unused variables (updated patch below). Other
than that:

Acked-by: Sebastian Ott <sebott@linux.vnet.ibm.com>

Regards,
Sebastian
---
s390/PCI: Use generic pci_enable_resources()

The generic pci_enable_resources() does essentially the same thing as the
code in the s390 version of pcibios_enable_device().

There are differences, but I don't think any of them are a problem.  The
generic code:

  - Checks everything up to PCI_NUM_RESOURCES, not PCI_BAR_COUNT (6), so
    we'll now check the ROM resource, IOV resources, and bridge windows.

  - Checks for res->flags & IORESOURCE_UNSET.  The s390 code never sets
    IORESOURCE_UNSET, so this isn't a problem.

  - Checks res->parent.  The s390 pcibios_add_device() calls
    pci_claim_resource() on all BARs (except ROM, IOV, and bridge windows)
    so this isn't a problem either.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Sebastian Ott <sebott@linux.vnet.ibm.com>
CC: Jan Glauber <jang@linux.vnet.ibm.com>
CC: linux390@de.ibm.com
---
 arch/s390/pci/pci.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -686,27 +686,13 @@ int pcibios_add_device(struct pci_dev *p
 int pcibios_enable_device(struct pci_dev *pdev, int mask)
 {
 	struct zpci_dev *zdev = get_zdev(pdev);
-	struct resource *res;
-	u16 cmd;
-	int i;
 
 	zdev->pdev = pdev;
 	zpci_debug_init_device(zdev);
 	zpci_fmb_enable_device(zdev);
 	zpci_map_resources(zdev);
 
-	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
-	for (i = 0; i < PCI_BAR_COUNT; i++) {
-		res = &pdev->resource[i];
-
-		if (res->flags & IORESOURCE_IO)
-			return -EINVAL;
-
-		if (res->flags & IORESOURCE_MEM)
-			cmd |= PCI_COMMAND_MEMORY;
-	}
-	pci_write_config_word(pdev, PCI_COMMAND, cmd);
-	return 0;
+	return pci_enable_resources(pdev, mask);
 }
 
 void pcibios_disable_device(struct pci_dev *pdev)

