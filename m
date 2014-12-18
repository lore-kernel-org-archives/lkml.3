Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaLRGdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:33:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58802 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaLRGdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:33:37 -0500
Date: Wed, 17 Dec 2014 22:33:18 -0800
From: tip-bot for Mitchell Krome <tipbot@zytor.com>
Message-ID: <tip-7ad74b41e56e4f7f42c6b765bc44428cd09310d7@git.kernel.org>
Cc: mingo@redhat.com, tglx@linutronix.de, mitchellkrome@gmail.com,
        jolsa@redhat.com, paulus@samba.org, mingo@kernel.org, hpa@zytor.com,
        acme@redhat.com, linux-kernel@vger.kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl
Reply-To: jolsa@redhat.com, mitchellkrome@gmail.com, tglx@linutronix.de,
        mingo@redhat.com, a.p.zijlstra@chello.nl, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        paulus@samba.org, mingo@kernel.org
In-Reply-To: <20141216021612.GA7199@mitchell>
References: <20141216021612.GA7199@mitchell>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols:
  Fix use after free in filename__read_build_id
Git-Commit-ID: 7ad74b41e56e4f7f42c6b765bc44428cd09310d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ad74b41e56e4f7f42c6b765bc44428cd09310d7
Gitweb:     http://git.kernel.org/tip/7ad74b41e56e4f7f42c6b765bc44428cd09310d7
Author:     Mitchell Krome <mitchellkrome@gmail.com>
AuthorDate: Tue, 16 Dec 2014 12:16:12 +1000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Dec 2014 11:58:17 -0300

perf symbols: Fix use after free in filename__read_build_id

In filename__read_build_id, phdr points to memory in buf, which gets realloced
before a call to fseek that uses phdr->p_offset. This change stores the value
of p_offset before buf is realloced, so the fseek can use the value safely.

Signed-off-by: Mitchell Krome <mitchellkrome@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20141216021612.GA7199@mitchell
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-minimal.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index fa585c6..d7efb03 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -129,6 +129,7 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 
 		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
 			void *tmp;
+			long offset;
 
 			if (need_swap) {
 				phdr->p_type = bswap_32(phdr->p_type);
@@ -140,12 +141,13 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 				continue;
 
 			buf_size = phdr->p_filesz;
+			offset = phdr->p_offset;
 			tmp = realloc(buf, buf_size);
 			if (tmp == NULL)
 				goto out_free;
 
 			buf = tmp;
-			fseek(fp, phdr->p_offset, SEEK_SET);
+			fseek(fp, offset, SEEK_SET);
 			if (fread(buf, buf_size, 1, fp) != 1)
 				goto out_free;
 
@@ -178,6 +180,7 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 
 		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
 			void *tmp;
+			long offset;
 
 			if (need_swap) {
 				phdr->p_type = bswap_32(phdr->p_type);
@@ -189,12 +192,13 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 				continue;
 
 			buf_size = phdr->p_filesz;
+			offset = phdr->p_offset;
 			tmp = realloc(buf, buf_size);
 			if (tmp == NULL)
 				goto out_free;
 
 			buf = tmp;
-			fseek(fp, phdr->p_offset, SEEK_SET);
+			fseek(fp, offset, SEEK_SET);
 			if (fread(buf, buf_size, 1, fp) != 1)
 				goto out_free;
 
