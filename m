Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaF3WrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:47:16 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:58764 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaF3WrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:47:14 -0400
Date: Mon, 30 Jun 2014 16:47:09 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI: Do not touch siblings in
 pci_assign_unassigned_bridge_resources
Message-ID: <20140630224709.GA22024@google.com>
References: <1402346730-2508-1-git-send-email-andreas.noever@gmail.com>
 <20140617221620.GC30559@google.com>
 <CAE9FiQXD7hvt0cUYMzvq0r6CbZn=iJZc7BHRaF2nACbG7qwuBQ@mail.gmail.com>
 <CAMxnaaWWuNeNbnUe++N=2bBfs5JyKiq7tHH+_kiQZyQ9aakEHg@mail.gmail.com>
 <CAE9FiQVQ657vDOhdhBq5VC044qt6TUF7FKP_-qy+35g71e56Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVQ657vDOhdhBq5VC044qt6TUF7FKP_-qy+35g71e56Yg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 09:41:02PM -0700, Yinghai Lu wrote:
> On Wed, Jun 18, 2014 at 3:40 PM, Andreas Noever
> <andreas.noever@gmail.com> wrote:
> > On Wed, Jun 18, 2014 at 1:39 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > It seems to fix the testcase (no unwanted resources are released). But
> > why do you reassign bus and not just skip the top level bridge? If one
> > of the allocations below bridge failed then a resource of that device
> > will be in fail_res and bridge->subordinate will get released anyways?
> > Also by not removing fail_res from the list you trigger the code in
> > the next loop for the top level bridge (in particular the res->flags =
> > 0 line looks dangerous).
> 
> Should not be dangerous, just second try.

I still don't understand this.  Why do we set "res->flags = 0"?  That
clears out the resource type.  Where do we figure out the type of "res"
again?

> > Could you explain why this function attempts to assign resources two
> > times? In which scenario will a second attempt be successful?
> 
> For example, at first mmio is assigned (by firmware), but pref mmio fails,
> then before second try,  mmio get cleared, then we could separate
> mmio and mmio pref. So need to try again for pref mmio.
> 
> Also I missed one MEM_64 for hotplug path.
> 
> So we need two patches.
> 
> Thanks
> 
> Yinghai

> Subject: [PATCH] pci: Don't release sibiling bridge resources
> 
> On hotplug case, we should not touch sibling bridges that is out
> side of the slots.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -1676,10 +1676,16 @@ again:
>  	 * Try to release leaf bridge's resources that doesn't fit resource of
>  	 * child device under that bridge
>  	 */
> -	list_for_each_entry(fail_res, &fail_head, list)
> -		pci_bus_release_bridge_resources(fail_res->dev->bus,
> +	list_for_each_entry(fail_res, &fail_head, list) {
> +		struct pci_bus *bus = fail_res->dev->bus;
> +
> +		if (fail_res->dev == bridge)
> +			bus = bridge->subordinate;
> +
> +		pci_bus_release_bridge_resources(bus,
>  						 fail_res->flags & type_mask,
>  						 whole_subtree);
> +	}
>  
>  	/* restore size and flags */
>  	list_for_each_entry(fail_res, &fail_head, list) {

> Subject: [PATCH] pci: Add back missing MEM_64 check for hotplug path
> 
> We miss that in
> |  commit 5b28541552ef5eeffc41d6936105f38c2508e566
> |    PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources
> for pci hotplug path.

This changelog is useless.  I don't have time to spend a few hours
figuring out why we want this change.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -1652,7 +1652,7 @@ void pci_assign_unassigned_bridge_resour
>  	struct pci_dev_resource *fail_res;
>  	int retval;
>  	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> -				  IORESOURCE_PREFETCH;
> +				  IORESOURCE_PREFETCH | IORESOURCE_MEM_64;
>  
>  again:
>  	__pci_bus_size_bridges(parent, &add_list);

