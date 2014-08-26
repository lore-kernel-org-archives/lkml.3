Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbaHZVhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:37:10 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:38751 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaHZVhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:37:08 -0400
Message-ID: <53FCFE01.8080701@kernel.dk>
Date: Tue, 26 Aug 2014 15:37:05 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Joe Lawrence <joe.lawrence@stratus.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3 0/2] block,scsi: fixup blk_get_request dead queue scenarios
References: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>	<x49egw36u55.fsf@segfault.boston.devel.redhat.com>	<53FCF9DB.6010501@kernel.dk> <x49mwar54ca.fsf@segfault.boston.devel.redhat.com> <53FCFD40.2010903@kernel.dk>
In-Reply-To: <53FCFD40.2010903@kernel.dk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 03:33 PM, Jens Axboe wrote:
> On 08/26/2014 03:27 PM, Jeff Moyer wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>>
>>> On 08/26/2014 11:24 AM, Jeff Moyer wrote:
>>>> Joe Lawrence <joe.lawrence@stratus.com> writes:
>>>>
>>>>> v2->v3: rebase to 3.16-rc2, consider return values from the
>>>>>         blk_mq_alloc_request leg of the blk_get_request callchain
>>>>>         (noted by Jeff), noted in the second patch changelog.
>>>>>
>>>>> 	blk_mq_queue_enter may return 0 or errno, which
>>>>>         blk_mq_alloc_request can propogate out via ERR_PTR.
>>>>> 	__blk_mq_alloc_request doesn't include any blk_queue_dying
>>>>> 	checks, so I'm assuming that its failures can be attributed
>>>>>         to -EWOULDBLOCK under !GFP_WAIT conditions.
>>>>>
>>>>> v1->v2: incorporate Jeff's feedback in bsg_map_hdr() and Reviewed-by
>>>>>         tags.
>>>>>
>>>>> Joe Lawrence (2):
>>>>>   block,scsi: verify return pointer from blk_get_request
>>>>>   block,scsi: fixup blk_get_request dead queue scenarios
>>>>
>>>> Jens,
>>>>
>>>> Did this patch set fall through the cracks again?
>>>
>>> Falling through the cracks implies that I meant to apply it and did not,
>>> which was not the case. 
>>
>> Sorry, I was mislead by our earlier conversation on this (mail inline
>> below).
> 
> I changed my mind, it didn't feel fully baked to me.
> 
>>> But I think we're at the point now where I'm finally comfortable with
>>> applying it. So, Joe, could you ensure that it applies to 3.17-rc2,
>>> then I will roll it in to the updates for 3.18.
>>
>> Joe, you will have one hunk to modify for sure, in scsi_ioctl.c.  A
>> previous patch added a check for null, but ended up returning the wrong
>> value (ENOMEM instead of ENODEV).
> 
> I have applied the first one, will look over the second one and hand
> apply it. Seems the NULL return was completely removed, so we _should_
> be ok on the IS_ERR() conversion, though that sort of thing always
> worries me a little bit. A NULL return can quickly show up again, and
> then they would all fail.

Additionally, there's still quite a few places that call
blk_get_request() and don't check the error return if __GFP_WAIT is set.
Since most of the point of this is to fix segfaulting on queue dead
scenarios, why aren't they all converted?

-- 
Jens Axboe

