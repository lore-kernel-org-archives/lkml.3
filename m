Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaIITD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:03:59 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44597 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaIITD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:03:57 -0400
Message-ID: <540F4F0E.8050306@gmail.com>
Date: Tue, 09 Sep 2014 21:03:42 +0200
From: Imre Palik <imrep.amz@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: drbd-dev@lists.linbit.com, Philipp Reisner <philipp.reisner@linbit.com>,
        linux-kernel@vger.kernel.org, "Palik, Imre" <imrep@amazon.de>,
        Matt Wilson <msw@amazon.com>
Subject: Re: [PATCH v3] drbd: fix throttling on newly created DM backing devices
References: <1409942478-29135-1-git-send-email-imrep.amz@gmail.com> <20140907095834.GA2332@hein> <540DA998.7060807@gmail.com> <20140908133816.GF9353@soda.linbit>
In-Reply-To: <20140908133816.GF9353@soda.linbit>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/14 15:38, Lars wrote:
> On Mon, Sep 08, 2014 at 03:05:28PM +0200, Imre Palik wrote:
>> On 09/07/14 11:58, Lars wrote:
>>> On Fri, Sep 05, 2014 at 08:41:18PM +0200, Imre Palik wrote:
>>>> From: "Palik, Imre" <imrep@amazon.de>
>>>>
>>>> If the drbd backing device is a new device mapper device (e.g., a
>>>> dm-linear mapping of an existing block device that contains data), the
>>>> counters are initially 0 even though the device contains useful
>>>> data. This causes throttling until something accesses the drbd device
>>>> or the backing device.
>>>
>>> What was wrong with my previous proposal?
>>
>> Sorry, I haven't realised you added a proposal to your reply.  It
>> seems, I really needed that extra sleep during the weekend ...
>>
>> Your proposal is good.  Of course, I like my last one a slightly
>> better.  But as they say, beauty is in the eye of the beholder :-)
>>
>>> How does changing the signedness help with
>>> rs_last_events not being properly initialized?
>>
>> It only helps with reasoning.  I reason with modular arithmetic way
>> easier than with signed integer overflows.  Accidentally, 0 is a
>> good initialisation value in case of unsigned arithmetic.
>>
>>> Are you sure you have also considered all wrap-around cases?
>>>
>>> Maybe you are too focused on your particular corner case
>>> (disk_stats starting with 0).
>>> Maybe I'm just thick right now, so please explain.
>>
>> The idea is that 0 is the smallest possible value for an unsigned,
>> and curr_events is monotonically increasing (mod 2^32) .
>
> The problem is: it is not :-(
>
> It's a difference between stats that are increased by the
> block core at (usually) completion time, and an atomic_t
> that is increased by DRBD at just before (or just after) submittion.
>
> Depending very much on stress in the IO subsystem,
> and overall timing of events, a later call may see a smaller
> "curr_events" (because rs_last_sect_ev has already increased,
> but the disk stats have not yet noticed).
>
> With unsigned, that may wrap around to UINT_MAX, which we don't want.

I see.  You hide the jitter behind the signedness.  Thanks for the 
explanation.

>> This
>> means, initially either curr_events > 64, that is, we enter the
>> loop, and do the initialisation, or it will be bigger than 64 at
>> most when we want to start throttle in an ideal world (after no more
>> than 64 sectors of activity).
>>
>> Basically, while you initialise rs_last_events to an ideal value
>> with some calculation, I choose a safe static value.  I am content
>> with both approaches.  I think, as a subsystem maintainer, you
>> should choose the one you like better.  If you choose yours, then
>> you can add
>> Reviewed-by: Imre Palik <imrep@amazon.de>
>
> Thanks,
>
> 	Lars
>

