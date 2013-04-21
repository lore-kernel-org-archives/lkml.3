Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3DUQuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 12:50:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:31124 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab3DUQt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 12:49:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,520,1363158000"; 
   d="scan'208";a="298519245"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] x86: Fix AMD K6 indirect call check v2
Date: Sun, 21 Apr 2013 09:49:55 -0700
Message-Id: <1366562995-20530-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The AMD K6 errata check relies on timing a indirect call.
But the way it was written it could be optimized to a direct call.
Force gcc to actually do a indirect call and not just
constant resolve the target address.

Found during code review, no runtime testing due to lack
of hardware.

v2: More description
Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 4a549db..11ea6f6 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -115,7 +115,7 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 		 */
 
 		n = K6_BUG_LOOP;
-		f_vide = vide;
+		asm("" : "=g" (f_vide) : "0" (vide));
 		rdtscl(d);
 		while (n--)
 			f_vide();
