Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab3FEQOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:14:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50694 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab3FEQOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:14:22 -0400
Message-ID: <51AF646D.7030903@oracle.com>
Date: Thu, 06 Jun 2013 00:16:45 +0800
From: vaughan <vaughan.cao@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: dgilbert@interlog.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sg: atomize check and set sdp->exclude in sg_open
References: <51AF0269.9070900@oracle.com> <20130605132746.GA1690@logfs.org>
In-Reply-To: <20130605132746.GA1690@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年06月05日 21:27, Jörn Engel 写道:
> On Wed, 5 June 2013 17:18:33 +0800, vaughan wrote:
>>
>> Check and set sdp->exclude should be atomic when set in sg_open().
>
> The patch is line-wrapped.  More importantly, it doesn't seem to do
It's shorter than the original line, so I just leave it like this...

> what your description indicates it should do.  And lastly, does this
> fix a bug, possibly even one you have a testcase for, or was it found
> by code inspection?
I found it by code inspection. A race condition may happen with the old 
code if two threads are both trying to open the same sg with O_EXCL 
simultaneously. It's possible that they both find fsds list is empty and 
get_exclude(sdp) returns 0, then they both call set_exclude() and break 
out from wait_event_interruptible and resume open. So it's necessary to 
check again with sg_open_exclusive_lock held to ensure only one can set 
sdp->exclude and return >0 to break out from wait_event loop.

>
>> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
>> ---
>>   drivers/scsi/sg.c | 17 ++++++++++++++++-
>>   1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index 25b5455..0ede08f 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -245,6 +245,21 @@ static int set_exclude(Sg_device *sdp, char val)
>>       return val;
>>   }
>>
>> +/* Check if we can set exclude and then set, return 1 if success */
>> +static int try_set_exclude(Sg_device *sdp)
>> +{
>> +    unsigned long flags;
>> +
>> +    spin_lock_irqsave(&sg_open_exclusive_lock, flags);
>> +    if (sdp->exclude) {
>> +        spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
>> +        return 0;
>> +    }
>> +    sdp->exclude = 1;
>> +    spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
>> +    return 1;
>> +}
>> +
>>   static int sfds_list_empty(Sg_device *sdp)
>>   {
>>       unsigned long flags;
>> @@ -303,7 +318,7 @@ sg_open(struct inode *inode, struct file *filp)
>>               goto error_out;
>>           }
>>           res = wait_event_interruptible(sdp->o_excl_wait,
>> -                       ((!sfds_list_empty(sdp) || get_exclude(sdp))
>> ? 0 : set_exclude(sdp, 1)));
>> +            ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 :
>> try_set_exclude(sdp)));
>>           if (res) {
>>               retval = res;    /* -ERESTARTSYS because signal hit process */
>>               goto error_out;
>> --
>> 1.7.11.7
>>
>
> Jörn
>
> --
> Fantasy is more important than knowledge. Knowledge is limited,
> while fantasy embraces the whole world.
> -- Albert Einstein
>
