Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbbAXPwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 10:52:32 -0500
Received: from netrider.rowland.org ([192.131.102.5]:47386 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753882AbbAXPw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 10:52:27 -0500
Date: Sat, 24 Jan 2015 10:52:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rodolfo Giometti <giometti@linux.it>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] usb: host: oxu210hp-hcd: Fix deadlock in oxu_qh_alloc()
In-Reply-To: <1422053601-29473-1-git-send-email-khoroshilov@ispras.ru>
Message-ID: <Pine.LNX.4.44L0.1501241049300.7435-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2015, Alexey Khoroshilov wrote:

> oxu_qh_alloc() acquires oxu->mem_lock spinlock, finds free qh slot
> and calls ehci_qtd_alloc() to initialize qh->dummy, but
> ehci_qtd_alloc() acquires oxu->mem_lock as well.
> That means an unavoidable deadlock in oxu_qh_alloc().
> 
> The patch fixes the issue by introduction of unlocked version
> of ehci_qtd_alloc().

This deadlock would affect anybody the moment they plugged a USB device
into one of these controllers, right?

Which means nobody can possibly be using them under Linux.  So wouldn't
it be better to remove the driver entirely?

Alan Stern
 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/usb/host/oxu210hp-hcd.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
> index 036924e640f5..15d4cf2c35cd 100644
> --- a/drivers/usb/host/oxu210hp-hcd.c
> +++ b/drivers/usb/host/oxu210hp-hcd.c
> @@ -573,13 +573,11 @@ static inline void oxu_qtd_free(struct oxu_hcd *oxu, struct ehci_qtd *qtd)
>  	spin_unlock(&oxu->mem_lock);
>  }
>  
> -static struct ehci_qtd *ehci_qtd_alloc(struct oxu_hcd *oxu)
> +static struct ehci_qtd *ehci_qtd_alloc_unlocked(struct oxu_hcd *oxu)
>  {
>  	int i;
>  	struct ehci_qtd *qtd = NULL;
>  
> -	spin_lock(&oxu->mem_lock);
> -
>  	for (i = 0; i < QTD_NUM; i++)
>  		if (!oxu->qtd_used[i])
>  			break;
> @@ -598,6 +596,17 @@ static struct ehci_qtd *ehci_qtd_alloc(struct oxu_hcd *oxu)
>  		oxu->qtd_used[i] = 1;
>  	}
>  
> +	return qtd;
> +}
> +
> +static struct ehci_qtd *ehci_qtd_alloc(struct oxu_hcd *oxu)
> +{
> +	struct ehci_qtd *qtd;
> +
> +	spin_lock(&oxu->mem_lock);
> +
> +	qtd = ehci_qtd_alloc_unlocked(oxu);
> +
>  	spin_unlock(&oxu->mem_lock);
>  
>  	return qtd;
> @@ -651,7 +660,7 @@ static struct ehci_qh *oxu_qh_alloc(struct oxu_hcd *oxu)
>  		INIT_LIST_HEAD(&qh->qtd_list);
>  
>  		/* dummy td enables safe urb queuing */
> -		qh->dummy = ehci_qtd_alloc(oxu);
> +		qh->dummy = ehci_qtd_alloc_unlocked(oxu);
>  		if (qh->dummy == NULL) {
>  			oxu_dbg(oxu, "no dummy td\n");
>  			oxu->qh_used[i] = 0;
> 

