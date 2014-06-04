Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaFDL3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:29:35 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:33712 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaFDL3e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:29:34 -0400
MIME-Version: 1.0
X-Originating-IP: [130.226.142.243]
In-Reply-To: <20140604103901.GA14383@kernel.org>
References: <1399627061-5960-1-git-send-email-m@bjorling.me>
	<1399627061-5960-2-git-send-email-m@bjorling.me>
	<536CE25C.5040107@kernel.dk>
	<536D0537.7010905@kernel.dk>
	<20140530121119.GA1637@kernel.org>
	<53888C80.2020206@kernel.dk>
	<20140604103901.GA14383@kernel.org>
Date: Wed, 4 Jun 2014 13:29:33 +0200
Message-ID: <CAOu_J6nRZuktyozjychkLOA+1zwct2+7KPUxfNAghVOOOBfi+g@mail.gmail.com>
Subject: Re: [PATCH] block: per-cpu counters for in-flight IO accounting
From: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's in

blk_io_account_start
  part_round_stats
    part_round_state_single
      part_in_flight

I like the granularity idea.

Thanks,
Matias

On Wed, Jun 4, 2014 at 12:39 PM, Shaohua Li <shli@kernel.org> wrote:
> On Fri, May 30, 2014 at 07:49:52AM -0600, Jens Axboe wrote:
>> On 2014-05-30 06:11, Shaohua Li wrote:
>> >On Fri, May 09, 2014 at 10:41:27AM -0600, Jens Axboe wrote:
>> >>On 05/09/2014 08:12 AM, Jens Axboe wrote:
>> >>>On 05/09/2014 03:17 AM, Matias Bjørling wrote:
>> >>>>With multi-million IOPS and multi-node workloads, the atomic_t in_flight
>> >>>>tracking becomes a bottleneck. Change the in-flight accounting to per-cpu
>> >>>>counters to elevate.
>> >>>
>> >>>The part stats are a pain in the butt, I've tried to come up with a
>> >>>great fix for them too. But I don't think the percpu conversion is
>> >>>necessarily the right one. The summing is part of the hotpath, so percpu
>> >>>counters aren't necessarily the right way to go. I don't have a better
>> >>>answer right now, otherwise it would have been fixed :-)
>> >>
>> >>Actual data point - this slows my test down ~14% compared to the stock
>> >>kernel. Also, if you experiment with this, you need to watch for the
>> >>out-of-core users of the part stats (like DM).
>> >
>> >I had a try with Matias's patch. Performance actually boost significantly.
>> >(there are other cache line issue though, eg, hd_struct_get). Jens, what did
>> >you run? part_in_flight() has 3 usages. 2 are for status output, which are cold
>> >path. part_round_stats_single() uses it too, but it's a cold path too as we
>> >simple data every jiffy. Are you using HZ=1000? maybe we should simple the data
>> >every 10ms instead of every jiffy?
>>
>> I ran peak and normal benchmarks on a p320, on a 4 socket box (64
>> cores). The problem is the one hot path of part_in_flight(), summing
>> percpu for that is too expensive. On bigger systems than mine, it'd
>> be even worse.
>
> I run a null_blk test with 4 sockets, Matias has improvement. And I didn't find
> part_in_flight() is called in any hot path.
>
> Thanks,
> Shaohua
