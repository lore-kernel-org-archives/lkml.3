Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaIWCey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:34:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:37517 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbaIWCev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:34:51 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nsn.com>,
        James Hogan <james.hogan@imgtec.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 07/45] MIPS: OCTEON: make get_system_type() thread-safe
Date: Tue, 23 Sep 2014 10:31:09 +0800
Message-Id: <1411439507-30391-7-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@nsn.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[lizf: Backport to 3.x: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/mips/cavium-octeon/setup.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index d3a9f012..b6fb650 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -265,6 +265,18 @@ static irqreturn_t octeon_rlm_interrupt(int cpl, void *dev_id)
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
@@ -272,11 +284,7 @@ static irqreturn_t octeon_rlm_interrupt(int cpl, void *dev_id)
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
1.7.9.5

