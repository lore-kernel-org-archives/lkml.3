Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030211Ab3BANHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:07:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:44323 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030197Ab3BANHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:07:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 12/89] ARM: 7628/1: head.S: map one extra section for the ATAG/DTB area
Date: Fri,  1 Feb 2013 14:07:27 +0100
Message-Id: <20130201130208.341617559@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/head.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -246,6 +246,7 @@ __create_page_tables:
 
 	/*
 	 * Then map boot params address in r2 if specified.
+	 * We map 2 sections in case the ATAGs/DTB crosses a section boundary.
 	 */
 	mov	r0, r2, lsr #SECTION_SHIFT
 	movs	r0, r0, lsl #SECTION_SHIFT
@@ -253,6 +254,8 @@ __create_page_tables:
 	addne	r3, r3, #PAGE_OFFSET
 	addne	r3, r4, r3, lsr #(SECTION_SHIFT - PMD_ORDER)
 	orrne	r6, r7, r0
+	strne	r6, [r3], #1 << PMD_ORDER
+	addne	r6, r6, #1 << SECTION_SHIFT
 	strne	r6, [r3]
 
 #ifdef CONFIG_DEBUG_LL


