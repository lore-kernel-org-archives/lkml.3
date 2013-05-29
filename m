Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966631Ab3E2PTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:19:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23442 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966175Ab3E2PTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:19:08 -0400
Date: Wed, 29 May 2013 11:17:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        xen-devel@lists.xen.org, mail@srajiv.net, tpmdd@selhorst.net,
        tpmdd@sirrix.com, leosilva@linux.vnet.ibm.com,
        adlai@linux.vnet.ibm.com, shpedoikal@gmail.com
Subject: Re: [PATCH v3] drivers/tpm: add xen tpmfront interface
Message-ID: <20130529151742.GB23775@phenom.dumpdata.com>
References: <1369755632-2753-1-git-send-email-dgdegra@tycho.nsa.gov>
 <20130528203216.GA25602@phenom.dumpdata.com>
 <51A51782.2070406@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A51782.2070406@tycho.nsa.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 04:45:54PM -0400, Daniel De Graaf wrote:
> On 05/28/2013 04:32 PM, Konrad Rzeszutek Wilk wrote:
> >On Tue, May 28, 2013 at 11:40:32AM -0400, Daniel De Graaf wrote:
> >>This is a complete rewrite of the Xen TPM frontend driver, taking
> >>advantage of a simplified frontend/backend interface and adding support
> >>for cancellation and timeouts.  The backend for this driver is provided
> >>by a vTPM stub domain using the interface in Xen 4.3.
> >>
> >>Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> >>Acked-by: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
> >
> >.. snip..
> >>+static void ring_free(struct tpm_private *priv)
> >>+{
> >>+	if (!priv)
> >>+		return;
> >>+
> >>+	if (priv->ring_ref)
> >>+		gnttab_end_foreign_access(priv->ring_ref, 0,
> >>+				(unsigned long)priv->shr);
> >>+	else
> >>+		free_page((unsigned long)priv->shr);
> >>+
> >>+	if (priv->chip && priv->chip->vendor.irq)
> >>+		unbind_from_irqhandler(priv->chip->vendor.irq, priv);
> >
> >You are missing:
> >
> >	if (priv->evtchn != INVALID_EVTCHN)
> >		xenbus_free_evtchn(priv->xdev, priv->evtchn);
> 
> This is already handled by unbind_from_irqhandler when it calls
> unbind_from_irq, which gets the event channel from the IRQ. This
> should be the same event channel as priv->evtchn, and it already
> calls EVTCHNOP_close on this port. Calling xenbus_free_evtchn on
> the event channel again will just double-free the port.
> 

Yup, I see what you mean. Thanks for the explanation.

In this case you can stick:

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

on the patch.

Thanks!
> This is done the same way as drivers/block/xen-blkfront.c, for
> reference.
> 
> >>+
> >>+	kfree(priv);
> >>+}
> >>+
> 
> 
> -- 
> Daniel De Graaf
> National Security Agency
