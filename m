Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbaIZKN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:13:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbaIZJqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nsn.com>,
        James Hogan <james.hogan@imgtec.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 072/142] MIPS: OCTEON: make get_system_type() thread-safe
Date: Fri, 26 Sep 2014 11:44:43 +0200
Message-Id: <1e1c3a21579aa9ea0429b69165caef77cca27f7e.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@nsn.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/mips/cavium-octeon/setup.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index b212ae12e5ac..8a0079981cc8 100644
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
2.1.0

