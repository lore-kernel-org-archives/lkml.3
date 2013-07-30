Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3G3MZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:25:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15861 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab3G3MZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:25:17 -0400
X-IronPort-AV: E=Sophos;i="4.89,778,1367971200"; 
   d="scan'208";a="38226795"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <xen-devel@lists.xen.org>
CC: Ben Guthro <benjamin.guthro@citrix.com>,
        <tboot-devel@lists.sourceforge.net>, Gang Wei <gang.wei@intel.com>
Subject: [PATCH v8 2/3] x86/tboot: Fail extended mode reduced hardware sleep
Date: Tue, 30 Jul 2013 08:24:53 -0400
Message-ID: <1375187094-19357-3-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375187094-19357-1-git-send-email-benjamin.guthro@citrix.com>
References: <1375187094-19357-1-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register for the extended sleep callback from acpi.
As tboot currently does not support the reduced hardware sleep
interface, fail this extended call.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
Cc: tboot-devel@lists.sourceforge.net
Cc: Gang Wei <gang.wei@intel.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/tboot.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index addf7b5..ade00c8 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -301,6 +301,17 @@ static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
 	return 0;
 }
 
+static int tboot_extended_sleep(u8 sleep_state, u32 val_a, u32 val_b)
+{
+	if (!tboot_enabled())
+		return 0;
+
+	pr_warning("tboot is not able to suspend on platforms with"
+		   " reduced hardware sleep (ACPIv5). Please contact"
+		   " tboot-devel@lists.sourceforge.net mailing list.");
+	return -ENODEV;
+}
+
 static atomic_t ap_wfs_count;
 
 static int tboot_wait_for_aps(int num_aps)
@@ -422,6 +433,7 @@ static __init int tboot_late_init(void)
 #endif
 
 	acpi_os_set_prepare_sleep(&tboot_sleep);
+	acpi_os_set_prepare_extended_sleep(&tboot_extended_sleep);
 	return 0;
 }
 
-- 
1.7.9.5

