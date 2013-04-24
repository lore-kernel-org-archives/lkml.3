Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab3DXPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:16:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab3DXPQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:16:58 -0400
Date: Wed, 24 Apr 2013 11:16:52 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] efi: Check EFI revision in setup_efi_vars
Message-ID: <20130424151652.GD15272@hansolo.jdub.homelinux.org>
References: <20130424143738.GB15272@hansolo.jdub.homelinux.org>
 <5177EFCE.80104@intel.com>
 <20130424145449.GC15272@hansolo.jdub.homelinux.org>
 <5177F2C3.5080907@intel.com>
 <1366815685.9976.0.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366815685.9976.0.camel@x230>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to check the runtime sys_table for the EFI version the firmware
specifies instead of just checking for a NULL QueryVariableInfo.  Older
implementations of EFI don't have QueryVariableInfo but the runtime is
a smaller structure, so the pointer to it may be pointing off into garbage.

This is apparently the case with several Apple firmwares that support EFI
1.10, and the current check causes them to no longer boot.  Fix based on
a suggestion from Matthew Garrett.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 v2: Drop the unnecessary NULL check

 arch/x86/boot/compressed/eboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 8615f75..4060c8d 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -258,7 +258,7 @@ static efi_status_t setup_efi_vars(struct boot_params *params)
 	u64 store_size, remaining_size, var_size;
 	efi_status_t status;
 
-	if (!sys_table->runtime->query_variable_info)
+	if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
 	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
-- 
1.8.1.4

