Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab3BGAz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:55:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab3BGAzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:55:24 -0500
Date: Wed, 6 Feb 2013 16:55:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: peter.senna@gmail.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] hlist: drop the node parameter from iterators
Message-Id: <20130206165522.ed6f10fc.akpm@linux-foundation.org>
In-Reply-To: <1359597622-31532-1-git-send-email-sasha.levin@oracle.com>
References: <1359597622-31532-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 21:00:22 -0500
Sasha Levin <sasha.levin@oracle.com> wrote:

> I'm not sure why, but the hlist for each entry iterators were conceived
> differently from the list ones. While the list ones are nice and elegant:
> 
>         list_for_each_entry(pos, head, member)
> 
> The hlist ones were greedy and wanted an extra parameter:
> 
>         hlist_for_each_entry(tpos, pos, head, member)
> 
> Why did they need an extra pos parameter? I'm not quite sure. Not only
> they don't really need it, it also prevents the iterator from looking
> exactly like the list iterator, which is unfortunate.
> 
> Besides the semantic patch, there was some manual work required:
> 
>  - Fix up the actual hlist iterators in linux/list.h
>  - Fix up the declaration of other iterators based on the hlist ones.
>  - A very small amount of places were using the 'node' parameter, this
>  was modified to use 'obj->member' instead.
>  - Coccinelle didn't handle the hlist_for_each_entry_safe iterator
>  properly, so those had to be fixed up manually.
>
> ...
>
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
>
> ...
>
> @@ -4525,7 +4524,7 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
>  	 * this is all done under the css_set_lock.
>  	 */
>  	write_lock(&css_set_lock);
> -	hash_for_each_safe(css_set_table, i, node, tmp, cg, hlist) {
> +	hash_for_each_safe(css_set_table, i, tmp, cg, hlist) {
>  		/* skip entries that we already rehashed */
>  		if (cg->subsys[ss->subsys_id])
>  			continue;

Problems in cgroup_load_subsys().

In linux-next, that function is now using the `node' storage which your
patch removes:

@@ -4503,23 +4525,17 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	 * this is all done under the css_set_lock.
 	 */
 	write_lock(&css_set_lock);
-	for (i = 0; i < CSS_SET_TABLE_SIZE; i++) {
-		struct css_set *cg;
-		struct hlist_node *node, *tmp;
-		struct hlist_head *bucket = &css_set_table[i], *new_bucket;
-
-		hlist_for_each_entry_safe(cg, node, tmp, bucket, hlist) {
-			/* skip entries that we already rehashed */
-			if (cg->subsys[ss->subsys_id])
-				continue;
-			/* remove existing entry */
-			hlist_del(&cg->hlist);
-			/* set new value */
-			cg->subsys[ss->subsys_id] = css;
-			/* recompute hash and restore entry */
-			new_bucket = css_set_hash(cg->subsys);
-			hlist_add_head(&cg->hlist, new_bucket);
-		}
+	hash_for_each_safe(css_set_table, i, node, tmp, cg, hlist) {
+		/* skip entries that we already rehashed */
+		if (cg->subsys[ss->subsys_id])
+			continue;
+		/* remove existing entry */
+		hash_del(&cg->hlist);
+		/* set new value */
+		cg->subsys[ss->subsys_id] = css;
+		/* recompute hash and restore entry */
+		key = css_set_hash(cg->subsys);
+		hash_add(css_set_table, node, key);     <<<<---- here
 	}
 	write_unlock(&css_set_lock);
 


This didn't show up (apart from a "used unintialized" warning) because
your patch forgot to remove the definition of `node'.

I did this.  Tejun, could you please opine?


@@ -4456,7 +4455,7 @@ int __init_or_module cgroup_load_subsys(
 {
 	struct cgroup_subsys_state *css;
 	int i, ret;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	struct css_set *cg;
 	unsigned long key;
 
@@ -4534,7 +4533,7 @@ int __init_or_module cgroup_load_subsys(
 		cg->subsys[ss->subsys_id] = css;
 		/* recompute hash and restore entry */
 		key = css_set_hash(cg->subsys);
-		hash_add(css_set_table, node, key);
+		hash_add(css_set_table, &cg->hlist, key);
 	}
 	write_unlock(&css_set_lock);
 

