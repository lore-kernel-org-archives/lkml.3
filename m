Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3EPTcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 15:32:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab3EPTcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 15:32:11 -0400
Date: Thu, 16 May 2013 22:31:37 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Richter <rric@kernel.org>
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130516193137.GI14597@redhat.com>
References: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
 <20130516175117.GK19669@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516175117.GK19669@dyad.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 07:51:17PM +0200, Peter Zijlstra wrote:
> On Thu, May 16, 2013 at 11:10:26AM -0400, Josh Boyer wrote:
> > Hi All,
> > 
> > If you boot a KVM guest on an AMD family 15h and specify -cpu host,
> > you'll get the following splat:
> > 
> > [    0.031000] ------------[ cut here ]------------
> > [    0.031000] WARNING: at arch/x86/kernel/cpu/perf_event_amd.c:772
> > amd_pmu_init+0x18c/0x249()
> > [    0.031000] Hardware name: Bochs
> > [    0.031000] Odd, counter constraints enabled but no core perfctrs
> > detected!
> > [    0.031000] Modules linked in:
> > 
> > [    0.031000] Pid: 1, comm: swapper/0 Not tainted
> > 3.9.0-0.rc1.git0.4.fc19.x86_64 #1
> > [    0.031000] Call Trace:
> > [    0.031000]  [<ffffffff81d10c67>] ? amd_pmu_init+0x18c/0x249
> > [    0.031000]  [<ffffffff8105c9a0>] warn_slowpath_common+0x70/0xa0
> > [    0.031000]  [<ffffffff81d106b3>] ? check_bugs+0x2d/0x2d
> > [    0.031000]  [<ffffffff8105ca1c>] warn_slowpath_fmt+0x4c/0x50
> > [    0.031000]  [<ffffffff81d10c67>] amd_pmu_init+0x18c/0x249
> > [    0.031000]  [<ffffffff81d106e7>] init_hw_perf_events+0x34/0x428
> > [    0.031000]  [<ffffffff81d106b3>] ? check_bugs+0x2d/0x2d
> > [    0.031000]  [<ffffffff8100210a>] do_one_initcall+0x10a/0x160
> > [    0.031000]  [<ffffffff81d06fa5>] kernel_init_freeable+0xcf/0x1fa
> > [    0.031000]  [<ffffffff81629800>] ? rest_init+0x80/0x80
> > [    0.031000]  [<ffffffff8162980e>] kernel_init+0xe/0x190
> > [    0.031000]  [<ffffffff8164e22c>] ret_from_fork+0x7c/0xb0
> > [    0.031000]  [<ffffffff81629800>] ? rest_init+0x80/0x80
> > [    0.031000] ---[ end trace a1e57d3cb8668105 ]---
> > 
> > That seems a bit excessive, and it gets picked up by auto-reporting
> > tools like ABRT as a bug.  Can we remove the WARN and just use pr_err or
> > something else instead?
> 
> Robert put that in, I suppose its because the CPUID crap indicates its got perf
> counters but then it doesn't actually have them.
> 
Actually it looks like it is the opposite: CPUID crap indicates
it got no perf, but the code expects this cpu model to have it.

> Clearly this is something that should be fixed in your virt thingy instead.
The only way to fix it is to implement perf virtualization for AMD, but
then it is odd for a guest to try and match CPUIDs with CPU model. This
defeats the purpose of CPUIDs in the first place.

--
			Gleb.
