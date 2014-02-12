Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbaBLU7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:59:14 -0500
Received: from mout.gmx.net ([212.227.15.18]:55944 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbaBLU7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:59:11 -0500
From: dl9pf@gmx.de
To: dl9pf@gmx.de
Cc: Behan Webster <behanw@converseincode.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, acpi: LLVMLinux: Remove nested functions from Thinkpad ACPI
Date: Wed, 12 Feb 2014 21:58:46 +0100
Message-Id: <1392238726-18787-1-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.8.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:4JMYTbtj0VxfdrlrpwMvhfM8iCgNicyJ7D194lDxQdwyC4eMSX/
 9qwfMC+CKnizNQGrE+c4jTKvO7Vfq6hivRkiHWOX2ZmGfL+VSsLy3EyuzLU5V312XsdHcjN
 LoPqvb0WXV021bVyKxhLN17x0NB9Pn0jYUZ00d6HMZHEPgfTybDwV0Mwd44hOkc9ItKu7lQ
 3NeY2SxvKK0We+prv+CNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

The only real change is passing in event_mask to the formerly nested functions.
Otherwise it's just moving around function and macro code.

This is the only place in the Linux kernel where nested functions are still in
use. Nested functions aren't part of the C standards, and complicate the
generated code. Although the Linux Kernel has never set out to be entirely C
standard compliant, it is increasingly compliant to the standard which is
supported by other compilers such as Clang. The LLVMLinux project is working on
being able to compile the Linux kernel with Clang. The use of nested functions
blocks this effort.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>

CC: David Woodhouse <David.Woodhouse@intel.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>
CC: ibm-acpi-devel@lists.sourceforge.net
CC: platform-driver-x86@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/platform/x86/thinkpad_acpi.c | 86 +++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 41 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index defb6af..e6e068e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -2321,53 +2321,55 @@ static void hotkey_read_nvram(struct tp_nvram_state *n, const u32 m)
 	}
 }
 
-static void hotkey_compare_and_issue_event(struct tp_nvram_state *oldn,
-					   struct tp_nvram_state *newn,
-					   const u32 event_mask)
-{
-
 #define TPACPI_COMPARE_KEY(__scancode, __member) \
-	do { \
-		if ((event_mask & (1 << __scancode)) && \
-		    oldn->__member != newn->__member) \
-			tpacpi_hotkey_send_key(__scancode); \
-	} while (0)
+do { \
+	if ((event_mask & (1 << __scancode)) && \
+	    oldn->__member != newn->__member) \
+		tpacpi_hotkey_send_key(__scancode); \
+} while (0)
 
 #define TPACPI_MAY_SEND_KEY(__scancode) \
-	do { \
-		if (event_mask & (1 << __scancode)) \
-			tpacpi_hotkey_send_key(__scancode); \
-	} while (0)
+do { \
+	if (event_mask & (1 << __scancode)) \
+		tpacpi_hotkey_send_key(__scancode); \
+} while (0)
 
-	void issue_volchange(const unsigned int oldvol,
-			     const unsigned int newvol)
-	{
-		unsigned int i = oldvol;
+static void issue_volchange(const unsigned int oldvol,
+			    const unsigned int newvol,
+			    const u32 event_mask)
+{
+	unsigned int i = oldvol;
 
-		while (i > newvol) {
-			TPACPI_MAY_SEND_KEY(TP_ACPI_HOTKEYSCAN_VOLUMEDOWN);
-			i--;
-		}
-		while (i < newvol) {
-			TPACPI_MAY_SEND_KEY(TP_ACPI_HOTKEYSCAN_VOLUMEUP);
-			i++;
-		}
+	while (i > newvol) {
+		TPACPI_MAY_SEND_KEY(TP_ACPI_HOTKEYSCAN_VOLUMEDOWN);
+		i--;
+	}
+	while (i < newvol) {
+		TPACPI_MAY_SEND_KEY(TP_ACPI_HOTKEYSCAN_VOLUMEUP);
+		i++;
 	}
+}
 
-	void issue_brightnesschange(const unsigned int oldbrt,
-				    const unsigned int newbrt)
-	{
-		unsigned int i = oldbrt;
+static void issue_brightnesschange(const unsigned int oldbrt,
+				   const unsigned int newbrt,
+				   const u32 event_mask)
+{
+	unsigned int i = oldbrt;
 
-		while (i > newbrt) {
-			TPACPI_MAY_SEND_KEY(TP_ACPI_HOTKEYSCAN_FNEND);
-			i--;
-		}
-		while (i < newbrt) {
-			TPACPI_MAY_SEND_KEY(TP_ACPI_HOTKEYSCAN_FNHOME);
-			i++;
-		}
+	while (i > newbrt) {
+		TPACPI_MAY_SEND_KEY(TP_ACPI_HOTKEYSCAN_FNEND);
+		i--;
 	}
+	while (i < newbrt) {
+		TPACPI_MAY_SEND_KEY(TP_ACPI_HOTKEYSCAN_FNHOME);
+		i++;
+	}
+}
+
+static void hotkey_compare_and_issue_event(struct tp_nvram_state *oldn,
+					   struct tp_nvram_state *newn,
+					   const u32 event_mask)
+{
 
 	TPACPI_COMPARE_KEY(TP_ACPI_HOTKEYSCAN_THINKPAD, thinkpad_toggle);
 	TPACPI_COMPARE_KEY(TP_ACPI_HOTKEYSCAN_FNSPACE, zoom_toggle);
@@ -2402,7 +2404,8 @@ static void hotkey_compare_and_issue_event(struct tp_nvram_state *oldn,
 		    oldn->volume_level != newn->volume_level) {
 			/* recently muted, or repeated mute keypress, or
 			 * multiple presses ending in mute */
-			issue_volchange(oldn->volume_level, newn->volume_level);
+			issue_volchange(oldn->volume_level, newn->volume_level,
+				event_mask);
 			TPACPI_MAY_SEND_KEY(TP_ACPI_HOTKEYSCAN_MUTE);
 		}
 	} else {
@@ -2412,7 +2415,8 @@ static void hotkey_compare_and_issue_event(struct tp_nvram_state *oldn,
 			TPACPI_MAY_SEND_KEY(TP_ACPI_HOTKEYSCAN_VOLUMEUP);
 		}
 		if (oldn->volume_level != newn->volume_level) {
-			issue_volchange(oldn->volume_level, newn->volume_level);
+			issue_volchange(oldn->volume_level, newn->volume_level,
+				event_mask);
 		} else if (oldn->volume_toggle != newn->volume_toggle) {
 			/* repeated vol up/down keypress at end of scale ? */
 			if (newn->volume_level == 0)
@@ -2425,7 +2429,7 @@ static void hotkey_compare_and_issue_event(struct tp_nvram_state *oldn,
 	/* handle brightness */
 	if (oldn->brightness_level != newn->brightness_level) {
 		issue_brightnesschange(oldn->brightness_level,
-				       newn->brightness_level);
+				       newn->brightness_level, event_mask);
 	} else if (oldn->brightness_toggle != newn->brightness_toggle) {
 		/* repeated key presses that didn't change state */
 		if (newn->brightness_level == 0)
-- 
1.8.4.5

