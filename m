Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3JRKby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 06:31:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37905 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752788Ab3JRKbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 06:31:53 -0400
Date: Fri, 18 Oct 2013 11:31:18 +0100
From: Will Deacon <will.deacon@arm.com>
To: Vinayak Kale <vkale@apm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] genirq: error reporting for non-percpu interrupt in
 request_percpu_irq()
Message-ID: <20131018103117.GA3296@mudshark.cambridge.arm.com>
References: <1382090789-18177-1-git-send-email-vkale@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382090789-18177-1-git-send-email-vkale@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 11:06:29AM +0100, Vinayak Kale wrote:
> Return a separate error code when a non-percpu interrupt is passed to
> request_percpu_irq().
> 
> Suggested-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> ---
>  kernel/irq/manage.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 514bcfd..c2713ae 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -1671,10 +1671,12 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
>  		return -EINVAL;
>  
>  	desc = irq_to_desc(irq);
> -	if (!desc || !irq_settings_can_request(desc) ||
> -	    !irq_settings_is_per_cpu_devid(desc))
> +	if (!desc || !irq_settings_can_request(desc))
>  		return -EINVAL;
>  
> +	if (!irq_settings_is_per_cpu_devid(desc))
> +		return -EPERM;

<bikeshedding> I reckon -ENODEV is clearer here. </bikeshedding>

Also, there's a counterpart to this code in request_threaded_irq, where I
think we should do something similar.

Will
