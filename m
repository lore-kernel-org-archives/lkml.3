Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734AbaGOVfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:35:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54270 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757395AbaGOVe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:34:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 195/198] efi-pstore: Fix an overflow on 32-bit builds
Date: Tue, 15 Jul 2014 14:31:05 -0700
Message-Id: <1405459868-15089-196-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Zaborowski <andrew.zaborowski@intel.com>

commit 783ee43118dc773bc8b0342c5b230e017d5a04d0 upstream.

In generic_id the long int timestamp is multiplied by 100000 and needs
an explicit cast to u64.

Without that the id in the resulting pstore filename is wrong and
userspace may have problems parsing it, but more importantly files in
pstore can never be deleted and may fill the EFI flash (brick device?).
This happens because when generic pstore code wants to delete a file,
it passes the id to the EFI backend which reinterpretes it and a wrong
variable name is attempted to be deleted.  There's no error message but
after remounting pstore, deleted files would reappear.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/firmware/efi/efi-pstore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 4b9dc83..e992abc 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -40,7 +40,7 @@ struct pstore_read_data {
 static inline u64 generic_id(unsigned long timestamp,
 			     unsigned int part, int count)
 {
-	return (timestamp * 100 + part) * 1000 + count;
+	return ((u64) timestamp * 100 + part) * 1000 + count;
 }
 
 static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
-- 
1.9.1

