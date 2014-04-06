Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaDFRrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 13:47:03 -0400
Received: from relay.parallels.com ([195.214.232.42]:47803 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbaDFRrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 13:47:01 -0400
Message-ID: <53419305.7090104@parallels.com>
Date: Sun, 6 Apr 2014 21:46:45 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH -mm 0/3] slab: cleanup mem hotplug synchronization
References: <cover.1396779337.git.vdavydov@parallels.com>
In-Reply-To: <cover.1396779337.git.vdavydov@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2014 07:33 PM, Vladimir Davydov wrote:
> kmem_cache_{create,destroy,shrink} need to get a stable value of
> cpu/node online mask, because they init/destroy/access per-cpu/node
> kmem_cache parts, which can be allocated or destroyed on cpu/mem
> hotplug. To protect against cpu hotplug, these functions use
> {get,put}_online_cpus. However, they do nothing to synchronize with
> memory hotplug - taking the slab_mutex does not eliminate the
> possibility of race as described in patch 3.
>
> What we need there is something like get_online_cpus, but for memory. We
> already have lock_memory_hotplug, which serves for the purpose, but it's
> a bit of a hammer right now, because it's backed by a mutex. As a
> result, it imposes some limitations to locking order, which are not
> desirable, and can't be used just like get_online_cpus. I propose to
> turn this mutex into an rw semaphore, which will be taken for reading in
> lock_memory_hotplug and for writing in memory hotplug code (that's what
> patch 1 does).

This is absolutely wrong, because down_read cannot be nested inside
down/up_write critical section. Although it would work now, it could
result in deadlocks in future. Please ignore this set completely.

Actually we need to implement a recursive rw semaphore here, just like
cpu_hotplug_lock.

Sorry for the noise.

Thanks.
