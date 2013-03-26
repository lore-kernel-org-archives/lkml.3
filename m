Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102Ab3CZS5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:57:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56925 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab3CZS5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:57:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 26 Mar 2013 19:56:53 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: Enable physical DMA above 4GB
Message-ID: <20130326195653.470b09d6@stein>
In-Reply-To: <1364307734-27709-1-git-send-email-peter@hurleysoftware.com>
References: <1364307734-27709-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 26 Peter Hurley wrote:
> Quadlet reads to memory above 4GB is painfully slow when serviced
> by the AR DMA context. In addition, the CPU(s) may be locked-up,
> preventing any transfer at all.
> 
> Write the PhyUpperBound register with the end-of-memory value. If
> end-of-memory is beyond the OHCI limit of 0x0000ffff00000000,
> clamp to that value.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/firewire/ohci.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
> index 044ace3..b4135a5 100644
> --- a/drivers/firewire/ohci.c
> +++ b/drivers/firewire/ohci.c
> @@ -2249,6 +2249,7 @@ static int ohci_enable(struct fw_card *card,
>  	struct pci_dev *dev = to_pci_dev(card->device);
>  	u32 lps, version, irqs;
>  	int i, ret;
> +	u32 phys_upper;
>  
>  	if (software_reset(ohci)) {
>  		dev_err(card->device, "failed to reset ohci card\n");
> @@ -2323,7 +2324,10 @@ static int ohci_enable(struct fw_card *card,
>  	reg_write(ohci, OHCI1394_FairnessControl, 0);
>  	card->priority_budget_implemented = ohci->pri_req_max != 0;
>  
> -	reg_write(ohci, OHCI1394_PhyUpperBound, 0x00010000);
> +	phys_upper = min(0xffff0000ULL,
> +			 (dma_get_required_mask(card->device) >> 16) + 1);
> +	reg_write(ohci, OHCI1394_PhyUpperBound, max(phys_upper, 0x00010000U));
> +
>  	reg_write(ohci, OHCI1394_IntEventClear, ~0);
>  	reg_write(ohci, OHCI1394_IntMaskClear, ~0);
>  

What Clemens said.

Also:  By far most OHCI-1394 chips do not implement PhyUpperBound,
i.e. ignore any writes to PhyUpperBound, return 0 when PhyUpperBound is
read, and keep the boundary between physical response and AR response at
4 GB, as described in the spec.

It has been a long time though since I last checked whether PhyUpperBound
is implemented; maybe it has become more widespread than it was back then.

Or maybe it hasn't:  All OHCI-1394 chips that ever came to market are 32
bit chips anyway.  So the few rare ones that do support PhyUpperBound
larger than 4 GB cannot in fact use it.

Or am I severely behind the times about this?
-- 
Stefan Richter
-=====-===-= --== ==-=-
http://arcgraph.de/sr/
