Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3I3IOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:14:11 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:61098 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3I3IOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:14:08 -0400
MIME-Version: 1.0
In-Reply-To: <1380376516-30144-7-git-send-email-richard@nod.at>
References: <1380376516-30144-1-git-send-email-richard@nod.at> <1380376516-30144-7-git-send-email-richard@nod.at>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 30 Sep 2013 10:13:46 +0200
Message-ID: <CACQ1gAiAO5JB0vEW1pS=qWrUUjfPkOhp_5RdNMK0bm3-A1Bwbg@mail.gmail.com>
Subject: Re: [PATCH 6/7] UBI: Fix memory leak in ubi_attach_fastmap() error path
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/9/28 Richard Weinberger <richard@nod.at>:
> On error we have to free all three temporary lists.
>
> Reported-by: Richard Genoud <richard.genoud@gmail.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/fastmap.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
> index 05067f5..4cfc8da 100644
> --- a/drivers/mtd/ubi/fastmap.c
> +++ b/drivers/mtd/ubi/fastmap.c
> @@ -841,6 +841,19 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
>  fail_bad:
>         ret = UBI_BAD_FASTMAP;
>  fail:
> +       list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &used, u.list) {
> +               kmem_cache_free(ai->aeb_slab_cache, tmp_aeb);
> +               list_del(&tmp_aeb->u.list);
> +       }
> +       list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &eba_orphans, u.list) {
> +               kmem_cache_free(ai->aeb_slab_cache, tmp_aeb);
> +               list_del(&tmp_aeb->u.list);
> +       }
> +       list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
> +               kmem_cache_free(ai->aeb_slab_cache, tmp_aeb);
> +               list_del(&tmp_aeb->u.list);
> +       }
> +
>         return ret;
>  }
>
> --
> 1.8.3.1
>

Works like a charm !
Tested-by: Richard Genoud <richard.genoud@gmail.com>


Thanks !
