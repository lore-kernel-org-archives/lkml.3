Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806Ab3CTMOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:14:10 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54422 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab3CTMOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:14:04 -0400
MIME-Version: 1.0
In-Reply-To: <1363737629-16745-1-git-send-email-tj@kernel.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
Date: Wed, 20 Mar 2013 20:14:02 +0800
Message-ID: <CACvQF52kd=MswzF=0sEuUspwhhatrdHZt_iTGp1M80dD0621Zw@mail.gmail.com>
Subject: Re: [PATCHSET wq/for-3.10] workqueue: NUMA affinity for unbound workqueues
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
        fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(off-topic)

Hi, tj,

 I think a0265a7f5161b6cb55e82b71edb236bbe0d9b3ae(tj/for-3.10) is
wrong direction, if workqueue_freezing is used only in
freeze_workqueues_begin()/thaw_workqueues(), which means it can be
removed or it is bug which is needed to be fixed. BUT
a0265a7f5161b6cb55e82b71edb236bbe0d9b3ae did not remove it nor fixed
it, it is unacceptable to me. actually it is bug, and I fixed it in my
patch1. any thought?

Thanks,
Lai

On Wed, Mar 20, 2013 at 8:00 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> There are two types of workqueues - per-cpu and unbound.  The former
> is bound to each CPU and the latter isn't not bound to any by default.
> While the recently added attrs support allows unbound workqueues to be
> confined to subset of CPUs, it still is quite cumbersome for
> applications where CPU affinity is too constricted but NUMA locality
> still matters.
>
> This patchset tries to solve that issue by automatically making
> unbound workqueues affine to NUMA nodes by default.  A work item
> queued to an unbound workqueue is executed on one of the CPUs allowed
> by the workqueue in the same node.  If there's none allowed, it may be
> executed on any cpu allowed by the workqueue.  It doesn't require any
> changes on the user side.  Every interface of workqueues functions the
> same as before.
>
> This would be most helpful to subsystems which use some form of async
> execution to process significant amount of data - e.g. crypto and
> btrfs; however, I wanted to find out whether it would make any dent in
> much less favorable use cases.  The following is total run time in
> seconds of buliding allmodconfig kernel w/ -j20 on a dual socket
> opteron machine with writeback thread pool converted to unbound
> workqueue and thus made NUMA-affine.  The file system is ext4 on top
> of a WD SSD.
>
>         before conversion               after conversion
>         1396.126                        1394.763
>         1397.621                        1394.965
>         1399.636                        1394.738
>         1397.463                        1398.162
>         1395.543                        1393.670
>
> AVG     1397.278                        1395.260        DIFF    2.018
> STDEV      1.585                           1.700
>
> And, yes, it actually made things go faster by about 1.2 sigma, which
> isn't completely conclusive but is a pretty good indication that it's
> actually faster.  Note that this is a workload which is dominated by
> CPU time and while there's writeback going on continously it really
> isn't touching too much data or a dominating factor, so the gain is
> understandably small, 0.14%, but hey it's still a gain and it should
> be much more interesting for crypto and btrfs which would actully
> access the data or workloads which are more sensitive to NUMA
> affinity.
>
> The implementation is fairly simple.  After the recent attrs support
> changes, a lot of the differences in pwq (pool_workqueue) handling
> between unbound and per-cpu workqueues are gone.  An unbound workqueue
> still has one "current" pwq that it uses for queueing any new work
> items but can handle multiple pwqs perfectly well while they're
> draining, so this patchset adds pwq dispatch table to unbound
> workqueues which is indexed by NUMA node and points to the matching
> pwq.  Unbound workqueues now simply have multiple "current" pwqs keyed
> by NUMA node.
>
> NUMA affinity can be turned off system-wide by workqueue.disable_numa
> kernel param or per-workqueue using "numa" sysfs file.
>
> This patchset contains the following ten patches.
>
>  0001-workqueue-add-wq_numa_tbl_len-and-wq_numa_possible_c.patch
>  0002-workqueue-drop-H-from-kworker-names-of-unbound-worke.patch
>  0003-workqueue-determine-NUMA-node-of-workers-accourding-.patch
>  0004-workqueue-add-workqueue-unbound_attrs.patch
>  0005-workqueue-make-workqueue-name-fixed-len.patch
>  0006-workqueue-move-hot-fields-of-workqueue_struct-to-the.patch
>  0007-workqueue-map-an-unbound-workqueues-to-multiple-per-.patch
>  0008-workqueue-break-init_and_link_pwq-into-two-functions.patch
>  0009-workqueue-implement-NUMA-affinity-for-unbound-workqu.patch
>  0010-workqueue-update-sysfs-interface-to-reflect-NUMA-awa.patch
>
> 0001 adds basic NUMA topology knoweldge to workqueue.
>
> 0002-0006 are prep patches.
>
> 0007-0009 implement NUMA affinity.
>
> 0010 adds control knobs and updates sysfs interface.
>
> This patchset is on top of
>
>  wq/for-3.10 a0265a7f51 ("workqueue: define workqueue_freezing static variable iff CONFIG_FREEZER")
>
> and also available in the following git branch.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-numa
>
> diffstat follows.
>
>  Documentation/kernel-parameters.txt |    9
>  include/linux/workqueue.h           |    5
>  kernel/workqueue.c                  |  393 ++++++++++++++++++++++++++++--------
>  3 files changed, 325 insertions(+), 82 deletions(-)
>
> Thanks.
>
> --
> tejun
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
