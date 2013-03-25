Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab3CYH0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 03:26:06 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:39919 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab3CYH0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 03:26:04 -0400
Message-ID: <514FFC06.9030703@acm.org>
Date: Mon, 25 Mar 2013 08:25:58 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        rusty@rustcorp.com.au, mst@redhat.com, asias@redhat.com,
        JBottomley@parallels.com, venkateshs@google.com, pbonzini@redhat.com
Subject: Re: [PATCH V7 4/5] virtio-scsi: introduce multiqueue support
References: <1364038124-32479-1-git-send-email-gaowanlong@cn.fujitsu.com> <1364038124-32479-5-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1364038124-32479-5-git-send-email-gaowanlong@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/13 12:28, Wanlong Gao wrote:
> +static struct virtio_scsi_vq *virtscsi_pick_vq(struct virtio_scsi *vscsi,
> +					       struct virtio_scsi_target_state *tgt)
> +{
> +	struct virtio_scsi_vq *vq;
> +	unsigned long flags;
> +	u32 queue_num;
> +
> +	spin_lock_irqsave(&tgt->tgt_lock, flags);
> +
> +	/*
> +	 * The memory barrier after atomic_inc_return matches
> +	 * the smp_read_barrier_depends() in virtscsi_req_done.
> +	 */
> +	if (atomic_inc_return(&tgt->reqs) > 1)
> +		vq = ACCESS_ONCE(tgt->req_vq);
> +	else {
> +		queue_num = smp_processor_id();
> +		while (unlikely(queue_num >= vscsi->num_queues))
> +			queue_num -= vscsi->num_queues;
> +
> +		tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
> +	}
> +
> +	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
> +	return vq;
> +}

Is there any reason why the smp_processor_id() % vscsi->num_queues 
computation in virtscsi_pick_vq() has been implemented as a loop instead 
of as an arithmetic operation ? If so, I would appreciate it if that 
could be explained in a comment.

Thanks,

Bart.
