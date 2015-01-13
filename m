Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbbAMJvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:51:22 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23043 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbbAMJvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:51:18 -0500
Message-ID: <54B4EA7F.1060601@oracle.com>
Date: Tue, 13 Jan 2015 17:50:55 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: =?windows-1252?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
CC: xen-devel@lists.xen.org, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        junxiao.bi@oracle.com
Subject: Re: [PATCH] xen/blkfront: restart request queue when there is enough
 persistent_gnts_c
References: <1420550343-14013-1-git-send-email-bob.liu@oracle.com> <54AFF909.3090909@citrix.com> <54B37336.40109@oracle.com> <54B3B1B7.40700@citrix.com>
In-Reply-To: <54B3B1B7.40700@citrix.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/12/2015 07:36 PM, Roger Pau Monné wrote:
> El 12/01/15 a les 8.09, Bob Liu ha escrit:
>>
>> On 01/09/2015 11:51 PM, Roger Pau Monné wrote:
>>> El 06/01/15 a les 14.19, Bob Liu ha escrit:
>>>> When there is no enough free grants, gnttab_alloc_grant_references()
>>>> will fail and block request queue will stop.
>>>> If the system is always lack of grants, blkif_restart_queue_callback() can't be
>>>> scheduled and block request queue can't be restart(block I/O hang).
>>>>
>>>> But when there are former requests complete, some grants may free to
>>>> persistent_gnts_c, we can give the request queue another chance to restart and
>>>> avoid block hang.
>>>>
>>>> Reported-by: Junxiao Bi <junxiao.bi@oracle.com>
>>>> Signed-off-by: Bob Liu <bob.liu@oracle.com>
>>>> ---
>>>>  drivers/block/xen-blkfront.c |   11 +++++++++++
>>>>  1 file changed, 11 insertions(+)
>>>>
>>>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>>>> index 2236c6f..dd30f99 100644
>>>> --- a/drivers/block/xen-blkfront.c
>>>> +++ b/drivers/block/xen-blkfront.c
>>>> @@ -1125,6 +1125,17 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
>>>>  			}
>>>>  		}
>>>>  	}
>>>> +
>>>> +	/*
>>>> +	 * Request queue would be stopped if failed to alloc enough grants and
>>>> +	 * won't be restarted until gnttab_free_count >= info->callback->count.
>>>> +	 *
>>>> +	 * But there is another case, once we have enough persistent grants we
>>>> +	 * can try to restart the request queue instead of continue to wait for
>>>> +	 * 'gnttab_free_count'.
>>>> +	 */
>>>> +	if (info->persistent_gnts_c >= info->callback.count)
>>>> +		schedule_work(&info->work);
>>>
>>> I guess I'm missing something here, but blkif_completion is called by
>>> blkif_interrupt, which in turn calls kick_pending_request_queues when
>>> finished, which IMHO should be enough to restart the processing of requests.
>>>
>>
>> You are right, sorry for the mistake.
>>
>> The problem we met was a xenblock I/O hang.
>> Dumped data showed at that time info->persistent_gnt_c = 8, max_gref = 8
>> but block request queue was still stopped.
>> It's very hard to reproduce this issue, we only see it once.
>>
>> I think there might be a race condition:
>>
>> request A                          request B:
>>
>>                                    info->persistent_gnts_c < max_grefs
>>                                    and fail to alloc enough grants
>>
>>
>> ^^^^
>> interrupt happen, blkif_complte():
>> info->persistent_gnts_c++
>> kick_pending_request_queues()
>>
>>                                     stop block request queue
>>                                     added to callback list
>>
>> If the system don't have enough grants(but have enough persistent_gnts),
>> request queue would still hang.
> 
> Not sure how can this happen, blkif_queue_request explicitly checks that
> persistent_gnts_c < max_grefs before adding the callback and stopping
> the request queue, so in your case the queue should not be blocked. Can
> you dump the state of info->connected?
> 

All virtual disks are in "connected" status. And you are right this race
condition won't happen. I'll dump more data if see this issue again.

Thanks,
-Bob
