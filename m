Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbaJHL7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:59:14 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:59565 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbaJHL7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:59:12 -0400
MIME-Version: 1.0
In-Reply-To: <543523A8.1040006@gmail.com>
References: <CAFLt3pjkXgz9H9p=u-NATyf4C+8ybJ3fwLc=GXEjaabBZ8NF5g@mail.gmail.com>
	<543523A8.1040006@gmail.com>
Date: Wed, 8 Oct 2014 13:59:11 +0200
Message-ID: <CAFLt3pjSQq+Q5mk1e74m9yXUTYZ8JkojQGKieTWonxomR0KOMA@mail.gmail.com>
Subject: Re: High latency while CPU is under full load
From: Grozdan <neutrino8@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 1:44 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2014-10-07 15:28, Grozdan wrote:
>>
>> Hi,
>>
>> Basically, my problem is this:
>>
>> I'm doing a lot of audio/video encoding on an AMD FX8350. The encoder
>> process always runs at nice 10. Even so, my whole system feels very
>> sluggish. Switching between different app windows and/or virtual
>> desktops takes up usually 3-5 seconds giving the impression that there
>> is not enough processing power. Browsing the web is also severely
>> impacted.
>>
>> I had to tune CFS in order to be (much) more responsive during an
>> encoding session. This has worked out pretty well thus far, but it is
>> my opinion that the user should *not* need to fiddle with buttons to
>> make his system respond fluently even under high load. The below is
>> what I had to do in order to get a snappy system during such load
>>
>> kernel.sched_nr_migrate = 64
>> kernel.sched_latency_ns = 65000000
>> kernel.sched_wakeup_granularity_ns = 100000
>> kernel.sched_min_granularity_ns = 100000
>> kernel.sched_migration_cost_ns = 7000000
>>
>> I have tried 3 different kernels, including one compiled myself, but
>> the results are the same
>> Kernels I tried were: 3.11.10, 3.12 and 3.16.4 (self-compiled)
>>
>> My system specs are as follows
>>
>> CPU: AMD FX-8350 @ 4GHz
>> RAM: 16GB DDR1333
>> GPU: NVIDIA GTX 560 with NV blob driver
>> HDD: Seagate Constellation ES.3 128MB cache
>> Desktop: KDE 4.11
>>
> Are you using a kernel with CONFIG_PREEMPT=y?  I've personally found that
> that can help hugely with UI sluggishness (and also tends to get better
> results when doing stuff like live video capture), although to get this you
> may need to build the kernel yourself.  Also, I would suggest trying the
> deadline I/O scheduler; I've found it provides much better latency than CFQ
> for most workloads, and you almost certainly don't need I/O priorities.
> I've actually got a similar setup (FX-8320 @ 4GHz, 16GB DDR3-1600, High-end
> storage, and a Radeon R7-240 GPU), and had similar issues when doing
> processing of big (>500MB) images in GIMP, and using a CONFIG_PREEMPT
> enabled kernel and the deadline I/O scheduler has pretty much resolved all
> of these issues.
>
> Additionally, try with KDE's 'semantic desktop' functionality turned off,
> this eats a huge amount of disk and memory bandwidth, and can easily bring a
> system to it's knees.  Furthermore, unless you can reproduce things using
> nouevau instead of the NV driver, you're not as likely to get a lot of help.
>
>

Hi,

Yes, PREEMP is enabled and the I/O scheduler used is BFQ. But the
problem existed regardless of the I/O scheduler

I've followed the suggestions of Mike and set the CFS values a little
bit lower than their standard ones and it appears to have improved.
There is sometimes a very small delay while opening something, but I
guess this is from the heavy load. I also turned off the KDE effects
and it's much more snappy now but I turned a few back on as I like the
animations of opening/closing windows :P

I have not tested the nouveau driver as I need VDPAU here. Also
updated the NV blob to latest version and it seems to improve a bit.
In the changelog it was mentioned that there was a fix

"Fixed an OpenGL issue that could cause glReadPixels() operations to
be improperly clipped when resizing composited application windows,
potentially leading to momentary X freezes."

I do not have KDE's semantic stuff enabled here as it's useless for me

This is the vmstat output. I have no idea what it means

procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
10  0      0 10298064    428 2873036    0    0   648   542  144  140
90  1  8  1  0
11  0      0 10295352    428 2874160    0    0  1024     0 9498 6792
88  1 12  0  0
10  0      0 10290824    428 2879140    0    0  3212  1540 9366 6305
89  1 10  0  0
10  0      0 10288868    428 2880944    0    0   896     0 8826 6037
89  1 10  0  0
 9  0      0 10286796    428 2883188    0    0  1920   172 8635 5447
89  1 10  0  0
12  0      0 10284848    428 2885508    0    0   896  1684 9162 6119
88  1 11  0  0
11  0      0 10280436    428 2888896    0    0  2560     0 8702 6206
86  2 12  0  0
12  0      0 10279448    428 2889744    0    0   640     0 8757 5915
91  1  8  0  0
10  0      0 10276564    428 2892480    0    0  1920  4168 8649 5471
88  1 11  0  0

-- 
Yours truly
