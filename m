Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaLWKuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:50:44 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61112 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbaLWKsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:48:50 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-91-5499488e957d
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>, nm@ti.com,
        khilman@linaro.org
Subject: [PATCH v10 4/8] ARM: l2c: Get outer cache .write_sec callback from
 mach_desc only if not NULL
Date: Tue, 23 Dec 2014 11:48:32 +0100
Message-id: <1419331716-8972-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xa7p9HjNDDC5sNbf4O+kYu8Wj+Y+Z
	LXoXXGWz+Hp4BaPF2aY37BbbO2ewW0z5s5zJYtPja6wWl3fNYbOYvaSfxWLG+X1MFrcv81qc
	276FxWLtkbvsFkuvX2SyePPjLJPFqeuf2SxW7frDaLH/ipeDsMeaeWsYPVqae9g8fv+axOjx
	7eskFo/Lfb1MHou+Z3nsnHWX3ePOtT1sHpuX1HtcOdHE6tG3ZRWjx/Eb25k8Pm+SC+CN4rJJ
	Sc3JLEst0rdL4Mr4dWY6e8FvzopVs78zNjBu5ehi5OSQEDCR+Dd/PSOELSZx4d56ti5GLg4h
	gaWMEtfb5jBDOH1MEu3XpzCDVLEJGEp0ve1iA7FFBNwk/q07BNbBLDCNRWLTkfNgRcICGRL7
	Tj1i7WLk4GARUJXYdq8eJMwr4C5x7fZCVohtchL/X65gArE5BTwkTi7aDGYLAdVse3qQZQIj
	7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIXHxZQfj4mNWhxgFOBiVeHhPvp8RIsSa
	WFZcmXuIUYKDWUmE96X4zBAh3pTEyqrUovz4otKc1OJDjEwcnFINjJ2HX0Z8Kw88ncBw4y7v
	dlW/iZXsr1Skpko/lPyZcvEpk+fqL6VfTi1L/zsrLDhhbeoN1nniUXsTmoMlak4veszSFCd7
	6/YxuxUHeN3VWX5cVRcwmbDaw/p1pkrRHzeN9h8FrGbvAvZ0W/lp+ExYW671Q2pa5I0fM2dG
	/ii5v9G6hWmNDHPhJiWW4oxEQy3mouJEAEPJdetpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Certain platforms (i.e. Exynos) might need to set .write_sec callback
from firmware initialization which is happenning in .init_early callback
of machine descriptor. However current code will overwrite the pointer
with whatever is present in machine descriptor, even though it can be
already set earlier. This patch fixes this by making the assignment
conditional, depending on whether current .write_sec callback is NULL.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/kernel/irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index ad857bada96c..350f188c92d2 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -109,7 +109,8 @@ void __init init_IRQ(void)
 
 	if (IS_ENABLED(CONFIG_OF) && IS_ENABLED(CONFIG_CACHE_L2X0) &&
 	    (machine_desc->l2c_aux_mask || machine_desc->l2c_aux_val)) {
-		outer_cache.write_sec = machine_desc->l2c_write_sec;
+		if (!outer_cache.write_sec)
+			outer_cache.write_sec = machine_desc->l2c_write_sec;
 		ret = l2x0_of_init(machine_desc->l2c_aux_val,
 				   machine_desc->l2c_aux_mask);
 		if (ret)
-- 
1.9.2

