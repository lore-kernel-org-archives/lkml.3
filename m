Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab3ANQvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:51:55 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:38633 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab3ANQvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:51:54 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf: symbol - mark vmlinux filename as allocated
Date: Mon, 14 Jan 2013 09:51:48 -0700
Message-Id: <1358182308-89715-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needs to be marked allocated so memory can be freed when
dso is deleted.
---
 tools/perf/util/symbol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 295f8d4..61edfd0 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1124,8 +1124,10 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 	filename = dso__build_id_filename(dso, NULL, 0);
 	if (filename != NULL) {
 		err = dso__load_vmlinux(dso, map, filename, filter);
-		if (err > 0)
+		if (err > 0) {
+			dso->lname_alloc = 1;
 			goto out;
+		}
 		free(filename);
 	}
 
@@ -1133,6 +1135,7 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 		err = dso__load_vmlinux(dso, map, vmlinux_path[i], filter);
 		if (err > 0) {
 			dso__set_long_name(dso, strdup(vmlinux_path[i]));
+			dso->lname_alloc = 1;
 			break;
 		}
 	}
@@ -1172,6 +1175,7 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 		if (err > 0) {
 			dso__set_long_name(dso,
 					   strdup(symbol_conf.vmlinux_name));
+			dso->lname_alloc = 1;
 			goto out_fixup;
 		}
 		return err;
-- 
1.7.10.1

