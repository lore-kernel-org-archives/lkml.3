Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaA2INv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:13:51 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55477 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaA2INt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:13:49 -0500
Date: Wed, 29 Jan 2014 00:13:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Jan Kara <jack@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] kthread: ensure locality of task_struct allocations
In-Reply-To: <20140128183808.GB9315@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1401290012460.10268@chino.kir.corp.google.com>
References: <20140128183808.GB9315@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Nishanth Aravamudan wrote:

> In the presence of memoryless nodes, numa_node_id()/cpu_to_node() will
> return the current CPU's NUMA node, but that may not be where we expect
> to allocate from memory from. Instead, we should use
> numa_mem_id()/cpu_to_mem(). On one ppc64 system with a memoryless Node
> 0, this ends up saving nearly 500M of slab due to less fragmentation.
> 
> Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>

> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index b5ae3ee..8573e4e 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -217,7 +217,7 @@ int tsk_fork_get_node(struct task_struct *tsk)
>  	if (tsk == kthreadd_task)
>  		return tsk->pref_node_fork;
>  #endif
> -	return numa_node_id();
> +	return numa_mem_id();

I'm wondering why return NUMA_NO_NODE wouldn't have the same effect and 
prefer the local node?
