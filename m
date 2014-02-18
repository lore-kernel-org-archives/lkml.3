Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbaBRKTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:19:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52559 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbaBRKTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:19:09 -0500
Date: Tue, 18 Feb 2014 10:18:31 +0000
From: Will Deacon <will.deacon@arm.com>
To: Drew Richardson <drew.richardson@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Arnaldo <acme@redhat.com>,
        Pawel Moll <Pawel.Moll@arm.com>, Wade Cherry <Wade.Cherry@arm.com>
Subject: Re: Perf Oops on 3.14-rc2
Message-ID: <20140218101831.GB4178@mudshark.cambridge.arm.com>
References: <20140210221758.GB11542@dreric01-Precision-T1600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210221758.GB11542@dreric01-Precision-T1600>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 10:17:59PM +0000, Drew Richardson wrote:
> While adding CPU on/offlining support during perf captures I get an
> Oops both on ARM as well as my desktop x86_64. Below is a small
> program that duplicates the issue.

[...]

FWIW I can reproduce this easily with -rc3 on my x86 laptop running
hackbench in parallel with a tweaked version of your test (using
_SC_NPROCESSORS_ONLN instead of _SC_NPROCESSORS_CONF and hotplugging off
both CPU2 and CPU3).

I've included part of the log below, but I also saw a WARN which I
unfortunately only managed to get a photo of.

  http://www.willdeacon.ukfsn.org/bitbucket/oopsen/x86/

Will

--->8

BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
IP: [<ffffffff811195fe>] perf_event_aux_ctx+0x4e/0x80
PGD 0
Oops: 0000 [#1608] SMP
Modules linked in:
CPU: 1 PID: 2270 Comm: hackbench Tainted: G      D W    3.14.0-rc3 #2
Hardware name: System76, Inc. Lemur Ultra/Lemur Ultra, BIOS 4.6.4 10/07/2011
task: ffff8800d1ec6180 ti: ffff8800d1fb4000 task.ti: ffff8800d1fb4000
RIP: 0010:[<ffffffff811195fe>]  [<ffffffff811195fe>] perf_event_aux_ctx+0x4e/0x80
RSP: 0018:ffff8800d1fb5d98  EFLAGS: 00010207
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000000fffd8
RDX: 0000000000000001 RSI: 00000000000fffd8 RDI: ffff8800d1fb5c98
RBP: ffff88021fa55e60 R08: 00000000000fffd8 R09: 00000000df1aa3e9
R10: ffffffff8108790e R11: ffffea000347dec0 R12: ffff8800d1fb5e18
R13: ffffffff8111f580 R14: ffff8800d1fb5e18 R15: ffff8800d1ec6180
FS:  0000000000000000(0000) GS:ffff88021fa40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000078 CR3: 0000000001ad5000 CR4: 00000000000407e0
Stack:
 00007f8618b68cc0 0000000000000000 ffff8800d1ec6180 ffffffff81ae17e0
 0000000000000000 ffffffff8111f580 ffff8800d1ec6180 ffffffff811196cb
 0000000000000064 ffffffff81ae17e0 0000000000000004 0000000000000000
Call Trace:
 [<ffffffff8111f580>] ? perf_event_task_tick+0xe0/0xe0
 [<ffffffff811196cb>] ? perf_event_aux+0x9b/0xd0
 [<ffffffff81119e48>] ? perf_event_task+0x78/0xa0
 [<ffffffff81122c80>] ? perf_event_exit_task+0xb0/0x200
 [<ffffffff81087928>] ? do_exit+0x2b8/0xa00
 [<ffffffff8117798c>] ? vfs_write+0x17c/0x1e0
 [<ffffffff81088178>] ? do_group_exit+0x38/0xa0
 [<ffffffff810881f2>] ? SyS_exit_group+0x12/0x20
 [<ffffffff817be922>] ? system_call_fastpath+0x16/0x1b
Code: 39 eb 75 27 eb 47 0f 1f 80 00 00 00 00 65 8b 14 25 1c b0 00 00 39 d0 74 26 48 8b 03 48 89 44 24 08 48 8b 5c 24 08 48 39 eb 74 22 <44> 8b 4b 78 45 85 c9 78 e5 8b 83 3c 02 00 00 83 f8 ff 75 ce 4c 
RIP  [<ffffffff811195fe>] perf_event_aux_ctx+0x4e/0x80
 RSP <ffff8800d1fb5d98>
CR2: 0000000000000078
---[ end trace 0e9345db7c92edc0 ]---
Fixing recursive fault but reboot is needed!
