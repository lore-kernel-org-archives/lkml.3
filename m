Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab3K0UWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:22:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60972 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab3K0URA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:00 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/34] perf completion: Factor out call to __ltrim_colon_completions
Date: Wed, 27 Nov 2013 17:16:06 -0300
Message-Id: <1385583394-3703-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

In our sole callsite, __ltrim_colon_completions is called after
__perfcomp, to modify the COMPREPLY set by the invocation.

This is problematic, because in the zsh equivalent (using compset/
compadd), we'll have to generate completions in one-shot.

So factor out this entire callsite into a special override'able
__perfcomp_colon function; we will override it when introducing zsh
support.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1384704807-15779-4-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 824312681601..573599b42be2 100644
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
1.8.1.4

