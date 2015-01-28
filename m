Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794AbbA1Ukg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:40:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698AbbA1Ukb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:40:31 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind offer
References: <1421768706-5363-1-git-send-email-vkuznets@redhat.com>
	<1421768706-5363-4-git-send-email-vkuznets@redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C61EA94FB7@SIXPRD3002MB028.064d.mgd.msft.net>
Date: Wed, 28 Jan 2015 13:08:54 +0100
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C61EA94FB7@SIXPRD3002MB028.064d.mgd.msft.net>
	(Dexuan Cui's message of "Wed, 28 Jan 2015 11:57:30 +0000")
Message-ID: <8761br9kfd.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

>> -----Original Message-----
>> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
>> Sent: Tuesday, January 20, 2015 23:45 PM
>> To: KY Srinivasan; devel@linuxdriverproject.org
>> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org; Dexuan Cui; Jason Wang;
>> Radim Krčmář; Dan Carpenter
>> Subject: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind offer
>> 
>> Commit 4b2f9abea52a ("staging: hv: convert channel_mgmt.c to not call
>> osd_schedule_callback")' was written under an assumption that we never
>> receive
>> Rescind offer while we're still processing the initial Offer request. However,
>> the issue we fixed in 04a258c162a8 could be caused by this assumption not
>> always being true.
>> 
>> In particular, we need to protect against the following:
>> 1) Receiving a Rescind offer after we do queue_work() for processing an
>> Offer
>>    request and before we actually enter vmbus_process_offer(). work.func
>> points
>>    to vmbus_process_offer() at this moment and in vmbus_onoffer_rescind()
>> we do
>>    another queue_work() without a check so we'll enter
>> vmbus_process_offer()
>>    twice.
>> 2) Receiving a Rescind offer after we enter vmbus_process_offer() and
>>    especially after we set >state = CHANNEL_OPEN_STATE. Many things can go
>>    wrong in that case, e.g. we can call free_channel() while we're still using
>>    it.
>> 
>> Implement the required protection by changing work->func at the very end
>> of
>> vmbus_process_offer() and checking work->func in vmbus_onoffer_rescind().
>> In
>> case we receive rescind offer during or before vmbus_process_offer() is
>> done
>> we set rescind flag to true and we check it at the end of
>> vmbus_process_offer()
>> so such offer will not get lost.
>> 
>> Suggested-by: Radim Krčmář <rkrcmar@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  drivers/hv/channel_mgmt.c | 30 ++++++++++++++++++++++--------
>>  1 file changed, 22 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
>> index c6fdd74..877a944 100644
>> --- a/drivers/hv/channel_mgmt.c
>> +++ b/drivers/hv/channel_mgmt.c
>> @@ -279,9 +279,6 @@ static void vmbus_process_offer(struct work_struct
>> *work)
>>  	int ret;
>>  	unsigned long flags;
>> 
>> -	/* The next possible work is rescind handling */
>> -	INIT_WORK(&newchannel->work, vmbus_process_rescind_offer);
>> -
>>  	/* Make sure this is a new offer */
>>  	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
>> 
>> @@ -341,7 +338,7 @@ static void vmbus_process_offer(struct work_struct
>> *work)
>>  			if (channel->sc_creation_callback != NULL)
>>  				channel->sc_creation_callback(newchannel);
>> 
>> -			goto out;
>> +			goto done_init_rescind;
>>  		}
>> 
>>  		goto err_free_chan;
>> @@ -382,7 +379,14 @@ static void vmbus_process_offer(struct work_struct
>> *work)
>>  		kfree(newchannel->device_obj);
>>  		goto err_free_chan;
>>  	}
>> -out:
>> +done_init_rescind:
>> +	spin_lock_irqsave(&newchannel->lock, flags);
>> +	/* The next possible work is rescind handling */
>> +	INIT_WORK(&newchannel->work, vmbus_process_rescind_offer);
>> +	/* Check if rescind offer was already received */
>> +	if (newchannel->rescind)
>> +		queue_work(newchannel->controlwq, &newchannel->work);
>> +	spin_unlock_irqrestore(&newchannel->lock, flags);
>>  	return;
>>  err_free_chan:
>>  	free_channel(newchannel);
>> @@ -520,6 +524,7 @@ static void vmbus_onoffer_rescind(struct
>> vmbus_channel_message_header *hdr)
>>  {
>>  	struct vmbus_channel_rescind_offer *rescind;
>>  	struct vmbus_channel *channel;
>> +	unsigned long flags;
>> 
>>  	rescind = (struct vmbus_channel_rescind_offer *)hdr;
>>  	channel = relid2channel(rescind->child_relid);
>> @@ -528,11 +533,20 @@ static void vmbus_onoffer_rescind(struct
>> vmbus_channel_message_header *hdr)
>>  		/* Just return here, no channel found */
>>  		return;
>> 
>> +	spin_lock_irqsave(&channel->lock, flags);
>>  	channel->rescind = true;
>> +	/*
>> +	 * channel->work.func != vmbus_process_rescind_offer means we
>> are still
>> +	 * processing offer request and the rescind offer processing should
>> be
>> +	 * postponed. It will be done at the very end of
>> vmbus_process_offer()
>> +	 * as rescind flag is being checked there.
>> +	 */
>> +	if (channel->work.func == vmbus_process_rescind_offer)
>> +		/* work is initialized for vmbus_process_rescind_offer() from
>> +		 * vmbus_process_offer() where the channel got created */
>> +		queue_work(channel->controlwq, &channel->work);
>> 
>> -	/* work is initialized for vmbus_process_rescind_offer() from
>> -	 * vmbus_process_offer() where the channel got created */
>> -	queue_work(channel->controlwq, &channel->work);
>> +	spin_unlock_irqrestore(&channel->lock, flags);
>>  }
>> 
>>  /*
>> --
>
> Hi Vitaly and all,
> I have 2 questions:
> In vmbus_process_offer(),  in the cases of "goto err_free_chan",
> should we consider the possibility a rescind message could be pending for 
> the new channel?
> In the cases,  because we don't run 
> "INIT_WORK(&newchannel->work, vmbus_process_rescind_offer); ",
> vmbus_onoffer_rescind() will do nothing and as a result, 
> vmbus_process_rescind_offer() won't be invoked.

Yes, but processing the rescind offer results in freeing the channel
(and this processing supposes the channel wasn't freed before) so
there is no difference... or is it?

>
> Question 2: in vmbus_process_offer(), in the case
> vmbus_device_register() fails, we'll run
> "list_del(&newchannel->listentry);" -- just after this line,
>  what will happen at this time if relid2channel() returns NULL
> in vmbus_onoffer_rescind()?
>
> I think we'll lose the rescind message. 
>

Yes, but same logic applies - we already freed the channes so no rescind
proccessing required. If we still need to do something we need to
add support for already freed channel to the rescind offer processing path.

> Thanks,
> -- Dexuan

-- 
  Vitaly
