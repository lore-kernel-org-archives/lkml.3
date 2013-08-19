Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912Ab3HSO3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:29:41 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43380 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3HSO3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:29:38 -0400
Message-ID: <52122BD1.2090406@cogentembedded.com>
Date: Mon, 19 Aug 2013 18:29:37 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: =?ISO-8859-1?Q?Svenning_S=F8rensen?= <sss@secomea.dk>,
        Felipe Balbi <balbi@ti.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6 v2] usb: musb: dsps: simplify platform_get_resource_byname/devm_ioremap_resource
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr> <1376902316-18520-5-git-send-email-Julia.Lawall@lip6.fr> <5211FED3.4090102@secomea.dk> <alpine.DEB.2.02.1308191346390.2313@hadrien>
In-Reply-To: <alpine.DEB.2.02.1308191346390.2313@hadrien>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/19/2013 03:47 PM, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>

> Remove unneeded error handling on the result of a call to
> platform_get_resource_byname when the value is passed to
> devm_ioremap_resource.

> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)

> // <smpl>
> @@
> expression pdev,res,e,e1;
> expression ret != 0;
> identifier l;
> @@
>
>    res = platform_get_resource_byname(...);
> - if (res == NULL) { ... \(goto l;\|return ret;\) }
>    e = devm_ioremap_resource(e1, res);
> // </smpl>

> This patch also adjusts the error-handling code on the call to
> devm_ioremap_resource to check the right value, noticed by Svenning Sørensen.

    Saying "also" in the changelog is usuallly a good sign the patch should be 
split.

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

> ---
> v2: Fixed the bug on the test of the result of devm_ioremap_resource

>   drivers/usb/musb/musb_dsps.c |    7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> index 4ffbaac..e60be6f 100644
> --- a/drivers/usb/musb/musb_dsps.c
> +++ b/drivers/usb/musb/musb_dsps.c
> @@ -357,12 +357,9 @@ static int dsps_musb_init(struct musb *musb)
>   	u32 rev, val;
>
>   	r = platform_get_resource_byname(parent, IORESOURCE_MEM, "control");
> -	if (!r)
> -		return -EINVAL;
> -
>   	reg_base = devm_ioremap_resource(dev, r);
> -	if (!musb->ctrl_base)
> -		return -EINVAL;
> +        if (IS_ERR(reg_base))
> +		return PTR_ERR(reg_base);

    This is indented with space, not tabs. And of course, this was a matter of 
a separate *fix* patch, while the original patch was a *cleanup*.

WBR, Sergei

