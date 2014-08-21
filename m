Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaHUI0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:26:16 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:46140 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbaHUI0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:26:10 -0400
Date: Thu, 21 Aug 2014 09:26:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Samuel Ortiz <sameo@linux.intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: menelaus: fix error return code
Message-ID: <20140821082605.GS4266@lee--X1>
References: <1407355938-10932-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407355938-10932-2-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2014, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert a zero return value on error to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> 
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/mfd/menelaus.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> index 5e2667a..16070d8 100644
> --- a/drivers/mfd/menelaus.c
> +++ b/drivers/mfd/menelaus.c
> @@ -1240,8 +1240,10 @@ static int menelaus_probe(struct i2c_client *client,
>  	pr_info("Menelaus rev %d.%d\n", rev >> 4, rev & 0x0f);
>  
>  	val = menelaus_read_reg(MENELAUS_VCORE_CTRL1);
> -	if (val < 0)
> +	if (val < 0) {
> +		err = val;
>  		goto fail;
> +	}

I'd prefer it if you could s/val/err and remove val altogether.  While
you're there, if you can s/(1 << 7)/BIT(7), that would be great
too.  If you don't have time, or just don't want to do it, I will be
happy to submit a patch instead with your Reported-by.  Your call.

>  	if (val & (1 << 7))
>  		menelaus->vcore_hw_mode = 1;
>  	else
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
