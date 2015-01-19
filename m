Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbbASKvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:51:42 -0500
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:48836 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbbASKvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:51:41 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54BCE1BA.1050608@mev.co.uk>
Date: Mon, 19 Jan 2015 10:51:38 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] comedi: rtd520: if condition with no effect - if
 identical to else
References: <1421582004-2398-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1421582004-2398-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/01/15 11:53, Nicholas Mc Guire wrote:
> The if and the else branch code are identical - so the condition has no
> effect on the effective code - this patch removes the condition and the
> duplicated code.
>
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>
> Patch is against 3.19.0-rc4 -next-20150116
>
> This patch was only compile tested with x86_64_defconfig + CONFIG_STAGING=y
> CONFIG_COMEDI=m, CONFIG_COMEDI_PCI_DRIVERS=m, CONFIG_COMEDI_RTD520=m
>
> commit c5930d66 (staging: comedi: rtd520: use the comedi_device 'mmio'
> member) introduced the current code, the probably bug was though
> present before this commit:
>
>          if (devpriv->xfer_count > 0)    /* transfer every N samples */
>                  writew(IRQM_ADC_ABOUT_CNT, dev->mmio + LAS0_IT);
>          else                            /* 1/2 FIFO transfers */
>                  writew(IRQM_ADC_ABOUT_CNT, dev->mmio + LAS0_IT);
>
> as the if and else branch are identical but the comments indicate that
> they are serving different purposes this looks like a bug. The code has
> though been in use in this form for more than 2 years - so maybe the
> condition is simply unnecessary. In any case this needs a review
> by someone who knows the details of the driver - the below patch
> is only cleaning up the current situation and may thus be wrong.
>
> ...and how did this pass multiple modifications and reviews ?...

The two halves used to output different kernel debug messages which were 
removed in commit d62bc468.  Prior to that, in commit 60aeb080, a whole 
bunch of unused #ifdef code was removed, which made the 'else' branch 
the same as the 'if' branch, apart from the debug messages, as can be 
seen here around line 1319 on the left side:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/staging/comedi/drivers/?id=60aeb08024dcd8a392917ab72a107ad451a59030&context=5&ignorews=0&dt=1

>
>   drivers/staging/comedi/drivers/rtd520.c |    6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
> index 06ae436..3ccdade 100644
> --- a/drivers/staging/comedi/drivers/rtd520.c
> +++ b/drivers/staging/comedi/drivers/rtd520.c
> @@ -1012,10 +1012,8 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
>   	readw(dev->mmio + LAS0_CLEAR);
>
>   	/* TODO: allow multiple interrupt sources */
> -	if (devpriv->xfer_count > 0)	/* transfer every N samples */
> -		writew(IRQM_ADC_ABOUT_CNT, dev->mmio + LAS0_IT);
> -	else				/* 1/2 FIFO transfers */
> -		writew(IRQM_ADC_ABOUT_CNT, dev->mmio + LAS0_IT);
> +	/* transfer every N samples */
> +	writew(IRQM_ADC_ABOUT_CNT, dev->mmio + LAS0_IT);
>
>   	/* BUG: start_src is ASSUMED to be TRIG_NOW */
>   	/* BUG? it seems like things are running before the "start" */
>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
