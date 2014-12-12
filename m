Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbaLLGnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:43:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51810 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758937AbaLLGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:55 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Rob Herring" <robh@kernel.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.681735710@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 135/164] of/base: Fix PowerPC address parsing hack
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

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
[bwh: Backported to 3.2: use #ifdef because IS_ENABLED() only works for
 config symbols that are defined on the current architecture]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/of/address.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -333,6 +333,22 @@ static struct of_bus *of_match_bus(struc
 	return NULL;
 }
 
+static int of_empty_ranges_quirk(void)
+{
+#ifdef CONFIG_PPC
+	/* To save cycles, we cache the result */
+	static int quirk_state = -1;
+
+	if (quirk_state < 0)
+		quirk_state =
+			of_machine_is_compatible("Power Macintosh") ||
+			of_machine_is_compatible("MacRISC");
+	return quirk_state;
+#else
+	return false;
+#endif
+}
+
 static int of_translate_one(struct device_node *parent, struct of_bus *bus,
 			    struct of_bus *pbus, u32 *addr,
 			    int na, int ns, int pna, const char *rprop)
@@ -358,12 +374,10 @@ static int of_translate_one(struct devic
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

