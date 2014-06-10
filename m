Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaFJWQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:16:15 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:42945 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbaFJWQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:16:13 -0400
Date: Tue, 10 Jun 2014 15:16:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Li Zefan <lizefan@huawei.com>
cc: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, Cgroups <cgroups@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy: fix sleeping function called from invalid
 context
In-Reply-To: <53967465.7070908@huawei.com>
Message-ID: <alpine.DEB.2.02.1406101512340.32203@chino.kir.corp.google.com>
References: <53902A44.50005@cn.fujitsu.com> <20140605132339.ddf6df4a0cf5c14d17eb8691@linux-foundation.org> <539192F1.7050308@cn.fujitsu.com> <alpine.DEB.2.02.1406081539140.21744@chino.kir.corp.google.com> <539574F1.2060701@cn.fujitsu.com>
 <alpine.DEB.2.02.1406090209460.24247@chino.kir.corp.google.com> <53967465.7070908@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Li Zefan wrote:

> > Yes, the rcu lock is not providing protection for any critical section 
> > here that requires (1) the forker's cpuset to be stored in 
> > cpuset_being_rebound or (2) the forked thread's cpuset to be rebound by 
> > the cpuset nodemask update, and no race involving the two.
> >
> 
> Yes, this is a long-standing issue. Besides the race you described, the child
> task's mems_allowed can be wrong if the cpuset's nodemask changes before the
> child has been added to the cgroup's tasklist.
> 
> I remember Tejun once said he wanted to disallow task migration between
> cgroups during fork, and that should fix this problem.
>  

Ok, I don't want to fix it in cpusets if cgroups will eventually prevent 
it, so I need an understanding of the long term plan.  Will cgroups 
continue to allow migration during fork(), Tejun?

> > It needs to be slightly rewritten to work properly without negatively 
> > impacting the latency of fork().  Do you have the cycles to do it?
> > 
> 
> Sounds you have other idea?
> 

It wouldn't be too difficult with a cgroup post fork callback into the 
cpuset code to rebind the nodemask if it has changed, but with my above 
concern those might be yanked out eventually :)
