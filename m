Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab3LBOij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:38:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab3LBOia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:38:30 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/4] microcode: Use request_firmware_direct()
Date: Mon,  2 Dec 2013 15:38:17 +0100
Message-Id: <1385995099-11901-3-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385995099-11901-1-git-send-email-tiwai@suse.de>
References: <1385995099-11901-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new helper, request_firmware_direct(), for avoiding the
lengthy timeout of non-existing firmware loads.  Especially the Intel
microcode driver suffers from this problem because each CPU triggers
the f/w loading, thus it ends up taking (literally) hours with many
cores.

Tested-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 arch/x86/kernel/microcode_amd.c   | 2 +-
 arch/x86/kernel/microcode_intel.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index c3d4cc972eca..22b3a1191ab3 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -430,7 +430,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 	if (c->x86 >= 0x15)
 		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
 
-	if (request_firmware(&fw, (const char *)fw_name, device)) {
+	if (request_firmware_direct(&fw, (const char *)fw_name, device)) {
 		pr_debug("failed to load file %s\n", fw_name);
 		goto out;
 	}
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 5fb2cebf556b..a276fa75d9b5 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -278,7 +278,7 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device,
 	sprintf(name, "intel-ucode/%02x-%02x-%02x",
 		c->x86, c->x86_model, c->x86_mask);
 
-	if (request_firmware(&firmware, name, device)) {
+	if (request_firmware_direct(&firmware, name, device)) {
 		pr_debug("data file %s load failed\n", name);
 		return UCODE_NFOUND;
 	}
-- 
1.8.4.4

