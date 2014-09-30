Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaI3Vg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:36:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60833 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaI3VgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:36:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaro Koskinen <aaro.koskinen@nsn.com>,
        James Hogan <james.hogan@imgtec.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 029/103] MIPS: OCTEON: make get_system_type() thread-safe
Date: Tue, 30 Sep 2014 14:30:34 -0700
Message-Id: <1412112708-27356-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/mips/cavium-octeon/setup.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 331b837..270cb3c 100644
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
1.9.1

