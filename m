Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaAYOYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:24:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52418 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbaAYOXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:23:44 -0500
Date: Sat, 25 Jan 2014 06:23:19 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-4afc81cd1caa93daa50c1c29a3ab747c978abc13@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        dave.long@linaro.org, hpa@zytor.com, mingo@kernel.org,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, dsahern@gmail.com,
        oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, dave.long@linaro.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20140123022950.7206.17357.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140123022950.7206.17357.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Load map before using map->map_ip
 ()
Git-Commit-ID: 4afc81cd1caa93daa50c1c29a3ab747c978abc13
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:23:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4afc81cd1caa93daa50c1c29a3ab747c978abc13
Gitweb:     http://git.kernel.org/tip/4afc81cd1caa93daa50c1c29a3ab747c978abc13
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 23 Jan 2014 02:29:50 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 23 Jan 2014 15:48:12 -0300

perf symbols: Load map before using map->map_ip()

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
index ee1dd68..3b97513 100644
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
