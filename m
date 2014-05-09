Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbaEIQFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:05:03 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:60047 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbaEIQFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:05:00 -0400
Date: Fri, 9 May 2014 12:04:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [REGRESSION] funny sched_domain build failure during resume
Message-ID: <20140509160455.GA4486@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

So, after resuming from suspend, I found my build jobs can not migrate
away from the CPU it started on and thus just making use of single
core.  It turns out the scheduler failed to build sched domains due to
order-3 allocation failure.

 systemd-sleep: page allocation failure: order:3, mode:0x104010
 CPU: 0 PID: 11648 Comm: systemd-sleep Not tainted 3.14.2-200.fc20.x86_64 #1
 Hardware name: System manufacturer System Product Name/P8Z68-V LX, BIOS 4105 07/01/2013
  0000000000000000 000000001bc36890 ffff88009c2d5958 ffffffff816eec92
  0000000000104010 ffff88009c2d59e8 ffffffff8117a32a 0000000000000000
  ffff88021efe6b00 0000000000000003 0000000000104010 ffff88009c2d59e8
 Call Trace:
  [<ffffffff816eec92>] dump_stack+0x45/0x56
  [<ffffffff8117a32a>] warn_alloc_failed+0xfa/0x170
  [<ffffffff8117e8f5>] __alloc_pages_nodemask+0x8e5/0xb00
  [<ffffffff811c0ce3>] alloc_pages_current+0xa3/0x170
  [<ffffffff811796a4>] __get_free_pages+0x14/0x50
  [<ffffffff8119823e>] kmalloc_order_trace+0x2e/0xa0
  [<ffffffff810c033f>] build_sched_domains+0x1ff/0xcc0
  [<ffffffff810c123e>] partition_sched_domains+0x35e/0x3d0
  [<ffffffff811168e7>] cpuset_update_active_cpus+0x17/0x40
  [<ffffffff810c130a>] cpuset_cpu_active+0x5a/0x70
  [<ffffffff816f9f4c>] notifier_call_chain+0x4c/0x70
  [<ffffffff810b2a1e>] __raw_notifier_call_chain+0xe/0x10
  [<ffffffff8108a413>] cpu_notify+0x23/0x50
  [<ffffffff8108a678>] _cpu_up+0x188/0x1a0
  [<ffffffff816e1783>] enable_nonboot_cpus+0x93/0xf0
  [<ffffffff810d9d45>] suspend_devices_and_enter+0x325/0x450
  [<ffffffff810d9fe8>] pm_suspend+0x178/0x260
  [<ffffffff810d8e79>] state_store+0x79/0xf0
  [<ffffffff81355bdf>] kobj_attr_store+0xf/0x20
  [<ffffffff81262c4d>] sysfs_kf_write+0x3d/0x50
  [<ffffffff81266b12>] kernfs_fop_write+0xd2/0x140
  [<ffffffff811e964a>] vfs_write+0xba/0x1e0
  [<ffffffff811ea0a5>] SyS_write+0x55/0xd0
  [<ffffffff816ff029>] system_call_fastpath+0x16/0x1b

The allocation is from alloc_rootdomain().

	struct root_domain *rd;

	rd = kmalloc(sizeof(*rd), GFP_KERNEL);

The thing is the system has plenty of reclaimable memory and shouldn't
have any trouble satisfying one GFP_KERNEL order-3 allocation;
however, the problem is that this is during resume and the devices
haven't been woken up yet, so pm_restrict_gfp_mask() punches out
GFP_IOFS from all allocation masks and the page allocator has just
__GFP_WAIT to work with and, with enough bad luck, fails expectedly.

The problem has always been there but seems to have been exposed by
the addition of deadline scheduler support, which added cpudl to
root_domain making it larger by around 20k bytes on my setup, making
an order-3 allocation necessary during CPU online.

It looks like the allocation is for a temp buffer and there are also
percpu allocations going on.  Maybe just allocate the buffers on boot
and keep them around?

Kudos to Johannes for helping deciphering mm debug messages.

Thanks.

-- 
tejun
