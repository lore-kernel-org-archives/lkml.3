Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab3KEPVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:21:45 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24539 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab3KEPVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:21:43 -0500
X-AuditID: cbfec7f4-b7f0a6d000007b1b-af-52790d05d963
From: Tomasz Figa <t.figa@samsung.com>
To: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 2/2] of: irq: Check for reg property presence only when parsing
 interrupt-map
Date: Tue, 05 Nov 2013 16:21:36 +0100
Message-id: <11085147.qYFvaZYATK@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <2177804.l4VGDTRFDu@amdc1227>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
 <20131104050455.GA3651@quad.lixom.net> <2177804.l4VGDTRFDu@amdc1227>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xq7qsvJVBBv1zFCw+NLUyW8w/co7V
	4sCfHYwWXw+vYLS4vGsOm8Wp65/ZHNg8et60sHrcubaHzePKiSZWj8+b5AJYorhsUlJzMstS
	i/TtErgylk2ezVJwgLfi06Uz7A2Mx7m6GDk5JARMJD592c0CYYtJXLi3ng3EFhJYyihx+YZR
	FyMXkN3FJHHp3wRmkASbgJrE54ZHYEUiAsoST9ougcWZBe4wSiw4nAViCwvES7xdvZIVxGYR
	UJXY+Gw6WA2vgJbEh039TCA2v4C6xLttT8FsUQE3iek/DoLVcALVPPraxASxuI9RYteBgywQ
	zYISPybfY4FYJi+xb/9UVghbS2L9zuNMExgFZyEpm4WkbBaSsgWMzKsYRVNLkwuKk9JzDfWK
	E3OLS/PS9ZLzczcxQkL9yw7GxcesDjEKcDAq8fA+OFseJMSaWFZcmXuIUYKDWUmE99j/iiAh
	3pTEyqrUovz4otKc1OJDjEwcnFINjLEWZ1bqGXrlps9QemrZYDM5MN+w4N2UzEd3/pfp35U+
	5GpyZJK58ZqtPxbbF2QvKPFiP7rziP7+yUuqFsr8mio7ZWa1zQbNY+f1/bSOLp7su+PBm7zi
	lwFh9/5pffvo/8Btr87fZzm1BbFp7R2vDovfSkiQj3PwKoxeyTSp8N/vqT1bfTcyfVRiKc5I
	NNRiLipOBACW6mgjUwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the of_irq_parse_raw() function to check for reg
property only when really parsing interrupt map property, as it is not
required otherwise and breaks existing device trees.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/of/irq.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 717eed4..72e9c51 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -147,17 +147,8 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 
 	pr_debug(" -> addrsize=%d\n", addrsize);
 
-	/* If we were passed no "reg" property and we attempt to parse
-	 * an interrupt-map, then #address-cells must be 0.
-	 * Fail if it's not.
-	 */
-	if (addr == NULL && addrsize != 0) {
-		pr_debug(" -> no reg passed in when needed !\n");
-		return -EINVAL;
-	}
-
 	/* Precalculate the match array - this simplifies match loop */
-	for (i = 0; i < addrsize; i++)
+	for (i = 0; i < addrsize && addr; i++)
 		initial_match_array[i] = addr[i];
 	for (i = 0; i < intsize; i++)
 		initial_match_array[addrsize + i] = cpu_to_be32(out_irq->args[i]);
@@ -184,6 +175,16 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 		}
 		imaplen /= sizeof(u32);
 
+		/*
+		 * If we were passed no "reg" property and we attempt to parse
+		 * an interrupt-map, then #address-cells must be 0.
+		 * Fail if it's not.
+		 */
+		if (addr == NULL && addrsize != 0) {
+			pr_debug(" -> no reg passed in when needed !\n");
+			return -EINVAL;
+		}
+
 		/* Look for a mask */
 		imask = of_get_property(ipar, "interrupt-map-mask", NULL);
 		if (!imask)
-- 
1.8.4.2


