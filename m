Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbaGVMQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:16:40 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:53939 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaGVMNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:13:49 -0400
X-Greylist: delayed 1203 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2014 08:13:49 EDT
From: Aaro Koskinen <aaro.koskinen@nsn.com>
To: Ralf Baechle <ralf@linux-mips.org>, David Daney <david.daney@cavium.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@nsn.com>, stable@vger.kernel.org
Subject: [PATCH] MIPS: OCTEON: make get_system_type() thread-safe
Date: Tue, 22 Jul 2014 14:51:08 +0300
Message-Id: <1406029868-6210-1-git-send-email-aaro.koskinen@nsn.com>
X-Mailer: git-send-email 2.0.0
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1770
X-purgate-ID: 151667::1406030012-00007A71-6AA87622/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_system_type() is not thread-safe on OCTEON. It uses static data,
also more dangerous issue is that it's calling cvmx_fuse_read_byte()
every time without any synchronization. Currently it's possible to get
processes stuck looping forever in kernel simply by launching multiple
readers of /proc/cpuinfo:

	(while true; do cat /proc/cpuinfo > /dev/null; done) &
	(while true; do cat /proc/cpuinfo > /dev/null; done) &
	...

Fix by initializing the system type string only once during the early
boot.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nsn.com>
Cc: stable@vger.kernel.org
---
 arch/mips/cavium-octeon/setup.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 008e9c8..c9d9c62 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -458,6 +458,18 @@ static void octeon_halt(void)
 	octeon_kill_core(NULL);
 }
 
+static char __read_mostly octeon_system_type[80];
+
+static int __init init_octeon_system_type(void)
+{
+	snprintf(octeon_system_type, sizeof(octeon_system_type), "%s (%s)",
+		cvmx_board_type_to_string(octeon_bootinfo->board_type),
+		octeon_model_get_string(read_c0_prid()));
+
+	return 0;
+}
+early_initcall(init_octeon_system_type);
+
 /**
  * Return a string representing the system type
  *
@@ -465,11 +477,7 @@ static void octeon_halt(void)
  */
 const char *octeon_board_type_string(void)
 {
-	static char name[80];
-	sprintf(name, "%s (%s)",
-		cvmx_board_type_to_string(octeon_bootinfo->board_type),
-		octeon_model_get_string(read_c0_prid()));
-	return name;
+	return octeon_system_type;
 }
 
 const char *get_system_type(void)
-- 
2.0.0

