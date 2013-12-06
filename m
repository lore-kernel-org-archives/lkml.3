Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161192Ab3LFNAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:00:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43680 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161175Ab3LFNAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 035/272] powerpc: ppc64 address space capped at 32TB, mmap randomisation disabled
Date: Fri,  6 Dec 2013 12:55:24 +0000
Message-Id: <1386334761-25517-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 5a049f14902982c26538250bdc8d54156d357252 upstream.

Commit fba2369e6ceb (mm: use vm_unmapped_area() on powerpc architecture)
has a bug in slice_scan_available() where we compare an unsigned long
(high_slices) against a shifted int. As a result, comparisons against
the top 32 bits of high_slices (representing the top 32TB) always
returns 0 and the top of our mmap region is clamped at 32TB

This also breaks mmap randomisation since the randomised address is
always up near the top of the address space and it gets clamped down
to 32TB.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/mm/slice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/slice.c b/arch/powerpc/mm/slice.c
index 3e99c14..7ce9cf3 100644
--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -258,7 +258,7 @@ static bool slice_scan_available(unsigned long addr,
 		slice = GET_HIGH_SLICE_INDEX(addr);
 		*boundary_addr = (slice + end) ?
 			((slice + end) << SLICE_HIGH_SHIFT) : SLICE_LOW_TOP;
-		return !!(available.high_slices & (1u << slice));
+		return !!(available.high_slices & (1ul << slice));
 	}
 }
 
-- 
1.8.3.2

