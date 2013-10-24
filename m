Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3JXODk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:03:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab3JXODi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:03:38 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] thinkpad_acpi: Fix build error when CONFIG_SND_MAX_CARDS > 32
Date: Thu, 24 Oct 2013 16:06:32 +0200
Message-Id: <1382623592-31690-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SNDRV_CARDS can be specified via Kconfig since 3.11 kernel, so this
can be over 32bit integer range, which leads to a build error.

Cc: <stable@vger.kernel.org> [v3.11+]
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/platform/x86/thinkpad_acpi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 0b7efb2..79f77a7 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6421,7 +6421,12 @@ static struct ibm_struct brightness_driver_data = {
 #define TPACPI_ALSA_SHRTNAME "ThinkPad Console Audio Control"
 #define TPACPI_ALSA_MIXERNAME TPACPI_ALSA_SHRTNAME
 
-static int alsa_index = ~((1 << (SNDRV_CARDS - 3)) - 1); /* last three slots */
+#if SNDRV_CARDS <= 32
+#define DEFAULT_ALSA_IDX		~((1 << (SNDRV_CARDS - 3)) - 1)
+#else
+#define DEFAULT_ALSA_IDX		~((1 << (32 - 3)) - 1)
+#endif
+static int alsa_index = DEFAULT_ALSA_IDX; /* last three slots */
 static char *alsa_id = "ThinkPadEC";
 static bool alsa_enable = SNDRV_DEFAULT_ENABLE1;
 
-- 
1.8.4

