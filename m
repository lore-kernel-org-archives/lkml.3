Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3F1W7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:59:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3F1W7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:59:21 -0400
Date: Fri, 28 Jun 2013 15:59:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v4 5/9] memcg: use css_get/put when charging/uncharging
 kmem
Message-Id: <20130628155919.840f44b4d76e4e9ade6a9b6e@linux-foundation.org>
In-Reply-To: <51BA77F1.4080106@huawei.com>
References: <51BA7794.2000305@huawei.com>
	<51BA77F1.4080106@huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jun 2013 09:54:57 +0800 Li Zefan <lizefan@huawei.com> wrote:

> Use css_get/put instead of mem_cgroup_get/put.
> 
> We can't do a simple replacement, because here mem_cgroup_put()
> is called during mem_cgroup_css_free(), while mem_cgroup_css_free()
> won't be called until css refcnt goes down to 0.
> 
> Instead we increment css refcnt in mem_cgroup_css_offline(), and
> then check if there's still kmem charges. If not, css refcnt will
> be decremented immediately, otherwise the refcnt will be released
> after the last kmem allocation is uncahred.
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -416,6 +416,11 @@ static void memcg_kmem_clear_activated(struct mem_cgroup *memcg)
>  
>  static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
>  {
> +	/*
> +	 * We need to call css_get() first, because memcg_uncharge_kmem()
> +	 * will call css_put() if it sees the memcg is dead.
> +	 */
> +	smp_wmb();
>  	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags))
>  		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_account_flags);
>  }

That comment is rather confusing and unhelpful.  "We need to call
css_get", but we clearly *don't* call css_get().  I guess we want

--- a/mm/memcontrol.c~memcg-use-css_get-put-when-charging-uncharging-kmem-fix
+++ a/mm/memcontrol.c
@@ -407,7 +407,7 @@ static void memcg_kmem_clear_activated(s
 static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
 {
 	/*
-	 * We need to call css_get() first, because memcg_uncharge_kmem()
+	 * Our caller must use css_get() first, because memcg_uncharge_kmem()
 	 * will call css_put() if it sees the memcg is dead.
 	 */
 	smp_wmb();
_


But it's still not good.

- What is the smp_wmb() for?  These barriers should always be
  documented so readers can see what we're barriering against but this
  one is floating around unexplained.

- What does memcg_uncharge_kmem() have to do with all this? 
  memcg_kmem_mark_dead() just does a set_bit() - what has that to do
  with memcg_kmem_mark_dead().

So I dunno, it's all clear as mud and I hope we can do better.


> @@ -3060,8 +3065,16 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg, u64 size)
>  	if (res_counter_uncharge(&memcg->kmem, size))
>  		return;
>  
> +	/*
> +	 * Releases a reference taken in kmem_cgroup_css_offline in case
> +	 * this last uncharge is racing with the offlining code or it is
> +	 * outliving the memcg existence.
> +	 *
> +	 * The memory barrier imposed by test&clear is paired with the
> +	 * explicit one in memcg_kmem_mark_dead().
> +	 */

OK, that clears things up a bit.  A small bit.


This code is far too tricky :(
