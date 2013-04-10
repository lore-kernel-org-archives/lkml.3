Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935800Ab3DJN3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:29:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab3DJN3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:29:36 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH] mm: pageattr: convert noop to functional fix
Date: Wed, 10 Apr 2013 15:28:25 +0200
Message-Id: <1365600505-19314-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a8aed3e0752b4beb2e37cbed6df69faae88268da introduced some valid
fix but one location that didn't trigger the bug that lead to finding
those (small) problems, wasn't updated using the right variable.

The wrong variable was also initialized for no good reason, that may
have been the source of the confusion. Remove the noop initialization
accordingly.

Commit a8aed3e0752b4beb2e37cbed6df69faae88268da also erroneously
removed one canon_pgprot pass meant to clear pmd bitflags not
supported in hardware by older CPUs, that automatically gets corrected
by this patch too by applying it to the right variable in the new
location.

Reported-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/mm/pageattr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 091934e..7896f71 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -467,7 +467,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 * We are safe now. Check whether the new pgprot is the same:
 	 */
 	old_pte = *kpte;
-	old_prot = new_prot = req_prot = pte_pgprot(old_pte);
+	old_prot = req_prot = pte_pgprot(old_pte);
 
 	pgprot_val(req_prot) &= ~pgprot_val(cpa->mask_clr);
 	pgprot_val(req_prot) |= pgprot_val(cpa->mask_set);
@@ -478,12 +478,12 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 * a non present pmd. The canon_pgprot will clear _PAGE_GLOBAL
 	 * for the ancient hardware that doesn't support it.
 	 */
-	if (pgprot_val(new_prot) & _PAGE_PRESENT)
-		pgprot_val(new_prot) |= _PAGE_PSE | _PAGE_GLOBAL;
+	if (pgprot_val(req_prot) & _PAGE_PRESENT)
+		pgprot_val(req_prot) |= _PAGE_PSE | _PAGE_GLOBAL;
 	else
-		pgprot_val(new_prot) &= ~(_PAGE_PSE | _PAGE_GLOBAL);
+		pgprot_val(req_prot) &= ~(_PAGE_PSE | _PAGE_GLOBAL);
 
-	new_prot = canon_pgprot(new_prot);
+	req_prot = canon_pgprot(req_prot);
 
 	/*
 	 * old_pte points to the large page base address. So we need
