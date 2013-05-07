Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064Ab3EGIuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:50:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:51353 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758928Ab3EGIuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:50:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,627,1363158000"; 
   d="scan'208";a="237934745"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, "Wang, Biao" <biao.wang@intel.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "mochel@digitalimplant.org" <mochel@digitalimplant.org>
Subject: RE: [PATCH] klist: del waiter from klist_remove_waiters before
 wakeup waitting process
Thread-Topic: [PATCH] klist: del waiter from klist_remove_waiters before
 wakeup waitting process
Thread-Index: AQHOR+rcm3IVOVXl7EyABKUrqYyo85j5b6uA
Date: Tue, 7 May 2013 08:49:54 +0000
Message-ID: <144086DDB7BB6D429C79280EB1C804D409CE3BAC@SHSMSX102.ccr.corp.intel.com>
References: <1367564796.27529.15.camel@wangbiao>
 <20130503104207.GA27558@dyad.programming.kicks-ass.net>
In-Reply-To: <20130503104207.GA27558@dyad.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Would you like to merge the patch to your MM tree?

Yanmin

>-----Original Message-----
>From: Peter Zijlstra [mailto:peterz@infradead.org]
>Sent: Friday, May 03, 2013 6:42 PM
>To: Wang, Biao
>Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
>mingo@redhat.com; Zhang, Yanmin; mochel@digitalimplant.org
>Subject: Re: [PATCH] klist: del waiter from klist_remove_waiters before wakeup
>waitting process
>
>On Fri, May 03, 2013 at 03:06:36PM +0800, wangbiao wrote:
>> From: "wang, biao" <biao.wang@intel.com>
>> Date: Fri, 3 May 2013 14:18:34 +0800
>> Subject: [PATCH] klist: del waiter from klist_remove_waiters before
>> wakeup  waitting process
>>
>> There is a race between klist_remove and klist_release. klist_remove
>> uses a local var waiter saved on stack. When klist_release calls
>> wake_up_process(waiter->process) to wake up the waiter, waiter might
>> run immediately and reuse the stack. Then, klist_release calls
>> list_del(&waiter->list) to change previous wait data and cause prior
>> waiter thread corrupt.
>>
>> The patch fixes it against kernel 3.9.
>
>
>I've never seen that code before in my life; but after a quick look you appear to
>be completely right.
>
>> Signed-off-by: wang, biao <biao.wang@intel.com>
>
>Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
>> ---
>>  lib/klist.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/lib/klist.c b/lib/klist.c index 0874e41..358a368 100644
>> --- a/lib/klist.c
>> +++ b/lib/klist.c
>> @@ -193,10 +193,10 @@ static void klist_release(struct kref *kref)
>>  		if (waiter->node != n)
>>  			continue;
>>
>> +		list_del(&waiter->list);
>>  		waiter->woken = 1;
>>  		mb();
>>  		wake_up_process(waiter->process);
>> -		list_del(&waiter->list);
>>  	}
>>  	spin_unlock(&klist_remove_lock);
>>  	knode_set_klist(n, NULL);
>> --
>> 1.7.6
>>
>>
>>
