Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3CREhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:37:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33666 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224Ab3CREbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:08 -0400
Message-Id: <20130318042147.062647496@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:12 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Tim McGrath <tmhikaru@gmail.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 28/82] dmi_scan: fix missing check for _DMI_ signature in smbios_present()
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit a40e7cf8f06b4e322ba902e4e9f6a6b0c2daa907 upstream.

Commit 9f9c9cbb6057 ("drivers/firmware/dmi_scan.c: fetch dmi version
from SMBIOS if it exists") hoisted the check for "_DMI_" into
dmi_scan_machine(), which means that we don't bother to check for
"_DMI_" at offset 16 in an SMBIOS entry.  smbios_present() may also call
dmi_present() for an address where we found "_SM_", if it failed further
validation.

Check for "_DMI_" in smbios_present() before calling dmi_present().

[akpm@linux-foundation.org: fix build]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Reported-by: Tim McGrath <tmhikaru@gmail.com>
Tested-by: Tim Mcgrath <tmhikaru@gmail.com>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 drivers/firmware/dmi_scan.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -442,7 +442,6 @@ static int __init dmi_present(const char
 static int __init smbios_present(const char __iomem *p)
 {
 	u8 buf[32];
-	int offset = 0;
 
 	memcpy_fromio(buf, p, 32);
 	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
@@ -461,9 +460,9 @@ static int __init smbios_present(const c
 			dmi_ver = 0x0206;
 			break;
 		}
-		offset = 16;
+		return memcmp(p + 16, "_DMI_", 5) || dmi_present(p + 16);
 	}
-	return dmi_present(buf + offset);
+	return 1;
 }
 
 void __init dmi_scan_machine(void)


