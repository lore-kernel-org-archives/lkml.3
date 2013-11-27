Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab3K0URF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:17:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60962 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3K0UQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:16:58 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/34] perf completion: Factor out compgen stuff
Date: Wed, 27 Nov 2013 17:16:05 -0300
Message-Id: <1385583394-3703-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

compgen is a bash-builtin; factor out the invocations into a separate
function to give us a chance to override it with a zsh equivalent in
future patches.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1384704807-15779-3-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 3efdc84f112c..824312681601 100644
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
1.8.1.4

