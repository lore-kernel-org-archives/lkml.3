Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3AaX3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 18:29:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab3AaX3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:29:37 -0500
Subject: Re: [PATCH 1/2] PCI: ASPM exit link state code could skip devices
From: Myron Stowe <mstowe@redhat.com>
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: linux-pci@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        David Bulkow <david.bulkow@stratus.com>, shli@kernel.org,
        shli@fusionio.com, kaneshige.kenji@jp.fujitsu.com,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1301181322500.31163@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1301181302260.31163@jlaw-desktop.mno.stratus.com>
	 <alpine.DEB.2.02.1301181322500.31163@jlaw-desktop.mno.stratus.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Jan 2013 16:29:25 -0700
Message-ID: <1359674965.2426.13.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-18 at 13:23 -0500, Joe Lawrence wrote:
> From 3a51bbad5555ba6c6e144aa5176c8112eb449325 Mon Sep 17 00:00:00 2001
> From: Joe Lawrence <joe.lawrence@stratus.com>
> Date: Tue, 15 Jan 2013 14:51:57 -0500
> Subject: [PATCH 1/2] PCI: ASPM exit link state code could skip devices
> 
> On PCI bus hotplug removal, pcie_aspm_exit_link_state could potentially skip
> parent devices that have link_state allocated.  Instead of exiting early if
> a given device is not PCIe, check that the device's parent is PCIe.  This
> enables pcie_aspm_exit_link_state to properly clean up parent link_state when
> the last function in a slot might not be PCIe.
> 
> Reviewed-by: David Bulkow <david.bulkow@stratus.com>
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> ---
>  drivers/pci/pcie/aspm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index b52630b..6122447 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -634,7 +634,7 @@ void pcie_aspm_exit_link_state(struct pci_dev *pdev)
>  	struct pci_dev *parent = pdev->bus->self;
>  	struct pcie_link_state *link, *root, *parent_link;
>  
> -	if (!pci_is_pcie(pdev) || !parent || !parent->link_state)
> +	if (!parent || !pci_is_pcie(parent) || !parent->link_state)
>  		return;
>  	if ((pci_pcie_type(parent) != PCI_EXP_TYPE_ROOT_PORT) &&
>  	    (pci_pcie_type(parent) != PCI_EXP_TYPE_DOWNSTREAM))

Joe:

Bjorn and I looked at this again today and think the checks that occur
early in 'pcie_aspm_exit_link_state()' could be simplified (as shown
below) to avoid issues such as you are encountering.

I think part of the confusion concerning the asymmetry between
'pcie_aspm_init_link_state()' and 'pcie_aspm_exit_link_state()' is that
the former is passed in a pointer to a bridge device whereas the latter
is passed in a pointer to a end-point device.  Frankly, I find the
entire driver to be confusing and very hard to understand.

Could you please test with the following patch and let us know the
results?


PCI: ASPM exit link state code is skipping devices

From: Myron Stowe <myron.stowe@redhat.com>

On PCI bus hotplug removal, 'pcie_aspm_exit_link_state' can potentially
skip parent devices that have link_state allocated.  Instead of exiting
early if a given device in not PCIe, check whether or not the device's
parent has link_state allocated.  This enables 'pcie_aspm_exit_link_state'
to properly clean up parent link_state when the last function in a slot
might not be PCIe.

Reported-by: Joe Lawrence <joe.lawrence@stratus.com>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/pcie/aspm.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)


diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 8474b6a..aa52727 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -634,10 +634,7 @@ void pcie_aspm_exit_link_state(struct pci_dev *pdev)
 	struct pci_dev *parent = pdev->bus->self;
 	struct pcie_link_state *link, *root, *parent_link;
 
-	if (!pci_is_pcie(pdev) || !parent || !parent->link_state)
-		return;
-	if ((pci_pcie_type(parent) != PCI_EXP_TYPE_ROOT_PORT) &&
-	    (pci_pcie_type(parent) != PCI_EXP_TYPE_DOWNSTREAM))
+	if (!parent || !parent->link_state)
 		return;
 
 	down_read(&pci_bus_sem);


