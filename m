Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab3KIH06 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:26:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab3KIGvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu ShuoX <shuox.liu@intel.com>, Chen LinX <linx.z.chen@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 63/74] mm/pagewalk.c: fix walk_page_range() access of wrong PTEs
Date: Fri,  8 Nov 2013 22:52:08 -0800
Message-Id: <20131109065117.897866566@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen LinX <linx.z.chen@intel.com>

commit 3017f079efd6af199b0852b5c425364513db460e upstream.

When walk_page_range walk a memory map's page tables, it'll skip
VM_PFNMAP area, then variable 'next' will to assign to vma->vm_end, it
maybe larger than 'end'.  In next loop, 'addr' will be larger than
'next'.  Then in /proc/XXXX/pagemap file reading procedure, the 'addr'
will growing forever in pagemap_pte_range, pte_to_pagemap_entry will
access the wrong pte.

  BUG: Bad page map in process procrank  pte:8437526f pmd:785de067
  addr:9108d000 vm_flags:00200073 anon_vma:f0d99020 mapping:  (null) index:9108d
  CPU: 1 PID: 4974 Comm: procrank Tainted: G    B   W  O 3.10.1+ #1
  Call Trace:
    dump_stack+0x16/0x18
    print_bad_pte+0x114/0x1b0
    vm_normal_page+0x56/0x60
    pagemap_pte_range+0x17a/0x1d0
    walk_page_range+0x19e/0x2c0
    pagemap_read+0x16e/0x200
    vfs_read+0x84/0x150
    SyS_read+0x4a/0x80
    syscall_call+0x7/0xb

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
Signed-off-by: Chen LinX <linx.z.chen@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/pagewalk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -242,7 +242,7 @@ int walk_page_range(unsigned long addr,
 		if (err)
 			break;
 		pgd++;
-	} while (addr = next, addr != end);
+	} while (addr = next, addr < end);
 
 	return err;
 }


