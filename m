Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab3IBDHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 23:07:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab3IBDHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 23:07:04 -0400
Message-ID: <522400CE.3020102@redhat.com>
Date: Mon, 02 Sep 2013 11:06:54 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 5/6] vhost_net: poll vhost queue after marking DMA
 is done
References: <1377836962-49780-1-git-send-email-jasowang@redhat.com>  <1377836962-49780-6-git-send-email-jasowang@redhat.com> <1377881073.2065.10.camel@bwh-desktop.uk.level5networks.com>
In-Reply-To: <1377881073.2065.10.camel@bwh-desktop.uk.level5networks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2013 12:44 AM, Ben Hutchings wrote:
> On Fri, 2013-08-30 at 12:29 +0800, Jason Wang wrote:
>> We used to poll vhost queue before making DMA is done, this is racy if vhost
>> thread were waked up before marking DMA is done which can result the signal to
>> be missed. Fix this by always poll the vhost thread before DMA is done.
> Does this bug only exist in net-next or is it older?  Should the fix go
> to net and stable branches?

This should go for the stable branches too (3.4 above).

Thanks for the checking.
>
> Ben.
>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>  drivers/vhost/net.c |    9 +++++----
>>  1 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index ff60c2a..d09c17c 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -308,6 +308,11 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>>  	struct vhost_virtqueue *vq = ubufs->vq;
>>  	int cnt = atomic_read(&ubufs->kref.refcount);
>>  
>> +	/* set len to mark this desc buffers done DMA */
>> +	vq->heads[ubuf->desc].len = success ?
>> +		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
>> +	vhost_net_ubuf_put(ubufs);
>> +
>>  	/*
>>  	 * Trigger polling thread if guest stopped submitting new buffers:
>>  	 * in this case, the refcount after decrement will eventually reach 1
>> @@ -318,10 +323,6 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>>  	 */
>>  	if (cnt <= 2 || !(cnt % 16))
>>  		vhost_poll_queue(&vq->poll);
>> -	/* set len to mark this desc buffers done DMA */
>> -	vq->heads[ubuf->desc].len = success ?
>> -		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
>> -	vhost_net_ubuf_put(ubufs);
>>  }
>>  
>>  /* Expects to be always run from workqueue - which acts as

