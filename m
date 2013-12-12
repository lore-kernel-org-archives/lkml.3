Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3LLOWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:22:15 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:59387 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3LLOWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:22:09 -0500
Date: Thu, 12 Dec 2013 09:21:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Tim Hockin <thockin@hockin.org>
Cc: David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom
 notifications to access reserves
Message-ID: <20131212142156.GB32683@htj.dyndns.org>
References: <20131204054533.GZ3556@cmpxchg.org>
 <alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
 <20131205025026.GA26777@htj.dyndns.org>
 <alpine.DEB.2.02.1312051537550.7717@chino.kir.corp.google.com>
 <20131206190105.GE13373@htj.dyndns.org>
 <alpine.DEB.2.02.1312061441390.8949@chino.kir.corp.google.com>
 <20131210215037.GB9143@htj.dyndns.org>
 <alpine.DEB.2.02.1312101522400.22701@chino.kir.corp.google.com>
 <20131211124240.GA24557@htj.dyndns.org>
 <CAAAKZwsmM-C=kLGV=RW=Y4Mq=BWpQzuPruW6zvEr9p0Xs4GD5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwsmM-C=kLGV=RW=Y4Mq=BWpQzuPruW6zvEr9p0Xs4GD5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Tim.

Sidenote: Please don't top-post with the whole body quoted below
unless you're adding new cc's.  Please selectively quote the original
message's body to remind the readers of the context and reply below
it.  It's a basic lkml etiquette and one with good reasons.  If you
have to top-post for whatever reason - say you're typing from a
machine which doesn't allow easy editing of the original message,
explain so at the top of the message, or better yet, wait till you can
unless it's urgent.

On Wed, Dec 11, 2013 at 09:37:46PM -0800, Tim Hockin wrote:
> The immediate problem I see with setting aside reserves "off the top"
> is that we don't really know a priori how much memory the kernel
> itself is going to use, which could still land us in an overcommitted
> state.
> 
> In other words, if I have your 128 MB machine, and I set aside 8 MB
> for OOM handling, and give 120 MB for jobs, I have not accounted for
> the kernel.  So I set aside 8 MB for OOM and 100 MB for jobs, leaving
> 20 MB for jobs.  That should be enough right?  Hell if I know, and
> nothing ensures that.

Yes, sure thing, that's the reason why I mentioned "with some slack"
in the original message and also that it might not be completely the
same.  It doesn't allow you to aggressively use system level OOM
handling as the sizing estimator for the root cgroup; however, it's
more of an implementation details than something which should guide
the overall architecture - it's a problem which lessens in severity as
[k]memcg improves and its coverage becomes more complete, which is the
direction we should be headed no matter what.

It'd depend on the workload but with memcg fully configured it
shouldn't fluctuate wildly.  If it does, we need to hunt down whatever
is causing such fluctuatation and include it in kmemcg, right?  That
way, memcg as a whole improves for all use cases not just your niche
one and I strongly believe that aligning as many use cases as possible
along the same axis, rather than creating a large hole to stow away
the exceptions, is vastly more beneficial to *everyone* in the long
term.

There'd still be all the bells and whistles to configure and monitor
system-level OOM and if there's justified need for improvements, we
surely can and should do that; however, with the heavy lifting / hot
path offloaded to the per-memcg userland OOM handlers, I believe it's
reasonable to expect the burden on system OOM handler being noticeably
less, which is the way it should be.  That's the last guard against
the whole system completely locking up and we can't extend its
capabilities beyond that easily and we most likely don't even want to.

If I take back a step and look at the two options and their pros and
cons, which path we should take is rather obvious to me.  I hope you
see it too.

Thanks.

-- 
tejun
