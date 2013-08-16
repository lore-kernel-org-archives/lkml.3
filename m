Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3HQAA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:00:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51810 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab3HPWkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 072/133] ARM: poison the vectors page
Date: Fri, 16 Aug 2013 15:33:34 -0700
Message-Id: <1376692475-28413-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kernel/traps.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index b0179b8..a4f84b0 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -824,10 +824,20 @@ void __init early_trap_init(void *vectors_base)
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
1.8.1.2

