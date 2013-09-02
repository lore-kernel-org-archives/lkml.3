Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab3IBGaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 02:30:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918Ab3IBGaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:30:22 -0400
Message-ID: <52243071.5090303@redhat.com>
Date: Mon, 02 Sep 2013 14:30:09 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 6/6] vhost_net: correctly limit the max pending buffers
References: <1377836962-49780-1-git-send-email-jasowang@redhat.com> <1377836962-49780-7-git-send-email-jasowang@redhat.com> <20130902055609.GC19838@redhat.com>
In-Reply-To: <20130902055609.GC19838@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 01:56 PM, Michael S. Tsirkin wrote:
> On Fri, Aug 30, 2013 at 12:29:22PM +0800, Jason Wang wrote:
>> As Michael point out, We used to limit the max pending DMAs to get better cache
>> utilization. But it was not done correctly since it was one done when there's no
>> new buffers submitted from guest. Guest can easily exceeds the limitation by
>> keeping sending packets.
>>
>> So this patch moves the check into main loop. Tests shows about 5%-10%
>> improvement on per cpu throughput for guest tx. But a 5% drop on per cpu
>> transaction rate for a single session TCP_RR.
> Any explanation for the drop? single session TCP_RR is unlikely to
> exceed VHOST_MAX_PEND, correct?

Unlikely to exceed. Recheck the result, looks like it was not stable
enough. Will re-test and report.
>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>  drivers/vhost/net.c |   15 ++++-----------
>>  1 files changed, 4 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index d09c17c..592e1f2 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -363,6 +363,10 @@ static void handle_tx(struct vhost_net *net)
>>  		if (zcopy)
>>  			vhost_zerocopy_signal_used(net, vq);
>>  
>> +		if ((nvq->upend_idx + vq->num - VHOST_MAX_PEND) % UIO_MAXIOV ==
>> +		    nvq->done_idx)
>> +			break;
>> +
>>  		head = vhost_get_vq_desc(&net->dev, vq, vq->iov,
>>  					 ARRAY_SIZE(vq->iov),
>>  					 &out, &in,
>> @@ -372,17 +376,6 @@ static void handle_tx(struct vhost_net *net)
>>  			break;
>>  		/* Nothing new?  Wait for eventfd to tell us they refilled. */
>>  		if (head == vq->num) {
>> -			int num_pends;
>> -
>> -			/* If more outstanding DMAs, queue the work.
>> -			 * Handle upend_idx wrap around
>> -			 */
>> -			num_pends = likely(nvq->upend_idx >= nvq->done_idx) ?
>> -				    (nvq->upend_idx - nvq->done_idx) :
>> -				    (nvq->upend_idx + UIO_MAXIOV -
>> -				     nvq->done_idx);
>> -			if (unlikely(num_pends > VHOST_MAX_PEND))
>> -				break;
>>  			if (unlikely(vhost_enable_notify(&net->dev, vq))) {
>>  				vhost_disable_notify(&net->dev, vq);
>>  				continue;
>> -- 
>> 1.7.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

