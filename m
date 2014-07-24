Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934988AbaGXKQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:16:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54822 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaGXJrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David R. Piegdon" <lkml@p23q.org>, Tony Lindgren <tony@atomide.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 051/128] ARM: OMAP2+: Fix parser-bug in platform muxing code
Date: Thu, 24 Jul 2014 10:45:00 +0100
Message-Id: <1406195177-8656-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David R. Piegdon" <lkml@p23q.org>

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
[tony@atomide.com: updated description to include full description]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

