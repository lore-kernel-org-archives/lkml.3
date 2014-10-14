Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaJNBT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:19:28 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37800 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaJNBT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:19:27 -0400
From: Martin Kelly <martin@martingkelly.com>
To: xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        Martin Kelly <martin@martingkelly.com>,
        Martin Kelly <martkell@amazon.com>
Subject: [PATCH] xen/setup: add paranoid index check and warning
Date: Mon, 13 Oct 2014 18:19:08 -0700
Message-Id: <1413249548-26415-1-git-send-email-martin@martingkelly.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a call to set_phys_range_identity, i-1 is used without checking that
i is non-zero. Although unlikely, a bug in the code before it could
cause the value to be 0, leading to erroneous behavior. This patch adds
a check against 0 value and a corresponding warning.

Signed-off-by: Martin Kelly <martkell@amazon.com>
---
 arch/x86/xen/setup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index af72161..26e39af 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -671,7 +671,10 @@ char * __init xen_memory_setup(void)
 	 * PFNs above MAX_P2M_PFN are considered identity mapped as
 	 * well.
 	 */
-	set_phys_range_identity(map[i-1].addr / PAGE_SIZE, ~0ul);
+	if (i > 0)
+		set_phys_range_identity(map[i-1].addr / PAGE_SIZE, ~0ul);
+	else
+		WARN(1, "Something went wrong clamping memory to a factor of EXTRA_MEM_RATIO!");
 
 	/*
 	 * In domU, the ISA region is normal, usable memory, but we
-- 
2.1.1

