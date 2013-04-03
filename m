Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728Ab3DCJMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:12:50 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:38795 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759772Ab3DCJMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:12:45 -0400
Message-ID: <515BF233.6070308@huawei.com>
Date: Wed, 3 Apr 2013 17:11:15 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: <linux-mm@kvack.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC][PATCH 0/7] memcg: make memcg's life cycle the same as cgroup
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I'll be off from my office soon, and I won't be responsive in the following
3 days.)

I'm working on converting memcg to use cgroup->id, and then we can kill css_id.

Now memcg has its own refcnt, so when a cgroup is destroyed, the memcg can
still be alive. This patchset converts memcg to always use css_get/put, so
memcg will have the same life cycle as its corresponding cgroup, and then
it's always safe for memcg to use cgroup->id.

The historical reason that memcg didn't use css_get in some cases, is that
cgroup couldn't be removed if there're still css refs. The situation has
changed so that rmdir a cgroup will succeed regardless css refs, but won't
be freed until css refs goes down to 0.

This is an early post, and it's NOT TESTED. I just want to see if the changes
are fine in general.

btw, after this patchset I think we don't need to free memcg via RCU, because
cgroup is already freed in RCU callback.

Note this patchset is based on a few memcg fixes I sent (but hasn't been
accepted)

--
 kernel/cgroup.c |  10 ++++++++
 mm/memcontrol.c | 129 ++++++++++++++++++++++++++++++++++++++-------------------------------------------------------
 2 files changed, 62 insertions(+), 77 deletions(-)
