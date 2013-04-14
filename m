Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab3DNQII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:08:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3DNQIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:08:05 -0400
Date: Sun, 14 Apr 2013 09:07:51 -0700
From: tip-bot for Boris Ostrovsky <tipbot@zytor.com>
Message-ID: <tip-26564600c9e88c6572a5e6ef5ae9121907edfb7f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boris.ostrovsky@oracle.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, tglx@linutronix.de
In-Reply-To: <1365703192-2089-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1365703192-2089-1-git-send-email-boris.ostrovsky@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm:
  Flush lazy MMU when DEBUG_PAGEALLOC is set
Git-Commit-ID: 26564600c9e88c6572a5e6ef5ae9121907edfb7f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 14 Apr 2013 09:07:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26564600c9e88c6572a5e6ef5ae9121907edfb7f
Gitweb:     http://git.kernel.org/tip/26564600c9e88c6572a5e6ef5ae9121907edfb7f
Author:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
AuthorDate: Thu, 11 Apr 2013 13:59:52 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Apr 2013 07:19:19 +0200

x86/mm: Flush lazy MMU when DEBUG_PAGEALLOC is set

When CONFIG_DEBUG_PAGEALLOC is set page table updates made by
kernel_map_pages() are not made visible (via TLB flush)
immediately if lazy MMU is on. In environments that support lazy
MMU (e.g. Xen) this may lead to fatal page faults, for example,
when zap_pte_range() needs to allocate pages in
__tlb_remove_page() -> tlb_next_batch().

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: konrad.wilk@oracle.com
Link: http://lkml.kernel.org/r/1365703192-2089-1-git-send-email-boris.ostrovsky@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/pageattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 7896f71..fb4e73e 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1413,6 +1413,8 @@ void kernel_map_pages(struct page *page, int numpages, int enable)
 	 * but that can deadlock->flush only current cpu:
 	 */
 	__flush_tlb_all();
+
+	arch_flush_lazy_mmu_mode();
 }
 
 #ifdef CONFIG_HIBERNATION
