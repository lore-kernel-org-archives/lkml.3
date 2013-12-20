Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3LTSEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:04:16 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35254 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3LTSEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:04:13 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH] perf probe: Improve error message when function not found
Date: Fri, 20 Dec 2013 11:04:09 -0700
Message-Id: <1387562649-25929-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When requesting a function from a userspace library the error message to
the user is less than helpful. e.g.,

    perf probe -x /lib64/libpthread-2.14.90.so -a 'lock_full=__pthread_mutex_lock_full'
    no symbols found in /lib64/libpthread-2.14.90.so, maybe install a debug package?
    Failed to load map.
       Error: Failed to add events. (-22)

yet the symbol really does exist but is a local symbol which is filtered:

nm /lib64/libpthread-2.14.90.so | grep __pthread_mutex_lock_full
0000000000005700 t __pthread_mutex_lock_full

With this patch:
    perf probe -x /lib64/libpthread-2.14.90.so -a 'lock_full=__pthread_mutex_lock_full'

    no symbols found in /lib64/libpthread-2.14.90.so, maybe install a debug package?
    Failed to find function in /lib64/libpthread-2.14.90.so. Perhaps it is a local variable?
      Error: Failed to add events. (-22)

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 9c6989ca2bea..2eac49096840 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2309,7 +2309,8 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 	}
 	available_func_filter = strfilter__new(function, NULL);
 	if (map__load(map, filter_available_functions)) {
-		pr_err("Failed to load map.\n");
+		pr_err("Failed to find requested symbol in %s. Is it a global variable?\n",
+		       name);
 		goto out;
 	}
 
-- 
1.8.3.4 (Apple Git-47)

