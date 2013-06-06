Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3FFNwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:52:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:47560 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab3FFNww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:52:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,815,1363158000"; 
   d="scan'208";a="349228640"
From: Jani Nikula <jani.nikula@intel.com>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: chris@chris-wilson.co.uk, daniel@ffwll.ch, jani.nikula@intel.com
Subject: [PATCH 1/3] dmi: add support for exact DMI matches in addition to substring matching
Date: Thu,  6 Jun 2013 16:53:02 +0300
Message-Id: <23c4a83b2720b7275b39bd7cccdc44b28bcc9e5f.1370525922.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1370525922.git.jani.nikula@intel.com>
References: <cover.1370525922.git.jani.nikula@intel.com>
In-Reply-To: <cover.1370525922.git.jani.nikula@intel.com>
References: <cover.1370525922.git.jani.nikula@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmi_match() considers a substring match to be a successful match. This
is not always sufficient to distinguish between DMI data for different
systems. Add support for exact string matching using strcmp() in
addition to the substring matching using strstr().

The specific use case in the i915 driver is to allow us to use an exact
match for D510MO, without also incorrectly matching D510MOV:

{
	.ident = "Intel D510MO",
	.matches = {
		DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
		DMI_EXACT_MATCH(DMI_BOARD_NAME, "D510MO"),
	},
}

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/firmware/dmi_scan.c     |   12 +++++++++---
 include/linux/mod_devicetable.h |    6 ++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index b95159b..eb760a2 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -551,9 +551,15 @@ static bool dmi_matches(const struct dmi_system_id *dmi)
 		int s = dmi->matches[i].slot;
 		if (s == DMI_NONE)
 			break;
-		if (dmi_ident[s]
-		    && strstr(dmi_ident[s], dmi->matches[i].substr))
-			continue;
+		if (dmi_ident[s]) {
+			if (!dmi->matches[i].exact_match &&
+			    strstr(dmi_ident[s], dmi->matches[i].substr))
+				continue;
+			else if (dmi->matches[i].exact_match &&
+				 !strcmp(dmi_ident[s], dmi->matches[i].substr))
+				continue;
+		}
+
 		/* No match */
 		return false;
 	}
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index b508016..b3bd7e7 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -456,7 +456,8 @@ enum dmi_field {
 };
 
 struct dmi_strmatch {
-	unsigned char slot;
+	unsigned char slot:7;
+	unsigned char exact_match:1;
 	char substr[79];
 };
 
@@ -474,7 +475,8 @@ struct dmi_system_id {
  */
 #define dmi_device_id dmi_system_id
 
-#define DMI_MATCH(a, b)	{ a, b }
+#define DMI_MATCH(a, b)	{ .slot = a, .substr = b }
+#define DMI_EXACT_MATCH(a, b)	{ .slot = a, .substr = b, .exact_match = 1 }
 
 #define PLATFORM_NAME_SIZE	20
 #define PLATFORM_MODULE_PREFIX	"platform:"
-- 
1.7.9.5

