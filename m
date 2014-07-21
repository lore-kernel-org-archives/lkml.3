Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbaGUOsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:48:47 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:37611 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaGUOsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:48:45 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, Marex Vasut <marex@denx.de>,
        Harro Haan <hrhaan@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>
Subject: [PATCH RFC 6/9] arm: mm: Avoid ioremap_page_range() for non-secure mappings
Date: Mon, 21 Jul 2014 15:47:17 +0100
Message-Id: <1405954040-30399-7-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
References: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioremap_page_range() cannot provide us memory with the the non-secure
section flag set unfortunately at present ioremap+MT_DEVICE_NS will
fallback to this function and spuriously return a virtual pointer to
what is effectively MT_DEVICE memory.

This patch makes the fallback to ioremap_page_range() ineffective; to
allocate MT_DEVICE_NS memory we must rely instead on the platform startup
code providing a suitable static mapping.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/mm/ioremap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index d1e5ad7..1cb12f8 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -319,6 +319,10 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 		err = remap_area_sections(addr, pfn, size, type);
 	} else
 #endif
+	if (type->prot_sect & PMD_SECT_NS)
+		/* required section flag is not achievable; give up */
+		return NULL;
+	else
 		err = ioremap_page_range(addr, addr + size, paddr,
 					 __pgprot(type->prot_pte));
 
-- 
1.9.3

