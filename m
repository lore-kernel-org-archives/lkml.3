Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaJNCa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 22:30:57 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55256 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbaJNCaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 22:30:55 -0400
From: Martin Kelly <martin@martingkelly.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org
Cc: david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, Martin Kelly <martin@martingkelly.com>,
        Martin Kelly <martkell@amazon.com>
Subject: [PATCH 2/2] xen/setup: warn on bad Xen-supplied memory map
Date: Mon, 13 Oct 2014 19:30:17 -0700
Message-Id: <1413253817-6943-2-git-send-email-martin@martingkelly.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413253817-6943-1-git-send-email-martin@martingkelly.com>
References: <1413253817-6943-1-git-send-email-martin@martingkelly.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we don't check the return code of sanitize_e820_map. However,
if the Xen-supplied memory map is invalid, then sanitize_e820_map will
return without doing anything, potentially leading to errors later on.
Add a WARN_ON in case sanitize_e820_map detects an invalid memory map.

Signed-off-by: Martin Kelly <martkell@amazon.com>
---
 arch/x86/xen/setup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index af72161..48c7072 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -608,7 +608,8 @@ char * __init xen_memory_setup(void)
 		xen_ignore_unusable(map, memmap.nr_entries);
 
 	/* Make sure the Xen-supplied memory map is well-ordered. */
-	sanitize_e820_map(map, memmap.nr_entries, &memmap.nr_entries);
+	rc = sanitize_e820_map(map, memmap.nr_entries, &memmap.nr_entries);
+	WARN_ON(rc == E820_RC_BAD_MAP);
 
 	max_pages = xen_get_max_pages();
 	if (max_pages > max_pfn)
-- 
2.1.1

