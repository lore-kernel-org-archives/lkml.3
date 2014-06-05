Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaFEEmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:42:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaFEEVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 145/214] efivars: pstore: Do not check size when erasing variable
Date: Wed,  4 Jun 2014 21:18:28 -0700
Message-Id: <20140605041659.314866078@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 80a19debc2f2d398cfa57fae97bc99826748a602 upstream.

In 3.2, unlike mainline, efi_pstore_erase() calls efi_pstore_write()
with a size of 0, as the underlying EFI interface treats a size of 0
as meaning deletion.

This was not taken into account in my backport of commit d80a361d779a
'efi_pstore: Check remaining space with QueryVariableInfo() before
writing data'.  The size check should be omitted when erasing.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efivars.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -778,19 +778,21 @@ static int efi_pstore_write(enum pstore_
 
 	spin_lock_irqsave(&efivars->lock, flags);
 
-	/*
-	 * Check if there is a space enough to log.
-	 * size: a size of logging data
-	 * DUMP_NAME_LEN * 2: a maximum size of variable name
-	 */
+	if (size) {
+		/*
+		 * Check if there is a space enough to log.
+		 * size: a size of logging data
+		 * DUMP_NAME_LEN * 2: a maximum size of variable name
+		 */
 
-	status = check_var_size_locked(efivars, PSTORE_EFI_ATTRIBUTES,
-					 size + DUMP_NAME_LEN * 2);
+		status = check_var_size_locked(efivars, PSTORE_EFI_ATTRIBUTES,
+					       size + DUMP_NAME_LEN * 2);
 
-	if (status) {
-		spin_unlock_irqrestore(&efivars->lock, flags);
-		*id = part;
-		return -ENOSPC;
+		if (status) {
+			spin_unlock_irqrestore(&efivars->lock, flags);
+			*id = part;
+			return -ENOSPC;
+		}
 	}
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)


