Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343AbbA1E0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:26:21 -0500
Received: from mail.kernel.org ([198.145.29.136]:41381 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965327AbbA1E0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:26:17 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robh@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 168/177] of/base: Fix PowerPC address parsing hack
Date: Wed, 28 Jan 2015 12:10:26 +0800
Message-Id: <1422418236-12852-259-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 746c9e9f92dde2789908e51a354ba90a1962a2eb upstream.

We have a historical hack that treats missing ranges properties as the
equivalent of an empty one. This is needed for ancient PowerMac "bad"
device-trees, and shouldn't be enabled for any other PowerPC platform,
otherwise we get some nasty layout of devices in sysfs or even
duplication when a set of otherwise identically named devices is
created multiple times under a different parent node with no ranges
property.

This fix is needed for the PowerNV i2c busses to be exposed properly
and will fix a number of other embedded cases.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/of/address.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 66d96f1..c059ce1 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -328,6 +328,21 @@ static struct of_bus *of_match_bus(struct device_node *np)
 	return NULL;
 }
 
+static int of_empty_ranges_quirk(void)
+{
+	if (IS_ENABLED(CONFIG_PPC)) {
+		/* To save cycles, we cache the result */
+		static int quirk_state = -1;
+
+		if (quirk_state < 0)
+			quirk_state =
+				of_machine_is_compatible("Power Macintosh") ||
+				of_machine_is_compatible("MacRISC");
+		return quirk_state;
+	}
+	return false;
+}
+
 static int of_translate_one(struct device_node *parent, struct of_bus *bus,
 			    struct of_bus *pbus, u32 *addr,
 			    int na, int ns, int pna, const char *rprop)
@@ -353,12 +368,10 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
 	 * This code is only enabled on powerpc. --gcl
 	 */
 	ranges = of_get_property(parent, rprop, &rlen);
-#if !defined(CONFIG_PPC)
-	if (ranges == NULL) {
+	if (ranges == NULL && !of_empty_ranges_quirk()) {
 		pr_err("OF: no ranges; cannot translate\n");
 		return 1;
 	}
-#endif /* !defined(CONFIG_PPC) */
 	if (ranges == NULL || rlen == 0) {
 		offset = of_read_number(addr, na);
 		memset(addr, 0, pna * 4);
-- 
1.9.1

