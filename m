Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaEIMMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:12:38 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:52739 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaEIMMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:12:37 -0400
Date: Fri, 9 May 2014 20:12:29 +0800
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <axboe@fb.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: blk-mq: WARN at block/blk-mq.c:585 __blk_mq_run_hw_queue
Message-ID: <20140509121229.GB27918@kernel.org>
References: <536A532C.4050001@oracle.com>
 <536A5532.1060008@fb.com>
 <536A56E4.5020909@oracle.com>
 <536A5764.4020606@fb.com>
 <536C49E6.9000503@oracle.com>
 <536C4B2E.4030906@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536C4B2E.4030906@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 09:27:42PM -0600, Jens Axboe wrote:
> On 2014-05-08 21:22, Sasha Levin wrote:
> >On 05/07/2014 11:55 AM, Jens Axboe wrote:
> >>On 05/07/2014 09:53 AM, Sasha Levin wrote:
> >>>On 05/07/2014 11:45 AM, Jens Axboe wrote:
> >>>>On 05/07/2014 09:37 AM, Sasha Levin wrote:
> >>>>>Hi all,
> >>>>>
> >>>>>While fuzzing with trinity inside a KVM tools guest running the latest -next
> >>>>>kernel I've stumbled on the following spew:
> >>>>>
> >>>>>[  986.962569] WARNING: CPU: 41 PID: 41607 at block/blk-mq.c:585 __blk_mq_run_hw_queue+0x90/0x500()
> >>>>
> >>>>I'm going to need more info than this. What were you running? How as kvm
> >>>>invoked (nr cpus)?
> >>>
> >>>Sure!
> >>>
> >>>It's running in a KVM tools guest (not qemu), with the following options:
> >>>
> >>>'--rng --balloon -m 28000 -c 48 -p "numa=fake=32 init=/virt/init zcache ftrace_dump_on_oops debugpat kvm.mmu_audit=1 slub_debug=FZPU rcutorture.rcutorture_runnable=0 loop.max_loop=64 zram.num_devices=4 rcutorture.nreaders=8 oops=panic nr_hugepages=1000 numa_balancing=enable'.
> >>>
> >>>So basically 48 vcpus (the host has 128 physical ones), and ~28G of RAM.
> >>>
> >>>I've been running trinity as a fuzzer, which doesn't handle logging too well,
> >>>so I can't reproduce it's actions easily.
> >>>
> >>>There was an additional stress of hotplugging CPUs and memory during this recent
> >>>fuzzing run, so it's fair to suspect that this happened as a result of that.
> >>
> >>Aha!
> >>
> >>>Anything else that might be helpful?
> >>
> >>No, not too surprising given the info that cpu hotplug was being
> >>stressed at the same time. blk-mq doesn't quiesce when this happens, so
> >>it's very unlikely that there are races between updating the cpu masks
> >>and flushing out the previously queued work.
> >
> >So this warning is something you'd expect when CPUs go up/down?
> 
> Let me put it this way - I'm not surprised that it triggered, but it
> will of course be fixed up.

Does reverting 1eaade629f5c47 change anything?

The ctx->online isn't changed immediately when cpu is offline, likely there are
something wrong. I'm wondering why we need that patch?

Thanks,
Shaohua
