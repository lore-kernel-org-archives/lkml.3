Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbbALPPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:15:30 -0500
Received: from smtp.citrix.com ([66.165.176.89]:7360 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbbALPP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:15:29 -0500
X-IronPort-AV: E=Sophos;i="5.07,744,1413244800"; 
   d="scan'208";a="214792344"
Message-ID: <54B3E4D8.30708@citrix.com>
Date: Mon, 12 Jan 2015 16:14:32 +0100
From: =?windows-1252?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, Bob Liu <bob.liu@oracle.com>
CC: <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <junxiao.bi@oracle.com>
Subject: Re: [PATCH] xen/blkfront: restart request queue when there is enough
 persistent_gnts_c
References: <1420550343-14013-1-git-send-email-bob.liu@oracle.com> <54AFF909.3090909@citrix.com> <54B37336.40109@oracle.com> <54B3B1B7.40700@citrix.com> <54B3C673.3040609@citrix.com>
In-Reply-To: <54B3C673.3040609@citrix.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 12/01/15 a les 14.04, David Vrabel ha escrit:
> On 12/01/15 11:36, Roger Pau Monné wrote:
>> El 12/01/15 a les 8.09, Bob Liu ha escrit:
>>>
>>> On 01/09/2015 11:51 PM, Roger Pau Monné wrote:
>>>> El 06/01/15 a les 14.19, Bob Liu ha escrit:
>>>>> When there is no enough free grants, gnttab_alloc_grant_references()
>>>>> will fail and block request queue will stop.
>>>>> If the system is always lack of grants, blkif_restart_queue_callback() can't be
>>>>> scheduled and block request queue can't be restart(block I/O hang).
>>>>>
>>>>> But when there are former requests complete, some grants may free to
>>>>> persistent_gnts_c, we can give the request queue another chance to restart and
>>>>> avoid block hang.
>>>>>
>>>>> Reported-by: Junxiao Bi <junxiao.bi@oracle.com>
>>>>> Signed-off-by: Bob Liu <bob.liu@oracle.com>
>>>>> ---
>>>>>  drivers/block/xen-blkfront.c |   11 +++++++++++
>>>>>  1 file changed, 11 insertions(+)
>>>>>
>>>>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>>>>> index 2236c6f..dd30f99 100644
>>>>> --- a/drivers/block/xen-blkfront.c
>>>>> +++ b/drivers/block/xen-blkfront.c
>>>>> @@ -1125,6 +1125,17 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
>>>>>  			}
>>>>>  		}
>>>>>  	}
>>>>> +
>>>>> +	/*
>>>>> +	 * Request queue would be stopped if failed to alloc enough grants and
>>>>> +	 * won't be restarted until gnttab_free_count >= info->callback->count.
>>>>> +	 *
>>>>> +	 * But there is another case, once we have enough persistent grants we
>>>>> +	 * can try to restart the request queue instead of continue to wait for
>>>>> +	 * 'gnttab_free_count'.
>>>>> +	 */
>>>>> +	if (info->persistent_gnts_c >= info->callback.count)
>>>>> +		schedule_work(&info->work);
>>>>
>>>> I guess I'm missing something here, but blkif_completion is called by
>>>> blkif_interrupt, which in turn calls kick_pending_request_queues when
>>>> finished, which IMHO should be enough to restart the processing of requests.
>>>>
>>>
>>> You are right, sorry for the mistake.
>>>
>>> The problem we met was a xenblock I/O hang.
>>> Dumped data showed at that time info->persistent_gnt_c = 8, max_gref = 8
>>> but block request queue was still stopped.
>>> It's very hard to reproduce this issue, we only see it once.
>>>
>>> I think there might be a race condition:
>>>
>>> request A                          request B:
>>>
>>>                                    info->persistent_gnts_c < max_grefs
>>>                                    and fail to alloc enough grants
>>>
>>>
>>> ^^^^
>>> interrupt happen, blkif_complte():
>>> info->persistent_gnts_c++
>>> kick_pending_request_queues()

blkif_interrupt can never interrupt blkif_queue_request, because it's
holding a spinlock (info->io_lock). If you have seen this trace in the
wild it means something is really wrong and we are calling
blkif_queue_request without acquiring the spinlock and thus without
disabling interrupts.

>>>
>>>                                     stop block request queue
>>>                                     added to callback list
>>>
>>> If the system don't have enough grants(but have enough persistent_gnts),
>>> request queue would still hang.
>>
>> Not sure how can this happen, blkif_queue_request explicitly checks that
>> persistent_gnts_c < max_grefs before adding the callback and stopping
>> the request queue, so in your case the queue should not be blocked. Can
>> you dump the state of info->connected?
> 
> I think Bob has correctly identified a race.
> 
> After calling blk_stop_queue(), check info->persistent_gnts again and
> restart the queue if there free grefs.
> 
> David
> 
> 

