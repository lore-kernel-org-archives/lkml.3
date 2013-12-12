Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3LLUsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:48:09 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:50913 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3LLUsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:48:04 -0500
MIME-Version: 1.0
In-Reply-To: <20131210050005.GC31386@dastard>
References: <cover.1386571280.git.vdavydov@parallels.com>
	<0ca62dbfbf545edb22b86bd11c50e9017a3dc4db.1386571280.git.vdavydov@parallels.com>
	<20131210050005.GC31386@dastard>
Date: Fri, 13 Dec 2013 00:48:03 +0400
Message-ID: <CAA6-i6rukbiu+_pnS1nkD45ViA0fnn9fQjhk74LWXOA+S=+7Tg@mail.gmail.com>
Subject: Re: [PATCH v13 11/16] mm: list_lru: add per-memcg lists
From: Glauber Costa <glommer@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, dchinner@redhat.com,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, devel@openvz.org,
        Glauber Costa <glommer@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, as far as I can tell, this is introducing a per-node, per-memcg
> LRU lists. Is that correct?
>
> If so, then that is not what Glauber and I originally intended for
> memcg LRUs. per-node LRUs are expensive in terms of memory and cross
> multiplying them by the number of memcgs in a system was not a good
> use of memory.
>
> According to Glauber, most memcgs are small and typically confined
> to a single node or two by external means and therefore don't need the
> scalability numa aware LRUs provide. Hence the idea was that the
> memcg LRUs would just be a single LRU list, just like a non-numa
> aware list_lru instantiation. IOWs, this is the structure that we
> had decided on as the best compromise between memory usage,
> complexity and memcg awareness:
>
Sorry for jumping late into this particular e-mail.

I just wanted to point out that the reason I adopted such matrix in my
design was that
it actually uses less memory this way. My reasoning for this was
explained in the original
patch that I posted that contained that implementation.

This is because whenever an object would go on a memcg list, it *would
not* go on
the global list. Therefore, to keep information about nodes for global
reclaim, you
have to put them in node-lists.

memcg reclaim, however, would reclaim regardless of node information.

In global reclaim, the memcg lists would be scanned obeying the node structure
in the lists.

Because that has a fixed cost, it ends up using less memory that having a second
list pointer in the objects, which is something that scale with the
number of objects.
Not to mention, that cost would be incurred even with memcg not being in use,
which is something that we would like to avoid.
