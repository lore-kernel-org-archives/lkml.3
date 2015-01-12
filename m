Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbbALWbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:31:14 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:32881 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbbALWbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:31:10 -0500
MIME-Version: 1.0
In-Reply-To: <1421090600-9750-11-git-send-email-yinghai@kernel.org>
References: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
	<1421090600-9750-11-git-send-email-yinghai@kernel.org>
Date: Mon, 12 Jan 2015 23:31:09 +0100
Message-ID: <CALMQjD91+0o=DjQDV3ydkakrG6X=3RkHoCf-T5=wLbC01WkdEA@mail.gmail.com>
Subject: Re: [PATCH 10/10] PCI, sparc: clip firmware assigned resource under
 parent bridge's
From: Kjetil Oftedal <oftedal@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Yijing Wang <wangyijing@huawei.com>, Sam Ravnborg <sam@ravnborg.org>,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am I missing something or is this just code to get the the resource
subsystem to accept the bus resources, not caring if the resources are
actually usable? PCI BARs usually have a given size for a reason?

-
Kjetil Oftedal


On 12/01/2015, Yinghai Lu <yinghai@kernel.org> wrote:
> Some bios put range that is not fully coverred by root bus resources.
> Try to clip them and update them in pci bridge bars.
>
> We'd like to fix other arches instead of just x86.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
> Reported-by: Marek Kordik <kordikmarek@gmail.com>
> Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to
> 64-bit resources")
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Yijing Wang <wangyijing@huawei.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: sparclinux@vger.kernel.org
> ---
>  arch/sparc/kernel/pci.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
> index b36365f..0e391e5 100644
> --- a/arch/sparc/kernel/pci.c
> +++ b/arch/sparc/kernel/pci.c
> @@ -623,6 +623,7 @@ static void pci_claim_bus_resources(struct pci_bus
> *bus)
>  	struct pci_dev *dev;
>
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		bool changed = false;
>  		int i;
>
>  		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
> @@ -639,8 +640,25 @@ static void pci_claim_bus_resources(struct pci_bus
> *bus)
>  				       (unsigned long long)r->end,
>  				       (unsigned int)r->flags);
>
> -			pci_claim_resource(dev, i);
> +			if (pci_claim_resource(dev, i) >= 0)
> +				continue;
> +
> +			if (dev->subordinate &&
> +			    i >= PCI_BRIDGE_RESOURCES &&
> +			    i < PCI_NUM_RESOURCES &&
> +			    (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
> +			    pci_bus_clip_resource(dev, r)) {
> +				changed = true;
> +				pci_claim_resource(dev, i);
> +			} else if (i < PCI_BRIDGE_RESOURCES &&
> +				   i != PCI_ROM_RESOURCE &&
> +				   pci_bus_clip_resource(dev, r)) {
> +					pci_update_resource(dev, i);
> +					pci_claim_resource(dev, i);
> +			}
>  		}
> +		if (changed)
> +			pci_setup_bridge(dev->subordinate);
>  	}
>
>  	list_for_each_entry(child_bus, &bus->children, node)
> --
> 1.8.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
