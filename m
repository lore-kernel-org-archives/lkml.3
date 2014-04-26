Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbaDZCDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 22:03:09 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55705 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaDZCDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 22:03:07 -0400
Message-ID: <535B13D7.4050202@kernel.dk>
Date: Fri, 25 Apr 2014 20:03:03 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Alexander Gordeev <agordeev@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
References: <cover.1395840483.git.agordeev@redhat.com>	<20140422071057.GA13195@dhcp-26-169.brq.redhat.com>	<535676A1.3070706@kernel.dk>	<5356916F.4000205@kernel.dk>	<CACVXFVMXh5ZP+ZsO2fV2mdKJrJF9AHg58v5KWmt_ZbEWvszsLw@mail.gmail.com>	<535716A5.6050108@kernel.dk>	<CACVXFVN-roORYH8b-qZ10e2_wrL1W5-xO2P=A_ARPFL2GqDn2Q@mail.gmail.com>	<535AD235.90604@kernel.dk> <CACVXFVPkiQT6yxse=sX1yuX8wLbr1sgbT4chQycbbPDR_A6hqA@mail.gmail.com>
In-Reply-To: <CACVXFVPkiQT6yxse=sX1yuX8wLbr1sgbT4chQycbbPDR_A6hqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-25 18:01, Ming Lei wrote:
> Hi Jens,
>
> On Sat, Apr 26, 2014 at 5:23 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 04/25/2014 03:10 AM, Ming Lei wrote:
>>
>> Sorry, I did run it the other day. It has little to no effect here, but
>> that's mostly because there's so much other crap going on in there. The
>> most effective way to currently make it work better, is just to ensure
>> the caching pool is of a sane size.
>
> Yes, that is just what the patch is doing, :-)

But it's not enough. For instance, my test case, it's 255 tags and 64 
CPUs. We end up in cross-cpu spinlock nightmare mode.

> From percpu_ida view, it is easy to observe it can improve
> allocation performance. I have several patches to export
> these information by sysfs for monitoring percpu_ida
> performance.

Sounds good!

>> I've got an alternative tagging scheme that I think would be useful for
>> the cases where the tag space to cpu ratio isn't big enough. So I think
>> we'll retain percpu_ida for the cases where it can cache enough, and
>> punt to an alternative scheme when not.
>
> OK, care to comment on the patch or the idea of setting percpu cache
> size as (nr_tags / hctx->nr_ctx)?

I think it's a good idea. The problem is that for percpu_ida to be 
effective, you need a bigger cache than the 3 I'd get above. If that 
isn't the case, it performs poorly. I'm just not convinced the design 
can ever work in the realm of realistic queue depths.


>> That doesn't mean we should not improve percpu_ida. There's quite a bit
>> of low hanging fruit in there.
>
> IMO percpu_max_size in percpu_ida is very important for the
> performance, and it might need to adjust dynamically according
> to the percpu allocation loading, but it is far more complicated
> to implement. And it might be the simplest way to fix the parameter
> before percpu_ida_init().

That's what I did, essentially. Ensuring that the percpu_max_size is at 
least 8 makes it a whole lot better here. But still slower than a 
regular simple bitmap, which makes me sad. A fairly straight forward 
cmpxchg based scheme I tested here is around 20% faster than the bitmap 
approach on a basic desktop machine, and around 35% faster on a 
4-socket. Outside of NVMe, I can't think of cases where that approach 
would not be faster than percpu_ida. That means all of SCSI, basically, 
and the basic block drivers.

-- 
Jens Axboe

