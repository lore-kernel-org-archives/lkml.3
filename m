Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab3GOU2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:28:38 -0400
Received: from mail1.windriver.com ([147.11.146.13]:51339 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3GOU2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:28:37 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <a.p.zijlstra@chello.nl>
CC: <paulus@samba.org>, <acme@ghostprotocols.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: Do not require /lib/modules/* on a guest
Date: Mon, 15 Jul 2013 15:27:53 -0500
Message-ID: <1373920073-4874-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some types of work loads and special guest environments, you might
have a kernel that has no kernel modules.  The perf kvm record tool
fails instantiate vmlinux maps when the kernel modules directory
cannot be opened, even though the kallsyms has been properly
processed.  This leads to a perf kvm report that has no guest symbols
resolved.

This patch changes the failure to locate kernel modules to be
non-fatal.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 tools/perf/util/machine.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b2ecad6..eb9ebd6 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -808,7 +808,10 @@ static int machine__create_modules(struct machine *machine)
 	free(line);
 	fclose(file);
 
-	return machine__set_modules_path(machine);
+	if (machine__set_modules_path(machine) < 0) {
+		pr_debug("Problems setting modules path maps, continuing anyway...\n");
+	}
+	return 0;
 
 out_delete_line:
 	free(line);
-- 
1.7.9.5

