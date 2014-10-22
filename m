Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaJVTNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:13:46 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64103 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbaJVTN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:13:28 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] eeepc-laptop: don't assume get_acpi succeeds
Date: Wed, 22 Oct 2014 21:12:43 +0200
Message-Id: <1414005163-3461-9-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In eeepc_hotk_thaw, we assume that get_acpi() will effectively return a
bool. However, it is possible that get_acpi() returns an error instead.
We should not be writing error values to the ACPI device, even though
it's quite possible that we couldn't contact the ACPI device in the
first place.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 275a239..14f79ef 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -911,7 +911,7 @@ static int eeepc_hotk_thaw(struct device *device)
 	struct eeepc_laptop *eeepc = dev_get_drvdata(device);
 
 	if (eeepc->wlan_rfkill) {
-		bool wlan;
+		int wlan;
 
 		/*
 		 * Work around bios bug - acpi _PTS turns off the wireless led
@@ -919,7 +919,8 @@ static int eeepc_hotk_thaw(struct device *device)
 		 * we should kick it ourselves in case hibernation is aborted.
 		 */
 		wlan = get_acpi(eeepc, CM_ASL_WLAN);
-		set_acpi(eeepc, CM_ASL_WLAN, wlan);
+		if (wlan >= 0)
+			set_acpi(eeepc, CM_ASL_WLAN, wlan);
 	}
 
 	return 0;
-- 
2.1.0

