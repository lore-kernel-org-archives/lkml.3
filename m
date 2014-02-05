Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaBEJx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:53:59 -0500
Received: from 15.mo3.mail-out.ovh.net ([87.98.150.177]:35134 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751469AbaBEJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:53:55 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH] clk: add strict of_clk_init dependency check
Date: Wed,  5 Feb 2014 10:48:00 +0100
Message-Id: <1391593680-9388-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391554766-11285-1-git-send-email-gregory.clement@free-electrons.com>
References: <1391554766-11285-1-git-send-email-gregory.clement@free-electrons.com>
X-Ovh-Tracer-Id: 638948197669763073
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.500029/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parent dependency check is only available on the first parent of a given
clk.

Add support for strict dependency check: all parents of a given clk must be
initialized.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---

Hello Gregory,

This patch adds support for strict check on clk dependencies (check if all
parents specified by an DT clk node are initialized).

I'm not sure this is what you were expecting (maybe testing the first parent
is what you really want), so please feel free to tell me if I'm wrong.

Best Regards,

Boris

 drivers/clk/clk.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index beb0f8b..6849769 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2543,22 +2543,37 @@ static int parent_ready(struct device_node *np)
 {
 	struct of_phandle_args clkspec;
 	struct of_clk_provider *provider;
+	int num_parents;
+	bool found;
+	int i;
 
 	/*
 	 * If there is no clock parent, no need to wait for them, then
 	 * we can consider their absence as being ready
 	 */
-	if (of_parse_phandle_with_args(np, "clocks", "#clock-cells", 0,
-					&clkspec))
+	num_parents = of_count_phandle_with_args(np, "clocks", "#clock-cells");
+	if (num_parents <= 0)
 		return 1;
 
-	/* Check if we have such a provider in our array */
-	list_for_each_entry(provider, &of_clk_providers, link) {
-		if (provider->node == clkspec.np)
+	for (i = 0; i < num_parents; i++) {
+		if (of_parse_phandle_with_args(np, "clocks", "#clock-cells", i,
+					       &clkspec))
 			return 1;
+
+		/* Check if we have such a provider in our array */
+		found = false;
+		list_for_each_entry(provider, &of_clk_providers, link) {
+			if (provider->node == clkspec.np) {
+				found = true;
+				break;
+			}
+		}
+
+		if (!found)
+			return 0;
 	}
 
-	return 0;
+	return 1;
 }
 
 /**
-- 
1.7.9.5

