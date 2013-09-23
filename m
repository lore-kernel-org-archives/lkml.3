Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab3IWUMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:12:12 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:53145 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3IWUMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:12:10 -0400
From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "majianpeng@gmail.com" <majianpeng@gmail.com>
Subject: Re: [PATCH v2 1/2] elevator: Fix a race in elevator switching and
 md device initialization
Thread-Topic: [PATCH v2 1/2] elevator: Fix a race in elevator switching and
 md device initialization
Thread-Index: AQHOpdLdNzajY7OslkaUETgfqPSrrZnSYvOAgAGDsgA=
Date: Mon, 23 Sep 2013 20:11:55 +0000
Message-ID: <CE661700.7BC5%Tomoki.Sekiyama@hds.com>
In-Reply-To: <20130922170417.GF30946@htj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13862237B546AA4EB7E56DAE4CED6BE6@hds.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-09-23_03:2013-09-22,2013-09-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1309230111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Thank you for the review.

On 9/22/13 13:04 , "Tejun Heo" <tj@kernel.org> wrote:

>On Fri, Aug 30, 2013 at 06:47:07PM -0400, Tomoki Sekiyama wrote:
>> @@ -739,9 +739,17 @@ blk_init_allocated_queue(struct request_queue *q,
>>request_fn_proc *rfn,
>>  
>>  	q->sg_reserved_size = INT_MAX;
>>  
>> +	/* Protect q->elevator from elevator_change */
>> +	mutex_lock(&q->sysfs_lock);
>> +
>>  	/* init elevator */
>> -	if (elevator_init(q, NULL))
>> +	if (elevator_init(q, NULL)) {
>> +		mutex_unlock(&q->sysfs_lock);
>>  		return NULL;
>> +	}
>> +
>> +	mutex_unlock(&q->sysfs_lock);
>> +
>>  	return q;
>>  }
>>  EXPORT_SYMBOL(blk_init_allocated_queue);
>> diff --git a/block/elevator.c b/block/elevator.c
>> index 668394d..02d4390 100644
>> --- a/block/elevator.c
>> +++ b/block/elevator.c
>> @@ -186,6 +186,12 @@ int elevator_init(struct request_queue *q, char
>>*name)
>>  	struct elevator_type *e = NULL;
>>  	int err;
>>  
>> +	/*
>> +	 * q->sysfs_lock must be held to provide mutual exclusion between
>> +	 * elevator_switch() and here.
>> +	 */
>> +	lockdep_assert_held(&q->sysfs_lock);
>> +
>>  	if (unlikely(q->elevator))
>>  		return 0;
>
>Hmm... why aren't we just changing elevator_init() to grab sysfs_lock
>where necessary?  

The locking cannot be moved into elevator_init() because it is called
from elevator_switch() path, where the request_queue's sysfs_lock is
already taken.

> It'd be more consistent with elevator_exit() that way.

What elevator_exit() locks is elevator_queue's sysfs_lock, not
request_queue's sysfs_lock. What we need here is request_queue's
sysfs_lock.

>Thanks.
>
>-- 
>Tejun


Thanks,
Tomoki Sekiyama


