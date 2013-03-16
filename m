Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3CPVfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 17:35:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799Ab3CPVfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 17:35:25 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
To: kay@vrfy.org
Cc: linux-hotplug@vger.kernel.org, greg@kroah.com, alex.williamson@redhat.com,
        linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com,
        linux-kernel@vger.kernel.org
Date: Sat, 16 Mar 2013 15:35:19 -0600
Message-ID: <20130316213519.2974.38954.stgit@amt.stowe>
In-Reply-To: <20130316213512.2974.17303.stgit@amt.stowe>
References: <20130316213512.2974.17303.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sysfs includes entries to memory that backs a PCI device's BARs, both I/O
Port space and MMIO.  This memory regions correspond to the device's
internal status and control registers used to drive the device.

Accessing these registers from userspace such as "udevadm info
--attribute-walk --path=/sys/devices/..." does can not be allowed as
such accesses outside of the driver, even just reading, can yield
catastrophic consequences.

Udevadm-info skips parsing a specific set of sysfs entries including
'resource'.  This patch extends the set to include the additional
'resource<N>' entries that correspond to a PCI device's BARs.

Reported-by: Xiangliang Yu <yuxiangl@marvell.com>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 src/udevadm-info.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/src/udevadm-info.c b/src/udevadm-info.c
index ee9b59f..298acb5 100644
--- a/src/udevadm-info.c
+++ b/src/udevadm-info.c
@@ -37,13 +37,18 @@ static bool skip_attribute(const char *name)
                 "uevent",
                 "dev",
                 "modalias",
-                "resource",
                 "driver",
                 "subsystem",
                 "module",
         };
         unsigned int i;
 
+        /*
+         * Skip any sysfs 'resource' entries, including 'resource<N>' entries
+         * that correspond to a device's I/O Port or MMIO space backed BARs.
+         */
+        if (strncmp((const char *)name, "resource", sizeof("resource")-1) == 0)
+                return true;
         for (i = 0; i < ARRAY_SIZE(skip); i++)
                 if (strcmp(name, skip[i]) == 0)
                         return true;

