Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab3BANJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:09:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:44576 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065Ab3BANJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:09:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 22/89] s390/thp: implement pmdp_set_wrprotect()
Date: Fri,  1 Feb 2013 14:07:37 +0100
Message-Id: <20130201130209.071347084@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit be3286507dab888d4aad9f91fd6ff5202b24cd5b upstream.

On s390, an architecture-specific implementation of the function
pmdp_set_wrprotect() is missing and the generic version is currently
being used. The generic version does not flush the tlb as it would be
needed on s390 when modifying an active pmd, which can lead to subtle
tlb errors on s390 when using transparent hugepages.

This patch adds an s390-specific implementation of pmdp_set_wrprotect()
including the missing tlb flush.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/pgtable.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1365,6 +1365,18 @@ static inline void pmdp_invalidate(struc
 	__pmd_idte(address, pmdp);
 }
 
+#define __HAVE_ARCH_PMDP_SET_WRPROTECT
+static inline void pmdp_set_wrprotect(struct mm_struct *mm,
+				      unsigned long address, pmd_t *pmdp)
+{
+	pmd_t pmd = *pmdp;
+
+	if (pmd_write(pmd)) {
+		__pmd_idte(address, pmdp);
+		set_pmd_at(mm, address, pmdp, pmd_wrprotect(pmd));
+	}
+}
+
 static inline pmd_t mk_pmd_phys(unsigned long physpage, pgprot_t pgprot)
 {
 	pmd_t __pmd;


