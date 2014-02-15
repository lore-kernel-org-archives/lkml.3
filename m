Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaBOUSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 15:18:08 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35468 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaBOUSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 15:18:06 -0500
Message-ID: <52FFCB70.3090600@gmail.com>
Date: Sun, 16 Feb 2014 04:17:52 +0800
From: Li Zefan <lizf.kern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>, Tejun Heo <tj@kernel.org>
CC: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [cgroups] BUG: unable to handle kernel NULL pointer dereference
 at 0000003c
References: <20140215124212.GA8782@localhost>
In-Reply-To: <20140215124212.GA8782@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014年02月15日 20:42, Fengguang Wu 写道:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
> commit de00ffa56ea3132c6013fc8f07133b8a1014cf53
> Author:     Tejun Heo <tj@kernel.org>
> AuthorDate: Tue Feb 11 11:52:48 2014 -0500
> Commit:     Tejun Heo <tj@kernel.org>
> CommitDate: Tue Feb 11 11:52:48 2014 -0500
> 
>     cgroup: make cgroup_subsys->base_cftypes use cgroup_add_cftypes()
>     
>     Currently, cgroup_subsys->base_cftypes registration is different from
>     dynamic cftypes registartion.  Instead of going through
>     cgroup_add_cftypes(), cgroup_init_subsys() invokes
>     cgroup_init_cftsets() which makes use of cgroup_subsys->base_cftset
>     which doesn't involve dynamic allocation.
>     
>     While avoiding dynamic allocation is somewhat nice, having two
>     separate paths for cftypes registration is nasty, especially as we're
>     planning to add more operations during cftypes registration.
>     
>     This patch drops cgroup_init_cftsets() and cgroup_subsys->base_cftset
>     and registers base_cftypes using cgroup_add_cftypes().  This is done
>     as a separate step in cgroup_init() instead of a part of
>     cgroup_init_subsys().  This is because cgroup_init_subsys() can be
>     called very early during boot when kmalloc() isn't available yet.
>     
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Acked-by: Li Zefan <lizefan@huawei.com>
> 
> [    0.020000] Calibrating delay loop (skipped) preset value.. 5786.00 BogoMIPS (lpj=28930000)
> [    0.020000] pid_max: default: 32768 minimum: 301
> [    0.020000] Mount-cache hash table entries: 512
> [    0.020000] BUG: unable to handle kernel NULL pointer dereference at 0000003c
> [    0.020000] IP: [<cc90b4ad>] cgroup_cfts_commit+0x27/0x1c1
> [    0.020000] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
> [    0.020000] Oops: 0000 [#1] SMP 
> [    0.020000] Modules linked in:
> [    0.020000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc2-next-20140212-02521-g4602175 #1
> [    0.020000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.020000] task: cd497910 ti: cd492000 task.ti: cd492000
> [    0.020000] EIP: 0060:[<cc90b4ad>] EFLAGS: 00210282 CPU: 0
> [    0.020000] EIP is at cgroup_cfts_commit+0x27/0x1c1
> [    0.020000] EAX: cd4b1d0c EBX: cf004fa0 ECX: 00000001 EDX: 00000001
> [    0.020000] ESI: 00000000 EDI: cd9820d4 EBP: cd493fa4 ESP: cd493f70
> [    0.020000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [    0.020000] CR0: 8005003b CR2: 0000003c CR3: 0d96e000 CR4: 000006b0
> [    0.020000] Stack:
> [    0.020000]  cf004fa0 cd4b1d4c 00200246 cd9820d4 cc9d1129 0190c691 0000000c 000080d0
> [    0.020000]  cd493f90 cd493f90 cf004fa0 cd9820d4 cd4accc4 cd493fbc cc90c6fc 00000000
> [    0.020000]  00000000 00000000 cd970800 cd493fcc cd78b646 00000000 00020800 cd493fe8
> [    0.020000] Call Trace:
> [    0.020000]  [<cc9d1129>] ? kmem_cache_alloc_trace+0x33f/0x3b7
> [    0.020000]  [<cc90c6fc>] cgroup_add_cftypes+0x8f/0xca
> [    0.020000]  [<cd78b646>] cgroup_init+0x6a/0x26a
> [    0.020000]  [<cd764d7d>] start_kernel+0x4d7/0x57a
> [    0.020000]  [<cd7642ef>] i386_start_kernel+0x92/0x96
> [    0.020000] Code: 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 28 e8 94 ab 71 00 89 c7 8b 77 50 89 45 d8 8d 45 ec 89 45 ec 89 45 f0 b8 0c 1d 4b cd 88 55 e3 <8b> 5e 3c e8 c9 4d 71 00 85 ff 74 0e 31 c0 81 7e 3c c8 43 ec cd
> [    0.020000] EIP: [<cc90b4ad>] cgroup_cfts_commit+0x27/0x1c1 SS:ESP 0068:cd493f70
> [    0.020000] CR2: 000000000000003c
> [    0.020000] ---[ end trace fd4743fe17bdbf8e ]---
> [    0.020000] Kernel panic - not syncing: Fatal exception
> 

This is a corner case. If CGROUP_SCHED=y but FAIR_GROUP_SCHED=n && CFS_BANDWIDTH=n &&
RT_GROUP_SCHED=n:

static struct cftype cpu_files[] = {
        { }     /* terminate */
};

Should be fixed by the following change. Will test it and send out a formal
patch on Monday.

It's 4 a.m on Sunday, and I lose sleep. :(

---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 851251b..fa393d84 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2348,6 +2348,9 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	int ret;
 
+	if (!cfts || cfts[0].name[0] == '\0')
+		return 0;
+
 	ret = cgroup_init_cftypes(ss, cfts);
 	if (ret)
 		return ret;

