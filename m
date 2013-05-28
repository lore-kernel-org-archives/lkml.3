Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab3E1Uqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:46:51 -0400
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:49751 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756102Ab3E1Uqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:46:50 -0400
X-TM-IMSS-Message-ID: <701b402d000f6b07@nsa.gov>
Message-ID: <51A51782.2070406@tycho.nsa.gov>
Date: Tue, 28 May 2013 16:45:54 -0400
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        xen-devel@lists.xen.org, mail@srajiv.net, tpmdd@selhorst.net,
        tpmdd@sirrix.com, leosilva@linux.vnet.ibm.com,
        adlai@linux.vnet.ibm.com, shpedoikal@gmail.com
Subject: Re: [PATCH v3] drivers/tpm: add xen tpmfront interface
References: <1369755632-2753-1-git-send-email-dgdegra@tycho.nsa.gov> <20130528203216.GA25602@phenom.dumpdata.com>
In-Reply-To: <20130528203216.GA25602@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 04:32 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, May 28, 2013 at 11:40:32AM -0400, Daniel De Graaf wrote:
>> This is a complete rewrite of the Xen TPM frontend driver, taking
>> advantage of a simplified frontend/backend interface and adding support
>> for cancellation and timeouts.  The backend for this driver is provided
>> by a vTPM stub domain using the interface in Xen 4.3.
>>
>> Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
>> Acked-by: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
>
> .. snip..
>> +static void ring_free(struct tpm_private *priv)
>> +{
>> +	if (!priv)
>> +		return;
>> +
>> +	if (priv->ring_ref)
>> +		gnttab_end_foreign_access(priv->ring_ref, 0,
>> +				(unsigned long)priv->shr);
>> +	else
>> +		free_page((unsigned long)priv->shr);
>> +
>> +	if (priv->chip && priv->chip->vendor.irq)
>> +		unbind_from_irqhandler(priv->chip->vendor.irq, priv);
>
> You are missing:
>
> 	if (priv->evtchn != INVALID_EVTCHN)
> 		xenbus_free_evtchn(priv->xdev, priv->evtchn);

This is already handled by unbind_from_irqhandler when it calls
unbind_from_irq, which gets the event channel from the IRQ. This
should be the same event channel as priv->evtchn, and it already
calls EVTCHNOP_close on this port. Calling xenbus_free_evtchn on
the event channel again will just double-free the port.

This is done the same way as drivers/block/xen-blkfront.c, for
reference.

>> +
>> +	kfree(priv);
>> +}
>> +


-- 
Daniel De Graaf
National Security Agency
