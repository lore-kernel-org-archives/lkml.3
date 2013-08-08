Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3HHEJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 00:09:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24303 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3HHEI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 00:08:58 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=ArXVvz0bfDcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=FKR1Mu3PhcYA:10 a=57SyGIRnAAAA:8 a=NufY4J3AAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=6K5P8MV31jpsz9ltaTgA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=re9sYKne76oA:10 a=LI9Vle30uBYA:10 a=cI_eZYRrEW0SSfIP:21 a=fk0-GHuJuJK74cQ5:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375934936.6848.41.camel@gandalf.local.home>
Subject: [BUG] hackbench locks up with perf in 3.11-rc1 and beyond
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameeter <cl@linux.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>
Date: Thu, 08 Aug 2013 00:08:56 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I went to do some benchmarks on the jump label code, and ran:


perf stat -r 100 ./hackbench 50

It ran twice, and then would die with:

[   65.785108] hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_score_adj=0
[   65.792921] hackbench cpuset=/ mems_allowed=0
[   65.797286] CPU: 6 PID: 6042 Comm: hackbench Not tainted 3.11.0-rc4-test+ #26
[   65.804428] Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01 v02.05 05/07/2012
[   65.813392]  0000000000000000 ffff8800105f5478 ffffffff8162024f 000000000000001e
[   65.820876]  ffff8800105f9770 ffff8800105f54f8 ffffffff8161ca6e 0000000000000000
[   65.828365]  0000000000000f48 0000000000000008 ffffffff81c375e0 ffffffff00000000
[   65.835862] Call Trace:
[   65.838317]  [<ffffffff8162024f>] dump_stack+0x46/0x58
[   65.843471]  [<ffffffff8161ca6e>] dump_header+0x7a/0x1be
[   65.848791]  [<ffffffff812ee4c3>] ? ___ratelimit+0x93/0x110
[   65.854373]  [<ffffffff8112f65b>] oom_kill_process+0x1cb/0x330
[   65.860234]  [<ffffffff8112fe20>] out_of_memory+0x470/0x4c0
[   65.865817]  [<ffffffff81135659>] __alloc_pages_nodemask+0xab9/0xad0
[   65.872178]  [<ffffffff812cadf9>] ? blk_recount_segments+0x29/0x40
[   65.878375]  [<ffffffff81173cb3>] alloc_pages_vma+0xa3/0x150
[   65.884048]  [<ffffffff8116786b>] read_swap_cache_async+0x10b/0x190
[   65.890324]  [<ffffffff8116798e>] swapin_readahead+0x9e/0xf0
[   65.895992]  [<ffffffff81154e4f>] handle_pte_fault+0x29f/0xa60
[   65.901832]  [<ffffffff81124cda>] ? __perf_sw_event+0x16a/0x190
[   65.907761]  [<ffffffff81124cda>] ? __perf_sw_event+0x16a/0x190
[   65.913689]  [<ffffffff8108d5be>] ? update_curr+0x1ee/0x200
[   65.919269]  [<ffffffff811567d6>] handle_mm_fault+0x256/0x5d0
[   65.925027]  [<ffffffff8162aa02>] __do_page_fault+0x182/0x4c0
[   65.930787]  [<ffffffff81122b56>] ? __perf_event_task_sched_in+0x196/0x1b0
[   65.937670]  [<ffffffff810819f8>] ? finish_task_switch+0xa8/0xe0
[   65.943684]  [<ffffffff81624bef>] ? __schedule+0x3bf/0x7f0
[   65.949177]  [<ffffffff8162ad4e>] do_page_fault+0xe/0x10
[   65.954495]  [<ffffffff816273f2>] page_fault+0x22/0x30
[   65.959641]  [<ffffffff812f4a09>] ? copy_user_enhanced_fast_string+0x9/0x20
[   65.966611]  [<ffffffff812fa2d7>] ? memcpy_toiovec+0x47/0x80
[   65.972286]  [<ffffffff815c81c7>] unix_stream_recvmsg+0x4e7/0x8d0
[   65.978392]  [<ffffffff81077460>] ? remove_wait_queue+0x50/0x50
[   65.984321]  [<ffffffff81512076>] sock_aio_read.part.11+0x156/0x170
[   65.990596]  [<ffffffff81124cda>] ? __perf_sw_event+0x16a/0x190
[   65.996522]  [<ffffffff815120b3>] sock_aio_read+0x23/0x30
[   66.001930]  [<ffffffff8119407a>] do_sync_read+0x7a/0xb0
[   66.007254]  [<ffffffff8119509d>] vfs_read+0x16d/0x180
[   66.012398]  [<ffffffff81195262>] SyS_read+0x52/0xa0
[   66.017369]  [<ffffffff810d6dd0>] ? __audit_syscall_exit+0x200/0x280
[   66.023728]  [<ffffffff8162f482>] system_call_fastpath+0x16/0x1b

As it always ran hackbench twice and then crashed, I changed the test to be just:

perf stat -r 10 ./hackbench 50

And kicked off ktest.pl to do the bisect. It came up with this commit as
the culprit:

commit 318df36e57c0ca9f2146660d41ff28e8650af423
Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date:   Wed Jun 19 15:33:55 2013 +0900

    slub: do not put a slab to cpu partial list when cpu_partial is 0
    
    In free path, we don't check number of cpu_partial, so one slab can
    be linked in cpu partial list even if cpu_partial is 0. To prevent
this,
    we should check number of cpu_partial in put_cpu_partial().
    
    Acked-by: Christoph Lameeter <cl@linux.com>
    Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
    Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
    Signed-off-by: Pekka Enberg <penberg@kernel.org>


I reverted the commit, and sure enough, perf now can run hackbench for
all the runs I specify.

-- Steve


