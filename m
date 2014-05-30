Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbaE3Nt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:49:57 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58461 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaE3Ntz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:49:55 -0400
Message-ID: <53888C80.2020206@kernel.dk>
Date: Fri, 30 May 2014 07:49:52 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>, sbradshaw@micron.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: per-cpu counters for in-flight IO accounting
References: <1399627061-5960-1-git-send-email-m@bjorling.me> <1399627061-5960-2-git-send-email-m@bjorling.me> <536CE25C.5040107@kernel.dk> <536D0537.7010905@kernel.dk> <20140530121119.GA1637@kernel.org>
In-Reply-To: <20140530121119.GA1637@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-30 06:11, Shaohua Li wrote:
> On Fri, May 09, 2014 at 10:41:27AM -0600, Jens Axboe wrote:
>> On 05/09/2014 08:12 AM, Jens Axboe wrote:
>>> On 05/09/2014 03:17 AM, Matias Bjørling wrote:
>>>> With multi-million IOPS and multi-node workloads, the atomic_t in_flight
>>>> tracking becomes a bottleneck. Change the in-flight accounting to per-cpu
>>>> counters to elevate.
>>>
>>> The part stats are a pain in the butt, I've tried to come up with a
>>> great fix for them too. But I don't think the percpu conversion is
>>> necessarily the right one. The summing is part of the hotpath, so percpu
>>> counters aren't necessarily the right way to go. I don't have a better
>>> answer right now, otherwise it would have been fixed :-)
>>
>> Actual data point - this slows my test down ~14% compared to the stock
>> kernel. Also, if you experiment with this, you need to watch for the
>> out-of-core users of the part stats (like DM).
>
> I had a try with Matias's patch. Performance actually boost significantly.
> (there are other cache line issue though, eg, hd_struct_get). Jens, what did
> you run? part_in_flight() has 3 usages. 2 are for status output, which are cold
> path. part_round_stats_single() uses it too, but it's a cold path too as we
> simple data every jiffy. Are you using HZ=1000? maybe we should simple the data
> every 10ms instead of every jiffy?

I ran peak and normal benchmarks on a p320, on a 4 socket box (64 
cores). The problem is the one hot path of part_in_flight(), summing 
percpu for that is too expensive. On bigger systems than mine, it'd be 
even worse.

But the stats are definitely an issue. The part references suck as well, 
as you mention, those need fixing up as well. And changing it to be 
every 10ms regardless of HZ is probably a good idea, at least then the 
granularity is fixed as well.

-- 
Jens Axboe

