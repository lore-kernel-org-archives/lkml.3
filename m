Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab3JNUka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:40:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38670 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575Ab3JNUC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 074/161] perf completion: Strip dependency on bash-completion
Date: Mon, 14 Oct 2013 17:01:03 -0300
Message-Id: <1381780950-25642-75-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

The bash-completion package defines the _get_comp_words_by_ref function.
There is no need to depend on it, as we can reimplement it like git.git
has.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Link: http://lkml.kernel.org/r/1372941691-14684-7-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion | 83 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 77 insertions(+), 6 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 35fdda1540d8..ee9c6d85f2c9 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -1,5 +1,81 @@
 # perf completion
 
+# Taken from git.git's completion script.
+__my_reassemble_comp_words_by_ref()
+{
+	local exclude i j first
+	# Which word separators to exclude?
+	exclude="${1//[^$COMP_WORDBREAKS]}"
+	cword_=$COMP_CWORD
+	if [ -z "$exclude" ]; then
+		words_=("${COMP_WORDS[@]}")
+		return
+	fi
+	# List of word completion separators has shrunk;
+	# re-assemble words to complete.
+	for ((i=0, j=0; i < ${#COMP_WORDS[@]}; i++, j++)); do
+		# Append each nonempty word consisting of just
+		# word separator characters to the current word.
+		first=t
+		while
+			[ $i -gt 0 ] &&
+			[ -n "${COMP_WORDS[$i]}" ] &&
+			# word consists of excluded word separators
+			[ "${COMP_WORDS[$i]//[^$exclude]}" = "${COMP_WORDS[$i]}" ]
+		do
+			# Attach to the previous token,
+			# unless the previous token is the command name.
+			if [ $j -ge 2 ] && [ -n "$first" ]; then
+				((j--))
+			fi
+			first=
+			words_[$j]=${words_[j]}${COMP_WORDS[i]}
+			if [ $i = $COMP_CWORD ]; then
+				cword_=$j
+			fi
+			if (($i < ${#COMP_WORDS[@]} - 1)); then
+				((i++))
+			else
+				# Done.
+				return
+			fi
+		done
+		words_[$j]=${words_[j]}${COMP_WORDS[i]}
+		if [ $i = $COMP_CWORD ]; then
+			cword_=$j
+		fi
+	done
+}
+
+type _get_comp_words_by_ref &>/dev/null ||
+_get_comp_words_by_ref()
+{
+	local exclude cur_ words_ cword_
+	if [ "$1" = "-n" ]; then
+		exclude=$2
+		shift 2
+	fi
+	__my_reassemble_comp_words_by_ref "$exclude"
+	cur_=${words_[cword_]}
+	while [ $# -gt 0 ]; do
+		case "$1" in
+		cur)
+			cur=$cur_
+			;;
+		prev)
+			prev=${words_[$cword_-1]}
+			;;
+		words)
+			words=("${words_[@]}")
+			;;
+		cword)
+			cword=$cword_
+			;;
+		esac
+		shift
+	done
+}
+
 type __ltrim_colon_completions &>/dev/null ||
 __ltrim_colon_completions()
 {
@@ -19,12 +95,7 @@ _perf()
 	local cur prev cmd
 
 	COMPREPLY=()
-	if function_exists _get_comp_words_by_ref; then
-		_get_comp_words_by_ref -n : cur prev
-	else
-		cur=$(_get_cword :)
-		prev=${COMP_WORDS[COMP_CWORD-1]}
-	fi
+	_get_comp_words_by_ref -n : cur prev
 
 	cmd=${COMP_WORDS[0]}
 
-- 
1.8.1.4

