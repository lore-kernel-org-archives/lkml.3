Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab3ENRqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:46:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:28695 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408Ab3ENRqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:46:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,671,1363132800"; 
   d="scan'208";a="25177478"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <linux-acpi@vger.kernel.org>, <xen-devel@lists.xensource.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Liang Tang <liang.tang@oracle.com>
Subject: [PATCH] xen/acpi/sleep: Register to the acpi_suspend_lowlevel a callback.
Date: Tue, 14 May 2013 13:46:12 -0400
Message-ID: <1368553572-4966-2-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368553572-4966-1-git-send-email-benjamin.guthro@citrix.com>
References: <1368551357-3903-1-git-send-email-benjamin.guthro@citrix.com>
 <1368553572-4966-1-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

We piggyback on "x86/acpi: Provide registration for acpi_suspend_lowlevel."
to register a Xen version of the callback. The callback does not
do anything special - except it omits the x86_acpi_suspend_lowlevel.

This is necessary b/c during suspend the generic code tries to write
cr3 values that clashes with what the hypervisor has set up for the guest.

Signed-off-by: Liang Tang <liang.tang@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Ben Guthro <benjamin.guthro@citrix.com>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/xen/acpi.h |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 68d73d0..46aa3d1 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -78,11 +78,25 @@ static inline int xen_acpi_get_pxm(acpi_handle h)
 int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnd);
 
+static inline int xen_acpi_suspend_lowlevel(void)
+{
+	/*
+	* Xen will save and restore CPU context, so
+	* we can skip that and just go straight to
+	* the suspend.
+	*/
+	acpi_enter_sleep_state(ACPI_STATE_S3);
+	return 0;
+}
+
 static inline void xen_acpi_sleep_register(void)
 {
-	if (xen_initial_domain())
+	if (xen_initial_domain()) {
 		acpi_os_set_prepare_sleep(
 			&xen_acpi_notify_hypervisor_state);
+
+		acpi_suspend_lowlevel = xen_acpi_suspend_lowlevel;
+	}
 }
 #else
 static inline void xen_acpi_sleep_register(void)
-- 
1.7.9.5

