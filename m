Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaG1PCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:02:00 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53179 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaG1PBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:01:55 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [IA64] Fix zeroing of PDAs
Date: Mon, 28 Jul 2014 17:01:48 +0200
Message-Id: <1406559709-9401-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The code uses a the following to zero out a PDA:

	memset(pda, 0, sizeof(pda));

But sizeof(pda) will return the size of a pointer rather than the size
of the structure pointed to. This triggers the following warning from
GCC:

	arch/ia64/sn/kernel/setup.c:582:23: warning: argument to 'sizeof' in 'memset' call is the same pointer type 'struct pda_s *' as the destination; expected 'struct pda_s' or an explicit length [-Wsizeof-pointer-memaccess]
	  memset(pda, 0, sizeof(pda));
	                       ^

Fix this by passing in the size of the structure using sizeof(*pda)
instead.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/ia64/sn/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index 53b01b8e2f19..36182c84363c 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -579,7 +579,7 @@ void sn_cpu_init(void)
 		       (sn_prom_type == 1) ? "real" : "fake");
 	}
 
-	memset(pda, 0, sizeof(pda));
+	memset(pda, 0, sizeof(*pda));
 	if (ia64_sn_get_sn_info(0, &sn_hub_info->shub2,
 				&sn_hub_info->nasid_bitmask,
 				&sn_hub_info->nasid_shift,
-- 
2.0.2

