Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951AbaH0UON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:14:13 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:34416 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964818AbaH0UOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:14:12 -0400
From: Michal Sojka <sojka@merica.cz>
To: linux-usb@vger.kernel.org
Cc: Bryan Wu <cooloney@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz
Subject: Re: [PATCH v3 1/2] usb: gadget: Refactor request completion
In-Reply-To: <1409144625-25274-2-git-send-email-sojka@merica.cz>
References: <CAK5ve-Jz7=7uZ3_Qg2bAH9BiGRZ36k-Oj9TNZ-_nAvaq6LGbjA@mail.gmail.com> <1409144625-25274-1-git-send-email-sojka@merica.cz> <1409144625-25274-2-git-send-email-sojka@merica.cz>
User-Agent: Notmuch/0.18.1+70~ge8d943c (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 27 Aug 2014 15:43:26 +0200
Message-ID: <87egw2m4jl.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27 2014, Michal Sojka wrote:
> All USB peripheral controller drivers called completion routines
> directly. This patch moves the completion call from drivers to
> usb_gadget_giveback_request(), in order to have a place where common
> functionality can be added.
>
> All places in drivers/usb/ matching "[-.]complete(" were replaced with a
> call to usb_gadget_giveback_request(). This was compile-tested with all
> ARM drivers enabled and runtime-tested for musb.

[...]

> diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
> index b0d9817..2eb0ae4 100644
> --- a/drivers/usb/gadget/udc/udc-core.c
> +++ b/drivers/usb/gadget/udc/udc-core.c
> @@ -102,6 +102,15 @@ void usb_gadget_unmap_request(struct usb_gadget *gadget,
>  }
>  EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
>  
> +void usb_gadget_giveback_request(struct usb_ep *ep,
> +		struct usb_request *req)
> +{
> +	/* complete() is from gadget layer,
> +	 * eg fsg->bulk_in_complete() */
> +	if (req->complete)
> +		req->complete(ep, req);
> +}
> +EXPORT_SYMBOL_GPL(usb_gadget_giveback_request);
>  #endif	/* CONFIG_HAS_DMA */

#endif should be before usb_gadget_giveback_request(). I'll fix this in
v4.

-Michal
