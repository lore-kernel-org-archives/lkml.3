Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaGIMVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:21:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:31396 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaGIMVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:21:14 -0400
X-IronPort-AV: E=Sophos;i="5.01,631,1400025600"; 
   d="scan'208";a="151206785"
Message-ID: <53BD33B8.9020901@citrix.com>
Date: Wed, 9 Jul 2014 13:21:12 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <konrad@kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v3 2/7] xen/pciback: Don't deadlock when unbinding.
References: <1404845909-13563-1-git-send-email-konrad@kernel.org> <1404845909-13563-3-git-send-email-konrad@kernel.org>
In-Reply-To: <1404845909-13563-3-git-send-email-konrad@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/14 19:58, konrad@kernel.org wrote:
> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -277,10 +277,15 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
>  	 * (so it's ready for the next domain)
>  	 */
>  
> -	/* This is OK - we are running from workqueue context
> -	 * and want to inhibit the user from fiddling with 'reset'
> +	/* We might be holding the PCI lock (see comment at the top of the
> +	 * function) - as such try lock and if we can't then don't worry -
> +	 * as either:
> +	 *  - we are 'unbind' in which case 'pcistub_device_release' gets
> +	 *    called which does the locked version of this.
> +	 *  - the toolstack has the smarts to do it and has done the
> +	 *    reset on SysFS before assigning this device to another guest.
>  	 */
> -	pci_reset_function(dev);
> +	pci_try_reset_function(dev);

Why not use __pci_reset_function_locked() and ensure all callers of
pcistub_put_pci_dev() are holding the device lock?

>  	pci_restore_state(dev);

If we didn't reset the device there is no need to restore its state.

David
