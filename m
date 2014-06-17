Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965933AbaFQVrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:47:16 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:39848 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965220AbaFQVrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:47:13 -0400
Date: Tue, 17 Jun 2014 15:47:09 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, ben@decadent.org.uk, gwshan@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Fix unaligned access testing AF transaction pending
Message-ID: <20140617214709.GA30559@google.com>
References: <20140612152732.4162.23298.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612152732.4162.23298.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 09:28:07AM -0600, Alex Williamson wrote:
> pci_wait_for_pending() uses word access, so we shouldn't be passing
> an offset that is only byte aligned.  Use the control register offset
> instead, shifting the mask to match.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable@vger.kernel.org

Applied with Gavin's ack to for-linus for v3.16, thanks!

> ---
>  drivers/pci/pci.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 759475e..81012ec 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3109,8 +3109,13 @@ static int pci_af_flr(struct pci_dev *dev, int probe)
>  	if (probe)
>  		return 0;
>  
> -	/* Wait for Transaction Pending bit clean */
> -	if (pci_wait_for_pending(dev, pos + PCI_AF_STATUS, PCI_AF_STATUS_TP))
> +	/*
> +	 * Wait for Transaction Pending bit to clear.  A word-aligned test
> +	 * is used, so we use the conrol offset rather than status and shift
> +	 * the test bit to match.
> +	 */
> +	if (pci_wait_for_pending(dev, pos + PCI_AF_CTRL,
> +				 PCI_AF_STATUS_TP << 8))
>  		goto clear;
>  
>  	dev_err(&dev->dev, "transaction is not cleared; "
> 
