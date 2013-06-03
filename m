Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab3FCTby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:31:54 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:44328 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab3FCTbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:31:51 -0400
Date: Mon, 3 Jun 2013 21:31:47 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add oom killer delay
Message-ID: <20130603193147.GC23659@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
 <20130530150539.GA18155@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com>
 <20130531081052.GA32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
 <20130531112116.GC32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com>
 <20130601102058.GA19474@dhcp22.suse.cz>
 <alpine.DEB.2.02.1306031102480.7956@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306031102480.7956@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 03-06-13 11:18:09, David Rientjes wrote:
> On Sat, 1 Jun 2013, Michal Hocko wrote:
[...]
> > I still do not see why you cannot simply read tasks file into a
> > preallocated buffer. This would be few pages even for thousands of pids.
> > You do not have to track processes as they come and go.
> > 
> 
> What do you suggest when you read the "tasks" file and it returns -ENOMEM 
> because kmalloc() fails because the userspace oom handler's memcg is also 
> oom? 

That would require that you track kernel allocations which is currently
done only for explicit caches.

> Obviously it's not a situation we want to get into, but unless you 
> know that handler's exact memory usage across multiple versions, nothing 
> else is sharing that memcg, and it's a perfect implementation, you can't 
> guarantee it.  We need to address real world problems that occur in 
> practice.

If you really need to have such a guarantee then you can have a _global_
watchdog observing oom_control of all groups that provide such a vague
requirements for oom user handlers.

> > As I said before. oom_delay_millisecs is actually really easy to be done
> > from userspace. If you really need a safety break then you can register
> > such a handler as a fallback. I am not familiar with eventfd internals
> > much but I guess that multiple handlers are possible. The fallback might
> > be enforeced by the admin (when a new group is created) or by the
> > container itself. Would something like this work for your use case?
> > 
> 
> You're suggesting another userspace process that solely waits for a set 
> duration and then reenables the oom killer?

Yes which kicks the oom killer.

> It faces all the same problems as the true userspace oom handler: it's
> own perfect implementation and it's own memcg constraints.

But that solution might be implemented as a global policy living in a
group with some reservations.

[...]
-- 
Michal Hocko
SUSE Labs
