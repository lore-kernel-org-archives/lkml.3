Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaFDJAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:00:33 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:9267 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaFDJAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:00:30 -0400
Message-ID: <538EE00F.10406@huawei.com>
Date: Wed, 4 Jun 2014 16:59:59 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] cgroup: make the default root invisible when it's
 umounted
References: <538D4956.5050205@huawei.com> <538D4982.10905@huawei.com> <20140603130144.GB26210@htj.dyndns.org>
In-Reply-To: <20140603130144.GB26210@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/3 21:01, Tejun Heo wrote:
> On Tue, Jun 03, 2014 at 12:05:22PM +0800, Li Zefan wrote:
>> Before this patch (in a fresh system):
>>
>>    # cat /proc/$$/cgroup
>>    # mount -t cgroup -o __DEVEL__sane_behavior xxx /cgroup
>>    # umount /cgroup
>>    # cat /proc/$$/cgroup
>>    0:cpuset,cpu,cpuacct,memory,devices,freezer,net_cls,blkio,perf_event,net_prio,hugetlb:/
>>
>> After this patch (in a fresh system):
>>
>>    # cat ...
>>    # mount ...
>>    # umount ...
>>    # cat /proc/$$/cgroup
>>    #
>>
>> You won't see the default root after it's umounted.
> 
> Hmmmm... I intentionally left it visible tho.  The only reason we gate
> its visibility is avoid disturbing userland which doesn't know about
> and won't use the unified hierarchy.  If the userland starts making
> use of it, there's no reason to hide it again especially as that's
> consistent with how other hierarchies behave too - they keep showing
> up if they have lingering refs.
> 

The example I gave is the same result if sane_behavior is not specified,
so this is a behavioural change for the old interface?

Do we need a fix like this?

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3f46165..6f10cff 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1789,6 +1789,9 @@ static void cgroup_kill_sb(struct super_block *sb)
 	else
 		percpu_ref_kill(&root->cgrp.self.refcnt);

+	if (root == &cgrp_dfl_root && !cgroup_sane_behavior(&root->cgrp))
+		cgrp_dfl_root_visible = false;
+
 	kernfs_kill_sb(sb);
 

