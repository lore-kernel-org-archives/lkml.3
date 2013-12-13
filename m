Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3LMXPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 18:15:31 -0500
Received: from nigelcunningham.com.au ([178.79.133.97]:35444 "EHLO
	nigelcunningham.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3LMXPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 18:15:30 -0500
Message-ID: <52AB9509.1080004@nigelcunningham.com.au>
Date: Sat, 14 Dec 2013 10:15:21 +1100
From: Nigel Cunningham <nigel@nigelcunningham.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system
 is frozen
References: <20131213174932.GA27070@htj.dyndns.org> <20131213185237.GD27070@htj.dyndns.org> <20131213204034.GE27070@htj.dyndns.org> <52AB8E27.90308@nigelcunningham.com.au> <20131213230744.GA17954@htj.dyndns.org>
In-Reply-To: <20131213230744.GA17954@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On 14/12/13 10:07, Tejun Heo wrote:
> Hello, Nigel.
>
> On Sat, Dec 14, 2013 at 09:45:59AM +1100, Nigel Cunningham wrote:
>> In your first email, in the first substantial paragraph (starting
>> "Now, if the rest.."), you say "libata device removal waits for the
>> scheduled writeback work item to finish". I wonder if that's the
>> lynchpin. If we know the device is gone, why are we trying to write
>> to it?
> It's just a standard part of block device removal -
> invalidate_partition(), bdi_wb_shutdown().
Mmm. But perhaps there needs to be some special code in there to handle 
the "we can't write to this device anymore" case?
>
>> All pending I/O should have been flushed when suspend/hibernate
>> started, and there's no point in trying to update metadata on a
> Frozen or not, it isn't guaranteed that bdi wb queue is empty when the
> system went to suspend.  They're likely to be empty but there's no
> guarantee.  Conversion to workqueue only makes the behavior more
> deterministic.
>
>> device we can't access, so there should be no writeback needed (and
>> anything that does somehow get there should just be discarded since
>> it will never succeed anyway).
> Even if they'll never succeed, they still need to be issued and
> drained; otherwise, we'll end up with leaked items and hung issuers.
Yeah - I get that, but drained needs to work differently if the device 
doesn't exist?
>> Having said the above, I agree that we shouldn't need to freeze
>> kernel threads and workqueues themselves. I think we should be
>> giving the producers of I/O the nous needed to avoid producing I/O
>> during suspend/hibernate. But perhaps I'm missing something here,
>> too.
> I never understood that part.  Why do we need to control the
> producers?  The chain between the producer and consumer is a long one
> and no matter what we do with the producers, the consumers need to be
> plugged all the same.  Why bother with the producers at all?  I think
> that's where all this freezable kthreads started but I don't
> understand what the benefit of that is.  Not only that, freezer is
> awefully inadequate in its role too.  There are flurry of activities
> which happen in the IO path without any thread involved and many of
> them can lead to issuance of new IO, so the only thing freezer is
> achieving is making existing bugs less visible, which is a bad thing
> especially for suspend/resume as the failure mode often doesn't yield
> to easy debugging.
>
> I asked the same question years ago and ISTR getting only fairly vague
> answers but this whole freezable kthread is expectedly proving to be a
> continuous source of problems.  Let's at least find out whether we
> need it and why if so.  Not some "I feel better knowing things are
> calmer" type vagueness but actual technical necessity of it.
>
My understanding is that the point is ensuring that - particularly in 
the case of hibernation - we don't cause filesystem corruption by 
writing one thing while writing the image and then doing something else 
(without knowledge of what happened while the image was being written) 
while reading the image or after restoring it.

Regards,

Nigel

