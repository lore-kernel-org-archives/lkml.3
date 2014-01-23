Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbaAWTib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:38:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43879 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaAWTi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:38:26 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "David A. Long" <dave.long@linaro.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf symbols: Load map before using map->map_ip()
Date: Thu, 23 Jan 2014 16:38:14 -0300
Message-Id: <1390505894-19733-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390505894-19733-1-git-send-email-acme@infradead.org>
References: <1390505894-19733-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

In map_groups__find_symbol() map->map_ip is used without ensuring the
map is loaded. Then the address passed to map->map_ip isn't mapped at
the first time.

E.g. below code always fails to get a symbol at the first call;

	addr = /* Somewhere in the kernel text */
	symbol_conf.try_vmlinux_path = true;
	symbol__init();
	host_machine = machine__new_host();
	sym = machine__find_kernel_function(host_machine,
					 addr, NULL, NULL);
	/* Note that machine__find_kernel_function calls
	   map_groups__find_symbol */

This ensures it by calling map__load before using it in
map_groups__find_symbol().

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140123022950.7206.17357.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ee1dd687a262..3b97513f0e77 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -386,7 +386,8 @@ struct symbol *map_groups__find_symbol(struct map_groups *mg,
 {
 	struct map *map = map_groups__find(mg, type, addr);
 
-	if (map != NULL) {
+	/* Ensure map is loaded before using map->map_ip */
+	if (map != NULL && map__load(map, filter) >= 0) {
 		if (mapp != NULL)
 			*mapp = map;
 		return map__find_symbol(map, map->map_ip(map, addr), filter);
-- 
1.8.1.4

