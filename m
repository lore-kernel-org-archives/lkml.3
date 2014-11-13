Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbaKMREW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:04:22 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57899 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226AbaKMREU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:04:20 -0500
Date: Thu, 13 Nov 2014 10:04:15 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Duc Dang <dhdang@apm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Liviu Dudau <liviu.dudau@arm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@apm.com, jcm@redhat.com, Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [PATCH 1/1] PCI: X-Gene: assign resource to bus before adding
 new devices
Message-ID: <20141113170415.GF5064@google.com>
References: <1415322858-4318-1-git-send-email-dhdang@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415322858-4318-1-git-send-email-dhdang@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:14:18PM -0800, Duc Dang wrote:
> X-Gene PCIE driver currently depends on Liviu Dudau's patch
> https://lkml.org/lkml/2014/9/30/166 in order to assign resource
> to root bus and endpoint devices. The patch was dropped because
> it will break x86, powerpc and probably others. So X-Gene PCIE
> host functionality is currently broken.
> 
> This patch adds function calls to create and scan root_bus as well
> as assign unassigned bus resource (similar to Liviu Dudau's patch
> above). This will help resolve the dependency to Liviu Dudau's patch
> and make X-Gene PCIE work in latest open-source kernel.
> 
> Signed-off-by: Duc Dang <dhdang@apm.com>
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>

I applied this to for-linus for v3.18, because it fixes a driver we added
in the v3.18 merge window.  Thanks!

> ---
>  drivers/pci/host/pci-xgene.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/host/pci-xgene.c b/drivers/pci/host/pci-xgene.c
> index 9ecabfa..2988fe1 100644
> --- a/drivers/pci/host/pci-xgene.c
> +++ b/drivers/pci/host/pci-xgene.c
> @@ -631,10 +631,15 @@ static int xgene_pcie_probe_bridge(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
>  
> -	bus = pci_scan_root_bus(&pdev->dev, 0, &xgene_pcie_ops, port, &res);
> +	bus = pci_create_root_bus(&pdev->dev, 0,
> +					&xgene_pcie_ops, port, &res);
>  	if (!bus)
>  		return -ENOMEM;
>  
> +	pci_scan_child_bus(bus);
> +	pci_assign_unassigned_bus_resources(bus);
> +	pci_bus_add_devices(bus);
> +
>  	platform_set_drvdata(pdev, port);
>  	return 0;
>  }
> -- 
> 1.8.2.1
> 
