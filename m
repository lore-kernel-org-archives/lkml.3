Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3KCMCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 07:02:31 -0500
Received: from mout.gmx.net ([212.227.15.15]:63783 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab3KCMCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 07:02:30 -0500
From: Andreas Werner <wernerandy@gmx.de>
To: tglx@linutronix.de
Cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, wernerandy@gmx.de,
        linux-kernel@vger.kernel.org, bp@alien8.de
Subject: [PATCH v2] X86: MM: Add PAT Type write-through in combination with mtrr
Date: Sun,  3 Nov 2013 13:02:22 +0100
Message-Id: <1383480142-5665-1-git-send-email-wernerandy@gmx.de>
X-Mailer: git-send-email 1.8.4
X-Provags-ID: V03:K0:oP3JP5mh4sgp9mcEHxEbCNskpLpicvb2z6prMI/FUxKDjA0bIEb
 bkdhM5SvnOYL5NzgJCeAtzHlc8vDXY4AMpmUV3L8Wx3EcN7JlcpqILf7fUM8MrcK0MgQkc8
 qL4ItVKpk+G+9ybWJqd4yhYqTyv5LsbeNmFWgFOhcW9OOc9Y6tIE1Uk2IQQ9Da3Pdfw/d+o
 s8br82QuOn1quUFlcHk3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revision 2:
	added comment in code.

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
PAT=Write-Back + MTRR=Write-Through.

Since marking IO Memory as cachable is not valid, WT is the
best way for caching/bursting on MMIO Devices.

Tested on - Intel (R) Atom E680 (Tunnel Creek)
          - Intel (R) Core(TM)2 Duo

Signed-off-by: Andreas Werner <wernerandy@gmx.de>
---
 arch/x86/mm/pat.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 6574388..cf05ee6 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -149,10 +149,22 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 		u8 mtrr_type;
 
 		mtrr_type = mtrr_type_lookup(start, end);
-		if (mtrr_type != MTRR_TYPE_WRBACK)
-			return _PAGE_CACHE_UC_MINUS;
 
-		return _PAGE_CACHE_WB;
+		switch (mtrr_type) {
+		case MTRR_TYPE_WRBACK:
+
+		/*
+		 * Return also WB (PAT) if MTTR is set to WT.
+		 * Since marking IO Memory as cachable is not valid,
+		 * WT is the best way for caching/bursting reads
+		 * on MMIO.
+		 */
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

