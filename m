Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbbA0DaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:30:11 -0500
Received: from plane.gmane.org ([80.91.229.3]:53175 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbbA0DaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:30:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ban <baneric926@gmail.com>
Subject: Re: [PATCH] mmc: core: fix race condition in =?utf-8?b?bW1jX3dhaXRfZGF0YV9kb25l?=
Date: Tue, 27 Jan 2015 03:25:19 +0000 (UTC)
Message-ID: <loom.20150127T041123-863@post.gmane.org>
References: <1421131366-29685-1-git-send-email-jlfu@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 118.163.83.72 (Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.91 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jialing Fu <jlfu <at> marvell.com> writes:

> 
> The following panic is captured in ker3.14, but the issue still exists
> in latest kernel.
> ---------------------------------------------------------------------
> [   20.738217] c0 3136 (Compiler) Unable to handle kernel NULL pointer 
dereference
> at virtual address 00000578
> ......
> [   20.738499] c0 3136 (Compiler) PC is at 
_raw_spin_lock_irqsave+0x24/0x60
> [   20.738527] c0 3136 (Compiler) LR is at 
_raw_spin_lock_irqsave+0x20/0x60
> [   20.740134] c0 3136 (Compiler) Call trace:
> [   20.740165] c0 3136 (Compiler) [<ffffffc0008ee900>] 
_raw_spin_lock_irqsave+0x24/0x60
> [   20.740200] c0 3136 (Compiler) [<ffffffc0000dd024>] __wake_up+0x1c/0x54
> [   20.740230] c0 3136 (Compiler) [<ffffffc000639414>] 
mmc_wait_data_done+0x28/0x34
> [   20.740262] c0 3136 (Compiler) [<ffffffc0006391a0>] 
mmc_request_done+0xa4/0x220
> [   20.740314] c0 3136 (Compiler) [<ffffffc000656894>] 
sdhci_tasklet_finish+0xac/0x264
> [   20.740352] c0 3136 (Compiler) [<ffffffc0000a2b58>] 
tasklet_action+0xa0/0x158
> [   20.740382] c0 3136 (Compiler) [<ffffffc0000a2078>] 
__do_softirq+0x10c/0x2e4
> [   20.740411] c0 3136 (Compiler) [<ffffffc0000a24bc>] irq_exit+0x8c/0xc0
> [   20.740439] c0 3136 (Compiler) [<ffffffc00008489c>] 
handle_IRQ+0x48/0xac
> [   20.740469] c0 3136 (Compiler) [<ffffffc000081428>] 
gic_handle_irq+0x38/0x7c
> ----------------------------------------------------------------------
> 
> Because in SMP, "mrq" has race condition between below two paths:
> path1: CPU0: <tasklet context>
>   static void mmc_wait_data_done(struct mmc_request *mrq)
>   {
>     mrq->host->context_info.is_done_rcv = true;
>     //
>     // If CPU0 has just finished "is_done_rcv = true" in path1, and at
>     // this moment, IRQ or ICache line missing happens in CPU0.
>     // What happens in CPU1 (path2)?
>     //
>     // If the mmcqd thread in CPU1(path2) hasn't entered to sleep mode:
>     // path2 would have chance to break from wait_event_interruptible
>     // in mmc_wait_for_data_req_done and continue to run for next
>     // mmc_request (mmc_blk_rw_rq_prep).
>     //
>     // Within mmc_blk_rq_prep, mrq is cleared to 0.
>     // If below line still gets host from "mrq" as the result of
>     // compiler, the panic happens as we traced.
>     wake_up_interruptible(&mrq->host->context_info.wait);
>   }
> 
> path2: CPU1: <The mmcqd thread runs mmc_queue_thread>
>  static int mmc_wait_for_data_req_done(...
>  {
>     ...
>     while (1) {
>           wait_event_interruptible(context_info->wait,
>                   (context_info->is_done_rcv ||
>                    context_info->is_new_req));
> 
>   static void mmc_blk_rw_rq_prep(...
>   {
>     ...
>     memset(brq, 0, sizeof(struct mmc_blk_request));
> 
> This issue happens very coincidentally; however adding mdelay(1) in
> mmc_wait_data_done as below could duplicate it easily.
>   static void mmc_wait_data_done(struct mmc_request *mrq)
>   {
>     mrq->host->context_info.is_done_rcv = true;
>     mdelay(1);
>     wake_up_interruptible(&mrq->host->context_info.wait);
>   }
> At runtime, IRQ or ICache line missing may just happen at the same place
> of the mdelay(1).
> 
> This patch gets the mmc_context_info at the beginning of function, it can
> avoid this race condition.
> 
> Signed-off-by: Jialing Fu <jlfu <at> marvell.com>
> ---
>  drivers/mmc/core/core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 9584bff..f08c9a8 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
>  <at>  <at>  -326,8 +326,10  <at>  <at>  EXPORT_SYMBOL(mmc_start_bkops);
>   */
>  static void mmc_wait_data_done(struct mmc_request *mrq)
>  {
> -	mrq->host->context_info.is_done_rcv = true;
> -	wake_up_interruptible(&mrq->host->context_info.wait);
> +	struct mmc_context_info *context_info = &mrq->host->context_info;
> +
> +	context_info->is_done_rcv = true;
> +	wake_up_interruptible(&context_info->wait);
>  }
> 
>  static void mmc_wait_done(struct mmc_request *mrq)

Hi Jialing, 
I met the same issue at kernel v3.10, and after adding mdelay(1) to 
mmc_wait_data_done() function, it could duplicate at every boot-up stage.
[   15.157899]  [<ffffffff828e504a>] _raw_spin_lock_irqsave+0x2a/0x40
[   15.157925]  [<ffffffff820dfd23>] __wake_up+0x23/0x50
[   15.157951]  [<ffffffff8262c4ce>] mmc_wait_data_done+0x3e/0x50
[   15.157975]  [<ffffffff8262c5a6>] mmc_request_done+0xa6/0x250
[   15.157999]  [<ffffffff828e4f48>] ? _raw_spin_unlock_irqrestore+0x28/0x60
[   15.158027]  [<ffffffff82645fdb>] sdhci_tasklet_finish+0xeb/0x190
[   15.158054]  [<ffffffff820b7d8c>] tasklet_action+0x6c/0xe0
[   15.158077]  [<ffffffff820b7850>] __do_softirq+0x110/0x2d0
[   15.158103]  [<ffffffff828ec60c>] call_softirq+0x1c/0x30
[   15.158127]  [<ffffffff820041ed>] do_softirq+0x6d/0xa0
[   15.158150]  [<ffffffff820b7ba5>] irq_exit+0xb5/0xc0
[   15.158172]  [<ffffffff828eccc6>] do_IRQ+0x56/0xc0
[   15.158195]  [<ffffffff828e53ef>] common_interrupt+0x6f/0x6f

I have no idea whether this patch is work or not because of rarely hit ratio 
even without your solution. However, I'll keep monitor this subject if it is 
healthy to be merged.

Thanks

