Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaFEEjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:39:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaFEEVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Matt Fleming <matt.fleming@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 151/214] x86,efi: Check max_size only if it is non-zero.
Date: Wed,  4 Jun 2014 21:18:34 -0700
Message-Id: <20140605041700.121237528@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 7791c8423f1f7f4dad94e753bae67461d5b80be8 upstream.

Some EFI implementations return always a MaximumVariableSize of 0,
check against max_size only if it is non-zero.
My Intel DQ67SW desktop board has such an implementation.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -979,7 +979,12 @@ efi_status_t efi_query_variable_store(u3
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
 


