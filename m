Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446AbaFIJOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:14:07 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:37869 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbaFIJOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:14:00 -0400
Date: Mon, 9 Jun 2014 02:13:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, Cgroups <cgroups@vger.kernel.org>,
        stable@vger.kernel.org, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] mm/mempolicy: fix sleeping function called from invalid
 context
In-Reply-To: <539574F1.2060701@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1406090209460.24247@chino.kir.corp.google.com>
References: <53902A44.50005@cn.fujitsu.com> <20140605132339.ddf6df4a0cf5c14d17eb8691@linux-foundation.org> <539192F1.7050308@cn.fujitsu.com> <alpine.DEB.2.02.1406081539140.21744@chino.kir.corp.google.com> <539574F1.2060701@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Gu Zheng wrote:

> > I think your patch addresses the problem that you're reporting but misses 
> > the larger problem with cpuset.mems rebinding on fork().  When the 
> > forker's task_struct is duplicated (which includes ->mems_allowed) and it 
> > races with an update to cpuset_being_rebound in update_tasks_nodemask() 
> > then the task's mems_allowed doesn't get updated.
> 
> Yes, you are right, this patch just wants to address the bug reported above.
> The race condition you mentioned above inherently exists there, but it is yet
> another issue, the rcu lock here makes no sense to it, and I think we need
> additional sync-mechanisms if want to fix it.

Yes, the rcu lock is not providing protection for any critical section 
here that requires (1) the forker's cpuset to be stored in 
cpuset_being_rebound or (2) the forked thread's cpuset to be rebound by 
the cpuset nodemask update, and no race involving the two.

> But thinking more, though the current implementation has flaw, but I worry
> about the negative effect if we really want to fix it. Or maybe the fear
> is unnecessary.:) 
> 

It needs to be slightly rewritten to work properly without negatively 
impacting the latency of fork().  Do you have the cycles to do it?
