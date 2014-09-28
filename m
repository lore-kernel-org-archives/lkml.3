Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaI1QEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:04:15 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:65421 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaI1QEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:04:13 -0400
Date: Sun, 28 Sep 2014 12:04:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v4 2/4] AHCI: Move host activation code into
 ahci_host_activate()
Message-ID: <20140928160408.GA8050@mtj.dyndns.org>
References: <cover.1411648623.git.agordeev@redhat.com>
 <39cff5287f4fcc33d0f00f89cb2337c5a5ec22b6.1411648623.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39cff5287f4fcc33d0f00f89cb2337c5a5ec22b6.1411648623.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 03:13:22PM +0200, Alexander Gordeev wrote:
> -/**
> - *	ahci_host_activate - start AHCI host, request IRQs and register it
> - *	@host: target ATA host
> - *	@irq: base IRQ number to request
> - *	@irq_handler: irq_handler used when requesting IRQs
> - *	@irq_flags: irq_flags used when requesting IRQs
> - *
> - *	Similar to ata_host_activate, but requests IRQs according to AHCI-1.1
> - *	when multiple MSIs were allocated. That is one MSI per port, starting
> - *	from @irq.
> - *
> - *	LOCKING:
> - *	Inherited from calling layer (may sleep).
> - *
> - *	RETURNS:
> - *	0 on success, -errno otherwise.
> - */
> -int ahci_host_activate(struct ata_host *host, int irq)
> -{
> -	int i, rc;
> -
> -	rc = ata_host_start(host);
> -	if (rc)
> -		return rc;
> -
> -	for (i = 0; i < host->n_ports; i++) {
> -		struct ahci_port_priv *pp = host->ports[i]->private_data;
> -
> -		/* Do not receive interrupts sent by dummy ports */
> -		if (!pp) {
> -			disable_irq(irq + i);
> -			continue;
> -		}
> -
> -		rc = devm_request_threaded_irq(host->dev, irq + i,
> -					       ahci_hw_interrupt,
> -					       ahci_thread_fn, IRQF_SHARED,
> -					       pp->irq_desc, host->ports[i]);
> -		if (rc)
> -			goto out_free_irqs;
> -	}
> -
> -	for (i = 0; i < host->n_ports; i++)
> -		ata_port_desc(host->ports[i], "irq %d", irq + i);
> -
> -	rc = ata_host_register(host, &ahci_sht);
> -	if (rc)
> -		goto out_free_all_irqs;
> -
> -	return 0;
> -
> -out_free_all_irqs:
> -	i = host->n_ports;
> -out_free_irqs:
> -	for (i--; i >= 0; i--)
> -		devm_free_irq(host->dev, irq + i, host->ports[i]);
> -
> -	return rc;
> -}

It's generally a bad idea to mix code movement w/ other changes.  I'm
applying this one but please separate code movements to separate
patches from now on.

Thanks.

-- 
tejun
