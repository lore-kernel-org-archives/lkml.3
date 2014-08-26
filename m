Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbaHZPAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:00:46 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:34806 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbaHZPAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:00:45 -0400
MIME-Version: 1.0
In-Reply-To: <53FC9FF5.7060106@fb.com>
References: <CACVxJT8LW4NOj7ksbcmfHig7MjJTK3AabZbnzWcNPNfznwPKrw@mail.gmail.com>
	<53FC9FF5.7060106@fb.com>
Date: Tue, 26 Aug 2014 18:00:43 +0300
Message-ID: <CACVxJT_usd+8bDnctx6+4kgozE1GDONA+a+W+QWaa_tzuKCUEg@mail.gmail.com>
Subject: Re: /proc/diskstats buglet
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jens Axboe <axboe@fb.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 5:55 PM, Jens Axboe <axboe@fb.com> wrote:
> On 08/26/2014 08:47 AM, Alexey Dobriyan wrote:
>> Found and reproduced some time ago, almost forgot about :-)
>>
>> In part_round_stats_single(), ->stamp field is written but without
>> locking SMP-wise.
>>
>>     part->stamp = now;
>>
>> So, if two processes read /proc/diskstats, it is possible for "now -
>> part->stamp" value to become negative.
>>
>> And indeed this can happen:
>>
>> now 4294755500, ->stamp 4294755501
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 1950 at block/blk-core.c:1229
>> part_round_stats_single+0xc0/0xd0()
>>  ...
>>  [<ffffffff811963f0>] part_round_stats_single+0xc0/0xd0
>>  [<ffffffff81196447>] part_round_stats+0x47/0x70
>>  [<ffffffff811a069d>] diskstats_show+0x8d/0x4b0
>>  ...
>>
>> Dunno how important used fields in /proc/diskstats but they can be
>> clearly bogus.
>
> Easiest fix is probably just to do the now - part->stamp math earlier,
> and ignore <= 0 instead of just now == part->stamp. I think that should
> be good enough for disk stats, and (most importantly), it would avoid
> the warning.
>
> Speaking of the warning, I don't see where that is. Where is it from?

I inserted the warning to be sure bug exists and I am not misreading the code.

  Alexey
