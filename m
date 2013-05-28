Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab3E1Dzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52522 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758834Ab3E1DyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Richard Weinberger" <richard@nod.at>,
        "Matt Fleming" <matt.fleming@intel.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.905104466@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [78/94] x86,efi: Check max_size only if it is non-zero.
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 7791c8423f1f7f4dad94e753bae67461d5b80be8 upstream.

Some EFI implementations return always a MaximumVariableSize of 0,
check against max_size only if it is non-zero.
My Intel DQ67SW desktop board has such an implementation.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/platform/efi/efi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -834,7 +834,12 @@ efi_status_t efi_query_variable_store(u3
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
 

