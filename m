Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839AbaF1RyH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:54:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785AbaF1Rxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        David Rientjes <rientjes@google.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 3.15 139/139] efi-pstore: Fix an overflow on 32-bit builds
Date: Sat, 28 Jun 2014 10:48:20 -0700
Message-Id: <20140628174611.746220930@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/efi-pstore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


