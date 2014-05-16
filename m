Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaEPWAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:00:20 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:57308 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaEPWAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:00:18 -0400
References: <1399994956-3907-1-git-send-email-mhocko@suse.cz>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Greg Thelen <gthelen@google.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] memcg: deprecate memory.force_empty knob
In-reply-to: <1399994956-3907-1-git-send-email-mhocko@suse.cz>
Date: Fri, 16 May 2014 15:00:16 -0700
Message-ID: <xr9338g9o03z.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, May 13 2014, Michal Hocko <mhocko@suse.cz> wrote:

> force_empty has been introduced primarily to drop memory before it gets
> reparented on the group removal. This alone doesn't sound fully
> justified because reparented pages which are not in use can be reclaimed
> also later when there is a memory pressure on the parent level.
>
> Mark the knob CFTYPE_INSANE which tells the cgroup core that it
> shouldn't create the knob with the experimental sane_behavior. Other
> users will get informed about the deprecation and asked to tell us more
> because I do not expect most users will use sane_behavior cgroups mode
> very soon.
> Anyway I expect that most users will be simply cgroup remove handlers
> which do that since ever without having any good reason for it.
>
> If somebody really cares because reparented pages, which would be
> dropped otherwise, push out more important ones then we should fix the
> reparenting code and put pages to the tail.

I should mention a case where I've needed to use memory.force_empty: to
synchronously flush stats from child to parent.  Without force_empty
memory.stat is temporarily inconsistent until async css_offline
reparents charges.  Here is an example on v3.14 showing that
parent/memory.stat contents are in-flux immediately after rmdir of
parent/child.

$ cat /test
#!/bin/bash

# Create parent and child.  Add some non-reclaimable anon rss to child,
# then move running task to parent.
mkdir p p/c
(echo $BASHPID > p/c/cgroup.procs && exec sleep 1d) &
pid=$!
sleep 1
echo $pid > p/cgroup.procs 

grep 'rss ' {p,p/c}/memory.stat
if [[ $1 == force ]]; then
  echo 1 > p/c/memory.force_empty
fi
rmdir p/c

echo 'For a small time the p/c memory has not been reparented to p.'
grep 'rss ' {p,p/c}/memory.stat

sleep 1
echo 'After waiting all memory has been reparented'
grep 'rss ' {p,p/c}/memory.stat

kill $pid
rmdir p


-- First, demonstrate that just rmdir, without memory.force_empty,
   temporarily hides reparented child memory stats.

$ /test
p/memory.stat:rss 0
p/memory.stat:total_rss 69632
p/c/memory.stat:rss 69632
p/c/memory.stat:total_rss 69632
For a small time the p/c memory has not been reparented to p.
p/memory.stat:rss 0
p/memory.stat:total_rss 0
grep: p/c/memory.stat: No such file or directory
After waiting all memory has been reparented
p/memory.stat:rss 69632
p/memory.stat:total_rss 69632
grep: p/c/memory.stat: No such file or directory
/test: Terminated              ( echo $BASHPID > p/c/cgroup.procs && exec sleep 1d )

-- Demonstrate that using memory.force_empty before rmdir, behaves more
   sensibly.  Stats for reparented child memory are not hidden.

$ /test force
p/memory.stat:rss 0
p/memory.stat:total_rss 69632
p/c/memory.stat:rss 69632
p/c/memory.stat:total_rss 69632
For a small time the p/c memory has not been reparented to p.
p/memory.stat:rss 69632
p/memory.stat:total_rss 69632
grep: p/c/memory.stat: No such file or directory
After waiting all memory has been reparented
p/memory.stat:rss 69632
p/memory.stat:total_rss 69632
grep: p/c/memory.stat: No such file or directory
/test: Terminated              ( echo $BASHPID > p/c/cgroup.procs && exec sleep 1d )
