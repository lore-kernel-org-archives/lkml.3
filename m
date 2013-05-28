Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3E1Udt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:33:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34835 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab3E1Uds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:33:48 -0400
Date: Tue, 28 May 2013 16:32:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        xen-devel@lists.xen.org, mail@srajiv.net, tpmdd@selhorst.net,
        tpmdd@sirrix.com, leosilva@linux.vnet.ibm.com,
        adlai@linux.vnet.ibm.com, shpedoikal@gmail.com
Subject: Re: [PATCH v3] drivers/tpm: add xen tpmfront interface
Message-ID: <20130528203216.GA25602@phenom.dumpdata.com>
References: <1369755632-2753-1-git-send-email-dgdegra@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369755632-2753-1-git-send-email-dgdegra@tycho.nsa.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 11:40:32AM -0400, Daniel De Graaf wrote:
> This is a complete rewrite of the Xen TPM frontend driver, taking
> advantage of a simplified frontend/backend interface and adding support
> for cancellation and timeouts.  The backend for this driver is provided
> by a vTPM stub domain using the interface in Xen 4.3.
> 
> Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> Acked-by: Matthew Fioravante <matthew.fioravante@jhuapl.edu>

.. snip..
> +static void ring_free(struct tpm_private *priv)
> +{
> +	if (!priv)
> +		return;
> +
> +	if (priv->ring_ref)
> +		gnttab_end_foreign_access(priv->ring_ref, 0,
> +				(unsigned long)priv->shr);
> +	else
> +		free_page((unsigned long)priv->shr);
> +
> +	if (priv->chip && priv->chip->vendor.irq)
> +		unbind_from_irqhandler(priv->chip->vendor.irq, priv);

You are missing:

	if (priv->evtchn != INVALID_EVTCHN)
		xenbus_free_evtchn(priv->xdev, priv->evtchn);

> +
> +	kfree(priv);
> +}
> +
