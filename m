Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab3K0UWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:22:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60973 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab3K0URA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:00 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/34] perf completion: Introduce zsh support
Date: Wed, 27 Nov 2013 17:16:07 -0300
Message-Id: <1385583394-3703-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

__perfcomp(), __perfcomp_colon(), and _perf() have to be overridden.
Inspired by the way the git.git completion system is structured.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1384704807-15779-5-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion | 63 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 573599b42be2..49494882d9bb 100644
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
1.8.1.4

