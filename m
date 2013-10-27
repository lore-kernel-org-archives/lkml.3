Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3J0Mze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 08:55:34 -0400
Received: from mout.gmx.net ([212.227.17.22]:54891 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab3J0Mzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 08:55:32 -0400
From: Andreas Werner <wernerandy@gmx.de>
To: tglx@linutronix.de
Cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, wernerandy@gmx.de
Subject: [PATCH] X86: MM: Add PAT Type write-through in combination with mtrr
Date: Sun, 27 Oct 2013 13:55:25 +0100
Message-Id: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
X-Mailer: git-send-email 1.8.4
X-Provags-ID: V03:K0:UWU8ETfk5NJf6LCIu7TtMKKnZMqmJr7LtJhYcMH+c/dMVqIZ0F3
 iVvfYh6I7RqrXoUT7Rn/GmzaL/kkjSRY+PSeDC/xc5e0Ci9z9QN6YjYNIJyq9/imzlbNJ8o
 WknskP4ReepBzi3wn30b6E+1a02KMGyav/EEYfx35eO2rZAXIidp27RdtjpOW9Y6MHExUoS
 6FDY9JIa0PColiVXIVtkA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Write-through memory type in combination with mtrr.
If you call ioremap_cache to request cachable memory (write-back) the
function tries to set the PAT to write-back only if the mtrr setting of
the requested region is also marked as Write-Back.
If the mttr regions are marked e.g. as Write-through or with other
types, the function will always return UC- memory.

If you check the Intel document " IA-32 SDM vol 3a table Effective
Memory Type", there
are many other combinations possible.

This patch will only add the following combination:
  PAT=Write-Back + MTRR=Write-Through = Effective Memory of
Write-Through

Tested on - Intel (R) Atom E680 (Tunnel Creek)
          - Intel (R) Core(TM)2 Duo

Signed-off-by: Andreas Werner <wernerandy@gmx.de>
---
 arch/x86/mm/pat.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 6574388..9cfe107 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -149,10 +149,15 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 		u8 mtrr_type;
 
 		mtrr_type = mtrr_type_lookup(start, end);
-		if (mtrr_type != MTRR_TYPE_WRBACK)
-			return _PAGE_CACHE_UC_MINUS;
 
-		return _PAGE_CACHE_WB;
+		switch (mtrr_type) {
+		case MTRR_TYPE_WRBACK:
+		case MTRR_TYPE_WRTHROUGH:
+		  return _PAGE_CACHE_WB;
+
+		default:
+		  return _PAGE_CACHE_UC_MINUS;
+		}
 	}
 
 	return req_type;
-- 
1.8.4

