Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab3HNKy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:54:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34486 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab3HNKhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 26/75] ARM: poison the vectors page
Date: Wed, 14 Aug 2013 11:36:15 +0100
Message-Id: <1376476624-10011-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit f928d4f2a86f46b030fa0850385b4391fc2b5918 upstream.

Fill the empty regions of the vectors page with an exception generating
instruction.  This ensures that any inappropriate branch to the vector
page is appropriately trapped, rather than just encountering some code
to execute.  (The vectors page was filled with zero before, which
corresponds with the "andeq r0, r0, r0" instruction - a no-op.)

Acked-by Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/traps.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index eeb7520..eb460ac 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -792,10 +792,20 @@ void __init early_trap_init(void *vectors_base)
 	extern char __vectors_start[], __vectors_end[];
 	extern char __kuser_helper_start[], __kuser_helper_end[];
 	int kuser_sz = __kuser_helper_end - __kuser_helper_start;
+	unsigned i;
 
 	vectors_page = vectors_base;
 
 	/*
+	 * Poison the vectors page with an undefined instruction.  This
+	 * instruction is chosen to be undefined for both ARM and Thumb
+	 * ISAs.  The Thumb version is an undefined instruction with a
+	 * branch back to the undefined instruction.
+	 */
+	for (i = 0; i < PAGE_SIZE / sizeof(u32); i++)
+		((u32 *)vectors_base)[i] = 0xe7fddef1;
+
+	/*
 	 * Copy the vectors, stubs and kuser helpers (in entry-armv.S)
 	 * into the vector page, mapped at 0xffff0000, and ensure these
 	 * are visible to the instruction stream.
-- 
1.8.3.2

