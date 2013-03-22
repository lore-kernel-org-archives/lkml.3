Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab3CVO2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:28:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17051 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247Ab3CVO2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:28:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, jinsong.liu@intel.com
Subject: [PATCH] xen/acpi-stub: Disable it b/c the acpi_processor_add is no longer called.
Date: Fri, 22 Mar 2013 10:28:00 -0400
Message-Id: <1363962480-1366-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the Xen ACPI stub code (CONFIG_XEN_STUB=y) enabled, the power
C and P states are no longer uploaded to the hypervisor.

The reason is that the Xen CPU hotplug code: xen-acpi-cpuhotplug.c
and the xen-acpi-stub.c register themselves as the "processor" type object.

That means the generic processor (processor_driver.c) stops
working and it does not call (acpi_processor_add) which populates the

         per_cpu(processors, pr->id) = pr;

structure. The 'pr' is gathered from the acpi_processor_get_info function
which does the job of finding the C-states and figuring out PBLK address.

The 'processors->pr' is then later used by xen-acpi-processor.c (the one that
uploads C and P states to the hypervisor). Since it is NULL, we end
skip the gathering of _PSD, _PSS, _PCT, etc and never upload the power
management data.

The end result is that enabling the CONFIG_XEN_STUB in the build means that
xen-acpi-processor is not working anymore.

This temporary patch fixes it by marking the XEN_STUB driver as
BROKEN until this can be properly fixed.

CC: jinsong.liu@intel.com
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 5a32232..67af155 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -182,7 +182,7 @@ config XEN_PRIVCMD
 
 config XEN_STUB
 	bool "Xen stub drivers"
-	depends on XEN && X86_64
+	depends on XEN && X86_64 && BROKEN
 	default n
 	help
 	  Allow kernel to install stub drivers, to reserve space for Xen drivers,
-- 
1.8.0.2

