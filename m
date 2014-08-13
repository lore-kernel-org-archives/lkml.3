Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaHMJ37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:29:59 -0400
Received: from smtp.citrix.com ([66.165.176.89]:45853 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaHMJ36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:29:58 -0400
X-IronPort-AV: E=Sophos;i="5.01,855,1400025600"; 
   d="scan'208";a="161284446"
Message-ID: <53EB3014.8090008@citrix.com>
Date: Wed, 13 Aug 2014 10:29:56 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <jgross@suse.com>, <xen-devel@lists.xenproject.org>,
        <david.vrabel@citrix.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Make bind_interdomain_evtchn_to_irq() public
References: <1407851024-18936-1-git-send-email-jgross@suse.com>
In-Reply-To: <1407851024-18936-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/14 14:43, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> bind_interdomain_evtchn_to_irq() is currently a private function. It is used
> only by bind_interdomain_evtchn_to_irqhandler() to register an irq-handler for
> an event channel.
> 
> By making it public it is possible to use e.g. threaded interrupts with
> interdomain event channels.

Can you give an example of using this?  Maybe we want a
bind_interdomain_evtchn_to_threaded_irqhandler() instead? Or add a flags
field to the existing function.

David

> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -900,8 +900,8 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
>  	return irq;
>  }
>  
> -static int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
> -					  unsigned int remote_port)
> +int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
> +				   unsigned int remote_port)
>  {
>  	struct evtchn_bind_interdomain bind_interdomain;
>  	int err;
> @@ -914,6 +914,7 @@ static int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
>  
>  	return err ? : bind_evtchn_to_irq(bind_interdomain.local_port);
>  }
> +EXPORT_SYMBOL_GPL(bind_interdomain_evtchn_to_irq);
>  
>  static int find_virq(unsigned int virq, unsigned int cpu)
>  {
> diff --git a/include/xen/events.h b/include/xen/events.h
> index 8bee7a7..5321cd9 100644
> --- a/include/xen/events.h
> +++ b/include/xen/events.h
> @@ -28,6 +28,8 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
>  			   unsigned long irqflags,
>  			   const char *devname,
>  			   void *dev_id);
> +int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
> +				   unsigned int remote_port);
>  int bind_interdomain_evtchn_to_irqhandler(unsigned int remote_domain,
>  					  unsigned int remote_port,
>  					  irq_handler_t handler,
> 

