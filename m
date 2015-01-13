Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbbAMVBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:01:21 -0500
Received: from mout.gmx.net ([212.227.17.21]:62291 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbbAMVBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:01:19 -0500
Message-ID: <54B5879A.9020902@gmx.de>
Date: Tue, 13 Jan 2015 22:01:14 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH 08/10] PCI, parisc: clip firmware assigned resource under
 parent bridge's
References: <1421090600-9750-1-git-send-email-yinghai@kernel.org> <1421090600-9750-9-git-send-email-yinghai@kernel.org>
In-Reply-To: <1421090600-9750-9-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ljL7cZupLE3ZSnCA6nTEvi3j5y9dsSEAEe+qJEcXTQc18AzgP4L
 gFUR+PG/vS3lrUuKFWdVySHj9bsqCgt4VWgPs/qNQwkpkNzmtKFkKCghDcHgVL0+zoRb++L
 k/2KHwb2VJh4S5ydJiRiHcvF7hWagbtj6eReT8RBJ8wNFi1PmkPW9Lbh9+W1B470F78UZhy
 9kgzGrVfgeV3ikttvtDzA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.01.2015 20:23, Yinghai Lu wrote:
> Some bios put range that is not fully coverred by root bus resources.
> Try to clip them and update them in pci bridge bars.
>
> We'd like to fix other arches instead of just x86.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
> Reported-by: Marek Kordik <kordikmarek@gmail.com>
> Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> Cc: Helge Deller <deller@gmx.de>
> Cc: linux-parisc@vger.kernel.org

I tested it on the parisc arch - everything OK.

Acked-by: Helge Deller <deller@gmx.de>

Thanks!
Helge


> ---
>   drivers/parisc/lba_pci.c | 26 ++++++++++++++++++++++++--
>   1 file changed, 24 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
> index 37e71ff..e6ab352 100644
> --- a/drivers/parisc/lba_pci.c
> +++ b/drivers/parisc/lba_pci.c
> @@ -692,11 +692,25 @@ lba_fixup_bus(struct pci_bus *bus)
>   	*/
>   	if (bus->parent) {
>   		int i;
> +		bool changed = false;
> +
> +		dev = bus->self;
>   		/* PCI-PCI Bridge */
>   		pci_read_bridge_bases(bus);
>   		for (i = PCI_BRIDGE_RESOURCES; i < PCI_NUM_RESOURCES; i++) {
> -			pci_claim_resource(bus->self, i);
> +			struct resource *res = &dev->resource[i];
> +
> +			if (pci_claim_resource(dev, i) >= 0)
> +				continue;
> +
> +			if (pci_bus_clip_resource(dev, res)) {
> +				changed = true;
> +				if (pci_claim_resource(dev, i) >= 0)
> +					continue;
> +			}
>   		}
> +		if (changed)
> +			pci_setup_bridge(bus);
>   	} else {
>   		/* Host-PCI Bridge */
>   		int err;
> @@ -776,7 +790,15 @@ lba_fixup_bus(struct pci_bus *bus)
>   			** that share expansion ROMs (think quad tulip), but
>   			** isn't harmful.
>   			*/
> -			pci_claim_resource(dev, i);
> +			if (pci_claim_resource(dev, i) >= 0)
> +				continue;
> +
> +			/* try again with clip */
> +			if (i != PCI_ROM_RESOURCE &&
> +			    pci_bus_clip_resource(dev, res)) {
> +				pci_update_resource(dev, i);
> +				pci_claim_resource(dev, i);
> +			}
>   		}
>
>   #ifdef FBB_SUPPORT
>

