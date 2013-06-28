Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab3F1UOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:14:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab3F1UOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:14:17 -0400
From: Lenny Szubowicz <lszubowi@redhat.com>
To: tony.luck@intel.com, cbouatmailru@gmail.com, matt.fleming@intel.com,
        linux-kernel@vger.kernel.org
Cc: n.hamaguchi@jp.fujitsu.com, dzickus@redhat.com
Subject: [PATCH 3/3] efivars: If pstore_register fails, free unneeded pstore buffer
Date: Fri, 28 Jun 2013 16:14:11 -0400
Message-Id: <1372450451-8790-4-git-send-email-lszubowi@redhat.com>
In-Reply-To: <1372450451-8790-1-git-send-email-lszubowi@redhat.com>
References: <1372450451-8790-1-git-send-email-lszubowi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch 3/3 of a patch set that cleans up pstore_register failure paths.

If efivars fails to register with pstore, there is no point to keeping
the 4 KB buffer around. It's only used by the pstore read/write routines.

Signed-off-by: Lenny Szubowicz <lszubowi@redhat.com>
Reported-by: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
---
 drivers/firmware/efi/efi-pstore.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 202d2c8..66c0c76 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -236,7 +236,11 @@ static __init int efivars_pstore_init(void)
 	efi_pstore_info.bufsize = 1024;
 	spin_lock_init(&efi_pstore_info.buf_lock);
 
-	pstore_register(&efi_pstore_info);
+	if (pstore_register(&efi_pstore_info)) {
+		kfree(efi_pstore_info.buf);
+		efi_pstore_info.buf = NULL;
+		efi_pstore_info.bufsize = 0;
+	}
 
 	return 0;
 }
-- 
1.8.2.1

