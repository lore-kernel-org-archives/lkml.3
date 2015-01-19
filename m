Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbbASFTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 00:19:10 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54591 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbbASFTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 00:19:08 -0500
Message-ID: <54BC93C3.7010808@hitachi.com>
Date: Mon, 19 Jan 2015 14:18:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
References: <1421600146.2080.8.camel@HansenPartnership.com>
In-Reply-To: <1421600146.2080.8.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/19 1:55), James Bottomley wrote:
> From: James Bottomley <JBottomley@Parallels.com>
> 
> After e513cc1 module: Remove stop_machine from module unloading,
> module_refcount() is returning (unsigned long)-1 when called from within
> a routine that runs in module_exit.  This is confusing the scsi device
> put code which is coded to detect a module_refcount() of zero for
> running within a module exit routine and not try to do another
> module_put.  The fix is to restore the original behaviour of
> module_refcount() and return zero if we're running inside an exit
> routine.
> 
> Fixes: e513cc1c07e2ab93a4514eec9833e031df3e30bb
> Reported-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> 

Yes, this should be fixed as you said, since it must return "unsigned long" value.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Just one comment below;

> diff --git a/kernel/module.c b/kernel/module.c
> index 3965511..c33a113 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -774,7 +774,12 @@ static int try_stop_module(struct module *mod, int flags, int *forced)
>  
>  unsigned long module_refcount(struct module *mod)
>  {
> -	return (unsigned long)atomic_read(&mod->refcnt) - MODULE_REF_BASE;
> +	unsigned long ret = atomic_read(&mod->refcnt);
> +
> +	if (ret == 0)

This would better be "if (unlikely(ret == 0))".

Thank you,

> +		/* ref is already zero (probably in module exit) */
> +		return 0;
> +	return ret - MODULE_REF_BASE;
>  }
>  EXPORT_SYMBOL(module_refcount);
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


