Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab3JOFYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:24:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385Ab3JOFYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:24:18 -0400
Date: Mon, 14 Oct 2013 22:23:35 -0700
From: tip-bot for Ricardo Ribalda Delgado <tipbot@zytor.com>
Message-ID: <tip-9cd00941f8c274e6ca03ed238d96ddb0be474b86@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        Waiman.Long@hp.com, ricardo.ribalda@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        Waiman.Long@hp.com, dsahern@gmail.com, ricardo.ribalda@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1379512574-25912-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1379512574-25912-1-git-send-email-ricardo.ribalda@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Support for Openembedded/
 Yocto -dbg packages
Git-Commit-ID: 9cd00941f8c274e6ca03ed238d96ddb0be474b86
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:23:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9cd00941f8c274e6ca03ed238d96ddb0be474b86
Gitweb:     http://git.kernel.org/tip/9cd00941f8c274e6ca03ed238d96ddb0be474b86
Author:     Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
AuthorDate: Wed, 18 Sep 2013 15:56:14 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:12:41 -0300

perf symbols: Support for Openembedded/Yocto -dbg packages

On OpenEmbedded the symbol files are located under a .debug folder on
the same folder as the binary file.

This patch adds support for such files.

Without this patch on perf top you can see:

no symbols found in /usr/lib/gstreamer-1.0/libtheoraenc.so.1.1.2, maybe
install a debug package?

84.56%  libtheoraenc.so.1.1.2       [.] 0x000000000000b346

With this patch symbols are shown:

19.06%  libtheoraenc.so.1.1.2       [.] oc_int_frag_satd_thresh_mmxext
9.76%   libtheoraenc.so.1.1.2       [.] oc_analyze_mb_mode_luma
5.58%   libtheoraenc.so.1.1.2       [.] oc_qii_state_advance
4.84%   libtheoraenc.so.1.1.2       [.] oc_enc_tokenize_ac
...

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Link: http://lkml.kernel.org/r/1379512574-25912-1-git-send-email-ricardo.ribalda@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c    | 49 +++++++++++++++++++++++++++++++++++-------------
 tools/perf/util/dso.h    |  1 +
 tools/perf/util/symbol.c |  1 +
 3 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index e3c1ff8..6bfc8aa 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -7,19 +7,20 @@
 char dso__symtab_origin(const struct dso *dso)
 {
 	static const char origin[] = {
-		[DSO_BINARY_TYPE__KALLSYMS]		= 'k',
-		[DSO_BINARY_TYPE__VMLINUX]		= 'v',
-		[DSO_BINARY_TYPE__JAVA_JIT]		= 'j',
-		[DSO_BINARY_TYPE__DEBUGLINK]		= 'l',
-		[DSO_BINARY_TYPE__BUILD_ID_CACHE]	= 'B',
-		[DSO_BINARY_TYPE__FEDORA_DEBUGINFO]	= 'f',
-		[DSO_BINARY_TYPE__UBUNTU_DEBUGINFO]	= 'u',
-		[DSO_BINARY_TYPE__BUILDID_DEBUGINFO]	= 'b',
-		[DSO_BINARY_TYPE__SYSTEM_PATH_DSO]	= 'd',
-		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]	= 'K',
-		[DSO_BINARY_TYPE__GUEST_KALLSYMS]	= 'g',
-		[DSO_BINARY_TYPE__GUEST_KMODULE]	= 'G',
-		[DSO_BINARY_TYPE__GUEST_VMLINUX]	= 'V',
+		[DSO_BINARY_TYPE__KALLSYMS]			= 'k',
+		[DSO_BINARY_TYPE__VMLINUX]			= 'v',
+		[DSO_BINARY_TYPE__JAVA_JIT]			= 'j',
+		[DSO_BINARY_TYPE__DEBUGLINK]			= 'l',
+		[DSO_BINARY_TYPE__BUILD_ID_CACHE]		= 'B',
+		[DSO_BINARY_TYPE__FEDORA_DEBUGINFO]		= 'f',
+		[DSO_BINARY_TYPE__UBUNTU_DEBUGINFO]		= 'u',
+		[DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO]	= 'o',
+		[DSO_BINARY_TYPE__BUILDID_DEBUGINFO]		= 'b',
+		[DSO_BINARY_TYPE__SYSTEM_PATH_DSO]		= 'd',
+		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]		= 'K',
+		[DSO_BINARY_TYPE__GUEST_KALLSYMS]		= 'g',
+		[DSO_BINARY_TYPE__GUEST_KMODULE]		= 'G',
+		[DSO_BINARY_TYPE__GUEST_VMLINUX]		= 'V',
 	};
 
 	if (dso == NULL || dso->symtab_type == DSO_BINARY_TYPE__NOT_FOUND)
@@ -64,6 +65,28 @@ int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
 			 symbol_conf.symfs, dso->long_name);
 		break;
 
+	case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:
+	{
+		char *last_slash;
+		size_t len;
+		size_t dir_size;
+
+		last_slash = dso->long_name + dso->long_name_len;
+		while (last_slash != dso->long_name && *last_slash != '/')
+			last_slash--;
+
+		len = scnprintf(file, size, "%s", symbol_conf.symfs);
+		dir_size = last_slash - dso->long_name + 2;
+		if (dir_size > (size - len)) {
+			ret = -1;
+			break;
+		}
+		len += scnprintf(file + len, dir_size, "%s",  dso->long_name);
+		len += scnprintf(file + len , size - len, ".debug%s",
+								last_slash);
+		break;
+	}
+
 	case DSO_BINARY_TYPE__BUILDID_DEBUGINFO:
 		if (!dso->has_build_id) {
 			ret = -1;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index b793053..dbd9241 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -23,6 +23,7 @@ enum dso_binary_type {
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
 	DSO_BINARY_TYPE__KCORE,
 	DSO_BINARY_TYPE__GUEST_KCORE,
+	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7eb0362..cd1dcc4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -51,6 +51,7 @@ static enum dso_binary_type binary_type_symtab[] = {
 	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
 	DSO_BINARY_TYPE__GUEST_KMODULE,
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
+	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
