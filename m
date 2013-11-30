Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3K3MuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:50:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59504 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3K3MuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:50:00 -0500
Date: Sat, 30 Nov 2013 04:49:48 -0800
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-12f9dd5042483698c74a133d9004ff1d1a6474f9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, artagnon@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1384704807-15779-3-git-send-email-artagnon@gmail.com>
References: <1384704807-15779-3-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf completion: Factor out compgen stuff
Git-Commit-ID: 12f9dd5042483698c74a133d9004ff1d1a6474f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:49:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12f9dd5042483698c74a133d9004ff1d1a6474f9
Gitweb:     http://git.kernel.org/tip/12f9dd5042483698c74a133d9004ff1d1a6474f9
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Sun, 17 Nov 2013 21:43:24 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:35 -0300

perf completion: Factor out compgen stuff

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
 
