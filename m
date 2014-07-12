Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaGLGar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 02:30:47 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62003 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaGLGaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 02:30:46 -0400
Date: Fri, 11 Jul 2014 23:30:41 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Bean Huo =?utf-8?B?6ZyN5paM5paMIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "b32955@freescale.com" <b32955@freescale.com>,
        Christian Riesch <christian.riesch@omicron.at>
Subject: Re: [PATCH v3] mtd:nor:timeout:fix do_write_buffer() timeout error
Message-ID: <20140712063041.GB23883@brian-ubuntu>
References: <A765B125120D1346A63912DDE6D8B6315D75AB@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315D75AB@NTXXIAMBX02.xacn.micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bean,

I see that you have sent this several times in a relatively short
period, and I see that there are several comments you haven't addressed
[1] [2].

It is very difficult for me to apply your patch. It seems to be an
invalid patch (I think the line counts are wrong), so it doesn't apply
with git-am. Christian already had this problem in [1]. Can you try
sending mail with git-send-email? It will probably do better than your
current mailer. If you're having any doubt, try sending the patch to
yourself and then applying it with git-am.
Documentation/email-clients.txt also has some tips for email.

Your patch also has several coding style issues, one of which Christian
also noticed, in [2]. (Thanks for reviewing, BTW, Chrisitan!)

Can you fix the subject to follow other patches' style? Like:

  mtd: cfi_cmdset_0002: ...

(I can fix one or two patches for these kind of things, but you said you
plan to send several more patches.)

On Mon, Jun 30, 2014 at 07:56:37AM +0000, Bean Huo 霍斌斌 (beanhuo) wrote:
> The size of the buffer program has been increased from 256 to 512 , 2ms maximum timeout for do_write_buffer can not adapt to all the different vendor's norflash.There maximum timeout information in the CFI area,so the best way is to choose the result calculated according to timeout field of struct cfi_ident that probed from norflash's CFI aera.This is also a standard defined by CFI.

Please line-wrap your commit descriptions. This line is >300 characters
long.

> 
> Without this change, if the size of buffer program is 512 or bigger than 256, due to timeout is the shorter than that the chip required,do_write_buffer sometimes fails.
> 
> Tested with Micron JS28F512M29EWx and Micron MT28EW512ABA flash devices.
> 
> Signed-off-by: bean huo <beanhuo@micron.com>
> ---
> changes 
> 	v1->v2:Deleted unused parameters in this patch (word_write_time_max and erase_time_max).
> Using usecs_to_jiffies instead of msecs_to_jiffies for convert timeout value into jiffies.
> 	v2->v3:Removed unnecessary messages form comments and deleted trailing whitespace.
> 
>  drivers/mtd/chips/cfi_cmdset_0002.c |   27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
> index e21fde9..f7098d6 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -628,10 +628,24 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)
>  		cfi->chips[i].word_write_time = 1<<cfi->cfiq->WordWriteTimeoutTyp;
>  		cfi->chips[i].buffer_write_time = 1<<cfi->cfiq->BufWriteTimeoutTyp;
>  		cfi->chips[i].erase_time = 1<<cfi->cfiq->BlockEraseTimeoutTyp;
> +		/*
> +		 * We first calculate the timeout max according to timeout
> +		 * field of struct cfi_ident that probed from chip's CFI
> +		 * aera,If haven't probed this information,we will specify
> +		 * a default value,and the time unit is us.
> +		 */
> +		if (cfi->cfiq->BufWriteTimeoutTyp &&
> +			cfi->cfiq->BufWriteTimeoutMax){

Can you put a space before the brace?

> +			cfi->chips[i].buffer_write_time_max =
> +				1<<(cfi->cfiq->BufWriteTimeoutTyp +

Please put spaces around the shift operator.

> +					cfi->cfiq->BufWriteTimeoutMax);
> +			} else {
> +			/* specify maximum timeout for buffer program 2000us */
> +				cfi->chips[i].buffer_write_time_max = 2000;
> +				}

The indentation of this entire 'else' block is wrong.

>  		cfi->chips[i].ref_point_counter = 0;
>  		init_waitqueue_head(&(cfi->chips[i].wq));
>  	}
> -

Please don't remove this line.

>  	map->fldrv = &cfi_amdstd_chipdrv;
>  
>  	return cfi_amdstd_setup(mtd);
> @@ -1462,8 +1476,15 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,  {
>  	struct cfi_private *cfi = map->fldrv_priv;
>  	unsigned long timeo = jiffies + HZ;
> -	/* see comments in do_write_oneword() regarding uWriteTimeo. */
> -	unsigned long uWriteTimeout = ( HZ / 1000 ) + 1;
> +	/* There maximum timeout information in the CFI area,so the
> +	 * best way is to choose the result calculated according to
> +	 * timeout field of struct cfi_ident that probed from
> +	 * norflash's CFI aera,see comments in cfi_cmdset_0002().
> +	 * uWriteTimeout is used for timeout step,it must be concerted
> +	 * into jiffies.

Some of the language here needs improvement, but I can spruce it up once
your patch is ready. Just fix the style up a bit, and make sure the
patch can apply, then I'll take care of the rest. Thanks!

> +	 */
> +	unsigned long uWriteTimeout =
> +				usecs_to_jiffies(chip->buffer_write_time_max);
>  	int ret = -EIO;
>  	unsigned long cmd_adr;
>  	int z, words;
> --
> 1.7.9.5

Brian

[1] http://lists.infradead.org/pipermail/linux-mtd/2014-June/054362.html
[2] http://lists.infradead.org/pipermail/linux-mtd/2014-June/054367.html
