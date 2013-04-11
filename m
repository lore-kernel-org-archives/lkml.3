Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161037Ab3DKMWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:22:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41013 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934936Ab3DKMWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:22:01 -0400
Date: Thu, 11 Apr 2013 05:20:35 -0700
From: tip-bot for Andrea Arcangeli <tipbot@zytor.com>
Message-ID: <tip-f76cfa3c2496c462b5bc01bd0c9340c2715b73ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        apw@canonical.com, bp@alien8.de, stefan.bader@canonical.com,
        aarcange@redhat.com, mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        apw@canonical.com, stefan.bader@canonical.com, bp@alien8.de,
        aarcange@redhat.com, mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1365600505-19314-1-git-send-email-aarcange@redhat.com>
References: <1365600505-19314-1-git-send-email-aarcange@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm/cpa: Convert noop to functional fix
Git-Commit-ID: f76cfa3c2496c462b5bc01bd0c9340c2715b73ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 11 Apr 2013 05:20:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f76cfa3c2496c462b5bc01bd0c9340c2715b73ca
Gitweb:     http://git.kernel.org/tip/f76cfa3c2496c462b5bc01bd0c9340c2715b73ca
Author:     Andrea Arcangeli <aarcange@redhat.com>
AuthorDate: Wed, 10 Apr 2013 15:28:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 11 Apr 2013 10:34:42 +0200

x86/mm/cpa: Convert noop to functional fix

Commit:

  a8aed3e0752b ("x86/mm/pageattr: Prevent PSE and GLOABL leftovers to confuse pmd/pte_present and pmd_huge")

introduced a valid fix but one location that didn't trigger the bug that
lead to finding those (small) problems, wasn't updated using the
right variable.

The wrong variable was also initialized for no good reason, that
may have been the source of the confusion. Remove the noop
initialization accordingly.

Commit a8aed3e0752b also erroneously removed one canon_pgprot pass meant
to clear pmd bitflags not supported in hardware by older CPUs, that
automatically gets corrected by this patch too by applying it to the right
variable in the new location.

Reported-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Mel Gorman <mgorman@suse.de>
Link: http://lkml.kernel.org/r/1365600505-19314-1-git-send-email-aarcange@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
