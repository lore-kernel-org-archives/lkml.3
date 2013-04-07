Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476Ab3DGWcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 18:32:51 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934446Ab3DGWct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 18:32:49 -0400
From: Richard Weinberger <richard@nod.at>
To: matt.fleming@intel.com
Cc: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.garrett@nebula.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH v2 1/2] efivars: Check max_size only if it is non-zero.
Date: Mon,  8 Apr 2013 00:32:17 +0200
Message-Id: <1365373938-25993-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some EFI implementations return always a MaximumVariableSize of 0,
check against max_size only if it is non-zero.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/firmware/efivars.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7acafb8..60c9899 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -449,7 +449,11 @@ check_var_size_locked(struct efivars *efivars, u32 attributes,
 	if (status != EFI_SUCCESS)
 		return status;
 
-	if (!storage_size || size > remaining_size || size > max_size ||
+	if (!max_size && remaining_size > size)
+		printk_once(KERN_ERR FW_BUG "Broken EFI implementation is returning MaxVariableSize=0\n");
+
+	if (!storage_size || size > remaining_size ||
+	    (max_size && size > max_size) ||
 	    (remaining_size - size) < (storage_size / 2))
 		return EFI_OUT_OF_RESOURCES;
 
-- 
1.8.1.4

