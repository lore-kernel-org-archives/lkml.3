Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab3FMGF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 02:05:58 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:56449 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3FMGF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 02:05:56 -0400
Message-ID: <51B960FF.7070604@huawei.com>
Date: Thu, 13 Jun 2013 14:04:47 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <koverstreet@google.com>, <linux-kernel@vger.kernel.org>,
        <cl@linux-foundation.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.11] cgroup: convert cgroup_subsys_state
 refcnt to percpu_ref
References: <1371096298-24402-1-git-send-email-tj@kernel.org>
In-Reply-To: <1371096298-24402-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/13 12:04, Tejun Heo wrote:
> Hello,
> 
> The changes from the last take[L] are,
> 
> * Rebased on top of further percpu-refcount updates.
> 
> * 0003: Broken patch description updated.
> 
> * 0004: Stupid list_del_init() conversions from the last decade
>         dropped.
> 
> * 0005: Typo fix.
> 
> * 0011: percpu_ref_init() error handling fixed.  Premature and
>         duplicate base css ref puts fixed.
> 
> This patchset does a lot of cleanup and then updates css
> (cgroup_subsys_state) refcnt to use the new percpu reference counter.
> A css (cgroup_subsys_state) is how each cgroup is represented to a
> controller.  As such, it can be used in hot paths across the various
> subsystems different controllers are associated with.
> 
> One of the common operations is reference counting, which up until now
> has been implemented using a global atomic counter and can have
> significant adverse impact on scalability.  For example, css refcnt
> can be gotten and put multiple times by blkcg for each IO request.
> For highops configurations which try to do as much per-cpu as
> possible, the global frequent refcnting can be very expensive.
> 
> In general, given the various hugely diverse paths css's end up being
> used from, we need to make it cheap and highly scalable.  In its
> usage, css refcnting isn't very different from module refcnting.
> 
> This patchset contains the following 11 patches.
> 
>  0001-cgroup-remove-now-unused-css_depth.patch
>  0002-cgroup-consistently-use-cset-for-struct-css_set-vari.patch
>  0003-cgroup-bring-some-sanity-to-naming-around-cg_cgroup_.patch
>  0004-cgroup-use-kzalloc-instead-of-kmalloc.patch
>  0005-cgroup-clean-up-css_-try-get-and-css_put.patch
>  0006-cgroup-rename-CGRP_REMOVED-to-CGRP_DEAD.patch
>  0007-cgroup-drop-unnecessary-RCU-dancing-from-__put_css_s.patch
>  0008-cgroup-remove-cgroup-count-and-use.patch
>  0009-cgroup-reorder-the-operations-in-cgroup_destroy_lock.patch
>  0010-cgroup-split-cgroup-destruction-into-two-steps.patch
>  0011-cgroup-use-percpu-refcnt-for-cgroup_subsys_states.patch
> 
> 0001-0007 are cleanups, many of them cosmetic.  They clean up the code
> paths which are related with the refcnting changes.  If you're only
> interested in the precpu usage, you can probably skip these.
> 
> 0008-0010 updates the cgroup destruction path so that percpu refcnting
> can be used.
> 
> 0011 updates css refcnting to use percpu_ref.
> 
> This patchset is on top of
> 
>   cgroup/for-3.11 d5c56ced77 ("cgroup: clean up the cftype array for the base cgroup files")
> + [1] percpu/review-percpu-ref-tryget
> 
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-css-percpu-ref
> 
> diffstat follows.  Thanks.
> 
>  include/linux/cgroup.h |   87 ++---
>  kernel/cgroup.c        |  723 ++++++++++++++++++++++++++-----------------------
>  2 files changed, 420 insertions(+), 390 deletions(-)
> 

Acked-by: Li Zefan <lizefan@huawei.com>

