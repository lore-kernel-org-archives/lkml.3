Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaJOKNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:13:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbaJOKNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:13:32 -0400
Message-ID: <543E48BF.4080502@redhat.com>
Date: Wed, 15 Oct 2014 18:13:19 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, eric.dumazet@gmail.com
Subject: Re: [RFC PATCH net-next 1/6] virtio: make sure used event never go
 backwards
References: <1413357930-45302-1-git-send-email-jasowang@redhat.com> <1413357930-45302-2-git-send-email-jasowang@redhat.com> <20141015093432.GB25776@redhat.com>
In-Reply-To: <20141015093432.GB25776@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 05:34 PM, Michael S. Tsirkin wrote:
> On Wed, Oct 15, 2014 at 03:25:25PM +0800, Jason Wang wrote:
>> This patch checks the new event idx to make sure used event idx never
>> goes back. This is used to synchronize the calls between
>> virtqueue_enable_cb_delayed() and virtqueue_enable_cb().
>>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> the implication being that moving event idx back might cause some race
> condition?  

This will cause race condition when tx interrupt is enabled. Consider
the following cases

1) tx napi was scheduled
2) start_xmit() call virtqueue_enable_cb_delayed() and disable cb, [used
event is vq->last_used_idx + 3/4 pendg bufs]
3) tx napi enable the callback by virtqueue_enable_cb() [ used event is
vq->last_used_idx ]
 
After step 3, used event was moved back, unnecessary tx interrupt was
triggered.
> If yes but please describe the race explicitly.
> Is there a bug we need to fix on stable?

Looks not, current code does not have such race condition.
> Please also explicitly describe a configuration that causes event idx
> to go back.
>
> All this info should go in the commit log.

Will do this.
>> ---
>>  drivers/virtio/virtio_ring.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>> index 3b1f89b..1b3929f 100644
>> --- a/drivers/virtio/virtio_ring.c
>> +++ b/drivers/virtio/virtio_ring.c
>> @@ -559,14 +559,17 @@ unsigned virtqueue_enable_cb_prepare(struct virtqueue *_vq)
>>  	u16 last_used_idx;
>>  
>>  	START_USE(vq);
>> -
>> +	last_used_idx = vq->last_used_idx;
>>  	/* We optimistically turn back on interrupts, then check if there was
>>  	 * more to do. */
>>  	/* Depending on the VIRTIO_RING_F_EVENT_IDX feature, we need to
>>  	 * either clear the flags bit or point the event index at the next
>>  	 * entry. Always do both to keep code simple. */
>>  	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
>> -	vring_used_event(&vq->vring) = last_used_idx = vq->last_used_idx;
>> +	/* Make sure used event never go backwards */
> s/go/goes/
>
>> +	if (!vring_need_event(vring_used_event(&vq->vring),
>> +			      vq->vring.avail->idx, last_used_idx))
>> +		vring_used_event(&vq->vring) = last_used_idx;
> The result will be that driver will *not* get an interrupt
> on the next consumed buffer, which is likely not what driver
> intended when it called virtqueue_enable_cb.

This will only happen when we want to delay the interrupt for next few
consumed buffers (virtqueue_enable_cb_delayed() was called). For the
other case, vq->last_used_idx should be ahead of previous used event. Do
you see any other case?
>
> Instead, how about we simply document the requirement that drivers either
> always call virtqueue_enable_cb_delayed or virtqueue_enable_cb
> but not both?

We need call them both when tx interrupt is enabled I believe.
>
>>  	END_USE(vq);
>>  	return last_used_idx;
>>  }
>> -- 
>> 1.7.1

