Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaJCVYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:24:47 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36098 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaJCVYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:24:46 -0400
Message-ID: <542F141A.8020601@kernel.dk>
Date: Fri, 03 Oct 2014 15:24:42 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "tytso@mit.edu" <tytso@mit.edu>,
        "gmazyland@gmail.com" <gmazyland@gmail.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>
Subject: Re: [PATCH] block: disable entropy contributions from nonrot devices
References: <1412295074-4984-1-git-send-email-snitzer@redhat.com> <94D0CD8314A33A4D9D801C0FE68B402958CCBFB5@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CCBFB5@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-02 21:26, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Mike Snitzer
>> Sent: Thursday, 02 October, 2014 7:11 PM
>> To: axboe@kernel.dk; linux-kernel@vger.kernel.org
>> Cc: tytso@mit.edu; gmazyland@gmail.com; agk@redhat.com; mpatocka@redhat.com
>> Subject: [PATCH] block: disable entropy contributions from nonrot devices
>>
>> Introduce queue_flags_set_nonrot_clear_add_random() and convert all
>> block drivers that set QUEUE_FLAG_NONROT over to using it instead.
>>
>> Historically, all block devices have automatically made entropy
>> contributions.  But as previously stated in commit e2e1a148 ("block: add
>> sysfs knob for turning off disk entropy contributions"):
>>      - On SSD disks, the completion times aren't as random as they
>>        are for rotational drives. So it's questionable whether they
>>        should contribute to the random pool in the first place.
>>      - Calling add_disk_randomness() has a lot of overhead.
>>
>> There are more reliable sources for randomness than non-rotational block
>> devices.  From a security perspective it is better to err on the side of
>> caution than to allow entropy contributions from unreliable "random"
>> sources.
>
> blk-mq defaults to off (QUEUE_FLAG_MQ_DEFAULT does not
> include QUEUE_FLAG_ADD_RANDOM).
>
> Even when it's off in block layer completion processing, all interrupts,
> storage or not, are forced to contribute during hardirq processing.
> I've seen this add 3-12 us latency blips every 64 interrupts (when
> the "fast_mix" code runs out of bits).

Yeah, it's a well known problem, and just as large (or larger) as the 
request completion randomness. It has significant performance 
implications, as your trace also shows. I'm pretty sure I complained 
about this 2-3 years ago (or longer), yet it's still poor.

I'd be fine with having an irq registration flag that says "don't 
contribute to randomness", on the grounds of more predictable irq 
latencies one these devices not adding any real entropy to the pool. But 
the suboptimal mixing should really be fixed.

-- 
Jens Axboe

