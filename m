Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104AbaDJDXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:23:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934670AbaDJDV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 037/134] ARM: 7628/1: head.S: map one extra section for the ATAG/DTB area
Date: Wed,  9 Apr 2014 20:22:33 -0700
Message-Id: <20140410032304.727278158@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[yangyl: Backported to 3.4: Adjust context]
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/head.S |    3 +++
 1 file changed, 3 insertions(+)

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


