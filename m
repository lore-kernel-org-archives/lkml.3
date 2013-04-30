Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842Ab3D3Vl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 17:41:28 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:43503 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933706Ab3D3VlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 17:41:24 -0400
Message-ID: <51803A7F.8080608@pobox.com>
Date: Tue, 30 Apr 2013 17:41:19 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH] AHCI: Make distinct names for ports in /proc/interrupts
References: <20130429101237.GA27738@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20130429101237.GA27738@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 06:12 AM, Alexander Gordeev wrote:
> Currently all interrupts assigned to AHCI ports show up in
> '/proc/interrupts' as 'ahci'. This fix adds port numbers as
> suffixes and hence makes the descriptions distinct.
>
> Reported-by: Jan Beulich <JBeulich@suse.com>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>   drivers/ata/ahci.c |    6 ++++--
>   drivers/ata/ahci.h |    1 +
>   2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 3b9a7b1..dc5c1aa 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1146,10 +1146,12 @@ int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis,
>   			return -EINVAL;
>
>   		for (i = 0; i < n_irqs; i++) {
> +			struct ahci_port_priv *pp = host->ports[i]->private_data;
> +			snprintf(pp->irq_desc, sizeof(pp->irq_desc),
> +				 "%s%d", dev_driver_string(host->dev), i);
>   			rc = devm_request_threaded_irq(host->dev, irq + i,
>   				ahci_multi_irqs_intr, ahci_port_thread_fn,
> -				IRQF_SHARED, dev_driver_string(host->dev),
> -				host->ports[i]);
> +				IRQF_SHARED, pp->irq_desc, host->ports[i]);
>   			if (rc)
>   				goto out_free_irqs;
>   		}
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index ed1fbc8..ceb5208 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -305,6 +305,7 @@ struct ahci_port_priv {
>   	int			fbs_last_dev;	/* save FBS.DEV of last FIS */
>   	/* enclosure management info per PM slot */
>   	struct ahci_em_priv	em_priv[EM_MAX_SLOTS];
> +	char			irq_desc[8];	/* bus + port # */

Would prefer to initialize irq_desc when the struct of ahci_port_priv is 
initialized, rather than at irq request time.

	Jeff




