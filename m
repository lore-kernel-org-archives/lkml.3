Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaFLXdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:33:47 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51544 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaFLXdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:33:45 -0400
Date: Fri, 13 Jun 2014 09:33:37 +1000
From: Gavin Shan <gwshan@linux.vnet.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com, ben@decadent.org.uk,
        gwshan@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Fix unaligned access testing AF transaction pending
Message-ID: <20140612233336.GA4404@shangw>
Reply-To: Gavin Shan <gwshan@linux.vnet.ibm.com>
References: <20140612152732.4162.23298.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612152732.4162.23298.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061223-5140-0000-0000-0000054D5C79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 09:28:07AM -0600, Alex Williamson wrote:
>pci_wait_for_pending() uses word access, so we shouldn't be passing
>an offset that is only byte aligned.  Use the control register offset
>instead, shifting the mask to match.
>
>Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>Reported-by: Ben Hutchings <ben@decadent.org.uk>
>Cc: stable@vger.kernel.org

Acked-by: Gavin Shan <gwshan@linux.vnet.ibm.com>

>---
> drivers/pci/pci.c |    9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>index 759475e..81012ec 100644
>--- a/drivers/pci/pci.c
>+++ b/drivers/pci/pci.c
>@@ -3109,8 +3109,13 @@ static int pci_af_flr(struct pci_dev *dev, int probe)
> 	if (probe)
> 		return 0;
>
>-	/* Wait for Transaction Pending bit clean */
>-	if (pci_wait_for_pending(dev, pos + PCI_AF_STATUS, PCI_AF_STATUS_TP))
>+	/*
>+	 * Wait for Transaction Pending bit to clear.  A word-aligned test
>+	 * is used, so we use the conrol offset rather than status and shift
>+	 * the test bit to match.
>+	 */
>+	if (pci_wait_for_pending(dev, pos + PCI_AF_CTRL,
>+				 PCI_AF_STATUS_TP << 8))
> 		goto clear;
>
> 	dev_err(&dev->dev, "transaction is not cleared; "
>

Thanks,
Gavin

