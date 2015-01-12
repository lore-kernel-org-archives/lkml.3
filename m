Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbbALPiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:38:12 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52835 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbALPiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:38:08 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-99-54b3ea5dfe68
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: EXYNOS: Handle of of_iomap() failure
Date: Mon, 12 Jan 2015 16:37:45 +0100
Message-id: <1421077065-30175-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOJMWRmVeSWpSXmKPExsVy+t/xa7qxrzaHGJzcLW/x+oWhRf/j18wW
	mx5fY7W4vGsOm8WM8/uYLG5f5nVg82hp7mHz2LSqk81j85J6j74tqxg9Pm+SC2CN4rJJSc3J
	LEst0rdL4Mr48Woza0EDe8Xrbz+ZGhhfs3YxcnJICJhITDvczw5hi0lcuLeerYuRi0NIYCmj
	xNJNVxkhnD4miTNbX4JVsQkYS2xevgSsSkRgM6NEf+NusFHMAoYSP9/9ASsSFrCS2Hh8ATOI
	zSKgKrH12hQWEJtXwF1i18wtzBDr5CROHpvMOoGRewEjwypG0dTS5ILipPRcQ73ixNzi0rx0
	veT83E2MkMD4soNx8TGrQ4wCHIxKPLwTZDaHCLEmlhVX5h5ilOBgVhLhdS0DCvGmJFZWpRbl
	xxeV5qQWH2Jk4uCUamDMbAgJviv/10yIS23ZJet5Dqm7fFZeubpaxSGyLzx3lsTMHUsVpuom
	lr2ocy4TV9l/ScJn2tn+xKML61btll4gvWJ/S85Zu1nmJova0o7IJPmEMfVfmrfxtYfpD9bJ
	AbNMK+5mfv9ftb9J7k7dV78Fbzh6dovFTNG6FnXp+fr7xZX2Oo+Mza4osRRnJBpqMRcVJwIA
	pyPKO+oBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent possible NULL pointer dereference if of_iomap() fails. Handle
the error by skipping such power domain.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/mach-exynos/pm_domains.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
index 20f267121b3e..fd7640a6b503 100644
--- a/arch/arm/mach-exynos/pm_domains.c
+++ b/arch/arm/mach-exynos/pm_domains.c
@@ -128,6 +128,13 @@ static __init int exynos4_pm_init_power_domain(void)
 		pd->pd.name = kstrdup(np->name, GFP_KERNEL);
 		pd->name = pd->pd.name;
 		pd->base = of_iomap(np, 0);
+		if (!pd->base) {
+			dev_warn(&pdev->dev, "Failed to map memory\n");
+			kfree(pd);
+			of_node_put(np);
+			continue;
+		}
+
 		pd->pd.power_off = exynos_pd_power_off;
 		pd->pd.power_on = exynos_pd_power_on;
 
-- 
1.9.1

