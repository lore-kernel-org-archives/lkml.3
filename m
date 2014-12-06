Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaLFPNE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:13:04 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47762 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752223AbaLFPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robh@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 29/66] of/base: Fix PowerPC address parsing hack
Date: Sat,  6 Dec 2014 16:07:21 +0100
Message-Id: <9a9c085844ed2582ae5cf5e5c11166adedc0a491.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/of/address.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 503b4e4cb551..f5582f3a06a4 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -401,6 +401,21 @@ static struct of_bus *of_match_bus(struct device_node *np)
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
 			    struct of_bus *pbus, __be32 *addr,
 			    int na, int ns, int pna, const char *rprop)
@@ -426,12 +441,10 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
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
2.1.3

