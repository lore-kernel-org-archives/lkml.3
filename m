Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaA3A1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:27:25 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54913 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaA3A1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:27:24 -0500
Date: Wed, 29 Jan 2014 16:27:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>, Eric Dumazet <edumazet@google.com>
cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Jan Kara <jack@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] kthread: ensure locality of task_struct allocations
In-Reply-To: <alpine.DEB.2.10.1401290957350.23856@nuc>
Message-ID: <alpine.DEB.2.02.1401291622550.22974@chino.kir.corp.google.com>
References: <20140128183808.GB9315@linux.vnet.ibm.com> <alpine.DEB.2.02.1401290012460.10268@chino.kir.corp.google.com> <alpine.DEB.2.10.1401290957350.23856@nuc>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014, Christoph Lameter wrote:

> > > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > > index b5ae3ee..8573e4e 100644
> > > --- a/kernel/kthread.c
> > > +++ b/kernel/kthread.c
> > > @@ -217,7 +217,7 @@ int tsk_fork_get_node(struct task_struct *tsk)
> > >  	if (tsk == kthreadd_task)
> > >  		return tsk->pref_node_fork;
> > >  #endif
> > > -	return numa_node_id();
> > > +	return numa_mem_id();
> >
> > I'm wondering why return NUMA_NO_NODE wouldn't have the same effect and
> > prefer the local node?
> >
> 
> The idea here seems to be that the allocation may occur from a cpu that is
> different from where the process will run later on.
> 

Yeah, that makes sense for kthreadd, but I'm wondering why we have to 
return numa_mem_id() rather than just NUMA_NO_NODE.  Sorry for not being 
specific about doing s/numa_mem_id/NUMA_NO_NODE/ here.

That should just turn kmem_cache_alloc_node() into kmem_cache_alloc() and 
alloc_pages_node() into alloc_pages() for the allocators that use this 
return value, task_struct and thread_info.  If that's not allocating local 
memory, if possible, and numa_mem_id() magically does, then there's a 
problem.

Eric, did you try this when writing 207205a2ba26 ("kthread: NUMA aware 
kthread_create_on_node()") or was it always numa_node_id() from the 
beginning?
