Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936951Ab3DJPgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:36:42 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:53508
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763998Ab3DJPgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:36:41 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Add additional distro specific Kconfig options
Date: Wed, 10 Apr 2013 09:08:17 -0700
Message-Id: <1365610097-10955-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The guest ID captures information about the guest and has room for
distributions to add distro specific information. Add Kconfig options
to support distro specific information to be managed easily.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/Kconfig        |   14 ++++++++++++++
 drivers/hv/hv.c           |    4 +++-
 drivers/hv/hyperv_vmbus.h |    2 +-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index 0403b51..d2ca9c7 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -19,4 +19,18 @@ config HYPERV_BALLOON
 	help
 	  Select this option to enable Hyper-V Balloon driver.
 
+config HYPERV_GUEST_D1
+	hex "Distro specific information"
+	range 0x00 0xff
+	default 0
+	help
+	  This specifies the Distro vendor
+
+config HYPERV_GUEST_D2
+	hex "Additional Distro specific information"
+	range 0x0000 0xffff
+	default 0
+	help
+	  Additional Distro specific kernel version information
+
 endmenu
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index ae49237..7bd2e88 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -148,7 +148,9 @@ int hv_init(void)
 	/*
 	 * Write our OS ID.
 	 */
-	hv_context.guestid = generate_guest_id(0, LINUX_VERSION_CODE, 0);
+	hv_context.guestid = generate_guest_id(HYPERV_GUEST_D1,
+						LINUX_VERSION_CODE,
+						HYPERV_GUEST_D2);
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, hv_context.guestid);
 
 	/* See if the hypercall page is already set */
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 12f2f9e..8c9ebd0 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -410,7 +410,7 @@ enum {
  *
  * Bit(s)
  * 63 - Indicates if the OS is Open Source or not; 1 is Open Source
- * 62:56 - Os Type; Linux is 0x100
+ * 62:56 - Os Type; Linux is 0x1
  * 55:48 - Distro specific identification
  * 47:16 - Linux kernel version number
  * 15:0  - Distro specific identification
-- 
1.7.4.1

