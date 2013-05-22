Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab3EVTQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:16:42 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:15255
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754882Ab3EVTQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:16:40 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN7S6X-01-FL1-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <ddutile@redhat.com>, <alex.williamson@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/3] iommu/amd: Adding amd_iommu_log cmdline option
Date: Wed, 22 May 2013 14:15:53 -0500
Message-ID: <1369250155-12226-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Adding amd_iommu_log command line option to allow "default", "verbose" and "debug"
IOMMU error logging level in kernel log.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 Documentation/kernel-parameters.txt |   10 ++++++++++
 drivers/iommu/amd_iommu_init.c      |   17 +++++++++++++++++
 drivers/iommu/amd_iommu_types.h     |    6 ++++++
 3 files changed, 33 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c3bfacb..752f0f9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -350,6 +350,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			driver will print ACPI tables for AMD IOMMU during
 			IOMMU initialization.
 
+	amd_iommu_log=	[HW,X86-64]
+			Specify parametes to choose the logging level. By default
+			the AMD IOMMU minimizes the logging detail, filters
+			duplicate log entries and suppress logging when encounters
+			storm of interrupts from a particular device.
+			Available options are:
+			default - Default log level.
+			verbose - Output detail log messages.
+			debug   - Output detail log messages and no filter/suppress.
+
 	amijoy.map=	[HW,JOY] Amiga joystick support
 			Map of devices attached to JOY0DAT and JOY1DAT
 			Format: <a>,<b>
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index bf51abb..66e3722 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -157,6 +157,8 @@ bool amd_iommu_v2_present __read_mostly;
 
 bool amd_iommu_force_isolation __read_mostly;
 
+int amd_iommu_log_level __read_mostly = AMD_IOMMU_LOG_DEFAULT;
+
 /*
  * List of protection domains - used during resume
  */
@@ -2157,6 +2159,20 @@ static int __init parse_amd_iommu_options(char *str)
 	return 1;
 }
 
+static int __init parse_amd_iommu_log(char *str)
+{
+	for (; *str; ++str) {
+		if (strncmp(str, "default", 7) == 0)
+			amd_iommu_log_level = AMD_IOMMU_LOG_DEFAULT;
+		else if (strncmp(str, "verbose", 7) == 0)
+			amd_iommu_log_level = AMD_IOMMU_LOG_VERBOSE;
+		else if (strncmp(str, "debug", 5) == 0)
+			amd_iommu_log_level = AMD_IOMMU_LOG_DEBUG;
+	}
+
+	return 1;
+}
+
 static int __init parse_ivrs_ioapic(char *str)
 {
 	unsigned int bus, dev, fn;
@@ -2219,6 +2235,7 @@ static int __init parse_ivrs_hpet(char *str)
 
 __setup("amd_iommu_dump",	parse_amd_iommu_dump);
 __setup("amd_iommu=",		parse_amd_iommu_options);
+__setup("amd_iommu_log=",	parse_amd_iommu_log);
 __setup("ivrs_ioapic",		parse_ivrs_ioapic);
 __setup("ivrs_hpet",		parse_ivrs_hpet);
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 0285a21..85b7a65 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -694,6 +694,12 @@ extern bool amd_iommu_v2_present;
 
 extern bool amd_iommu_force_isolation;
 
+#define AMD_IOMMU_LOG_DEFAULT        0
+#define AMD_IOMMU_LOG_VERBOSE        1
+#define AMD_IOMMU_LOG_DEBUG          2
+
+extern int amd_iommu_log_level;
+
 /* Max levels of glxval supported */
 extern int amd_iommu_max_glx_val;
 
-- 
1.7.10.4


