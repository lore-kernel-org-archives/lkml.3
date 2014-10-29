Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbaJ2KAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:00:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbaJ2KAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:00:42 -0400
Date: Wed, 29 Oct 2014 03:00:30 -0700
From: tip-bot for Dexuan Cui <tipbot@zytor.com>
Message-ID: <tip-d1cd1210834649ce1ca6bafe5ac25d2f40331343@git.kernel.org>
Cc: hpa@zytor.com, haiyangz@microsoft.com, mingo@kernel.org,
        tglx@linutronix.de, decui@microsoft.com, linux-kernel@vger.kernel.org,
        kys@microsoft.com
Reply-To: hpa@zytor.com, haiyangz@microsoft.com, mingo@kernel.org,
        tglx@linutronix.de, kys@microsoft.com, decui@microsoft.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1414580017-27444-1-git-send-email-decui@microsoft.com>
References: <1414580017-27444-1-git-send-email-decui@microsoft.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, pageattr:
  Prevent overflow in slow_virt_to_phys() for X86_PAE
Git-Commit-ID: d1cd1210834649ce1ca6bafe5ac25d2f40331343
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1cd1210834649ce1ca6bafe5ac25d2f40331343
Gitweb:     http://git.kernel.org/tip/d1cd1210834649ce1ca6bafe5ac25d2f40331343
Author:     Dexuan Cui <decui@microsoft.com>
AuthorDate: Wed, 29 Oct 2014 03:53:37 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 29 Oct 2014 10:57:21 +0100

x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE

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
---
 arch/x86/mm/pageattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index ae242a7..36de293 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -409,7 +409,7 @@ phys_addr_t slow_virt_to_phys(void *__virt_addr)
 	psize = page_level_size(level);
 	pmask = page_level_mask(level);
 	offset = virt_addr & ~pmask;
-	phys_addr = pte_pfn(*pte) << PAGE_SHIFT;
+	phys_addr = (phys_addr_t)pte_pfn(*pte) << PAGE_SHIFT;
 	return (phys_addr | offset);
 }
 EXPORT_SYMBOL_GPL(slow_virt_to_phys);
