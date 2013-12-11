Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab3LKKRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:17:32 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:53593 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3LKKR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:17:29 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf list: fix --raw-dump
Date: Wed, 11 Dec 2013 15:46:20 +0530
Message-Id: <1386756980-23121-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While adding usage information, 44d742e (perf list: Add usage,
2013-10-30) broke

  $ perf list --raw-dump

by asking parse_options() to stop at
non-option (PARSE_OPT_STOP_AT_NON_OPTION), hence parsing the option
--raw-dump and barfing. Ask it to keep unknown options
unparsed (PARSE_OPT_KEEP_UNKNOWN) so that we have a chance to handle it
later. The trade-off that this patch makes is that

  $ perf list --foo

will not error out like it used to.

Fixes: 44d742e01e6d (perf list: Add usage)
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 I spotted this while trying to complete

   $ perf record -e <TAB>

 tools/perf/builtin-list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e..8b076f3 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -28,7 +28,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 	};
 
 	argc = parse_options(argc, argv, list_options, list_usage,
-			     PARSE_OPT_STOP_AT_NON_OPTION);
+			PARSE_OPT_KEEP_UNKNOWN);
 
 	setup_pager();
 
-- 
1.8.5.rc0.5.g70ebc73.dirty

