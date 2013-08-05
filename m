Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3HEUFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:05:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab3HEUFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:05:32 -0400
Date: Mon, 5 Aug 2013 13:05:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] memcg: don't initialize kmem-cache destroying work for
 root caches
Message-Id: <20130805130530.fd38ec4866ba7f1d9a400218@linux-foundation.org>
In-Reply-To: <1375718980-22154-1-git-send-email-avagin@openvz.org>
References: <1375718980-22154-1-git-send-email-avagin@openvz.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Aug 2013 20:09:40 +0400 Andrey Vagin <avagin@openvz.org> wrote:

> struct memcg_cache_params has a union. Different parts of this union
> are used for root and non-root caches. A part with destroying work is
> used only for non-root caches.
> 
> I fixed the same problem in another place v3.9-rc1-16204-gf101a94, but
> didn't notice this one.
> 
> Cc: <stable@vger.kernel.org>    [3.9.x]

hm, why the cc:stable?

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3195,11 +3195,11 @@ int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
>  	if (!s->memcg_params)
>  		return -ENOMEM;
>  
> -	INIT_WORK(&s->memcg_params->destroy,
> -			kmem_cache_destroy_work_func);
>  	if (memcg) {
>  		s->memcg_params->memcg = memcg;
>  		s->memcg_params->root_cache = root_cache;
> +		INIT_WORK(&s->memcg_params->destroy,
> +				kmem_cache_destroy_work_func);
>  	} else
>  		s->memcg_params->is_root_cache = true;

So the bug here is that we'll scribble on some entries in
memcg_caches[].  Those scribbles may or may not be within the part of
that array which is actually used.  If there's code which expects
memcg_caches[] entries to be zeroed at initialisation then yes, we have
a problem.

But I rather doubt whether this bug was causing runtime problems?


Presently memcg_register_cache() allocates too much memory for the
memcg_caches[] array.  If that was fixed then this INIT_WORK() might
scribble into unknown memory, which is of course serious.
