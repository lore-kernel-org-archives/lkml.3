Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab3HMOuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:50:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60442 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757619Ab3HMOux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:50:53 -0400
Date: Tue, 13 Aug 2013 11:50:43 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Nilanjan Roychowdhury <nilanjan.roychowdhury@gmail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Resubmit mtd: mtdoops: fix for a potential memory
 leak in mtdoops_notify_remove
Message-ID: <20130813145041.GB2359@localhost>
References: <1376369315-5170-1-git-send-email-nilanjan.roychowdhury@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376369315-5170-1-git-send-email-nilanjan.roychowdhury@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nilanjan,

On Mon, Aug 12, 2013 at 09:48:35PM -0700, Nilanjan Roychowdhury wrote:
> we are allocating cxt->oops_page_used using vmalloc in mtdoops_notify_add for
> every mtd_info addition but not freeing it in mtdoops_notify_remove. Also care is
> taken so that we do not free the same pointer again in module remove.
> 

Could you re-send this with a better commit message?

In particular we'd like to see why you're doing this, explaining
how the current implementation implies a possible leak, explaining under
what circumstance this leak.

I think it would be great if you could test the patch and also add
some information about the testing scenario.

Please note the subject should be "[PATCH v2] mtd: ...", with a
proper patch version number. The next patch will be v3 (and so on) which
should be stated in the subject.

Also...

> Signed-off-by: Nilanjan Roychowdhury <nilanjan.roychowdhury@gmail.com>
> ---

In this place (between the "---" and the diffstat) you can put some
changelog information, like this:

Changes from v2:
 * Did this and that.

Changes from v1:
 * Added check to vfree() in remove function as suggested by Ezequiel.

>  drivers/mtd/mtdoops.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
> index 97bb8f6..4b8b621 100644
> --- a/drivers/mtd/mtdoops.c
> +++ b/drivers/mtd/mtdoops.c
> @@ -386,6 +386,8 @@ static void mtdoops_notify_remove(struct mtd_info *mtd)
>  	cxt->mtd = NULL;
>  	flush_work(&cxt->work_erase);
>  	flush_work(&cxt->work_write);
> +	vfree(cxt->oops_page_used);
> +	cxt->oops_page_used = NULL;
>  }
>  
>  
> @@ -439,7 +441,8 @@ static void __exit mtdoops_exit(void)
>  
>  	unregister_mtd_user(&mtdoops_notifier);
>  	vfree(cxt->oops_buf);
> -	vfree(cxt->oops_page_used);
> +	if (cxt->oops_page_used)
> +		vfree(cxt->oops_page_used);
>  }
>  
>  
> -- 
> 1.7.9.5
> 

Thanks!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
