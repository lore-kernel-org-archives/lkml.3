Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab3BGBAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:00:40 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:46894 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab3BGBAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:00:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130206165522.ed6f10fc.akpm@linux-foundation.org>
References: <1359597622-31532-1-git-send-email-sasha.levin@oracle.com>
	<20130206165522.ed6f10fc.akpm@linux-foundation.org>
Date: Wed, 6 Feb 2013 17:00:37 -0800
X-Google-Sender-Auth: wixYDxY247odVTy89xnmTF2aN_0
Message-ID: <CAOS58YOX+ZRSoWnGhQJz_StMfheJyJe=ZbKUEVr21AOkpKKBLw@mail.gmail.com>
Subject: Re: [PATCH v2] hlist: drop the node parameter from iterators
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, peter.senna@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Li)

On Wed, Feb 6, 2013 at 4:55 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> Problems in cgroup_load_subsys().
>
> In linux-next, that function is now using the `node' storage which your
> patch removes:
>
> @@ -4503,23 +4525,17 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
>          * this is all done under the css_set_lock.
>          */
>         write_lock(&css_set_lock);
> -       for (i = 0; i < CSS_SET_TABLE_SIZE; i++) {
> -               struct css_set *cg;
> -               struct hlist_node *node, *tmp;
> -               struct hlist_head *bucket = &css_set_table[i], *new_bucket;
> -
> -               hlist_for_each_entry_safe(cg, node, tmp, bucket, hlist) {
> -                       /* skip entries that we already rehashed */
> -                       if (cg->subsys[ss->subsys_id])
> -                               continue;
> -                       /* remove existing entry */
> -                       hlist_del(&cg->hlist);
> -                       /* set new value */
> -                       cg->subsys[ss->subsys_id] = css;
> -                       /* recompute hash and restore entry */
> -                       new_bucket = css_set_hash(cg->subsys);
> -                       hlist_add_head(&cg->hlist, new_bucket);
> -               }
> +       hash_for_each_safe(css_set_table, i, node, tmp, cg, hlist) {
> +               /* skip entries that we already rehashed */
> +               if (cg->subsys[ss->subsys_id])
> +                       continue;
> +               /* remove existing entry */
> +               hash_del(&cg->hlist);
> +               /* set new value */
> +               cg->subsys[ss->subsys_id] = css;
> +               /* recompute hash and restore entry */
> +               key = css_set_hash(cg->subsys);
> +               hash_add(css_set_table, node, key);     <<<<---- here
>         }
>         write_unlock(&css_set_lock);
>
>
>
> This didn't show up (apart from a "used unintialized" warning) because
> your patch forgot to remove the definition of `node'.
>
> I did this.  Tejun, could you please opine?
>
>
> @@ -4456,7 +4455,7 @@ int __init_or_module cgroup_load_subsys(
>  {
>         struct cgroup_subsys_state *css;
>         int i, ret;
> -       struct hlist_node *node, *tmp;
> +       struct hlist_node *tmp;
>         struct css_set *cg;
>         unsigned long key;
>
> @@ -4534,7 +4533,7 @@ int __init_or_module cgroup_load_subsys(
>                 cg->subsys[ss->subsys_id] = css;
>                 /* recompute hash and restore entry */
>                 key = css_set_hash(cg->subsys);
> -               hash_add(css_set_table, node, key);
> +               hash_add(css_set_table, &cg->hlist, key);
>         }
>         write_unlock(&css_set_lock);

Yeah, looks correct & better to me.  Li?

Maybe we want to audit all the cases where the @node variable isn't
removed together?

Thanks.

-- 
tejun
