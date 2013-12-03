Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3LCH4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 02:56:32 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:51130 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3LCH4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 02:56:30 -0500
MIME-Version: 1.0
In-Reply-To: <529CDDB3.3090301@parallels.com>
References: <1385989693-28788-1-git-send-email-vdavydov@parallels.com>
	<20131202181501.GA5524@dhcp22.suse.cz>
	<CAA6-i6rWsZNQmFY5L-=yc6TaTGyg4hP4qn9gMZVsu8wWJ=1ywg@mail.gmail.com>
	<529CDDB3.3090301@parallels.com>
Date: Tue, 3 Dec 2013 11:56:29 +0400
Message-ID: <CAA6-i6q+WooWMSbJwLS=ByVu=fgAQuep99iP7tAXiuLABu2gVA@mail.gmail.com>
Subject: Re: [PATCH] memcg: remove KMEM_ACCOUNTED_ACTIVATED
From: Glauber Costa <glommer@gmail.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, devel@openvz.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 11:21 PM, Vladimir Davydov
<vdavydov@parallels.com> wrote:
> On 12/02/2013 10:26 PM, Glauber Costa wrote:
>>
>> On Mon, Dec 2, 2013 at 10:15 PM, Michal Hocko <mhocko@suse.cz> wrote:
>>>
>>> [CCing Glauber - please do so in other posts for kmem related changes]
>>>
>>> On Mon 02-12-13 17:08:13, Vladimir Davydov wrote:
>>>>
>>>> The KMEM_ACCOUNTED_ACTIVATED was introduced by commit a8964b9b ("memcg:
>>>> use static branches when code not in use") in order to guarantee that
>>>> static_key_slow_inc(&memcg_kmem_enabled_key) will be called only once
>>>> for each memory cgroup when its kmem limit is set. The point is that at
>>>> that time the memcg_update_kmem_limit() function's workflow looked like
>>>> this:
>>>>
>>>>        bool must_inc_static_branch = false;
>>>>
>>>>        cgroup_lock();
>>>>        mutex_lock(&set_limit_mutex);
>>>>        if (!memcg->kmem_account_flags && val != RESOURCE_MAX) {
>>>>                /* The kmem limit is set for the first time */
>>>>                ret = res_counter_set_limit(&memcg->kmem, val);
>>>>
>>>>                memcg_kmem_set_activated(memcg);
>>>>                must_inc_static_branch = true;
>>>>        } else
>>>>                ret = res_counter_set_limit(&memcg->kmem, val);
>>>>        mutex_unlock(&set_limit_mutex);
>>>>        cgroup_unlock();
>>>>
>>>>        if (must_inc_static_branch) {
>>>>                /* We can't do this under cgroup_lock */
>>>>                static_key_slow_inc(&memcg_kmem_enabled_key);
>>>>                memcg_kmem_set_active(memcg);
>>>>        }
>>>>
>>>> Today, we don't use cgroup_lock in memcg_update_kmem_limit(), and
>>>> static_key_slow_inc() is called under the set_limit_mutex, but the
>>>> leftover from the above-mentioned commit is still here. Let's remove it.
>>>
>>> OK, so I have looked there again and 692e89abd154b (memcg: increment
>>> static branch right after limit set) which went in after cgroup_mutex
>>> has been removed. It came along with the following comment.
>>>                  /*
>>>                   * setting the active bit after the inc will guarantee
>>> no one
>>>                   * starts accounting before all call sites are patched
>>>                   */
>>>
>>> This suggests that the flag is needed after all because we have
>>> to be sure that _all_ the places have to be patched. AFAIU
>>> memcg_kmem_newpage_charge might see the static key already patched so
>>> it would do a charge but memcg_kmem_commit_charge would still see it
>>> unpatched and so the charge won't be committed.
>>>
>>> Or am I missing something?
>>
>> You are correct. This flag is there due to the way we are using static
>> branches.
>> The patching of one call site is atomic, but the patching of all of
>> them are not.
>> Therefore we need to use a two-flag scheme to guarantee that in the first
>> time
>> we turn the static branches on, there will be a clear point after
>> which we're going
>> to start accounting.
>
>
> Hi, Glauber
>
> Sorry, but I don't understand why we need two flags. Isn't checking the flag
> set after all call sites have been patched (I mean KMEM_ACCOUNTED_ACTIVE)
> not enough?

Take a look at net/ipv4/tcp_memcontrol.c. There are comprehensive comments there
for a mechanism that basically achieves the same thing. The idea is
that one flag is used
at all times and means "it is enabled". The second flags is a one time
only flag to indicate
that the patching process is complete. With one flag it seems to work,
but it is racy.

-- 
E Mare, Libertas
