Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaA2EDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 23:03:08 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:56007 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbaA2EDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 23:03:06 -0500
Message-ID: <52E87D64.30800@huawei.com>
Date: Wed, 29 Jan 2014 12:02:44 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] cgroup: move the one-off opts sanity check in cgroup_root_from_opts()
 to parse_cgroupfs_options()
References: <1390923125-4369-1-git-send-email-tj@kernel.org> <1390923125-4369-5-git-send-email-tj@kernel.org>
In-Reply-To: <1390923125-4369-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/28 23:32, Tejun Heo wrote:
> cgroup_root_from_opts() checks whether (!opts->subsys_mask &&
> !opts->none) and returns NULL if so.  After that, if allocation fails,
> returns ERR_PTR(-ENOMEM).  The caller, cgroup_mount(), doesn't treat
> NULL as an error but set opts.new_root to NULL; however, later on,
> cgroup_set_super() fails with -EINVAL if new_root is NULL.

This patch changes mount semantics.

If cgroup_root_from_opts() returns NULL, it means we should be looking
for existing superblock only.

This will fail:

  # mount -t cgroup -o name=abc xxx /mnt

But this is ok:

  # mount -t cgroup -o none,name=abc xxx /mnt
  # mkdir /mnt/sub
  # umount /mnt
  # mount -t cgroup -o name=abc xxx /mnt   <-- this won't work with your patch

> 
> This is one bizarre error handling sequence especially when all other
> opts sanity checks including the very close (!opts->subsys_mask &&
> !opts->name) check are done in parse_cgroupfs_options().
> 
> Let's move the one-off check in cgroup_root_from_opts() to
> parse_cgroupfs_options() where it can be combined with the
> (!opts->subsys_mask && !opts->name) check.  cgroup_root_from_opts() is
> updated to return NULL on memory allocation failure.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

