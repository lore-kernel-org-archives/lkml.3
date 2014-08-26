Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbaHZOUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:20:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23792 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463AbaHZOSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:18:10 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-07-53fc971e6864
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v4 2/7] ARM: l2c: Add interface to ask hypervisor to configure
 L2C
Date: Tue, 26 Aug 2014 16:17:55 +0200
Message-id: <1409062680-15906-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.4
In-reply-to: <1409062680-15906-1-git-send-email-t.figa@samsung.com>
References: <1409062680-15906-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t/xK7py0/8EG6ydr2fxaP5jZoveBVfZ
	LLZ3zmC3mPJnOZPFpsfXWC0u75rDZjF7ST+LxYzz+5gsbl/mtTi3fQuLxdojd9ktXvetYbZY
	P+M1i8WqXX8YLfZf8XLg92hp7mHz+PZ1EovH5b5eJo9F37M8ds66y+5x59oeNo/NS+o9+ras
	YvQ4fmM7k8fnTXIBXFFcNimpOZllqUX6dglcGQd/L2UqeMlX8aF5G1MD4wKeLkYODgkBE4kd
	0/O7GDmBTDGJC/fWs3UxcnEICSxllJjw9R4LhNPHJHFl/Xd2kCo2ATWJzw2P2EBsEQFVic9t
	C8DizAIHmCXaVwaA2MICIRL7ZxxjAVnAAlQz47ExSJhXwEniYtcFdohlchKrNu5jArE5BZwl
	9nzpYwaxhYBqnuzfxz6BkXcBI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJBg/rqDcekx
	q0OMAhyMSjy8D9J+BwuxJpYVV+YeYpTgYFYS4f2R9CdYiDclsbIqtSg/vqg0J7X4ECMTB6dU
	A+NSl3msy09tLn/p/Pr68fWtGl8ULrLtjjvt/F5T4E4ny/uGCUf9noZ949bedmvnvfpIe5nr
	E92KmGfPeLfnz5GoNUaGv2cva46q41GUFA/p47uopvkhzjLz1F4Bnybryyvfii1aU/53T+7N
	Ot+JTh0ckxOTFueVP5VbkN1xUUDu2OMtl99IZUxWYinOSDTUYi4qTgQAX6pZ3UQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because certain secure hypervisor do not allow writes to individual L2C
registers, but rather expect set of parameters to be passed as argument
to secure monitor calls, there is a need to provide an interface for the
L2C driver to ask the firmware to configure the hardware according to
specified parameters. This patch adds such.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/include/asm/outercache.h | 3 +++
 arch/arm/mm/cache-l2x0.c          | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outercache.h
index 891a56b..563b92f 100644
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
index b073563..84c6c55 100644
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
2.0.4

