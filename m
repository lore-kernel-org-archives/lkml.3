Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161300AbaGRNXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:23:31 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17950 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030823AbaGRNSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:14 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David R. Piegdon" <lkml@p23q.org>,
        Tony Lindgren <tony@atomide.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 103/170] ARM: OMAP2+: Fix parser-bug in platform muxing code
Date: Fri, 18 Jul 2014 14:11:48 +0200
Message-Id: <ce2d2b635d6629a3626ceea60a2b05683d406fba.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David R. Piegdon" <lkml@p23q.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c021f241f4fab2bb4fc4120a38a828a03dd3f970 upstream.

Fix a parser-bug in the omap2 muxing code where muxtable-entries will be
wrongly selected if the requested muxname is a *prefix* of their
m0-entry and they have a matching mN-entry. Fix by additionally checking
that the length of the m0_entry is equal.

For example muxing of "dss_data2.dss_data2" on omap32xx will fail
because the prefix "dss_data2" will match the mux-entries "dss_data2" as
well as "dss_data20", with the suffix "dss_data2" matching m0 (for
dss_data2) and m4 (for dss_data20). Thus both are recognized as signal
path candidates:

Relevant muxentries from mux34xx.c:
        _OMAP3_MUXENTRY(DSS_DATA20, 90,
                "dss_data20", NULL, "mcspi3_somi", "dss_data2",
                "gpio_90", NULL, NULL, "safe_mode"),
        _OMAP3_MUXENTRY(DSS_DATA2, 72,
                "dss_data2", NULL, NULL, NULL,
                "gpio_72", NULL, NULL, "safe_mode"),

This will result in a failure to mux the pin at all:

 _omap_mux_get_by_name: Multiple signal paths (2) for dss_data2.dss_data2

Patch should apply to linus' latest master down to rather old linux-2.6
trees.

Signed-off-by: David R. Piegdon <lkml@p23q.org>
Cc: stable@vger.kernel.org
[tony@atomide.com: updated description to include full description]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-omap2/mux.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index f82cf878d6af..94c2f6d17dae 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -183,8 +183,10 @@ static int __init _omap_mux_get_by_name(struct omap_mux_partition *partition,
 		m0_entry = mux->muxnames[0];
 
 		/* First check for full name in mode0.muxmode format */
-		if (mode0_len && strncmp(muxname, m0_entry, mode0_len))
-			continue;
+		if (mode0_len)
+			if (strncmp(muxname, m0_entry, mode0_len) ||
+			    (strlen(m0_entry) != mode0_len))
+				continue;
 
 		/* Then check for muxmode only */
 		for (i = 0; i < OMAP_MUX_NR_MODES; i++) {
-- 
2.0.0

