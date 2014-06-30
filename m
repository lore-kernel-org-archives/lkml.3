Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbaF3Mal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:30:41 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136AbaF3Mai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Andrzej Zaborowski <andrew.zaborowski@intel.com>,
        Matt Fleming <matt.fleming@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 178/181] efi-pstore: Fix an overflow on 32-bit builds
Date: Mon, 30 Jun 2014 13:53:19 +0200
Message-Id: <a7add90168e893800caaee32826f761501da9de6.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrzej Zaborowski <andrew.zaborowski@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/firmware/efi/efi-pstore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 743fd426f21b..b1b82e1dfb6b 100644
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
2.0.0

