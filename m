Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaE0Rgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:36:44 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:58309 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaE0Rgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:36:41 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 27 May 2014 13:40:45 -0400 (EDT)
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: perf: fuzzer getting stuck with slow memory leak
Message-ID: <alpine.DEB.2.10.1405271327470.1839@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, now that the various fixes made it in, I'm running the perf_fuzzer on 
3.15-rc7.

On my core2 machine I found a random seed that reliably reproduces the 
"fuzzer gets stuck, burning 100% CPU" issue.

I'm having a hard time figuring out what is happening, though I did manage 
to get a ftrace of it.

Not a useful trace though, due to the dreaded EVENTS_DROPPED 
happening right when things would be interesting.

CPU:0 [148307 EVENTS DROPPED]
     perf_fuzzer-2940  [000]   396.172211: kmalloc:              (T.1267+0xe) call_site=ffffffff810d027d ptr=0xffff8800be516b00 bytes_req=216 bytes_alloc=256 gfp_flags=GFP_KERNEL|GFP_ZERO
     perf_fuzzer-2940  [000]   396.172211: function:             perf_lock_task_context
     perf_fuzzer-2940  [000]   396.172211: function:             alloc_perf_context

Anyway it's repeating the above 3 lines forever while possibly leaking 256 
bytes of memory each time it does so.

I can't seem to find the codepath that would cause it to get stuck here.

If I force a stack dump it looks like this:

[10229.956005] task: ffff8800ca2c3000 ti: ffff8800c53fc000 task.ti: ffff8800c53fc000
[10229.956005] RIP: 0010:[<ffffffff8111160b>]  [<ffffffff8111160b>] ____cache_alloc+0x50/0x29d
[10229.956005] RSP: 0018:ffff8800c53fdd18  EFLAGS: 00000006
[10229.956005] RAX: ffff8800c7108c00 RBX: ffff88011f000400 RCX: ffff88011a156180
[10229.956005] RDX: 0000000080000000 RSI: ffff88011b38ac00 RDI: ffff88011f000400
[10229.956005] RBP: ffff8800c53fdd78 R08: 00000000000080d0 R09: ffff8800ca2c3000
[10229.956005] R10: ffff8800ca2c3000 R11: 0000000000000013 R12: ffff88011f000400
[10229.956005] R13: 0000000000000000 R14: 00000000000080d0 R15: 00000000000080d0
[10229.956005] FS:  00007fa9b7107700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[10229.956005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[10229.956005] CR2: 00007f9042256fc9 CR3: 00000000c4a30000 CR4: 00000000000407e0
[10229.956005] DR0: 0000000002546000 DR1: 0000000002341000 DR2: 0000000002837000
[10229.956005] DR3: 000000000262f000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[10229.956005] Stack:
[10229.956005]  ffffea0002b8b9c0 ffff88011f002358 ffff88011f002348 ffffffff0000002c
[10229.956005]  ffff88011f002368 000080d0810d027d ffff880100000001 ffff88011f000400
[10229.956005]  00000000000000d8 ffff88011f000400 00000000000080d0 00000000000080d0
[10229.956005] Call Trace:
[10229.956005]  [<ffffffff81112657>] __kmalloc+0x8a/0xed
[10229.956005]  [<ffffffff810d027d>] ? T.1265+0xe/0x10
[10229.956005]  [<ffffffff810d027d>] T.1265+0xe/0x10
[10229.956005]  [<ffffffff810d07b9>] alloc_perf_context+0x20/0x95
[10229.956005]  [<ffffffff810d095e>] find_get_context+0x130/0x1bf
[10229.956005]  [<ffffffff810d0eea>] SYSC_perf_event_open+0x42b/0x808
[10229.956005]  [<ffffffff810d12d5>] SyS_perf_event_open+0xe/0x10
[10229.956005]  [<ffffffff81543466>] system_call_fastpath+0x1a/0x1f
[10229.956005] Code: 8b b4 c7 80 00 00 00 83 3e 00 74 2b c7 46 0c 01 00 00 00 8b
 05 87 bf b8 00 85 c0 0f 8e 36 02 00 00 8b 55 cc 31 c9 e8 b6 ed ff ff <48> 85 c0 0f 85 14 02 00 00 41 b5 01 65 44 8b 34 25 b8 ee 00 00 

