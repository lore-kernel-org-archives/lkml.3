Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3I0Toe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:44:34 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750981Ab3I0Toc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:44:32 -0400
Message-ID: <5245E01D.3020104@nod.at>
Date: Fri, 27 Sep 2013 21:44:29 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: fastmap: fix a mem leak on error path
References: <1380296235-24194-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1380296235-24194-1-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.09.2013 17:37, schrieb Richard Genoud:
> If the scan_pool() function fails, the "free" list is not freed.
> This leads to destroy_ai(ai) complaining with:
> "kmem_cache_destroy ubi_ainf_peb_slab: Slab cache still has objects"

Hmm, I *think* we need to take care about used and eba_orphans too.
Tomorrow I'll have time to investigate...

Thanks,
//richard

> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>  drivers/mtd/ubi/fastmap.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
> index 05067f5..22eb527 100644
> --- a/drivers/mtd/ubi/fastmap.c
> +++ b/drivers/mtd/ubi/fastmap.c
> @@ -841,6 +841,10 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
>  fail_bad:
>  	ret = UBI_BAD_FASTMAP;
>  fail:
> +	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
> +		kmem_cache_free(ai->aeb_slab_cache, tmp_aeb);
> +		list_del(&tmp_aeb->u.list);
> +	}
>  	return ret;
>  }
>  
> 

