Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbaIKMwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:52:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51592 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755413AbaIKMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "James Hogan" <james.hogan@imgtec.com>,
        "Aaro Koskinen" <aaro.koskinen@nsn.com>,
        "Markos Chandras" <markos.chandras@imgtec.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.132759756@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 079/131] MIPS: OCTEON: make get_system_type() thread-safe
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@nsn.com>

commit 608308682addfdc7b8e2aee88f0e028331d88e4d upstream.

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
Reviewed-by: Markos Chandras <markos.chandras@imgtec.com>
Patchwork: http://patchwork.linux-mips.org/patch/7437/
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/cavium-octeon/setup.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -266,6 +266,18 @@ static irqreturn_t octeon_rlm_interrupt(
 }
 #endif
 
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
@@ -273,11 +285,7 @@ static irqreturn_t octeon_rlm_interrupt(
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

