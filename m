Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbaA2Dhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 22:37:48 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:4333 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbaA2Dhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 22:37:46 -0500
Message-ID: <52E87780.1040002@huawei.com>
Date: Wed, 29 Jan 2014 11:37:36 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 3/4] cgroup: fix locking in cgroup_cfts_commit()
References: <1390923125-4369-1-git-send-email-tj@kernel.org> <1390923125-4369-4-git-send-email-tj@kernel.org>
In-Reply-To: <1390923125-4369-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/28 23:32, Tejun Heo wrote:
> cgroup_cfts_commit() walks the cgroup hierarchy that the target
> subsystem is attached to and tries to apply the file changes.  Due to
> the convolution with inode locking, it can't keep cgroup_mutex locked
> while iterating.  It currently holds only RCU read lock around the
> actual iteration and then pins the found cgroup using dget().
> 
> Unfortunately, this is incorrect.  Although the iteration does check
> cgroup_is_dead() before invoking dget(), there's nothing which
> prevents the dentry from going away inbetween.  Note that this is
> different from the usual css iterations where css_tryget() is used to
> pin the css - css_tryget() tests whether the css can be pinned and
> fails if not.
> 
> The problem can be solved by simply holding cgroup_mutex instead of
> RCU read lock around the iteration, which actually reduces LOC.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: stable@vger.kernel.org

Good catch!

Acked-by: Li Zefan <lizefan@huawei.com>
