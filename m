Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaGGXzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:55:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbaGGXy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David R. Piegdon" <lkml@p23q.org>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.14 57/94] ARM: OMAP2+: Fix parser-bug in platform muxing code
Date: Mon,  7 Jul 2014 16:57:47 -0700
Message-Id: <20140707235758.470589428@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org
[tony@atomide.com: updated description to include full description]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/mux.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -183,8 +183,10 @@ static int __init _omap_mux_get_by_name(
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


