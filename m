Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3KQQWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:22:42 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53381 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab3KQQWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:22:24 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 3/5] perf completion: factor out call to __ltrim_colon_completions
Date: Sun, 17 Nov 2013 21:43:25 +0530
Message-Id: <1384704807-15779-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.6.gfd75b41
In-Reply-To: <1384704807-15779-1-git-send-email-artagnon@gmail.com>
References: <1384704807-15779-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In our sole callsite, __ltrim_colon_completions is called after
__perfcomp, to modify the COMPREPLY set by the invocation. This is
problematic, because in the zsh equivalent (using compset/ compadd),
we'll have to generate completions in one-shot. So factor out this
entire callsite into a special override'able __perfcomp_colon function;
we will override it when introducing zsh support.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/bash_completion | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 82431268..573599b 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -94,6 +94,12 @@ __perfcomp ()
 	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
 }
 
+__perfcomp_colon ()
+{
+	__perfcomp "$1" "$2"
+	__ltrim_colon_completions $cur
+}
+
 __perf_main ()
 {
 	local cmd
@@ -114,8 +120,7 @@ __perf_main ()
 	# List possible events for -e option
 	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
 		evts=$($cmd list --raw-dump)
-		__perfcomp "$evts" "$cur"
-		__ltrim_colon_completions $cur
+		__perfcomp_colon "$evts" "$cur"
 	# List long option names
 	elif [[ $cur == --* ]];  then
 		subcmd=${words[1]}
-- 
1.8.5.rc0.6.gfd75b41

