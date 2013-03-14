Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab3CNKnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:43:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52058 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab3CNKiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 71/88] dmi_scan: fix missing check for _DMI_ signature in smbios_present()
Date: Thu, 14 Mar 2013 10:36:04 +0000
Message-Id: <1363257381-15900-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/firmware/dmi_scan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 982f1f5..4cd392d 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -442,7 +442,6 @@ static int __init dmi_present(const char __iomem *p)
 static int __init smbios_present(const char __iomem *p)
 {
 	u8 buf[32];
-	int offset = 0;
 
 	memcpy_fromio(buf, p, 32);
 	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
@@ -461,9 +460,9 @@ static int __init smbios_present(const char __iomem *p)
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
-- 
1.8.1.2

