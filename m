Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab3BRASF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 19:18:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39843 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab3BRASD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 19:18:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, serge.hallyn@canonical.com,
        Dave Jones <davej@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <512117D5.3050602@oracle.com>
Date: Sun, 17 Feb 2013 16:17:53 -0800
In-Reply-To: <512117D5.3050602@oracle.com> (Sasha Levin's message of "Sun, 17
	Feb 2013 12:48:05 -0500")
Message-ID: <87ppzyqxu6.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/qwk8iv2kvad+qybpx/oI6Rehg9HZo7d4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <sasha.levin@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: BUG in find_pid_ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding Oleg since he knows about as much about signals and pids as
anyone.

Sasha Levin <sasha.levin@oracle.com> writes:

> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest, running latest -next kernel,
> I've stumbled on the following spew:

To my knowledge there are no in progress patches to this area of the kernel
and nothing has changed in quite a while.

The bad pointer value is 0xfffffffffffffff0.  Hmm.

If you have the failure location correct it looks like a corrupted hash
entry was found while following the hash chain.

It looks like the memory has been set to -16 -EBUSY? Weird.

It smells like something is stomping on the memory of a struct pid, with
the same hash value and thus in the same hash chain as the current pid.

Can you reproduce this?

Memory corruption is hard to trace down with just a single data point.

Looking a little closer Sasha you have rewritten
hlist_for_each_entry_rcu, and that seems to be the most recent patch
dealing with pids, and we are failing in hlist_for_each_entry_rcu.

I haven't looked at your patch in enough detail to know if you have
missed something or not, but a brand new patch and a brand new failure
certainly look suspicious at first glance.

Eric


> [  400.345287] BUG: unable to handle kernel paging request at fffffffffffffff0
> [  400.346614] IP: [<ffffffff81131d50>] find_pid_ns+0x110/0x1f0
> [  400.347649] PGD 5429067 PUD 542b067 PMD 0
> [  400.348459] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  400.351166] Dumping ftrace buffer:
> [  400.352884]    (ftrace buffer empty)
> [  400.354640] Modules linked in:
> [  400.355021] CPU 1
> [  400.355021] Pid: 6890, comm: trinity Tainted: G        W    3.8.0-rc7-next-20130215-sasha-00027-gb399f44-dirty #288
> [  400.355021] RIP: 0010:[<ffffffff81131d50>]  [<ffffffff81131d50>] find_pid_ns+0x110/0x1f0
> [  400.375245] RSP: 0018:ffff8800aedb5e18  EFLAGS: 00010286
> [  400.380086] RAX: 0000000000000001 RBX: 0000000000007e7d RCX: 0000000000000000
> [  400.383643] RDX: 0000000000000001 RSI: ffffffff85466e40 RDI: 0000000000000286
> [  400.383643] RBP: ffff8800aedb5e48 R08: 0000000000000001 R09: 0000000000000001
> [  400.383643] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff85466460
> [  400.383643] R13: ffff8800bf8d3928 R14: fffffffffffffff0 R15: ffff8800a5b7f140
> [  400.383643] FS:  00007faab0ad2700(0000) GS:ffff8800bb800000(0000) knlGS:0000000000000000
> [  400.383643] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  400.383643] CR2: fffffffffffffff0 CR3: 00000000b07a1000 CR4: 00000000000406e0
> [  400.383643] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  400.383643] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  400.383643] Process trinity (pid: 6890, threadinfo ffff8800aedb4000, task ffff8800b0660000)
> [  400.383643] Stack:
> [  400.383643]  ffffffff85466e40 0000000000007e7d ffff8800aedb5ed8 0000000000000000
> [  400.383643]  0000000000000004 20c49ba5e353f7cf ffff8800aedb5e58 ffffffff81131e5c
> [  400.383643]  ffff8800aedb5ec8 ffffffff8112400f ffffffff81123f9c 0000000000000000
> [  400.383643] Call Trace:
> [  400.383643]  [<ffffffff81131e5c>] find_vpid+0x2c/0x30
> [  400.383643]  [<ffffffff81123f9c>] ? kill_something_info+0x2c/0x270
> [  400.383643]  [<ffffffff81125e38>] sys_kill+0x88/0xa0
> [  400.383643]  [<ffffffff8107ad34>] ? syscall_trace_enter+0x24/0x2e0
> [  400.383643]  [<ffffffff811813b8>] ? trace_hardirqs_on_caller+0x128/0x160
> [  400.383643]  [<ffffffff83d96275>] ? tracesys+0x7e/0xe6
> [  400.383643]  [<ffffffff83d962d8>] tracesys+0xe1/0xe6
> [  400.383643] Code: 4d 8b 75 00 e8 b2 0e 00 00 85 c0 0f 84 d2 00 00 00 80 3d fa 17 d5 04 00 0f 85 c5 00 00 00 e9 93 00 00 00 0f
> 1f 84 00 00 00 00 00 <41> 39 1e 75 2b 4d 39 66 08 75 25 41 8b 84 24 20 08 00 00 48 c1
> [  400.383643] RIP  [<ffffffff81131d50>] find_pid_ns+0x110/0x1f0
> [  400.383643]  RSP <ffff8800aedb5e18>
> [  400.383643] CR2: fffffffffffffff0
> [  400.383643] ---[ end trace 5bae629f658bf736 ]---
>
> This points out to:
>
> struct pid *find_pid_ns(int nr, struct pid_namespace *ns)
> {
>         struct upid *pnr;
>
>         hlist_for_each_entry_rcu(pnr,
>                         &pid_hash[pid_hashfn(nr, ns)], pid_chain)
>                 if (pnr->nr == nr && pnr->ns == ns)		<=== here
>                         return container_of(pnr, struct pid,
>                                         numbers[ns->level]);
>
>         return NULL;
> }
>
>
> Thanks,
> Sasha
