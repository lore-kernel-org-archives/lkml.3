Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbbALHJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:09:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38004 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbALHJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:09:37 -0500
Message-ID: <54B3727A.108@oracle.com>
Date: Mon, 12 Jan 2015 15:06:34 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: =?windows-1252?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
CC: xen-devel@lists.xen.org, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        junxiao.bi@oracle.com
Subject: Re: [PATCH] xen/blkfront: restart request queue when there is enough
 persistent_gnts_c
References: <1420550343-14013-1-git-send-email-bob.liu@oracle.com> <54AFF909.3090909@citrix.com>
In-Reply-To: <54AFF909.3090909@citrix.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/09/2015 11:51 PM, Roger Pau Monné wrote:
> El 06/01/15 a les 14.19, Bob Liu ha escrit:
>> When there is no enough free grants, gnttab_alloc_grant_references()
>> will fail and block request queue will stop.
>> If the system is always lack of grants, blkif_restart_queue_callback() can't be
>> scheduled and block request queue can't be restart(block I/O hang).
>>
>> But when there are former requests complete, some grants may free to
>> persistent_gnts_c, we can give the request queue another chance to restart and
>> avoid block hang.
>>
>> Reported-by: Junxiao Bi <junxiao.bi@oracle.com>
>> Signed-off-by: Bob Liu <bob.liu@oracle.com>
>> ---
>>  drivers/block/xen-blkfront.c |   11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>> index 2236c6f..dd30f99 100644
>> --- a/drivers/block/xen-blkfront.c
>> +++ b/drivers/block/xen-blkfront.c
>> @@ -1125,6 +1125,17 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
>>  			}
>>  		}
>>  	}
>> +
>> +	/*
>> +	 * Request queue would be stopped if failed to alloc enough grants and
>> +	 * won't be restarted until gnttab_free_count >= info->callback->count.
>> +	 *
>> +	 * But there is another case, once we have enough persistent grants we
>> +	 * can try to restart the request queue instead of continue to wait for
>> +	 * 'gnttab_free_count'.
>> +	 */
>> +	if (info->persistent_gnts_c >= info->callback.count)
>> +		schedule_work(&info->work);
> 
> I guess I'm missing something here, but blkif_completion is called by
> blkif_interrupt, which in turn calls kick_pending_request_queues when
> finished, which IMHO should be enough to restart the processing of requests.
> 

You are right, sorry for the mistake.

The problem we met was a xenblock I/O hang.
Dumped data showed at that time info->persistent_gnt_c = 8, max_gref = 8
but block request queue was still stopped.
It's very hard to reproduce this issue, we only see it once.

I think there might be a race condition:

request A                          request B:

                                   info->persistent_gnts_c < max_grefs
                                   and fail to alloc enough grants


^^^^
interrupt happen, blkif_complte():
info->persistent_gnts_c++
kick_pending_request_queues()

                                    stop block request queue
                                    added to callback()

If the system don't have enough grants(but have enough persistent_gnts),
request queue would still hang.

-- 
Regards,
-Bob
