Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3JCAjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 20:39:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:12754 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab3JCAjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 20:39:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1022,1371106800"; 
   d="scan'208";a="387026724"
Date: Wed, 2 Oct 2013 17:39:05 -0700
From: Jon Mason <jon.mason@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Matt Porter <mporter@kernel.crashing.org>, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, x86@kernel.org, linux-ide@vger.kernel.org,
        iss_storagedev@hp.com, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 01/77] PCI/MSI: Fix return value when
 populate_msi_sysfs() failed
Message-ID: <20131003003905.GK6768@jonmason-lab>
References: <cover.1380703262.git.agordeev@redhat.com>
 <3ff5236944aae69f2cd934b5b6da7c1c269df7c1.1380703262.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ff5236944aae69f2cd934b5b6da7c1c269df7c1.1380703262.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 12:48:17PM +0200, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Since you are changing the behavior of the msix_capability_init
function on populate_msi_sysfs error, a comment describing why in this
commit would be nice.

> ---
>  drivers/pci/msi.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index d5f90d6..b43f391 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -719,7 +719,7 @@ static int msix_capability_init(struct pci_dev *dev,
>  
>  	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
>  	if (ret)
> -		goto error;
> +		goto out_avail;
>  
>  	/*
>  	 * Some devices require MSI-X to be enabled before we can touch the
> @@ -732,10 +732,8 @@ static int msix_capability_init(struct pci_dev *dev,
>  	msix_program_entries(dev, entries);
>  
>  	ret = populate_msi_sysfs(dev);
> -	if (ret) {
> -		ret = 0;
> -		goto error;
> -	}
> +	if (ret)
> +		goto out_free;
>  
>  	/* Set MSI-X enabled bits and unmask the function */
>  	pci_intx_for_msi(dev, 0);
> @@ -746,7 +744,7 @@ static int msix_capability_init(struct pci_dev *dev,
>  
>  	return 0;
>  
> -error:
> +out_avail:
>  	if (ret < 0) {
>  		/*
>  		 * If we had some success, report the number of irqs
> @@ -763,6 +761,7 @@ error:
>  			ret = avail;
>  	}
>  
> +out_free:
>  	free_msi_irqs(dev);
>  
>  	return ret;
> -- 
> 1.7.7.6
> 
