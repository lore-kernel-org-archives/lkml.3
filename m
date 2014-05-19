Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaESOCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:02:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbaESOCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:02:51 -0400
Date: Mon, 19 May 2014 16:02:48 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] memcg: deprecate memory.force_empty knob
Message-ID: <20140519140248.GD3017@dhcp22.suse.cz>
References: <1399994956-3907-1-git-send-email-mhocko@suse.cz>
 <xr9338g9o03z.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xr9338g9o03z.fsf@gthelen.mtv.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 16-05-14 15:00:16, Greg Thelen wrote:
> On Tue, May 13 2014, Michal Hocko <mhocko@suse.cz> wrote:
[...]
> > If somebody really cares because reparented pages, which would be
> > dropped otherwise, push out more important ones then we should fix the
> > reparenting code and put pages to the tail.
> 
> I should mention a case where I've needed to use memory.force_empty: to
> synchronously flush stats from child to parent.  Without force_empty
> memory.stat is temporarily inconsistent until async css_offline
> reparents charges.  Here is an example on v3.14 showing that
> parent/memory.stat contents are in-flux immediately after rmdir of
> parent/child.

OK, it is true that the delayed offlining makes this little bit
complicated because there is no direct user visible relation between
rmdir and css_offline.

> $ cat /test
> #!/bin/bash
> 
> # Create parent and child.  Add some non-reclaimable anon rss to child,
> # then move running task to parent.
> mkdir p p/c
> (echo $BASHPID > p/c/cgroup.procs && exec sleep 1d) &
> pid=$!
> sleep 1
> echo $pid > p/cgroup.procs 
> 
> grep 'rss ' {p,p/c}/memory.stat
> if [[ $1 == force ]]; then
>   echo 1 > p/c/memory.force_empty
> fi
> rmdir p/c
> 
> echo 'For a small time the p/c memory has not been reparented to p.'
> grep 'rss ' {p,p/c}/memory.stat
> 
> sleep 1
> echo 'After waiting all memory has been reparented'
> grep 'rss ' {p,p/c}/memory.stat
> 
> kill $pid
> rmdir p
> 
> 
> -- First, demonstrate that just rmdir, without memory.force_empty,
>    temporarily hides reparented child memory stats.
> 
> $ /test
> p/memory.stat:rss 0
> p/memory.stat:total_rss 69632
> p/c/memory.stat:rss 69632
> p/c/memory.stat:total_rss 69632
> For a small time the p/c memory has not been reparented to p.
> p/memory.stat:rss 0
> p/memory.stat:total_rss 0

OK, this is a bug. Our iterators skip the children because css_tryget
fails on it but css_offline still not done. This is fixable, though,
and force_empty is just a workaround so I wouldn't see this as a proper
justification to keep it alive.

One possible way to fix this is to iterate children even when css_tryget
fails for them if they haven't finished css_offline yet.
There are some changes in the cgroups core which should make this easier
and Johannes claimed he has some work in that area.

Anyway this is a useful testcase. Thanks Greg!

> grep: p/c/memory.stat: No such file or directory
> After waiting all memory has been reparented
> p/memory.stat:rss 69632
> p/memory.stat:total_rss 69632
> grep: p/c/memory.stat: No such file or directory
> /test: Terminated              ( echo $BASHPID > p/c/cgroup.procs && exec sleep 1d )
> 
> -- Demonstrate that using memory.force_empty before rmdir, behaves more
>    sensibly.  Stats for reparented child memory are not hidden.
> 
> $ /test force
> p/memory.stat:rss 0
> p/memory.stat:total_rss 69632
> p/c/memory.stat:rss 69632
> p/c/memory.stat:total_rss 69632
> For a small time the p/c memory has not been reparented to p.
> p/memory.stat:rss 69632
> p/memory.stat:total_rss 69632
> grep: p/c/memory.stat: No such file or directory
> After waiting all memory has been reparented
> p/memory.stat:rss 69632
> p/memory.stat:total_rss 69632
> grep: p/c/memory.stat: No such file or directory
> /test: Terminated              ( echo $BASHPID > p/c/cgroup.procs && exec sleep 1d )

-- 
Michal Hocko
SUSE Labs
