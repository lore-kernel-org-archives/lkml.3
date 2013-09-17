Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3IQSXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:23:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53857 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3IQSXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:23:50 -0400
Message-ID: <52389E25.5010605@kernel.dk>
Date: Tue, 17 Sep 2013 12:23:33 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: BLK_TN_PROCESS events not delivered for all devices
References: <20130916092347.GB19027@quack.suse.cz> <52386733.4010801@kernel.dk> <20130917171028.GB16938@quack.suse.cz>
In-Reply-To: <20130917171028.GB16938@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 11:10 AM, Jan Kara wrote:
> On Tue 17-09-13 08:29:07, Jens Axboe wrote:
>> On 09/16/2013 03:23 AM, Jan Kara wrote:
>>>   Hi,
>>>
>>>   I've been looking into a problem where BLK_TN_PROCESS events are not
>>> delivered to all devices which are being traced. This results in process
>>> name being (null) when trace for a single device is parsed.
>>>
>>> The reason for this problem is that trace_note_tsk() is called only if
>>> tsk->btrace_seq != blktrace_seq and it updates tsk->btrace_seq to
>>> blktrace_seq. Thus after a trace for another device is started
>>> BLK_TN_PROCESS event is sent only on behalf of the first device with which
>>> the task interacts. That isn't necessarily the new device thus traces for
>>> some devices accumulate several BLK_TN_PROCESS events for one task while
>>> other have none. Is this a known problem and is this intended to work
>>> better?
>>>
>>> I was thinking how to fix that for a while and it doesn't seem to be
>>> possible without tracking with each block trace which tasks it has been
>>> notified about. And that is relatively expensive...
>>
>> It is unfortunately a known issue... I have not come up with a good way
>> to fix it either, while keeping it cheap. So if you think of something,
>> do let me know.
>   Hum... How about linking all running block traces (struct blk_trace) in a
> linked list and sending BLK_TN_PROCESS to all the traces? Sure we will be
> spamming with BLK_TN_PROCESS a bit but starting a trace isn't such a common
> thing so it shouldn't be too bad. What do you think?

That might be good enough. I'm not worried about start/stop type
expenses, those things generally don't matter. And the list wont add any
fast path overhead when tracing.

-- 
Jens Axboe

