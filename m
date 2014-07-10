Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaGJRUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:20:38 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45176 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaGJRUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:20:37 -0400
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH] platform/chrome: pstore: fix dmi table to match all chrome systems
Date: Thu, 10 Jul 2014 10:20:38 -0700
Message-Id: <1405012838-31015-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 2.0.1.473.gc4d58ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turns out that DMI_SYSTEM_VENDOR is actually the native vendor of each
Chromebook/box. I tested the original patch on a Pixel that -- surprise,
has Google as vendor. *facepalm*.

The only other data I can think of to probe on is Google_* in the version
string.  Checking with our firmware team, all systems should have this
and nothing else than Chrome hardware should have the coreboot + Google_*
combination to date.

So, we'll switch to this. For future platforms we are going to move to
using an ACPI device to configure this instead of a DMI table (yay!),
so longer-term that will sort itself out.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/platform/chrome/chromeos_pstore.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/chrome/chromeos_pstore.c b/drivers/platform/chrome/chromeos_pstore.c
index e0e0e65cf442..34749200e4ab 100644
--- a/drivers/platform/chrome/chromeos_pstore.c
+++ b/drivers/platform/chrome/chromeos_pstore.c
@@ -16,23 +16,13 @@
 static struct dmi_system_id chromeos_pstore_dmi_table[] __initdata = {
 	{
 		/*
-		 * Today all Chromebooks/boxes ship with GOOGLE as vendor and
+		 * Today all Chromebooks/boxes ship with Google_* as version and
 		 * coreboot as bios vendor. No other systems with this
 		 * combination are known to date.
 		 */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
-			DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
-		},
-	},
-	{
-		/*
-		 * The first Samsung Chromebox and Chromebook Series 5 550 use
-		 * coreboot but with Samsung as the system vendor.
-		 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG"),
 			DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
+			DMI_MATCH(DMI_BIOS_VERSION, "Google_"),
 		},
 	},
 	{
-- 
2.0.1.473.gc4d58ca

