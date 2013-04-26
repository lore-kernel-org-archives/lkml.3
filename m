Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab3DZQMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:12:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7618 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab3DZQMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:12:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,559,1363132800"; 
   d="scan'208";a="20804286"
Date: Fri, 26 Apr 2013 17:12:31 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 4/9] xen/events: Check that IRQ value passed in is
 valid.
In-Reply-To: <1366142947-18655-5-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1304261712250.4180@kaball.uk.xensource.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com> <1366142947-18655-5-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013, Konrad Rzeszutek Wilk wrote:
> We naively assume that the IRQ value passed in is correct.
> If it is not, then any dereference operation for the 'info'
> structure will result in crash - so might as well guard ourselves
> and sprinkle copious amounts of WARN_ON.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  drivers/xen/events.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index bb65f75..94daed1 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -515,6 +515,9 @@ static void xen_free_irq(unsigned irq)
>  {
>  	struct irq_info *info = irq_get_handler_data(irq);
>  
> +	if (WARN_ON(!info))
> +		return;
> +
>  	list_del(&info->list);
>  
>  	irq_set_handler_data(irq, NULL);
> @@ -1003,6 +1006,9 @@ static void unbind_from_irq(unsigned int irq)
>  	int evtchn = evtchn_from_irq(irq);
>  	struct irq_info *info = irq_get_handler_data(irq);
>  
> +	if (WARN_ON(!info))
> +		return;
> +
>  	mutex_lock(&irq_mapping_update_lock);
>  
>  	if (info->refcnt > 0) {
> @@ -1130,6 +1136,10 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
>  
>  void unbind_from_irqhandler(unsigned int irq, void *dev_id)
>  {
> +	struct irq_info *info = irq_get_handler_data(irq);
> +
> +	if (WARN_ON(!info))
> +		return;
>  	free_irq(irq, dev_id);
>  	unbind_from_irq(irq);
>  }
> @@ -1441,6 +1451,9 @@ void rebind_evtchn_irq(int evtchn, int irq)
>  {
>  	struct irq_info *info = info_for_irq(irq);
>  
> +	if (WARN_ON(!info))
> +		return;
> +
>  	/* Make sure the irq is masked, since the new event channel
>  	   will also be masked. */
>  	disable_irq(irq);
> @@ -1714,7 +1727,12 @@ void xen_poll_irq(int irq)
>  int xen_test_irq_shared(int irq)
>  {
>  	struct irq_info *info = info_for_irq(irq);
> -	struct physdev_irq_status_query irq_status = { .irq = info->u.pirq.pirq };
> +	struct physdev_irq_status_query irq_status;
> +
> +	if (WARN_ON(!info))
> +		return -ENOENT;
> +
> +	irq_status.irq = info->u.pirq.pirq;
>  
>  	if (HYPERVISOR_physdev_op(PHYSDEVOP_irq_status_query, &irq_status))
>  		return 0;
> -- 
> 1.8.1.4
> 
