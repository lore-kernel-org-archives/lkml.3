Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934584AbaFIWw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:52:57 -0400
Received: from mail-ve0-f201.google.com ([209.85.128.201]:41543 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaFIWwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:52:54 -0400
References: <20140606144421.GE26253@dhcp22.suse.cz> <1402066010-25901-1-git-send-email-mhocko@suse.cz> <1402066010-25901-2-git-send-email-mhocko@suse.cz>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Greg Thelen <gthelen@google.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] memcg: Allow hard guarantee mode for low limit reclaim
In-reply-to: <1402066010-25901-2-git-send-email-mhocko@suse.cz>
Date: Mon, 09 Jun 2014 15:52:51 -0700
Message-ID: <xr934mzt4rwc.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Jun 06 2014, Michal Hocko <mhocko@suse.cz> wrote:

> Some users (e.g. Google) would like to have stronger semantic than low
> limit offers currently. The fallback mode is not desirable and they
> prefer hitting OOM killer rather than ignoring low limit for protected
> groups. There are other possible usecases which can benefit from hard
> guarantees. I can imagine workloads where setting low_limit to the same
> value as hard_limit to prevent from any reclaim at all makes a lot of
> sense because reclaim is much more disrupting than restart of the load.
>
> This patch adds a new per memcg memory.reclaim_strategy knob which
> tells what to do in a situation when memory reclaim cannot do any
> progress because all groups in the reclaimed hierarchy are within their
> low_limit. There are two options available:
> 	- low_limit_best_effort - the current mode when reclaim falls
> 	  back to the even reclaim of all groups in the reclaimed
> 	  hierarchy
> 	- low_limit_guarantee - groups within low_limit are never
> 	  reclaimed and OOM killer is triggered instead. OOM message
> 	  will mention the fact that the OOM was triggered due to
> 	  low_limit reclaim protection.

To (a) be consistent with existing hard and soft limits APIs and (b)
allow use of both best effort and guarantee memory limits, I wonder if
it's best to offer three per memcg limits, rather than two limits (hard,
low_limit) and a related reclaim_strategy knob.  The three limits I'm
thinking about are:

1) hard_limit (aka the existing limit_in_bytes cgroupfs file).  No
   change needed here.  This is an upper bound on a memcg hierarchy's
   memory consumption (assuming use_hierarchy=1).

2) best_effort_limit (aka desired working set).  This allow an
   application or administrator to provide a hint to the kernel about
   desired working set size.  Before oom'ing the kernel is allowed to
   reclaim below this limit.  I think the current soft_limit_in_bytes
   claims to provide this.  If we prefer to deprecate
   soft_limit_in_bytes, then a new desired_working_set_in_bytes (or a
   hopefully better named) API seems reasonable.

3) low_limit_guarantee which is a lower bound of memory usage.  A memcg
   would prefer to be oom killed rather than operate below this
   threshold.  Default value is zero to preserve compatibility with
   existing apps.

Logically hard_limit >= best_effort_limit >= low_limit_guarantee.
