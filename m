Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189AbaKLCY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:24:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965816AbaKLBuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:50:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-mm@kvack.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        dave.hansen@intel.com, riel@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.10 023/123] x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE
Date: Wed, 12 Nov 2014 10:16:29 +0900
Message-Id: <20141112011720.072807554@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1414580017-27444-1-git-send-email-decui@microsoft.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/pageattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -389,7 +389,7 @@ phys_addr_t slow_virt_to_phys(void *__vi
 	psize = page_level_size(level);
 	pmask = page_level_mask(level);
 	offset = virt_addr & ~pmask;
-	phys_addr = pte_pfn(*pte) << PAGE_SHIFT;
+	phys_addr = (phys_addr_t)pte_pfn(*pte) << PAGE_SHIFT;
 	return (phys_addr | offset);
 }
 EXPORT_SYMBOL_GPL(slow_virt_to_phys);


