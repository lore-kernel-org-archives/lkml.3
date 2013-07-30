Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab3G3MZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:25:46 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10356 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab3G3MZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:25:17 -0400
X-IronPort-AV: E=Sophos;i="4.89,778,1367971200"; 
   d="scan'208";a="40169453"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <xen-devel@lists.xen.org>
CC: Ben Guthro <benjamin.guthro@citrix.com>
Subject: [PATCH v8 3/3] xen/acpi: notify xen when reduced hardware sleep is available
Date: Tue, 30 Jul 2013 08:24:54 -0400
Message-ID: <1375187094-19357-4-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375187094-19357-1-git-send-email-benjamin.guthro@citrix.com>
References: <1375187094-19357-1-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of acpi_os_prepare_extended_sleep callback to notify xen
to make use of the reduced hardware sleep functionality

The xen hypervisor change underlying this is commit 62d1a69
("ACPI: support v5 (reduced HW) sleep interface") on the master
branch of git://xenbits.xen.org/xen.git.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
Acked-by: Konrad Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/acpi.c               |   41 ++++++++++++++++++++++++++------------
 include/xen/acpi.h               |    8 ++++++--
 include/xen/interface/platform.h |    7 ++++---
 3 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/drivers/xen/acpi.c b/drivers/xen/acpi.c
index 119d42a..90307c0 100644
--- a/drivers/xen/acpi.c
+++ b/drivers/xen/acpi.c
@@ -35,28 +35,43 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 
-int xen_acpi_notify_hypervisor_state(u8 sleep_state,
-				     u32 pm1a_cnt, u32 pm1b_cnt)
+static int xen_acpi_notify_hypervisor_state(u8 sleep_state,
+					    u32 val_a, u32 val_b,
+					    bool extended)
 {
+	unsigned int bits = extended ? 8 : 16;
+
 	struct xen_platform_op op = {
 		.cmd = XENPF_enter_acpi_sleep,
 		.interface_version = XENPF_INTERFACE_VERSION,
-		.u = {
-			.enter_acpi_sleep = {
-				.pm1a_cnt_val = (u16)pm1a_cnt,
-				.pm1b_cnt_val = (u16)pm1b_cnt,
-				.sleep_state = sleep_state,
-			},
+		.u.enter_acpi_sleep = {
+			.val_a = (u16)val_a,
+			.val_b = (u16)val_b,
+			.sleep_state = sleep_state,
+			.flags = extended ? XENPF_ACPI_SLEEP_EXTENDED : 0,
 		},
 	};
 
-	if ((pm1a_cnt & 0xffff0000) || (pm1b_cnt & 0xffff0000)) {
-		WARN(1, "Using more than 16bits of PM1A/B 0x%x/0x%x!"
-		     "Email xen-devel@lists.xensource.com  Thank you.\n", \
-		     pm1a_cnt, pm1b_cnt);
+	if (WARN((val_a & (~0 << bits)) || (val_b & (~0 << bits)),
+		 "Using more than %u bits of sleep control values %#x/%#x!"
+		 "Email xen-devel@lists.xen.org - Thank you.\n", \
+		 bits, val_a, val_b))
 		return -1;
-	}
 
 	HYPERVISOR_dom0_op(&op);
 	return 1;
 }
+
+int xen_acpi_notify_hypervisor_sleep(u8 sleep_state,
+				     u32 pm1a_cnt, u32 pm1b_cnt)
+{
+	return xen_acpi_notify_hypervisor_state(sleep_state, pm1a_cnt,
+						pm1b_cnt, false);
+}
+
+int xen_acpi_notify_hypervisor_extended_sleep(u8 sleep_state,
+				     u32 val_a, u32 val_b)
+{
+	return xen_acpi_notify_hypervisor_state(sleep_state, val_a,
+						val_b, true);
+}
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 46aa3d1..4ddd7dc 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -75,8 +75,10 @@ static inline int xen_acpi_get_pxm(acpi_handle h)
 	return -ENXIO;
 }
 
-int xen_acpi_notify_hypervisor_state(u8 sleep_state,
+int xen_acpi_notify_hypervisor_sleep(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnd);
+int xen_acpi_notify_hypervisor_extended_sleep(u8 sleep_state,
+				     u32 val_a, u32 val_b);
 
 static inline int xen_acpi_suspend_lowlevel(void)
 {
@@ -93,7 +95,9 @@ static inline void xen_acpi_sleep_register(void)
 {
 	if (xen_initial_domain()) {
 		acpi_os_set_prepare_sleep(
-			&xen_acpi_notify_hypervisor_state);
+			&xen_acpi_notify_hypervisor_sleep);
+		acpi_os_set_prepare_extended_sleep(
+			&xen_acpi_notify_hypervisor_extended_sleep);
 
 		acpi_suspend_lowlevel = xen_acpi_suspend_lowlevel;
 	}
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
index c57d5f6..f1331e3 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -152,10 +152,11 @@ DEFINE_GUEST_HANDLE_STRUCT(xenpf_firmware_info_t);
 #define XENPF_enter_acpi_sleep    51
 struct xenpf_enter_acpi_sleep {
 	/* IN variables */
-	uint16_t pm1a_cnt_val;      /* PM1a control value. */
-	uint16_t pm1b_cnt_val;      /* PM1b control value. */
+	uint16_t val_a;             /* PM1a control / sleep type A. */
+	uint16_t val_b;             /* PM1b control / sleep type B. */
 	uint32_t sleep_state;       /* Which state to enter (Sn). */
-	uint32_t flags;             /* Must be zero. */
+#define XENPF_ACPI_SLEEP_EXTENDED 0x00000001
+	uint32_t flags;             /* XENPF_ACPI_SLEEP_*. */
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_enter_acpi_sleep_t);
 
-- 
1.7.9.5

