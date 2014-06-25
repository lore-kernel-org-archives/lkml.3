Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaFYBjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:39:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30160 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbaFYBjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:39:21 -0400
Message-ID: <53AA280D.2030103@fb.com>
Date: Tue, 24 Jun 2014 19:38:21 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>,
        <willy@linux.intel.com>, <keith.busch@intel.com>,
        <sbradshaw@micron.com>, <linux-kernel@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <hch@infradead.org>,
        <rlnelson@google.com>, <tom.leiming@gmail.com>
Subject: Re: [PATCH v9] NVMe: Convert to blk-mq
References: <1403651531-24891-1-git-send-email-m@bjorling.me> <1403651531-24891-2-git-send-email-m@bjorling.me>
In-Reply-To: <1403651531-24891-2-git-send-email-m@bjorling.me>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-25_01:2014-06-24,2014-06-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406250013
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-24 17:12, Matias Bjørling wrote:
> +static int nvme_admin_init_request(void *data, struct request *req,
> +				unsigned int hctx_idx, unsigned int rq_idx,
> +				unsigned int numa_node)
>   {
> -	return DIV_ROUND_UP(depth, 8) + (depth * sizeof(struct nvme_cmd_info));
> +	struct nvme_dev *dev = data;
> +	struct nvme_cmd_info *cmd = blk_mq_rq_to_pdu(req);
> +	struct nvme_queue *nvmeq = dev->queues[0];
> +
> +	WARN_ON(!nvmeq);
> +	WARN_ON(!cmd);
> +	cmd->nvmeq = nvmeq;
> +	return 0;

Get rid of the WARN_ON(!cmd) - if that should trigger, we'll see the 
obvious oops right after.

> +static int nvme_init_request(void *data, struct request *req,
> +				unsigned int hctx_idx, unsigned int rq_idx,
> +				unsigned int numa_node)
> +{
> +	struct nvme_dev *dev = data;
> +	struct nvme_cmd_info *cmd = blk_mq_rq_to_pdu(req);
> +	struct nvme_queue *nvmeq = dev->queues[hctx_idx + 1];
> +
> +	WARN_ON(!nvmeq);
> +	WARN_ON(!cmd);
> +	cmd->nvmeq = nvmeq;
> +	return 0;

Ditto

> +/* Admin queue isn't initialized as a request queue. If at some point this
> + * happens anyway, make sure to notify the user */
> +static int nvme_admin_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
>   {
> -	struct nvme_ns *ns = q->queuedata;
> -	struct nvme_queue *nvmeq = get_nvmeq(ns->dev);
> -	int result = -EBUSY;
> -
> -	if (!nvmeq) {
> -		bio_endio(bio, -EIO);
> -		return;
> -	}
> -
> -	spin_lock_irq(&nvmeq->q_lock);
> -	if (!nvmeq->q_suspended && bio_list_empty(&nvmeq->sq_cong))
> -		result = nvme_submit_bio_queue(nvmeq, ns, bio);
> -	if (unlikely(result)) {
> -		if (!waitqueue_active(&nvmeq->sq_full))
> -			add_wait_queue(&nvmeq->sq_full, &nvmeq->sq_cong_wait);
> -		bio_list_add(&nvmeq->sq_cong, bio);
> -	}
> -
> -	nvme_process_cq(nvmeq);
> -	spin_unlock_irq(&nvmeq->q_lock);
> -	put_nvmeq(nvmeq);
> +	WARN_ON(1);
> +	return BLK_MQ_RQ_QUEUE_ERROR;

That should be a WARN_ON_ONCE(1). In case it does trigger, you don't 
want to see it tons of times, once is enough.

-- 
Jens Axboe

