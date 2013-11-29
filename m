Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3K2KJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:09:35 -0500
Received: from relay.parallels.com ([195.214.232.42]:42684 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3K2KJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:09:32 -0500
Message-ID: <529867CE.4040004@parallels.com>
Date: Fri, 29 Nov 2013 14:09:18 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: fix kmem_account_flags check in memcg_can_account_kmem()
References: <1385567162-14973-1-git-send-email-vdavydov@parallels.com> <20131129094502.GD25893@dhcp22.suse.cz>
In-Reply-To: <20131129094502.GD25893@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.24.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2013 01:45 PM, Michal Hocko wrote:
> On Wed 27-11-13 19:46:01, Vladimir Davydov wrote:
>> We should start kmem accounting for a memory cgroup only after both its
>> kmem limit is set (KMEM_ACCOUNTED_ACTIVE) and related call sites are
>> patched (KMEM_ACCOUNTED_ACTIVATED).
> This should be vice-versa, no? ACTIVE is set after
> static_key_slow_inc(&memcg_kmem_enabled_key) AFAICS.
>
>> Currently memcg_can_account_kmem() allows kmem accounting even if only
>> one of the conditions is true.
>> Fix it.
> It would be nice to describe, what is the actual problem here. I assume
> this is a charge vs. enable race. Let me try
>
> So we have KMEM_ACCOUNTED_ACTIVATED (set by memcg_update_cache_sizes)
> but the static key is not enabled yet (so KMEM_ACCOUNTED_ACTIVE is not
> set yet). memcg_can_account_kmem is called from 2 contexts during charge
> 	- memcg_kmem_get_cache via __memcg_kmem_get_cache
> 	- memcg_kmem_newpage_charge via __memcg_kmem_newpage_charge
>
> both of them start by checking memcg_kmem_enabled which is our
> static key before memcg_can_account_kmem. This would suggest that
> static_key+ACTIVE check memcg_can_account_kmem is sufficient. No?

Yes, I guess you're perfectly right and we don't need the ACTIVATED bit 
at all. I'll look at this deeper and send a patch removing it if it 
doesn't break something.

Thanks.
