Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab3CHDQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:16:09 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:50974 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174Ab3CHDQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:16:07 -0500
Message-ID: <513957E3.8000406@huawei.com>
Date: Fri, 8 Mar 2013 11:15:47 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
CC: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: next-20130306 - BUG: unable to handle kernel paging reques in
 avc_has_perm_noaudit
References: <3077.1362687651@turing-police.cc.vt.edu>
In-Reply-To: <3077.1362687651@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/8 4:20, Valdis Kletnieks wrote:
> Seeing this in next-20130306:
> 
> [  180.958482] BUG: unable to handle kernel paging request at ffffffffffffffe0
> [  180.958488] IP: [<ffffffff811e5661>] avc_has_perm_noaudit+0xbf/0x1bc
> 
> [  180.958506] Pid: 1910, comm: systemd-udevd Tainted: G           O 3.9.0-rc1-next-20130306-dirty #64 Dell Inc. Latitude E6500
> 
> [  180.958537]  [<ffffffff811e5790>] avc_has_perm_flags+0x32/0xe4
> [  180.958540]  [<ffffffff81071c81>] ? mark_lock+0x2e/0x225
> [  180.958543]  [<ffffffff811e5ada>] avc_has_perm+0xf/0x11
> [  180.958546]  [<ffffffff811e5e92>] selinux_inode_rename+0x84/0x138
> [  180.958549]  [<ffffffff811002b6>] ? __kmalloc_track_caller+0x107/0x119
> [  180.958552]  [<ffffffff811e36db>] security_inode_rename+0x6f/0x7a
> [  180.958556]  [<ffffffff81115a8f>] vfs_rename+0x1e2/0x36a
> [  180.958558]  [<ffffffff81115e04>] SYSC_renameat+0x1ed/0x282
> [  180.958562]  [<ffffffff81123485>] ? mntput+0x49/0x50
> [  180.958566]  [<ffffffff81068576>] ? __read_seqcount_retry.constprop.21+0x20/0x25
> [  180.958568]  [<ffffffff81068b1c>] ? current_kernel_time+0x2a/0x41
> [  180.958572]  [<ffffffff81094215>] ? __audit_syscall_entry+0xf9/0x125
> [  180.958575]  [<ffffffff8111681f>] SyS_renameat+0x9/0xb
> [  180.958577]  [<ffffffff81116837>] SyS_rename+0x16/0x1b
> [  180.958581]  [<ffffffff815f55d2>] system_call_fastpath+0x16/0x1b
> 
> Most suspicious-looking recent commit in git log:
> 

I don't think so. The commit changes cgroup_rename(), but the above stack doesn't
sugguest it was renaming a cgroup directory.

> ommit 65dff759d2948cf18e2029fc5c0c595b8b7da3a5
> Author: Li Zefan <lizefan@huawei.com>
> Date:   Fri Mar 1 15:01:56 2013 +0800
> 
>     cgroup: fix cgroup_path() vs rename() race
> 
>     rename() will change dentry->d_name. The result of this race can
>     be worse than seeing partially rewritten name, but we might access
>     a stale pointer because rename() will re-allocate memory to hold
>     a longer name.
> 
> I admit not having any clue what crazy antics systemd was trying to do
> at the time.  If this doesn't ring a bell, I'll go bisect it.
> 

