Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3KVVT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:19:27 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58207 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab3KVVT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:19:26 -0500
From: Francis Giraldeau <francis.giraldeau@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Francis Giraldeau <francis.giraldeau@gmail.com>
Subject: [PATCH] Prevent infinite loop if unwind fails
Date: Fri, 22 Nov 2013 16:19:16 -0500
Message-Id: <1385155156-26573-1-git-send-email-francis.giraldeau@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unwind may loop forever if sample is incomplete or bogus. Bound the number of
unw_step() that yield the same IP to prevent infinite loop.

Signed-off-by: Francis Giraldeau <francis.giraldeau@gmail.com>
---
 tools/perf/util/unwind.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 958723b..bf45b6b 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -520,7 +520,8 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 {
 	unw_addr_space_t addr_space;
 	unw_cursor_t c;
-	int ret;
+	unw_word_t prev_ip = 0;
+	int ret, rec = 0;
 
 	addr_space = unw_create_addr_space(&accessors, 0);
 	if (!addr_space) {
@@ -537,6 +538,11 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 
 		unw_get_reg(&c, UNW_REG_IP, &ip);
 		ret = entry(ip, ui->thread, ui->machine, cb, arg);
+		if (prev_ip != ip)
+			rec = 0;
+		if (++rec >= 100)
+			break;
+		prev_ip = ip;
 	}
 
 	unw_destroy_addr_space(addr_space);
-- 
1.8.1.2

