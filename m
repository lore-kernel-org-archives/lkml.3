Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaKYKnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59026 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaKYKnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kyle McMartin <kyle@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 203/254] arm64: __clear_user: handle exceptions on strb
Date: Tue, 25 Nov 2014 10:39:13 +0000
Message-Id: <1416912004-5928-204-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle McMartin <kyle@redhat.com>

commit 97fc15436b36ee3956efad83e22a557991f7d19d upstream.

ARM64 currently doesn't fix up faults on the single-byte (strb) case of
__clear_user... which means that we can cause a nasty kernel panic as an
ordinary user with any multiple PAGE_SIZE+1 read from /dev/zero.
i.e.: dd if=/dev/zero of=foo ibs=1 count=1 (or ibs=65537, etc.)

This is a pretty obscure bug in the general case since we'll only
__do_kernel_fault (since there's no extable entry for pc) if the
mmap_sem is contended. However, with CONFIG_DEBUG_VM enabled, we'll
always fault.

if (!down_read_trylock(&mm->mmap_sem)) {
	if (!user_mode(regs) && !search_exception_tables(regs->pc))
		goto no_context;
retry:
	down_read(&mm->mmap_sem);
} else {
	/*
	 * The above down_read_trylock() might have succeeded in
	 * which
	 * case, we'll have missed the might_sleep() from
	 * down_read().
	 */
	might_sleep();
	if (!user_mode(regs) && !search_exception_tables(regs->pc))
		goto no_context;
}

Fix that by adding an extable entry for the strb instruction, since it
touches user memory, similar to the other stores in __clear_user.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Reported-by: Miloš Prchlík <mprchlik@redhat.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/lib/clear_user.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/lib/clear_user.S b/arch/arm64/lib/clear_user.S
index 6e0ed93d51fe..c17967fdf5f6 100644
--- a/arch/arm64/lib/clear_user.S
+++ b/arch/arm64/lib/clear_user.S
@@ -46,7 +46,7 @@ USER(9f, strh	wzr, [x0], #2	)
 	sub	x1, x1, #2
 4:	adds	x1, x1, #1
 	b.mi	5f
-	strb	wzr, [x0]
+USER(9f, strb	wzr, [x0]	)
 5:	mov	x0, #0
 	ret
 ENDPROC(__clear_user)
-- 
2.1.0

