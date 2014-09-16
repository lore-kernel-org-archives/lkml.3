Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbaIPBec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:34:32 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:59944 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbaIPBea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:34:30 -0400
Message-ID: <541794E5.7020207@gmail.com>
Date: Tue, 16 Sep 2014 09:39:49 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, konrad.wilk@oracle.com,
        David Vrabel <david.vrabel@citrix.com>,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] drivers/xen/xenbus/xenbus_client.c: Improve the failure
 processing for __xenbus_switch_state()
References: <54157282.40402@gmail.com> <5415737D.2030209@gmail.com> <54178D6E.9090705@oracle.com>
In-Reply-To: <54178D6E.9090705@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/16/14 9:07, Boris Ostrovsky wrote:
> 
> On 09/14/2014 06:52 AM, Chen Gang wrote:
>> When failure occurs, need return failure code instead of 0, or the upper
>> caller will misunderstand.
>>
>> Also when retry for EAGAIN reason, better to schedule out for a while,
>> so can let others have chance to continue their tasks (especially,
>> their tasks are related EAGAIN under UP kernel).
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>   drivers/xen/xenbus/xenbus_client.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
>> index 620ffd2..fc8699b 100644
>> --- a/drivers/xen/xenbus/xenbus_client.c
>> +++ b/drivers/xen/xenbus/xenbus_client.c
>> @@ -36,6 +36,7 @@
>>   #include <linux/spinlock.h>
>>   #include <linux/vmalloc.h>
>>   #include <linux/export.h>
>> +#include <linux/delay.h>
>>   #include <asm/xen/hypervisor.h>
>>   #include <asm/xen/page.h>
>>   #include <xen/interface/xen.h>
>> @@ -196,7 +197,7 @@ again:
>>       err = xenbus_transaction_start(&xbt);
>>       if (err) {
>>           xenbus_switch_fatal(dev, depth, err, "starting transaction");
>> -        return 0;
>> +        return err;
>>       }
>>         err = xenbus_scanf(xbt, dev->nodename, "state", "%d", &current_state);
>> @@ -213,13 +214,15 @@ again:
>>   abort:
>>       err = xenbus_transaction_end(xbt, abort);
>>       if (err) {
>> -        if (err == -EAGAIN && !abort)
>> +        if (err == -EAGAIN && !abort) {
>> +            msleep(20);
> 
> I'd suggest you use schedule() here.
> 

For me, it is really better than msleep(20).

But just like the related maintainer said, we do not need it, since it
has already "have a rest" inside xenbus_transaction_end().


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
