Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbbAZL4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:56:38 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:45058 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbbAZL4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:56:34 -0500
Date: Mon, 26 Jan 2015 13:56:12 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [mm] WARNING: CPU: 1 PID: 681 at mm/mmap.c:2858 exit_mmap()
Message-ID: <20150126115612.GA25833@node.dhcp.inet.fi>
References: <20150125043608.GB6109@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125043608.GB6109@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 08:36:08PM -0800, Fengguang Wu wrote:
> [   17.687075] Freeing unused kernel memory: 1716K (c190d000 - c1aba000)
> [   17.808897] random: init urandom read with 5 bits of entropy available
> [   17.828360] ------------[ cut here ]------------
> [   17.828989] WARNING: CPU: 1 PID: 681 at mm/mmap.c:2858 exit_mmap+0x197/0x1ad()
> [   17.830086] Modules linked in:
> [   17.830549] CPU: 1 PID: 681 Comm: init Not tainted 3.19.0-rc5-gf7a7b53 #19
> [   17.831339]  00000001 00000000 00000001 d388bd4c c14341a1 00000000 00000001 c16ebf08
> [   17.832421]  d388bd68 c1056987 00000b2a c1150db8 00000001 00000001 00000000 d388bd78
> [   17.833488]  c1056a11 00000009 00000000 d388bdd0 c1150db8 d3858380 ffffffff ffffffff
> [   17.841323] Call Trace:
> [   17.844215]  [<c14341a1>] dump_stack+0x78/0xa8
> [   17.844700]  [<c1056987>] warn_slowpath_common+0xb7/0xce
> [   17.847797]  [<c1150db8>] ? exit_mmap+0x197/0x1ad
> [   17.850955]  [<c1056a11>] warn_slowpath_null+0x14/0x18
> [   17.854131]  [<c1150db8>] exit_mmap+0x197/0x1ad
> [   17.854629]  [<c10537ff>] mmput+0x52/0xef
> [   17.857584]  [<c1175602>] flush_old_exec+0x923/0x99d
> [   17.860806]  [<c11aea1e>] load_elf_binary+0x430/0x11af
> [   17.861378]  [<c108559f>] ? local_clock+0x2f/0x39
> [   17.865327]  [<c109817f>] ? lock_release_holdtime+0x60/0x6d
> [   17.866002]  [<c1174159>] search_binary_handler+0x9c/0x20f
> [   17.866588]  [<c11ac7e5>] load_script+0x339/0x355
> [   17.874149]  [<c108550c>] ? sched_clock_cpu+0x188/0x1a3
> [   17.874718]  [<c108559f>] ? local_clock+0x2f/0x39
> [   17.878580]  [<c109817f>] ? lock_release_holdtime+0x60/0x6d
> [   17.879355]  [<c109c1bf>] ? do_raw_read_unlock+0x28/0x53
> [   17.879997]  [<c1174159>] search_binary_handler+0x9c/0x20f
> [   17.887644]  [<c1176054>] do_execveat_common+0x6d6/0x954
> [   17.890904]  [<c11762eb>] do_execve+0x19/0x1b
> [   17.891389]  [<c1176586>] SyS_execve+0x21/0x25
> [   17.895168]  [<c143be92>] syscall_call+0x7/0x7
> [   17.895653] ---[ end trace 6a7094e9a1d04ce0 ]---
> [   17.909585] ------------[ cut here ]------------

Thanks for report. The patch below should fix this.

>From 00fc3107c8c62c4592a64293faff7e5643a068c0 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Mon, 26 Jan 2015 13:50:58 +0200
Subject: [PATCH 2/2] mm, x86: fix pmd accounting for PAE

Add missed mm->nr_pmds decrement on cleanup prepopulated PMDs.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/x86/mm/pgtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index a7d36de0bd30..7b22adaad4f1 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -249,6 +249,7 @@ static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
 
 			paravirt_release_pmd(pgd_val(pgd) >> PAGE_SHIFT);
 			pmd_free(mm, pmd);
+			mm_dec_nr_pmds(mm);
 		}
 	}
 }
-- 
 Kirill A. Shutemov
