Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab3HGNWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:22:16 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:40245 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950Ab3HGNWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:22:14 -0400
Date: Wed, 7 Aug 2013 09:22:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH 1/3] memcg: limit the number of thresholds per-memcg
Message-ID: <20130807132210.GD27006@htj.dyndns.org>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 07, 2013 at 01:28:25PM +0200, Michal Hocko wrote:
> There is no limit for the maximum number of threshold events registered
> per memcg. This might lead to an user triggered memory depletion if a
> regular user is allowed to register on memory.[memsw.]usage_in_bytes
> eventfd interface.
> 
> Let's be more strict and cap the number of events that might be
> registered. MAX_THRESHOLD_EVENTS value is more or less random. The
> expectation is that it should be high enough to cover reasonable
> usecases while not too high to allow excessive resources consumption.
> 1024 events consume something like 16KB which shouldn't be a big deal
> and it should be good enough.

I don't think the memory consumption per-se is the issue to be handled
here (as kernel memory consumption is a different generic problem) but
rather that all listeners, regardless of their priv level, cgroup
membership and so on, end up contributing to this single shared
contiguous table, which makes it quite easy to do DoS attack on it if
the event control is actually delegated to untrusted security domain,
which BTW kinda makes all these complexities kinda pointless as it
nullifies the only use case (many un-coordinated listeners watching
different thresholds) which the event mechanism can actually do
better.

A proper fix would be making it build sorted data structure, be it
list or tree, and letting each listener insert its own probe at the
appropriate position and updating the event generation maintain cursor
in the tree and fire events as appropriate, but given that the whole
usage model is being obsoleted, it probably isn't worth doing that and
this fixed limit is better than just letting things go and allow
allocation to fail at some point, I suppose.

Can you please update the patch description to reflect the actual
problem?

Thanks.

-- 
tejun
