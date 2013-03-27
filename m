Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3C0TJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:09:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57078 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3C0TJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:09:42 -0400
X-IronPort-AV: E=Sophos;i="4.84,920,1355126400"; 
   d="scan'208";a="32994257"
Message-ID: <d6658b60b7e09376cfcf692dc54ac922.squirrel@www.codeaurora.org>
In-Reply-To: <20130325123410.GG22327@kernel.dk>
References: <1364202150-8776-1-git-send-email-tlinder@codeaurora.org>
    <20130325123410.GG22327@kernel.dk>
Date: Wed, 27 Mar 2013 12:09:41 -0700
Subject: Re: [PATCH v5 1/3] block: Add support for reinsert a dispatched req
From: tlinder@codeaurora.org
To: "Jens Axboe" <axboe@kernel.dk>
Cc: "Tanya Brokhman" <tlinder@codeaurora.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, alex.lemberg@sandisk.com,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens

>> Add support for reinserting a dispatched request back to the
>> scheduler's internal data structures.
>> This capability is used by the device driver when it chooses to
>> interrupt the current request transmission and execute another (more
>> urgent) pending request. For example: interrupting long write in order
>> to handle pending read. The device driver re-inserts the
>> remaining write request back to the scheduler, to be rescheduled
>> for transmission later on.
>>
>> Add API for verifying whether the current scheduler
>> supports reinserting requests mechanism. If reinsert mechanism isn't
>> supported by the scheduler, this code path will never be activated.
>
> This is practically the exact same operation as a requeue.

Not exactly. When you requeue request X it will be the next one to be
dispatched and handled by the device driver. When you reinsert a request,
you reinset it back to the I/O scheduler and not to the dispatch queue.
That means that this reinserted request will be rescheduled and its
possible that it wont be the next one to be dispatched since there might
be more urgent requests pending.
For example: an urgent request notification was sent to the device driver
that is currently transmitting a long packed WRITE command. The urgent
request pending to be served is a READ request. The device driver decides
to stop the packed WRITE request and handle the urgent READ. This is the
difference between requeue and reinsert:
 - if we requeue the stopped packed WRITE, it will be immediately fetched
and transmitted again and the READ will be left pending till the packed
WRITE completes. In this case there was no point in stopping the packed
WRITE
- if we reinsert the stopped packed WRITE the next request to be
dispatched will be the urgent READ request (since READ is given priority
over WRITE) and this will reduce the READ latency greatly.

> So why this
> duplication? I also don't quite understand why an IO scheduler would
> have to opt-in for this, seems like a pretty basic operation.

I hope the above example addressed this as well. Please let me know if
this is not the case.

Thanks
Tanya Brokhman
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation



