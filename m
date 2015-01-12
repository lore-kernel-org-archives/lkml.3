Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbbALRDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:03:47 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:51722 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbbALRDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:03:45 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SATA link power management issues
Date: Mon, 12 Jan 2015 18:03:41 +0100
Message-ID: <3361938.rq9uq9yRiO@xps13>
In-Reply-To: <20150112131602.GX25319@htj.dyndns.org>
References: <3352987.ugV1Ipy7Z5@xps13> <1437237.yiFxI2gUSM@xps13> <20150112131602.GX25319@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2015 08:16:02 Tejun Heo wrote:
> Hello,
> 
> What you're experiencing looks like the ssd behaving badly after link
> state transition.  I wonder whether the right solution is plugging
> PHYRDY IRQ for a while after LPM state change.  Does the following
> path make any difference?
> 
> Thanks.
> 
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index 97683e4..684f45d 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -735,8 +735,8 @@ static int ahci_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
>  		sata_link_scr_lpm(link, policy, false);
>  
>  		/* turn PHYRDY IRQ back on */
> -		pp->intr_mask |= PORT_IRQ_PHYRDY;
> -		writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
> +		//pp->intr_mask |= PORT_IRQ_PHYRDY;
> +		//writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
>  	}
>  
>  	return 0;

Hi,

I tried it and got the same result:

[  451.077463] ahci 0000:00:1f.2: port does not support device sleep
[  452.162451] ata3.00: exception Emask 0x10 SAct 0x400 SErr 0x50000 action 0xe frozen
[  452.162461] ata3.00: irq_stat 0x00400008, PHY RDY changed
[  452.162467] ata3: SError: { PHYRdyChg CommWake }
[  452.162473] ata3.00: failed command: WRITE FPDMA QUEUED
[  452.162484] ata3.00: cmd 61/58:50:98:7c:4b/00:00:17:00:00/40 tag 10 ncq 45056 out
         res 40/00:54:98:7c:4b/00:00:17:00:00/40 Emask 0x10 (ATA bus error)
[  452.162489] ata3.00: status: { DRDY }
[  452.162497] ata3: hard resetting link
[  452.886958] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  452.890384] ata3.00: configured for UDMA/133
[  452.902976] ahci 0000:00:1f.2: port does not support device sleep
[  452.903002] ata3: EH complete

Gabriele
