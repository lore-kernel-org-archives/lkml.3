Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaCCUGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:06:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40591 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbaCCUGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:06:47 -0500
Message-ID: <5314E0CD.6070308@oracle.com>
Date: Mon, 03 Mar 2014 15:06:37 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: add pte_present() check on existing hugetlb_entry
 callbacks
References: <53126861.7040107@oracle.com> <1393822946-26871-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1393822946-26871-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 12:02 AM, Naoya Horiguchi wrote:
> Hi Sasha,
>
>> >I can confirm that with this patch the lockdep issue is gone. However, the NULL deref in
>> >walk_pte_range() and the BUG at mm/hugemem.c:3580 still appear.
> I spotted the cause of this problem.
> Could you try testing if this patch fixes it?

I'm seeing a different failure with this patch:

[ 1860.669114] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
[ 1860.670498] IP: [<ffffffff8129c0bf>] vm_normal_page+0x3f/0x90
[ 1860.672795] PGD 6c1c84067 PUD 6e0a3d067 PMD 0
[ 1860.672795] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1860.672795] Dumping ftrace buffer:
[ 1860.672795]    (ftrace buffer empty)
[ 1860.672795] Modules linked in:
[ 1860.672795] CPU: 4 PID: 34914 Comm: trinity-c184 Tainted: G        W    3.14.0-rc4-ne
[ 1860.672795] task: ffff880717d90000 ti: ffff88070b3da000 task.ti: ffff88070b3da000
[ 1860.672795] RIP: 0010:[<ffffffff8129c0bf>]  [<ffffffff8129c0bf>] vm_normal_page+0x3f/
[ 1860.672795] RSP: 0018:ffff88070b3dbba8  EFLAGS: 00010202
[ 1860.672795] RAX: 000000000000767f RBX: ffff88070b3dbdd8 RCX: ffff88070b3dbd78
[ 1860.672795] RDX: 800000000767f225 RSI: 0100000000699000 RDI: 800000000767f225
[ 1860.672795] RBP: ffff88070b3dbba8 R08: 0000000000000000 R09: 0000000000000000
[ 1860.672795] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880717df24c8
[ 1860.672795] R13: 0000000000000020 R14: 0100000000699000 R15: 0100000000800000
[ 1860.672795] FS:  00007f20a3584700(0000) GS:ffff88052b800000(0000) knlGS:0000000000000
[ 1860.672795] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1860.672795] CR2: 0000000000000050 CR3: 00000006d73cf000 CR4: 00000000000006e0
[ 1860.672795] Stack:
[ 1860.672795]  ffff88070b3dbbd8 ffffffff812c2f3d ffffffff812b2dc0 010000000069a000
[ 1860.672795]  ffff880717df24c8 ffff88070b3dbd78 ffff88070b3dbc28 ffffffff812b2e00
[ 1860.672795]  0000000000000000 ffff88072956bcf0 ffff88070b3dbc28 ffff8806e0a3d018
[ 1860.672795] Call Trace:
[ 1860.672795]  [<ffffffff812c2f3d>] queue_pages_pte+0x3d/0xd0
[ 1860.672795]  [<ffffffff812b2dc0>] ? walk_pte_range+0xc0/0x180
[ 1860.672795]  [<ffffffff812b2e00>] walk_pte_range+0x100/0x180
[ 1860.672795]  [<ffffffff812b3091>] walk_pmd_range+0x211/0x240
[ 1860.672795]  [<ffffffff812b31eb>] walk_pud_range+0x12b/0x160
[ 1860.672795]  [<ffffffff812d2ee4>] ? __slab_free+0x384/0x5e0
[ 1860.672795]  [<ffffffff812b3329>] walk_pgd_range+0x109/0x140
[ 1860.672795]  [<ffffffff812b3395>] __walk_page_range+0x35/0x40
[ 1860.672795]  [<ffffffff812b3552>] walk_page_range+0xf2/0x130
[ 1860.672795]  [<ffffffff812c2e41>] queue_pages_range+0x71/0x90
[ 1860.672795]  [<ffffffff812c2f00>] ? queue_pages_hugetlb+0xa0/0xa0
[ 1860.672795]  [<ffffffff812c2e60>] ? queue_pages_range+0x90/0x90
[ 1860.672795]  [<ffffffff812c30d0>] ? change_prot_numa+0x30/0x30
[ 1860.672795]  [<ffffffff812c6c61>] do_mbind+0x321/0x340
[ 1860.672795]  [<ffffffff8129af2f>] ? might_fault+0x9f/0xb0
[ 1860.672795]  [<ffffffff8129aee6>] ? might_fault+0x56/0xb0
[ 1860.672795]  [<ffffffff812c6d09>] SYSC_mbind+0x89/0xb0
[ 1860.672795]  [<ffffffff81268db5>] ? context_tracking_user_exit+0x195/0x1d0
[ 1860.672795]  [<ffffffff812c6d3e>] SyS_mbind+0xe/0x10
[ 1860.672795]  [<ffffffff8447d890>] tracesys+0xdd/0xe2


Thanks,
Sasha
