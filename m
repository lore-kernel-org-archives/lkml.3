Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387Ab3B1UwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:52:14 -0500
Received: from relay3.sgi.com ([192.48.152.1]:52174 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755160Ab3B1UwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:52:08 -0500
Date: Thu, 28 Feb 2013 14:52:06 -0600
From: Robin Holt <holt@sgi.com>
To: hpa@sgi.com, Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11 elilo.efi
Message-ID: <20130228205206.GC3438@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I revert that commit (5dcd14ecd4), It completes boot fine.  With that
commit applied, by ACPI tables (as well as much else) seems to be
completely messed up.  The ACPI XSDT table is removed, all the SRAT
is gone.  Much of the remaining ACPI table is messed up.  Some of the
EFI memory map is whacked.

If I change the following, things work:
diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 5b5e9cb..85337ab 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -19,9 +19,11 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 {
        if (boot_params->sentinel) {
                /*fields in boot_params are not valid, clear them */
+#if 0
                memset(&boot_params->olpc_ofw_header, 0,
                       (char *)&boot_params->alt_mem_k -
                        (char *)&boot_params->olpc_ofw_header);
+#endif
                memset(&boot_params->kbd_status, 0,
                       (char *)&boot_params->hdr -
                       (char *)&boot_params->kbd_status);

Thanks,
Robin
