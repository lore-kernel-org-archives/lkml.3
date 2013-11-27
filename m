Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab3K0UWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:22:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32773 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab3K0URB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:01 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/34] perf completion: Rename file to reflect zsh support
Date: Wed, 27 Nov 2013 17:16:08 -0300
Message-Id: <1385583394-3703-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1384704807-15779-6-git-send-email-artagnon@gmail.com
[ Fix 'make install' target ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf      |   4 +-
 tools/perf/bash_completion    | 202 ------------------------------------------
 tools/perf/perf-completion.sh | 202 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 204 insertions(+), 204 deletions(-)
 delete mode 100644 tools/perf/bash_completion
 create mode 100644 tools/perf/perf-completion.sh

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 7fc8f179cae7..e416ccc7d831 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -840,9 +840,9 @@ ifndef NO_LIBPYTHON
 		$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'; \
 		$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
 endif
-	$(call QUIET_INSTALL, bash_completion-script) \
+	$(call QUIET_INSTALL, perf_completion-script) \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'; \
-		$(INSTALL) bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
+		$(INSTALL) perf-completion.sh '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
 	$(call QUIET_INSTALL, tests) \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'; \
 		$(INSTALL) tests/attr.py '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'; \
diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
deleted file mode 100644
index 49494882d9bb..000000000000
--- a/tools/perf/bash_completion
+++ /dev/null
@@ -1,202 +0,0 @@
-# perf bash and zsh completion
-
-# Taken from git.git's completion script.
-__my_reassemble_comp_words_by_ref()
-{
-	local exclude i j first
-	# Which word separators to exclude?
-	exclude="${1//[^$COMP_WORDBREAKS]}"
-	cword_=$COMP_CWORD
-	if [ -z "$exclude" ]; then
-		words_=("${COMP_WORDS[@]}")
-		return
-	fi
-	# List of word completion separators has shrunk;
-	# re-assemble words to complete.
-	for ((i=0, j=0; i < ${#COMP_WORDS[@]}; i++, j++)); do
-		# Append each nonempty word consisting of just
-		# word separator characters to the current word.
-		first=t
-		while
-			[ $i -gt 0 ] &&
-			[ -n "${COMP_WORDS[$i]}" ] &&
-			# word consists of excluded word separators
-			[ "${COMP_WORDS[$i]//[^$exclude]}" = "${COMP_WORDS[$i]}" ]
-		do
-			# Attach to the previous token,
-			# unless the previous token is the command name.
-			if [ $j -ge 2 ] && [ -n "$first" ]; then
-				((j--))
-			fi
-			first=
-			words_[$j]=${words_[j]}${COMP_WORDS[i]}
-			if [ $i = $COMP_CWORD ]; then
-				cword_=$j
-			fi
-			if (($i < ${#COMP_WORDS[@]} - 1)); then
-				((i++))
-			else
-				# Done.
-				return
-			fi
-		done
-		words_[$j]=${words_[j]}${COMP_WORDS[i]}
-		if [ $i = $COMP_CWORD ]; then
-			cword_=$j
-		fi
-	done
-}
-
-type _get_comp_words_by_ref &>/dev/null ||
-_get_comp_words_by_ref()
-{
-	local exclude cur_ words_ cword_
-	if [ "$1" = "-n" ]; then
-		exclude=$2
-		shift 2
-	fi
-	__my_reassemble_comp_words_by_ref "$exclude"
-	cur_=${words_[cword_]}
-	while [ $# -gt 0 ]; do
-		case "$1" in
-		cur)
-			cur=$cur_
-			;;
-		prev)
-			prev=${words_[$cword_-1]}
-			;;
-		words)
-			words=("${words_[@]}")
-			;;
-		cword)
-			cword=$cword_
-			;;
-		esac
-		shift
-	done
-}
-
-type __ltrim_colon_completions &>/dev/null ||
-__ltrim_colon_completions()
-{
-	if [[ "$1" == *:* && "$COMP_WORDBREAKS" == *:* ]]; then
-		# Remove colon-word prefix from COMPREPLY items
-		local colon_word=${1%"${1##*:}"}
-		local i=${#COMPREPLY[*]}
-		while [[ $((--i)) -ge 0 ]]; do
-			COMPREPLY[$i]=${COMPREPLY[$i]#"$colon_word"}
-		done
-	fi
-}
-
-__perfcomp ()
-{
-	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
-}
-
-__perfcomp_colon ()
-{
-	__perfcomp "$1" "$2"
-	__ltrim_colon_completions $cur
-}
-
-__perf_main ()
-{
-	local cmd
-
-	cmd=${words[0]}
-	COMPREPLY=()
-
-	# List perf subcommands or long options
-	if [ $cword -eq 1 ]; then
-		if [[ $cur == --* ]]; then
-			__perfcomp '--help --version \
-			--exec-path --html-path --paginate --no-pager \
-			--perf-dir --work-tree --debugfs-dir' -- "$cur"
-		else
-			cmds=$($cmd --list-cmds)
-			__perfcomp "$cmds" "$cur"
-		fi
-	# List possible events for -e option
-	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
-		evts=$($cmd list --raw-dump)
-		__perfcomp_colon "$evts" "$cur"
-	# List long option names
-	elif [[ $cur == --* ]];  then
-		subcmd=${words[1]}
-		opts=$($cmd $subcmd --list-opts)
-		__perfcomp "$opts" "$cur"
-	fi
-}
-
-if [[ -n ${ZSH_VERSION-} ]]; then
-	autoload -U +X compinit && compinit
-
-	__perfcomp ()
-	{
-		emulate -L zsh
-
-		local c IFS=$' \t\n'
-		local -a array
-
-		for c in ${=1}; do
-			case $c in
-			--*=*|*.) ;;
-			*) c="$c " ;;
-			esac
-			array[${#array[@]}+1]="$c"
-		done
-
-		compset -P '*[=:]'
-		compadd -Q -S '' -a -- array && _ret=0
-	}
-
-	__perfcomp_colon ()
-	{
-		emulate -L zsh
-
-		local cur_="${2-$cur}"
-		local c IFS=$' \t\n'
-		local -a array
-
-		if [[ "$cur_" == *:* ]]; then
-			local colon_word=${cur_%"${cur_##*:}"}
-		fi
-
-		for c in ${=1}; do
-			case $c in
-			--*=*|*.) ;;
-			*) c="$c " ;;
-			esac
-			array[$#array+1]=${c#"$colon_word"}
-		done
-
-		compset -P '*[=:]'
-		compadd -Q -S '' -a -- array && _ret=0
-	}
-
-	_perf ()
-	{
-		local _ret=1 cur cword prev
-		cur=${words[CURRENT]}
-		prev=${words[CURRENT-1]}
-		let cword=CURRENT-1
-		emulate ksh -c __perf_main
-		let _ret && _default && _ret=0
-		return _ret
-	}
-
-	compdef _perf perf
-	return
-fi
-
-type perf &>/dev/null &&
-_perf()
-{
-	local cur words cword prev
-	_get_comp_words_by_ref -n =: cur words cword prev
-	__perf_main
-} &&
-
-complete -o bashdefault -o default -o nospace -F _perf perf 2>/dev/null \
-	|| complete -o default -o nospace -F _perf perf
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
new file mode 100644
index 000000000000..49494882d9bb
--- /dev/null
+++ b/tools/perf/perf-completion.sh
@@ -0,0 +1,202 @@
+# perf bash and zsh completion
+
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
+type __ltrim_colon_completions &>/dev/null ||
+__ltrim_colon_completions()
+{
+	if [[ "$1" == *:* && "$COMP_WORDBREAKS" == *:* ]]; then
+		# Remove colon-word prefix from COMPREPLY items
+		local colon_word=${1%"${1##*:}"}
+		local i=${#COMPREPLY[*]}
+		while [[ $((--i)) -ge 0 ]]; do
+			COMPREPLY[$i]=${COMPREPLY[$i]#"$colon_word"}
+		done
+	fi
+}
+
+__perfcomp ()
+{
+	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
+}
+
+__perfcomp_colon ()
+{
+	__perfcomp "$1" "$2"
+	__ltrim_colon_completions $cur
+}
+
+__perf_main ()
+{
+	local cmd
+
+	cmd=${words[0]}
+	COMPREPLY=()
+
+	# List perf subcommands or long options
+	if [ $cword -eq 1 ]; then
+		if [[ $cur == --* ]]; then
+			__perfcomp '--help --version \
+			--exec-path --html-path --paginate --no-pager \
+			--perf-dir --work-tree --debugfs-dir' -- "$cur"
+		else
+			cmds=$($cmd --list-cmds)
+			__perfcomp "$cmds" "$cur"
+		fi
+	# List possible events for -e option
+	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
+		evts=$($cmd list --raw-dump)
+		__perfcomp_colon "$evts" "$cur"
+	# List long option names
+	elif [[ $cur == --* ]];  then
+		subcmd=${words[1]}
+		opts=$($cmd $subcmd --list-opts)
+		__perfcomp "$opts" "$cur"
+	fi
+}
+
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
+type perf &>/dev/null &&
+_perf()
+{
+	local cur words cword prev
+	_get_comp_words_by_ref -n =: cur words cword prev
+	__perf_main
+} &&
+
+complete -o bashdefault -o default -o nospace -F _perf perf 2>/dev/null \
+	|| complete -o default -o nospace -F _perf perf
-- 
1.8.1.4

