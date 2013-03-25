Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3CYBPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:15:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33834 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427Ab3CYBPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:14 -0400
Message-Id: <20130325010534.602354282@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:07:08 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [ 104/104] efivars: pstore: Do not check size when erasing variable
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

In 3.2, unlike mainline, efi_pstore_erase() calls efi_pstore_write()
with a size of 0, as the underlying EFI interface treats a size of 0
as meaning deletion.

This was not taken into account in my backport of commit d80a361d779a
'efi_pstore: Check remaining space with QueryVariableInfo() before
writing data'.  The size check should be omitted when erasing.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -787,19 +787,21 @@ static int efi_pstore_write(enum pstore_
 
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


