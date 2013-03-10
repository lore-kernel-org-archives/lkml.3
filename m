Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab3CJKcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 06:32:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20207 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab3CJKcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 06:32:21 -0400
X-IronPort-AV: E=Sophos;i="4.84,818,1355068800"; 
   d="scan'208";a="6844235"
Message-ID: <513C61B9.5030004@cn.fujitsu.com>
Date: Sun, 10 Mar 2013 18:34:33 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCHSET wq/for-3.10-tmp] workqueue: implement workqueue with
 custom worker attributes
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/10 18:31:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/10 18:31:10,
	Serialize complete at 2013/03/10 18:31:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/13 11:23, Tejun Heo wrote:

Hi, Tejun,

I agree almost the whole design.(only except some locks)
And I found only a little problems for current review.

> 
> This patchset contains the following 31 patches.
> 
>  0001-workqueue-make-sanity-checks-less-punshing-using-WAR.patch

>  0002-workqueue-make-workqueue_lock-irq-safe.patch

workqueue_lock protects too many things. We can introduce different locks
for different purpose later.

>  0003-workqueue-introduce-kmem_cache-for-pool_workqueues.patch
>  0004-workqueue-add-workqueue_struct-pwqs-list.patch
>  0005-workqueue-replace-for_each_pwq_cpu-with-for_each_pwq.patch
>  0006-workqueue-introduce-for_each_pool.patch
>  0007-workqueue-restructure-pool-pool_workqueue-iterations.patch
>  0008-workqueue-add-wokrqueue_struct-maydays-list-to-repla.patch
>  0009-workqueue-consistently-use-int-for-cpu-variables.patch
>  0010-workqueue-remove-workqueue_struct-pool_wq.single.patch
>  0011-workqueue-replace-get_pwq-with-explicit-per_cpu_ptr-.patch
>  0012-workqueue-update-synchronization-rules-on-workqueue-.patch
>  0013-workqueue-update-synchronization-rules-on-worker_poo.patch

>  0014-workqueue-replace-POOL_MANAGING_WORKERS-flag-with-wo.patch
>  0015-workqueue-separate-out-init_worker_pool-from-init_wo.patch
>  0016-workqueue-introduce-workqueue_attrs.patch
>  0017-workqueue-implement-attribute-based-unbound-worker_p.patch
>  0018-workqueue-remove-unbound_std_worker_pools-and-relate.patch
>  0019-workqueue-drop-std-from-cpu_std_worker_pools-and-for.patch
>  0020-workqueue-add-pool-ID-to-the-names-of-unbound-kworke.patch
>  0021-workqueue-drop-WQ_RESCUER-and-test-workqueue-rescuer.patch
>  0022-workqueue-restructure-__alloc_workqueue_key.patch


>  0023-workqueue-implement-get-put_pwq.patch

I guess this patch and patch25 may have very deep issue VS RCU.

>  0024-workqueue-prepare-flush_workqueue-for-dynamic-creati.patch
>  0025-workqueue-perform-non-reentrancy-test-when-queueing-.patch
>  0026-workqueue-implement-apply_workqueue_attrs.patch
>  0027-workqueue-make-it-clear-that-WQ_DRAINING-is-an-inter.patch
>  0028-workqueue-reject-increasing-max_active-for-ordered-w.patch
>  0029-cpumask-implement-cpumask_parse.patch
>  0030-driver-base-implement-subsys_virtual_register.patch
>  0031-workqueue-implement-sysfs-interface-for-workqueues.patch
> 


for 1~13,15~22,26~28, please add Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>


> 0001-0003 are misc preps.
> 
> 0004-0008 update various iterators such that they don't operate on cpu
> number.
> 
> 0009-0011 are another set of misc preps / cleanups.
> 
> 0012-0014 update synchronization rules to prepare for dynamic
> management of pwqs and pools.
> 
> 0015-0022 introduce workqueue_attrs and prepare for dynamic management
> of pwqs and pools.
> 
> 0023-0026 implement dynamic application of workqueue_attrs which
> involes creating and destroying unbound pwqs and pools dynamically.
> 
> 0027-0028 prepare workqueue for sysfs exports.
> 
> 0029-0030 make cpumask and driver core changes for workqueue sysfs
> exports.
> 
> 0031 implements sysfs exports for workqueues.
> 
> This patchset is on top of
> 
> [1] wq/for-3.10-tmp 7bceeff75e ("workqueue: better define synchronization rule around rescuer->pool updates")
> 
> which is scheduled to be rebased on top of v3.9-rc1 once it comes out.
> The changes are also available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-attrs
> 
> diffstat follows.
> 
>  drivers/base/base.h         |    2 
>  drivers/base/bus.c          |   73 +
>  drivers/base/core.c         |    2 
>  include/linux/cpumask.h     |   15 
>  include/linux/device.h      |    2 
>  include/linux/workqueue.h   |   34 
>  kernel/workqueue.c          | 1716 +++++++++++++++++++++++++++++++-------------
>  kernel/workqueue_internal.h |    5 
>  8 files changed, 1322 insertions(+), 527 deletions(-)
> 
> Thanks.
> 
> --
> tejun
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.10-tmp
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

