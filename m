Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3KQQXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:23:17 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46163 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3KQQW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:22:27 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 4/5] perf completion: introduce zsh support
Date: Sun, 17 Nov 2013 21:43:26 +0530
Message-Id: <1384704807-15779-5-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.6.gfd75b41
In-Reply-To: <1384704807-15779-1-git-send-email-artagnon@gmail.com>
References: <1384704807-15779-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__perfcomp(), __perfcomp_colon(), and _perf() have to be
overridden. Inspired by the way the git.git completion system is
structured.

Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/bash_completion | 63 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 573599b..4949488 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -1,4 +1,4 @@
-# perf completion
+# perf bash and zsh completion
 
 # Taken from git.git's completion script.
 __my_reassemble_comp_words_by_ref()
@@ -129,6 +129,67 @@ __perf_main ()
 	fi
 }
 
+if [[ -n ${ZSH_VERSION-} ]]; then
+	autoload -U +X compinit && compinit
+
+	__perfcomp ()
+	{
+		emulate -L zsh
+
+		local c IFS=$' \t\n'
+		local -a array
+
+		for c in ${=1}; do
+			case $c in
+			--*=*|*.) ;;
+			*) c="$c " ;;
+			esac
+			array[${#array[@]}+1]="$c"
+		done
+
+		compset -P '*[=:]'
+		compadd -Q -S '' -a -- array && _ret=0
+	}
+
+	__perfcomp_colon ()
+	{
+		emulate -L zsh
+
+		local cur_="${2-$cur}"
+		local c IFS=$' \t\n'
+		local -a array
+
+		if [[ "$cur_" == *:* ]]; then
+			local colon_word=${cur_%"${cur_##*:}"}
+		fi
+
+		for c in ${=1}; do
+			case $c in
+			--*=*|*.) ;;
+			*) c="$c " ;;
+			esac
+			array[$#array+1]=${c#"$colon_word"}
+		done
+
+		compset -P '*[=:]'
+		compadd -Q -S '' -a -- array && _ret=0
+	}
+
+	_perf ()
+	{
+		local _ret=1 cur cword prev
+		cur=${words[CURRENT]}
+		prev=${words[CURRENT-1]}
+		let cword=CURRENT-1
+		emulate ksh -c __perf_main
+		let _ret && _default && _ret=0
+		return _ret
+	}
+
+	compdef _perf perf
+	return
+fi
+
 type perf &>/dev/null &&
 _perf()
 {
-- 
1.8.5.rc0.6.gfd75b41

