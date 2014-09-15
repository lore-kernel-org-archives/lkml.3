Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbaIOVFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:05:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbaIOT06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.16 040/158] powerpc/thp: Add write barrier after updating the valid bit
Date: Mon, 15 Sep 2014 12:24:39 -0700
Message-Id: <20140915192544.091648678@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit b0aa44a3dfae3d8f45bd1264349aa87f87b7774f upstream.

With hugepages, we store the hpte valid information in the pte page
whose address is stored in the second half of the PMD. Use a
write barrier to make sure clearing pmd busy bit and updating
hpte valid info are ordered properly.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/hugepage-hash64.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/hugepage-hash64.c
+++ b/arch/powerpc/mm/hugepage-hash64.c
@@ -172,8 +172,11 @@ repeat:
 		mark_hpte_slot_valid(hpte_slot_array, index, slot);
 	}
 	/*
-	 * No need to use ldarx/stdcx here
+	 * The hpte valid is stored in the pgtable whose address is in the
+	 * second half of the PMD. Order this against clearing of the busy bit in
+	 * huge pmd.
 	 */
+	smp_wmb();
 	*pmdp = __pmd(new_pmd & ~_PAGE_BUSY);
 	return 0;
 }


