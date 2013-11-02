Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3KBWhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 18:37:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58683 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab3KBWhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 18:37:11 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree-discuss@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 2/2] of/irq: Fix potential buffer overflow
Date: Sat,  2 Nov 2013 08:24:46 +0000
Message-Id: <1383380686-26979-3-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383380686-26979-1-git-send-email-grant.likely@linaro.org>
References: <1383380686-26979-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2361613206e6, "of/irq: Refactor interrupt-map parsing" introduced
a potential buffer overflow bug because it doesn't do sufficient range
checking on the input data. This patch adds the appropriate checking and
buffer size adjustments. If the bounds are out of range then warn
loudly. MAX_PHANDLE_ARGS should be sufficient. If it is not then the
value can be increased.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 drivers/of/irq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 52dba6a01423..d385bb824772 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -95,9 +95,9 @@ struct device_node *of_irq_find_parent(struct device_node *child)
 int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 {
 	struct device_node *ipar, *tnode, *old = NULL, *newpar = NULL;
-	__be32 initial_match_array[8];
+	__be32 initial_match_array[MAX_PHANDLE_ARGS];
 	const __be32 *match_array = initial_match_array;
-	const __be32 *tmp, *imap, *imask, dummy_imask[] = { ~0, ~0, ~0, ~0, ~0 };
+	const __be32 *tmp, *imap, *imask, dummy_imask[] = { [0 ... MAX_PHANDLE_ARGS] = ~0 };
 	u32 intsize = 1, addrsize, newintsize = 0, newaddrsize = 0;
 	int imaplen, match, i;
 
@@ -147,6 +147,10 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 
 	pr_debug(" -> addrsize=%d\n", addrsize);
 
+	/* Range check so that the temporary buffer doesn't overflow */
+	if (WARN_ON(addrsize + intsize > MAX_PHANDLE_ARGS))
+		goto fail;
+
 	/* Precalculate the match array - this simplifies match loop */
 	for (i = 0; i < addrsize; i++)
 		initial_match_array[i] = addr ? addr[i] : 0;
@@ -229,6 +233,8 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 			    newintsize, newaddrsize);
 
 			/* Check for malformed properties */
+			if (WARN_ON(newaddrsize + newintsize > MAX_PHANDLE_ARGS))
+				goto fail;
 			if (imaplen < (newaddrsize + newintsize))
 				goto fail;
 
-- 
1.8.1.2

