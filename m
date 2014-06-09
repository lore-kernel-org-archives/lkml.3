Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbaFIOvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:51:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47757 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaFIOu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:50:57 -0400
From: Andrzej Zaborowski <andrew.zaborowski@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Subject: [PATCH] pstore: Fix an overflow on 32-bit builds.
Date: Mon,  9 Jun 2014 16:50:40 +0200
Message-Id: <1402325440-26335-1-git-send-email-andrew.zaborowski@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend]
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
---
 drivers/firmware/efi/efi-pstore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.7.6

