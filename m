Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161821Ab3DEHgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 03:36:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24032 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab3DEHgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 03:36:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,413,1363104000"; 
   d="scan'208";a="7001533"
Message-ID: <515E7FA0.6030903@cn.fujitsu.com>
Date: Fri, 05 Apr 2013 15:39:12 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] workqueue: avoid false negative WARN_ON() in destroy_workqueue()
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com> <1365041143-3088-7-git-send-email-laijs@cn.fujitsu.com> <20130404145514.GJ9425@htj.dyndns.org>
In-Reply-To: <20130404145514.GJ9425@htj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/05 15:35:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/05 15:35:17,
	Serialize complete at 2013/04/05 15:35:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 10:55 PM, Tejun Heo wrote:
>>From 5c529597e922c26910fe49b8d5f93aeaca9a2415 Mon Sep 17 00:00:00 2001
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date: Thu, 4 Apr 2013 10:05:38 +0800
> 
> destroy_workqueue() performs several sanity checks before proceeding
> with destruction of a workqueue.  One of the checks verifies that
> refcnt of each pwq (pool_workqueue) is over 1 as at that point there
> should be no in-flight work items and the only holder of pwq refs is
> the workqueue itself.
> 
> This worked fine as a workqueue used to hold only one reference to its
> pwqs; however, since 4c16bd327c ("workqueue: implement NUMA affinity
> for unbound workqueues"), a workqueue may hold multiple references to
> its default pwq triggering this sanity check spuriously.
> 
> Fix it by not triggering the pwq->refcnt assertion on default pwqs.
> 
> An example spurious WARN trigger follows.
> 
>  WARNING: at kernel/workqueue.c:4201 destroy_workqueue+0x6a/0x13e()
>  Hardware name: 4286C12
>  Modules linked in: sdhci_pci sdhci mmc_core usb_storage i915 drm_kms_helper drm i2c_algo_bit i2c_core video
>  Pid: 361, comm: umount Not tainted 3.9.0-rc5+ #29
>  Call Trace:
>   [<c04314a7>] warn_slowpath_common+0x7c/0x93
>   [<c04314e0>] warn_slowpath_null+0x22/0x24
>   [<c044796a>] destroy_workqueue+0x6a/0x13e
>   [<c056dc01>] ext4_put_super+0x43/0x2c4
>   [<c04fb7b8>] generic_shutdown_super+0x4b/0xb9
>   [<c04fb848>] kill_block_super+0x22/0x60
>   [<c04fb960>] deactivate_locked_super+0x2f/0x56
>   [<c04fc41b>] deactivate_super+0x2e/0x31
>   [<c050f1e6>] mntput_no_expire+0x103/0x108
>   [<c050fdce>] sys_umount+0x2a2/0x2c4
>   [<c050fe0e>] sys_oldumount+0x1e/0x20
>   [<c085ba4d>] sysenter_do_call+0x12/0x38
> 
> tj: Rewrote description.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>

Hi, Wu

Could you also send regression-report of workqueue to me?

Thanks,
Lai

> ---
> Applied to wq/for-3.10.
> 
> Thanks.
> 
>  kernel/workqueue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index dd2a4c4..c273376 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4201,7 +4201,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
>  			}
>  		}
>  
> -		if (WARN_ON(pwq->refcnt > 1) ||
> +		if (WARN_ON((pwq != wq->dfl_pwq) && (pwq->refcnt > 1)) ||
>  		    WARN_ON(pwq->nr_active) ||
>  		    WARN_ON(!list_empty(&pwq->delayed_works))) {
>  			mutex_unlock(&wq->mutex);

