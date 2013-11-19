Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab3KSNkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:40:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab3KSNkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:40:09 -0500
Date: Tue, 19 Nov 2013 14:40:07 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Joern Engel <joern@logfs.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
Message-ID: <20131119134007.GD20655@dhcp22.suse.cz>
References: <20131119131400.GC20655@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119131400.GC20655@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 19-11-13 14:14:00, Michal Hocko wrote:
[...]
> We have basically ended up with 3 options AFAIR:
> 	1) allow memcg approach (memcg.oom_control) on the root level
>            for both OOM notification and blocking OOM killer and handle
>            the situation from the userspace same as we can for other
> 	   memcgs.

This looks like a straightforward approach as the similar thing is done
on the local (memcg) level. There are several problems though.
Running userspace from within OOM context is terribly hard to do
right. This is true even in the memcg case and we strongly discurage
users from doing that. The global case has nothing like outside of OOM
context though. So any hang would blocking the whole machine. Even
if the oom killer is careful and locks in all the resources it would
have hard time to query the current system state (existing processes
and their states) without any allocation.  There are certain ways to
workaround these issues - e.g. give the killer access to memory reserves
- but this all looks scary and fragile.

> 	2) allow modules to hook into OOM killer path and take the
> 	   appropriate action.

This already exists actually. There is oom_notify_list callchain and
{un}register_oom_notifier that allow modules to hook into oom and
skip the global OOM if some memory is freed. There are currently only
s390 and powerpc which seem to abuse it for something that looks like a
shrinker except it is done in OOM path...

I think the interface should be changed if something like this would be
used in practice. There is a lot of information lost on the way. I would
basically expect to get everything that out_of_memory gets.

> 	3) create a generic filtering mechanism which could be
> 	   controlled from the userspace by a set of rules (e.g.
> 	   something analogous to packet filtering).

This looks generic enough but I have no idea about the complexity.
-- 
Michal Hocko
SUSE Labs
