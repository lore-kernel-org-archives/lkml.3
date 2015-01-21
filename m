Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbbAUNXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:23:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbbAUNXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:23:10 -0500
Date: Wed, 21 Jan 2015 14:23:08 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: mmotm:
 mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch is
 causing preemptible splats
Message-ID: <20150121132308.GB23700@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am getting tons of splats like this:
[  187.593291] BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u4:1/24
[  187.593293] caller is debug_smp_processor_id+0x17/0x19
[  187.599127] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[  187.601997]  ffffffff8181786e ffff8800068a3d78 ffffffff8151a4b8 ffffffff81078e0e
[  187.604373]  0000000000000000 ffff8800068a3da8 ffffffff81280ac0 ffff8800068acac8
[  187.606619]  00000000000029b2 ffff880007401500 00000000000000d0 ffff8800068a3db8
[  187.608869] Call Trace:
[  187.609602]  [<ffffffff8151a4b8>] dump_stack+0x4f/0x7c
[  187.615881]  [<ffffffff81078e0e>] ? down_trylock+0x2d/0x37
[  187.617468]  [<ffffffff81280ac0>] check_preemption_disabled+0xe7/0xf9
[  187.619295]  [<ffffffff81280ae9>] debug_smp_processor_id+0x17/0x19
[  187.621055]  [<ffffffff8113b2f6>] kmem_cache_alloc_trace+0x78/0x22e
[  187.622854]  [<ffffffff81088d36>] ? do_syslog+0xb2/0x452
[  187.624376]  [<ffffffff81088d36>] do_syslog+0xb2/0x452
[  187.626030]  [<ffffffff811675b4>] ? __fdget_pos+0x3d/0x43
[  187.627557]  [<ffffffff810745ac>] ? wait_woken+0x5d/0x5d
[  187.629073]  [<ffffffff811675b4>] ? __fdget_pos+0x3d/0x43
[  187.630611]  [<ffffffff811a787b>] kmsg_read+0x2d/0x54
[  187.632069]  [<ffffffff8119c4ff>] proc_reg_read+0x4a/0x6c
[  187.633775]  [<ffffffff8114e4d8>] vfs_read+0xa5/0x141
[  187.635242]  [<ffffffff8114ee35>] SyS_read+0x51/0x8f
[  187.636666]  [<ffffffff81522892>] system_call_fastpath+0x12/0x17

$ grep "BUG: using smp_processor_id" mmap.qcow_serial.log | wc -l
660
after few minutes of runtime when running the current mmotm tree 
(https://git.kernel.org/cgit/linux/kernel/git/mhocko/mm.git/log/?h=since-3.18).

The warning seems to come from this_cpu_ptr which is using my_cpu_offset
which is
#define my_cpu_offset per_cpu_offset(smp_processor_id())
if CONFIG_DEBUG_PREEMPT

So it matches the following code in slab_alloc_node resp. slab_free:
        do {
                tid = this_cpu_read(s->cpu_slab->tid);
                c = this_cpu_ptr(s->cpu_slab); <<< HERE
        } while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));

This is with:
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_DEBUG_PREEMPT=y

I am not sure how to fix this but it sounds like this_cpu_ptr should
offer the same preempt expectations as other this_cpu_* functions.
-- 
Michal Hocko
SUSE Labs
