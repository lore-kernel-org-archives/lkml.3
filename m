Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3ISO4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:56:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58771 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab3ISOzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:55:07 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org
Subject: [PATCH 07/11] x86, pageattr: Add a PTE pagetable populating function
Date: Thu, 19 Sep 2013 16:54:50 +0200
Message-Id: <1379602494-26684-8-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379602494-26684-1-git-send-email-bp@alien8.de>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Handle last level by unconditionally writing the PTEs into the PTE page
while paying attention to the NX bit.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/mm/pageattr.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index c56d71591617..02cf97b3bb7c 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -686,7 +686,27 @@ static int alloc_pmd_page(pud_t *pud)
 	return 0;
 }
 
-#define populate_pte(cpa, start, end, pages, pmd, pgprot)	do {} while (0)
+static void populate_pte(struct cpa_data *cpa,
+			 unsigned long start, unsigned long end,
+			 unsigned num_pages, pmd_t *pmd, pgprot_t pgprot)
+{
+	pte_t *pte;
+
+	pte = pte_offset_kernel(pmd, start);
+
+	while (num_pages-- && start < end) {
+
+		/* deal with the NX bit */
+		if (!(pgprot_val(pgprot) & _PAGE_NX))
+			cpa->pfn &= ~_PAGE_NX;
+
+		set_pte(pte, pfn_pte(cpa->pfn >> PAGE_SHIFT, pgprot));
+
+		start	 += PAGE_SIZE;
+		cpa->pfn += PAGE_SIZE;
+		pte++;
+	}
+}
 
 static int populate_pmd(struct cpa_data *cpa,
 			unsigned long start, unsigned long end,
-- 
1.8.4

