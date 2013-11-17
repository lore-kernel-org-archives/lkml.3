Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3KQQWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:22:54 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52954 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3KQQWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:22:22 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/5] perf completion: factor out compgen stuff
Date: Sun, 17 Nov 2013 21:43:24 +0530
Message-Id: <1384704807-15779-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.6.gfd75b41
In-Reply-To: <1384704807-15779-1-git-send-email-artagnon@gmail.com>
References: <1384704807-15779-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compgen is a bash-builtin; factor out the invocations into a separate
function to give us a chance to override it with a zsh equivalent in
future patches.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/bash_completion | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 3efdc84..82431268 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -89,6 +89,11 @@ __ltrim_colon_completions()
 	fi
 }
 
+__perfcomp ()
+{
+	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
+}
+
 __perf_main ()
 {
 	local cmd
@@ -99,23 +104,23 @@ __perf_main ()
 	# List perf subcommands or long options
 	if [ $cword -eq 1 ]; then
 		if [[ $cur == --* ]]; then
-			COMPREPLY=( $( compgen -W '--help --version \
+			__perfcomp '--help --version \
 			--exec-path --html-path --paginate --no-pager \
-			--perf-dir --work-tree --debugfs-dir' -- "$cur" ) )
+			--perf-dir --work-tree --debugfs-dir' -- "$cur"
 		else
 			cmds=$($cmd --list-cmds)
-			COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
+			__perfcomp "$cmds" "$cur"
 		fi
 	# List possible events for -e option
 	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
 		evts=$($cmd list --raw-dump)
-		COMPREPLY=( $( compgen -W '$evts' -- "$cur" ) )
+		__perfcomp "$evts" "$cur"
 		__ltrim_colon_completions $cur
 	# List long option names
 	elif [[ $cur == --* ]];  then
 		subcmd=${words[1]}
 		opts=$($cmd $subcmd --list-opts)
-		COMPREPLY=( $( compgen -W '$opts' -- "$cur" ) )
+		__perfcomp "$opts" "$cur"
 	fi
 }
 
-- 
1.8.5.rc0.6.gfd75b41

