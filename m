Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3GBDDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 23:03:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:18204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab3GBDDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 23:03:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,977,1363158000"; 
   d="scan'208";a="359068456"
Message-ID: <51D24336.5020504@intel.com>
Date: Tue, 02 Jul 2013 11:04:22 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'James Bottomley'" <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] block: Fix possible sleep in invalid context
References: <1372692515-31969-1-git-send-email-sthumma@codeaurora.org>
In-Reply-To: <1372692515-31969-1-git-send-email-sthumma@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 11:28 PM, Sujit Reddy Thumma wrote:
> When block runtime PM is enabled following warning is seen
> while resuming the device.
> 
> BUG: sleeping function called from invalid context at
> .../drivers/base/power/runtime.c:923
> in_atomic(): 1, irqs_disabled(): 128, pid: 12, name: kworker/0:1
> [<c0014448>] (unwind_backtrace+0x0/0x120) from
> [<c03120e4>] (__pm_runtime_suspend+0x34/0xa0) from
> [<c021c33c>] (blk_post_runtime_resume+0x4c/0x5c) from
> [<c03297cc>] (scsi_runtime_resume+0x90/0xb4) from
> [<c0310940>] (__rpm_callback+0x30/0x58) from
> [<c0310980>] (rpm_callback+0x18/0x28) from
> [<c0311ab0>] (rpm_resume+0x3dc/0x540) from
> [<c03120a4>] (pm_runtime_work+0x8c/0x98) from
> [<c007767c>] (process_one_work+0x238/0x3e4) from
> [<c0077b90>] (worker_thread+0x1ac/0x2ac) from
> [<c007cfdc>] (kthread+0x88/0x94) from
> [<c000ece0>] (kernel_thread_exit+0x0/0x8)
> 
> Fix this by releasing spin_lock_irq() before calling
> pm_runtime_autosuspend() in blk_post_runtime_resume().

Hi Sujit,

Thanks for testing out block layer runtime PM!

As for the problem here, it is already fixed by:

commit c60855cdb976c632b3bf8922eeab8a0e78edfc04
Author: Aaron Lu <aaron.lu@intel.com>
Date:   Fri May 17 15:47:20 2013 +0800

    blkpm: avoid sleep when holding queue lock

-Aaron

> 
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Cc: stable@vger.kernel.org
> ---
>  block/blk-core.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 33c33bc..2456116 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -3159,16 +3159,18 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
>   */
>  void blk_post_runtime_resume(struct request_queue *q, int err)
>  {
> -	spin_lock_irq(q->queue_lock);
>  	if (!err) {
> +		spin_lock_irq(q->queue_lock);
>  		q->rpm_status = RPM_ACTIVE;
>  		__blk_run_queue(q);
>  		pm_runtime_mark_last_busy(q->dev);
> +		spin_unlock_irq(q->queue_lock);
>  		pm_runtime_autosuspend(q->dev);
>  	} else {
> +		spin_lock_irq(q->queue_lock);
>  		q->rpm_status = RPM_SUSPENDED;
> +		spin_unlock_irq(q->queue_lock);
>  	}
> -	spin_unlock_irq(q->queue_lock);
>  }
>  EXPORT_SYMBOL(blk_post_runtime_resume);
>  #endif
> 

