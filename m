Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbaGINfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:35:00 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:60593 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbaGINe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:34:59 -0400
Date: Wed, 9 Jul 2014 16:34:36 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v4 13/13] mincore: apply page table walker on do_mincore()
Message-ID: <20140709133436.GA18391@node.dhcp.inet.fi>
References: <1404234451-21695-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1404234451-21695-14-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404234451-21695-14-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 01:07:31PM -0400, Naoya Horiguchi wrote:
> This patch makes do_mincore() use walk_page_vma(), which reduces many lines
> of code by using common page table walk code.
> 
> ChangeLog v4:
> - remove redundant vma
> 
> ChangeLog v3:
> - add NULL vma check in mincore_unmapped_range()
> - don't use pte_entry()
> 
> ChangeLog v2:
> - change type of args of callbacks to void *
> - move definition of mincore_walk to the start of the function to fix compiler
>   warning
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Trinity crases this implementation of mincore pretty easily:

[   42.775369] BUG: unable to handle kernel paging request at ffff88007bb61000
[   42.776656] IP: [<ffffffff81126f8f>] mincore_unmapped_range+0xdf/0x100
[   42.777560] PGD 2ef6067 PUD 87fa01067 PMD 87f823067 PTE 800000007bb61060
[   42.778529] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[   42.779106] Modules linked in:
[   42.779106] CPU: 0 PID: 917 Comm: trinity-c27 Not tainted 3.16.0-rc4-next-20140709-00013-g28e4629f71a8 #1450
[   42.779106] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   42.779106] task: ffff880852e98110 ti: ffff880844024000 task.ti: ffff880844024000
[   42.779106] RIP: 0010:[<ffffffff81126f8f>]  [<ffffffff81126f8f>] mincore_unmapped_range+0xdf/0x100
[   42.779106] RSP: 0018:ffff880844027df0  EFLAGS: 00010202
[   42.779106] RAX: 000000000000001c RBX: 00007fc300000000 RCX: 00003ffffffff000
[   42.779106] RDX: 000000000000001b RSI: ffff88007bb60fe5 RDI: 00007fc2c2c00000
[   42.779106] RBP: ffff880844027e28 R08: 00007fc2c2e00000 R09: 0000000000000000
[   42.779106] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000200
[   42.779106] R13: ffff88007bb60fe5 R14: ffff880855a80018 R15: 00007fc2c2c00000
[   42.779106] FS:  00007fc345666700(0000) GS:ffff880859600000(0000) knlGS:0000000000000000
[   42.779106] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.779106] CR2: ffff88007bb61000 CR3: 0000000852dfd000 CR4: 00000000000006f0
[   42.779106] Stack:
[   42.779106]  ffff880844027f10 ffff88007bb60fe5 00007fc300000000 00007fc2c2e00000
[   42.779106]  00007fc2c1e1b000 ffff880844027f10 00007fc2c2c00000 ffff880844027eb8
[   42.779106]  ffffffff81135bfe 00007fc341c1bfff ffff880000000000 ffff880852dfd7f8
[   42.779106] Call Trace:
[   42.779106]  [<ffffffff81135bfe>] __walk_page_range+0x1ae/0x450
[   42.779106]  [<ffffffff81136051>] walk_page_vma+0x71/0x90
[   42.779106]  [<ffffffff8112741e>] SyS_mincore+0x1de/0x270
[   42.779106]  [<ffffffff810949fd>] ? trace_hardirqs_on+0xd/0x10
[   42.779106]  [<ffffffff81126fb0>] ? mincore_unmapped_range+0x100/0x100
[   42.779106]  [<ffffffff81126eb0>] ? mincore_page+0xa0/0xa0
[   42.779106]  [<ffffffff81126dc0>] ? handle_mm_fault+0xd30/0xd30
[   42.779106]  [<ffffffff81746b52>] system_call_fastpath+0x16/0x1b
[   42.779106] Code: 83 c4 10 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 40 00 31 d2 31 c0 4d 85 e4 4c 8b 6d d0 74 d3 0f 1f 00 48 8b 75 d0 83 c0 01 <c6> 04 16 00 48 63 d0 49 39 d4 77 ed eb b3 48 89 fe 4c 89 f7 e8 
[   42.779106] RIP  [<ffffffff81126f8f>] mincore_unmapped_range+0xdf/0x100
[   42.779106]  RSP <ffff880844027df0>
[   42.779106] CR2: ffff88007bb61000
[   42.779106] ---[ end trace 3fac62521b6b0cb0 ]---
[   42.779106] Kernel panic - not syncing: Fatal exception
[   42.779106] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)


Looks like 'vec' overflow. I don't see what could prevent do_mincore() to
write more than PAGE_SIZE to 'vec'.

-- 
 Kirill A. Shutemov
