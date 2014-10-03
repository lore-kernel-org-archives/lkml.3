Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbaJCVrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:47:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252AbaJCVp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:45:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.16 212/357] KVM: s390/mm: Fix guest storage key corruption in ptep_set_access_flags
Date: Fri,  3 Oct 2014 14:29:58 -0700
Message-Id: <20141003212939.898680677@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 1951497d90d6754201af3e65241a06f9ef6755cd upstream.

commit 0944fe3f4a32 ("s390/mm: implement software referenced bits")
triggered another paging/storage key corruption. There is an
unhandled invalid->valid pte change where we have to set the real
storage key from the pgste.
When doing paging a guest page might be swapcache or swap and when
faulted in it might be read-only and due to a parallel scan old.
An do_wp_page will make it writeable and young. Due to software
reference tracking this page was invalid and now becomes valid.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/pgtable.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1319,6 +1319,7 @@ static inline int ptep_set_access_flags(
 	ptep_flush_direct(vma->vm_mm, address, ptep);
 
 	if (mm_has_pgste(vma->vm_mm)) {
+		pgste_set_key(ptep, pgste, entry, vma->vm_mm);
 		pgste = pgste_set_pte(ptep, pgste, entry);
 		pgste_set_unlock(ptep, pgste);
 	} else


