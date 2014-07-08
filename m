Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbaGHWTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:19:15 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43569 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbaGHWTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:19:14 -0400
Date: Tue, 8 Jul 2014 18:19:06 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, mhocko@suse.cz, cl@linux.com, glommer@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/8] memcg: reparent kmem on css offline
Message-ID: <20140708221906.GC29639@cmpxchg.org>
References: <cover.1404733720.git.vdavydov@parallels.com>
 <20140707142506.GB1149@cmpxchg.org>
 <53BAD567.8060506@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BAD567.8060506@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 09:14:15PM +0400, Vladimir Davydov wrote:
> 07.07.2014 18:25, Johannes Weiner:
> >In addition, Tejun made offlined css iterable and split css_tryget()
> >and css_tryget_online(), which would allow memcg to pin the css until
> >the last charge is gone while continuing to iterate and reclaim it on
> >hierarchical pressure, even after it was offlined.
> 
> One more question.
> 
> With reparenting enabled, the number of cgroups (lruvecs) that must be
> iterated on global reclaim is bound by the number of live containers,
> while w/o reparenting it's practically unbound, isn't it? Won't it be
> the source of latency spikes?

It might deteriorate a little bit, but it is a self-correcting problem
as soon as memory pressure kicks.  Creating and destroying cgroups is
serialized at a global level, so I would expect the cost of doing that
at a high rate to become a problem before the csss become an issue for
the reclaim scanner.

At some point we will probably have to make the global reclaim cgroup
walk in shrink_zone() intermittent, but I'm not aware of any problems
with it so far.
