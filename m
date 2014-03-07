Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaCGBEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:04:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27005 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaCGBET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:04:19 -0500
Message-ID: <53191B05.20102@oracle.com>
Date: Thu, 06 Mar 2014 20:04:05 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, mgorman@suse.de,
        hhuang@redhat.com, knoel@redhat.com, aarcange@redhat.com
Subject: Re: [PATCH -mm] mm,numa,mprotect: always continue after finding a
 stable thp page
References: <5318E4BC.50301@oracle.com> <20140306173137.6a23a0b2@cuia.bos.redhat.com>
In-Reply-To: <20140306173137.6a23a0b2@cuia.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 05:31 PM, Rik van Riel wrote:
> On Thu, 06 Mar 2014 16:12:28 -0500
> Sasha Levin<sasha.levin@oracle.com>  wrote:
>
>> >While fuzzing with trinity inside a KVM tools guest running latest -next kernel I've hit the
>> >following spew. This seems to be introduced by your patch "mm,numa: reorganize change_pmd_range()".
> That patch should not introduce any functional changes, except for
> the VM_BUG_ON that catches the fact that we fell through to the 4kB
> pte handling code, despite having just handled a THP pmd...
>
> Does this patch fix the issue?

I'm seeing a different issue with this patch:

[  625.886532] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[  625.888056] IP: [<ffffffff811aca2c>] __lock_acquire+0xbc/0x580
[  625.888969] PGD 427842067 PUD 41b321067 PMD 0
[  625.889775] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  625.890773] Dumping ftrace buffer:
[  625.891454]    (ftrace buffer empty)
[  625.892041] Modules linked in:
[  625.892610] CPU: 9 PID: 18991 Comm: trinity-c198 Tainted: G        W    3.14.0-rc5-next-20140305-sasha-00012-g00c5c8f-dirty #110
[  625.894293] task: ffff8804278cb000 ti: ffff88041d89a000 task.ti: ffff88041d89a000
[  625.895678] RIP: 0010:[<ffffffff811aca2c>]  [<ffffffff811aca2c>] __lock_acquire+0xbc/0x580
[  625.896232] RSP: 0018:ffff88041d89bbe8  EFLAGS: 00010002
[  625.896232] RAX: 0000000000000082 RBX: 0000000000000018 RCX: 0000000000000000
[  625.896232] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000018
[  625.896232] RBP: ffff88041d89bc58 R08: 0000000000000001 R09: 0000000000000000
[  625.896232] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8804278cb000
[  625.896232] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
[  625.896232] FS:  00007f144ab81700(0000) GS:ffff880a2b800000(0000) knlGS:0000000000000000
[  625.896232] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  625.896232] CR2: 0000000000000018 CR3: 00000004290cf000 CR4: 00000000000006a0
[  625.896232] Stack:
[  625.896232]  ffff8802295abc18 ffff8804278cb000 ffff880a2b9d84c0 ffff880a2b9d84d0
[  625.896232]  ffff88041d89bc18 ffffffff810bb084 ffff88041d89bc28 ffffffff8107912d
[  625.896232]  ffff88041d89bc58 ffff8804278cb000 0000000000000000 0000000000000001
[  625.896232] Call Trace:
[  625.896232]  [<ffffffff810bb084>] ? kvm_clock_read+0x24/0x50
[  625.896232]  [<ffffffff8107912d>] ? sched_clock+0x1d/0x30
[  625.896232]  [<ffffffff811ad072>] lock_acquire+0x182/0x1d0
[  625.896232]  [<ffffffff812aa473>] ? change_pte_range+0xa3/0x3b0
[  625.896232]  [<ffffffff8107912d>] ? sched_clock+0x1d/0x30
[  625.896232]  [<ffffffff844793a0>] _raw_spin_lock+0x40/0x80
[  625.896232]  [<ffffffff812aa473>] ? change_pte_range+0xa3/0x3b0
[  625.896232]  [<ffffffff812aa473>] change_pte_range+0xa3/0x3b0
[  625.896232]  [<ffffffff812aab28>] change_protection_range+0x3a8/0x4d0
[  625.896232]  [<ffffffff8447f152>] ? preempt_count_sub+0xe2/0x120
[  625.896232]  [<ffffffff812aac75>] change_protection+0x25/0x30
[  625.896232]  [<ffffffff812c3ebb>] change_prot_numa+0x1b/0x30
[  625.896232]  [<ffffffff8118df49>] task_numa_work+0x279/0x360
[  625.896232]  [<ffffffff8116c57e>] task_work_run+0xae/0xf0
[  625.896232]  [<ffffffff8106ffbe>] do_notify_resume+0x8e/0xe0
[  625.896232]  [<ffffffff84484422>] int_signal+0x12/0x17
[  625.896232] Code: c2 37 f6 6b 85 be fa 0b 00 00 48 c7 c7 a1 4f 6c 85 e8 09 60 f9 ff 31 c0 e9 9c 04 00 00 66 90 44 8b 1d 39 1f cd 04 45 85 db 74 0c <48> 81 3b 40 52 76 87 75 06 0f 1f 00 45 31 c0 83 fe 01 77 0c 89
[  625.896232] RIP  [<ffffffff811aca2c>] __lock_acquire+0xbc/0x580
[  625.896232]  RSP <ffff88041d89bbe8>
[  625.896232] CR2: 0000000000000018


Thanks,
Sasha
