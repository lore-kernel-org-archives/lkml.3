Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbaAWCbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:31:47 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51842 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbaAWC3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:29:53 -0500
Subject: [PATCH -tip 2/8] [BUGFIX] perf-tools: Load map before using
 map->map_ip
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 23 Jan 2014 02:29:50 +0000
Message-ID: <20140123022950.7206.17357.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In map_groups__find_symbol() map->map_ip is used without
ensuring the map is loaded. Then the address passed
to map->map_ip isn't mapped at the first time.

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
---
 tools/perf/util/map.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9b9bd71..6a805e7 100644
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


