Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab3CYQqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:46:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:40848 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758086Ab3CYQqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:46:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,905,1355126400"; 
   d="scan'208";a="307166688"
Date: Mon, 25 Mar 2013 09:45:51 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI / ACPI: Always resume devices on ACPI wakeup
 notifications
Message-ID: <20130325164551.GA6869@xanatos>
References: <2282655.IicBMMa6jN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2282655.IicBMMa6jN@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 03:33:03PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> It turns out that _Lxx control methods provided by some BIOSes clear
> the PME Status bit of PCI devices they handle, which means that
> pci_acpi_wake_dev() cannot really use that bit to check whether or
> not the device has signalled wakeup.
> 
> For this reason, make pci_acpi_wake_dev() always attempt to resume
> the device it is called for regardless of the device's PME Status bit
> value (that bit still has to be cleared if set at this point,
> though).
> 
> Reported-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Should this be marked for stable?  I had this issue on 3.7 and 3.8 as
well.

Sarah

> ---
>  drivers/pci/pci-acpi.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> Index: linux-pm/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pci-acpi.c
> +++ linux-pm/drivers/pci/pci-acpi.c
> @@ -53,14 +53,15 @@ static void pci_acpi_wake_dev(acpi_handl
>  		return;
>  	}
>  
> -	if (!pci_dev->pm_cap || !pci_dev->pme_support
> -	     || pci_check_pme_status(pci_dev)) {
> -		if (pci_dev->pme_poll)
> -			pci_dev->pme_poll = false;
> +	/* Clear PME Status if set. */
> +	if (pci_dev->pme_support)
> +		pci_check_pme_status(pci_dev);
>  
> -		pci_wakeup_event(pci_dev);
> -		pm_runtime_resume(&pci_dev->dev);
> -	}
> +	if (pci_dev->pme_poll)
> +		pci_dev->pme_poll = false;
> +
> +	pci_wakeup_event(pci_dev);
> +	pm_runtime_resume(&pci_dev->dev);
>  
>  	if (pci_dev->subordinate)
>  		pci_pme_wakeup_bus(pci_dev->subordinate);
> 
