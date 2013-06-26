Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab3FZOGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:06:35 -0400
Received: from smtp.citrix.com ([66.165.176.89]:54617 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab3FZOGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:06:32 -0400
X-IronPort-AV: E=Sophos;i="4.87,944,1363132800"; 
   d="scan'208";a="33546356"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafaell J . Wysocki" <rjw@sisk.pl>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <xen-devel@lists.xen.org>
CC: Ben Guthro <benjamin.guthro@citrix.com>
Subject: [PATCH v3 3/3] xen/acpi: notify xen when reduced hardware sleep is available
Date: Wed, 26 Jun 2013 10:06:15 -0400
Message-ID: <1372255575-29567-4-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372255575-29567-1-git-send-email-benjamin.guthro@citrix.com>
References: <1372255575-29567-1-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of acpi_os_prepare_sleep extended parameter to notify xen
to make use of the reduced hardware sleep functionality

The hypervisor change underlying this is commit 62d1a69 ("ACPI: support
v5 (reduced HW) sleep interface") on the master branch of
git://xenbits.xen.org/xen.git.

Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/acpi.c               |   26 +++++++++++++-------------
 include/xen/acpi.h               |    4 ++--
 include/xen/interface/platform.h |    7 ++++---
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/xen/acpi.c b/drivers/xen/acpi.c
index 119d42a..f4e12dc 100644
--- a/drivers/xen/acpi.c
+++ b/drivers/xen/acpi.c
@@ -35,27 +35,27 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 
-int xen_acpi_notify_hypervisor_state(u8 sleep_state,
-				     u32 pm1a_cnt, u32 pm1b_cnt)
+int xen_acpi_notify_hypervisor_state(u8 sleep_state, u32 val_a, u32 val_b,
+				     u8 extended)
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
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 68d73d0..55bf8423f 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -75,8 +75,8 @@ static inline int xen_acpi_get_pxm(acpi_handle h)
 	return -ENXIO;
 }
 
-int xen_acpi_notify_hypervisor_state(u8 sleep_state,
-				     u32 pm1a_cnt, u32 pm1b_cnd);
+int xen_acpi_notify_hypervisor_state(u8 sleep_state, u32 val_a, u32 val_b,
+				     u8 extended);
 
 static inline void xen_acpi_sleep_register(void)
 {
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

