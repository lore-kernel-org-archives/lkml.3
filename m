Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965641AbaGPSE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:04:29 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52444 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965602AbaGPSE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:04:28 -0400
Date: Wed, 16 Jul 2014 11:04:23 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Bean Huo <beanhuo@outlook.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Huang Shijie <b32955@freescale.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-mtd@lists.infradead.org, christian.riesch@omicron.at
Subject: Re: [PATCH v6] mtd:nor:timeout:fix do_write_buffer() timeout error
Message-ID: <20140716180423.GV7537@ld-irv-0074>
References: <BLU436-SMTP223B6F83933407357F0FF3BA6F70@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU436-SMTP223B6F83933407357F0FF3BA6F70@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bean,

On Wed, Jul 16, 2014 at 09:05:26AM -0700, Bean Huo wrote:
> From: bean huo <beanhuo@outlook.com>
> 
> For some Norflashes,the size of the buffer program has been
> increased from 256 bytes to 512 bytes,2ms maximum timeout can
> not adapt to all the different vendor's norflash.There maximum
> timeout information in the CFI area,so the best way is to choose
> the result calculated according to timeout field of struct cfi_ident
> that probed from norflash's CFI aera.This is also a standard defined
> by CFI.If haven't probed this information,or smaller than 2000us,then
> specify a defualt value 2000us.
> 
> Tested with Micron JS28F512M29EWx and Micron MT28EW512ABA flash devices.
> 
> Signed-off-by: bean huo <beanhuo@outlook.com>
> ---
> 	v1->v2:Deleted unused parameters in this patch(word_write_time_max and erase_time_max).
> 	Using usecs_to_jiffies instead of msecs_to_jiffies for convert timeout value into jiffies.
> 	v2->v3:Removed unnecessary messages form comments and deleted trailing whitespace.
> 	V3->v4:If haven't probed timeout information,or smaller than 2000us,specify default 2000us.
> 	v4->v5:Add space before '>='
> 	v5->v6:Add the same indentation as 'if' at the front of 'else'
> 
>  drivers/mtd/chips/cfi_cmdset_0002.c |   29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
> index e21fde9..aed6f9e 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -628,6 +628,25 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)
[...]
> +		cfi->chips[i].buffer_write_time_max =
> +			((cfi->chips[i].buffer_write_time_max >= 2000)
> +			 ? cfi->chips[i].buffer_write_time_max : 2000);

This should just use the 'max()' macro, from <linux/kernel.h>.

> +
>  		cfi->chips[i].ref_point_counter = 0;
>  		init_waitqueue_head(&(cfi->chips[i].wq));
>  	}

I have just fixed up your patch myself, to use max() and to improve some
of the language. Let me know if the below works for you.

>From 6534e6809e6c9d48114b537afe03bee3fd33bf01 Mon Sep 17 00:00:00 2001
From: Bean Huo <beanhuo@outlook.com>
Date: Wed, 16 Jul 2014 09:05:26 -0700
Subject: [PATCH] mtd: cfi_cmdset_0002: fix do_write_buffer() timeout error

For some NOR flashes, the size of the buffer program has been increased
from 256 bytes to 512 bytes, and so 2ms maximum timeout can may not be
sufficient for all different vendor's NOR flash. There is maximum
timeout information in the CFI area, so we instead of picking a fixed
value, we can calculate this according to the standard CFI parameters
parsed at probe time. If we haven't probed this information, or it is
smaller than 2000us, then specify a minimum value 2000us.

Tested with Micron JS28F512M29EWx and Micron MT28EW512ABA flash devices.

Signed-off-by: Bean Huo <beanhuo@outlook.com>
[Brian: fix up comments, use 'max()']
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index bf313be6ee26..5a4bfe33112a 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -645,6 +645,23 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)
 		cfi->chips[i].word_write_time = 1<<cfi->cfiq->WordWriteTimeoutTyp;
 		cfi->chips[i].buffer_write_time = 1<<cfi->cfiq->BufWriteTimeoutTyp;
 		cfi->chips[i].erase_time = 1<<cfi->cfiq->BlockEraseTimeoutTyp;
+		/*
+		 * First calculate the timeout max according to timeout field
+		 * of struct cfi_ident that probed from chip's CFI aera, if
+		 * available. Specify a minimum of 2000us, in case the CFI data
+		 * is wrong.
+		 */
+		if (cfi->cfiq->BufWriteTimeoutTyp &&
+		    cfi->cfiq->BufWriteTimeoutMax)
+			cfi->chips[i].buffer_write_time_max =
+				1 << (cfi->cfiq->BufWriteTimeoutTyp +
+				      cfi->cfiq->BufWriteTimeoutMax);
+		else
+			cfi->chips[i].buffer_write_time_max = 0;
+
+		cfi->chips[i].buffer_write_time_max =
+			max(cfi->chips[i].buffer_write_time_max, 2000);
+
 		cfi->chips[i].ref_point_counter = 0;
 		init_waitqueue_head(&(cfi->chips[i].wq));
 	}
@@ -1774,8 +1791,12 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,
 {
 	struct cfi_private *cfi = map->fldrv_priv;
 	unsigned long timeo = jiffies + HZ;
-	/* see comments in do_write_oneword() regarding uWriteTimeo. */
-	unsigned long uWriteTimeout = ( HZ / 1000 ) + 1;
+	/*
+	 * Timeout is calculated according to CFI data, if available.
+	 * See more comments in cfi_cmdset_0002().
+	 */
+	unsigned long uWriteTimeout =
+				usecs_to_jiffies(chip->buffer_write_time_max);
 	int ret = -EIO;
 	unsigned long cmd_adr;
 	int z, words;
-- 
1.9.1

