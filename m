Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaA3APf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:15:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25490 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaA3APd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:15:33 -0500
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: konrad.wilk@oracle.com
Cc: roger.pau@citrix.com, Xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pvh: set cr4 flags for APs
Date: Wed, 29 Jan 2014 16:15:18 -0800
Message-Id: <1391040918-11722-2-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1391040918-11722-1-git-send-email-mukesh.rathor@oracle.com>
References: <1391040918-11722-1-git-send-email-mukesh.rathor@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to set cr4 flags for APs that are already set for BSP.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
---
 arch/x86/xen/enlighten.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a4d7b64..201d09a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1473,6 +1473,18 @@ static void xen_pvh_set_cr_flags(int cpu)
 	 * X86_CR0_TS, X86_CR0_PE, X86_CR0_ET are set by Xen for HVM guests
 	 * (which PVH shared codepaths), while X86_CR0_PG is for PVH. */
 	write_cr0(read_cr0() | X86_CR0_MP | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM);
+
+	if (!cpu)
+		return;
+	/*
+	 * For BSP, PSE PGE are set in probe_page_size_mask(), for APs
+	 * set them here. For all, OSFXSR OSXMMEXCPT are set in fpu_init.
+	*/
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	if (cpu_has_pge)
+		set_in_cr4(X86_CR4_PGE);
 }
 
 /*
-- 
1.7.2.3

