Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaIXLIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:08:11 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28616 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaIXLFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:05:51 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-3e-5422a58c2270
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com
Subject: [PATCH v5 2/7] ARM: l2c: Add interface to ask hypervisor to configure
 L2C
Date: Wed, 24 Sep 2014 13:05:36 +0200
Message-id: <1411556741-5810-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com>
References: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t/xa7o9S5VCDA4sYLV4NP8xs0Xvgqts
	Fmeb3rBbbO+cwW4x5c9yJotNj6+xWlzeNYfNYvaSfhaLGef3MVncvsxrcW77FhaLtUfuslu8
	7lvDbLFq1x9Gi/1XvBz4PVqae9g8vn2dxOJxua+XyWPR9yyPnbPusnvcubaHzWPzknqPvi2r
	GD2O39jO5PF5k1wAVxSXTUpqTmZZapG+XQJXxrrHO1gKHvNXvLmyiaWBsY+3i5GTQ0LARGLn
	o21sELaYxIV764FsLg4hgaWMEscOHWWCcPqYJFZP2g9WxSZgKNH1tgvMFhHIlvjxbTILSBGz
	QCuzxOMn31hBEsICIRL9a/8yg9gsAqoSD/e8A2vgFXCXmLB5DxPEOjmJ/y9XgNmcAh4Sjx//
	Y+xi5ADa5i7RtMllAiPvAkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghAf11B+PSY1aH
	GAU4GJV4eCeKK4UIsSaWFVfmHmKU4GBWEuF91QMU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwGjS
	v7xJ4MDU244FIm67BF9aLwmdPC1Jp+/JQg3GdfdKF+id0b40uTh43dFm2WTn7Vryaq63Cm+k
	fPva7BLitbP9it/cst0pzkLOvnez+su3Jq2pW9H1ayaHeoKd/W/e81IH90u7Vvewmd3seL6d
	Y7nb8ro7O+/6fk/LOby86iCPtitv+XODP0osxRmJhlrMRcWJAGKF6ldGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Because certain secure hypervisor do not allow writes to individual L2C
registers, but rather expect set of parameters to be passed as argument
to secure monitor calls, there is a need to provide an interface for the
L2C driver to ask the firmware to configure the hardware according to
specified parameters. This patch adds such.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/include/asm/outercache.h | 3 +++
 arch/arm/mm/cache-l2x0.c          | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outercache.h
index 891a56b35bcf..563b92fc2f41 100644
--- a/arch/arm/include/asm/outercache.h
+++ b/arch/arm/include/asm/outercache.h
@@ -23,6 +23,8 @@
 
 #include <linux/types.h>
 
+struct l2x0_regs;
+
 struct outer_cache_fns {
 	void (*inv_range)(unsigned long, unsigned long);
 	void (*clean_range)(unsigned long, unsigned long);
@@ -36,6 +38,7 @@ struct outer_cache_fns {
 
 	/* This is an ARM L2C thing */
 	void (*write_sec)(unsigned long, unsigned);
+	void (*configure)(const struct l2x0_regs *);
 };
 
 extern struct outer_cache_fns outer_cache;
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index b0735634f12c..84c6c55ab896 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -109,6 +109,11 @@ static inline void l2c_unlock(void __iomem *base, unsigned num)
 
 static void l2c_configure(void __iomem *base)
 {
+	if (outer_cache.configure) {
+		outer_cache.configure(&l2x0_saved_regs);
+		return;
+	}
+
 	if (l2x0_data->configure)
 		l2x0_data->configure(base);
 
@@ -909,6 +914,7 @@ static int __init __l2c_init(const struct l2c_init_data *data,
 
 	fns = data->outer_cache;
 	fns.write_sec = outer_cache.write_sec;
+	fns.configure = outer_cache.configure;
 	if (data->fixup)
 		data->fixup(l2x0_base, cache_id, &fns);
 
-- 
1.9.2

