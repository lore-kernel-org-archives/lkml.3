Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3IVSRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 14:17:35 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:34713 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3IVSRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:17:33 -0400
From: Felipe Pena <felipensp@gmail.com>
To: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Helge Deller <deller@gmx.de>
Cc: Felipe Pena <felipensp@gmail.com>
Subject: [PATCH 1/1] arch/parisc: mm: fix uninitialized variable usage
Date: Sun, 22 Sep 2013 15:17:46 -0300
Message-Id: <1379873866-29219-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FAULT_FLAG_WRITE flag has been set based on uninitialized variable

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 arch/parisc/mm/fault.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
index d10d27a..6b38026 100644
--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -182,8 +182,6 @@ void do_page_fault(struct pt_regs *regs, unsigned long code,
 
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
-	if (acc_type & VM_WRITE)
-		flags |= FAULT_FLAG_WRITE;
 retry:
 	down_read(&mm->mmap_sem);
 	vma = find_vma_prev(mm, address, &prev_vma);
@@ -201,6 +199,9 @@ good_area:
 	if ((vma->vm_flags & acc_type) != acc_type)
 		goto bad_area;
 
+	if (acc_type & VM_WRITE)
+		flags |= FAULT_FLAG_WRITE;
+
 	/*
 	 * If for any reason at all we couldn't handle the fault, make
 	 * sure we exit gracefully rather than endlessly redo the
-- 
1.7.10.4

