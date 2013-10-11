Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826Ab3JKTw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:52:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932777Ab3JKTmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gurudas Pai <gurudas.pai@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Rientjes <rientjes@google.com>
Subject: [ 093/135] mm: Fix generic hugetlb pte check return type.
Date: Fri, 11 Oct 2013 12:39:34 -0700
Message-Id: <20131011193955.369035517@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Miller <davem@davemloft.net>

[ Upstream commit 26794942461f438a6bc725ec7294b08a6bd782c4 ]

The include/asm-generic/hugetlb.h stubs that just vector huge_pte_*()
calls to the pte_*() implementations won't work in certain situations.

x86 and sparc, for example, return "unsigned long" from the bit
checks, and just go "return pte_val(pte) & PTE_BIT_FOO;"

But since huge_pte_*() returns 'int', if any high bits on 64-bit are
relevant, they get chopped off.

The net effect is that we can loop forever trying to COW a huge page,
because the huge_pte_write() check signals false all the time.

Reported-by: Gurudas Pai <gurudas.pai@oracle.com>
Tested-by: Gurudas Pai <gurudas.pai@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/hugetlb.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/asm-generic/hugetlb.h
+++ b/include/asm-generic/hugetlb.h
@@ -6,12 +6,12 @@ static inline pte_t mk_huge_pte(struct p
 	return mk_pte(page, pgprot);
 }
 
-static inline int huge_pte_write(pte_t pte)
+static inline unsigned long huge_pte_write(pte_t pte)
 {
 	return pte_write(pte);
 }
 
-static inline int huge_pte_dirty(pte_t pte)
+static inline unsigned long huge_pte_dirty(pte_t pte)
 {
 	return pte_dirty(pte);
 }


