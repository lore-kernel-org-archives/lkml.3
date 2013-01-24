Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945906Ab3AXUic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:38:32 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53971
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab3AXUIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:35 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 51/74] perf symbols: Mark vmlinux filename as allocated
Date: Thu, 24 Jan 2013 17:08:00 -0300
Message-Id: <1359058103-31645-52-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Needs to be marked allocated so memory can be freed when dso is deleted.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1358185650-90848-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index daf9554..e6432d8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -923,8 +923,10 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
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
 
@@ -932,6 +934,7 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 		err = dso__load_vmlinux(dso, map, vmlinux_path[i], filter);
 		if (err > 0) {
 			dso__set_long_name(dso, strdup(vmlinux_path[i]));
+			dso->lname_alloc = 1;
 			break;
 		}
 	}
@@ -971,6 +974,7 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 		if (err > 0) {
 			dso__set_long_name(dso,
 					   strdup(symbol_conf.vmlinux_name));
+			dso->lname_alloc = 1;
 			goto out_fixup;
 		}
 		return err;
-- 
1.8.1.1.361.gec3ae6e

