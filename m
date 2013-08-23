Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3HWKiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:38:10 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:5717 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab3HWKiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:38:09 -0400
Message-ID: <52173B89.7070607@atmel.com>
Date: Fri, 23 Aug 2013 11:38:01 +0100
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: <devel@linuxdriverproject.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/4] staging: ozwpan: Create deferred work to destroy
 PD object.
References: <1377189531-24950-1-git-send-email-rupesh.gujare@atmel.com> <1377189531-24950-4-git-send-email-rupesh.gujare@atmel.com> <52164E53.9000700@cogentembedded.com>
In-Reply-To: <52164E53.9000700@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/13 18:45, Sergei Shtylyov wrote:
>> +void oz_pd_destroy(struct oz_pd *pd)
>> +{
>> +    int ret;
>> +
>> +    if (hrtimer_active(&pd->timeout))
>> +        hrtimer_cancel(&pd->timeout);
>> +    if (hrtimer_active(&pd->heartbeat))
>> +        hrtimer_cancel(&pd->heartbeat);
>> +
>> +    memset(&pd->workitem, 0, sizeof(pd->workitem));
>> +    INIT_WORK(&pd->workitem, oz_pd_free);
>
>    Hm, memset(), then INIT_WORK()? Is memset() necessary?

Opps.. you are right, I think we don't need memset() here.

>
>> +    ret = schedule_work(&pd->workitem);
>> +
>
>    Don't think empty line is needed here.


Yes, I agree. I will send follow on patches to fix this, as original 
patches had already been applied by Greg.


>
>> +    if (ret)
>> +        oz_pd_dbg(pd, ON, "failed to schedule workitem\n");
>> +}
>> +
>> +/*------------------------------------------------------------------------------ 
>>
>>    * Context: softirq-serialized
>>    */
>>   int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
>> diff --git a/drivers/staging/ozwpan/ozpd.h 
>> b/drivers/staging/ozwpan/ozpd.h
>> index 996ef65..12c7129 100644
>> --- a/drivers/staging/ozwpan/ozpd.h
>> +++ b/drivers/staging/ozwpan/ozpd.h
>> @@ -99,6 +99,7 @@ struct oz_pd {
>>       u8      timeout_type;
>>       struct tasklet_struct   heartbeat_tasklet;
>>       struct tasklet_struct   timeout_tasklet;
>> +    struct work_struct workitem;
>
>    Er, other field names seem aligned, what about this one?
>

After applying patch, it looks all right to me.


-- 
Regards,
Rupesh Gujare

