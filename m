Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123Ab3K0Bl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:41:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3K0A6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Michel Lespinasse <walken@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.10 68/80] powerpc: ppc64 address space capped at 32TB, mmap randomisation disabled
Date: Tue, 26 Nov 2013 16:57:37 -0800
Message-Id: <20131127005645.650924141@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/slice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -258,7 +258,7 @@ static bool slice_scan_available(unsigne
 		slice = GET_HIGH_SLICE_INDEX(addr);
 		*boundary_addr = (slice + end) ?
 			((slice + end) << SLICE_HIGH_SHIFT) : SLICE_LOW_TOP;
-		return !!(available.high_slices & (1u << slice));
+		return !!(available.high_slices & (1ul << slice));
 	}
 }
 


