Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaJ1WZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:25:17 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47029 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaJ1WZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:25:15 -0400
Date: Tue, 28 Oct 2014 15:25:11 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Andrea Adami <andrea.adami@gmail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Christian Riesch <christian.riesch@omicron.at>,
        Jingoo Han <jg1.han@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: cfi_cmdset_0001.c: fix resume for LH28F640BF chips
Message-ID: <20141028222511.GB23619@ld-irv-0074>
References: <1414020181-8855-1-git-send-email-andrea.adami@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414020181-8855-1-git-send-email-andrea.adami@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 01:23:01AM +0200, Andrea Adami wrote:
> After '#echo mem > /sys/power/state' some devices can not be properly resumed
> because apparently the MTD Partition Configuration Register has been reset
> to default thus the rootfs cannot be mounted cleanly on resume.
> An example of this can be found in the SA-1100 Developer's Manual at 9.5.3.3
> where the second step of the Sleep Shutdown Sequence is described:
> "An internal reset is applied to the SA-1100. All units are reset...".
> 
> As workaround we refresh the PCR value as done initially on chip setup.
> 
> This behavior and the fix are confirmed by our tests done on 2 different Zaurus
> collie units with kernel 3.17.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Signed-off-by: Andrea Adami <andrea.adami@gmail.com>

Who's the author? I have a 'From' header (which becomes the patch
author) of Andrea, but the sign-off is Dmitry. If you add a
'From: xxx <yyy@zzz.tld>' line to the beginning of the email, that can
clarify the author, even when the author is not emailing.

git-send-email will also handle that for you, if the original git commit
has the proper author.

> ---
>  drivers/mtd/chips/cfi_cmdset_0001.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
> index a7543ba..59e2355 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0001.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0001.c
> @@ -2590,6 +2590,8 @@ static void cfi_intelext_resume(struct mtd_info *mtd)
>  
>  		/* Go to known state. Chip may have been power cycled */
>  		if (chip->state == FL_PM_SUSPENDED) {
> +			/* Refresh LH28F640BF Partition Config. Register */
> +			fixup_LH28F640BF(mtd);

OK, that looks fine.

But while we're at it, it seems like any chip which has a boot-time
fixup hook in cfi_fixup_table[] should be run at resume time, since
those chips may have lost power too. For instance, it looks like
fixup_unlock_powerup_lock() would need rerun.

I'm not sure if we should do a more invasive patch like that without any
testing, though.

>  			map_write(map, CMD(0xFF), cfi->chips[i].start);
>  			chip->oldstate = chip->state = FL_READY;
>  			wake_up(&chip->wq);

Brian
