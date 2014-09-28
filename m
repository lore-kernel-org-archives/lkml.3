Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaI1QK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:10:59 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33953 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaI1QK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:10:57 -0400
Date: Sun, 28 Sep 2014 12:10:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v4 4/4] AHCI: Do not read HOST_IRQ_STAT reg in multi-MSI
 mode
Message-ID: <20140928161050.GC8050@mtj.dyndns.org>
References: <cover.1411648623.git.agordeev@redhat.com>
 <82c0cbbafd74eca0e346ca97f73838ba236315c3.1411648623.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82c0cbbafd74eca0e346ca97f73838ba236315c3.1411648623.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alexander.

On Thu, Sep 25, 2014 at 03:13:24PM +0200, Alexander Gordeev wrote:
> @@ -1797,11 +1797,14 @@ static irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance)
>  	unsigned long flags;
>  	u32 status;
>  
> -	spin_lock_irqsave(&ap->host->lock, flags);
> +	spin_lock_irqsave(&pp->intr_lock, flags);
>  	status = pp->intr_status;
>  	if (status)
>  		pp->intr_status = 0;
> -	spin_unlock_irqrestore(&ap->host->lock, flags);
> +	spin_unlock_irqrestore(&pp->intr_lock, flags);

atomic_xchg() prolly is a better option here.

> +
> +	if (!status)
> +		return IRQ_NONE;
>  
>  	spin_lock_bh(ap->lock);
>  	ahci_handle_port_interrupt(ap, port_mmio, status);
> @@ -1824,53 +1827,14 @@ static void ahci_update_intr_status(struct ata_port *ap)
>  
>  static irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance)
>  {
...
> +	spin_lock(&pp->intr_lock);
> +	ahci_update_intr_status(ap);
> +	spin_unlock(&pp->intr_lock);

and atomic_or() in update_intr_status.

Thanks.

-- 
tejun
