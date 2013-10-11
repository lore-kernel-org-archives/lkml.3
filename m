Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab3JKPjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:39:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:55294 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab3JKPjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:39:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1081,1371106800"; 
   d="scan'208";a="391685053"
Date: Fri, 11 Oct 2013 09:39:42 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Matias Bjorling <m@bjorling.me>
cc: willy@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH 1/2] NVMe: Refactor doorbell
In-Reply-To: <1381481333-23888-2-git-send-email-m@bjorling.me>
Message-ID: <alpine.LRH.2.03.1310110823320.4763@AMR>
References: <1381481333-23888-1-git-send-email-m@bjorling.me> <1381481333-23888-2-git-send-email-m@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013, Matias Bjorling wrote:
> The doorbell code is repeated various places. Refactor it into its own function
> for clarity.
>
> Signed-off-by: Matias Bjorling <m@bjorling.me>

Looks good to me.
Reviewed-by: Keith Busch <keith.busch@intel.com>

> ---
> drivers/block/nvme-core.c | 29 +++++++++++++----------------
> 1 file changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
> index da52092..40998d5 100644
> --- a/drivers/block/nvme-core.c
> +++ b/drivers/block/nvme-core.c
> @@ -242,6 +242,13 @@ void put_nvmeq(struct nvme_queue *nvmeq)
> 	put_cpu();
> }
>
> +static inline void nvme_ring_doorbell(struct nvme_queue *nvmeq)
> +{
> +	if (++nvmeq->sq_tail == nvmeq->q_depth)
> +		nvmeq->sq_tail = 0;
> +	writel(nvmeq->sq_tail, nvmeq->q_db);
> +}
> +
> /**
>  * nvme_submit_cmd() - Copy a command into a queue and ring the doorbell
>  * @nvmeq: The queue to use
> @@ -252,14 +259,10 @@ void put_nvmeq(struct nvme_queue *nvmeq)
> static int nvme_submit_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd)
> {
> 	unsigned long flags;
> -	u16 tail;
> +
> 	spin_lock_irqsave(&nvmeq->q_lock, flags);
> -	tail = nvmeq->sq_tail;
> -	memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
> -	if (++tail == nvmeq->q_depth)
> -		tail = 0;
> -	writel(tail, nvmeq->q_db);
> -	nvmeq->sq_tail = tail;
> +	memcpy(&nvmeq->sq_cmds[nvmeq->sq_tail], cmd, sizeof(*cmd));
> +	nvme_ring_doorbell(nvmeq);
> 	spin_unlock_irqrestore(&nvmeq->q_lock, flags);
>
> 	return 0;
> @@ -619,9 +622,7 @@ static int nvme_submit_discard(struct nvme_queue *nvmeq, struct nvme_ns *ns,
> 	cmnd->dsm.nr = 0;
> 	cmnd->dsm.attributes = cpu_to_le32(NVME_DSMGMT_AD);
>
> -	if (++nvmeq->sq_tail == nvmeq->q_depth)
> -		nvmeq->sq_tail = 0;
> -	writel(nvmeq->sq_tail, nvmeq->q_db);
> +	nvme_ring_doorbell(nvmeq);
>
> 	return 0;
> }
> @@ -636,9 +637,7 @@ static int nvme_submit_flush(struct nvme_queue *nvmeq, struct nvme_ns *ns,
> 	cmnd->common.command_id = cmdid;
> 	cmnd->common.nsid = cpu_to_le32(ns->ns_id);
>
> -	if (++nvmeq->sq_tail == nvmeq->q_depth)
> -		nvmeq->sq_tail = 0;
> -	writel(nvmeq->sq_tail, nvmeq->q_db);
> +	nvme_ring_doorbell(nvmeq);
>
> 	return 0;
> }
> @@ -729,9 +728,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
> 	cmnd->rw.dsmgmt = cpu_to_le32(dsmgmt);
>
> 	nvme_start_io_acct(bio);
> -	if (++nvmeq->sq_tail == nvmeq->q_depth)
> -		nvmeq->sq_tail = 0;
> -	writel(nvmeq->sq_tail, nvmeq->q_db);
> +	nvme_ring_doorbell(nvmeq);
>
> 	return 0;
>
> -- 
> 1.8.1.2
>
>
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme@lists.infradead.org
> http://merlin.infradead.org/mailman/listinfo/linux-nvme
>
