Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaDRQGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:06:03 -0400
Received: from relay.parallels.com ([195.214.232.42]:55419 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaDRQGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:06:00 -0400
Message-ID: <53514D66.1010607@parallels.com>
Date: Fri, 18 Apr 2014 20:05:58 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: <mhocko@suse.cz>, <akpm@linux-foundation.org>, <glommer@gmail.com>,
        <cl@linux-foundation.org>, <penberg@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: Re: [PATCH RFC -mm v2 1/3] memcg, slab: do not schedule cache destruction
 when last page goes away
References: <cover.1397804745.git.vdavydov@parallels.com> <e929fb6cc3a10ce1a9dcee0440e6995bdf427090.1397804745.git.vdavydov@parallels.com> <20140418134122.GB26283@cmpxchg.org>
In-Reply-To: <20140418134122.GB26283@cmpxchg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 05:41 PM, Johannes Weiner wrote:
>> Thus we have a piece of code that works only when we explicitly call
>> kmem_cache_shrink, but complicates the whole picture a lot. Moreover,
>> it's racy in fact. For instance, kmem_cache_shrink may free the last
>> slab and thus schedule cache destruction before it finishes checking
>> that the cache is empty, which can lead to use-after-free.
>
> Can't this still happen when the last object free races with css
> destruction?

AFAIU, yes, it still can happen, but we have less places to fix now. I'm
planning to sort this out by rearranging operations inside
kmem_cache_free so that we do not touch the cache after we've
decremented memcg_cache_params::nr_pages and made the cache potentially
destroyable.

Or, if we could reparent individual slabs as you proposed earlier, we
wouldn't have to bother about it at all any more as well as about per
memcg cache destruction.

Thanks.
