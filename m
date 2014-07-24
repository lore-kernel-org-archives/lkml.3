Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935329AbaGXKTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:19:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54749 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932597AbaGXJrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 037/128] efi-pstore: Fix an overflow on 32-bit builds
Date: Thu, 24 Jul 2014 10:44:46 +0100
Message-Id: <1406195177-8656-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/firmware/efi/efi-pstore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index b438a3a4d0d8..14e83e955182 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -39,7 +39,7 @@ struct pstore_read_data {
 static inline u64 generic_id(unsigned long timestamp,
 			     unsigned int part, int count)
 {
-	return (timestamp * 100 + part) * 1000 + count;
+	return ((u64) timestamp * 100 + part) * 1000 + count;
 }
 
 static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
-- 
1.9.1

