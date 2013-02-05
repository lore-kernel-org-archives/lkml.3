Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab3BEWNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:13:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48303 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097Ab3BEWNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:13:31 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ben Hutchings <ben@decadent.org.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 93/93] ARM: 7628/1: head.S: map one extra section for the ATAG/DTB area
Date: Tue,  5 Feb 2013 20:07:22 -0200
Message-Id: <1360102042-10732-94-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nicolas.pitre@linaro.org>

commit 6f16f4998f98e42e3f2dedf663cfb691ff0324af upstream.

We currently use a temporary 1MB section aligned to a 1MB boundary for
mapping the provided device tree until the final page table is created.
However, if the device tree happens to cross that 1MB boundary, the end
of it remains unmapped and the kernel crashes when it attempts to access
it.  Given no restriction on the location of that DTB, it could end up
with only a few bytes mapped at the end of a section.

Solve this issue by mapping two consecutive sections.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Tested-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[bwh: Backported to 3.2:
 - Adjust context
 - The mapping is not conditional; drop the 'ne' suffixes]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[ herton: same backport applies to 3.5, with context adjusted on comment ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/kernel/head.S |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 835898e..458b8d3 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -254,6 +254,7 @@ __create_page_tables:
 	/*
 	 * Then map boot params address in r2 or the first 1MB (2MB with LPAE)
 	 * of ram if boot params address is not specified.
+	 * We map 2 sections in case the ATAGs/DTB crosses a section boundary.
 	 */
 	mov	r0, r2, lsr #SECTION_SHIFT
 	movs	r0, r0, lsl #SECTION_SHIFT
@@ -262,6 +263,8 @@ __create_page_tables:
 	add	r3, r3, #PAGE_OFFSET
 	add	r3, r4, r3, lsr #(SECTION_SHIFT - PMD_ORDER)
 	orr	r6, r7, r0
+	str	r6, [r3], #1 << PMD_ORDER
+	add	r6, r6, #1 << SECTION_SHIFT
 	str	r6, [r3]
 
 #ifdef CONFIG_DEBUG_LL
-- 
1.7.9.5

