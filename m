Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaG1XI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 19:08:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32028 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaG1XI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 19:08:56 -0400
Message-ID: <53D6D7E5.8090906@oracle.com>
Date: Mon, 28 Jul 2014 19:08:21 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
References: <53B98709.3090603@oracle.com> <20140707083016.GA19379@twins.programming.kicks-ass.net> <53BAA6DF.5060409@oracle.com> <20140707200550.GA6758@twins.programming.kicks-ass.net> <53BB2392.20404@oracle.com>
In-Reply-To: <53BB2392.20404@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 06:47 PM, Sasha Levin wrote:
> On 07/07/2014 04:05 PM, Peter Zijlstra wrote:
>> > On Mon, Jul 07, 2014 at 09:55:43AM -0400, Sasha Levin wrote:
>>> >> I've also had this one, which looks similar:
>>> >> 
>>> >> [10375.005884] BUG: spinlock recursion on CPU#0, modprobe/10965 [10375.006573]  lock: 0xffff8803a0fd7740, .magic: dead4ead, .owner: modprobe/10965, .owner_cpu: 15 [10375.007412] CPU: 0 PID: 10965 Comm: modprobe Tainted: G        W      3.16.0-rc3-next-20140704-sasha-00023-g26c0906-dirty #765
>> > 
>> > Something's fucked; so we have:
>> > 
>> > debug_spin_lock_before() SPIN_BUG_ON(lock->owner == current, "recursion");
>> > 
>> > Causing that, _HOWEVER_ look at .owner_cpu and the reporting cpu!! How can the lock owner, own the lock on cpu 15 and again contend with it on CPU 0. That's impossible.
>> > 
>> > About when-ish did you start seeing things like this? Lemme go stare hard at recent changes.
>> > 
> ~next-20140704 I guess, about when I reported the original issue.

Just wanted to add that this is still going on in -next:

[  860.050433] BUG: spinlock recursion on CPU#33, trinity-subchil/21438
[  860.051572]  lock: 0xffff8805fee10080, .magic: dead4ead, .owner: trinity-subchil/21438, .owner_cpu: -1
[  860.052943] CPU: 33 PID: 21438 Comm: trinity-subchil Not tainted 3.16.0-rc7-next-20140728-sasha-00029-ge067ff9 #976
[  860.053998]  ffff8805fee10080 ffff8805fe72bab0 ffffffffad464226 ffff8805ba163000
[  860.054820]  ffff8805fe72bad0 ffffffffaa1d7e76 ffff8805fee10080 ffffffffae88d599
[  860.055641]  ffff8805fe72baf0 ffffffffaa1d7ef6 ffff8805fee10080 ffff8805fee10080
[  860.056485] Call Trace:
[  860.056818]  [<ffffffffad464226>] dump_stack+0x4e/0x7a
[  860.057788]  [<ffffffffaa1d7e76>] spin_dump+0x86/0xe0
[  860.058620]  [<ffffffffaa1d7ef6>] spin_bug+0x26/0x30
[  860.059487]  [<ffffffffaa1d80bf>] do_raw_spin_lock+0x14f/0x1b0
[  860.060318]  [<ffffffffad4a9f01>] _raw_spin_lock+0x61/0x80
[  860.060318]  [<ffffffffaa1b4832>] ? load_balance+0x3a2/0xa50
[  860.060318]  [<ffffffffaa1b4832>] load_balance+0x3a2/0xa50
[  860.060318]  [<ffffffffaa1b541f>] pick_next_task_fair+0x53f/0xb00
[  860.060318]  [<ffffffffaa1b5300>] ? pick_next_task_fair+0x420/0xb00
[  860.060318]  [<ffffffffad4a89ab>] __schedule+0x16b/0x8c0
[  860.060318]  [<ffffffffaa2dbf18>] ? unlink_file_vma+0x38/0x60
[  860.060318]  [<ffffffffaa1a1903>] schedule_preempt_disabled+0x33/0x80
[  860.060318]  [<ffffffffaa1c633e>] mutex_lock_nested+0x1ae/0x620
[  860.060318]  [<ffffffffaa2dbf18>] ? unlink_file_vma+0x38/0x60
[  860.060318]  [<ffffffffaa2dbf18>] unlink_file_vma+0x38/0x60
[  860.060318]  [<ffffffffaa2d2b70>] free_pgtables+0xb0/0x130
[  860.060318]  [<ffffffffaa2df0d4>] exit_mmap+0xc4/0x180
[  860.060318]  [<ffffffffaa168aa3>] mmput+0x73/0x110
[  860.060318]  [<ffffffffaa16fa9a>] do_exit+0x2ca/0xc80
[  860.060318]  [<ffffffffaa1cecdb>] ? trace_hardirqs_on_caller+0xfb/0x280
[  860.060318]  [<ffffffffaa1cee6d>] ? trace_hardirqs_on+0xd/0x10
[  860.060318]  [<ffffffffaa1704de>] do_group_exit+0x4e/0xe0
[  860.060318]  [<ffffffffaa170584>] SyS_exit_group+0x14/0x20
[  860.060318]  [<ffffffffad4ab593>] tracesys+0xe1/0xe6


Thanks,
Sasha
