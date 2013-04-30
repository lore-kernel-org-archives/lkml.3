Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766Ab3D3PCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:02:49 -0400
Received: from smtp.citrix.com ([66.165.176.89]:52151 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759686Ab3D3PCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:02:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,582,1363132800"; 
   d="scan'208";a="22401830"
Date: Tue, 30 Apr 2013 16:02:42 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Julien Grall <julien.grall@linaro.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH] xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST when a VIRQ
 is bound
In-Reply-To: <1367264377-7107-1-git-send-email-julien.grall@linaro.org>
Message-ID: <alpine.DEB.2.02.1304301556130.5398@kaball.uk.xensource.com>
References: <1367264377-7107-1-git-send-email-julien.grall@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, Julien Grall wrote:
> Reset the IRQ_NOAUTOEN and IRQ_NOREQUEST flags that are enabled by
> default on ARM. If IRQ_NOAUTOEN is set, __setup_irq doesn't call
> irq_startup, that is responsible for calling irq_unmask at startup time.
> As a result event channels remain masked.
> 
> The clear is already made in bind_evtchn_to_irq with commit a8636c0 but was
> missing in bind_virq_to_irq.
> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>

As in the original commit, you should point out that this change does
not have any effects on x86 (where IRQ_NOREQUEST and IRQ_NOAUTOEN are
cleared by default).

At this point we might as well do this consistently everywhere we
allocate a new evtchn irq, including pirqs and ipis, even though we don't
actually use them on ARM.

If the call to irq_clear_status_flags can be moved earlier, a good place
for it could be xen_irq_init.


>  drivers/xen/events.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index d8cc812..b0ad226 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -994,6 +994,7 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
>  		WARN_ON(info == NULL || info->type != IRQT_VIRQ);
>  	}
>  
> +	irq_clear_status_flags(irq, IRQ_NOREQUEST|IRQ_NOAUTOEN);
>  out:
>  	mutex_unlock(&irq_mapping_update_lock);

