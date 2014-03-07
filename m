Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaCGGSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:18:12 -0500
Received: from relay.parallels.com ([195.214.232.42]:47067 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaCGGSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:18:10 -0500
Message-ID: <5319649C.3060309@parallels.com>
Date: Fri, 7 Mar 2014 10:18:04 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cl@linux-foundation.org>, <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: slub: fix leak of 'name' in sysfs_slab_add
References: <20140306211141.GA17009@redhat.com>
In-Reply-To: <20140306211141.GA17009@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Andrew to Cc]

On 03/07/2014 01:11 AM, Dave Jones wrote:
> The failure paths of sysfs_slab_add don't release the allocation of 'name'
> made by create_unique_id() a few lines above the context of the diff below.
> Create a common exit path to make it more obvious what needs freeing.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 25f14ad8f817..b2181d2682ac 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5197,17 +5197,13 @@ static int sysfs_slab_add(struct kmem_cache *s)
>  
>  	s->kobj.kset = slab_kset;
>  	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
> -	if (err) {
> -		kobject_put(&s->kobj);
> -		return err;
> -	}
> +	if (err)
> +		goto err_out;
>  
>  	err = sysfs_create_group(&s->kobj, &slab_attr_group);
> -	if (err) {
> -		kobject_del(&s->kobj);
> -		kobject_put(&s->kobj);
> -		return err;
> -	}
> +	if (err)
> +		goto err_sysfs;
> +
>  	kobject_uevent(&s->kobj, KOBJ_ADD);
>  	if (!unmergeable) {
>  		/* Setup first alias */
> @@ -5215,6 +5211,13 @@ static int sysfs_slab_add(struct kmem_cache *s)
>  		kfree(name);
>  	}
>  	return 0;
> +
> +err_sysfs:
> +	kobject_del(&s->kobj);
> +err_out:
> +	kobject_put(&s->kobj);
> +	kfree(name);
> +	return err;
>  }

We should free the name only if !unmergeable, because:

sysfs_slab_add():
	if (unmergeable) {
		/*
		 * Slabcache can never be merged so we can use the name proper.
		 * This is typically the case for debug situations. In that
		 * case we can catch duplicate names easily.
		 */
		sysfs_remove_link(&slab_kset->kobj, s->name);
		name = s->name;
	} else {
		/*
		 * Create a unique name for the slab as a target
		 * for the symlinks.
		 */
		name = create_unique_id(s);
	}

Since this function was modified in the mmotm tree, I would propose
something like this on top of mmotm to avoid further merge conflicts:

diff --git a/mm/slub.c b/mm/slub.c
index c6eb29d65847..f4ca525c05b0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5214,25 +5214,19 @@ static int sysfs_slab_add(struct kmem_cache *s)
 
 	s->kobj.kset = cache_kset(s);
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
-	if (err) {
-		kobject_put(&s->kobj);
-		return err;
-	}
+	if (err)
+		goto out_put_kobj;
 
 	err = sysfs_create_group(&s->kobj, &slab_attr_group);
-	if (err) {
-		kobject_del(&s->kobj);
-		kobject_put(&s->kobj);
-		return err;
-	}
+	if (err)
+		goto out_del_kobj;
 
 #ifdef CONFIG_MEMCG_KMEM
 	if (is_root_cache(s)) {
 		s->memcg_kset = kset_create_and_add("cgroup", NULL, &s->kobj);
 		if (!s->memcg_kset) {
-			kobject_del(&s->kobj);
-			kobject_put(&s->kobj);
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto out_del_kobj;
 		}
 	}
 #endif
@@ -5241,9 +5235,16 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	if (!unmergeable) {
 		/* Setup first alias */
 		sysfs_slab_alias(s, s->name);
-		kfree(name);
 	}
-	return 0;
+out:
+	if (!unmergeable)
+		kfree(name);
+	return err;
+out_del_kobj:
+	kobject_del(&s->kobj);
+out_put_kobj:
+	kobject_put(&s->kobj);
+	goto out;
 }
 
 static void sysfs_slab_remove(struct kmem_cache *s)
