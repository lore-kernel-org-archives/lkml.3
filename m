Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaKGHvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 02:51:41 -0500
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:52435 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaKGHvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 02:51:31 -0500
X-Greylist: delayed 2890 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2014 02:51:26 EST
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Feiner <pfeiner@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH -mm v7 03/13] pagewalk: add walk_page_vma()
Thread-Topic: [PATCH -mm v7 03/13] pagewalk: add walk_page_vma()
Thread-Index: AQHP+li3rdq72o6JsESWbQ7S3n57Aw==
Date: Fri, 7 Nov 2014 07:01:56 +0000
Message-ID: <1415343692-6314-4-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1415343692-6314-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1415343692-6314-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.22]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduces walk_page_vma(), which is useful for the callers which want to
walk over a given vma.  It's used by later patches.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
ChangeLog v3:
- check walk_page_test's return value instead of walk->skip
---
 include/linux/mm.h |  1 +
 mm/pagewalk.c      | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git mmotm-2014-11-05-16-01.orig/include/linux/mm.h mmotm-2014-11-05-16-01/include/linux/mm.h
index 25a4cf75b575..1022cc27150e 100644
--- mmotm-2014-11-05-16-01.orig/include/linux/mm.h
+++ mmotm-2014-11-05-16-01/include/linux/mm.h
@@ -1157,6 +1157,7 @@ struct mm_walk {
 
 int walk_page_range(unsigned long addr, unsigned long end,
 		struct mm_walk *walk);
+int walk_page_vma(struct vm_area_struct *vma, struct mm_walk *walk);
 void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
diff --git mmotm-2014-11-05-16-01.orig/mm/pagewalk.c mmotm-2014-11-05-16-01/mm/pagewalk.c
index d9cc3caae802..4c9a653ba563 100644
--- mmotm-2014-11-05-16-01.orig/mm/pagewalk.c
+++ mmotm-2014-11-05-16-01/mm/pagewalk.c
@@ -272,3 +272,21 @@ int walk_page_range(unsigned long start, unsigned long end,
 	} while (start = next, start < end);
 	return err;
 }
+
+int walk_page_vma(struct vm_area_struct *vma, struct mm_walk *walk)
+{
+	int err;
+
+	if (!walk->mm)
+		return -EINVAL;
+
+	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
+	VM_BUG_ON(!vma);
+	walk->vma = vma;
+	err = walk_page_test(vma->vm_start, vma->vm_end, walk);
+	if (err > 0)
+		return 0;
+	if (err < 0)
+		return err;
+	return __walk_page_range(vma->vm_start, vma->vm_end, walk);
+}
-- 
2.2.0.rc0.2.gf745acb
