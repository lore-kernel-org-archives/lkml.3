Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592Ab3LHRbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 12:31:24 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:42641 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3LHRbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 12:31:21 -0500
Message-ID: <52A4BAF6.501@cogentembedded.com>
Date: Sun, 08 Dec 2013 21:31:18 +0300
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
Subject: Re: [PATCH v4 1/3] usb: ohci-at91: replace request_mem_region + ioremap
 by devm_ioremap_resource
References: <1386514980-6383-1-git-send-email-b.brezillon@overkiz.com> <1386514980-6383-2-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1386514980-6383-2-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/08/2013 06:02 PM, Boris BREZILLON wrote:

> Replace the request_mem_region + ioremap calls by the
> devm_ioremap_resource call which does the same things but with device
> managed resources.

> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>   drivers/usb/host/ohci-at91.c |   28 +++++++---------------------
>   1 file changed, 7 insertions(+), 21 deletions(-)

> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index 8c356af..fe2ecc5 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -158,24 +158,18 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>   	hcd->rsrc_start = res->start;
>   	hcd->rsrc_len = resource_size(res);
>
> -	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
> -		pr_debug("request_mem_region failed\n");
> -		retval = -EBUSY;
> -		goto err1;
> -	}
> -
> -	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
> -	if (!hcd->regs) {
> -		pr_debug("ioremap failed\n");
> -		retval = -EIO;
> -		goto err2;
> +	hcd->regs = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(hcd->regs)) {
> +		dev_dbg(dev, "devm_ioremap_resource failed\n");

    I've already told you devm_ioremap_resource() prints the detailed error 
message. No need to duplicate it.

> +		retval = PTR_ERR(hcd->regs);
> +		goto err;
>   	}

WBR, Sergei

