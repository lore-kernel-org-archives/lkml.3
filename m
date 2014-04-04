Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaDDJQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:16:04 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:37668 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaDDJP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:15:58 -0400
Message-ID: <533E7801.8090604@huawei.com>
Date: Fri, 4 Apr 2014 17:14:41 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
References: <20140403164911.GE24119@htj.dyndns.org> <CA+55aFy1dm_CoTv+tihQ+m54G3gR9siOngurHsuKf9W3k1sKKw@mail.gmail.com> <CA+55aFwBm202pchEH9A6vbJVdar9-T35pBF44cCt7FNjmno9sQ@mail.gmail.com> <CAOS58YMckmoCocguf9BC_Wxbn3D2Rx3MArhgozO9qCj4g=5aDw@mail.gmail.com> <CA+55aFw2+VKojzoF2aDaruOMKHikTO8J0HeK9DoDLZr+HqTWbg@mail.gmail.com> <20140403194335.GC2472@mtj.dyndns.org>
In-Reply-To: <20140403194335.GC2472@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/4 3:43, Tejun Heo wrote:
> Hello,
> 
> On Thu, Apr 03, 2014 at 12:01:23PM -0700, Linus Torvalds wrote:
>> [ Extending the participants list a bit ]
>>
>> On Thu, Apr 3, 2014 at 11:34 AM, Tejun Heo <tj@kernel.org> wrote:
>>> On the road so sending from phone. Iirc the param is necessary to
>>> distinguishe when a new sb is created so that it can be put properly later.
>>> I think cgroup is leaking super ref now and li was planning to send a fix
>>> once things are merged.
>>
>> So as far as I can tell, cgroup is fine, because the superblock itself
>> is properly refcounted by the mounting code. It's the magic hidden
> 
> Ah, I remembered the other way around.  We could leak cgroup_root
> reference, not the other way around.  cgroup_mount() can be called
> multiple times for the same sb and we inc cgroup_root's ref each time
> but cgroup_kill_sb() only happens when the sb is released, so if we do
> the following,
> 
>  # mkdir cpuset cpuset1
>  # mount -t cgroup -o cpuset cgroup cpuset
>  # mount -t cgroup -o cpuset cgroup cpuset1
>  # umount cpuset
>  # umount cpuset1
> 
> The cgroup_root should be destroyed but it isn't, I think.  We'd need
> to bump cgroup_root's refcnt only when a new sb is created.

Yeah, I had been waiting for the kernfs change to be merged into mainline,
so I can fix this cgroup refcnting, and here is the fix.

====================

[PATCH] cgroup: fix top cgroup refcnt leak

As mount() and kill_sb() is not a one-to-one match, If we mount the same
cgroupfs in serveral mount points, and then umount all of them, kill_sb()
will be called only once.

Try:
        # mount -t cgroup -o cpuacct xxx /cgroup
        # mount -t cgroup -o cpuacct xxx /cgroup2
        # cat /proc/cgroups | grep cpuacct
        cpuacct 2       1       1
        # umount /cgroup
        # umount /cgroup2
        # cat /proc/cgroups | grep cpuacct
        cpuacct 2       1       1

You'll see cgroupfs will never be freed.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2189462..48bd9c9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1487,6 +1487,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	struct cgroup_sb_opts opts;
 	struct dentry *dentry;
 	int ret;
+	bool new_sb;
 
 	/*
 	 * The first time anyone tries to mount a cgroup, enable the list
@@ -1603,8 +1604,8 @@ out_unlock:
 	if (ret)
 		return ERR_PTR(ret);
 
-	dentry = kernfs_mount(fs_type, flags, root->kf_root, NULL);
-	if (IS_ERR(dentry))
+	dentry = kernfs_mount(fs_type, flags, root->kf_root, &new_sb);
+	if (IS_ERR(dentry) || !new_sb)
 		cgroup_put(&root->cgrp);
 	return dentry;
 }
-- 
1.8.0.2


