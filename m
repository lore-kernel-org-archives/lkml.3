Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaENDPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:15:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57640 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaENDPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:15:16 -0400
Message-ID: <5372DFBC.6020303@huawei.com>
Date: Wed, 14 May 2014 11:15:08 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: use css->refcnt for cgroup
 reference counting
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/10 5:13, Tejun Heo wrote:
> Hello,
> 
> Currently, cgroup and css (cgroup_subsys_state) are separately
> reference counted.  cgroup->refcnt is an atomic_t and css->refcnt is a
> percpu_ref.  css is becoming the primary structural block and used
> widely in various operaitons.  cgroup already has a css embedded in it
> (cgroup->dummy_css) to use as its proxy in such operations; however,
> there still are quite a few differences between cgroup and css
> handling limitng how cgroup->dummy_css can be used.
> 
> This patchset makes cgroup use the embedded css's refcnt for reference
> counting.  This closes one of the gaps between an cgroup embedded css,
> which is renamed to cgroup->self early in the patchset, and a normal
> css and will allow more unified handling of cgroups and csses.  In
> addition, this makes cgroup refcnting use percpu_ref too, which is a
> lot more scalable than an atomic_t.
> 
> Ultimately, it'd make things far simpler to assign a proper
> cgroup_subsys to the cgroup embedded csses and handle them the same as
> other csses; however, we can't yet do it thanks to multiple
> hierarchies as we end up with multiple csses of the same subsystem for
> the same task, but in the very long term, if multiple hierarchies can
> be removed, that's where it's headed.
> 
> This patchset contains the following nine patches.
> 
>  0001-cgroup-use-restart_syscall-for-mount-retries.patch
>  0002-cgroup-rename-cgroup-dummy_css-to-self-and-move-it-t.patch
>  0003-cgroup-separate-out-cgroup_has_live_children-from-cg.patch
>  0004-cgroup-move-check_for_release-parent-call-to-the-end.patch
>  0005-cgroup-move-cgroup-sibling-unlinking-to-cgroup_put.patch
>  0006-cgroup-remove-cgroup_destory_css_killed.patch
>  0007-cgroup-bounce-css-release-through-css-destroy_work.patch
>  0008-cgroup-enable-refcnting-for-root-csses.patch
>  0009-cgroup-use-cgroup-self.refcnt-for-cgroup-refcnting.patch
> 
> 0001-0003 are prep patches.
> 
> 0004-0006 remove cgroup_destroy_css_killed().  This brings cgroup's
> destruction path closer to css's so that they can be merged.
> 
> 0007-0009 make cgroup use the embedded css's refcnt.
> 
> This pachset is on top of
> 
>  b9a63d0116e8 ("Merge branch 'for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu into for-3.16")
>  + [1] [PATCHSET v2 cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
>  + [2] (REFRESHED) [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
>  + [3] (REFRESHED) [PATCHSET cgroup/for-3.16] cgroup: remove cgroup_tree_mutex
> 
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-use-css-ref
> 
> diffstat follows.  Thanks.
> 
>  include/linux/cgroup.h |   25 ----
>  kernel/cgroup.c        |  284 ++++++++++++++++++++++---------------------------
>  2 files changed, 136 insertions(+), 173 deletions(-)
> 

With the memory leak fixed:

Acked-by: Li Zefan <lizefan@huawei.com>

