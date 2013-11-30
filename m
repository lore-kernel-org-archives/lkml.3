Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3K3MuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:50:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59529 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab3K3MuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:50:19 -0500
Date: Sat, 30 Nov 2013 04:50:06 -0800
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-f38ab8af794c184c15f5e001d0eaa16f4a120978@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, fweisbec@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1384704807-15779-5-git-send-email-artagnon@gmail.com>
References: <1384704807-15779-5-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf completion: Introduce zsh support
Git-Commit-ID: f38ab8af794c184c15f5e001d0eaa16f4a120978
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:50:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f38ab8af794c184c15f5e001d0eaa16f4a120978
Gitweb:     http://git.kernel.org/tip/f38ab8af794c184c15f5e001d0eaa16f4a120978
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Sun, 17 Nov 2013 21:43:26 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:35 -0300

perf completion: Introduce zsh support

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
