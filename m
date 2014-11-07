Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaKGHv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 02:51:29 -0500
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:52435 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaKGHv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 02:51:27 -0500
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
Subject: [PATCH -mm v7 10/13] arch/powerpc/mm/subpage-prot.c: use walk->vma
 and walk_page_vma()
Thread-Topic: [PATCH -mm v7 10/13] arch/powerpc/mm/subpage-prot.c: use
 walk->vma and walk_page_vma()
Thread-Index: AQHP+li7NvyVivzQXUeOx1wxzCbmpw==
Date: Fri, 7 Nov 2014 07:02:02 +0000
Message-ID: <1415343692-6314-11-git-send-email-n-horiguchi@ah.jp.nec.com>
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

We don't have to use mm_walk->private to pass vma to the callback function
because of mm_walk->vma. And walk_page_vma() is useful if we walk over a
single vma.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/powerpc/mm/subpage-prot.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git mmotm-2014-11-05-16-01.orig/arch/powerpc/mm/subpage-prot.c mmotm-2014-11-05-16-01/arch/powerpc/mm/subpage-prot.c
index 6c0b1f5f8d2c..fa9fb5b4c66c 100644
--- mmotm-2014-11-05-16-01.orig/arch/powerpc/mm/subpage-prot.c
+++ mmotm-2014-11-05-16-01/arch/powerpc/mm/subpage-prot.c
@@ -134,7 +134,7 @@ static void subpage_prot_clear(unsigned long addr, unsigned long len)
 static int subpage_walk_pmd_entry(pmd_t *pmd, unsigned long addr,
 				  unsigned long end, struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = walk->private;
+	struct vm_area_struct *vma = walk->vma;
 	split_huge_page_pmd(vma, addr, pmd);
 	return 0;
 }
@@ -163,9 +163,7 @@ static void subpage_mark_vma_nohuge(struct mm_struct *mm, unsigned long addr,
 		if (vma->vm_start >= (addr + len))
 			break;
 		vma->vm_flags |= VM_NOHUGEPAGE;
-		subpage_proto_walk.private = vma;
-		walk_page_range(vma->vm_start, vma->vm_end,
-				&subpage_proto_walk);
+		walk_page_vma(vma, &subpage_proto_walk);
 		vma = vma->vm_next;
 	}
 }
-- 
2.2.0.rc0.2.gf745acb
