Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3GAWRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:17:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab3GAWRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:17:13 -0400
Date: Mon, 1 Jul 2013 15:17:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Jens Axboe <axboe@kernel.dk>,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        stable@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix possible sleep in invalid context
Message-Id: <20130701151712.f453745bc0c587f449cc3214@linux-foundation.org>
In-Reply-To: <1372692515-31969-1-git-send-email-sthumma@codeaurora.org>
References: <1372692515-31969-1-git-send-email-sthumma@codeaurora.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Jul 2013 20:58:35 +0530 Sujit Reddy Thumma <sthumma@codeaurora.org> wrote:

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
> 
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

I suppose we can do this cleanly enough:

--- a/block/blk-core.c~block-fix-possible-sleep-in-invalid-context-fix
+++ a/block/blk-core.c
@@ -3159,15 +3159,14 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
  */
 void blk_post_runtime_resume(struct request_queue *q, int err)
 {
+	spin_lock_irq(q->queue_lock);
 	if (!err) {
-		spin_lock_irq(q->queue_lock);
 		q->rpm_status = RPM_ACTIVE;
 		__blk_run_queue(q);
 		pm_runtime_mark_last_busy(q->dev);
 		spin_unlock_irq(q->queue_lock);
 		pm_request_autosuspend(q->dev);
 	} else {
-		spin_lock_irq(q->queue_lock);
 		q->rpm_status = RPM_SUSPENDED;
 		spin_unlock_irq(q->queue_lock);
 	}
_


I wonder if we actually need locking around that second write to
q->rpm_status.

