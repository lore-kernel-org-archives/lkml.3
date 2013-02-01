Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab3BAUJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:09:46 -0500
Received: from mailhub5.stratus.com ([134.111.1.18]:39991 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab3BAUJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:09:44 -0500
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2013 15:09:43 EST
Date: Fri, 1 Feb 2013 14:55:42 -0500 (EST)
From: Joe Lawrence <Joe.Lawrence@stratus.com>
X-X-Sender: jlaw@jlaw-desktop.mno.stratus.com
To: Myron Stowe <mstowe@redhat.com>
cc: Joe Lawrence <Joe.Lawrence@stratus.com>, linux-pci@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Bulkow <david.bulkow@stratus.com>, shli@kernel.org,
        shli@fusionio.com, kaneshige.kenji@jp.fujitsu.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] PCI: ASPM exit link state code could skip devices
In-Reply-To: <1359674965.2426.13.camel@zim.stowe>
Message-ID: <alpine.DEB.2.02.1302011442200.11804@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1301181302260.31163@jlaw-desktop.mno.stratus.com>  <alpine.DEB.2.02.1301181322500.31163@jlaw-desktop.mno.stratus.com> <1359674965.2426.13.camel@zim.stowe>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 01 Feb 2013 19:59:23.0824 (UTC) FILETIME=[A1C25B00:01CE00B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, Myron Stowe wrote:

> On Fri, 2013-01-18 at 13:23 -0500, Joe Lawrence wrote:
> > From 3a51bbad5555ba6c6e144aa5176c8112eb449325 Mon Sep 17 00:00:00 2001
> > From: Joe Lawrence <joe.lawrence@stratus.com>
> > Date: Tue, 15 Jan 2013 14:51:57 -0500
> > Subject: [PATCH 1/2] PCI: ASPM exit link state code could skip devices
> > 
> > On PCI bus hotplug removal, pcie_aspm_exit_link_state could potentially skip
> > parent devices that have link_state allocated.  Instead of exiting early if
> > a given device is not PCIe, check that the device's parent is PCIe.  This
> > enables pcie_aspm_exit_link_state to properly clean up parent link_state when
> > the last function in a slot might not be PCIe.
> > 
> > Reviewed-by: David Bulkow <david.bulkow@stratus.com>
> > Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> > ---
> >  drivers/pci/pcie/aspm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> > index b52630b..6122447 100644
> > --- a/drivers/pci/pcie/aspm.c
> > +++ b/drivers/pci/pcie/aspm.c
> > @@ -634,7 +634,7 @@ void pcie_aspm_exit_link_state(struct pci_dev *pdev)
> >  	struct pci_dev *parent = pdev->bus->self;
> >  	struct pcie_link_state *link, *root, *parent_link;
> >  
> > -	if (!pci_is_pcie(pdev) || !parent || !parent->link_state)
> > +	if (!parent || !pci_is_pcie(parent) || !parent->link_state)
> >  		return;
> >  	if ((pci_pcie_type(parent) != PCI_EXP_TYPE_ROOT_PORT) &&
> >  	    (pci_pcie_type(parent) != PCI_EXP_TYPE_DOWNSTREAM))
> 
> Joe:
> 
> Bjorn and I looked at this again today and think the checks that occur
> early in 'pcie_aspm_exit_link_state()' could be simplified (as shown
> below) to avoid issues such as you are encountering.
> 
> I think part of the confusion concerning the asymmetry between
> 'pcie_aspm_init_link_state()' and 'pcie_aspm_exit_link_state()' is that
> the former is passed in a pointer to a bridge device whereas the latter
> is passed in a pointer to a end-point device.  Frankly, I find the
> entire driver to be confusing and very hard to understand.
> 
> Could you please test with the following patch and let us know the
> results?
> 
> 
> PCI: ASPM exit link state code is skipping devices
> 
> From: Myron Stowe <myron.stowe@redhat.com>
> 
> On PCI bus hotplug removal, 'pcie_aspm_exit_link_state' can potentially
> skip parent devices that have link_state allocated.  Instead of exiting
> early if a given device in not PCIe, check whether or not the device's
> parent has link_state allocated.  This enables 'pcie_aspm_exit_link_state'
> to properly clean up parent link_state when the last function in a slot
> might not be PCIe.
> 
> Reported-by: Joe Lawrence <joe.lawrence@stratus.com>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---
> 
>  drivers/pci/pcie/aspm.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 8474b6a..aa52727 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -634,10 +634,7 @@ void pcie_aspm_exit_link_state(struct pci_dev *pdev)
>  	struct pci_dev *parent = pdev->bus->self;
>  	struct pcie_link_state *link, *root, *parent_link;
>  
> -	if (!pci_is_pcie(pdev) || !parent || !parent->link_state)
> -		return;
> -	if ((pci_pcie_type(parent) != PCI_EXP_TYPE_ROOT_PORT) &&
> -	    (pci_pcie_type(parent) != PCI_EXP_TYPE_DOWNSTREAM))
> +	if (!parent || !parent->link_state)
>  		return;
>  
>  	down_read(&pci_bus_sem);
> 
> 
> 

Hi Myron,

The patch tests eliminates the reported crash when hotplugging our 
problem PCI bus.

The additional checks removed from pcie_aspm_exit_link_state (ie, the 
simplification) do appear to be unnecessary as pcie_aspm_init_link_state 
is already preventing such devices from allocating link state.  

Thanks,

-- Joe
