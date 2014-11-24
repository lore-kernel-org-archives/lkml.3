Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaKXPTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:19:05 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21083 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbaKXPSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:18:47 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-14-54734c548591
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC 1/2] clk: Allow overriding generic ops for clocks
Date: Mon, 24 Nov 2014 16:18:31 +0100
Message-id: <1416842312-4405-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com>
References: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xa7ohPsUhBns3KFu0XTnIbnH0d4HF
	6xeGFv2PXzNbPN38mMli0+NrrBaXd81hs5hxfh+TxdMJF9ksDr9pZ7VYtesPowO3x9/n11k8
	ds66y+6xaVUnm8eda3vYPDYvqffo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujMYt/1gK3olV
	HDj7nrWB8YdQFyMnh4SAicSFOxcYIWwxiQv31rN1MXJxCAksZZTY/m0RE4TTxyTx930DG0gV
	m4CxxOblS8CqRASmMUv8WXGcHSTBLGAo8fPdHyCbg0NYwF7iwiNhkDCLgKrE0cN3wEp4Bdwk
	Fv64CLVNTuLkscmsIDangLvEycen2UBahYBqbjzjmMDIu4CRYRWjaGppckFxUnqukV5xYm5x
	aV66XnJ+7iZGSCh+3cG49JjVIUYBDkYlHt4KzeIQIdbEsuLK3EOMEhzMSiK83V5AId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYxTBS8nJ8/u4t2wb/IuNY1fy2ueurE/up9w4JpPxjsb9YgLwV1P
	8qLv/Lu9NFNWYmFzuOxVd8Mg74cr6+7JzFvcvzeesWZ7wTOm05MXxRy9deF1KcfkxSah16vq
	pY5E7l33don90pNPsu8LWGkIWbHN3fzzOO+5xu3rni8IO+s1o+BfAUPh5utnlViKMxINtZiL
	ihMB8g0x5iMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For clocks depending on some other clock domain one may want to perform
specific ops before actual enable/disable of gate clock. Allow such case
by accepting supplied ops in new exported function:
clk_register_gate_ops().

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/clk-gate.c       | 16 +++++++++++++---
 include/linux/clk-provider.h |  5 +++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index 51fd87fb7ba6..51802af2d9e7 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -117,11 +117,12 @@ EXPORT_SYMBOL_GPL(clk_gate_ops);
  * @bit_idx: which bit in the register controls gating of this clock
  * @clk_gate_flags: gate-specific flags for this clock
  * @lock: shared register lock for this clock
+ * @ops: clk_ops to use for this clock
  */
-struct clk *clk_register_gate(struct device *dev, const char *name,
+struct clk *clk_register_gate_ops(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 bit_idx,
-		u8 clk_gate_flags, spinlock_t *lock)
+		u8 clk_gate_flags, spinlock_t *lock, const struct clk_ops *ops)
 {
 	struct clk_gate *gate;
 	struct clk *clk;
@@ -142,7 +143,7 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 	}
 
 	init.name = name;
-	init.ops = &clk_gate_ops;
+	init.ops = ops;
 	init.flags = flags | CLK_IS_BASIC;
 	init.parent_names = (parent_name ? &parent_name: NULL);
 	init.num_parents = (parent_name ? 1 : 0);
@@ -161,4 +162,13 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 
 	return clk;
 }
+EXPORT_SYMBOL_GPL(clk_register_gate_ops);
+
+struct clk *clk_register_gate(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		void __iomem *reg, u8 bit_idx,
+		u8 clk_gate_flags, spinlock_t *lock)
+{
+	return clk_register_gate_ops(dev, name, parent_name, flags, reg, bit_idx, clk_gate_flags, lock, &clk_gate_ops);
+}
 EXPORT_SYMBOL_GPL(clk_register_gate);
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index be21af149f11..6cfc77a9f339 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -290,11 +290,16 @@ struct clk_gate {
 #define CLK_GATE_HIWORD_MASK		BIT(1)
 
 extern const struct clk_ops clk_gate_ops;
+struct clk *clk_register_gate_ops(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		void __iomem *reg, u8 bit_idx,
+		u8 clk_gate_flags, spinlock_t *lock, const struct clk_ops *ops);
 struct clk *clk_register_gate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 bit_idx,
 		u8 clk_gate_flags, spinlock_t *lock);
 
+
 struct clk_div_table {
 	unsigned int	val;
 	unsigned int	div;
-- 
1.9.1

