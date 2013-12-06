Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3LFQrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:47:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52226 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab3LFQrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:47:03 -0500
Message-ID: <52A1FF49.6090801@kernel.dk>
Date: Fri, 06 Dec 2013 09:46:01 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>, Ming Lei <tom.leiming@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [OOPS, 3.13-rc2] null ptr in dio_complete()
References: <20131203215940.GX10988@dastard> <20131204015837.GJ10988@dastard> <20131205222220.5d7f4a48@tom-ThinkPad-T410> <20131205212651.GP10988@dastard> <20131205231612.GQ10988@dastard>
In-Reply-To: <20131205231612.GQ10988@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 04:16 PM, Dave Chinner wrote:
> On Fri, Dec 06, 2013 at 08:26:51AM +1100, Dave Chinner wrote:
>> On Thu, Dec 05, 2013 at 10:22:20PM +0800, Ming Lei wrote:
>>> On Wed, 4 Dec 2013 12:58:38 +1100
>>> Dave Chinner <david@fromorbit.com> wrote:
>>>
>>>>
>>>> And I just hit this from running xfs_repair which is doing
>>>> multithreaded direct IO directly on /dev/vdc:
>> .....
>>>> So this is looking like another virtio+blk_mq problem....
>>>
>>> This one might be caused by using-after-'free' request because the freed
>>> request may be allocated to another CPU immediately, and the below patch
>>> may be helpful, would you mind testing it?
>>>
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index 6875736..2358bdf 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -311,12 +311,12 @@ void blk_mq_complete_request(struct request *rq, int error)
>>>  
>>>  	blk_account_io_completion(rq, bytes);
>>>  
>>> +	blk_account_io_done(rq);
>>> +
>>>  	if (rq->end_io)
>>>  		rq->end_io(rq, error);
>>>  	else
>>>  		blk_mq_free_request(rq);
>>> -
>>> -	blk_account_io_done(rq);
>>>  }
>>>  
>>>  void __blk_mq_end_io(struct request *rq, int error)
>>
>> Testing it now. I'll let you know how it goes in couple of hours.
> 
> Ok, this looks like it is working correctly. The read/write io stats
> are now working properly, too. Thanks for finding the problem
> quickly!

Great, thanks for testing, Dave. The fix is now in Linus' tree.

-- 
Jens Axboe

