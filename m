Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3LRE2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 23:28:49 -0500
Received: from relay3.sgi.com ([192.48.152.1]:45479 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752714Ab3LRE2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 23:28:36 -0500
Date: Wed, 18 Dec 2013 04:28:35 +0000
From: Hedi Berriche <hedi@sgi.com>
To: linux-kernel@vger.kernel.org, peterz@infradead.org,
        srikar@linux.vnet.ibm.com
Subject: Re: [Regression] sched: division by zero in find_busiest_group()
Message-ID: <20131218042835.GA6771@dangermouse.emea.sgi.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, peterz@infradead.org,
	srikar@linux.vnet.ibm.com
References: <20131209181042.GA6771@dangermouse.emea.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131209181042.GA6771@dangermouse.emea.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 18:10 Hedi Berriche wrote:
| Folks,
| 
| The following panic occurs *early* at boot time on high *enough* CPU count
| machines:
| 
| divide error: 0000 [#1] SMP 
| Modules linked in:
| CPU: 22 PID: 1146 Comm: kworker/22:0 Not tainted 3.13.0-rc2-00122-gdea4f48 #8
| Hardware name: Intel Corp. Stoutland Platform, BIOS 2.20 UEFI2.10 PI1.0 X64 2013-09-20
| task: ffff8827d49f31c0 ti: ffff8827d4a18000 task.ti: ffff8827d4a18000
| RIP: 0010:[<ffffffff810a345b>]  [<ffffffff810a345b>] find_busiest_group+0x26b/0x890
| RSP: 0000:ffff8827d4a19b68  EFLAGS: 00010006
| RAX: 0000000000007fff RBX: 0000000000008000 RCX: 0000000000000200
| RDX: 0000000000000000 RSI: 0000000000008000 RDI: 0000000000000020
| RBP: ffff8827d4a19cc0 R08: 0000000000000000 R09: 0000000000000000
| R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
| R13: ffff8827d4a19d28 R14: ffff8827d4a19b98 R15: 0000000000000000
| FS:  0000000000000000(0000) GS:ffff8827dfd80000(0000) knlGS:0000000000000000
| CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
| CR2: 00000000000000b8 CR3: 00000000018da000 CR4: 00000000000007e0
| Stack:
| ffff8827d4b35800 0000000000000000 0000000000014600 0000000000014600
| 0000000000000000 ffff8827d4b35818 0000000000000000 0000000000000000
| 0000000000000000 0000000000000000 0000000000008000 0000000000000000
| Call Trace:
| [<ffffffff810a3be6>] load_balance+0x166/0x7f0
| [<ffffffff810a477e>] idle_balance+0x10e/0x1b0
| [<ffffffff815d83d3>] __schedule+0x723/0x780
| [<ffffffff815d8459>] schedule+0x29/0x70
| [<ffffffff810818b9>] worker_thread+0x1c9/0x400
| [<ffffffff810816f0>] ? rescuer_thread+0x3e0/0x3e0
| [<ffffffff81088562>] kthread+0xd2/0xf0
| [<ffffffff81088490>] ? kthread_create_on_node+0x180/0x180
| [<ffffffff815e437c>] ret_from_fork+0x7c/0xb0
| [<ffffffff81088490>] ? kthread_create_on_node+0x180/0x180

Hmm...had time to dig into this a bit deeper and looking at
build_overlap_sched_groups(), specifically this bit of code:

kernel/sched/core.c:

5066 static int
5067 build_overlap_sched_groups(struct sched_domain *sd, int cpu)
5068 {
...
5109                 /*
5110                  * Initialize sgp->power such that even if we mess up the
5111                  * domains and no possible iteration will get us here, we won't
5112                  * die on a /0 trap.
5113                  */
5114                 sg->sgp->power = SCHED_POWER_SCALE * cpumask_weight(sg_span);

I'm wondering whether the same precaution should be used when it comes to sg->sgp->power_orig.

Cheers,
Hedi.
