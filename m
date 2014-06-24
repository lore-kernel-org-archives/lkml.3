Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaFXPUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:20:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbaFXPUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:20:19 -0400
Date: Tue, 24 Jun 2014 11:20:09 -0400
From: Dave Jones <davej@redhat.com>
To: Josh Hunt <johunt@akamai.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Baron, Jason" <jbaron@akamai.com>
Subject: Re: [PATCH] panic: add TAINT_SOFTLOCKUP
Message-ID: <20140624152009.GB18176@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Josh Hunt <johunt@akamai.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Baron, Jason" <jbaron@akamai.com>
References: <1401847955-3345-1-git-send-email-johunt@akamai.com>
 <20140623151121.44f17779004e94ab620b837c@linux-foundation.org>
 <53A8ADEC.6070406@akamai.com>
 <20140623155118.e2446a6110a9889454db2386@linux-foundation.org>
 <53A9899C.9040005@akamai.com>
 <20140624150615.GA18176@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624150615.GA18176@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 11:06:15AM -0400, Dave Jones wrote:
> 
 > For things like the fuzz test runs I do, I'd have to patch this out.
 > 
 > Things like migrate_pages() with bad arguments will trigger a page
 > allocation failure rather easily. Likewise set_mempolicy(), and a
 > handful of other vm syscalls.

I grepped logs for the last week.  There's also a lot of non-obvious
causes of page alloc failures. (Possibly because free memory had been
filled with dirty huge pages), but here we can't even successfully
alloc a single order 0 page.

Traces from separate runs, on various kernels from the last week.


page allocation failure: order:0, mode:0x280da
dump_stack+0x4e/0x7a
warn_alloc_failed+0xff/0x170
__alloc_pages_nodemask+0x78e/0xc90
alloc_pages_vma+0xaf/0x1c0
handle_mm_fault+0xa31/0xc50
? default_wake_function+0x12/0x20
__do_page_fault+0x1c9/0x630
? __acct_update_integrals+0x8b/0x120
? preempt_count_sub+0xab/0x100
trace_do_page_fault+0x3d/0x130
trace_page_fault+0x22/0x30


page allocation failure: order:0, mode:0x200da
dump_stack+0x4e/0x7a
warn_alloc_failed+0xff/0x170
__alloc_pages_nodemask+0x78e/0xc90
alloc_pages_vma+0xaf/0x1c0
read_swap_cache_async+0x123/0x220
swapin_readahead+0x106/0x1d0
handle_mm_fault+0x9d5/0xc50
? default_wake_function+0x12/0x20
? autoremove_wake_function+0x2b/0x40
__do_page_fault+0x1c9/0x630
? __wake_up+0x44/0x50
? __acct_update_integrals+0x8b/0x120
? preempt_count_sub+0xab/0x100
trace_do_page_fault+0x3d/0x130
trace_page_fault+0x22/0x30


page allocation failure: order:0, mode:0x280da
dump_stack+0x4e/0x7a
warn_alloc_failed+0xff/0x170
__alloc_pages_nodemask+0x78e/0xc90
alloc_pages_vma+0xaf/0x1c0
handle_mm_fault+0xa31/0xc50
? follow_page_mask+0x1f0/0x320
__get_user_pages+0x22b/0x660
? kmem_cache_alloc+0x183/0x210
__mlock_vma_pages_range+0x9e/0xd0
__mm_populate+0xca/0x180
vm_mmap_pgoff+0xd3/0xe0
SyS_mmap_pgoff+0x116/0x2c0
? syscall_trace_enter+0x14d/0x2a0
SyS_mmap+0x22/0x30
tracesys+0xdd/0xe2


page allocation failure: order:0, mode:0x2084d0
dump_stack+0x4e/0x7a
warn_alloc_failed+0xff/0x170
__alloc_pages_nodemask+0x78e/0xc90
alloc_pages_current+0xb1/0x160
pte_alloc_one+0x17/0x90
__pte_alloc+0x27/0x150
handle_mm_fault+0x68d/0xc50
? follow_page_mask+0xcb/0x320
__get_user_pages+0x22b/0x660
? kmem_cache_alloc+0x183/0x210
__mlock_vma_pages_range+0x9e/0xd0
__mm_populate+0xca/0x180
vm_mmap_pgoff+0xd3/0xe0
SyS_mmap_pgoff+0x116/0x2c0
? syscall_trace_enter+0x14d/0x2a0
SyS_mmap+0x22/0x30
tracesys+0xdd/0xe2

