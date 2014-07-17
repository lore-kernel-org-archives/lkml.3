Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaGQCzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 22:55:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaGQCzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 22:55:46 -0400
Message-ID: <53C73B29.4070107@redhat.com>
Date: Thu, 17 Jul 2014 10:55:37 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>, rusty@rustcorp.com.au,
        mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Vlad Yasevich <vyasevic@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next V2 3/3] virtio-net: rx busy polling support
References: <1405491707-22706-1-git-send-email-jasowang@redhat.com> <1405491707-22706-4-git-send-email-jasowang@redhat.com> <53C63A11.4050401@gmail.com>
In-Reply-To: <53C63A11.4050401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 04:38 PM, Varka Bhadram wrote:
> On 07/16/2014 11:51 AM, Jason Wang wrote:
>> Add basic support for rx busy polling.
>>
>> Test was done between a kvm guest and an external host. Two hosts were
>> connected through 40gb mlx4 cards. With both busy_poll and busy_read
>> are set to 50 in guest, 1 byte netperf tcp_rr shows 116% improvement:
>> transaction rate was increased from 9151.94 to 19787.37.
>>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Cc: Vlad Yasevich <vyasevic@redhat.com>
>> Cc: Eric Dumazet <eric.dumazet@gmail.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/net/virtio_net.c | 190
>> ++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 187 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index e417d93..4830713 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -27,6 +27,7 @@
>>   #include <linux/slab.h>
>>   #include <linux/cpu.h>
>>   #include <linux/average.h>
>> +#include <net/busy_poll.h>
>>     static int napi_weight = NAPI_POLL_WEIGHT;
>>   module_param(napi_weight, int, 0444);
>> @@ -94,8 +95,143 @@ struct receive_queue {
>>         /* Name of this receive queue: input.$index */
>>       char name[40];
>> +
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +    unsigned int state;
>> +#define VIRTNET_RQ_STATE_IDLE        0
>> +#define VIRTNET_RQ_STATE_NAPI         1    /* NAPI or refill owns
>> this RQ */
>> +#define VIRTNET_RQ_STATE_POLL         2    /* poll owns this RQ */
>> +#define VIRTNET_RQ_STATE_DISABLED    4    /* RQ is disabled */
>> +#define VIRTNET_RQ_OWNED (VIRTNET_RQ_STATE_NAPI |
>> VIRTNET_RQ_STATE_POLL)
>> +#define VIRTNET_RQ_LOCKED (VIRTNET_RQ_OWNED |
>> VIRTNET_RQ_STATE_DISABLED)
>> +#define VIRTNET_RQ_STATE_NAPI_YIELD  8    /* NAPI or refill yielded
>> this RQ */
>> +#define VIRTNET_RQ_STATE_POLL_YIELD  16   /* poll yielded this RQ */
>> +    spinlock_t lock;
>> +#endif  /* CONFIG_NET_RX_BUSY_POLL */
>>   };
>>   +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +static inline void virtnet_rq_init_lock(struct receive_queue *rq)
>> +{
>> +
>> +    spin_lock_init(&rq->lock);
>> +    rq->state = VIRTNET_RQ_STATE_IDLE;
>> +}
>> +
>> +/* called from the device poll routine or refill routine to get
>> ownership of a
>> + * receive queue.
>> + */
>> +static inline bool virtnet_rq_lock_napi_refill(struct receive_queue
>> *rq)
>> +{
>> +    int rc = true;
>> +
>
> bool instead of int...?

Yes, it was better.
>
>> +    spin_lock(&rq->lock);
>> +    if (rq->state & VIRTNET_RQ_LOCKED) {
>> +        WARN_ON(rq->state & VIRTNET_RQ_STATE_NAPI);
>> +        rq->state |= VIRTNET_RQ_STATE_NAPI_YIELD;
>> +        rc = false;
>> +    } else
>> +        /* we don't care if someone yielded */
>> +        rq->state = VIRTNET_RQ_STATE_NAPI;
>> +    spin_unlock(&rq->lock);
>
> Lock for rq->state ...?
>
> If yes:
> spin_lock(&rq->lock);
> if (rq->state & VIRTNET_RQ_LOCKED) {
>     rq->state |= VIRTNET_RQ_STATE_NAPI_YIELD;
>     spin_unlock(&rq->lock);
>     WARN_ON(rq->state & VIRTNET_RQ_STATE_NAPI);
>     rc = false;
> } else {
>     /* we don't care if someone yielded */
>     rq->state = VIRTNET_RQ_STATE_NAPI;
>     spin_unlock(&rq->lock);
> } 

I didn't see any differences. Is this used to catch the bug of driver
earlier? btw, several other rx busy polling capable driver does the same
thing.
