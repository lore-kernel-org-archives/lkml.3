Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab3KHCWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:22:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34881 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab3KHCVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:51 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>, <annndddrr@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Cornel Panceac <cpanceac@gmail.com>, Greg KH <greg@kroah.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 66/91] dmi: add support for exact DMI matches in addition to substring matching
Date: Thu,  7 Nov 2013 18:15:21 -0800
Message-Id: <1383876946-2396-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 5017b2851373ee15c7035151853bb1448800cae2 upstream.

dmi_match() considers a substring match to be a successful match.  This is
not always sufficient to distinguish between DMI data for different
systems.  Add support for exact string matching using strcmp() in addition
to the substring matching using strstr().

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
Cc: <annndddrr@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Cornel Panceac <cpanceac@gmail.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: 3.8-stable prereq for various commits ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/firmware/dmi_scan.c     | 12 +++++++++---
 include/linux/mod_devicetable.h |  6 ++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 4cd392d..2861ef4 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -534,9 +534,15 @@ static bool dmi_matches(const struct dmi_system_id *dmi)
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
index fed3def..163eb82 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -480,7 +480,8 @@ enum dmi_field {
 };
 
 struct dmi_strmatch {
-	unsigned char slot;
+	unsigned char slot:7;
+	unsigned char exact_match:1;
 	char substr[79];
 };
 
@@ -508,7 +509,8 @@ struct dmi_system_id {
 #define dmi_device_id dmi_system_id
 #endif
 
-#define DMI_MATCH(a, b)	{ a, b }
+#define DMI_MATCH(a, b)	{ .slot = a, .substr = b }
+#define DMI_EXACT_MATCH(a, b)	{ .slot = a, .substr = b, .exact_match = 1 }
 
 #define PLATFORM_NAME_SIZE	20
 #define PLATFORM_MODULE_PREFIX	"platform:"
-- 
1.8.1.2

