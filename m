Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab3K0BIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:08:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab3K0A76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.12 090/116] powerpc: Fix __get_user_pages_fast() irq handling
Date: Tue, 26 Nov 2013 16:57:43 -0800
Message-Id: <20131127005743.129687780@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 95f715b08fa4a953771398d20cbe35a6803ea41d upstream.

__get_user_pages_fast() may be called with interrupts disabled (see e.g.
get_futex_key() in kernel/futex.c) and therefore should use local_irq_save()
and local_irq_restore() instead of local_irq_disable()/enable().

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/gup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/gup.c
+++ b/arch/powerpc/mm/gup.c
@@ -123,6 +123,7 @@ int __get_user_pages_fast(unsigned long
 	struct mm_struct *mm = current->mm;
 	unsigned long addr, len, end;
 	unsigned long next;
+	unsigned long flags;
 	pgd_t *pgdp;
 	int nr = 0;
 
@@ -156,7 +157,7 @@ int __get_user_pages_fast(unsigned long
 	 * So long as we atomically load page table pointers versus teardown,
 	 * we can follow the address down to the the page and take a ref on it.
 	 */
-	local_irq_disable();
+	local_irq_save(flags);
 
 	pgdp = pgd_offset(mm, addr);
 	do {
@@ -179,7 +180,7 @@ int __get_user_pages_fast(unsigned long
 			break;
 	} while (pgdp++, addr = next, addr != end);
 
-	local_irq_enable();
+	local_irq_restore(flags);
 
 	return nr;
 }


