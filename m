Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbaHHO2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:28:51 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63956 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbaHHO2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:28:49 -0400
Message-ID: <53E4DE9F.7090603@kernel.dk>
Date: Fri, 08 Aug 2014 08:28:47 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, oren@purestorage.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race in get_request()
References: <20140808005443.GA7895@logfs.org> <53E4DD9C.1050306@kernel.dk>
In-Reply-To: <53E4DD9C.1050306@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 08:24 AM, Jens Axboe wrote:
> On 08/07/2014 06:54 PM, Jörn Engel wrote:
>> Hello Jens!
>>
>> I came across the below while investigating some other problem.
>> Something here doesn't seem right.  This looks like an obvious bug and
>> something roughly along the lines of my patch would fix it.  But I
>> must be in the wrong decade to find such a bug in the block layer.
>>
>> Is this for real?  Or if not, what am I missing?
>>
>> Jörn
>>
>> --
>>
>> If __get_request() returns NULL, get_request will call
>> prepare_to_wait_exclusive() followed by io_schedule().  Not rechecking
>> the sleep condition after prepare_to_wait_exclusive() leaves a race
>> where the condition changes before prepare_to_wait_exclusive(), but
>> not after and accordingly this thread never gets woken up.
>>
>> The race must be exceedingly hard to hit, otherwise I cannot explain how
>> such a classic race could outlive the last millenium.
> 
> I think that is a genuine bug, it's just extremely hard to hit in real
> life. It has probably only potentially ever triggered in the cases where
> we are so out of memory that a blocking ~300b alloc fails, and Linux
> generally shits itself pretty hard when it gets to that stage anyway...
> And for the bug to be critical, you'd need this to happen for a device
> that otherwise has no IO pending, since you'd get woken up by the next
> completed request anyway.

Actually, this can't trigger for an empty queue, since the mempool holds
a few requests. So it should never result in a softlock, we will make
progress. Given that we also still hold the queue spinlock (that will be
held for a free as well), we should not be able to get a free of a
request until the prepare_to_wait() has been done. So not sure there is
an actual bug there, but I agree the code looks confusing that way.

-- 
Jens Axboe

