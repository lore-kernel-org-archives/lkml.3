Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaKXNDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:03:49 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:38721 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaKXNDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:03:41 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "linux-arch@vger.kernel.org, linux-mips@linux-mips.org, linux-x86_64@vger.kernel.org, linux-s390"@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH/RFC 4/7] x86: Replace ACCESS_ONCE in gup with a barrier
Date: Mon, 24 Nov 2014 14:03:27 +0100
Message-Id: <1416834210-61738-5-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
References: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112413-0017-0000-0000-000001F464B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Let's use a barrier instead of ACCESS_ONCE to avoid that issue.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/x86/mm/gup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 207d9aef..35991f6 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -14,8 +14,12 @@
 
 static inline pte_t gup_get_pte(pte_t *ptep)
 {
+	pte_t pte;
+
 #ifndef CONFIG_X86_PAE
-	return ACCESS_ONCE(*ptep);
+	pte = *ptep;
+	barrier();
+	return pte;
 #else
 	/*
 	 * With get_user_pages_fast, we walk down the pagetables without taking
@@ -49,7 +53,6 @@ static inline pte_t gup_get_pte(pte_t *ptep)
 	 * very careful -- it does not atomically load the pte or anything that
 	 * is likely to be useful for you.
 	 */
-	pte_t pte;
 
 retry:
 	pte.pte_low = ptep->pte_low;
-- 
1.9.3

