Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaLCLvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:51:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbaLCL1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:19 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 040/101] arm64: __clear_user: handle exceptions on strb
Date: Wed,  3 Dec 2014 12:26:02 +0100
Message-Id: <beb762ba2a940ce1f87a03b1c5820ce2d433db6e.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.1.3

