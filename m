Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaE3DUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 23:20:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbaE3DUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 23:20:32 -0400
Date: Fri, 30 May 2014 11:20:10 +0800
From: Dave Young <dyoung@redhat.com>
To: matt.fleming@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, vgoyal@redhat.com
Subject: [PATCH]x86 efi: do not export efi runtime map in case old map
Message-ID: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For ioremapped efi memory aka old_map the virt addresses are not persistant
across kexec reboot. kexec-tools will read the runtime maps from sysfs then
pass them to 2nd kernel and assuming kexec efi boot is ok. This will cause
kexec boot failure.

To address this issue do not export runtime maps in case efi old_map so
userspace can use no efi boot instead.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3781dd3..4d36932 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -919,6 +919,9 @@ static void __init save_runtime_map(void)
 	void *tmp, *p, *q = NULL;
 	int count = 0;
 
+	if (efi_enabled(EFI_OLD_MEMMAP))
+		return;
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 
-- 
1.8.3.1

