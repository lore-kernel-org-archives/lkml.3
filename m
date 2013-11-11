Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3KKPVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:21:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab3KKPVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:21:21 -0500
From: Takashi Iwai <tiwai@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        amd64-microcode@amd64.org
Subject: [PATCH v2 3/3] firmware: Avoid bogus fallback warning
Date: Mon, 11 Nov 2013 16:21:18 +0100
Message-Id: <1384183278-19787-4-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384183278-19787-1-git-send-email-tiwai@suse.de>
References: <1384183278-19787-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit [3e358ac2bb5b: firmware: Be a bit more verbose about direct
firmware loading failure] introduced a new warning message about
falling back to user helper, but this isn't true when
CONFIG_FW_LOADER_USER_HELPER isn't set.

For avoiding the confusion, add a proper ifdef.  And now we can remove
the dummy fw_load_from_user_helper(), too, since it's no longer called
with CONFIG_FW_LOADER_USER_HELPER=n.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/firmware_class.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 7f48a6ffb0df..bb03c71bd94d 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -940,14 +940,6 @@ static void kill_requests_without_uevent(void)
 #endif
 
 #else /* CONFIG_FW_LOADER_USER_HELPER */
-static inline int
-fw_load_from_user_helper(struct firmware *firmware, const char *name,
-			 struct device *device, bool uevent, bool nowait,
-			 long timeout)
-{
-	return -ENOENT;
-}
-
 /* No abort during direct loading */
 #define is_fw_load_aborted(buf) false
 
@@ -1097,11 +1089,13 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	if (ret) {
 		dev_warn(device, "Direct firmware load failed with error %d\n",
 			 ret);
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 		if (fallback) {
 			dev_warn(device, "Falling back to user helper\n");
 			ret = fw_load_from_user_helper(fw, name, device,
 					       uevent, nowait, timeout);
 		}
+#endif
 	}
 
 	/* don't cache firmware handled without uevent */
-- 
1.8.4.2

