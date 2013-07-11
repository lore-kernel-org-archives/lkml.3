Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab3GKO3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:29:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43288 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab3GKO1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Weinberger <richard@nod.at>, Matt Fleming <matt.fleming@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 92/98] x86,efi: Check max_size only if it is non-zero.
Date: Thu, 11 Jul 2013 15:25:02 +0100
Message-Id: <1373552708-15235-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 7791c8423f1f7f4dad94e753bae67461d5b80be8 upstream.

Some EFI implementations return always a MaximumVariableSize of 0,
check against max_size only if it is non-zero.
My Intel DQ67SW desktop board has such an implementation.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/platform/efi/efi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b8699b3..0eb3066 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -983,7 +983,12 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	if (status != EFI_SUCCESS)
 		return status;
 
-	if (!storage_size || size > remaining_size || size > max_size ||
+	if (!max_size && remaining_size > size)
+		printk_once(KERN_ERR FW_BUG "Broken EFI implementation"
+			    " is returning MaxVariableSize=0\n");
+
+	if (!storage_size || size > remaining_size ||
+	    (max_size && size > max_size) ||
 	    (remaining_size - size) < (storage_size / 2))
 		return EFI_OUT_OF_RESOURCES;
 
-- 
1.8.1.2

