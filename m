Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3BRLmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:42:33 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62125 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3BRLmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:42:31 -0500
MIME-Version: 1.0
In-Reply-To: <5121C7AF.2090803@numascale-asia.com>
References: <5121C7AF.2090803@numascale-asia.com>
Date: Mon, 18 Feb 2013 19:42:30 +0800
Message-ID: <CAJd=RBArPT8YowhLuE8YVGNfH7G-xXTOjSyDgdV2RsatL-9m+Q@mail.gmail.com>
Subject: Re: kswapd craziness round 2
From: Hillf Danton <dhillf@gmail.com>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 2:18 PM, Daniel J Blueman
<daniel@numascale-asia.com> wrote:
> On Monday, 18 February 2013 06:10:02 UTC+8, Jiri Slaby  wrote:
>
>> Hi,
>>
>> You still feel the sour taste of the "kswapd craziness in v3.7" thread,
>> right? Welcome to the hell, part two :{.
>>
>> I believe this started happening after update from
>> 3.8.0-rc4-next-20130125 to 3.8.0-rc7-next-20130211. The same as before,
>> many hours of uptime are needed and perhaps some suspend/resume cycles
>> too. Memory pressure is not high, plenty of I/O cache:
>> # free
>>              total       used       free     shared    buffers     cached
>> Mem:       6026692    5571184     455508          0     351252    2016648
>> -/+ buffers/cache:    3203284    2823408
>> Swap:            0          0          0
>>
>> kswap is working very toughly though:
>> root       580  0.6  0.0      0     0 ?        S    úno12  46:21 [kswapd0]
>>
>> This happens on I/O activity right now. For example by updatedb or find
>> /. This is what the stack trace of kswapd0 looks like:
>> [<ffffffff8113c431>] shrink_slab+0xa1/0x2d0
>> [<ffffffff8113ecd1>] kswapd+0x541/0x930
>> [<ffffffff810a3000>] kthread+0xc0/0xd0
>> [<ffffffff816beb5c>] ret_from_fork+0x7c/0xb0
>> [<ffffffffffffffff>] 0xffffffffffffffff
>
> Likewise with 3.8-rc, I've been able to reproduce [1] a livelock scenario
> which hoses the box and observe RCU stalls are observed [2].
>
> There may be a connection; I'll do a bit more debugging in the next few
> days.
>
> Daniel
>
> --- [1]
>
> 1. live-booted image using ramdisk
> 2. boot 3.8-rc with <16GB memory and without swap
> 3. run OpenMP NAS Parallel Benchmark dc.B against local disk (ie not
> ramdisk)
> 4. observe hang O(30) mins later
>
> --- [2]
>
> [ 2675.587878] INFO: rcu_sched self-detected stall on CPU { 5}  (t=24000
> jiffies g=6313 c=6312 q=68)

Does Ingo's revert help? https://lkml.org/lkml/2013/2/15/168
