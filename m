Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaAOR5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:57:06 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:46207 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbaAOR5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:57:04 -0500
Date: Wed, 15 Jan 2014 12:56:55 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 1/3] memcg: notify userspace about OOM only when and action
 is due
Message-ID: <20140115175655.GJ6963@cmpxchg.org>
References: <1389798068-19885-1-git-send-email-mhocko@suse.cz>
 <1389798068-19885-2-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389798068-19885-2-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 04:01:06PM +0100, Michal Hocko wrote:
> Userspace is currently notified about OOM condition after reclaim
> fails to uncharge any memory after MEM_CGROUP_RECLAIM_RETRIES rounds.
> This usually means that the memcg is really in troubles and an
> OOM action (either done by userspace or kernel) has to be taken.
> The kernel OOM killer however bails out and doesn't kill anything
> if it sees an already dying/exiting task in a good hope a memory
> will be released and the OOM situation will be resolved.
> 
> Therefore it makes sense to notify userspace only after really all
> measures have been taken and an userspace action is required or
> the kernel kills a task.
> 
> This patch is based on idea by David Rientjes to not notify
> userspace when the current task is killed or in a late exiting.
> The original patch, however, didn't handle in kernel oom killer
> back offs which is implemtented by this patch.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

OOM is a temporary state because any task can exit at a time that is
not under our control and outside our knowledge.  That's why the OOM
situation is defined by failing an allocation after a certain number
of reclaim and charge attempts.

As of right now, the OOM sampling window is MEM_CGROUP_RECLAIM_RETRIES
loops of charge attempts and reclaim.  If a racing task is exiting and
releasing memory during that window, the charge will succeed fine.  If
the sampling window is too short in practice, it will have to be
extended, preferrably through increasing MEM_CGROUP_RECLAIM_RETRIES.

But a random task exiting a split second after the sampling window has
closed will always be a possibility, regardless of how long it is.
There is nothing to be gained from this layering violation and it's
mind-boggling that you two still think this is a meaningful change.

Nacked-by: Johannes Weiner <hannes@cmpxchg.org>
