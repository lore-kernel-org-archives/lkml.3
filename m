Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3BPIBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 03:01:13 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:24513 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3BPIBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 03:01:12 -0500
Message-ID: <511F3C6B.30604@huawei.com>
Date: Sat, 16 Feb 2013 15:59:39 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix cgroup_path() vs rename() race
References: <51022FC7.5020607@huawei.com> <511547EA.4090902@gmail.com>
In-Reply-To: <511547EA.4090902@gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for the late reply, just came back from holiday)

On 2013/2/9 2:46, Sasha Levin wrote:
> On 01/25/2013 02:09 AM, Li Zefan wrote:
>> rename() will change dentry->d_name. The result of this race can
>> be worse than seeing partially rewritten name, but we might access
>> a stale pointer because rename() will re-allocate memory to hold
>> a longer name.
>>
>> Use dentry_path_raw(), and this vfs API will take care of lockings.
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> Hi Li,
> 
> I was fuzzing with trinity inside a KVM tools guest, and stumbled on
> a lockdep spew related to this patch.
> 
> Here's the spew (brace yourself):
> 

dentry_path_raw() will grab rename_lock and dentry->d_lock without disabling
irq, which means cgroup_path() can't be called if the caller has already held
a spinlock with irq disabled.

Both blkio cgroup and cpu cgroup have this lock issue...The only fix is to
make a copy of dentry->d_name and save it in cgrp->name.

Patch will be followed.

> [  313.262599] ======================================================
> [  313.271340] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> [  313.277542] 3.8.0-rc6-next-20130208-sasha-00028-ge4e162d #278 Tainted: G        W
> [  313.277542] ------------------------------------------------------
> [  313.277542] kworker/u:3/4490 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> [  313.277542]  (rename_lock){+.+...}, at: [<ffffffff812a11f9>] dentry_path_raw+0x29/0x70
> [  313.277542]
> [  313.277542] and this task is already holding:
> [  313.277542]  (&(&q->__queue_lock)->rlock){-.-...}, at: [<ffffffff819e78f3>] put_io_context_active+0x63/0x100
> [  313.277542] which would create a new lock dependency:
> [  313.277542]  (&(&q->__queue_lock)->rlock){-.-...} -> (rename_lock){+.+...}
> [  313.277542]
> [  313.277542] but this new dependency connects a HARDIRQ-irq-safe lock:
> [  313.277542]  (&(&q->__queue_lock)->rlock){-.-...}
> ... which became HARDIRQ-irq-safe at:
> 
...
