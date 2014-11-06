Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaKFWlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:41:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58697 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaKFWlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dexuan Cui <decui@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, gregkh@linuxfoundation.org,
        linux-mm@kvack.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, dave.hansen@intel.com, riel@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 147/162] x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE
Date: Thu,  6 Nov 2014 14:36:51 -0800
Message-Id: <1415313426-9622-148-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dexuan Cui <decui@microsoft.com>

commit d1cd1210834649ce1ca6bafe5ac25d2f40331343 upstream.

pte_pfn() returns a PFN of long (32 bits in 32-PAE), so "long <<
PAGE_SHIFT" will overflow for PFNs above 4GB.

Due to this issue, some Linux 32-PAE distros, running as guests on Hyper-V,
with 5GB memory assigned, can't load the netvsc driver successfully and
hence the synthetic network device can't work (we can use the kernel parameter
mem=3000M to work around the issue).

Cast pte_pfn() to phys_addr_t before shifting.

Fixes: "commit d76565344512: x86, mm: Create slow_virt_to_phys()"
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: gregkh@linuxfoundation.org
Cc: linux-mm@kvack.org
Cc: olaf@aepfle.de
Cc: apw@canonical.com
Cc: jasowang@redhat.com
Cc: dave.hansen@intel.com
Cc: riel@redhat.com
Link: http://lkml.kernel.org/r/1414580017-27444-1-git-send-email-decui@microsoft.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/mm/pageattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index bb32480..aabdf76 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -389,7 +389,7 @@ phys_addr_t slow_virt_to_phys(void *__virt_addr)
 	psize = page_level_size(level);
 	pmask = page_level_mask(level);
 	offset = virt_addr & ~pmask;
-	phys_addr = pte_pfn(*pte) << PAGE_SHIFT;
+	phys_addr = (phys_addr_t)pte_pfn(*pte) << PAGE_SHIFT;
 	return (phys_addr | offset);
 }
 EXPORT_SYMBOL_GPL(slow_virt_to_phys);
-- 
1.9.1

