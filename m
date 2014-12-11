Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789AbaLKNvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:51:48 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54504 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840AbaLKNvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:51:47 -0500
From: Arjun Sreedharan <arjun024@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Masahiro Yamada <yamada.m@jp.panasonic.com>
Subject: [PATCH] docproc: fix potential memory leak in find_all_symbols()
Date: Thu, 11 Dec 2014 19:21:37 +0530
Message-Id: <1418305897-1879-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in case realloc() fails, @data is overwritten by NULL losing
reference to the memory. This is avoided by @data_old

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 scripts/docproc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/scripts/docproc.c b/scripts/docproc.c
index e267e621..e230c0b 100644
--- a/scripts/docproc.c
+++ b/scripts/docproc.c
@@ -359,7 +359,8 @@ static void find_all_symbols(char *filename)
 	int ret, i, count, start;
 	char real_filename[PATH_MAX + 1];
 	int pipefd[2];
-	char *data, *str;
+	char *data, *data_old;
+	char *str;
 	size_t data_len = 0;
 
 	vec[0] = KERNELDOC;
@@ -395,7 +396,13 @@ static void find_all_symbols(char *filename)
 						   data + data_len,
 						   4096)) > 0) {
 					data_len += ret;
+					data_old = data;
 					data = realloc(data, data_len + 4096);
+					if (!data) {
+						free(data_old);
+						fprintf(stderr, "Out of memory.\n");
+						exit(1);
+					}
 				}
 			} while (ret == -EAGAIN);
 			if (ret != 0) {
-- 
1.7.11.7

