Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab3K3MuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:50:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59522 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3K3MuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:50:11 -0500
Date: Sat, 30 Nov 2013 04:49:57 -0800
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-37e72c31061521d6f0e4b7fe47cd5748280ed691@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, artagnon@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1384704807-15779-4-git-send-email-artagnon@gmail.com>
References: <1384704807-15779-4-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf completion:
  Factor out call to __ltrim_colon_completions
Git-Commit-ID: 37e72c31061521d6f0e4b7fe47cd5748280ed691
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:50:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37e72c31061521d6f0e4b7fe47cd5748280ed691
Gitweb:     http://git.kernel.org/tip/37e72c31061521d6f0e4b7fe47cd5748280ed691
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Sun, 17 Nov 2013 21:43:25 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:35 -0300

perf completion: Factor out call to __ltrim_colon_completions

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
