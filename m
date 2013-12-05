Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3LETd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:33:57 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:63153 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3LETd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:33:56 -0500
Message-ID: <52A0E334.5080002@cogentembedded.com>
Date: Thu, 05 Dec 2013 23:33:56 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/3] usb: ohci-at91: replace request_mem_region + ioremap
 by devm_request_and_ioremap
References: <1386237282-22385-1-git-send-email-b.brezillon@overkiz.com> <1386237282-22385-2-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1386237282-22385-2-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/05/2013 12:54 PM, Boris BREZILLON wrote:

> Replace the request_mem_region + ioremap calls by the
> devm_request_and_ioremap call which does the same things but with device
> managed resources.

> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>   drivers/usb/host/ohci-at91.c |   24 +++++-------------------
>   1 file changed, 5 insertions(+), 19 deletions(-)

> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index 7aec6ca..8528895 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -157,24 +157,18 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>   	hcd->rsrc_start = mem_r->start;
>   	hcd->rsrc_len = resource_size(mem_r);
>
> -	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
> -		pr_debug("request_mem_region failed\n");
> -		retval = -EBUSY;
> -		goto err1;
> -	}
> -
> -	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
> +	hcd->regs = devm_request_and_ioremap(dev, mem_r);

    This function is already deprecated, use devm_ioremap_resource() instead 
(it returns error pointer, not NULL on error).

>   	if (!hcd->regs) {
> -		pr_debug("ioremap failed\n");
> +		dev_dbg(dev, "devm_request_and_ioremap failed\n");

    There's no need -- those functions print error messages themselves.

>   		retval = -EIO;
> -		goto err2;
> +		goto err;
>   	}
[...]

WBR, Sergei

