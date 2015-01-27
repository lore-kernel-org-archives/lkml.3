Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbbA0MpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:45:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34967 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758399AbbA0MRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 032/126] mm: fix corner case in anon_vma endless growing prevention
Date: Tue, 27 Jan 2015 12:15:37 +0000
Message-Id: <1422361031-19364-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <koct9i@gmail.com>

commit b800c91a0517071156e772d4fb329ad33590da62 upstream.

Fix for BUG_ON(anon_vma->degree) splashes in unlink_anon_vmas() ("kernel
BUG at mm/rmap.c:399!") caused by commit 7a3ef208e662 ("mm: prevent
endless growth of anon_vma hierarchy")

Anon_vma_clone() is usually called for a copy of source vma in
destination argument.  If source vma has anon_vma it should be already
in dst->anon_vma.  NULL in dst->anon_vma is used as a sign that it's
called from anon_vma_fork().  In this case anon_vma_clone() finds
anon_vma for reusing.

Vma_adjust() calls it differently and this breaks anon_vma reusing
logic: anon_vma_clone() links vma to old anon_vma and updates degree
counters but vma_adjust() overrides vma->anon_vma right after that.  As
a result final unlink_anon_vmas() decrements degree for wrong anon_vma.

This patch assigns ->anon_vma before calling anon_vma_clone().

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-and-tested-by: Chris Clayton <chris2553@googlemail.com>
Reported-and-tested-by: Oded Gabbay <oded.gabbay@amd.com>
Reported-and-tested-by: Chih-Wei Huang <cwhuang@android-x86.org>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Daniel Forrest <dan.forrest@ssec.wisc.edu>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/mmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 9f7b97613ca4..5f0712551402 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -749,10 +749,12 @@ again:			remove_next = 1 + (end > next->vm_end);
 		if (exporter && exporter->anon_vma && !importer->anon_vma) {
 			int error;
 
+			importer->anon_vma = exporter->anon_vma;
 			error = anon_vma_clone(importer, exporter);
-			if (error)
+			if (error) {
+				importer->anon_vma = NULL;
 				return error;
-			importer->anon_vma = exporter->anon_vma;
+			}
 		}
 	}
 
-- 
2.1.4

